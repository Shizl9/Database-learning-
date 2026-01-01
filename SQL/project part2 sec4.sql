-- Database Project Part 2: Advanced Queries, Views, and Stored Procedures
-- Course: Database Management Systems
-- Prerequisites: Completion of Database Project Part 1
-- Topics Covered: Joins, Aggregation Functions, Grouping, Views, Stored Procedures
-- 
-- Assumptions:
-- - Database schema from Part 1 includes tables: Libraries, Books, Members, Staff, Loans, Payments, Reviews.
-- - Key columns: Libraries(id, name), Books(id, title, isbn, genre, price, available, library_id), 
--   Members(id, name, email, phone, library_id), Staff(id, name, position, library_id), 
--   Loans(id, member_id, book_id, loan_date, due_date, return_date, status), 
--   Payments(id, loan_id, amount, method, status, date), Reviews(id, member_id, book_id, rating, review_text, date).
-- - Status values for Loans: 'Issued', 'Overdue', 'Returned'.
-- - Available in Books: 1 for available, 0 for not.
-- - Fine calculation: $2 per day overdue.
-- - Dates use SQL DATE functions (e.g., CURDATE(), DATEDIFF).
-- - Members are associated with libraries via library_id.
-- - Sufficient test data exists (at least 3 libraries, 20 books, 10 members, 15 loans).
-- - All queries/views/procedures are adapted to the assumed schema.

-- Section 1: Complex Queries with Joins (40 points)

-- 1. Library Book Inventory Report
-- Displays library name, total number of books, number of available books, and number of books currently on loan for each library.
SELECT l.library_name,
       COUNT(b.book_id) AS total_books,
       SUM(CASE WHEN b.availability_status = 1 THEN 1 ELSE 0 END) AS available_books,
       COUNT(CASE WHEN ln.status IN ('Issued', 'Overdue') THEN 1 END) AS books_on_loan
FROM library l
LEFT JOIN Books b ON l.library_id = b.library_id
LEFT JOIN loans ln ON b.book_id = ln.book_id AND ln.status IN ('Issued', 'Overdue')
GROUP BY l.library_id, l.library_name;

-- 2. Active Borrowers Analysis
-- Lists all members who currently have books on loan (status = 'Issued' or 'Overdue'). Shows member name, email, book title, loan date, due date, and current status.
SELECT m.full_name, m.email, b.title, ln.loan_date, ln.due_date, ln.status
FROM members m
JOIN loans ln ON m.member_id = ln.member_id
JOIN Books b ON ln.book_id = b.book_id
WHERE ln.status IN ('Issued', 'Overdue');

-- 3. Overdue Loans with Member Details
-- Retrieves all overdue loans showing member name, phone number, book title, library name, days overdue (calculated as difference between current date and due date), and any fines paid for that loan.
SELECT m.full_name, m.phone, b.title, l.library_name,
       DATEDIFF(DAY, ln.due_date, GETDATE()) AS days_overdue,
       COALESCE(p.amount, 0) AS fines_paid
FROM loans ln
JOIN members m ON ln.member_id = m.member_id
JOIN Books b ON ln.book_id = b.book_id
JOIN library l ON b.library_id = l.library_id
LEFT JOIN payment p ON ln.loan_id = p.loan_id
WHERE ln.status = 'Overdue' AND ln.due_date < GETDATE();

-- 4. Staff Performance Overview
-- For each library, shows the library name, staff member names, their positions, and count of books managed at that library.
SELECT 
    l.library_name,s.full_name AS staff_name,s.position,
    COUNT(b.book_id) AS books_managed
FROM library l
JOIN Staff s ON l.library_id = s.library_id
LEFT JOIN Books b ON l.library_id = b.library_id
GROUP BY l.library_id, l.library_name, s.staff_id, s.full_name, s.position
ORDER BY l.library_name, s.full_name;


-- 5. Book Popularity Report
-- Displays books that have been loaned at least 3 times. Includes book title, ISBN, genre, total number of times loaned, and average review rating (if any reviews exist).
-- Approach: Use JOINs to link books to loans and reviews, GROUP BY book details, and HAVING to filter books loaned >=3 times. Aggregate rating with AVG.
SELECT 
    b.title,
    b.ISBN,
    b.genre,
    COUNT(ln.loan_id) AS times_loaned,
    AVG(r.rating) AS avg_rating
FROM Books b
JOIN loans ln ON b.book_id = ln.book_id
LEFT JOIN review r ON b.book_id = r.book_id
GROUP BY b.book_id, b.title, b.ISBN, b.genre
HAVING COUNT(ln.loan_id) >= 3;

-- 6. Member Reading History
-- Shows each member's complete borrowing history including: member name, book titles borrowed (including currently borrowed and previously returned), loan dates, return dates, and any reviews they left for those books.
-- Approach: JOIN members to loans to books, and LEFT JOIN to reviews. This covers all loans (past and present) with associated reviews.
SELECT m.full_name, b.title, ln.loan_date, ln.return_date, r.comments
FROM members m
JOIN loans ln ON m.member_id = ln.member_id
JOIN Books b ON ln.book_id = b.book_id
LEFT JOIN review r ON m.member_id = r.member_id AND b.book_id = r.book_id;

-- 7. Revenue Analysis by Genre
-- Calculates total fine payments collected for each book genre. Shows genre name, total number of loans for that genre, total fine amount collected, and average fine per loan.
-- Approach: JOIN books to loans to payments, GROUP BY genre, and use aggregation for counts and sums.
SELECT b.genre, COUNT(ln.loan_id) AS total_loans,
       SUM(COALESCE(p.amount, 0)) AS total_fines,
       AVG(COALESCE(p.amount, 0)) AS avg_fine_per_loan
FROM Books b
JOIN loans ln ON b.book_id = ln.book_id
LEFT JOIN payment p ON ln.loan_id = p.loan_id
GROUP BY b.genre;


-- Section 2: Aggregate Functions and Grouping (30 points)

-- 8. Monthly Loan Statistics
-- Generates a report showing the number of loans issued per month for the current year. Includes month name, total loans, total returned, and total still issued/overdue.
SELECT DATENAME(MONTH, ln.loan_date) AS month_name,
       COUNT(*) AS total_loans,
       SUM(CASE WHEN ln.status = 'Returned' THEN 1 ELSE 0 END) AS total_returned,
       SUM(CASE WHEN ln.status IN ('Issued','Overdue') THEN 1 ELSE 0 END) AS still_issued
FROM loans ln
WHERE YEAR(ln.loan_date) = YEAR(GETDATE())
GROUP BY MONTH(ln.loan_date), DATENAME(MONTH, ln.loan_date)
ORDER BY MONTH(ln.loan_date);

-- 9. Member Engagement Metrics
-- For each member, calculates: total books borrowed, total books currently on loan, total fines paid, and average rating they give in reviews. Only includes members who have borrowed at least one book.
SELECT m.full_name,
       COUNT(ln.loan_id) AS total_borrowed,
       SUM(CASE WHEN ln.status IN ('Issued','Overdue') THEN 1 ELSE 0 END) AS currently_on_loan,
       SUM(COALESCE(p.amount,0)) AS total_fines,
       AVG(r.rating) AS avg_rating
FROM members m
JOIN loans ln ON m.member_id = ln.member_id
LEFT JOIN payment p ON ln.loan_id = p.loan_id
LEFT JOIN review r ON m.member_id = r.member_id
GROUP BY m.member_id, m.full_name
HAVING COUNT(ln.loan_id) >= 1;

-- 10. Library Performance Comparison
-- Compares libraries by showing: library name, total books owned, total active members (members with at least one loan), total revenue from fines, and average books per member.
ALTER TABLE members
ADD library_id INT NULL,

SELECT l.library_name,
       COUNT(b.book_id) AS total_books,
       COUNT(DISTINCT CASE WHEN ln.loan_id IS NOT NULL THEN m.member_id END) AS active_members,
       SUM(ISNULL(p.amount, 0)) AS total_revenue,
       COUNT(b.book_id) / NULLIF(COUNT(DISTINCT m.member_id),0) AS avg_books_per_member
FROM library l
LEFT JOIN Books b ON l.library_id = b.library_id
LEFT JOIN loans ln ON b.book_id = ln.book_id
LEFT JOIN members m ON ln.member_id = m.member_id
LEFT JOIN payment p ON ln.loan_id = p.loan_id
GROUP BY l.library_name;


-- 11. High-Value Books Analysis
-- Identifies books priced above the average book price in their genre. Shows book title, genre, price, genre average price, and difference from average.
SELECT b.title, b.genre, b.price,
       AVG(b2.price*1.0) AS genre_avg_price,
       b.price - AVG(b2.price*1.0) AS difference
FROM Books b
JOIN Books b2 ON b.genre = b2.genre
GROUP BY b.book_id, b.title, b.genre, b.price
HAVING b.price > AVG(b2.price);

-- 12. Payment Pattern Analysis
-- Groups payments by payment method and shows: payment method, number of transactions, total amount collected, average payment amount, and percentage of total revenue.
SELECT p.method,
       COUNT(*) AS num_transactions,
       SUM(p.amount) AS total_amount,
       AVG(p.amount) AS avg_amount,
       (SUM(p.amount) * 100.0 / (SELECT SUM(amount) FROM payment)) AS percentage
FROM payment p
GROUP BY p.method;


-- Section 3: Views Creation (15 points)

-- 13. vw_CurrentLoans
-- A view that shows all currently active loans (status 'Issued' or 'Overdue') with member details, book details, loan information, and calculated days until due (or days overdue).
CREATE VIEW vw_CurrentLoans AS
SELECT m.full_name, m.email, b.title, ln.loan_date, ln.due_date,
       CASE WHEN ln.due_date < CAST(GETDATE() AS DATE) THEN DATEDIFF(DAY, ln.due_date, CAST(GETDATE() AS DATE))
            ELSE DATEDIFF(DAY, CAST(GETDATE() AS DATE), ln.due_date) END AS days
FROM loans ln
JOIN members m ON ln.member_id = m.member_id
JOIN Books b ON ln.book_id = b.book_id
WHERE ln.status IN ('Issued','Overdue');

-- 14. vw_LibraryStatistics
-- A comprehensive view showing library-level statistics including total books, available books, total members, active loans, total staff, and total revenue from fines.
CREATE VIEW vw_LibraryStatistics AS
SELECT l.library_name,
       COUNT(b.book_id) AS total_books,
       SUM(CASE WHEN b.availability_status = 1 THEN 1 ELSE 0 END) AS available_books,
       COUNT(DISTINCT m.member_id) AS total_members,
       COUNT(CASE WHEN ln.status IN ('Issued', 'Overdue') THEN 1 END) AS active_loans,
       COUNT(s.staff_id) AS total_staff,
       SUM(COALESCE(p.amount, 0)) AS total_revenue
FROM library  l
LEFT JOIN Books b ON l.library_id  = b.library_id
LEFT JOIN Members m ON l.library_id  = m.library_id
LEFT JOIN Loans ln ON b.book_id   = ln.book_id
LEFT JOIN Staff s ON l.library_id  = s.library_id
LEFT JOIN Payment p ON ln.loan_id  = p.loan_id
GROUP BY l.library_id, l.library_name;


-- 15. vw_BookDetailsWithReviews
-- A view combining book information with aggregated review data (average rating, total reviews, latest review date) and current availability status.
CREATE VIEW vw_BookDetailsWithReviews AS
SELECT b.book_id, b.title, b.genre, b.ISBN, b.price, b.shelf_location, b.availability_status,
       AVG(r.rating*1.0) AS avg_rating,
       COUNT(r.review_id) AS total_reviews,
       MAX(r.review_date) AS latest_review
FROM Books b
LEFT JOIN review r ON b.book_id = r.book_id
GROUP BY b.book_id, b.title, b.genre, b.ISBN, b.price, b.shelf_location, b.availability_status;

-- Section 4: Stored Procedures (15 points)

-- 16. sp_IssueBook
-- Input Parameters: MemberID, BookID, DueDate
-- Functionality: Check if book is available, check if member has any overdue loans, if validations pass, create a new loan record and update book availability, return appropriate success or error message.

CREATE PROCEDURE sp_IssueBook 
    @member_id INT, 
    @book_id INT,
    @due_date DATE
AS
BEGIN
    DECLARE @available BIT;
    DECLARE @overdue_count INT;

    -- Ã·» Õ«·…  Ê›— «·ﬂ «»
    SELECT @available = availability_status
    FROM Book
    WHERE book_id = @book_id;

    -- Õ”«» ⁄œœ «·ﬁ—Ê÷ «·„ √Œ—… ··⁄÷Ê
    SELECT @overdue_count = COUNT(*)
    FROM loans
    WHERE member_id = @member_id
      AND status = 'Overdue';

    -- «· Õﬁﬁ Ê≈’œ«— «·ﬂ «»
    IF @available = 1 AND @overdue_count = 0
    BEGIN
        INSERT INTO loans (member_id, book_id, loan_date, due_date, status)
        VALUES (@member_id, @book_id, CAST(GETDATE() AS DATE), @due_date, 'Issued');

        UPDATE Book
        SET availability_status = 0
        WHERE book_id = @book_id;

        SELECT 'Book issued successfully' AS message;
    END
    ELSE
    BEGIN
        SELECT 'Book not available or member has overdue loans' AS message;
    END
END;
-- ≈’œ«— ﬂ «» ··⁄÷Ê 1 Ê«·ﬂ «» 1° » «—ÌŒ «” Õﬁ«ﬁ 2023-12-31
EXEC sp_IssueBook @member_id = 1, @book_id = 1, @due_date = '2025-12-31';



-- 17. sp_ReturnBook
-- Input Parameters: LoanID, ReturnDate
-- Functionality: Update loan status to 'Returned' and set return date, update book availability to TRUE, calculate if there's a fine ($2 per day overdue), if fine exists, automatically create a payment record with 'Pending' status, return total fine amount (if any).
CREATE PROCEDURE sp_ReturnBook
    @loan_id INT,
    @return_date DATE
AS
BEGIN
    DECLARE @due_date DATE;
    DECLARE @book_id INT;
    DECLARE @fine DECIMAL(8,2);

    -- Ã·»  «—ÌŒ «·«” Õﬁ«ﬁ Ê—ﬁ„ «·ﬂ «»
    SELECT 
        @due_date = due_date,
        @book_id = book_id
    FROM dbo.loans
    WHERE loan_id = @loan_id;

    -- Õ”«» «·€—«„…
    IF @return_date > @due_date
        SET @fine = DATEDIFF(DAY, @due_date, @return_date) * 2;
    ELSE
        SET @fine = 0;

    --  ÕœÌÀ «·ﬁ—÷
    UPDATE dbo.loans
    SET status = 'Returned',
        return_date = @return_date
    WHERE loan_id = @loan_id;

    --  ÕœÌÀ  Ê›— «·ﬂ «»
    UPDATE dbo.Books
    SET availability_status = 1
    WHERE book_id = @book_id;

    -- ≈œŒ«· «·€—«„… ≈–« ÊıÃœ 
    IF @fine > 0
    BEGIN
        INSERT INTO dbo.payment (loan_id, payment_date, amount, method)
        VALUES (@loan_id, CAST(GETDATE() AS DATE), @fine, 'Cash');
    END

    -- ≈—Ã«⁄ ﬁÌ„… «·€—«„…
    SELECT @fine AS total_fine;
END;
EXEC sp_ReturnBook 
    @loan_id = 1,
    @return_date = '2023-04-20';

-- 18. sp_GetMemberReport
-- Input Parameters: MemberID
-- Output: Multiple result sets showing: Member basic information, Current loans (if any), Loan history with return status, Total fines paid and any pending fines, Reviews written by the member.
CREATE PROCEDURE sp_GetMemberReport
    @member_id INT
AS
BEGIN
    -- 1. „⁄·Ê„«  «·⁄÷Ê
    SELECT * 
    FROM dbo.members
    WHERE member_id = @member_id;

    -- 2. «·ﬁ—Ê÷ «·Õ«·Ì…
    SELECT l.loan_id, l.book_id, b.title, l.loan_date, l.due_date, l.status
    FROM dbo.loans l
    JOIN dbo.Books b ON l.book_id = b.book_id
    WHERE l.member_id = @member_id
      AND l.status IN ('Issued','Overdue');

    -- 3. ﬂ· «·ﬁ—Ê÷ «·”«»ﬁ…
    SELECT l.loan_id, l.book_id, b.title, l.loan_date, l.due_date, l.return_date, l.status
    FROM dbo.loans l
    JOIN dbo.Books b ON l.book_id = b.book_id
    WHERE l.member_id = @member_id;

    -- 4. „Ã„Ê⁄ «·€—«„«  «·„œ›Ê⁄… (·«  ÊÃœ pending)
    SELECT 
        SUM(COALESCE(amount, 0)) AS total_fines_paid
    FROM dbo.payment
    WHERE loan_id IN (
        SELECT loan_id
        FROM dbo.loans
        WHERE member_id = @member_id
    );

    -- 5. «·„—«Ã⁄«  «· Ì ﬂ »Â« «·⁄÷Ê
    SELECT r.review_id, r.book_id, b.title, r.rating, r.comments, r.review_date
    FROM dbo.review r
    JOIN dbo.Books b ON r.book_id = b.book_id
    WHERE r.member_id = @member_id;
END;

EXEC sp_GetMemberReport @member_id = 1;


-- 19. sp_MonthlyLibraryReport
-- Input Parameters: LibraryID, Month, Year
-- Output: Comprehensive report showing: Total loans issued in that month, Total books returned in that month, Total revenue collected, Most borrowed genre, Top 3 most active members (by number of loans).
CREATE PROCEDURE sp_MonthlyLibraryReport
    @library_id INT,
    @month INT,
    @year INT
AS
BEGIN
    -- 1. ≈Ã„«·Ì «·ﬁ—Ê÷ ›Ì «·‘Â—
    SELECT COUNT(*) AS total_loans
    FROM dbo.loans l
    JOIN dbo.Books b ON l.book_id = b.book_id
    WHERE b.library_id = @library_id
      AND MONTH(l.loan_date) = @month
      AND YEAR(l.loan_date) = @year;

    -- 2. ≈Ã„«·Ì «·ﬂ » «·„⁄«œ… ›Ì «·‘Â—
    SELECT COUNT(*) AS total_returned
    FROM dbo.loans l
    JOIN dbo.Books b ON l.book_id = b.book_id
    WHERE b.library_id = @library_id
      AND MONTH(l.return_date) = @month
      AND YEAR(l.return_date) = @year
      AND l.status = 'Returned';

    -- 3. ≈Ã„«·Ì «·⁄«∆œ«  ›Ì «·‘Â—
    SELECT SUM(COALESCE(p.amount,0)) AS total_revenue
    FROM dbo.payment p
    JOIN dbo.loans l ON p.loan_id = l.loan_id
    JOIN dbo.Books b ON l.book_id = b.book_id
    WHERE b.library_id = @library_id
      AND MONTH(p.payment_date) = @month
      AND YEAR(p.payment_date) = @year;

    -- 4. √ﬂÀ— ‰Ê⁄ ﬂ » «” ⁄Ì—«
    SELECT TOP 1 b.genre, COUNT(*) AS count
    FROM dbo.loans l
    JOIN dbo.Books b ON l.book_id = b.book_id
    WHERE b.library_id = @library_id
      AND MONTH(l.loan_date) = @month
      AND YEAR(l.loan_date) = @year
    GROUP BY b.genre
    ORDER BY count DESC;

    -- 5. √⁄·Ï 3 √⁄÷«¡ ‰‘«ÿ«
    SELECT TOP 3 m.member_id, m.full_name, COUNT(*) AS loans
    FROM dbo.loans l
    JOIN dbo.Books b ON l.book_id = b.book_id
    JOIN dbo.members m ON l.member_id = m.member_id
    WHERE b.library_id = @library_id
      AND MONTH(l.loan_date) = @month
      AND YEAR(l.loan_date) = @year
    GROUP BY m.member_id, m.full_name
    ORDER BY loans DESC;
END;

--  ﬁ—Ì— ‘Â—Ì ·„ﬂ »… 1 ·‘Â— 12 ”‰… 2025
EXEC sp_MonthlyLibraryReport @library_id = 1, @month = 12, @year = 2025;

-- Test Data Inserts (for demonstration purposes)
-- Insert sample data to test procedures (assuming tables are created from Part 1).
-- Example inserts (adjust IDs as needed):
-- INSERT INTO Libraries (name) VALUES ('Central Library'), ('Branch Library');
-- INSERT INTO Books (title, isbn, genre, price, available, library_id) VALUES ('Book1', '123', 'Fiction', 10.00, 1, 1), ('Book2', '456', 'Non-Fiction', 15.00, 1, 1);
-- INSERT INTO Members (name, email, phone, library_id) VALUES ('John Doe', 'john@example.com', '1234567890', 1);
-- INSERT INTO Loans (member_id, book_id, loan_date, due_date, status) VALUES (1, 1, '2023-10-01', '2023-10-15', 'Issued');
-- INSERT INTO Payments (loan_id, amount, method, status, date) VALUES (1, 5.00, 'Cash', 'Paid', '2023-10-16');

-- Test Cases for Stored Procedures:
-- For sp_IssueBook: CALL sp_IssueBook(1, 2, '2023-11-01'); -- Success if book available and no overdues.
-- For sp_IssueBook: CALL sp_IssueBook(1, 1, '2023-11-01'); -- Error if book not available.
-- For sp_ReturnBook: CALL sp_ReturnBook(1, '2023-10-20'); -- Success with fine calculation.
-- For sp_ReturnBook: CALL sp_ReturnBook(1, '2023-10-10'); -- Success with no fine.
-- For sp_GetMemberReport: CALL sp_GetMemberReport(1); -- Outputs multiple result sets.
-- For sp_MonthlyLibraryReport: CALL sp_MonthlyLibraryReport(1, 10, 2023); -- Outputs report data.
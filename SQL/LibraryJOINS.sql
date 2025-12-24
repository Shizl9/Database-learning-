--Library Database – JOIN Queries--
--1. Display library ID, name, and the name of the manager.--
SELECT 
    l.library_id,
    l.library_name,
    s.full_name AS Manager_Name
FROM library l
JOIN Staff s
    ON l.library_id = s.library_id
WHERE s.position = 'Head Librarian';

--2. Display library names and the books available in each one.--
SELECT 
    l.library_name,
    b.title AS Book_Title
FROM library l
JOIN Books b
    ON l.library_id = b.library_id;

--3. Display all member data along with their loan history.--
SELECT 
    m.member_id,
    m.full_name,
    m.email,
    m.phone,
    m.membership_start_date,
    lo.loan_id,
    lo.loan_date,
    lo.due_date
FROM members m
LEFT JOIN loans lo
    ON m.member_id = lo.member_id;

--4. Display all books located in 'Muscat' or 'Sohar'.--
SELECT 
    b.book_id,
    b.title,
    b.genre,
    b.price,
    b.shelf_location,
    l.library_name,
    l.location
FROM Books b
JOIN library l
    ON b.library_id = l.library_id
WHERE l.location IN ('Muscat', 'Salalah');

--5. Display all books whose titles start with 'T'.--
SELECT *
FROM Books
WHERE title LIKE 'T%';

--6. List members who borrowed books priced between 100 and 300 LE.--
SELECT DISTINCT
    m.member_id,
    m.full_name,
    m.email,
    m.phone
FROM loans lo
JOIN members m
    ON lo.member_id = m.member_id
JOIN Books b
    ON lo.book_id = b.book_id
WHERE b.price BETWEEN 100 AND 300;

--7. Retrieve members who borrowed and returned books titled 'The Alchemist'.--
SELECT DISTINCT
    m.member_id,
    m.full_name,
    m.email,
    m.phone
FROM members m
JOIN loans lo
    ON m.member_id = lo.member_id
JOIN Books b
    ON lo.book_id = b.book_id
WHERE b.title = 'Oman History Vol 2';



--8. Find all members assisted by librarian "Huda Al-Balushi".--
SELECT DISTINCT
    m.member_id,
    m.full_name,
    m.email
FROM Staff s
JOIN library l
    ON s.library_id = l.library_id
JOIN Books b
    ON l.library_id = b.library_id
JOIN loans lo
    ON b.book_id = lo.book_id
JOIN members m
    ON lo.member_id = m.member_id
WHERE s.full_name = 'Saeed Al-Rashdi';

--9. Display each member’s name and the books they borrowed, ordered by book title.--
SELECT 
    m.full_name AS Member_Name,
    b.title AS Book_Title
FROM members m
JOIN loans lo
    ON m.member_id = lo.member_id
JOIN Books b
    ON lo.book_id = b.book_id
ORDER BY b.title;

--10. For each book located in 'Cairo Branch', show title, library name, manager, and shelf info.--
SELECT
    b.title,
    l.library_name,
    s.full_name AS Librarian_Name,
    b.shelf_location
FROM Books b
JOIN library l
    ON b.library_id = l.library_id
JOIN Staff s
    ON l.library_id = s.library_id
WHERE l.location = 'Muscat';

--11. Display all staff members who manage libraries.--
SELECT
    full_name,
    position,
    contact_number,
    library_id
FROM Staff
WHERE position LIKE '%Librarian%';

--12. Display all members and their reviews, even if some didn’t submit any review yet.--
SELECT
    m.member_id,
    m.full_name,
    m.email,
    r.review_id,
    r.rating,
    r.comments,
    r.review_date
FROM members m
LEFT JOIN review r
    ON m.member_id = r.member_id;
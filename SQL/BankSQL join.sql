--Bank Database – JOIN Queries--

--1. Display branch ID, name, and the name of the employee who Account Officer it.--
SELECT * FROM Branch;
SELECT * FROM Employee;

SELECT 
    b.branch_id,
    b.address AS BranchName,
    e.name AS EmployeeName,
    e.position
FROM Branch b
JOIN Employee e
    ON b.branch_id = e.branch_id
WHERE e.position = 'Bank Officer';

--2. Display branch names and the accounts opened under each.--
SELECT 
    b.address AS branch_name,
    a.account_no
FROM Branch b
JOIN Employee e
    ON b.branch_id = e.branch_id
JOIN EmployeeCustomerAction ec
    ON e.employee_id = ec.employee_id
JOIN Account a
    ON ec.customer_id = a.customer_id
WHERE ec.action_type = 'Open Account';

--3. Display full customer details along with their loans.--
SELECT *
FROM Customer c
JOIN Loan l
    ON c.customer_id = l.customer_id;

--4. Display loan records where the loan office is in 'Alexandria' or 'Giza'.--
SELECT 
    l.*,
    e.name AS employee_name,
    b.address AS branch_name
FROM Loan l
JOIN Employee e
    ON l.employee_id = e.employee_id
JOIN Branch b
    ON e.branch_id = b.branch_id
WHERE b.address IN ('Muscat Main Branch', 'Salalah Branch');

--5. Display account data where the type starts with "S" (e.g., "Savings").--
SELECT *
FROM Account
WHERE account_type LIKE 'S%';

--6. List customers with accounts having balances between 5000.00 AND 12000.--
SELECT * FROM Account;
SELECT * FROM Customer;

SELECT c.*
FROM Customer c
JOIN Account a
    ON c.customer_id = a.customer_id
WHERE a.balance BETWEEN 5000 AND 12000;

--7. Retrieve customer names who borrowed more than 1000,00 LE from 'Cairo Main Branch'.--
SELECT * FROM Customer;
SELECT * FROM Employee;
SELECT * FROM Loan;

SELECT 
    c.name AS CustomerName,
    l.amount
FROM Loan l
JOIN Customer c
    ON l.customer_id = c.customer_id
JOIN Employee e
    ON l.employee_id = e.employee_id
JOIN Branch b
    ON e.branch_id = b.branch_id
WHERE l.amount > 1000
  AND b.address = 'Muscat Main Branch';

--8. Find all customers assisted by employee "Khalid Al-Sinani".--
SELECT 
    c.name AS CustomerName,
    e.name AS EmployeeName
FROM EmployeeCustomerAction ec
JOIN Employee e
    ON ec.employee_id = e.employee_id
JOIN Customer c
    ON ec.customer_id = c.customer_id
WHERE e.name = 'Saeed Al Balushi';


--9. Display each customer’s name and the accounts they hold, sorted by account type.--
SELECT 
    c.name AS CustomerName,
    a.account_no AS AccountNumber,
    a.account_type AS AccountType
FROM Customer c
JOIN Account a
    ON c.customer_id = a.customer_id
ORDER BY a.account_type;

--10. For each loan issued in 'Muscat – Al Khuwair', show loan ID, customer name, employee handling it, and branch name.--
SELECT 
    l.loan_id,
    c.name AS CustomerName,
    e.name AS EmployeeName,
    b.address AS BranchAddress
FROM Loan l
JOIN Customer c
    ON l.customer_id = c.customer_id
JOIN Employee e
    ON l.employee_id = e.employee_id
JOIN Branch b
    ON e.branch_id = b.branch_id
WHERE b.address = 'Salalah Branch';

--11. Display all employees who manage any branch.--
SELECT 
    e.employee_id,
    e.name AS EmployeeName,
    e.position,
    b.address AS BranchAddress
FROM Employee e
JOIN Branch b
    ON e.branch_id = b.branch_id
WHERE e.position LIKE '%Manager%';


--12. Display all customers and their transactions, even if some customers have no transactions yet.--
SELECT 
    c.customer_id,
    c.name AS CustomerName,
    t.transaction_id,
    t.transaction_date,
    t.amount,
    t.transaction_type
FROM Customer c
LEFT JOIN Account a
    ON c.customer_id = a.customer_id
LEFT JOIN BankTransaction t
    ON a.account_no = t.account_no
ORDER BY c.customer_id, t.transaction_date;

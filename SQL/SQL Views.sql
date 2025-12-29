create database BankingDB
use BankingDB
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(15),
    SSN CHAR(9)
);

CREATE TABLE Account (
    AccountID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
    Balance DECIMAL(10,2),
    AccountType VARCHAR(50),
    Status VARCHAR(20)
);

CREATE TABLE [Transaction] (
    TransactionID INT PRIMARY KEY,
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID),
    Amount DECIMAL(10,2),
    Type VARCHAR(10),
    TransactionDate DATETIME
);

CREATE TABLE Loan (
    LoanID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
    LoanAmount DECIMAL(12,2),
    LoanType VARCHAR(50),
    Status VARCHAR(20)
);
INSERT INTO Customer VALUES
(1,'Ali Ahmed','ali@email.com','91234567','123456789'),
(2,'Sara Said','sara@email.com','92345678','987654321');

SELECT * FROM Customer;

INSERT INTO Account VALUES
(101,1,5000,'Saving','Active'),
(102,2,8000,'Current','Active');
SELECT * FROM Account;

INSERT INTO [Transaction] VALUES
(1,101,500,'Deposit',GETDATE()),
(2,101,200,'Withdraw',DATEADD(DAY,-10,GETDATE()));
SELECT * FROM [Transaction];

INSERT INTO Loan VALUES
(1,1,20000,'Car Loan','Approved');
SELECT * FROM Loan;

--Part 1: Research & Documentation

--1: What are the types of Views in SQL Server?
--1. Standard View
--A Standard View is a virtual table created using a SELECT statement. It does not store data physically; it only stores the query.
--Real-life use case:
--In a banking system, it is used to show customer information without exposing sensitive data.
--2. Indexed View
--An Indexed View stores the result set physically by creating a unique clustered index on the view. This improves performance for complex queries.
--Real-life use case:
--Used in banking reports that calculate totals or summaries frequently.
--Limitations:
--Requires SCHEMABINDING, uses extra storage, and may slow down DML operations.
--3. Partitioned View (Union View)
--A Partitioned View combines data from multiple tables using UNION ALL.
--Real-life use case:
--Bank transactions stored in different tables by year.

--2: Can we use DML operations (INSERT, UPDATE, DELETE) on Views
--Yes, DML operations can be performed on Standard Views with restrictions:
--The view must be based on a single table
--No JOIN, GROUP BY, DISTINCT, or aggregate functions
--No calculated columns
--Real-life example:
--Updating employee phone numbers through a view in an HR system.

--Part 2: How Views Simplify Complex Queries
--3: How can Views simplify JOIN-heavy queries?
--Views hide complex JOIN logic, reduce repeated SQL code, improve readability, and enhance security.
--Banking example:
--Call center agents can use a view to quickly access customer account summaries.
--4: Create a View that joins banking tables??
CREATE VIEW vw_CustomerAccountSummary AS
SELECT c.CustomerID, c.FullName, a.AccountID, a.Balance, a.Status
FROM Customer c
JOIN Account a ON c.CustomerID = a.CustomerID;

--Part 3: Real-Life Implementation Task (Banking System)
--5: Create a Customer Service View??
CREATE VIEW vw_CustomerService AS
SELECT c.FullName, c.Phone, a.Status
FROM Customer c
JOIN Account a ON c.CustomerID = a.CustomerID;

--6: Create a Finance Department View??
CREATE VIEW vw_Finance AS
SELECT AccountID, Balance, AccountType
FROM Account;
--7: Create a Loan Officer View??
CREATE VIEW vw_LoanOfficer AS
SELECT LoanID, CustomerID, LoanAmount, LoanType, Status
FROM Loan;
--8: Create a Transaction Summary View (Last 30 Days)??
CREATE VIEW vw_RecentTransactions AS
SELECT AccountID, Amount, TransactionDate
FROM [Transaction]
WHERE TransactionDate >= DATEADD(DAY, -30, GETDATE());

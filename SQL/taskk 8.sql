--1. Display the department ID, department name, manager ID, and the full name of the manager.
select*from Department1
-- adding department name 
ALTER TABLE Department1
ADD DName VARCHAR(50)  NULL;
UPDATE Department1 SET DName = 'HR' WHERE DNUM = 1;
UPDATE Department1 SET DName = 'Finance' WHERE DNUM = 2;
UPDATE Department1 SET DName = 'IT' WHERE DNUM = 3;

SELECT 
    D.DNUM AS DepartmentID,
    D.DName AS DepartmentName,
    D.MngSSN AS ManagerID,
    E.FirstName + ' ' + E.LastName AS ManagerFullName
FROM Department1 D
JOIN Employee1 E
    ON D.MngSSN = E.SSN;
--2. Display the names of departments and the names of the projects they control.
select* from project
SELECT 
    D.DName AS DepartmentName,
    P.Pname AS ProjectName
FROM Department1 D
JOIN Project P
    ON D.DNUM = P.DNum;
--3. Display full data of all dependents, along with the full name of the employee they depend on.
select* from dependent
select* from Employee1
SELECT 
    E.FirstName + ' ' + E.LastName AS EmployeeFullName,
    D.Dnum,
    D.SSN,
    D.Gender,
    D.Birthday
FROM Employee1 E
LEFT JOIN Dependent D
    ON D.SSN = E.SSN;
--4. Display the project ID, name, and location of all projects located in Cairo or Alex.
select* from project
SELECT * FROM Employee1;
SELECT * FROM MyWork;
INSERT INTO Project (PNUM, Location, City, Pname, DNum)
VALUES
(104, 'Room D', 'Cairo', 'Project Delta', 1),
(105, 'Room E', 'Alex', 'Project Epsilon', 2);
INSERT INTO MyWork (SSN, PNUM, Hours)
VALUES
(1, 104, 40),
(2, 104, 30);

SELECT 
    E.FirstName + ' ' + E.LastName AS EmployeeFullName,
    P.PNUM AS ProjectID,
    P.Pname AS ProjectName,
    P.City,
    W.Hours
FROM Project P
JOIN MyWork W
    ON W.PNUM = P.PNUM
JOIN Employee1 E
    ON E.SSN = W.SSN
WHERE P.City = 'Cairo';

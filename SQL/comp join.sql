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
--5. Display all project data where the project name starts with the letter 'A'
SELECT *
FROM Project
WHERE Pname LIKE 'A%';
--6. Display the IDs and names of employees in department 30 with a salary between 1000 and 2000 LE
--7. Retrieve the names of employees in department 10 who work ? 10 hours/week on the "AL Rabwah" project
SELECT DISTINCT
    E.FirstName + ' ' + E.LastName AS EmployeeName
FROM Employee1 E
JOIN MyWork W ON E.SSN = W.SSN
JOIN Project P ON W.PNUM = P.PNUM
WHERE P.Pname = 'AL Rabwah'
  AND W.Hours >= 10;
--8. Find the names of employees who are directly supervised by "Kamel Mohamed"
SELECT 
    E.FirstName + ' ' + E.LastName AS EmployeeName
FROM Employee1 E
JOIN Employee1 S
    ON E.superID = S.SSN
WHERE S.FirstName = 'Kamel'
  AND S.LastName = 'Mohamed';
  --9. Retrieve the names of employees and the names of the projects they work on, sorted by project name
  SELECT 
    E.FirstName + ' ' + E.LastName AS EmployeeName,
    P.Pname AS ProjectName
FROM Employee1 E
JOIN MyWork W
    ON E.SSN = W.SSN
JOIN Project P
    ON W.PNUM = P.PNUM
ORDER BY P.Pname;
--10. For each project located in Cairo, display the project number, controlling department name, manager's last name,
--address, and birthdate
SELECT 
    P.PNUM AS ProjectNumber,
    D.DName AS DepartmentName,
    M.LastName AS ManagerLastName,
    M.Birthday
FROM Project P
JOIN Department1 D
    ON P.DNum = D.DNUM
JOIN Employee1 M
    ON D.MngSSN = M.SSN
WHERE P.City = 'Cairo';
--11. Display all data of managers in the company.
SELECT DISTINCT
    E.*
FROM Employee1 E
JOIN Department1 D
    ON E.SSN = D.MngSSN;
--12. Display all employees and their dependents, even if some employees have no dependents
SELECT 
    E.FirstName + ' ' + E.LastName AS EmployeeName,
    D.Gender AS DependentGender,
    D.Birthday AS DependentBirthday
FROM Employee1 E
LEFT JOIN Dependent D
    ON E.SSN = D.SSN;
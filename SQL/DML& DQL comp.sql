--1) Company Database – DQL & DML Tasks---
--1. Display all employee data--
select*from Employee
--Display employee first name, last name, salary, and department number--
select fname,lname,salary,Dno from Employee
--Display each employee’s full name and their annual commission (10% of annual--
--salary) as ANNUAL_COMM--
select fname + ' '+ lname as full_name,
salary*12*0.10 as annual_comm from Employee
--4. Display employee ID and name for employees earning more than 1000 LE monthly.--
select SSN,fname,lname from Employee where Salary>1000 
--5. Display employee ID and name for employees earning more than 10000 LE--
--annually--
select SSN,fname,lname from Employee where Salary*12>1000 
--Display names and salaries of all female employees--
select fname,lname,salary from Employee where Sex='F'
--Display employees whose salary is between 2000 and 5000--
select* from Employee where salary between 2000 and 5000
--8. Display employee names ordered by salary descending--
select fname + ' ' + lname from Employee order by salary desc
--Display the maximum, minimum, and average salary.--
select 
max(salary) as max_salary,
Min(salary) as min_salary,
avg(salary) as avg_salary
from employee;
--Display the total number of employees--
SELECT COUNT(*) AS Total_Employees
FROM Employee
--Display employees whose first name starts with 'A'.--
select * from Employee where Fname LIKE 'A%'
-- Display employees who have no supervisor--
select* from Employee where Superssn is null
--14. Insert your personal data into the employee table (Department = 30, SSN = 102672,
--Superssn = 112233, Salary = 3000--
insert into employee (fname,lname,SSN,bdate,address,Sex,Salary,Superssn,Dno)
values( 'sheika','Albusafi',102672,'2001-04-10','albidayah','F',3000,112233,30)
--15. Insert another employee (your friend) in department 30 with SSN = 102660, leaving--
--salary and supervisor number NULL--
insert into employee (fname,lname,SSN,bdate,address,Sex,Salary,Superssn,Dno)
values( 'Elham','Alblushi',102660,'2002-03-05','alnabrah','F',null,null,30)
--16. Update your salary by 20%.
update Employee 
set salary=salary*0.20
--17. Increase salaries by 5% for all employees in department 30.
update Employee
set salary=Salary*0.05 where Dno=30
--19. Delete employees with NULL salary.--
delete from Employee where Salary=null
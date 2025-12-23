--University Database – JOIN Queries--

--1. Display the department ID, name, and the full name of the faculty managing it.--

SELECT d.D_id AS DepartmentID,
       d.Dname AS DepartmentName,
       f.Name AS FacultyFullName
FROM Department d
JOIN faculaty f
ON d.D_id = f.D_id;


--2. Display each program's name and the name of the department offering it.--
SELECT c.Cname AS CourseName,
       d.Dname AS DepartmentName
FROM cource c
JOIN Department d
ON c.D_id = d.D_id;

--3. Display the full student data and the full name of their faculty advisor.--
SELECT s.*, f.Name AS FacultyAdvisorFullName
FROM student s
LEFT JOIN faculaty f
ON s.F_id = f.F_id;


--4. Display class IDs, course titles, and room locations for classes in buildings 'A' or 'B'.--
SELECT e.Exams_code AS ExamID,
       s.subject_name AS CourseTitle,
       e.Room AS RoomLocation
FROM Exams e
JOIN subject s ON e.subject_name = s.subject_name
WHERE e.Room LIKE 'A%' OR e.Room LIKE 'B%';


--5. Display full data about courses whose titles start with "N" (e.g., "Introduction to...").--
SELECT *
FROM cource
WHERE Cname LIKE 'N%';

--6. Display names of students in program ID 3 whose GPA is between 2.5 and 4.0.--
ALTER TABLE student
ADD GPA DECIMAL(3,2);
UPDATE student
SET GPA = 3.2
WHERE student_id = 1001;

UPDATE student
SET GPA = 3.8
WHERE student_id = 1026;

UPDATE student
SET GPA = 2.7
WHERE student_id = 1251;
SELECT s.fname + ' ' + s.lname AS StudentName,
       s.GPA
FROM student s
WHERE s.D_id = 3
  AND s.GPA BETWEEN 2.5 AND 4.0;


--7. Retrieve student names in the Engineering program who earned grades ≥ 80 in the "Database" course.--
-- Add Grade column if not exists
ALTER TABLE Student_Course ADD Grade INT;

-- Update example grades
UPDATE Student_Course
SET Grade = 95
WHERE Student_id = 1001 AND Course_id = 401;

UPDATE Student_Course
SET Grade = 88
WHERE Student_id = 1026 AND Course_id = 301;

-- Query for Engineering students (assuming D_id = 2 for Engineering)
SELECT s.fname + ' ' + s.lname AS StudentName,
       c.Cname AS CourseName,
       sc.Grade
FROM student s
JOIN Student_Course sc ON s.student_id = sc.Student_id
JOIN cource c ON sc.Course_id = c.cource_id
WHERE c.Cname LIKE '%Database%' AND sc.Grade >= 80
  AND s.D_id = 2;



--8. Find names of students who are advised by "Dr. Ahmed Hassan".--
SELECT s.fname + ' ' + s.lname AS StudentName
FROM student s
JOIN faculaty f
ON s.F_id = f.F_id
WHERE f.Name = 'Sara Alblushi';

--9. Retrieve each student's name and the titles of courses they are enrolled in, ordered by course title.--
SELECT s.fname + ' ' + s.lname AS StudentName,
       c.Cname AS CourseName
FROM student s
JOIN Student_Course sc ON s.student_id = sc.Student_id
JOIN cource c ON sc.Course_id = c.cource_id
ORDER BY c.Cname;


--10. For each subject, retrieve the subject ID, course name, department name, and faculty name teaching the subject.--
SELECT sub.Subject_id AS SubjectID,
       sub.subject_name,
       d.Dname AS DepartmentName,
       f.Name AS FacultyName
FROM subject sub
JOIN faculaty f ON sub.F_id = f.F_id
JOIN Department d ON f.D_id = d.D_id;

--11. Display all faculty members who manage any department.--
SELECT f.F_id, f.Name, d.Dname AS DepartmentName
FROM faculaty f
JOIN Department d ON f.D_id = d.D_id;

--12. Display all students and their advisors' names, even if some students don’t have advisors yet--
SELECT s.fname + ' ' + s.lname AS StudentName,
       f.Name AS AdvisorName
FROM student s
LEFT JOIN faculaty f ON s.F_id = f.F_id;


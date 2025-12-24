--Part 1: Warm-Up
--1. Display all courses with prices.
SELECT Title, Price
FROM Courses;

--2. Display all students with join dates.
SELECT FullName, JoinDate
FROM Students;

-- 3. Show all enrollments with completion percent and rating.
SELECT EnrollmentID, CompletionPercent, Rating
FROM Enrollments;

--4. Count instructors who joined in 2023.
SELECT COUNT(*) AS InstructorCount
FROM Instructors
WHERE YEAR(JoinDate) = 2023;-- where = يفلتر rows قبل التجميع 

--5. Count students who joined in April 2023.
SELECT COUNT(*) AS StudentCount
FROM Students
WHERE JoinDate BETWEEN '2023-04-01' AND '2023-04-30';

--Part 2: Beginner Aggregation 
--1. Count total number of students.
SELECT COUNT(*) AS totalStudents
FROM Students
---2. Count total number of enrollments. 
SELECT COUNT(*) AS totalenrollments
FROM enrollments
--3. Find average rating per course.
SELECT CourseID, AVG(Rating) AS AvgRating
FROM Enrollments
GROUP BY CourseID; --نستخدم group by لمن نريد نسوي متوسط التقييم حال كل كورس
-- هو ايضا يقسم البيانات الى مجموعات 

--4. Count courses per instructor. 
SELECT InstructorID, COUNT(*) AS CourseCount
FROM Courses
GROUP BY InstructorID;

--5. Count courses per category. 
SELECT CategoryID, COUNT(*) AS CourseCount
FROM Courses
GROUP BY CategoryID;

--6. Count students enrolled in each course.
SELECT CourseID, COUNT(StudentID) AS StudentCount
FROM Enrollments
GROUP BY CourseID;

--7. Find average course price per category. 
SELECT CategoryID, AVG(Price) AS AvgPrice
FROM Courses
GROUP BY CategoryID;

--8. Find maximum course price.
SELECT MAX(Price) AS MaxPrice
FROM Courses;

--9. Find min, max, and average rating per course. 
SELECT CourseID,
       MIN(Rating) AS MinRating,
       MAX(Rating) AS MaxRating,
       AVG(Rating) AS AvgRating
FROM Enrollments
GROUP BY CourseID;

--10. Count how many students gave rating = 5.
SELECT COUNT(*) AS FiveStarRatings
FROM Enrollments
WHERE Rating = 5;

--Part 3: Extended Beginner Practice 
--11. Count enrollments per month. 
SELECT MONTH(EnrollDate) AS Month, COUNT(*) AS Total
FROM Enrollments
GROUP BY MONTH(EnrollDate);

--12. Find average course price overall. 
SELECT AVG(Price) AS AvgCoursePrice
FROM Courses;

--13. Count students per join month. 
SELECT MONTH(JoinDate) AS Month, COUNT(*) AS Total
FROM Students
GROUP BY MONTH(JoinDate);

--14. Count ratings per value (1–5).
SELECT Rating, COUNT(*) AS Total
FROM Enrollments
GROUP BY Rating;

--15. Find courses that never received rating = 5.
SELECT CourseID
FROM Enrollments
GROUP BY CourseID
HAVING MAX(Rating) < 5;

--16. Count courses priced above 30. 
SELECT COUNT(*) AS ExpensiveCourses
FROM Courses
WHERE Price > 30;

--17. Find average completion percentage. 
SELECT AVG(CompletionPercent) AS AvgCompletion
FROM Enrollments;

--18. Find course with lowest average rating.
SELECT TOP 1 *
FROM (
    SELECT CourseID, AVG(Rating) AS AvgRating
    FROM Enrollments
    GROUP BY CourseID
) t
ORDER BY AvgRating ASC;

--Reflection (End of Day 1) Answer briefly: 
--• What was easiest? 
--COUNT و AVG البسيطة بدون JOIN.
--• What was hardest? 
--استخدام HAVING مع JOIN والتجميع.
--• What does GROUP BY do in your own words? 
--تقوم بتجميع الصفوف المتشابهة بحيث تعمل دوال التجميع (AVG, COUNT…) على كل مجموعة بدل الجدول كامل.
--Day 1 Mini Challenge
--Course Performance Snapshot Show:
--• Course title 
--• Total enrollments 
--• Average rating 
--• Average completion % 
SELECT c.Title,
       COUNT(e.EnrollmentID) AS TotalEnrollments,
       AVG(e.Rating) AS AvgRating,
       AVG(e.CompletionPercent) AS AvgCompletion
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title;

--Day 2 – JOIN + Aggregation + Analysis 
--Objectives 
--• Use JOIN with aggregation 
--• Apply HAVING correctly 
--• Think like a data analyst 
SELECT c.Title, i.FullName, COUNT(e.EnrollmentID) AS Enrollments
FROM Courses c
JOIN Instructors i ON c.InstructorID = i.InstructorID
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title, i.FullName;

--Part 4: 
--JOIN + Aggregation 
--1. Course title + instructor name + enrollments.
SELECT c.Title, i.FullName, COUNT(e.EnrollmentID) AS Enrollments
FROM Courses c
JOIN Instructors i ON c.InstructorID = i.InstructorID
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title, i.FullName;

--2. Category name + total courses + average price. 
SELECT cat.CategoryName,
       COUNT(c.CourseID) AS TotalCourses,
       AVG(c.Price) AS AvgPrice
FROM Categories cat
JOIN Courses c ON cat.CategoryID = c.CategoryID
GROUP BY cat.CategoryName;

--3. Instructor name + average course rating. 
SELECT i.FullName, AVG(e.Rating) AS AvgRating
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;

--4. Student name + total courses enrolled. 
SELECT s.FullName, COUNT(e.CourseID) AS CoursesEnrolled
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.FullName;

--5. Category name + total enrollments. 
SELECT cat.CategoryName, COUNT(e.EnrollmentID) AS TotalEnrollments
FROM Categories cat
JOIN Courses c ON cat.CategoryID = c.CategoryID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY cat.CategoryName;

--6. Instructor name + total revenue.
SELECT i.FullName, SUM(c.Price) AS TotalRevenue
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;

--7. Course title + % of students completed 100%. 
SELECT c.Title,
       SUM(CASE WHEN e.CompletionPercent = 100 THEN 1 ELSE 0 END) * 100.0
       / COUNT(*) AS CompletionRate
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title;

--Part 5: HAVING Practice Use HAVING only.
--1. Courses with more than 2 enrollments. 
SELECT CourseID
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(*) > 1; -- having = يفلنر النواتج بعد التجميع    

--2. Instructors with average rating above 4.
select* from Enrollments
SELECT i.FullName
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName
HAVING AVG(e.Rating) > 2;

--3. Courses with average completion below 60%. 
SELECT CourseID
FROM Enrollments
GROUP BY CourseID
HAVING AVG(CompletionPercent) < 60;

--4. Categories with more than 1 course. 
SELECT CategoryID
FROM Courses
GROUP BY CategoryID
HAVING COUNT(*) > 1;

--5. Students enrolled in at least 2 courses. 
SELECT StudentID
FROM Enrollments
GROUP BY StudentID
HAVING COUNT(*) >= 2;

--Part 6: Analytical Thinking Answer using SQL + short explanation: 
--1. Best performing course.
SELECT StudentID
FROM Enrollments
GROUP BY StudentID
HAVING COUNT(*) >= 2;
--Answer: HTML & CSS Basics
--Reason: أعلى متوسط تقييم.
--2. Instructor to promote. 
SELECT TOP 1 i.FullName, AVG(e.Rating) AS AvgRating
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName
ORDER BY AvgRating DESC;
--sarah ahmed اعلى تقييم 
--3. Highest revenue category.
SELECT TOP 1 cat.CategoryName, SUM(c.Price) AS Revenue
FROM Categories cat
JOIN Courses c ON cat.CategoryID = c.CategoryID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY cat.CategoryName
ORDER BY Revenue DESC;
--web development the highest 

--4. Do expensive courses have better ratings? 
SELECT c.Price, AVG(e.Rating) AS AvgRating
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Price;
--Conclusion: لا، السعر الأعلى لا يعني تقييم أعلى.
--5. Do cheaper courses have higher completion? 
SELECT c.Price, AVG(e.CompletionPercent) AS AvgCompletion
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Price;

--Final Challenge – Mini Analytics Report 
--1. Top 3 courses by revenue. 
SELECT TOP 3 c.Title, SUM(c.Price) AS Revenue
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title
ORDER BY Revenue DESC;

--2. Instructor with most enrollments. 
SELECT TOP 1 i.FullName, COUNT(e.EnrollmentID) AS TotalEnrollments
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName
ORDER BY TotalEnrollments DESC;

--3. Course with lowest completion rate. 
SELECT TOP 1 c.Title, AVG(e.CompletionPercent) AS AvgCompletion
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title
ORDER BY AvgCompletion ASC;

--4. Category with highest average rating.
SELECT TOP 1 cat.CategoryName, AVG(e.Rating) AS AvgRating
FROM Categories cat
JOIN Courses c ON cat.CategoryID = c.CategoryID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY cat.CategoryName
ORDER BY AvgRating DESC;

--5. Student enrolled in most courses. 
SELECT TOP 1 s.FullName, COUNT(e.CourseID) AS TotalCourses
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.FullName
ORDER BY TotalCourses DESC;

--خلاصة:
--GROUP BY = تحليل حسب كل مجموعة
--COUNT / AVG = تلخيص البيانات
--JOIN = ربط الجداول
--HAVING = فلترة بعد شرط التجميع
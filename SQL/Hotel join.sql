--Hotel JOIN 

--1. Display hotel ID, name, and the name of its manager.--
SELECT b.branch_id, b.name AS branch_name, s.name AS manager_name
FROM Branch b
JOIN Staff s ON b.branch_id = s.branch_id
WHERE s.job_title = 'Manager';

--2. Display hotel names and the rooms available under them.--
SELECT b.name AS branch_name, r.room_no, r.room_type
FROM Branch b
JOIN Room r ON b.branch_id = r.branch_id
ORDER BY b.branch_id, r.room_no;

--3. Display guest data along with the bookings they made.--
Select * from Customer;
Select * from Booking;
SELECT * FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id;

--4. Display bookings for hotels in 'Muscat Main' or 'Salalah Resort'.--
SELECT b.booking_id, b.customer_id, b.check_in_date, b.check_out_date
FROM Booking b
JOIN BookingRoom brm ON b.booking_id = brm.booking_id
JOIN Room r ON brm.room_no = r.room_no AND brm.branch_id = r.branch_id
JOIN Branch br ON r.branch_id = br.branch_id
WHERE br.name IN ('Muscat Hotel', 'Salalah Resort');

--5. Display all room records where room type starts with "S" (e.g., "Suite", "Single").--
SELECT *
FROM Room
WHERE room_type LIKE 'S%';

--6. List guests who booked rooms priced between 50 and 165 LE.--
SELECT DISTINCT c.customer_id, c.name, c.phone, c.email
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN BookingRoom brm ON b.booking_id = brm.booking_id
JOIN Room r ON brm.room_no = r.room_no AND brm.branch_id = r.branch_id
WHERE r.nightly_rate BETWEEN 50 AND 165;

--7. Retrieve guest names who have bookings marked as 'Confirmed' in hotel "Hilton Downtown".--
-- ما عندي Confirmed و Hilton Downtown--

--8. Find guests whose bookings were handled by staff member "Hassan".--
SELECT DISTINCT c.customer_id, c.name AS customer_name
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN StaffAction sa ON b.booking_id = sa.booking_id
JOIN Staff s ON sa.staff_id = s.staff_id
WHERE s.name LIKE 'Hassan%';

--9. Display each guest’s name and the rooms they booked, ordered by room type.--
SELECT c.name AS customer_name, r.room_no, r.room_type
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN BookingRoom brm ON b.booking_id = brm.booking_id
JOIN Room r ON brm.room_no = r.room_no AND brm.branch_id = r.branch_id
ORDER BY r.room_type;

--10. For each hotel in 'Salalah Resort', display hotel ID, name, manager name, and contact info.--
SELECT br.branch_id, br.name AS hotel_name, s.name AS manager_name
FROM Branch br
JOIN Staff s ON br.branch_id = s.branch_id
WHERE br.name = 'Salalah Resort' AND s.job_title = 'Manager';

--11. Display all staff members who hold 'Manager' positions.--
SELECT *
FROM Staff
WHERE job_title = 'Manager';

--12. Display all guests and their reviews, even if some guests haven't submitted any reviews.--
-- (not possible, لا يوجد جدول Reviews)--

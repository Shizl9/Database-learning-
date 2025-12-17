create database college
use college
create table Department( 
D_id int primary key identity (1,1),
Dname nVarchar(50) Not null
)
create table faculaty( 
F_id int primary key identity (1,1),
Name nVarchar (50) not null,
mopile_no nVarchar(50) not null,
Dept nVarchar (50)not null,
salary decimal (9,2)null,
D_id int,
foreign key (D_id) references Department(D_id)
)
create table Hostel(
Hostel_id int primary key not null,
Hostel_name nVarchar(50)null,  
No_of_seats int not null,
city nVarchar(50) null,
state nVarchar(30) null,
Pin_code nVarchar (50) null,
)
create table student (
student_id int primary  key,
fname nVarchar(50) not null,
lname nVarchar(50) not null,
phone_no int null,
DOB date,
F_id int,
D_id int,
H_id int,
foreign key (F_id) references faculaty(F_id),
foreign key (D_id) references Department(D_id),
foreign key (H_id) references Hostel (Hostel_id)
)
create Table cource(
cource_id int primary key,
Cname nVarchar(50) not null,
duration nVarchar not null,
D_id int,
foreign key (D_id) references Department(D_id),
)
create Table subject(
Subject_id int primary key,
subject_name nVarchar(50) not null,
F_id int,
foreign key (F_id) references faculaty(F_id),
)
create Table Exams(
Exams_code int primary key,
subject_name nVarchar(50) not null,
Exam_date date,
Exam_time time,
Room nVarchar(50),
D_id int,
foreign key (D_id) references Department(D_id)
)
Create table Student_Course (
Student_id int,
Course_id int,
primary key (Student_id, Course_id),
foreign key (Student_id) references Student(Student_id),
foreign key(Course_id) references Cource(Cource_id)
)
Create table Student_Subject(
student_id int,
Subject_id int,
Primary key (student_id,Subject_id),
Foreign key (Student_id) references student(Student_id),
Foreign key (Subject_id) references subject (Subject_id)
)
Create table Student_Exams(
student_id int,
Exams_code int,
Primary key (student_id,Exams_code),
Foreign key (Student_id) references student(Student_id),
Foreign key (Exams_code) references Exams(Exams_code)
)
insert into Department(Dname)
values
('Computer Science'),
('Software Engineering'),
('Information Technology')
select* from Department
insert into faculaty(Name,mopile_no,Dept,D_id,salary)
values
('Ahmed Ali',95673246,'Computer Science',1,3000),
('Sara Alblushi',98890001,'Software Engineering',2,3500),
('Ali Alrajhi',99883344,'Information Technology',3,3200)
select* from faculaty
insert into Hostel(Hostel_id,Hostel_name,No_of_seats,city,state,Pin_code)
values
(101,'univercuty Hostel',500,'Alkhwair','Muscat',1234),
(102,'girls Hostel',200,'Sohar','albatinah',1554),
(122,'univercuty Hostel',110,'salalah','Dhofar',222)
select* from Hostel
insert into student(student_id,fname,lname,phone_no,DOB,F_id,D_id,H_id)
values
(1001,'sewar','alzedjali',7771228,'2001-09-09',1,1,101),
(1026,'Hafsah','almoqbali',90081241,'2003-01-29',2,2,102),
(1251,'kahlfan','bit-hamiar',78731538,'2006-11-20',3,3,122)
select* from student
insert into cource(cource_id,cname,Duration,D_id)
values
(401,'Computer Science',4,1),
(301,'Software Engineering',6,2),
(207,'Information Technology',3,3)
select* from cource
insert into subject(subject_id,subject_name,F_id)
values
(502,'database systems',1),
(503,'operating systems',2),
(504,'computer networks',3)
select*from subject
insert into Exams(Exams_code,Exam_date,Exam_time,Room,D_id,subject_name)
values
(9001,'2025-6-19','9:00','CE01',1,'database systems'),
(9002,'2025-06-12','11:00','ME02',2,'operating systems'),
(9003,'2025-06-15','10:00','CE04',3,'computer networks')
select*from Exams
insert into Student_Course (Student_id, Course_id)
VALUES
(1001, 401),
(1026, 301),
(1251, 207)
select*from  Student_Course
insert into Student_Subject (student_id,Subject_id)
VALUES
(1001, 502),
(1026, 503),
(1251, 504)
select*from Student_Subject

insert into Student_Exams (student_id,Exams_code)
VALUES
(1001, 9001),
(1026, 9002),
(1251, 9003)
select*from Student_Exams

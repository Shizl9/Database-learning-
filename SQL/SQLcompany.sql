create database companyDB
use companyDB
create Table Employee1(
SSN INT primary key identity(1,1 ),
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50)not null,
Gender VARCHAR(50) NOT NULL,
Birthday date,
superID INT,
FOREIGN KEY (superID) REFERENCES Employee1(SSN) 
);
CREATE TABLE Department1(
DNUM INT PRIMARY KEY IDENTITY(1,1),
HiringDate DATE,
MngSSN INT,
FOREIGN KEY (MngSSN) REFERENCES Employee1(SSN),
mDNUM INT,
FOREIGN KEY (mDNUM) REFERENCES Department1(DNUM)
);
create TABLE Locations(
Dnum INT,
location VARCHAR(50),
Primary key (Dnum,Location),
FOREIGN KEY(Dnum) REFERENCES Department1(DNUM) 
);
create TABLE Project(
PNUM INT Primary key,
location VARCHAR(50),
City VARCHAR(50),
Pname VARCHAR(50),
DNum INT,
FOREIGN KEY (DNum) ReFERENCES Department1(DNUM)
);
create TABLE Mywork(
SSN INT,
PNUM INT,
Hours INT,
Primary key (SSN,PNUM),
FOREIGN KEY(SSN) References employee1(SSN),
FOREIGN KEY(PNUM) References Project(PNUM)
);
Create Table Dependent(
Dnum INT,
SSN INT,
Primary key(Dnum,SSN),
Gender VARCHAR (50) NOT NULL,
Birthday date,
FOREIGN KEY (SSN) references Employee1(SSN)
);

insert into Employee1 (FirstName,LastName, Birthday,Gender)
Values
('Sheika', 'Salim', '2001-04-10', 'Female'),
('Sara', 'Hamad','1999-08-11','Female'),
('Omar', 'Saleh', '1996-03-2','Male');

INSERT INTO Department1 (HiringDate, MngSSN, mDNUM)
VALUES
('2020-01-01', 1, NULL), 
('2021-03-15', 2, 1),   
('2022-06-10', 3, 1)    

INSERT INTO Project (PNUM, Location, City, Pname, DNum)
VALUES
(101, 'Room A', 'Muscat', 'Project Alpha', 1),
(102, 'Room B', 'ALsuwiq', 'Project Beta', 2),
(103, 'Room C', 'Qurayyat', 'Project Gamma', 3);
SELECT PNUM, Pname
FROM Project;

INSERT INTO MyWork (SSN, PNUM, Hours)
VALUES
(1, 101, 40),
(2, 101, 20),
(2, 102, 15),
(3, 102, 30),
(3, 103, 25);
SELECT *
FROM Dependent;
DELETE FROM Dependent;
INSERT INTO Dependent (Dnum, SSN, Gender, Birthday)
VALUES
(1, 1, 'Male', '2010-05-10'),
(1, 2, 'Female', '2012-07-20'),
(2, 3, 'Male', '2005-11-15'); 

DELETE FROM Locations;

INSERT INTO Locations (Dnum, Location)
VALUES
(1, 'Head Office'),
(2, 'Branch Office A'),
(3, 'Branch Office B');


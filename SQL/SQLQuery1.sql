create database comp2DB
use comp2DB
create Table Employee(
SSN INT primary key identity(1,1 ),
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50)not null,
Gender VARCHAR(50) NOT NULL,
Birthday date,
superID INT,
FOREIGN KEY (superID) REFERENCES Employee(SSN) 
)
CREATE TABLE Department(
Dname nvarchar(20) not null,
DNUM INT PRIMARY KEY IDENTITY(1,1),
HiringDate DATE not null,
MngSSN INT,
FOREIGN KEY (MngSSN) REFERENCES Employee(SSN),
)
create TABLE Location2(
Dnum INT,
location nVARCHAR(100),
Primary key (Dnum,Location),
FOREIGN KEY(Dnum) REFERENCES Department(DNUM) 
)
create TABLE Project1(
PNUM INT Primary key identity(1,1),
location nVARCHAR(100)not null,
City nVARCHAR(50),
Pname nVARCHAR(50)not null,
DNum INT,
FOREIGN KEY (DNum) ReFERENCES Department(DNUM)
)
create TABLE Myworks(
SSN INT,
PNUM INT,
Hours INT not null,
Primary key (SSN,PNUM),
FOREIGN KEY(SSN) References employee(SSN),
FOREIGN KEY(PNUM) References Project1(PNUM)
)
Create Table Dependent1(
Dnum nVarchar(50) not null,
SSN INT,
Primary key(Dnum,SSN),
Gender bit default 0,
Birthday date,
FOREIGN KEY (SSN) references Employee(SSN)
)
alter table employee 
add DNUM int foreign key REFERENCES Department (Dnum) 

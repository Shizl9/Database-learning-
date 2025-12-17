create database companyDB
use companyDB
create Table Employee1(
SSN INT primary key,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50)not null,
Gender VARCHAR(50) NOT NULL,
Birthday date,
superID INT,
FOREIGN KEY (superID) REFERENCES Employee1(SSN) 
)
CREATE TABLE Department1(
DNUM INT Primary key,
HiringDate DATE,
MngSSN INT,
FOREIGN KEY (MngSSN) REFERENCES Employee1(SSN),
mDNUM INT,
FOREIGN KEY (mDNUM) REFERENCES Department1(DNUM)
)
create TABLE Locaions(
location VARCHAR(50),
Dnum INT,
Primary key (Dnum,Location),
FOREIGN KEY(Dnum) REFERENCES Department1(DNUM) 
)
create TABLE Project(
PNUM INT Primary key,
location VARCHAR(50),
City VARCHAR(50),
Pname VARCHAR(50),
DNum INT,
FOREIGN KEY (DNum) ReFERENCES Department1(DNUM)
)
create TABLE Mywork(
SSN INT,
PNUM INT,
Hours INT,
Primary key (SSN,PNUM),
FOREIGN KEY(SSN) References employee1(SSN),
FOREIGN KEY(PNUM) References Project(PNUM)
)
Create Table Dependent(
Dnum INT,
SSN INT,
Primary key(Dnum,SSN),
Gender VARCHAR (50) NOT NULL,
Birthday date,
FOREIGN KEY (SSN) references Employee1(SSN)
)
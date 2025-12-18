create database AirlineDB
use AirlineDB
CREATE TABLE Airport (
    AirportCode CHAR(3) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL
)
CREATE TABLE AirplaneType (
    TypeName VARCHAR(50) PRIMARY KEY,
    Company VARCHAR(50) NOT NULL,
    MaxSeats INT NOT NULL CHECK (MaxSeats > 0)
)
CREATE TABLE AirportAirplaneType (
    AirportCode CHAR(3),
    TypeName VARCHAR(50),
    PRIMARY KEY (AirportCode, TypeName),
    FOREIGN KEY (AirportCode) REFERENCES Airport(AirportCode),
    FOREIGN KEY (TypeName) REFERENCES AirplaneType(TypeName)
)
CREATE TABLE Airplane (
    AirplaneID INT PRIMARY KEY,
    TotalSeats INT NOT NULL CHECK (TotalSeats > 0),
    TypeName VARCHAR(50) NOT NULL,
    FOREIGN KEY (TypeName) REFERENCES AirplaneType(TypeName)
)
CREATE TABLE Flight (
    FlightNo INT PRIMARY KEY,
    Airline VARCHAR(50) NOT NULL,
    Weekdays VARCHAR(20),
    Restrictions VARCHAR(100)
)
CREATE TABLE FlightLeg (
    LegNo INT PRIMARY KEY,
    FlightNo INT NOT NULL,
    DepartureAirport CHAR(3) NOT NULL,
    ArrivalAirport CHAR(3) NOT NULL,
    ScheduledDepTime TIME NOT NULL,
    ScheduledArrTime TIME NOT NULL,
    FOREIGN KEY (FlightNo) REFERENCES Flight(FlightNo),
    FOREIGN KEY (DepartureAirport) REFERENCES Airport(AirportCode),
    FOREIGN KEY (ArrivalAirport) REFERENCES Airport(AirportCode)
)
CREATE TABLE LegInstance (
    LegNo INT NOT NULL,
    FlightDate DATE NOT NULL,
    ActualDepTime DATETIME NOT NULL,
    ActualArrTime DATETIME NOT NULL,
    AvailableSeats INT NOT NULL CHECK (AvailableSeats >= 0),
    AirplaneID INT NOT NULL,
    PRIMARY KEY (LegNo, FlightDate),
    FOREIGN KEY (LegNo) REFERENCES FlightLeg(LegNo),
    FOREIGN KEY (AirplaneID) REFERENCES Airplane(AirplaneID),
    CHECK (ActualArrTime > ActualDepTime)
);

-- TASK 1
CREATE DATABASE Minions

-- TASK 2
CREATE TABLE Minions (
Id INT PRIMARY KEY NOT NULL,
Name NVARCHAR(50),
Age INT)

CREATE TABLE Towns (
Id INT PRIMARY KEY NOT NULL,
Name NVARCHAR(50)
)

-- TASK 3
ALTER TABLE Minions
ADD TownId INT FOREIGN KEY 
REFERENCES Towns(Id)

SELECT * FROM Minions

-- DROP TABLE Minions
-- DROP TABLE Towns

SELECT * FROM Towns
SELECT * FROM Minions

-- TASK 4
INSERT INTO Towns (Id, Name)
VALUES (1, 'Sofia')

INSERT INTO Towns (Id, Name)
VALUES (2, 'Plovdiv')

INSERT INTO Towns (Id, Name)
VALUES (3, 'Varna')

INSERT INTO Minions (Id, Name, Age, TownId)
VALUES (1, 'Kevin', 22, 1)

INSERT INTO Minions (Id, Name, Age, TownId)
VALUES (2, 'Bob', 15, 3)

INSERT INTO Minions (Id, Name, Age, TownId)
VALUES (3, 'Steward', null, 2)

-- TASK 5
TRUNCATE TABLE Minions

-- TASK 6
DROP TABLE Minions
DROP TABLE Towns

-- TASK 7
CREATE TABLE People(
Id INT PRIMARY KEY IDENTITY (1,1),
Name NVARCHAR(200) NOT NULL,
Picture VARBINARY(MAX) CHECK(DATALENGTH(Picture)<1000000) NULL,
Height DECIMAL (15,2) NULL,
Weight DECIMAL (15,2) NULL,
Gender NCHAR(1) CHECK (Gender = 'm' OR Gender = 'f') NOT NULL,
Birthdate DATE NOT NULL,
Biography NVARCHAR(MAX) NULL
)

-- DROP TABLE People
-- TRUNCATE TABLE People
-- SELECT * FROM People

INSERT INTO People (Name, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Alpha', 190, 210, 'm', '19901010', 'Pichgdf')

INSERT INTO People (Name, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Beta', 200, 130, 'm', '19901010', 'Pich fef')

INSERT INTO People (Name, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Gama', 210, 120, 'm', '19901010', 'Pich es s')

INSERT INTO People (Name, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Delta', 120, 110, 'm', '19901010', 'Pich e')

INSERT INTO People (Name, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Epsilon', 110, 50, 'm', '19901010', 'Pich e')


-- TASK 8

CREATE TABLE Users(
Id BIGINT IDENTITY (1,1),
Username VARCHAR(30) NOT NULL,
Password VARCHAR(26) NOT NULL,
Picture VARBINARY(MAX) CHECK(DATALENGTH(Picture)<900000) NULL,
LastLoginTime DATETIME2 NULL,
IsDeleted BIT
CONSTRAINT pk_Users PRIMARY KEY (Id)
)

-- SELECT * FROM Users
-- DROP table Users

INSERT INTO Users (Username, Password, LastLoginTime, IsDeleted)
VALUES ('NumoeroUno', 'abc', '2016-12-01 12:32:00.0000000', 0)

INSERT INTO Users (Username, Password, LastLoginTime, IsDeleted)
VALUES ('NumoeroDUO', 'abc', '2016-12-01 12:32:00.0000000', 0)

INSERT INTO Users (Username, Password, LastLoginTime, IsDeleted)
VALUES ('KAKetri', 'abc', '2016-12-01 12:32:00.0000000', 0)

INSERT INTO Users (Username, Password, LastLoginTime, IsDeleted)
VALUES ('QUATRO', 'abc', '2016-12-01 12:32:00.0000000', 0)

INSERT INTO Users (Username, Password, LastLoginTime, IsDeleted)
VALUES ('QuintoIliNeshtotakoa', 'abc', '2016-12-01 12:32:00.0000000', 0)

-- TASK 9
ALTER TABLE Users
DROP CONSTRAINT pk_Users

ALTER TABLE Users
ADD CONSTRAINT pk_Users PRIMARY KEY (Id, Username)

-- TASK 10
ALTER TABLE Users
ADD CONSTRAINT ps_Users CHECK (DATALENGTH(Password) >= 5)

-- TASK 11
ALTER TABLE Users
ADD CONSTRAINT df_Users_DateTime
DEFAULT SYSDATETIME() for [LastLoginTime]

-- Test
-- INSERT INTO Users (Username, Password, IsDeleted) VALUES ('QuintoIliNeshtotakoa', 'abc', 0)
-- SELECT * FROM Users

-- TASK 12
ALTER TABLE Users
DROP CONSTRAINT pk_Users

ALTER TABLE Users
ADD CONSTRAINT pk_Users PRIMARY KEY (Username)

ALTER TABLE Users
ADD CONSTRAINT username_length_Users CHECK (DATALENGTH(Username) >= 3)

ALTER TABLE Users
ADD CONSTRAINT unique_username_Users UNIQUE(Username)

-- TASK 13
CREATE DATABASE Movies
USE Movies

CREATE TABLE Directors (
Id INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
DirectorName NVARCHAR(100) NOT NULL,
Notes NVARCHAR(1000) NULL)

INSERT INTO Directors (DirectorName, Notes)
VALUES ('Pesho', 'Razni belejki')

INSERT INTO Directors (DirectorName, Notes)
VALUES ('Gosho', 'Razni belejki2')

INSERT INTO Directors (DirectorName, Notes)
VALUES ('Stefan', 'Razni belejki3')

INSERT INTO Directors (DirectorName, Notes)
VALUES ('Ivan', 'Razni belejki4')

INSERT INTO Directors (DirectorName, Notes)
VALUES ('Rusata panda', 'Razni belejki5')

-- SELECT * FROM Directors

CREATE TABLE Genres (
Id INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
GenreName NVARCHAR(100) NOT NULL,
NOTES NVARCHAR(1000) NULL)

INSERT INTO Genres (GenreName, NOTES)
VALUES ('Action' , 'Bel 1')

INSERT INTO Genres (GenreName, NOTES)
VALUES ('Horror' , 'Bel 2')

INSERT INTO Genres (GenreName, NOTES)
VALUES ('Commedy' , 'Bel 50')

INSERT INTO Genres (GenreName, NOTES)
VALUES ('Drama' , 'Bel 100')

INSERT INTO Genres (GenreName, NOTES)
VALUES ('Errotic' , 'Bel 500')

-- SELECT * FROM Genres
-- DROP TABLE Genres

CREATE TABLE Categories (
Id INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
CategoryName NVARCHAR(100) NOT NULL,
NOTES NVARCHAR(1000) NULL)

INSERT INTO Categories (CategoryName, NOTES)
VALUES ('Planned' , 'Gathering info and financing')

INSERT INTO Categories (CategoryName, NOTES)
VALUES ('Preproduction' , 'Writing scripts')

INSERT INTO Categories (CategoryName, NOTES)
VALUES ('Shooting' , 'On set')

INSERT INTO Categories (CategoryName, NOTES)
VALUES ('Postproduction' , 'Adding CGI')

INSERT INTO Categories (CategoryName, NOTES)
VALUES ('Released' , 'It is out in the wild')

-- SELECT * FROM Categories
-- DROP TABLE Categories

CREATE TABLE Movies (
Id INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
Title NVARCHAR(255) NOT NULL,
DirectorId INT FOREIGN KEY REFERENCES Directors(Id) NOT NULL,
CopyrightYear INT NOT NULL,
Length INT NULL,
GenredId INT FOREIGN KEY REFERENCES Genres(Id) NOT NULL,
CategoryId INT FOREIGN KEY REFERENCES Categories(Id)NOT NULL,
Rating INT null,
NOTES NVARCHAR(1000) NULL)

INSERT INTO Movies (Title, DirectorId, CopyrightYear, Length, GenredId, CategoryId, Rating, NOTES)
VALUES ('Lake Adventures', 5, 2017, 120, 5, 1, 10, 'Super e')

INSERT INTO Movies (Title, DirectorId, CopyrightYear, Length, GenredId, CategoryId, Rating, NOTES)
VALUES ('Boro 1', 1, 2017, 120, 1, 5, 10, 'qk e')

INSERT INTO Movies (Title, DirectorId, CopyrightYear, Length, GenredId, CategoryId, Rating, NOTES)
VALUES ('Kybyt Libre', 2, 2017, 120, 4, 4, 10, 'nou e qk')

INSERT INTO Movies (Title, DirectorId, CopyrightYear, Length, GenredId, CategoryId, Rating, NOTES)
VALUES ('Small Men, Big Walls', 3, 2018, 120, 1, 2, 10, 'e super e')

INSERT INTO Movies (Title, DirectorId, CopyrightYear, Length, GenredId, CategoryId, Rating, NOTES)
VALUES ('Kofti Trypka', 4, 2017, 120, 3, 3, 10, 'Plato')

-- TASK 14

CREATE DATABASE CarRental
USE CarRental

CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	CategoryName nvarchar(50) NOT NULL,
	DailyRate int,
	WeeklyRate int,
	MonthlyRate int NOT NULL,
	WeekendRate int
)

CREATE TABLE Cars
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Platenumber nvarchar(50) NOT NULL UNIQUE,
	Model nvarchar(255) NOT NULL,
	CarYear int NOT NULL,
	CategoryId nvarchar(255),
	Doors int,
	Picture ntext,
	Condition nvarchar(50) NOT NULL,
	Available INT NOT NULL
)

CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50) NOT NULL,
	Title nvarchar(255) NOT NULL,
	Notes nvarchar(255)
)

CREATE TABLE Customers
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	DriverLicenceNumber int NOT NULL UNIQUE,
	FullName nvarchar(255) NOT NULL,
	Address nvarchar(255),
	City nvarchar(255) NOT NULL,
	ZIPCode nvarchar(255),
	Notes nvarchar(255)
)

CREATE TABLE RentalOrders
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	EmployeeId INT NOT NULL UNIQUE,
	CustomerId INT NOT NULL UNIQUE,
	CarId INT NOT NULL,
	TankLevel INT,
	KilometrageStart INT NOT NULL,
	KilometrageEnd INT NOT NULL,
	TotalKilometrage INT,
	StartDate DATE,
	EndDate DATE,
	TotalDays INT,
	RateApplied nvarchar(50),
	TaxRate nvarchar(50),
	OrderStatus nvarchar(255),
	Notes nvarchar(255)
)

INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES('Somecategory', NULL, 3, 100, 2)
INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES('SomeanotherCategory', 1, NULL, 900, NULL)
INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES('TheLastCategory', 4, 5, 800, 35)

INSERT INTO Cars(Platenumber,Model,CarYear,CategoryId,Doors,Picture,Condition,Available)
VALUES('ÑÀ 2258 ÀÑ', 'BMW', 2017, NULL,4,NULL,'New', 10)
INSERT INTO Cars(Platenumber,Model,CarYear,CategoryId,Doors,Picture,Condition,Available)
VALUES('RA 2299 CA', 'AUDI', 2017, NULL,2,NULL,'New', 21)
INSERT INTO Cars(Platenumber,Model,CarYear,CategoryId,Doors,Picture,Condition,Available)
VALUES('EG 8888 GA', 'MERCEDES', 2017, NULL,4,NULL,'New', 9)

INSERT INTO Employees(FirstName,LastName,Title,Notes)
VALUES('Gosho','Peshov','Software Developer',NULL)
INSERT INTO Employees(FirstName,LastName,Title,Notes)
VALUES('Pesho','Goshov','Pilot',NULL)
INSERT INTO Employees(FirstName,LastName,Title,Notes)
VALUES('Mariika','Petrova','Doctor',NULL)

INSERT INTO Customers(DriverLicenceNumber, FullName, Address,City,ZIPCode,Notes)
VALUES(5821596,'Gosho it-to',NULL,'Sofia', NULL, NULL)
INSERT INTO Customers(DriverLicenceNumber, FullName, Address,City,ZIPCode,Notes)
VALUES(123513,'Pesho Peshov Peshov',NULL,'England', 'TN9T4U', NULL)
INSERT INTO Customers(DriverLicenceNumber, FullName, Address,City,ZIPCode,Notes)
VALUES(09834758,'Pesho Goshov Peshov',NULL,'Switzerland', NULL, NULL)

INSERT INTO RentalOrders(EmployeeId,CustomerId,CarId,TankLevel,KilometrageStart,KilometrageEnd,TotalKilometrage,StartDate,EndDate,TotalDays,RateApplied,TaxRate,OrderStatus,Notes)
VALUES(5315351, 1351, 5, NULL, 5000, 2351, 1231245, NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO RentalOrders(EmployeeId,CustomerId,CarId,TankLevel,KilometrageStart,KilometrageEnd,TotalKilometrage,StartDate,EndDate,TotalDays,RateApplied,TaxRate,OrderStatus,Notes)
VALUES(53453, 643, 3, NULL, 567876, 12323, 3453453, NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO RentalOrders(EmployeeId,CustomerId,CarId,TankLevel,KilometrageStart,KilometrageEnd,TotalKilometrage,StartDate,EndDate,TotalDays,RateApplied,TaxRate,OrderStatus,Notes)
VALUES(7859647, 123, 2, NULL, 12312, 543536, 367787, NULL,NULL,NULL,NULL,NULL,'DELIVERED',NULL)


-- TASK 15
CREATE DATABASE Hotel
USE Hotel

CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50),
	Title nvarchar(50) NOT NULL,
	Notes nvarchar(255)
)

CREATE TABLE Customers
(
	AccountNumber INT PRIMARY KEY IDENTITY(1,1),
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50) NOT NULL,
	PhoneNumber INT,
	EmergencyName nvarchar(255),
	EmergencyNumber INT NOT NULL,
	Notes nvarchar(255)
)

CREATE TABLE RoomStatus
(
	RoomType nvarchar(50) PRIMARY KEY NOT NULL,
	Notes nvarchar(255)
)

CREATE TABLE RoomTypes
(
	RoomType nvarchar(50) PRIMARY KEY NOT NULL,
	Notes nvarchar(255)
)


CREATE TABLE BedTypes
(
	BedType nvarchar(50) PRIMARY KEY NOT NULL,
	Notes nvarchar(255)
)

CREATE TABLE Rooms
(
	RoomNumber INT PRIMARY KEY IDENTITY(1,1),
	RoomType nvarchar(50) NOT NULL,
	BedType nvarchar(50) NOT NULL,
	Rate nvarchar(50),
	RoomStatus nvarchar(50),
	Notes nvarchar(255)
)

CREATE TABLE Payments
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	EmployeeId INT UNIQUE NOT NULL,
	PaymentDate date,
	AccountNumber INT NOT NULL,
	FirstDateOccupied date,
	LastDateOccupied date,
	TotalDays INT NOT NULL,
	AmountCharged INT NOT NULL,
	TaxRate INT,
	TaxAmount INT,
	PaymentTotal INT NOT NULL,
	Notes nvarchar(255)
)

CREATE TABLE Occupancies
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	EmployeeId INT UNIQUE NOT NULL,
	DateOccupied date,
	AccountNumber INT NOT NULL,
	RoomNumber INT NOT NULL,
	RateApplied INT,
	PhoneCharge INT,
	Notes nvarchar(255)
)

INSERT INTO Employees(FirstName,LastName,Title,Notes)
VALUES('Pesho', 'Peshov', 'Software Developer',NULL)
INSERT INTO Employees(FirstName,LastName,Title,Notes)
VALUES('Gosho', 'Peshov', 'Pilot',NULL)
INSERT INTO Employees(FirstName,LastName,Title,Notes)
VALUES('Pesho', 'Petrov', 'Engineer',NULL)

INSERT INTO Customers(FirstName,LastName,PhoneNumber,EmergencyName,EmergencyNumber, Notes)
VALUES('Pesho', 'Peshov', NULL, NULL, 112, NULL)
INSERT INTO Customers(FirstName,LastName,PhoneNumber,EmergencyName,EmergencyNumber, Notes)
VALUES('Pesho', 'Petrov', NULL, NULL, 911, NULL)
INSERT INTO Customers(FirstName,LastName,PhoneNumber,EmergencyName,EmergencyNumber, Notes)
VALUES('Pesho', 'Peshov', NULL, NULL, 912, NULL)

INSERT INTO RoomStatus(RoomType, Notes)
VALUES('Free', NULL)
INSERT INTO RoomStatus(RoomType, Notes)
VALUES('Reserved', NULL)
INSERT INTO RoomStatus(RoomType, Notes)
VALUES('Currently not available', NULL)

INSERT INTO RoomTypes(RoomType,Notes)
VALUES('Luxury', NULL)
INSERT INTO RoomTypes(RoomType,Notes)
VALUES('Standard', NULL)
INSERT INTO RoomTypes(RoomType,Notes)
VALUES('Small', NULL)

INSERT INTO BedTypes(BedType,Notes)
VALUES('LARGE', NULL)
INSERT INTO BedTypes(BedType,Notes)
VALUES('Medium', NULL)
INSERT INTO BedTypes(BedType,Notes)
VALUES('Small', NULL)

INSERT INTO Rooms(RoomType, BedType, Rate,RoomStatus,Notes)
VALUES('Luxury', 'Large', 'Perfect for rich people', 'Available', NULL)
INSERT INTO Rooms(RoomType, BedType, Rate,RoomStatus,Notes)
VALUES('Medium', 'Medium', NULL, 'Not available', NULL)
INSERT INTO Rooms(RoomType, BedType, Rate,RoomStatus,Notes)
VALUES('Economy', 'Small', NULL, 'Available', NULL)

INSERT INTO Payments(EmployeeId,PaymentDate,AccountNumber,FirstDateOccupied,LastDateOccupied,TotalDays,AmountCharged,TaxRate,TaxAmount,PaymentTotal,Notes)
VALUES(231, NULL, 2311, NULL,NULL, 7, 5000, 0,0,5000,NULL)
INSERT INTO Payments(EmployeeId,PaymentDate,AccountNumber,FirstDateOccupied,LastDateOccupied,TotalDays,AmountCharged,TaxRate,TaxAmount,PaymentTotal,Notes)
VALUES(321, NULL, 3211, NULL,NULL, 7, 5000, 0,2000,7000,NULL)
INSERT INTO Payments(EmployeeId,PaymentDate,AccountNumber,FirstDateOccupied,LastDateOccupied,TotalDays,AmountCharged,TaxRate,TaxAmount,PaymentTotal,Notes)
VALUES(999, NULL, 9989, NULL,NULL, 7, 5000, 0,50,5500,NULL)

INSERT INTO Occupancies(EmployeeId,DateOccupied,AccountNumber,RoomNumber,RateApplied,PhoneCharge,Notes)
VALUES(991, NULL, 534, 8, NULL,NULL,NULL)
INSERT INTO Occupancies(EmployeeId,DateOccupied,AccountNumber,RoomNumber,RateApplied,PhoneCharge,Notes)
VALUES(561, NULL, 75, 9, NULL,NULL,NULL)
INSERT INTO Occupancies(EmployeeId,DateOccupied,AccountNumber,RoomNumber,RateApplied,PhoneCharge,Notes)
VALUES(135, NULL, 8, 10, NULL,NULL,NULL)


-- TASK 19
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

-- TASK 20
SELECT * FROM Towns
ORDER BY Name
SELECT * FROM Departments
ORDER BY Name
SELECT * FROM Employees
ORDER BY Salary DESC

-- TASK 21
SELECT Name FROM Towns ORDER BY Name
SELECT Name FROM Departments ORDER BY Name
SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC

-- TASK 22 Increase Employees Salary
UPDATE Employees
SET Salary *= 1.1
SELECT Salary FROM Employees

-- TASK 23 Decrease Tax Rate Hotel Database
UPDATE Payments
SET TaxRate-=TaxRate*3/100
SELECT TaxRate FROM Payments

-- TASK 24
TRUNCATE TABLE Occupancies

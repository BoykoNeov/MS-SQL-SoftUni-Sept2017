-- TASK 1

CREATE TABLE Passports(
ID INT IDENTITY(1,1),
PassportNumber VARCHAR(50),
CONSTRAINT PK_ID PRIMARY KEY (ID)
)

-- INSERT INTO Passports (PassportNumber)
-- VALUES ('4ger443rf')

-- INSERT INTO Passports (PassportNumber)
-- VALUES ('c3e43rf3as')

-- INSERT INTO Passports (PassportNumber)
-- VALUES ('xg22r4vbr9')

CREATE TABLE Persons (
PersonID INT IDENTITY(1,1),
FirstName NVARCHAR(50),
Salary DECIMAL(15,2),
PassportID INT,
CONSTRAINT PK_PersonID PRIMARY KEY (PersonID),
CONSTRAINT FK_PassportID FOREIGN KEY (PassportID) REFERENCES Passports(ID),
CONSTRAINT UQ_PassportID UNIQUE (PassportID)
)

-- INSERT INTO Persons(FirstName, Salary, PassportID)
-- VALUES ('Bace1', 1001, 1)

-- DROP TABLE Passports
-- DROP TABLE Persons

-- SELECT * FROM Passports ; SELECT * FROM Persons

-- TASK 2
CREATE TABLE Manufacturers(
ManufacturerID INT IDENTITY(1,1),
Name VARCHAR(50),
EstablishedOn DATETIME,
CONSTRAINT PK_ManufacturerID PRIMARY KEY (ManufacturerID)
)

CREATE TABLE Models(
ModelID INT IDENTITY(1,1),
Name VARCHAR(50),
ManufacturerID INT,
CONSTRAINT PK_ModelID PRIMARY KEY (ModelID),
CONSTRAINT FK_ManufacturerID FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers(ManufacturerID)
)

-- TASK 3
CREATE TABLE Students(
StudentID INT IDENTITY(1,1),
Name VARCHAR(50),
CONSTRAINT PK_StudentID PRIMARY KEY (StudentID))

CREATE TABLE Exams(
ExamID INT IDENTITY(1,1),
Name VARCHAR(50),
CONSTRAINT PK_ExamID PRIMARY KEY (ExamID))

CREATE TABLE StudentsExams(
StudentID INT,
ExamID INT,
CONSTRAINT PK_StudentID_ExamID PRIMARY KEY (StudentID, ExamID),
CONSTRAINT FK_StudentID FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
CONSTRAINT FK_ExamID FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
)

-- TASK 4
CREATE TABLE Teachers(
TeacherID INT IDENTITY(101,1),
Name VARCHAR(50) NOT NULL,
ManagerID INT,
CONSTRAINT PK_TeacherID PRIMARY KEY (TeacherID),
CONSTRAINT FK_ManagerID FOREIGN KEY (ManagerID) REFERENCES Teachers
)

INSERT INTO Teachers (Name, ManagerID)
VALUES ('John', NULL), ('Maya' , 106) , ('Silvia' , 106) , ('Ted', 105), ('Mark', 101), ('Greta', 101)

-- SELECT * FROM Teachers

-- TASK 5
CREATE TABLE Cities(
CityID INT IDENTITY(1,1) PRIMARY KEY,
Name VARCHAR(50)
)

CREATE TABLE Customers(
CustomerID INT IDENTITY(1,1) PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Birthday DATETIME,
CityID INT FOREIGN KEY REFERENCES Cities
)

CREATE TABLE Orders(
OrderID INT IDENTITY(1,1) PRIMARY KEY,
CustomerID INT FOREIGN KEY REFERENCES Customers
)

CREATE TABLE ItemTypes(
ItemTypeID INT IDENTITY(1,1) PRIMARY KEY,
Name VARCHAR(50)
)

CREATE TABLE Items(
ItemID INT IDENTITY (1,1) PRIMARY KEY,
Name VARCHAR(50),
ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes
)

CREATE TABLE OrderItems(
OrderID INT FOREIGN KEY REFERENCES Orders,
ItemID INT FOREIGN KEY REFERENCES Items,
CONSTRAINT PK_OrderItems PRIMARY KEY (OrderID, ItemID)
)

-- TASK 6
CREATE TABLE Majors(
  MajorID INT PRIMARY KEY,
  Name NVARCHAR(50) NOT NULL,
)

CREATE TABLE Students(
  StudentID INT PRIMARY KEY,
  StudentNumber INT NOT NULL UNIQUE,
  StudentName NVARCHAR(200) NOT NULL,
  MajorID INT,
  CONSTRAINT FK_Students_Majors FOREIGN KEY (MajorID) REFERENCES Majors(MajorID)
)


CREATE TABLE Payments(
  PaymentID INT PRIMARY KEY,
  PaymentDate DATE NOT NULL,
  PaymentAmount MONEY NOT NULL,
  StudentID INT NOT NULL,
  CONSTRAINT FK_Payments_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
)

CREATE TABLE Subjects(
  SubjectID INT PRIMARY KEY,
  SubjectName NVARCHAR(50) NOT NULL,
)

CREATE TABLE Agenda(
  StudentID INT NOT NULL,
  SubjectID INT NOT NULL,
  CONSTRAINT PK_Agenda PRIMARY KEY (StudentID, SubjectID),
  CONSTRAINT FK_Agenda_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  CONSTRAINT FK_Agenda_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
)

-- TASK 9
USE Geography

SELECT MountainRange, PeakName, Elevation
FROM Peaks AS p 
JOIN Mountains AS m ON p.MountainId = m.Id
WHERE MountainRange = 'Rila'
ORDER BY Elevation DESC
USE SoftUni

-- TASK 1
SELECT FirstName, LastName FROM Employees
WHERE FirstName LIKE 'SA%'

-- TASK 2
SELECT FirstName, LastName FROM Employees
WHERE LastName LIKE '%ei%'

-- TASK 3
SELECT FirstName FROM Employees
WHERE (DepartmentID = 3 OR DepartmentID = 10) AND (DATEPART(year, HireDate) >= 1995 OR DATEPART(year, HireDate) <= 2005)

-- TASK 4
SELECT FirstName, LastName FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

-- TASK 5
SELECT Name FROM Towns
WHERE LEN(Name) = 5 OR LEN(NAME) = 6
ORDER BY Name ASC

-- TASK 6
SELECT * FROM Towns
WHERE Name LIKE '[MKBE]%' 
ORDER BY Name ASC

-- TASK 7
SELECT * FROM Towns
WHERE Name LIKE '[^RBD]%' 
ORDER BY Name ASC

-- TASK 8
GO

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName FROM Employees
WHERE DATEPART(Year, HireDate) > 2000

GO
SELECT * FROM V_EmployeesHiredAfter2000

-- TASK 9
SELECT FirstName, LastName FROM Employees
WHERE LEN(LastName) = 5

USE Geography
-- TASK 10
SELECT CountryName, IsoCode FROM Countries
WHERE (LEN(CountryName) - LEN(REPLACE (CountryName, 'a', '')) >= 3)
ORDER BY IsoCode ASC

-- TASK 11
SELECT Peaks.PeakName, Rivers.RiverName, LOWER(CONCAT(LEFT(Peaks.PeakName, LEN(Peaks.PeakName)-1), Rivers.RiverName)) AS Mix
FROM Peaks, Rivers
WHERE (RIGHT(PeakName, 1) = LEFT(RiverName, 1))
ORDER BY Mix ASC

USE Diablo

-- TASK 12
SELECT TOP 50 Name, FORMAT(Start, 'yyyy-MM-dd') AS 'Start'
FROM Games
WHERE YEAR(Start) BETWEEN 2011 AND 2012
ORDER BY Start, Name ASC

-- TASK 13
SELECT Username,
RIGHT(Email, (LEN(Email) - CHARINDEX('@', Email))) AS 'Email Provider'
FROM Users
ORDER BY [Email Provider], Username

-- TASK 14
SELECT Username, IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username ASC

-- TASK 15
SELECT Name,
'Part of the Day' =
CASE 
WHEN DATEPART(Hour, Start) >= 0 AND DATEPART(Hour, Start) < 12 THEN 'Morning'
WHEN DATEPART(Hour, Start) >= 12 AND DATEPART(Hour, Start) < 18 THEN 'Afternoon'
WHEN DATEPART(Hour, Start) >= 18 AND DATEPART(Hour, Start) < 24 THEN 'Evening'
END,
'Duration' =
CASE
WHEN Duration <= 3 THEN 'Extra Short'
WHEN Duration >= 4 AND Duration <= 6 THEN 'Short'
WHEN Duration > 6 THEN 'Long'
WHEN ISNULL(Duration, 1) = 1 THEN 'Extra Long'
END
FROM Games
ORDER BY Name, Duration, [Part of the Day]

USE Orders
-- TASK 16
SELECT ProductName,
OrderDate,
DATEADD(D, 3, OrderDate) AS 'Pay Due',
DATEADD (M, 1, OrderDate) AS 'Deliver Due'
FROM Orders

-- TASK 17
CREATE TABLE People (
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(100),
Birthdate DATETIME2)

INSERT INTO People (Name, Birthdate)
VALUES
('Boyko' , '1984-10-25'),
('Stoyko' , '1943-01-11'),
('Malina' , '1944-07-01')

SELECT Name,
DATEDIFF (YEAR, Birthdate, GETDATE()) AS 'Age in Years',
DATEDIFF (MONTH, Birthdate, GETDATE()) AS 'Age in Monts',
DATEDIFF (DAY, Birthdate, GETDATE()) AS 'Age in Days',
DATEDIFF (MINUTE, Birthdate, GETDATE()) AS 'Age in Minutes'
FROM People
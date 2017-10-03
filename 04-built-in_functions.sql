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
SELECT * FROM Towns
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

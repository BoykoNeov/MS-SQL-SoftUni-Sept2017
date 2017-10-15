USE SoftUni
GO

-- TASK 1

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName, LastName
FROM Employees
WHERE Salary > 35000

GO
/*
usp_GetEmployeesSalaryAbove35000
GO
*/

-- TASK 2
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber @SalaryCeiling DECIMAL(18,4)
AS
SELECT FirstName, LastName
FROM Employees
WHERE Salary >= @SalaryCeiling

/*
GO
usp_GetEmployeesSalaryAboveNumber 40000
*/
GO

-- TASK 3
CREATE PROCEDURE usp_GetTownsStartingWith @FirstLetter VARCHAR(50)
AS
SELECT Name
FROM Towns
WHERE LEFT(Name, LEN(@FirstLetter)) = @FirstLetter

/*
GO
usp_GetTownsStartingWith 'b'
*/
GO

-- TASK 4
CREATE PROCEDURE usp_GetEmployeesFromTown @TownName VARCHAR(50)
AS
SELECT FirstName, LastName
FROM Employees
JOIN Addresses ON Employees.AddressID = Addresses.AddressID
JOIN Towns ON Addresses.TownID = Towns.TownID
WHERE Towns.Name = @TownName

GO
/*
usp_GetEmployeesFromTown 'Sofia'
GO
*/

-- TASK 5
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(7)
AS
BEGIN
DECLARE @level VARCHAR(7)
SET @level =
CASE
   WHEN @salary < 30000 THEN 'Low'
   WHEN @salary >= 30000 AND @salary <= 50000 THEN 'Average'
   WHEN @salary > 50000 THEN 'High'
   END
RETURN @level
END

GO

-- SELECT dbo.ufn_GetSalaryLevel (46756)

-- TASK 6
CREATE PROCEDURE usp_EmployeesBySalaryLevel @SalaryLevel VARCHAR(7)
AS
SELECT FirstName, LastName
FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel

GO
/*
usp_EmployeesBySalaryLevel 'High'
*/

-- TASK 7
 CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50),
 @word VARCHAR(50))
 RETURNS INT
 AS
 BEGIN
 DECLARE @WordLength INT = LEN(@word),
 @CurrentChar INT = 1,
 @Result INT = 1

 WHILE @CurrentChar <= @WordLength
	BEGIN
	IF (CHARINDEX(SUBSTRING(@word,@CurrentChar,1), @setOfLetters, 1) = 0)
		BEGIN
		SET @Result = 0
		BREAK;
		END;
	SET @CurrentChar += 1
	END

 RETURN @Result
 END

-- Test
/*
GO
SELECT dbo.ufn_IsWordComprised('oistmiahf', 'Sofia')
SELECT dbo.ufn_IsWordComprised('oistmiahf', 'halves')
SELECT dbo.ufn_IsWordComprised('bobr', 'Rob')
SELECT dbo.ufn_IsWordComprised('pppp', 'Guy')
*/

GO

-- TASK 8
CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
ALTER TABLE Departments ALTER COLUMN ManagerID INT NULL

DELETE FROM EmployeesProjects
WHERE EmployeeID IN 
(SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

UPDATE Employees SET ManagerID = NULL
WHERE ManagerID IN (SELECT EmployeeID FROM Employees
	WHERE DepartmentID = @departmentId)

UPDATE Departments SET ManagerID = NULL
WHERE ManagerID IN (SELECT EmployeeID FROM Employees
	WHERE DepartmentID = @departmentId) 

DELETE FROM Employees
WHERE DepartmentID = @departmentId
DELETE FROM Departments
WHERE DepartmentID = @departmentId

SELECT COUNT(*) AS [Employees Count] FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID
WHERE e.DepartmentID = @departmentId

--
GO
USE Bank
GO

-- TASK 9
CREATE PROCEDURE usp_GetHoldersFullName
AS
SELECT FirstName + ' ' + LastName FROM AccountHolders


GO
-- TEST
usp_GetHoldersFullName
GO

-- TASK 10
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan @money DECIMAL(18,4)
AS
BEGIN

WITH cte_HoldersAboveLimit (TotalSumPerHolder, AccountHolderID) AS (
SELECT SUM (Balance), AccountHolderId FROM Accounts
GROUP BY AccountHolderId
HAVING SUM(Balance) > @money
)

SELECT FirstName, LastName FROM AccountHolders
JOIN cte_HoldersAboveLimit ON AccountHolders.Id = cte_HoldersAboveLimit.AccountHolderID
ORDER BY LastName, FirstName
END

---------------
-- ALTERNATIVE FROM GITHUB (name of procedure changed for testing)
---------------

GO  -- DO NOT SUBMIT IN JUDGE "Go"
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThana (@minBalance money)
AS
BEGIN
  WITH CTE_MinBalanceAccountHolders (HolderId) AS (
    SELECT AccountHolderId FROM Accounts
    GROUP BY AccountHolderId
    HAVING SUM(Balance) > @minBalance
  )

  SELECT ah.FirstName AS [First Name], ah.LastName AS [Last Name]
  FROM CTE_MinBalanceAccountHolders AS minBalanceHolders 
  JOIN AccountHolders AS ah ON ah.Id = minBalanceHolders.HolderId
  ORDER BY ah.LastName, ah.FirstName 

END

-- testing - do not submit in Judge
EXEC usp_GetHoldersWithBalanceHigherThana 6000000;
EXEC usp_GetHoldersWithBalanceHigherThana 5000000;

EXEC usp_GetHoldersWithBalanceHigherThan 6000000;
EXEC usp_GetHoldersWithBalanceHigherThan 5000000;

EXEC usp_GetHoldersWithBalanceHigherThana 1000;
EXEC usp_GetHoldersWithBalanceHigherThan 1000;
GO

-- TASK 11
CREATE FUNCTION ufn_CalculateFutureValue (@sum DECIMAL (18,2), @interestRate FLOAT,
@numberOfYears INT)
RETURNS money
AS
BEGIN
DECLARE @result money
SET @result = @sum * POWER((1 + @interestRate), @numberOfYears)
RETURN @result
END

-- Test
-- DROP FUNCTION ufn_CalculateFutureValue
GO
SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)
GO

-- TASK 12
CREATE PROCEDURE usp_CalculateFutureValueForAccount (@AccId INT, @interestRate FLOAT)
AS
BEGIN
DECLARE @FutureMoney money = 0, @currentMoney money, @CurrentAccHolderId INT

SET @currentMoney = (SELECT Balance FROM Accounts
WHERE Accounts.Id = @AccId)
SET @CurrentAccHolderId = (SELECT AccountHolderId FROM Accounts
WHERE Accounts.Id = @AccId)

SET @FutureMoney = dbo.ufn_CalculateFutureValue(@currentMoney, @interestRate, 5)

SELECT @AccId, FirstName, LastName, @currentMoney, @FutureMoney 
FROM AccountHolders
WHERE AccountHolders.Id = @CurrentAccHolderId
END

GO
-- DROP PROCEDURE usp_CalculateFutureValueForAccount
usp_CalculateFutureValueForAccount 1, 0.1
GO
-- TASK 13
USE DIABLO
GO

CREATE OR ALTER FUNCTION ufn_CashInUsersGames (@GameName VARCHAR(50))
RETURNS MONEY
BEGIN
DECLARE @Result MONEY
RETURN 5
END

GO

DECLARE @SearchedGameID VARCHAR(50)
SET @SearchedGameID = (SELECT Games.Id FROM GAMES
WHERE Games.Name = 'Love in a mist')

SELECT * FROM UsersGames
WHERE GameId = @SearchedGameID

-- SELECT * FROM UsersGames WHERE GameID = 48

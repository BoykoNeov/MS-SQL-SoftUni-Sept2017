USE Bank
GO
-- TASK 1
CREATE TABLE Logs(
LogId INT PRIMARY KEY IDENTITY(1,1),
AccountID INT NOT NULL,
OldSum INT NOT NULL,
NewSum INT NOT NULL
)

-- SELECT * FROM Accounts
GO

CREATE TRIGGER tr_AccountsUpdate ON Accounts
FOR UPDATE
AS
BEGIN
DECLARE @AccountID INT, @OldBalance MONEY, @NewBalance MONEY
SET @AccountID = (SELECT Id FROM deleted)
SET @OldBalance = (SELECT Balance FROM deleted)
SET @NewBalance = (SELECT Balance FROM inserted)
INSERT INTO Logs VALUES (@AccountID, @OldBalance, @NewBalance)
END

--TASK 2
-- DROP TABLE NotificationEmails
CREATE TABLE NotificationEmails(
Id INT PRIMARY KEY IDENTITY(1,1),
Recipient NVARCHAR(200),
Subject NVARCHAR(255),
Body NVARCHAR(MAX)
)

GO
-- DROP TRIGGER tr_LogsUpdate
CREATE TRIGGER tr_LogsUpdate ON Logs
FOR INSERT
AS
BEGIN
DECLARE @Recipient NVARCHAR(200), @Subject NVARCHAR(255), @Body NVARCHAR (500),
@DateTime NVARCHAR(120)

SET @Recipient = (SELECT AccountID FROM inserted)
SET @Subject = CONCAT('Balance change for account: ', @Recipient)
SET @DateTime = (SELECT LEFT(CONVERT(NVARCHAR, GETDATE(), 120), 10))

SET @Body = CONCAT('On ', @DateTime, ' your balance was changed from ' ,
(SELECT OldSum FROM inserted), ' to ', (SELECT NewSum FROM inserted))

INSERT INTO NotificationEmails (Recipient, Subject, Body) 
VALUES (@Recipient, @Subject, @Body)
END

--test
INSERT INTO Logs (AccountID, NewSum, OldSum)
VALUES (27, 160, 100)

-- TASK 3
-- SELECT * FROM Accounts
GO


CREATE PROCEDURE usp_DepositMoney @AccountID MONEY, @MoneyAmount MONEY
AS
BEGIN
	BEGIN TRANSACTION
	UPDATE Accounts
		SET Balance += @MoneyAmount
		WHERE Id = @AccountID

		IF(@@ROWCOUNT <> 1)
			BEGIN
			RAISERROR ('Ivalid account', 16 ,1)
			ROLLBACK
			RETURN
			END
	COMMIT
END

GO

-- TASK 4
CREATE PROCEDURE usp_WithdrawMoney @AccountID MONEY, @MoneyAmount MONEY
AS
BEGIN
	BEGIN TRANSACTION
	DECLARE @CurrentAmount MONEY = (SELECT Balance FROM Accounts
	WHERE Id = @AccountID)

	UPDATE Accounts
		SET Balance -= @MoneyAmount
		WHERE Id = @AccountID

		IF(@@ROWCOUNT <> 1 OR (@CurrentAmount - @MoneyAmount < 0))
			BEGIN
			RAISERROR ('Ivalid account or sum', 16 ,1)
			ROLLBACK
			RETURN
			END
	COMMIT
END

GO

-- TASK 5
CREATE PROCEDURE usp_TransferMoney (@SenderId INT, @ReceiverId INT, @Amount MONEY)
AS
BEGIN
		EXEC usp_WithdrawMoney @SenderId, @Amount
		EXEC usp_DepositMoney @ReceiverId, @Amount
END

GO

-- TASK 7 FROM GITHUB
USE Diablo

--07. *Massive Shopping
DECLARE @gameName nvarchar(50) = 'Safflower';
DECLARE @username nvarchar(50) = 'Stamat';

DECLARE @userGameId int = (
  SELECT ug.Id 
  FROM UsersGames AS ug
  JOIN Users AS u ON ug.UserId = u.Id
  JOIN Games AS g ON ug.GameId = g.Id
  WHERE u.Username = @username AND g.Name = @gameName

);

DECLARE @userGameLevel int = (SELECT Level FROM UsersGames WHERE Id = @userGameId);
DECLARE @itemsCost money, @availableCash money, @minLevel int, @maxLevel int;



-- Buy items from LEVEL 11-12
SET @minLevel = 11; SET @maxLevel = 12;
SET @availableCash = (SELECT Cash FROM UsersGames WHERE Id = @userGameId);
SET @itemsCost = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel);



/* begin transaction only if: enough game cash to buy all requested items & 
   high enough user game level to meet item minlevel requirement */

IF (@availableCash >= @itemsCost AND @userGameLevel >= @maxLevel) 

BEGIN 
  BEGIN TRANSACTION  
  UPDATE UsersGames SET Cash -= @itemsCost WHERE Id = @userGameId; 
  IF(@@ROWCOUNT <> 1) 
  BEGIN
    ROLLBACK; RAISERROR('Could not make payment', 16, 1); --RETURN;
  END

  ELSE
  BEGIN

    INSERT INTO UserGameItems (ItemId, UserGameId) 
    (SELECT Id, @userGameId FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) 

    IF((SELECT COUNT(*) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) <> @@ROWCOUNT)
    BEGIN
      ROLLBACK; RAISERROR('Could not buy items', 16, 1); --RETURN;
    END	

    ELSE COMMIT;

  END

END



-- Buy items from LEVEL 19-21
SET @minLevel = 19; SET @maxLevel = 21;
SET @availableCash = (SELECT Cash FROM UsersGames WHERE Id = @userGameId);
SET @itemsCost = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel);

/* begin transaction only if: enough game cash to buy all requested items & 
   high enough user game level to meet item minlevel requirement */

IF (@availableCash >= @itemsCost AND @userGameLevel >= @maxLevel) 

BEGIN 
  BEGIN TRANSACTION  
  UPDATE UsersGames SET Cash -= @itemsCost WHERE Id = @userGameId; 

  IF(@@ROWCOUNT <> 1) 
  BEGIN
    ROLLBACK; RAISERROR('Could not make payment', 16, 1); --RETURN;
  END

  ELSE
  BEGIN

    INSERT INTO UserGameItems (ItemId, UserGameId) 
    (SELECT Id, @userGameId FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) 

    IF((SELECT COUNT(*) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) <> @@ROWCOUNT)
    BEGIN
      ROLLBACK; RAISERROR('Could not buy items', 16, 1); --RETURN;
    END	

    ELSE COMMIT;
  END

END

-- select items in game
SELECT i.Name AS [Item Name]
FROM UserGameItems AS ugi
JOIN Items AS i ON i.Id = ugi.ItemId
JOIN UsersGames AS ug ON ug.Id = ugi.UserGameId
JOIN Games AS g ON g.Id = ug.GameId
WHERE g.Name = @gameName
ORDER BY [Item Name]

GO
--TASK 8
USE SoftUni
GO

CREATE PROCEDURE usp_AssignProject (@employeeId INT, @projectID INT)
AS
BEGIN

	BEGIN TRANSACTION
	
	INSERT INTO EmployeesProjects (EmployeeID, ProjectID)
	VALUES (@employeeId, @projectID)

	IF (
	(SELECT COUNT(*)
	FROM EmployeesProjects
	WHERE EmployeeID = @employeeId)
	 > 3)
	 BEGIN
	 ROLLBACK
	 RAISERROR ('The employee has too many projects!', 16, 1)
	 RETURN
	 END
	
	COMMIT

END

GO

-- TASK 9
-- DROP TABLE Deleted_Employees
CREATE TABLE Deleted_Employees (
EmployeeId INT PRIMARY KEY,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
MiddleName NVARCHAR(50) NULL,
JobTitle NVARCHAR(255) NOT NULL,
DepartmentId INT NOT NULL,
Salary MONEY NOT NULL
)

-- SELECT * FROM Employees
GO

--DROP TRIGGER tr_DeleteEmployee
CREATE TRIGGER tr_DeleteEmployee ON Employees
FOR DELETE
AS
BEGIN

INSERT INTO Deleted_Employees (--EmployeeId,
FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary)
SELECT --EmployeeID,
FirstName, LastName, MiddleName, JobTitle, DepartmentID, Salary
FROM deleted

END

--DELETE FROM Employees
--WHERE EmployeeID > 3 AND EmployeeID < 10

--SELECT * FROM Deleted_Employees
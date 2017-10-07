USE Gringotts

-- TASK 1
SELECT COUNT(Id) AS 'Count'
FROM WizzardDeposits

-- TASK 2
SELECT MAX(MagicWandSize) AS 'LongestMagicWand'
FROM WizzardDeposits

-- TASK 3
SELECT DepositGroup, MAX(MagicWandSize) AS 'LongestMagicWand'
FROM WizzardDeposits
GROUP BY DepositGroup

-- TASK 4
SELECT TOP 2 DepositGroup FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

-- TASK 5
SELECT DepositGroup, SUM(DepositAmount) 
FROM WizzardDeposits
GROUP BY DepositGroup

-- TASK 6
SELECT DepositGroup, SUM(DepositAmount) 
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

-- TASK 7 
SELECT DepositGroup, SUM(DepositAmount) 
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY SUM(DepositAmount) DESC

-- TASK 8
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup ASC

-- TASK 9
SELECT AgeGroup, COUNT(*) FROM
(
  SELECT CASE 
    WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
    WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
    WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
    WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
    WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
    WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
    WHEN Age > 60 THEN '[61+]'
  END
  AS 'AgeGroup'
  FROM WizzardDeposits) 
AS AgeGroups
GROUP BY AgeGroups.AgeGroup

-- TASK 10
SELECT DISTINCT LEFT(FirstName, 1) AS FirstLetter
FROM WizzardDeposits
GROUP BY DepositGroup, FirstName
HAVING DepositGroup = 'Troll Chest'

--TASK 11
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) FROM WizzardDeposits
WHERE DATEPART(YEAR, DepositStartDate) > 1984
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired ASC

--TASK 12
-- SELECT '44393.97'
SELECT SUM(Result.Difference) FROM
(
SELECT DepositAmount - LEAD(DepositAmount) OVER (ORDER BY Id) AS Difference  FROM WizzardDeposits
) AS Result

USE SoftUni

-- TASK 13
SELECT DepartmentID, SUM(Salary) FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID ASC

-- TASK 14
SELECT DepartmentID, MIN(Salary) FROM Employees
WHERE (DepartmentID = 2 OR DepartmentID = 5 OR DepartmentID = 7) AND DATEPART(YEAR, HireDate) > 1999
GROUP BY DepartmentID

-- TASK 15
SELECT * INTO NewTable FROM Employees
WHERE Salary > 30000

DELETE FROM NewTable
WHERE ManagerID = 42

UPDATE NewTable
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) FROM NewTable
GROUP BY DepartmentID

-- TASK 16
SELECT DepartmentID, MAX(Salary) AS 'MaxSalary' FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-- TASK 17
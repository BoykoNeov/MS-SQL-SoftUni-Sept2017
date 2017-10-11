USE SoftUni
--

-- TASK 1
SELECT TOP 5 EmployeeID, JobTitle, e.AddressID, a.AddressText
FROM Employees AS e
INNER JOIN Addresses AS a ON e.AddressID = a.AddressID
ORDER BY e.AddressID ASC

-- TASK 2
SELECT TOP 50 FirstName, LastName, t.Name, AddressText
FROM Employees AS e
INNER JOIN Addresses AS a ON e.AddressID = a.AddressID
INNER JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY e.FirstName ASC, e.LastName DESC

-- TASK 3
SELECT EmployeeID, FirstName, LastName, d.Name
FROM Employees as e
INNER JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ORDER BY EmployeeID ASC

-- TASK 4
SELECT TOP 5
e.EmployeeID, e.FirstName, e.Salary, d.Name
FROM Employees AS e
INNER JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
WHERE Salary > 15000
ORDER BY e.DepartmentID ASC

-- TASK 5
SELECT TOP 3 EmployeeID, FirstName
FROM Employees as e
WHERE NOT EXISTS (SELECT NULL FROM EmployeesProjects AS ep
WHERE ep.EmployeeID = e.EmployeeID)
ORDER BY EmployeeID ASC

-- alternative
SELECT TOP 3 EmployeeID, FirstName
FROM Employees AS e
WHERE e.EmployeeID NOT IN (SELECT EmployeeID FROM EmployeesProjects)
ORDER BY EmployeeID ASC

-- alternative with JOIN
SELECT TOP 3 e.EmployeeID, FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep
ON e.EmployeeID = ep.EmployeeID
WHERE ep.EmployeeID IS NULL
ORDER BY EmployeeID ASC

-- TASK 6
SELECT FirstName, LastName, HireDate, d.Name FROM Employees as e
INNER JOIN Departments as d
ON e.DepartmentID = d.DepartmentID
WHERE (d.Name = 'Sales' OR d.Name = 'Finance')
AND e.HireDate > 1998
ORDER BY e.HireDate ASC

-- TASK 7
SELECT TOP 5 e.EmployeeID, e.FirstName, p.Name FROM Employees AS e
INNER JOIN EmployeesProjects AS ep
ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects AS p
ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > '20020813' AND p.EndDate IS NULL
ORDER BY e.EmployeeID ASC

-- TASK 8
SELECT e.EmployeeID, e.FirstName,  
IIF(p.StartDate > '2005-01-01', NULL, p.Name)
AS ProjectName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep
ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Projects AS p
ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24

-- TASK9 
SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName
FROM Employees AS e
JOIN Employees AS m
ON m.EmployeeID = e.ManagerID
WHERE e.ManagerID = 3 OR e.ManagerID = 7
ORDER BY e.EmployeeID ASC

-- TASK 10
SELECT
TOP 50
e.EmployeeID,
(e.FirstName + ' ' + e.LastName) AS EmployeeName,
(m.FirstName + ' ' + m.LastName) AS ManagerName,
d.Name AS DepartmentName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID ASC

-- TASK 11
SELECT TOP 1 AVG(e.Salary) AS MinAverageSalary
FROM Employees AS e
GROUP BY e.DepartmentID
ORDER BY MinAverageSalary ASC

--
USE Geography
--

-- TASK 12
SELECT
 mc.CountryCode, m.MountainRange, p.PeakName, p.Elevation
FROM Peaks AS p
JOIN Mountains AS m ON m.Id = p.MountainId
JOIN MountainsCountries AS mc ON m.Id = mc.MountainId
WHERE p.Elevation > 2835 AND mc.CountryCode = 'BG'
ORDER BY p.Elevation DESC

-- TASK 13
SELECT mc.CountryCode, COUNT(mc.MountainId)
FROM Mountains AS m
JOIN MountainsCountries AS mc ON m.Id = mc.MountainId
JOIN Countries AS c ON c.CountryCode = mc.CountryCode
WHERE c.CountryName IN ('United States' , 'Russia' , 'Bulgaria')
GROUP BY mc.CountryCode

-- TASK 14
SELECT TOP 5
c.CountryName, r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName ASC

-- TASK 15
WITH CCYContUsage_CTE (ContinentCode, CurrencyCode, CurrencyUsage) AS (
  SELECT ContinentCode, CurrencyCode, COUNT(CountryCode) AS CurrencyUsage
  FROM Countries 
  GROUP BY ContinentCode, CurrencyCode
  HAVING COUNT(CountryCode) > 1  
)
SELECT ContMax.ContinentCode, ccy.CurrencyCode, ContMax.CurrencyUsage 
  FROM
  (SELECT ContinentCode, MAX(CurrencyUsage) AS CurrencyUsage
   FROM CCYContUsage_CTE 
   GROUP BY ContinentCode) AS ContMax
JOIN CCYContUsage_CTE AS ccy 
ON (ContMax.ContinentCode = ccy.ContinentCode AND ContMax.CurrencyUsage = ccy.CurrencyUsage)
ORDER BY ContMax.ContinentCode 

-- TASK 16
SELECT COUNT(CountryCode) AS CountryCode FROM Countries as c
WHERE c.CountryCode NOT IN (SELECT CountryCode FROM MountainsCountries)

-- Alternative
SELECT
COUNT(c.CountryCode) AS CountryCode
FROM Countries AS c
LEFT JOIN MountainsCountries AS m ON c.CountryCode = m.CountryCode
WHERE m.MountainId IS NULL

-- TASK 17
SELECT TOP 5
CountryName,
MAX(p.Elevation) AS HighestPeakElevation,
MAX(r.Length) AS LongestRiverLength
FROM Countries AS c
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
JOIN Peaks as p ON p.MountainId = mc.MountainId
JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
JOIN Rivers AS r ON r.Id = cr.RiverId
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName

-- TASK 18

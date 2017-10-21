CREATE DATABASE WMS
USE WMS

-- DROP DATABASE WMS

--TASK 1
CREATE TABLE Clients (
ClientId INT PRIMARY KEY IDENTITY(1,1),
FirstName VARCHAR(50),
LastName VARCHAR(50),
Phone VARCHAR(12),
CONSTRAINT cs_PhoneLength CHECK (LEN(Phone) = 12)
)

CREATE TABLE Mechanics (
MechanicId INT PRIMARY KEY IDENTITY(1,1),
FirstName VARCHAR(50),
LastName VARCHAR(50),
Address VARCHAR(255)
)

CREATE TABLE Vendors (
VendorId INT PRIMARY KEY IDENTITY (1,1),
Name VARCHAR(50) UNIQUE
)

CREATE TABLE Models (
ModelId INT PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(50) UNIQUE
)

CREATE TABLE Parts (
PartId INT PRIMARY KEY IDENTITY (1,1),
SerialNumber VARCHAR(50) UNIQUE,
Description VARCHAR(50) NULL,
Price MONEY,
CONSTRAINT cs_PriceLimit CHECK (Price <=9999.99 AND Price > 0),
VendorId INT FOREIGN KEY REFERENCES Vendors(VendorId),
StockQty INT DEFAULT (0),
CONSTRAINT cs_PositiveQuantity CHECK (StockQty >= 0)
)

CREATE TABLE Jobs (
JobId INT PRIMARY KEY IDENTITY(1,1),
ModelId INT FOREIGN KEY REFERENCES Models(ModelId),
Status VARCHAR(11) DEFAULT ('Pending'),
CONSTRAINT cs_StatusIsAllowed CHECK (Status IN ('Pending', 'In Progress', 'Finished')),
ClientId INT FOREIGN KEY REFERENCES Clients(ClientId),
MechanicId INT NULL FOREIGN KEY REFERENCES Mechanics(MechanicId),
IssueDate DATE,
FinishDate DATE NULL
)

CREATE TABLE Orders (
OrderId INT PRIMARY KEY IDENTITY (1,1),
JobId INT FOREIGN KEY REFERENCES Jobs(JobId),
IssueDate DATE NULL,
Delivered BIT DEFAULT ('False')
)

CREATE TABLE OrderParts (
OrderId INT FOREIGN KEY REFERENCES Orders(OrderId),
PartId INT FOREIGN KEY REFERENCES Parts(PartId),
Quantity INT DEFAULT 1,
CONSTRAINT cs_QuantityIsPositive CHECK (Quantity > 0),
CONSTRAINT fk_OrdersAndParts PRIMARY KEY (OrderId, PartId)
)

CREATE TABLE PartsNeeded (
JobId INT FOREIGN KEY REFERENCES Jobs(JobId),
PartId INT FOREIGN KEY REFERENCES Parts(PartId),
Quantity INT DEFAULT 1,
CONSTRAINT cs_QuantityIsPositive_PN CHECK (Quantity > 0),
CONSTRAINT fk_JobsAndParts PRIMARY KEY (JobId, PartId)
)

-- TASK 2
--Clients
INSERT INTO Clients (FirstName, LastName, Phone)
VALUES
('Teri', 'Ennaco' , '570-889-5187'),
('Merlyn' , 'Lawler' ,'201-588-7810'),
('Georgene', 'Montezuma', '925-615-5185'),
('Jettie', 'Mconnell', '908-802-3564'),
('Lemuel' ,'Latzke', '631-748-6479'),
('Melodie',	'Knipp', '805-690-1682'),
('Candida', 'Corbley' ,'908-275-8357')

-- Parts
INSERT INTO Parts (SerialNumber, Description, Price, VendorId)
VALUES
('WP8182119','Door Boot Seal',117.86, 2),
('W10780048', 'Suspension Rod',	42.81, 1),
('W10841140', 'Silicone Adhesive', 6.77, 4),
('WPY055980', 'High Temperature Adhesive', 13.94 , 3)

-- TASK 3
UPDATE Jobs
SET MechanicId = 3
WHERE Status = 'Pending' AND MechanicId IS NULL

UPDATE Jobs
SET Status = 'In Progress'
WHERE MechanicId=3 AND Status='Pending'

-- TASK 4
DELETE FROM OrderParts
WHERE OrderId = 19
DELETE FROM Orders
WHERE OrderId = 19

-- TASK 5
SELECT FirstName, LastName, Phone FROM Clients
ORDER BY LastName ASC, ClientId DESC

-- TASK 6
SELECT Status, IssueDate FROM Jobs
WHERE Status != 'Finished'
ORDER BY IssueDate ASC, JobId ASC

-- TASK 7
SELECT CONCAT(Mechanics.FirstName,' ', Mechanics.LastName) AS Mechanic,
Jobs.Status,
IssueDate
FROM Mechanics
JOIN Jobs ON Jobs.MechanicId = Mechanics.MechanicId
ORDER BY Mechanics.MechanicId ASC, Jobs.IssueDate ASC, Jobs.JobId ASC

-- TASK 8
SELECT CONCAT (Clients.FirstName, ' ', Clients.LastName) AS Client,
DATEDIFF(DAY, Jobs.IssueDate, '20170424') AS Daysgoing,
Jobs.Status
FROM Clients
JOIN Jobs ON Clients.ClientId = Jobs.ClientId
WHERE Jobs.Status != 'Finished'
ORDER BY Daysgoing DESC, Jobs.ClientId ASC

-- TASK 9
SELECT CONCAT(Mechanics.FirstName, ' ', Mechanics.LastName) AS Mechanic,
AVG(DATEDIFF(DAY, Jobs.IssueDate, Jobs.FinishDate)) AS AverageDays
FROM Mechanics
JOIN Jobs ON Jobs.MechanicId = Mechanics.MechanicId
WHERE Jobs.Status='Finished'
GROUP BY Mechanics.FirstName, LastName, Mechanics.MechanicId
ORDER BY Mechanics.MechanicId ASC

-- TASK 10
SELECT TOP 3 CONCAT(Mechanics.FirstName, ' ', Mechanics.LastName) AS Mechanic,
COUNT(*) AS Jobs
FROM Mechanics
JOIN Jobs ON Jobs.MechanicId = Mechanics.MechanicId
WHERE Jobs.Status!='Finished'
GROUP BY Mechanics.FirstName, LastName, Mechanics.MechanicId
HAVING COUNT(*) > 1
ORDER BY Jobs DESC, Mechanics.MechanicId ASC

-- TASK 11
SELECT CONCAT(Mechanics.FirstName, ' ', Mechanics.LastName) AS Available
FROM Mechanics
WHERE 
Mechanics.MechanicId NOT IN
(
SELECT Mechanics.MechanicId FROM Mechanics
JOIN Jobs ON Jobs.MechanicId = Mechanics.MechanicId
WHERE Jobs.Status = 'Pending' OR Jobs.Status = 'In Progress')
ORDER BY Mechanics.MechanicId ASC

-- TASK 12
SELECT ISNULL(SUM(PartsPrice),0) AS PartsTotal
FROM
(SELECT SUM(Parts.Price) * OrderParts.Quantity AS PartsPrice
FROM Parts
JOIN OrderParts ON Parts.PartId = OrderParts.PartId
JOIN Orders ON Orders.OrderId = OrderParts.OrderId
WHERE (DATEDIFF(WEEK, Orders.IssueDate, '20170427')) <= 3
GROUP BY Parts.PartId, OrderParts.Quantity) as a

-- TASK 13
SELECT Jobs.JobId,
ISNULL(SUM(Parts.Price * OrderParts.Quantity),0) AS Total
FROM Jobs
FULL JOIN Orders ON Jobs.JobId = Orders.JobId
FULL JOIN OrderParts ON OrderParts.OrderId = Orders.OrderId
FULL JOIN Parts ON Parts.PartId = OrderParts.PartId
WHERE Jobs.Status = 'Finished'
GROUP BY Jobs.JobId
ORDER BY Total DESC, Jobs.JobId ASC

-- TASK 14
SELECT m.ModelId, 
	   m.Name, 
	   CAST(AVG(DATEDIFF(DAY, j.IssueDate, j.FinishDate))AS VARCHAR(10)) + ' ' + 'days' AS [Average Service Time]
FROM Models AS m
JOIN Jobs AS j ON j.ModelId = m.ModelId
GROUP BY m.ModelId, m.Name
ORDER BY CAST(AVG(DATEDIFF(DAY, j.IssueDate, j.FinishDate))AS VARCHAR(10)) + ' ' + 'days'

-- TASK 15
SELECT TOP 1 WITH TIES m.Name, COUNT(*) AS [Times Serviced],
(SELECT ISNULL(SUM(p.Price * op.Quantity),0) FROM Jobs AS j
JOIN Orders AS o ON O.JobId = j.JobId
JOIN OrderParts AS op ON op.OrderId = o.OrderId
JOIN Parts AS p ON p.[PartId] = op.PartId
WHERE j.ModelId = m.ModelId) AS [Parts Total]
 FROM Models AS m
JOIN Jobs AS j ON j.ModelId = m.ModelId
GROUP BY m.ModelId, m.Name
ORDER BY [Times Serviced] DESC

-- TASK 16
SELECT 
	p.PartId,
	p.[Description],
	SUM(pn.Quantity) AS [Required],
	AVG(p.StockQty) AS [In Stock],
	ISNULL(SUM(op.Quantity),0) AS [Ordered]
FROM Parts AS p
JOIN PartsNeeded AS pn ON pn.PartId = p.PartId
JOIN Jobs AS j ON j.JobId = pn.JobId
LEFT JOIN Orders AS o ON o.JobId = j.JobId
LEFT JOIN OrderParts AS op ON op.OrderId = o.OrderId
WHERE j.Status <> 'Finished'
GROUP BY p.PartId, p.Description
HAVING SUM(pn.Quantity) > AVG(p.StockQty) + ISNULL(SUM(op.Quantity),0)
ORDER BY p.PartId

GO

-- TASK 17
CREATE FUNCTION udf_GetCost (@JobId INT)
RETURNS DECIMAL(6,2)
AS
BEGIN
	DECLARE @TotalSum DECIMAL(6,2) = 
(SELECT ISNULL(SUM(p.Price * op.Quantity),0) FROM Parts AS p
JOIN OrderParts AS op ON op.PartId = p.PartId
JOIN Orders AS o ON o.OrderId = op.OrderId
JOIN Jobs AS j ON j.JobId = o.JobId
WHERE j.JobId = @JobId)

RETURN @TotalSum

END

GO
-- TASK 18
CREATE PROC usp_PlaceOrder @JobId INT, @SerialNumber VARCHAR(50), @Quantity INT
AS
BEGIN
	IF(@Quantity <=0)
	BEGIN
		RAISERROR('Part quantity must be more than zero!', 16, 1)
		RETURN;
	END

	DECLARE @JobIdSelect INT = (SELECT JobId FROM Jobs WHERE JobId = @JobId)

	IF(@JobIdSelect IS NULL)
	BEGIN
		RAISERROR('Job not found!', 16, 1)
	END

	DECLARE @JobStatus VARCHAR(50) = (SELECT Status FROM Jobs WHERE JobId = @JobId)
	IF(@JobStatus = 'Finished')
	BEGIN
		RAISERROR('This job is not active!', 16, 1)
	END

	DECLARE @PartId INT = (SELECT PartId FROM Parts WHERE SerialNumber = @SerialNumber)
	IF(@PartId IS NULL)
	BEGIN
		RAISERROR('Part not found!', 16, 1)
		RETURN;
	END

	DECLARE @OrderId INT = (SELECT o.OrderId FROM Orders AS o
							JOIN OrderParts AS op ON op.OrderId = o.OrderId
							JOIN Parts AS p ON p.PartId = op.PartId
							WHERE JobId = @JobId AND p.PartId = @PartId AND IssueDate IS NULL)
	
	IF(@OrderId IS NULL)
	BEGIN
	INSERT INTO Orders(JobId, IssueDate) VALUES
	(@JobId, NULL)

	INSERT INTO OrderParts(OrderId, PartId, Quantity) VALUES
	(IDENT_CURRENT('Orders'), @PartId, @Quantity)
	END

	ELSE
	BEGIN
		DECLARE @PartExistanceOrder INT = (SELECT @@ROWCOUNT FROM OrderParts WHERE OrderId = @OrderId AND PartId = @PartId)

		IF(@PartExistanceOrder IS NULL)
		BEGIN
			INSERT INTO OrderParts(OrderId, PartId, Quantity) VALUES
			(@OrderId, @PartId, @Quantity)
		END

		ELSE
		BEGIN
			UPDATE OrderParts
			SET Quantity += @Quantity
			WHERE OrderId = @OrderId AND PartId = @PartId
		END
	END
END

-- TASK 19
CREATE TRIGGER tr_OrderDeliver ON Orders AFTER UPDATE
AS
BEGIN

	DECLARE @OldStatus INT = (SELECT Delivered from deleted)
	DECLARE @NewStatus INT = (SELECT Delivered from inserted)

	IF(@OldStatus = 0 AND @NewStatus = 1)
	BEGIN
		UPDATE Parts
		SET StockQty += op.Quantity
		FROM Parts AS p
		JOIN OrderParts AS op ON op.PartId = p.PartId
		JOIN Orders AS o ON o.OrderId = op.OrderId
		JOIN inserted AS i ON i.OrderId = o.OrderId
		JOIN deleted AS d ON d.OrderId = i.OrderId
		
	END
END

-- TASK 20
WITH CTE_Parts
AS
(
	SELECT m.MechanicId,
		   v.VendorId,
		   SUM(op.Quantity) AS VendorItems
	 FROM Mechanics AS m
	JOIN Jobs AS j ON j.MechanicId = m.MechanicId
	JOIN Orders AS o ON o.JobId = j.JobId
	JOIN OrderParts AS op ON op.OrderId = o.OrderId
	JOIN Parts AS p ON p.PartId = op.PartId
	JOIN Vendors AS v ON v.VendorId = P.VendorId
	GROUP BY m.MechanicId, v.VendorId
)

SELECT CONCAT(m.FirstName, ' ', m.LastName) AS [Mechanic],
	   v.Name AS [Vendor],
	   c.VendorItems AS [Parts],
	   CAST(CAST(CAST(VendorItems AS DECIMAL(6,2)) / (SELECT SUM(VendorItems) FROM CTE_Parts WHERE MechanicId = c.MechanicId) * 100 AS INT) AS VARCHAR(MAX)) + '%' AS Preference
	FROM CTE_Parts AS c
JOIN Mechanics AS m ON m.MechanicId = c.MechanicId
JOIN Vendors AS v ON v.VendorId = c.VendorId
ORDER BY Mechanic, Parts DESC, Vendor
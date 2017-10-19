-- TASK 1
SELECT Domaines AS EmailProvider, COUNT(Domaines) AS NumberOfUsers
FROM
(SELECT SUBSTRING(Email, CHARINDEX('@', Email) + 1, 100) AS Domaines
FROM Users
) AS subquery
GROUP BY Domaines
ORDER BY NumberOfUsers DESC, Domaines

-- TASK 2
SELECT 
Games.Name AS 'Game',
 GameTypes.Name AS GameType,
  Users.Username,
   UsersGames.Level,
    UsersGames.Cash,
	 Characters.Name AS Character
FROM UsersGames
JOIN Users ON UsersGames.UserId = Users.Id
JOIN Games ON Games.Id = UsersGames.GameId
JOIN GameTypes ON Games.GameTypeId = GameTypes.Id
JOIN Characters ON Characters.Id = UsersGames.CharacterId
ORDER BY UsersGames.Level DESC, Users.Username ASC, Games.Name ASC

-- TASK 3
GO

SELECT
subquery1.Username,
subquery1.Game,
COUNT(*) AS ItemsCount,
 SUM(subquery1.ItemsPrice) AS ItemsPrice
  
FROM
(
SELECT Users.Username, Games.Name AS Game, Items.Id AS ItemsID, Items.Price AS ItemsPrice
FROM Users
JOIN UsersGames ON Users.Id = UsersGames.UserId
JOIN Games ON Games.Id = UsersGames.GameId
JOIN UserGameItems ON UserGameItems.UserGameId = UsersGames.Id
JOIN Items ON Items.Id = UserGameItems.ItemId
) AS subquery1
GROUP BY subquery1.Game, subquery1.Username
HAVING COUNT(*) >= 10
ORDER BY ItemsCount DESC, ItemsPrice DESC, subquery1.Username ASC

-- TASK 4

-- TASK 1
SELECT Domaines AS EmailProvider, COUNT(Domaines) AS NumberOfUsers
FROM
(SELECT SUBSTRING(Email, CHARINDEX('@', Email) + 1, 100) AS Domaines
FROM Users
) AS subquery
GROUP BY Domaines
ORDER BY NumberOfUsers DESC, Domaines
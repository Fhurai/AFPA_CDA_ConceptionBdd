USE [airDeJava]
GO

/*
 * Rencontres ayant eu n groupes participants.
**/
DECLARE @n INT = 4

SELECT CONCAT (
		[airDeJava].[dbo].[RENCONTRE].[NMREN],
		' de ',
		[airDeJava].[dbo].[RENCONTRE].[LIEUREN],
		' du ',
		FORMAT([airDeJava].[dbo].[RENCONTRE].[DATDEBREN], 'd', 'fr-FR'),
		' au ',
		FORMAT([airDeJava].[dbo].[RENCONTRE].[DATFINREN], 'd', 'fr-FR')
		) AS 'Rencontre',
	COUNT([airDeJava].[dbo].[PASSAGE].[CDGROUP]) AS 'Nombre de groupes participants'
FROM [airDeJava].[dbo].[RENCONTRE]
INNER JOIN [airDeJava].[dbo].[PASSAGE]
	ON [PASSAGE].[CDREN] = [RENCONTRE].[CDREN]
GROUP BY [airDeJava].[dbo].[RENCONTRE].[NMREN],
	[airDeJava].[dbo].[RENCONTRE].[LIEUREN],
	[airDeJava].[dbo].[RENCONTRE].[DATDEBREN],
	[airDeJava].[dbo].[RENCONTRE].[DATFINREN]
HAVING COUNT([airDeJava].[dbo].[PASSAGE].[CDGROUP]) > @n
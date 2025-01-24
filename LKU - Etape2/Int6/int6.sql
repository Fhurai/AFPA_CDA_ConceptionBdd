USE [airDeJava]
GO

/*
 * Rencontres où on a joué d'un instrument donné.
**/
DECLARE @instrument VARCHAR(20) = 'Guitare'

SELECT CONCAT (
		[airDeJava].[dbo].[RENCONTRE].[NMREN],
		' de ',
		[airDeJava].[dbo].[RENCONTRE].[LIEUREN],
		' du ',
		FORMAT([airDeJava].[dbo].[RENCONTRE].[DATDEBREN], 'd', 'fr-FR'),
		' au ',
		FORMAT([airDeJava].[dbo].[RENCONTRE].[DATFINREN], 'd', 'fr-FR')
		) AS 'Rencontre'
FROM [airDeJava].[dbo].[RENCONTRE]
INNER JOIN [airDeJava].[dbo].[PASSAGE]
	ON [PASSAGE].[CDREN] = [RENCONTRE].[CDREN]
INNER JOIN [airDeJava].[dbo].[EST MEMBRE DE]
	ON [EST MEMBRE DE].[CDGROUP] = [PASSAGE].[CDGROUP]
INNER JOIN [airDeJava].[dbo].[JOUE]
	ON [JOUE].[PERCD] = [EST MEMBRE DE].[PERCD]
INNER JOIN [airDeJava].[dbo].[INSTRUMENT]
	ON [INSTRUMENT].[CDINSTU] = [JOUE].[CDINSTU]
WHERE [airDeJava].[dbo].[INSTRUMENT].[NMINSTRU] = @instrument
GROUP BY [airDeJava].[dbo].[RENCONTRE].[NMREN],
	[airDeJava].[dbo].[RENCONTRE].[LIEUREN],
	[airDeJava].[dbo].[RENCONTRE].[DATDEBREN],
	[airDeJava].[dbo].[RENCONTRE].[DATFINREN]
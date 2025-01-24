USE [airDeJava]
GO

/*
 * Rencontres où un titre a été interprété.
**/
SELECT CONCAT (
		[airDeJava].[dbo].[RENCONTRE].[NMREN],
		' de ',
		[airDeJava].[dbo].[RENCONTRE].[LIEUREN],
		' du ',
		FORMAT([airDeJava].[dbo].[RENCONTRE].[DATDEBREN], 'd', 'fr-FR'),
		' au ',
		FORMAT([airDeJava].[dbo].[RENCONTRE].[DATFINREN], 'd', 'fr-FR')
		) AS 'Rencontre'
FROM [airDeJava].[dbo].[TITRE _ CHANSON]
INNER JOIN [airDeJava].[dbo].[REPRESENTATION]
	ON [REPRESENTATION].[CDTITRE] = [TITRE _ CHANSON].[CDTITRE]
INNER JOIN [airDeJava].[dbo].[PASSAGE]
	ON [PASSAGE].[PASSID] = [REPRESENTATION].[PASSID]
INNER JOIN [airDeJava].[dbo].[RENCONTRE]
	ON [RENCONTRE].[CDREN] = [PASSAGE].[CDREN]
WHERE [airDeJava].[dbo].[TITRE _ CHANSON].[NMTITRE] = ''
GROUP BY [airDeJava].[dbo].[RENCONTRE].[NMREN],
	[airDeJava].[dbo].[RENCONTRE].[DATDEBREN],
	[airDeJava].[dbo].[RENCONTRE].[DATFINREN],
	[airDeJava].[dbo].[RENCONTRE].[LIEUREN]
ORDER BY [airDeJava].[dbo].[RENCONTRE].[NMREN] ASC
GO


USE [airDeJava]
GO

/*
 * Groupes jouant un titre donné durant une rencontre donnée.
**/
SELECT [airDeJava].[dbo].[GROUPE].[NMGROUP] AS 'Groupe'
FROM [airDeJava].[dbo].[TITRE _ CHANSON]
INNER JOIN [airDeJava].[dbo].[REPERTORIE]
	ON [REPERTORIE].[CDTITRE] = [TITRE _ CHANSON].[CDTITRE]
INNER JOIN [airDeJava].[dbo].[GROUPE]
	ON [GROUPE].[CDGROUP] = [REPERTORIE].[CDGROUP]
INNER JOIN [airDeJava].[dbo].[REPRESENTER]
	ON [REPRESENTER].[CDGROUP] = [GROUPE].[CDGROUP]
INNER JOIN [airDeJava].[dbo].[RENCONTRE]
	ON [RENCONTRE].[CDREN] = [REPRESENTER].[CDREN]
WHERE [airDeJava].[dbo].[TITRE _ CHANSON].[NMTITRE] = ''
	AND [airDeJava].[dbo].[RENCONTRE].[NMREN] = ''
GROUP BY [airDeJava].[dbo].[GROUPE].[NMGROUP]
GO
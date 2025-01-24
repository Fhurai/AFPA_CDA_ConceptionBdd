USE [airDeJava]
GO

/*
 * Titres de plus de x minutes joués dans une rencontre donnée pour un pays donné.
**/
DECLARE @pays VARCHAR(20) = 'Allemagne'
DECLARE @rencontre VARCHAR(20) = 'LES MUZIKELLES'
DECLARE @x VARCHAR(8) = '06:30:00'

SELECT CONCAT (
		'"',
		[airDeJava].[dbo].[TITRE _ CHANSON].[NMTITRE],
		'" interprété par ',
		[airDeJava].[dbo].[GROUPE].[NMGROUP]
		) AS 'Titre'
FROM [airDeJava].[dbo].[RENCONTRE]
INNER JOIN [airDeJava].[dbo].[REPRESENTER]
	ON [REPRESENTER].[CDREN] = [RENCONTRE].[CDREN]
INNER JOIN [airDeJava].[dbo].[REGION]
	ON [REGION].[CDREG] = [REPRESENTER].[CDREG]
INNER JOIN [airDeJava].[dbo].[PAYS]
	ON [PAYS].[PAYSID] = [REGION].[PAYSID]
INNER JOIN [airDeJava].[dbo].[GROUPE]
	ON [GROUPE].[CDGROUP] = [REPRESENTER].[CDGROUP]
INNER JOIN [airDeJava].[dbo].[PASSAGE]
	ON (
			[PASSAGE].[CDGROUP] = [GROUPE].[CDGROUP]
			AND [PASSAGE].[CDREN] = [RENCONTRE].[CDREN]
			)
INNER JOIN [airDeJava].[dbo].[REPRESENTATION]
	ON [REPRESENTATION].[PASSID] = [PASSAGE].[PASSID]
INNER JOIN [airDeJava].[dbo].[TITRE _ CHANSON]
	ON [TITRE _ CHANSON].[CDTITRE] = [REPRESENTATION].[CDTITRE]
WHERE [airDeJava].[dbo].[PAYS].[PAYSLIB] = @pays
	AND [airDeJava].[dbo].[RENCONTRE].[NMREN] = @rencontre
	AND CONVERT(VARCHAR(20), [airDeJava].[dbo].[TITRE _ CHANSON].[TPSTITRE], 114) > CONVERT(VARCHAR(20), CONVERT(DATETIME, @x), 114)
GROUP BY [airDeJava].[dbo].[TITRE _ CHANSON].[NMTITRE],
	[airDeJava].[dbo].[GROUPE].[NMGROUP]
GO


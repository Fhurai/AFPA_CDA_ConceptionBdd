USE [airDeJava]
GO

/*
 * Membres ayant une spécialité donnée pour une rencontre donnée.
**/
SELECT CONCAT (
		[airDeJava].[dbo].[CIVILITE].[LIBCIV],
		' ',
		[airDeJava].[dbo].[PERSONNE].[PERPR],
		' ',
		[airDeJava].[dbo].[PERSONNE].[PERNM]
		) AS 'Membre'
FROM [airDeJava].[dbo].[SPECIALITE]
INNER JOIN [airDeJava].[dbo].[SPE]
	ON [SPE].[CDSPE] = [SPECIALITE].[CDSPE]
INNER JOIN [airDeJava].[dbo].[RENCONTRE]
	ON [RENCONTRE].[CDREN] = [SPE].[CDREN]
INNER JOIN [airDeJava].[dbo].[PERSONNE]
	ON [PERSONNE].[PERCD] = [SPE].[PERCD]
INNER JOIN [airDeJava].[dbo].[CIVILITE]
	ON [CIVILITE].[CDCIV] = [PERSONNE].[CDCIV]
WHERE [airDeJava].[dbo].[SPECIALITE].[NMSPE] = ''
	AND [airDeJava].[dbo].[RENCONTRE].[NMREN] = ''
GROUP BY [airDeJava].[dbo].[CIVILITE].[LIBCIV],
	[airDeJava].[dbo].[PERSONNE].[PERPR],
	[airDeJava].[dbo].[PERSONNE].[PERNM]
GO
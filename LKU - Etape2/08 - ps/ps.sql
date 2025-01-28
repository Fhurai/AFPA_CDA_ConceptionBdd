USE [airDeJava]
GO

/*S�lectionne les groupes qui ne participent pas � une
rencontre donn�e*/
CREATE PROCEDURE [dbo].[prc_grp_nn_prtcptn] @vgroupe INT
AS
BEGIN
	SELECT [GROUPE].[CDGROUP],
		[GROUPE].[NMGROUP]
	FROM GROUPE
	WHERE [CDGROUP] NOT IN (
			SELECT DISTINCT [GROUPE].[CDGROUP]
			FROM GROUPE
			INNER JOIN REPRESENTER
				ON REPRESENTER.CDGROUP = GROUPE.CDGROUP
			WHERE [CDREN] = @vgroupe
			)
END
GO

EXEC prc_grp_nn_prtcptn 1
GO

/*Renvoie le dernier num�ro de
rencontre ins�r�e*/
ALTER PROCEDURE [dbo].[prc_lst_rncntr]
	@id INT OUTPUT
AS
BEGIN
	SET @id = (SELECT TOP 1 ([CDREN])
	FROM RENCONTRE
	ORDER BY CDREN DESC);
END
GO

DECLARE @last INT

EXEC prc_lst_rncntr @last OUTPUT

PRINT 'La derni�re rencontre est la rencontre n�' + cast(@last as varchar(4))
GO
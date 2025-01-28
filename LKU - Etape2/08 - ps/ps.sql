USE [airDeJava]
GO

/*Sélectionne les groupes qui ne participent pas à une
rencontre donnée*/
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

/* Exécution de la procédure pour le groupe n°1 */
EXEC prc_grp_nn_prtcptn 1
GO

/*Renvoie le dernier numéro de
rencontre insérée*/
CREATE PROCEDURE [dbo].[prc_lst_rncntr]
	@id INT OUTPUT
AS
BEGIN
	SET @id = (SELECT TOP 1 ([CDREN])
	FROM RENCONTRE
	ORDER BY CDREN DESC);
END
GO

/* Exécution de la procédure pour obtenir le dernier identifiant inséré dans la variable @last qui est utilisée ensuite pour l'affichage du résultat. */
DECLARE @last INT

EXEC prc_lst_rncntr @last OUTPUT

PRINT 'La dernière rencontre est la rencontre n°' + cast(@last as varchar(4))
GO
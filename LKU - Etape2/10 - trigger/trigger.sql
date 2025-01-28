/*Suppression groupe*/
CREATE TRIGGER [dbo].[deleteGroupTrigger] ON [airDeJava].[dbo].[GROUPE]
INSTEAD OF DELETE
AS
BEGIN
	/* Déclaration des variables. */
	DECLARE @idGroup INT
	DECLARE @idPass INT

	/* Déclaration des groupes supprimés lors de la requête de suppression dans un curseur. */
	DECLARE groupes CURSOR LOCAL FORWARD_ONLY READ_ONLY
	FOR
	SELECT CDGROUP
	FROM deleted

	/* Ouverture du curseur. */
	OPEN groupes

	BEGIN TRY

		/* Récupération de la première ligne de résultats. */
		FETCH NEXT
		FROM groupes
		INTO @idGroup

		/* Tant qu'une ligne de résultats existe. */
		WHILE @@FETCH_STATUS = 0
		BEGIN
			/* Suppression EST MEMBRE DE.*/
			DELETE
			FROM [dbo].[EST MEMBRE DE]
			WHERE [CDGROUP] = @idGroup

			/* Suppression REPRESENTER.*/
			DELETE
			FROM [dbo].[REPRESENTER]
			WHERE [CDGROUP] = @idGroup

			/* Suppression REPRESENTATION.*/
			DELETE REP
			FROM [dbo].[REPRESENTATION] AS REP
			INNER JOIN [dbo].[PASSAGE]
				ON REP.PASSID = [PASSAGE].[PASSID]
			WHERE [CDGROUP] = @idGroup

			/* Suppression PASSAGE.*/
			DELETE
			FROM [dbo].[PASSAGE]
			WHERE [CDGROUP] = @idGroup

			/* Suppression REPERTORIE.*/
			DELETE
			FROM [dbo].[REPERTORIE]
			WHERE [CDGROUP] = @idGroup

			/* Suppression OCCUPE */
			DELETE
			FROM [dbo].[OCCUPE]
			WHERE [CDGROUP] = @idGroup

			/* Suppression GROUPE*/
			DELETE
			FROM [dbo].[GROUPE]
			WHERE [CDGROUP] = @idGroup

			/* Récupération de la prochaine ligne de résultats. */
			FETCH NEXT
			FROM groupes
			INTO @idGroup
		END

		/* Fermeture du curseur. */
		CLOSE groupes

		/* Nettoyage mémoire du curseur. */
		DEALLOCATE groupes
	END TRY

	BEGIN CATCH
		/* Fermeture du curseur. */
		CLOSE groupes

		/* Nettoyage mémoire du curseur. */
		DEALLOCATE groupes

		/* Avertissement de l'utilisateur qu'un ROLLBACK a eu lieu. */
		PRINT 'ROLLBACK'

		/* ROLLBACK de la transaction liée au trigger. */
		ROLLBACK TRANSACTION
	END CATCH
END
GO

/*Suppression d'une oeuvre*/
CREATE TRIGGER [dbo].[DeleteOeuvreTrigger] ON [airDeJava].[dbo].[TITRE _ CHANSON]
INSTEAD OF DELETE
AS
BEGIN
	/* Déclaration des variables. */
	DECLARE @idTitre INT

	/* Déclaration des oeuvres supprimés lors de la requête de suppression dans un curseur. */
	DECLARE titres CURSOR LOCAL FORWARD_ONLY READ_ONLY
	FOR
	SELECT CDTITRE
	FROM deleted

	/* Ouverture du curseur. */
	OPEN titres

	BEGIN TRY

		/* Récupération de la première ligne de résultats. */
		FETCH NEXT
		FROM titres
		INTO @idTitre

		/* Tant qu'une ligne de résultats existe. */
		WHILE @@FETCH_STATUS = 0
		BEGIN
			/* Suppression REPERTORIE. */
			DELETE
			FROM [dbo].[REPERTORIE]
			WHERE [CDTITRE] = @idTitre

			/* Suppression REPRESENTATION. */
			DELETE
			FROM [dbo].[REPRESENTATION]
			WHERE [CDTITRE] = @idTitre

			/* Suppression EST AUTEUR DE. */
			DELETE
			FROM [dbo].[EST AUTEUR DE]
			WHERE [CDTITRE] = @idTitre

			/* Suppression NECESSITE. */
			DELETE
			FROM [dbo].[NECESSITE]
			WHERE [CDTITRE] = @idTitre

			/* Suppression TITRE _ CHANSON. */
			DELETE
			FROM [dbo].[TITRE _ CHANSON]
			WHERE [CDTITRE] = @idTitre

			/* Récupération de la prochaine ligne de résultats. */
			FETCH NEXT
			FROM titres
			INTO @idTitre
		END

		/* Fermeture du curseur. */
		CLOSE titres

		/* Nettoyage mémoire du curseur. */
		DEALLOCATE titres
	END TRY

	BEGIN CATCH
		/* Fermeture du curseur. */
		CLOSE titres

		/* Nettoyage mémoire du curseur. */
		DEALLOCATE titres

		/* Avertissement de l'utilisateur qu'un ROLLBACK a eu lieu. */
		PRINT 'ROLLBACK'

		/* ROLLBACK de la transaction liée au trigger. */
		ROLLBACK TRANSACTION
	END CATCH
END
GO

/* Test trigger */
--DELETE
--FROM [GROUPE]
--WHERE CDGROUP = 4
--GO

/* Test trigger */
--DELETE
--FROM [TITRE _ CHANSON]
--WHERE CDTITRE = 4
--GO
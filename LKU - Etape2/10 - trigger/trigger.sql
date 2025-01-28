/*Suppression groupe*/
ALTER TRIGGER [dbo].[deleteGroupTrigger] ON [airDeJava].[dbo].[GROUPE]
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @idGroup INT
	DECLARE @idPass INT

	/* Récupération du (ou des) groupe(s) supprimé(s)*/
	DECLARE groupes CURSOR LOCAL FORWARD_ONLY READ_ONLY
	FOR
	SELECT CDGROUP
	FROM deleted

	OPEN groupes

	BEGIN TRY
		FETCH NEXT
		FROM groupes
		INTO @idGroup

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

			FETCH NEXT
			FROM groupes
			INTO @idGroup
		END

		CLOSE groupes

		DEALLOCATE groupes
	END TRY

	BEGIN CATCH
		CLOSE groupes

		DEALLOCATE groupes

		PRINT 'ROLLBACK'

		ROLLBACK TRANSACTION
	END CATCH
END
GO

/* Test trigger */
DELETE
FROM [GROUPE]
WHERE CDGROUP = 4
GO

/*Suppression d'une oeuvre*/
ALTER TRIGGER [dbo].[DeleteOeuvreTrigger] ON [airDeJava].[dbo].[TITRE _ CHANSON]
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @idTitre INT

	/* Récupération du (ou des) groupe(s) supprimé(s)*/
	DECLARE titres CURSOR LOCAL FORWARD_ONLY READ_ONLY
	FOR
	SELECT CDTITRE
	FROM deleted

	OPEN titres

	BEGIN TRY
		FETCH NEXT
		FROM titres
		INTO @idTitre

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

			FETCH NEXT
			FROM titres
			INTO @idTitre
		END

		CLOSE titres

		DEALLOCATE titres
	END TRY

	BEGIN CATCH
		CLOSE titres

		DEALLOCATE titres

		PRINT 'ROLLBACK'

		ROLLBACK TRANSACTION
	END CATCH
END
GO

/* Test trigger */
DELETE
FROM [TITRE _ CHANSON]
WHERE CDTITRE = 4
GO
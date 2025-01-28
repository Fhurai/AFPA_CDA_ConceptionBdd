USE [airDeJava]
GO

/* Suppression message d'erreur en anglais et en français. */
EXECUTE sp_dropmessage 50030,
	@lang = 'all'
GO

/* Création message d'erreur en anglais. */
EXECUTE sp_addmessage @msgnum = 50030,
	@severity = 15,
	@msgtext = N'Festival is not permitted at that date',
	@lang = 'us_english'
GO

/* Création message d'erreur en français. */
EXECUTE sp_addmessage @msgnum = 50030,
	@severity = 15,
	@msgtext = N'Rencontre non permise à cette date',
	@lang = 'french'
GO

/* Générer sept rencontres ayant les mêmes
caractéristiques sauf la date de la rencontre qui augmente d’une journée à chaque fois.*/
CREATE PROCEDURE [dbo].[prc_insert_svn_rncntrs] @succeed BIT
AS
BEGIN
	/* Lancement transaction. */
	BEGIN TRANSACTION

	BEGIN TRY
		
		/* Déclaration des variables. */
		DECLARE @i INT = 21
		DECLARE @pdatedeb DATETIME;
		DECLARE @pdatefin DATETIME;
		DECLARE @last INT

		/* Tant que i <= 28 (7 jours d'affilées depuis le 21) */
		WHILE @i < 28
		BEGIN

			/* La procédure a été appelée pour échouer. */
			IF @succeed = 0
			BEGIN
				/* Dates valorisées en décembre, hors période estivale. */
				SET @pdatedeb = CAST(CAST(@i AS VARCHAR(2)) + '-12-2024 08:00:00' AS DATETIME)
				SET @pdatefin = CAST(CAST(@i AS VARCHAR(2)) + '-12-2024 18:00:00' AS DATETIME)
			END
			ELSE
			BEGIN
				/* Date valorisées en juillet, en pleine période estivale. */
				SET @pdatedeb = CAST(CAST(@i AS VARCHAR(2)) + '-07-2024 08:00:00' AS DATETIME)
				SET @pdatefin = CAST(CAST(@i AS VARCHAR(2)) + '-07-2024 18:00:00' AS DATETIME)
			END

			/* Si la date est autorise une rencontre. */
			IF [dbo].[fn_ctrl_debut_rencontre](@pdatedeb) = 1
			BEGIN
				/* Récupération du dernier identifiant utilisé pour une rencontre. */
				EXEC prc_lst_rncntr @last OUTPUT

				/* Insertion de la nouvelle rencontre. */
				INSERT INTO [dbo].[RENCONTRE] (
					[CDREN],
					[PERCD],
					[PERIOID],
					[NMREN],
					[LIEUREN],
					[DATDEBREN],
					[DATFINREN],
					[NBPERREN]
					)
				VALUES (
					@last + 1,
					17,
					10,
					'Test' + CAST(@i AS varchar(2)),
					'METZ',
					@pdatedeb,
					@pdatefin,
					5000
					)
			END
			ELSE
			/* La date n'autorise pas le début d'une rencontre. */
			BEGIN
				/* Appel d'une erreur pour empêcher la création et alerter l'utilisateur. */
				RAISERROR (
						50030,
						- 1,
						- 1
						)
			END

			/* Incrémentation du compteur. */
			SET @i = @i + 1;
		END

		/* Aucun problème rencontré lors de la transaction, validation de celle-ci. */
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		/* Erreur récupérée. */

		/* Avertissement de l'utilisateur qu'un ROLLBACK a eu lieu. */
		PRINT 'ROLLBACK'

		/* ROLLBACK de la transaction liée au trigger. */
		ROLLBACK TRANSACTION

		/* Retour d'un message d'erreur. */
		RETURN -100
	END CATCH
END
GO

/* Exécution de la procédure transactionnelle. 
@succeed 0 => Jeu de tests avec rollback (21-28/12/2024 de 08:00 à 18:00)
@succeed 1 => Jeu de tests avec commit (21-28/07/2024 de 08:00 à 18:00)
*/
EXEC prc_insert_svn_rncntrs 1
GO
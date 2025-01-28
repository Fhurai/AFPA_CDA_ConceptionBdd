USE [airDeJava]
GO

/* Création message d'erreur en anglais et en français. */
EXECUTE sp_addmessage @msgnum = 50030,
	@severity = 15,
	@msgtext = N'Festival is not permitted at that date',
	@lang = 'us_english'
GO

EXECUTE sp_addmessage @msgnum = 50030,
	@severity = 15,
	@msgtext = N'Rencontre non permise à cette date',
	@lang = 'french'
GO

/* Générer sept rencontres ayant les mêmes
caractéristiques sauf la date de la rencontre qui augmente d’une journée à chaque fois.*/
ALTER PROCEDURE [dbo].[prc_insert_svn_rncntrs] @succeed BIT
AS
BEGIN
	BEGIN TRANSACTION

	BEGIN TRY
		DECLARE @i INT = 21
		DECLARE @pdatedeb DATETIME;
		DECLARE @pdatefin DATETIME;
		DECLARE @last INT

		WHILE @i < 28
		BEGIN
			IF @succeed = 0
			BEGIN
				SET @pdatedeb = CAST(CAST(@i AS VARCHAR(2)) + '-12-2024 08:00:00' AS DATETIME)
				SET @pdatefin = CAST(CAST(@i AS VARCHAR(2)) + '-12-2024 18:00:00' AS DATETIME)
			END
			ELSE
			BEGIN
				SET @pdatedeb = CAST(CAST(@i AS VARCHAR(2)) + '-07-2024 08:00:00' AS DATETIME)
				SET @pdatefin = CAST(CAST(@i AS VARCHAR(2)) + '-07-2024 18:00:00' AS DATETIME)
			END

			IF [dbo].[fn_ctrl_debut_rencontre](@pdatedeb) = 1
			BEGIN
				EXEC prc_lst_rncntr @last OUTPUT

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
			BEGIN
				RAISERROR (
						50030,
						- 1,
						- 1
						)
			END

			SET @i = @i + 1;
		END

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		PRINT 'ROLLBACK'
		ROLLBACK TRANSACTION

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
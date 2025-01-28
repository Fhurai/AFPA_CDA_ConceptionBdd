USE [airDeJava]
GO

/* Suppression message d'erreur en anglais et en fran�ais. */
EXECUTE sp_dropmessage 50030,
	@lang = 'all'
GO

/* Cr�ation message d'erreur en anglais. */
EXECUTE sp_addmessage @msgnum = 50030,
	@severity = 15,
	@msgtext = N'Festival is not permitted at that date',
	@lang = 'us_english'
GO

/* Cr�ation message d'erreur en fran�ais. */
EXECUTE sp_addmessage @msgnum = 50030,
	@severity = 15,
	@msgtext = N'Rencontre non permise � cette date',
	@lang = 'french'
GO

/* G�n�rer sept rencontres ayant les m�mes
caract�ristiques sauf la date de la rencontre qui augmente d�une journ�e � chaque fois.*/
CREATE PROCEDURE [dbo].[prc_insert_svn_rncntrs] @succeed BIT
AS
BEGIN
	/* Lancement transaction. */
	BEGIN TRANSACTION

	BEGIN TRY
		
		/* D�claration des variables. */
		DECLARE @i INT = 21
		DECLARE @pdatedeb DATETIME;
		DECLARE @pdatefin DATETIME;
		DECLARE @last INT

		/* Tant que i <= 28 (7 jours d'affil�es depuis le 21) */
		WHILE @i < 28
		BEGIN

			/* La proc�dure a �t� appel�e pour �chouer. */
			IF @succeed = 0
			BEGIN
				/* Dates valoris�es en d�cembre, hors p�riode estivale. */
				SET @pdatedeb = CAST(CAST(@i AS VARCHAR(2)) + '-12-2024 08:00:00' AS DATETIME)
				SET @pdatefin = CAST(CAST(@i AS VARCHAR(2)) + '-12-2024 18:00:00' AS DATETIME)
			END
			ELSE
			BEGIN
				/* Date valoris�es en juillet, en pleine p�riode estivale. */
				SET @pdatedeb = CAST(CAST(@i AS VARCHAR(2)) + '-07-2024 08:00:00' AS DATETIME)
				SET @pdatefin = CAST(CAST(@i AS VARCHAR(2)) + '-07-2024 18:00:00' AS DATETIME)
			END

			/* Si la date est autorise une rencontre. */
			IF [dbo].[fn_ctrl_debut_rencontre](@pdatedeb) = 1
			BEGIN
				/* R�cup�ration du dernier identifiant utilis� pour une rencontre. */
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
			/* La date n'autorise pas le d�but d'une rencontre. */
			BEGIN
				/* Appel d'une erreur pour emp�cher la cr�ation et alerter l'utilisateur. */
				RAISERROR (
						50030,
						- 1,
						- 1
						)
			END

			/* Incr�mentation du compteur. */
			SET @i = @i + 1;
		END

		/* Aucun probl�me rencontr� lors de la transaction, validation de celle-ci. */
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		/* Erreur r�cup�r�e. */

		/* Avertissement de l'utilisateur qu'un ROLLBACK a eu lieu. */
		PRINT 'ROLLBACK'

		/* ROLLBACK de la transaction li�e au trigger. */
		ROLLBACK TRANSACTION

		/* Retour d'un message d'erreur. */
		RETURN -100
	END CATCH
END
GO

/* Ex�cution de la proc�dure transactionnelle. 
@succeed 0 => Jeu de tests avec rollback (21-28/12/2024 de 08:00 � 18:00)
@succeed 1 => Jeu de tests avec commit (21-28/07/2024 de 08:00 � 18:00)
*/
EXEC prc_insert_svn_rncntrs 1
GO
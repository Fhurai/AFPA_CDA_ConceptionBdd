USE [airDeJava]
GO

/* Contr�ler qu�une date de rencontre commence bien un
vendredi soir (heure de d�but de rencontre apr�s 18h), un samedi ou un dimanche en matin�e
(heure de d�but de rencontre avant 12h).*/
CREATE FUNCTION [fn_ctrl_debut_rencontre] (@pdate DATETIME)
RETURNS BIT
AS
BEGIN
	/* D�claration variables */
	DECLARE @month INT
	DECLARE @day INT
	DECLARE @dw INT
	DECLARE @hour INT

	/* R�cup�ration info depuis date */
	SET @month = DATEPART(mm, @pdate) -- Le mois.
	SET @day = DATEPART(dd, @pdate) -- Le jour.
	SET @dw = DATEPART(dw, @pdate) -- Le jour de la semaine.
	SET @hour = DATEPART(hour, @pdate) -- L'heure.

	RETURN CASE 
			/* Cas Juillet/Aout - Tous les jours � toutes les heures.*/
			WHEN @month IN (
					7,
					8
					)
				THEN 1
					/* Cas Juin - Weekend avant le 15, tous les jours apr�s le 15.*/
			WHEN @month = 6
				THEN CASE 
						WHEN @day >= 15
							THEN 1
						ELSE CASE 
								WHEN @dw = 5
									THEN CASE 
											WHEN @hour >= 18
												THEN 1
											ELSE 0
											END
								WHEN @dw = 6
									OR @dw = 7
									THEN CASE 
											WHEN @hour < 12
												THEN 1
											ELSE 0
											END
								ELSE 0
								END
						END
					/* Cas Juin - Tous les jours avant le 15, weekend apr�s le 15.*/
			WHEN @month = 9
				THEN CASE 
						WHEN @day <= 15
							THEN 1
						ELSE CASE 
								WHEN @dw = 5
									THEN CASE 
											WHEN @hour >= 18
												THEN 1
											ELSE 0
											END
								WHEN @dw = 6
									OR @dw = 7
									THEN CASE 
											WHEN @hour < 12
												THEN 1
											ELSE 0
											END
								ELSE 0
								END
						END
			ELSE
				/* Cas normal - Vendredi apres 18h, Samedi & Dimanche avant 12h.*/
				CASE 
					WHEN @dw = 5
						THEN CASE 
								WHEN @hour >= 18
									THEN 1
								ELSE 0
								END
					WHEN @dw = 6
						OR @dw = 7
						THEN CASE 
								WHEN @hour < 12
									THEN 1
								ELSE 0
								END
					ELSE 0
					END
			END
END
GO

SELECT 'Vendredi avant 17h, hors p�riode estivale',
	[dbo].[fn_ctrl_debut_rencontre]('13-06-2025 17:30:00') AS 'D�but festival autoris�' -- false(0).

UNION

SELECT 'Mardi � toute heure, en p�riode estivale',
	[dbo].[fn_ctrl_debut_rencontre]('17-06-2025 16:30:00') AS 'D�but festival autoris�' -- true(1). 

UNION

SELECT 'Dimanche apr�s 12h, hors p�riode estivale',
	[dbo].[fn_ctrl_debut_rencontre]('05-01-2025 23:30:00') AS 'D�but festival autoris�' -- false(0).

UNION

SELECT 'Vendredi apr�s 17h, hors p�riode estivale',
	[dbo].[fn_ctrl_debut_rencontre]('17-01-2025 23:30:00') AS 'D�but festival autoris�' -- true(1).
GO


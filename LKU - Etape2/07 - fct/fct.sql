USE [airDeJava]
GO

/* Contrôler qu’une date de rencontre commence bien un
vendredi soir (heure de début de rencontre après 18h), un samedi ou un dimanche en matinée
(heure de début de rencontre avant 12h).*/
CREATE FUNCTION [fn_ctrl_debut_rencontre] (@pdate DATETIME)
RETURNS BIT
AS
BEGIN
	/* Déclaration variables */
	DECLARE @month INT
	DECLARE @day INT
	DECLARE @dw INT
	DECLARE @hour INT

	/* Récupération info depuis date */
	SET @month = DATEPART(mm, @pdate) -- Le mois.
	SET @day = DATEPART(dd, @pdate) -- Le jour.
	SET @dw = DATEPART(dw, @pdate) -- Le jour de la semaine.
	SET @hour = DATEPART(hour, @pdate) -- L'heure.

	RETURN CASE 
			/* Cas Juillet/Aout - Tous les jours à toutes les heures.*/
			WHEN @month IN (
					7,
					8
					)
				THEN 1
					/* Cas Juin - Weekend avant le 15, tous les jours après le 15.*/
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
					/* Cas Juin - Tous les jours avant le 15, weekend après le 15.*/
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

SELECT 'Vendredi avant 17h, hors période estivale',
	[dbo].[fn_ctrl_debut_rencontre]('13-06-2025 17:30:00') AS 'Début festival autorisé' -- false(0).

UNION

SELECT 'Mardi à toute heure, en période estivale',
	[dbo].[fn_ctrl_debut_rencontre]('17-06-2025 16:30:00') AS 'Début festival autorisé' -- true(1). 

UNION

SELECT 'Dimanche après 12h, hors période estivale',
	[dbo].[fn_ctrl_debut_rencontre]('05-01-2025 23:30:00') AS 'Début festival autorisé' -- false(0).

UNION

SELECT 'Vendredi après 17h, hors période estivale',
	[dbo].[fn_ctrl_debut_rencontre]('17-01-2025 23:30:00') AS 'Début festival autorisé' -- true(1).
GO


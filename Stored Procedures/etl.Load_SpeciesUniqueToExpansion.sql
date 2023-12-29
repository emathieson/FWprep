USE [FWprep]
GO

/****** Object:  StoredProcedure [etl].[Load_SpeciesUniqueToExpansion]    Script Date: 12/29/2023 10:45:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE     PROCEDURE [etl].[Load_SpeciesUniqueToExpansion]


AS
/*
PURPOSE:
Loads species into rpt.SpeciesUniqueToExpansion

LOG:
Date		Owner		Message
09.04.23	EMathieson	Push to Beta/ITFProd
09.07.23	EMathieson	Cleanup for GIT
12.26.23	EMathieson	Push to FWprep, adding notes

*/

BEGIN TRY
--My variation of etl logging for troubleshooting
--ProcRunLog DECLARES
DECLARE @ObjectName			SYSNAME		= OBJECT_NAME(@@PROCID)
DECLARE @ObjectStart		DATETIME2	= GETDATE()
DECLARE @RowsReturned		INT			= NULL
DECLARE @ObjectEnd			DATETIME2	= NULL
DECLARE @RunLogID			BIGINT		= NULL

--ProcRunLog START
EXEC util.RunLog_Insert @ObjectName,@ObjectStart,@ObjectEnd,@RowsReturned,@RunLogID,@RunLogIdOutput = @RunLogID OUTPUT

------------------------------------------------------------------------------yeehaw------------------------------------------------------------------------------------------------------


DROP TABLE IF EXISTS #Exp
CREATE TABLE #Exp
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		ExpansionFlag					INT,
		MichiganIsleRoyale				VARCHAR(100),
		Everglades						VARCHAR(100),
		NorthCascadesOlympic			VARCHAR(100),
		Redwoods						VARCHAR(100),
		Yosemite						VARCHAR(100)
	)
	INSERT INTO #Exp
		(
			UniqueID,
			CommonName,
			ExpansionFlag,				
			MichiganIsleRoyale,	
			Everglades,			
			NorthCascadesOlympic,
			Redwoods,				
			Yosemite			
		)
		SELECT 
			UniqueID,
			CommonName,
			'1',
			MichiganIsleRoyale,	
			Everglades,			
			NorthCascadesOlympic,
			Redwoods,				
			Yosemite
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS NULL
			AND JoshuaTree IS NULL
			AND Zion IS NULL
			AND Saguaro IS NULL

TRUNCATE TABLE rpt.SpeciesUniqueToExpansion

INSERT INTO rpt.SpeciesUniqueToExpansion
SELECT * FROM #Exp

--SELECT * FROM rpt.SpeciesUniqueToExpansion

----------------------------------------------------------------------------end yeehaw----------------------------------------------------------------------------------------------------

--ProcRunLog SET after values
SET @RowsReturned		= @@ROWCOUNT
SET @ObjectEnd			= GETDATE()

--ProcRunLog "UPDATE" logs via RunLog_Insert
EXEC util.RunLog_Insert @ObjectName,@ObjectStart,@ObjectEnd,@RowsReturned,@RunLogID

END TRY

BEGIN CATCH
	--ProcErrLog "UPDATE" logs via ErrorLog_Insert
	EXEC util.ErrorLog_Insert @RunLogID

	DECLARE @ErrMessage		NVARCHAR(4000)	= ERROR_MESSAGE()
	DECLARE @ErrSeverity	INT				= ERROR_SEVERITY()
	DECLARE @ErrState		INT				= ERROR_STATE()

	RAISERROR(@ErrMessage,  @ErrSeverity, @ErrState)

END CATCH
GO


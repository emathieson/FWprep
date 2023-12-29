USE [FWprep]
GO

/****** Object:  StoredProcedure [etl].[Load_SpeciesUniqueToRegion]    Script Date: 12/29/2023 10:45:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE     PROCEDURE [etl].[Load_SpeciesUniqueToRegion]


AS
/*
Loads  rpt.SpeciesUniqueToRegion  table



PURPOSE:
Truncates and then loads information into the region composition reports
Regions:
Northeast - MichiganSleepingBear, GreatSmokyMountains, Acadia, MichiganIsleRoyale
SouthWest - JoshuaTree, Zion, Saguaro
WestCentral - YellowstoneGrandTeton, Glacier
WestCoastPNW - NorthCascadesOlympic, Redwood, Yosemite
SouthEast - Everglades


--Current state, not pulling info from plants

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

--------------------------------------------------------------------------------
--NorthEast
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS #NorthEast
CREATE TABLE #NorthEast
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniqueToArea					VARCHAR(50),
	)
	INSERT INTO #NorthEast
		(
			UniqueID,
			CommonName,
			UniqueToArea
		)
		SELECT 
			UniqueID,
			CommonName,
			'NorthEast'
		FROM Species.AllSpecies
			WHERE 1=1
				AND (MichiganSleepingBear IS NOT NULL
				OR GreatSmokyMountains IS NOT NULL
				OR Acadia IS NOT NULL
				OR MichiganIsleRoyale IS NOT NULL)
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS NULL
			AND Zion IS NULL
			AND Saguaro IS NULL
			AND Everglades IS NULL
			AND NorthCascadesOlympic IS NULL
			AND Redwoods IS NULL
			AND Yosemite IS NULL

--------------------------------------------------------------------------------
--SouthWest------------------------------------
DROP TABLE IF EXISTS #SouthWest
CREATE TABLE #SouthWest
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniqueToArea					VARCHAR(50)
	)
	INSERT INTO #SouthWest
		(
			UniqueID,
			CommonName,
			UniqueToArea
		)
		SELECT 
			UniqueID,
			CommonName,
			'SouthWest'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULL
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS  NULL
			AND Glacier IS  NULL
				AND (JoshuaTree IS NOT NULL
				OR Zion IS NOT NULL
				OR Saguaro IS NOT NULL)
			AND MichiganIsleRoyale IS  NULL
			AND Everglades IS  NULL
			AND NorthCascadesOlympic IS  NULL
			AND Redwoods IS  NULL
			AND Yosemite IS  NULL

--------------------------------------------------------------------------------
--WestCentral
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS #WestCentral
CREATE TABLE #WestCentral
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniqueToArea					VARCHAR(50)
	)
	INSERT INTO #WestCentral
		(
			UniqueID,
			CommonName,
			UniqueToArea
		)
		SELECT 
			UniqueID,
			CommonName,
			'WestCentral'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULL
			AND Acadia IS NULL
				AND (YellowstoneGrandTeton IS NOT NULL
				OR Glacier IS NOT NULL)
			AND JoshuaTree IS NULL
			AND Zion IS NULL
			AND Saguaro IS NULL
			AND MichiganIsleRoyale IS NULL
			AND Everglades IS NULL
			AND NorthCascadesOlympic IS NULL
			AND Redwoods IS NULL
			AND Yosemite IS NULL

--------------------------------------------------------------------------------
--WestCoastPNW
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS #WestCoastPNW
CREATE TABLE #WestCoastPNW
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniqueToArea					VARCHAR(50)
	)
	INSERT INTO #WestCoastPNW
		(
			UniqueID,
			CommonName,
			UniqueToArea
		)
		SELECT 
			UniqueID,
			CommonName,
			'WestCoastPNW'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULL
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS NULL
			AND JoshuaTree IS NULL
			AND Zion IS NULL
			AND Saguaro IS NULL
			AND MichiganIsleRoyale IS NULL
			AND Everglades IS NULL
				AND (NorthCascadesOlympic IS NOT NULL
				OR Redwoods IS NOT NULL
				OR Yosemite IS NOT NULL)

--------------------------------------------------------------------------------
--SouthEast
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SouthEast
CREATE TABLE #SouthEast
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniqueToArea					VARCHAR(50)
	)
	INSERT INTO #SouthEast
		(
			UniqueID,
			CommonName,
			UniqueToArea
		)
		SELECT 
			UniqueID,
			CommonName,
			'SouthEast'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULL
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS NULL
			AND JoshuaTree IS NULL
			AND Zion IS NULL
			AND Saguaro IS NULL
			AND MichiganIsleRoyale IS NULL
				AND Everglades IS NOT NULL
			AND NorthCascadesOlympic IS NULL
			AND Redwoods IS NULL
			AND Yosemite IS NULL

--------------------------------------------------------------------------------
--Putting it all together, weeee
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS #temp_union
CREATE TABLE #temp_union
	(
		UniqueID			VARCHAR(5),
		CommonName			VARCHAR(100),
		UniqueToArea		VARCHAR(50)
	)
	INSERT INTO #temp_union
		(
			 UniqueID
			,CommonName
			,UniqueToArea
		)
		SELECT * FROM #NorthEast
		UNION
		SELECT * FROM #SouthWest
		UNION
		SELECT * FROM #WestCentral
		UNION
		SELECT * FROM #WestCoastPNW
		UNION
		SELECT * FROM #SouthEast


TRUNCATE TABLE rpt.SpeciesUniqueToRegion
INSERT INTO rpt.SpeciesUniqueToRegion
SELECT * FROM #temp_union

--Display table after insert
--SELECT * FROM rpt.SpeciesUniqueToRegion
--ORDER BY UniqueToRegion



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


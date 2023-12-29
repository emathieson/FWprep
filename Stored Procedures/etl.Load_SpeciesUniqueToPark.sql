USE [FWprep]
GO

/****** Object:  StoredProcedure [etl].[Load_SpeciesUniqueToPark]    Script Date: 12/29/2023 10:45:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE   PROCEDURE [etl].[Load_SpeciesUniqueToPark]


AS
/*
PURPOSE:
Loads species into  rpt.SpeciesUniqueToParks  table

LOG:
Date		Owner		Message
09.04.23	EMathieson	Push to Beta/ITFProd
09.07.23	EMathieson	Cleanup for GIT
12.26.23	EMathieson	Pushing to FWprep and adding notes

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

/*
MichiganSleepingBear unique
*/
DROP TABLE IF EXISTS #MichiganSleepingBearOnly
CREATE TABLE #MichiganSleepingBearOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #MichiganSleepingBearOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'MichiganSleepingBear'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NOT NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS  NULL
			AND YellowstoneGrandTeton IS  NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS  NULL
			AND Zion IS  NULL
			AND Saguaro IS  NULL
			AND MichiganIsleRoyale IS  NULL
			AND Everglades IS  NULL
			AND NorthCascadesOlympic IS  NULL
			AND Redwoods IS  NULL
			AND Yosemite IS  NULL



/*
GreatSmokyMountains unique
*/
DROP TABLE IF EXISTS #GreatSmokyMountainsOnly
CREATE TABLE #GreatSmokyMountainsOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #GreatSmokyMountainsOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'GreatSmokyMountains'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NOT NULl
			AND Acadia IS  NULL
			AND YellowstoneGrandTeton IS  NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS  NULL
			AND Zion IS  NULL
			AND Saguaro IS  NULL
			AND MichiganIsleRoyale IS  NULL
			AND Everglades IS  NULL
			AND NorthCascadesOlympic IS  NULL
			AND Redwoods IS  NULL
			AND Yosemite IS  NULL


/*
Acadia unique
*/
DROP TABLE IF EXISTS #AcadiaOnly
CREATE TABLE #AcadiaOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #AcadiaOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'Acadia'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS NOT NULL
			AND YellowstoneGrandTeton IS  NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS  NULL
			AND Zion IS  NULL
			AND Saguaro IS  NULL
			AND MichiganIsleRoyale IS  NULL
			AND Everglades IS  NULL
			AND NorthCascadesOlympic IS  NULL
			AND Redwoods IS  NULL
			AND Yosemite IS  NULL


/*
YellowstoneGlacier unique
*/
DROP TABLE IF EXISTS #YellowstoneGlacierOnly
CREATE TABLE #YellowstoneGlacierOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #YellowstoneGlacierOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'YellowstoneGrandTeton'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NOT NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS  NULL
			AND Zion IS  NULL
			AND Saguaro IS  NULL
			AND MichiganIsleRoyale IS  NULL
			AND Everglades IS  NULL
			AND NorthCascadesOlympic IS  NULL
			AND Redwoods IS  NULL
			AND Yosemite IS  NULL

/*
Glacier unique
*/
DROP TABLE IF EXISTS #GlacierOnly
CREATE TABLE #GlacierOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #GlacierOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'Glacier'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS NOT NULL
			AND JoshuaTree IS NULL
			AND Zion IS  NULL
			AND Saguaro IS  NULL
			AND MichiganIsleRoyale IS  NULL
			AND Everglades IS  NULL
			AND NorthCascadesOlympic IS  NULL
			AND Redwoods IS  NULL
			AND Yosemite IS  NULL

/*
JoshuaTree unique
*/
DROP TABLE IF EXISTS #JoshuaTreeOnly
CREATE TABLE #JoshuaTreeOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #JoshuaTreeOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'JoshuaTree'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS NOT NULL
			AND Zion IS  NULL
			AND Saguaro IS  NULL
			AND MichiganIsleRoyale IS  NULL
			AND Everglades IS  NULL
			AND NorthCascadesOlympic IS  NULL
			AND Redwoods IS  NULL
			AND Yosemite IS  NULL


/*
Zion unique
*/
DROP TABLE IF EXISTS #ZionOnly
CREATE TABLE #ZionOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #ZionOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'Zion'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS NULL
			AND Zion IS NOT NULL
			AND Saguaro IS  NULL
			AND MichiganIsleRoyale IS  NULL
			AND Everglades IS  NULL
			AND NorthCascadesOlympic IS  NULL
			AND Redwoods IS  NULL
			AND Yosemite IS  NULL


/*
Saguaro unique
*/
DROP TABLE IF EXISTS #SaguaroOnly
CREATE TABLE #SaguaroOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #SaguaroOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'Saguaro'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS NULL
			AND Zion IS NULL
			AND Saguaro IS NOT NULL
			AND MichiganIsleRoyale IS  NULL
			AND Everglades IS  NULL
			AND NorthCascadesOlympic IS  NULL
			AND Redwoods IS  NULL
			AND Yosemite IS  NULL



/*
MichiganIsleRoyale unique
*/
DROP TABLE IF EXISTS #MichiganIsleRoyaleOnly
CREATE TABLE #MichiganIsleRoyaleOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #MichiganIsleRoyaleOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'MichiganIsleRoyale'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS NULL
			AND Zion IS NULL
			AND Saguaro IS NULL
			AND MichiganIsleRoyale IS NOT NULL
			AND Everglades IS  NULL
			AND NorthCascadesOlympic IS  NULL
			AND Redwoods IS  NULL
			AND Yosemite IS  NULL


/*
Everglades unique
*/
DROP TABLE IF EXISTS #EvergladesOnly
CREATE TABLE #EvergladesOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #EvergladesOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'Everglades'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS NULL
			AND Zion IS NULL
			AND Saguaro IS NULL
			AND MichiganIsleRoyale IS NULL
			AND Everglades IS NOT NULL
			AND NorthCascadesOlympic IS  NULL
			AND Redwoods IS  NULL
			AND Yosemite IS  NULL


/*
Everglades unique
*/
DROP TABLE IF EXISTS #NorthCascadesOlympicOnly
CREATE TABLE #NorthCascadesOlympicOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #NorthCascadesOlympicOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'NorthCascadesOlympic'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS NULL
			AND Zion IS NULL
			AND Saguaro IS NULL
			AND MichiganIsleRoyale IS NULL
			AND Everglades IS NULL
			AND NorthCascadesOlympic IS NOT NULL
			AND Redwoods IS  NULL
			AND Yosemite IS  NULL


/*
Redwoods unique
*/
DROP TABLE IF EXISTS #RedwoodsOnly
CREATE TABLE #RedwoodsOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #RedwoodsOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'Redwoods'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS NULL
			AND Zion IS NULL
			AND Saguaro IS NULL
			AND MichiganIsleRoyale IS NULL
			AND Everglades IS NULL
			AND NorthCascadesOlympic IS NULL
			AND Redwoods IS NOT NULL
			AND Yosemite IS  NULL


/*
Yosemite unique
*/
DROP TABLE IF EXISTS #YosemiteOnly
CREATE TABLE #YosemiteOnly
	(
		UniqueID						VARCHAR(5),
		CommonName						VARCHAR(100),
		UniquePark						VARCHAR(50)
	)
	INSERT INTO #YosemiteOnly
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT 
			UniqueID,
			CommonName,
			'Yosemite'
		FROM Species.AllSpecies
			WHERE 1=1
			AND MichiganSleepingBear IS NULL
			AND GreatSmokyMountains IS NULl
			AND Acadia IS NULL
			AND YellowstoneGrandTeton IS NULL
			AND Glacier IS  NULL
			AND JoshuaTree IS NULL
			AND Zion IS NULL
			AND Saguaro IS NULL
			AND MichiganIsleRoyale IS NULL
			AND Everglades IS NULL
			AND NorthCascadesOlympic IS NULL
			AND Redwoods IS NULL
			AND Yosemite IS NOT NULL


DROP TABLE IF EXISTS #Unique
CREATE TABLE #Unique
	(
		UniqueID		VARCHAR(5),
		CommonName		VARCHAR(100),
		UniquePark	VARCHAR(100)
	)
	INSERT INTO #Unique
		(
			UniqueID,
			CommonName,
			UniquePark
		)
		SELECT * FROM #MichiganSleepingBearOnly
		UNION
		SELECT * FROM #GreatSmokyMountainsOnly
		UNION
		SELECT * FROM #AcadiaOnly
		UNION
		SELECT * FROM #YellowstoneGlacierOnly
		UNION
		SELECT * FROM #GlacierOnly
		UNION
		SELECT * FROM #JoshuaTreeOnly
		UNION
		SELECT * FROM #ZionOnly
		UNION
		SELECT * FROM #SaguaroOnly
		UNION
		SELECT * FROM #MichiganIsleRoyaleOnly
		UNION
		SELECT * FROM #EvergladesOnly
		UNION
		SELECT * FROM #NorthCascadesOlympicOnly
		UNION
		SELECT * FROM #RedwoodsOnly
		UNION
		SELECT * FROM #YosemiteOnly

TRUNCATE TABLE rpt.SpeciesUniqueToParks
INSERT INTO rpt.SpeciesUniqueToParks
SELECT * FROM #Unique

--SELECT * FROM rpt.SpeciesUniqueToParks

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


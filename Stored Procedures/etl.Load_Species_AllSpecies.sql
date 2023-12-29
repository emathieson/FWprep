USE [FWprep]
GO

/****** Object:  StoredProcedure [etl].[Load_Species_AllSpecies]    Script Date: 12/29/2023 10:44:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [etl].[Load_Species_AllSpecies]


AS
/*
PURPOSE:
Loads  Species.AllSpecies  table


This truncates the Species.AllSpecies table.
Pulls MOST info from all Species.CATEGORYs tables


LOG:
Date		Owner		Message
09.04.23	EMathieson	Push to Beta/ITFProd
09.07.23	EMathieson	Cleanup for GIT
12.24.23	EMathieson	Push to FWprep, changes to table names
12.26-23	EMathieson	Adding notes

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

--ALL HERPS--------------------------------------------------------------------------
DROP TABLE IF EXISTS #AllHerps
CREATE TABLE #AllHerps
	(
		Category				VARCHAR(20),
		UniqueID				VARCHAR(5),
		Class					VARCHAR(50),
		[Order]					VARCHAR(50),
		Family					VARCHAR(50),
		CommonName				VARCHAR(100),
		ScientificName			VARCHAR(100),
		MichiganSleepingBear	VARCHAR(50),
		GreatSmokyMountains		VARCHAR(50),
		Acadia					VARCHAR(50),
		YellowstoneGrandTeton	VARCHAR(50),
		Glacier					VARCHAR(50),
		JoshuaTree				VARCHAR(50),
		Zion					VARCHAR(50),
		Saguaro					VARCHAR(50),
		MichiganIsleRoyale		VARCHAR(50),
		Everglades				VARCHAR(50),
		NorthCascadesOlympic	VARCHAR(50),
		Redwoods				VARCHAR(50),
		Yosemite				VARCHAR(50),
		Habitat					VARCHAR(max),
		DailyActivity			VARCHAR(200),
		YearlyActvity			VARCHAR(200),
		IUCN					VARCHAR(40)

	)
	INSERT INTO #AllHerps
		(
		Category,
		UniqueID,
		Class,
		[Order],
		Family,
		CommonName,
		ScientificName,
		MichiganSleepingBear,
		GreatSmokyMountains,
		Acadia,
		YellowstoneGrandTeton,
		Glacier,
		JoshuaTree,
		Zion,
		Saguaro,
		MichiganIsleRoyale,
		Everglades,
		NorthCascadesOlympic,
		Redwoods,
		Yosemite,
		Habitat,
		DailyActivity,
		YearlyActvity,
		IUCN
		)
		SELECT	'Herp',
				herp.UniqueID,
				herp.Class,
				herp.[Order],
				herp.Family,
				herp.CommonName,
				herp.ScientificName,
				herp.MichiganSleepingBear,
				herp.GreatSmokyMountains,
				herp.Acadia,
				herp.YellowstoneGrandTeton,
				herp.Glacier,
				herp.JoshuaTree,
				herp.Zion,
				herp.Saguaro,
				herp.MichiganIsleRoyale,
				herp.Everglades,
				herp.NorthCascadesOlympic,
				herp.Redwoods,
				herp.Yosemite,
				herp.Habitat,
				herp.DailyActivity,
				herp.YearlyActivity,
				herp.IUCN
				
		FROM Species.Herps (NOLOCK) herp

-- ALL FISH----------------------------------------------------------------------------
DROP TABLE IF EXISTS #AllFish
CREATE TABLE #AllFish
	(
		Category				VARCHAR(20),
		UniqueID				VARCHAR(5),
		Class					VARCHAR(50),
		[Order]					VARCHAR(50),
		Family					VARCHAR(50),
		CommonName				VARCHAR(100),
		ScientificName			VARCHAR(100),
		MichiganSleepingBear	VARCHAR(50),
		GreatSmokyMountains		VARCHAR(50),
		Acadia					VARCHAR(50),
		YellowstoneGrandTeton	VARCHAR(50),
		Glacier					VARCHAR(50),
		JoshuaTree				VARCHAR(50),
		Zion					VARCHAR(50),
		Saguaro					VARCHAR(50),
		MichiganIsleRoyale		VARCHAR(50),
		Everglades				VARCHAR(50),
		NorthCascadesOlympic	VARCHAR(50),
		Redwoods				VARCHAR(50),
		Yosemite				VARCHAR(50),
		Habitat					VARCHAR(max),
		DailyActivity			VARCHAR(200),
		YearlyActvity			VARCHAR(200),
		IUCN					VARCHAR(40)
	)
	INSERT INTO #AllFish
		(
		Category,
		UniqueID,
		Class,
		[Order],
		Family,
		CommonName,
		ScientificName,
		MichiganSleepingBear,
		GreatSmokyMountains,
		Acadia,
		YellowstoneGrandTeton,
		Glacier,
		JoshuaTree,
		Zion,
		Saguaro,
		MichiganIsleRoyale,
		Everglades,
		NorthCascadesOlympic,
		Redwoods,
		Yosemite,
		Habitat,
		DailyActivity,
		YearlyActvity,
		IUCN
		)
		SELECT	'Fish',
				fish.UniqueID,
				fish.Class,
				fish.[Order],
				fish.Family,
				fish.CommonName,
				fish.ScientificName,
				fish.MichiganSleepingBear,
				fish.GreatSmokyMountains,
				fish.Acadia,
				fish.YellowstoneGrandTeton,
				fish.Glacier,
				fish.JoshuaTree,
				fish.Zion,
				fish.Saguaro,
				fish.MichiganIsleRoyale,
				fish.Everglades,
				fish.NorthCascadesOlympic,
				fish.Redwoods,
				fish.Yosemite,
				fish.Habitat,
				fish.DailyActivity,
				fish.YearlyActivity,
				fish.IUCN
				
		FROM Species.Fish (NOLOCK) fish

--ALL INVERTS------------------------------------------------------------------------
DROP TABLE IF EXISTS #AllInverts
CREATE TABLE #AllInverts
	(
		Category				VARCHAR(20),
		UniqueID				VARCHAR(5),
		Class					VARCHAR(50),
		[Order]					VARCHAR(50),
		Family					VARCHAR(50),
		CommonName				VARCHAR(100),
		ScientificName			VARCHAR(100),
		MichiganSleepingBear	VARCHAR(50),
		GreatSmokyMountains		VARCHAR(50),
		Acadia					VARCHAR(50),
		YellowstoneGrandTeton	VARCHAR(50),
		Glacier					VARCHAR(50),
		JoshuaTree				VARCHAR(50),
		Zion					VARCHAR(50),
		Saguaro					VARCHAR(50),
		MichiganIsleRoyale		VARCHAR(50),
		Everglades				VARCHAR(50),
		NorthCascadesOlympic	VARCHAR(50),
		Redwoods				VARCHAR(50),
		Yosemite				VARCHAR(50),
		Habitat					VARCHAR(max),
		DailyActivity			VARCHAR(200),
		YearlyActvity			VARCHAR(200),
		IUCN					VARCHAR(40)
	)
	INSERT INTO #AllInverts
	(
		Category,
		UniqueID,
		Class,
		[Order],
		Family,
		CommonName,
		ScientificName,
		MichiganSleepingBear,
		GreatSmokyMountains,
		Acadia,
		YellowstoneGrandTeton,
		Glacier,
		JoshuaTree,
		Zion,
		Saguaro,
		MichiganIsleRoyale,
		Everglades,
		NorthCascadesOlympic,
		Redwoods,
		Yosemite,
		Habitat,
		DailyActivity,
		YearlyActvity,
		IUCN
		)
		SELECT	'Inverts',
				inverts.UniqueID,
				inverts.Class,
				inverts.[Order],
				inverts.Family,
				inverts.CommonName,
				inverts.ScientificName,
				inverts.MichiganSleepingBear,
				inverts.GreatSmokyMountains,
				inverts.Acadia,
				inverts.YellowstoneGrandTeton,
				inverts.Glacier,
				inverts.JoshuaTree,
				inverts.Zion,
				inverts.Saguaro,
				inverts.MichiganIsleRoyale,
				inverts.Everglades,
				inverts.NorthCascadesOlympic,
				inverts.Redwoods,
				inverts.Yosemite,
				inverts.Habitat,
				inverts.DailyActivity,
				inverts.YearlyActivity,
				inverts.IUCN
				
		FROM Species.Inverts (NOLOCK) inverts

--ALL MAMMALS-------------------------------------------------------------------------
DROP TABLE IF EXISTS #AllMammals
CREATE TABLE #AllMammals
	(
		Category				VARCHAR(20),
		UniqueID				VARCHAR(5),
		Class					VARCHAR(50),
		[Order]					VARCHAR(50),
		Family					VARCHAR(50),
		CommonName				VARCHAR(100),
		ScientificName			VARCHAR(100),
		MichiganSleepingBear	VARCHAR(50),
		GreatSmokyMountains		VARCHAR(50),
		Acadia					VARCHAR(50),
		YellowstoneGrandTeton	VARCHAR(50),
		Glacier					VARCHAR(50),
		JoshuaTree				VARCHAR(50),
		Zion					VARCHAR(50),
		Saguaro					VARCHAR(50),
		MichiganIsleRoyale		VARCHAR(50),
		Everglades				VARCHAR(50),
		NorthCascadesOlympic	VARCHAR(50),
		Redwoods				VARCHAR(50),
		Yosemite				VARCHAR(50),
		Habitat					VARCHAR(max),
		DailyActivity			VARCHAR(200),
		YearlyActvity			VARCHAR(200),
		IUCN					VARCHAR(40)
	)
	INSERT INTO #AllMammals
		(
		Category,
		UniqueID,
		Class,
		[Order],
		Family,
		CommonName,
		ScientificName,
		MichiganSleepingBear,
		GreatSmokyMountains,
		Acadia,
		YellowstoneGrandTeton,
		Glacier,
		JoshuaTree,
		Zion,
		Saguaro,
		MichiganIsleRoyale,
		Everglades,
		NorthCascadesOlympic,
		Redwoods,
		Yosemite,
		Habitat,
		DailyActivity,
		YearlyActvity,
		IUCN
		)
		SELECT	'Mammals',
				mam.UniqueID,
				mam.Class,
				mam.[Order],
				mam.Family,
				mam.CommonName,
				mam.ScientificName,
				mam.MichiganSleepingBear,
				mam.GreatSmokyMountains,
				mam.Acadia,
				mam.YellowstoneGrandTeton,
				mam.Glacier,
				mam.JoshuaTree,
				mam.Zion,
				mam.Saguaro,
				mam.MichiganIsleRoyale,
				mam.Everglades,
				mam.NorthCascadesOlympic,
				mam.Redwoods,
				mam.Yosemite,
				mam.Habitat,
				mam.DailyActivity,
				mam.YearlyActivity,
				mam.IUCN
				
		FROM Species.Mammals (NOLOCK) mam

----ALL PLANTS--------------------------------------------------------------------------
--DROP TABLE IF EXISTS #AllPlants
--CREATE TABLE #AllPlants
--	(
--		Category				VARCHAR(20),
--		UniqueID				VARCHAR(5),
--		Class					VARCHAR(50),
--		[Order]					VARCHAR(50),
--		Family					VARCHAR(50),
--		CommonName				VARCHAR(100),
--		ScientificName			VARCHAR(100),
--		MichiganSleepingBear	VARCHAR(50),
--		GreatSmokyMountains		VARCHAR(50),
--		Acadia					VARCHAR(50),
--		YellowstoneGrandTeton	VARCHAR(50),
--		Glacier					VARCHAR(50),
--		JoshuaTree				VARCHAR(50),
--		Zion					VARCHAR(50),
--		Saguaro					VARCHAR(50),
--		MichiganIsleRoyale		VARCHAR(50),
--		Everglades				VARCHAR(50),
--		NorthCascadesOlympic	VARCHAR(50),
--		Redwoods				VARCHAR(50),
--		Yosemite				VARCHAR(50),
--		Habitat					VARCHAR(max),
--		DailyActivity			VARCHAR(200),
--		YearlyActvity			VARCHAR(200),
--		IUCN					VARCHAR(40)
--	)
--	INSERT INTO #AllPlants
--		(
--		Category,
--		UniqueID,
--		Class,
--		[Order],
--		Family,
--		CommonName,
--		ScientificName,
--		MichiganSleepingBear,
--		GreatSmokyMountains,
--		Acadia,
--		YellowstoneGrandTeton,
--		Glacier,
--		JoshuaTree,
--		Zion,
--		Saguaro,
--		MichiganIsleRoyale,
--		Everglades,
--		NorthCascadesOlympic,
--		Redwoods,
--		Yosemite,
--		Habitat,
--		DailyActivity,
--		YearlyActvity,
--		IUCN
--		)
--		SELECT	'Plants',
--				plt.UniqueID,
--				plt.Class,
--				plt.[Order],
--				plt.Family,
--				plt.CommonName,
--				plt.ScientificName,
--				plt.MichiganSleepingBear,
--				plt.GreatSmokyMountains,
--				plt.Acadia,
--				plt.YellowstoneGrandTeton,
--				plt.Glacier,
--				plt.JoshuaTree,
--				plt.Zion,
--				plt.Saguaro,
--				plt.MichiganIsleRoyale,
--				plt.Everglades,
--				plt.NorthCascadesOlympic,
--				plt.Redwoods,
--				plt.Yosemite,
--				NULL,
--				NULL,
--				NULL,
--				NULL
				
--		FROM Species.Plants_current (NOLOCK) plt

--ALL BIRDS--------------------------------------------------------------------------
DROP TABLE IF EXISTS #AllBirds
CREATE TABLE #AllBirds
	(
		Category				VARCHAR(20),
		UniqueID				VARCHAR(5),
		Class					VARCHAR(50),
		[Order]					VARCHAR(50),
		Family					VARCHAR(50),
		CommonName				VARCHAR(100),
		ScientificName			VARCHAR(100),
		MichiganSleepingBear	VARCHAR(50),
		GreatSmokyMountains		VARCHAR(50),
		Acadia					VARCHAR(50),
		YellowstoneGrandTeton	VARCHAR(50),
		Glacier					VARCHAR(50),
		JoshuaTree				VARCHAR(50),
		Zion					VARCHAR(50),
		Saguaro					VARCHAR(50),
		MichiganIsleRoyale		VARCHAR(50),
		Everglades				VARCHAR(50),
		NorthCascadesOlympic	VARCHAR(50),
		Redwoods				VARCHAR(50),
		Yosemite				VARCHAR(50),
		Habitat					VARCHAR(max),
		DailyActivity			VARCHAR(200),
		YearlyActvity			VARCHAR(200),
		IUCN					VARCHAR(40)
	)
	INSERT INTO #AllBirds
		(
		Category,
		UniqueID,
		Class,
		[Order],
		Family,
		CommonName,
		ScientificName,
		MichiganSleepingBear,
		GreatSmokyMountains,
		Acadia,
		YellowstoneGrandTeton,
		Glacier,
		JoshuaTree,
		Zion,
		Saguaro,
		MichiganIsleRoyale,
		Everglades,
		NorthCascadesOlympic,
		Redwoods,
		Yosemite,
		Habitat,
		DailyActivity,
		YearlyActvity,
		IUCN
		)
		SELECT	'Birds',
				bds.UniqueID,
				bds.Class,
				bds.[Order],
				bds.Family,
				bds.CommonName,
				bds.ScientificName,
				bds.MichiganSleepingBear,
				bds.GreatSmokyMountains,
				bds.Acadia,
				bds.YellowstoneGrandTeton,
				bds.Glacier,
				bds.JoshuaTree,
				bds.Zion,
				bds.Saguaro,
				bds.MichiganIsleRoyale,
				bds.Everglades,
				bds.NorthCascadesOlympic,
				bds.Redwoods,
				bds.Yosemite,
				bds.Habitat,
				bds.DailyActivity,
				bds.YearlyActivity,
				bds.IUCN
				
		FROM Species.Birds (NOLOCK) bds


--YEEHAW UNION TIME---------------------------------------------------------------
DROP TABLE IF EXISTS #TempToInsert
CREATE TABLE #TempToInsert
	(
		Category				VARCHAR(20),
		UniqueID				VARCHAR(5),
		Class					VARCHAR(50),
		[Order]					VARCHAR(50),
		Family					VARCHAR(50),
		CommonName				VARCHAR(100),
		ScientificName			VARCHAR(100),
		MichiganSleepingBear	VARCHAR(50),
		GreatSmokyMountains		VARCHAR(50),
		Acadia					VARCHAR(50),
		YellowstoneGrandTeton	VARCHAR(50),
		Glacier					VARCHAR(50),
		JoshuaTree				VARCHAR(50),
		Zion					VARCHAR(50),
		Saguaro					VARCHAR(50),
		MichiganIsleRoyale		VARCHAR(50),
		Everglades				VARCHAR(50),
		NorthCascadesOlympic	VARCHAR(50),
		Redwoods				VARCHAR(50),
		Yosemite				VARCHAR(50),
		Habitat					VARCHAR(max),
		DailyActivity			VARCHAR(200),
		YearlyActvity			VARCHAR(200),
		IUCN					VARCHAR(40)
	)
	INSERT INTO #TempToInsert
		(
		Category,
		UniqueID,
		Class,
		[Order],
		Family,
		CommonName,
		ScientificName,
		MichiganSleepingBear,
		GreatSmokyMountains,
		Acadia,
		YellowstoneGrandTeton,
		Glacier,
		JoshuaTree,
		Zion,
		Saguaro,
		MichiganIsleRoyale,
		Everglades,
		NorthCascadesOlympic,
		Redwoods,
		Yosemite,
		Habitat,
		DailyActivity,
		YearlyActvity,
		IUCN
		)
		SELECT 
			Category,
			UniqueID,
			Class,
			[Order],
			Family,
			CommonName,
			ScientificName,
			MichiganSleepingBear,
			GreatSmokyMountains,
			Acadia,
			YellowstoneGrandTeton,
			Glacier,
			JoshuaTree,
			Zion,
			Saguaro,
			MichiganIsleRoyale,
			Everglades,
			NorthCascadesOlympic,
			Redwoods,
			Yosemite,
			Habitat,
			DailyActivity,
			YearlyActvity,
			IUCN
		FROM #AllHerps
		UNION

		SELECT 
			Category,
			UniqueID,
			Class,
			[Order],
			Family,
			CommonName,
			ScientificName,
			MichiganSleepingBear,
			GreatSmokyMountains,
			Acadia,
			YellowstoneGrandTeton,
			Glacier,
			JoshuaTree,
			Zion,
			Saguaro,
			MichiganIsleRoyale,
			Everglades,
			NorthCascadesOlympic,
			Redwoods,
			Yosemite,
			Habitat,
			DailyActivity,
			YearlyActvity,
			IUCN
		FROM #AllFish
		UNION

		SELECT 
			Category,
			UniqueID,
			Class,
			[Order],
			Family,
			CommonName,
			ScientificName,
			MichiganSleepingBear,
			GreatSmokyMountains,
			Acadia,
			YellowstoneGrandTeton,
			Glacier,
			JoshuaTree,
			Zion,
			Saguaro,
			MichiganIsleRoyale,
			Everglades,
			NorthCascadesOlympic,
			Redwoods,
			Yosemite,
			Habitat,
			DailyActivity,
			YearlyActvity,
			IUCN
		FROM #AllBirds
		UNION

		--SELECT 
		--	Category,
		--	UniqueID,
		--	Class,
		--	[Order],
		--	Family,
		--	CommonName,
		--	ScientificName,
		--	MichiganSleepingBear,
		--	GreatSmokyMountains,
		--	Acadia,
		--	YellowstoneGrandTeton,
		--	Glacier,
		--	JoshuaTree,
		--	Zion,
		--	Saguaro,
		--	MichiganIsleRoyale,
		--	Everglades,
		--	NorthCascadesOlympic,
		--	Redwoods,
		--	Yosemite,
		--	Habitat,
		--	DailyActivity,
		--	YearlyActvity,
		--	IUCN
		--FROM #AllPlants
		--UNION

		SELECT 
			Category,
			UniqueID,
			Class,
			[Order],
			Family,
			CommonName,
			ScientificName,
			MichiganSleepingBear,
			GreatSmokyMountains,
			Acadia,
			YellowstoneGrandTeton,
			Glacier,
			JoshuaTree,
			Zion,
			Saguaro,
			MichiganIsleRoyale,
			Everglades,
			NorthCascadesOlympic,
			Redwoods,
			Yosemite,
			Habitat,
			DailyActivity,
			YearlyActvity,
			IUCN
		FROM #AllMammals
		UNION

		SELECT 
			Category,
			UniqueID,
			Class,
			[Order],
			Family,
			CommonName,
			ScientificName,
			MichiganSleepingBear,
			GreatSmokyMountains,
			Acadia,
			YellowstoneGrandTeton,
			Glacier,
			JoshuaTree,
			Zion,
			Saguaro,
			MichiganIsleRoyale,
			Everglades,
			NorthCascadesOlympic,
			Redwoods,
			Yosemite,
			Habitat,
			DailyActivity,
			YearlyActvity,
			IUCN

		FROM #AllInverts


TRUNCATE TABLE Species.AllSpecies


INSERT INTO Species.AllSpecies
SELECT * FROM #TempToInsert

--SELECT * FROM Species.AllSpecies

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


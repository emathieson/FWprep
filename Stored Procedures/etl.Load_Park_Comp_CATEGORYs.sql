USE [FWprep]
GO

/****** Object:  StoredProcedure [etl].[Load_Park_Comp_CATEGORYs]    Script Date: 12/29/2023 10:44:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [etl].[Load_Park_Comp_CATEGORYs]

AS
/*
PURPOSE:
Loads  rpt.Park_Comp_CATEGORYs  tables.

Uses information from the rpt.Comp_PARK_By_Category reports
--IMPORTANT! Currently not loading plants.

LOG:
Date		Owner		Message
09.04.23	EMathieson	Push to Beta/ITFProd
09.07.23	EMathieson	Cleanup for GIT
12.24.23	EMathieson	Push to FWprep
12.26.23	EMathieson	Cleaning up, creating SQL variable for repeating code, adding notes

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
DECLARE @SQLUnionSelects vARCHAR(max)
SET @SQLUnionSelects = 
		'SELECT * FROM rpt.Comp_MichiganSleepingBear_By_Category
		UNION
		SELECT * FROM rpt.Comp_GreatSmokyMountains_By_Category
		UNION
		SELECT * FROM rpt.Comp_Acadia_By_Category
		UNION
		SELECT * FROM rpt.Comp_YellowstoneGrandTeton_By_Category
		UNION
		SELECT * FROM rpt.Comp_Glacier_By_Category
		UNION
		SELECT * FROM rpt.Comp_JoshuaTree_By_Category
		UNION
		SELECT * FROM rpt.Comp_Zion_By_Category
		UNION
		SELECT * FROM rpt.Comp_Saguaro_By_Category
		UNION
		SELECT * FROM rpt.Comp_MichiganIsleRoyale_By_Category
		UNION
		SELECT * FROM rpt.Comp_Everglades_By_Category
		UNION
		SELECT * FROM rpt.Comp_NorthCascadesOlympic_By_Category
		UNION
		SELECT * FROM rpt.Comp_Redwoods_By_Category
		UNION
		SELECT * FROM rpt.Comp_Yosemite_By_Category'

----------------------------------------------
--HERPS
----------------------------------------------
DROP TABLE IF EXISTS #herps_comp
CREATE  TABLE #herps_comp
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #herps_comp
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	EXEC (@SQLUnionSelects)

	-----------------------------
TRUNCATE TABLE rpt.Park_Comp_Herps

INSERT INTO rpt.Park_Comp_Herps
SELECT * FROM #herps_comp
WHERE Category = 'Herps'

--SELECT * FROM rpt.Park_Comp_Herps
--ORDER BY [Count] DESC
--------------------------------------------------------------------------------------------

----------------------------------------------
--FISH
----------------------------------------------
DROP TABLE IF EXISTS #fish_comp
CREATE  TABLE #fish_comp
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #fish_comp
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
		EXEC (@SQLUnionSelects)

-----------------------------
TRUNCATE TABLE rpt.Park_Comp_Fish

INSERT INTO rpt.Park_Comp_Fish
SELECT * FROM #fish_comp
WHERE Category = 'Fish'

--SELECT * FROM rpt.Park_Comp_Fish
--ORDER BY [Count] DESC
--------------------------------------------------------------------------------------------

----------------------------------------------
--Birds
----------------------------------------------
DROP TABLE IF EXISTS #birds_comp
CREATE  TABLE #birds_comp
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #birds_comp
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
		EXEC (@SQLUnionSelects)

-----------------------------
TRUNCATE TABLE rpt.Park_Comp_Birds

INSERT INTO rpt.Park_Comp_Birds
SELECT * FROM #birds_comp
WHERE Category = 'Birds'

--SELECT * FROM rpt.Park_Comp_Birds
--ORDER BY [Count] DESC
--------------------------------------------------------------------------------------------

----------------------------------------------
--Inverts
----------------------------------------------
DROP TABLE IF EXISTS #inverts_comp
CREATE  TABLE #inverts_comp
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #inverts_comp
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
		EXEC (@SQLUnionSelects)

-----------------------------
TRUNCATE TABLE rpt.Park_Comp_Inverts

INSERT INTO rpt.Park_Comp_Inverts
SELECT * FROM #inverts_comp
WHERE Category = 'Inverts'

--SELECT * FROM rpt.Park_Comp_Inverts
--ORDER BY [Count] DESC
--------------------------------------------------------------------------------------------

----------------------------------------------
--Mammals
----------------------------------------------
DROP TABLE IF EXISTS #mammals_comp
CREATE  TABLE #mammals_comp
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #mammals_comp
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
		EXEC (@SQLUnionSelects)

-----------------------------
TRUNCATE TABLE rpt.Park_Comp_Mammals

INSERT INTO rpt.Park_Comp_Mammals
SELECT * FROM #mammals_comp
WHERE Category = 'Mammals'

--SELECT * FROM rpt.Park_Comp_Mammals
--ORDER BY [Count] DESC

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


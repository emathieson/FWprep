USE [FWprep]
GO

/****** Object:  StoredProcedure [etl].[Load_Comp_PARK_By_Category]    Script Date: 12/29/2023 10:44:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE   PROCEDURE [etl].[Load_Comp_PARK_By_Category]


AS
/*
PURPOSE:
Loads the  rpt.Comp_PARK_By_Category  tables

LOG:
Date		Owner		Message
09.04.23	EMathieson	Push to Beta/ITFProd
09.07.23	EMathieson	Cleanup for GIT
12.24.23	EMathieson	Push to FWprep, changes to table names
12.26.23	EMathieson	Changes to table names rpt.Comp_PARKNAME_By_Category, change to proc name, adding notes

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

----------------------------------------------
--MICHIGAN SLEEPING BEAR
----------------------------------------------
DECLARE @msbTotal INT = (SELECT COUNT(UniqueID) FROM Park.MichiganSleepingBear)

DROP TABLE IF EXISTS #msb
CREATE TABLE #msb
	(
		Category			VARCHAR(40),
		[Count]				FLOAT,
		SpeciesUniqueToPark	INT
	)
	INSERT INTO #msb
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.MichiganSleepingBear WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(msb.UniqueID) FROM Park.MichiganSleepingBear msb
										JOIN rpt.SpeciesUniqueToParks sutp ON msb.UniqueID = sutp.UniqueID
										WHERE msb.UniqueID LIKE '%B%' AND sutp.UniquePark =  'MichiganSleepingBear')
	INSERT INTO #msb
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.MichiganSleepingBear WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(msb.UniqueID) FROM Park.MichiganSleepingBear msb
										JOIN rpt.SpeciesUniqueToParks sutp ON msb.UniqueID = sutp.UniqueID
										WHERE msb.UniqueID LIKE '%H%' AND sutp.UniquePark =  'MichiganSleepingBear')
	INSERT INTO #msb
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.MichiganSleepingBear WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(msb.UniqueID) FROM Park.MichiganSleepingBear msb
										JOIN rpt.SpeciesUniqueToParks sutp ON msb.UniqueID = sutp.UniqueID
										WHERE msb.UniqueID LIKE '%F%' AND sutp.UniquePark =  'MichiganSleepingBear')
	INSERT INTO #msb
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.MichiganSleepingBear WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(msb.UniqueID) FROM Park.MichiganSleepingBear msb
										JOIN rpt.SpeciesUniqueToParks sutp ON msb.UniqueID = sutp.UniqueID
										WHERE msb.UniqueID LIKE '%M%' AND sutp.UniquePark =  'MichiganSleepingBear')
	INSERT INTO #msb
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.MichiganSleepingBear WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(msb.UniqueID) FROM Park.MichiganSleepingBear msb
										JOIN rpt.SpeciesUniqueToParks sutp ON msb.UniqueID = sutp.UniqueID
										WHERE msb.UniqueID LIKE '%I%' AND sutp.UniquePark =  'MichiganSleepingBear')

DROP TABLE IF EXISTS #finalmsb
CREATE TABLE #finalmsb
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finalmsb
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'MichiganSleepingBear',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #msb
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@msbTotal)*100.00, 2))ca_math

	DECLARE @msbUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #msb)

INSERT INTO #finalmsb
VALUES
	(
		'MichiganSleepingBear',
		'ALL',
		CAST(@msbTotal AS FLOAT),
		100,
		CAST(@msbUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finalmsb
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_MichiganSleepingBear_By_Category
INSERT INTO rpt.Comp_MichiganSleepingBear_By_Category
SELECT *  FROM #finalmsb

--SELECT * FROM rpt.Comp_MichiganSleepingBear_By_Category
--ORDER BY[Park Composition %] ASC
--------------------------------------------------------------------------------------------
----------------------------------------------
--GREAT SMOKY MOUNTAINS
----------------------------------------------
DECLARE @gsmTotal INT = (SELECT COUNT(UniqueID) FROM Park.GreatSmokyMountains)

DROP TABLE IF EXISTS #gsm
CREATE TABLE #gsm
	(
		Category			VARCHAR(40),
		[Count]				FLOAT,
		SpeciesUniqueToPark	INT
	)
	INSERT INTO #gsm
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.GreatSmokyMountains WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(gsm.UniqueID) FROM Park.GreatSmokyMountains gsm
										JOIN rpt.SpeciesUniqueToParks sutp ON gsm.UniqueID = sutp.UniqueID
										WHERE gsm.UniqueID LIKE '%B%' AND sutp.UniquePark =  'GreatSmokyMountains')
	INSERT INTO #gsm
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.GreatSmokyMountains WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(gsm.UniqueID) FROM Park.GreatSmokyMountains gsm
										JOIN rpt.SpeciesUniqueToParks sutp ON gsm.UniqueID = sutp.UniqueID
										WHERE gsm.UniqueID LIKE '%H%' AND sutp.UniquePark =  'GreatSmokyMountains')
	INSERT INTO #gsm
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.GreatSmokyMountains WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(gsm.UniqueID) FROM Park.GreatSmokyMountains gsm
										JOIN rpt.SpeciesUniqueToParks sutp ON gsm.UniqueID = sutp.UniqueID
										WHERE gsm.UniqueID LIKE '%F%' AND sutp.UniquePark =  'GreatSmokyMountains')
	INSERT INTO #gsm
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.GreatSmokyMountains WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(gsm.UniqueID) FROM Park.GreatSmokyMountains gsm
										JOIN rpt.SpeciesUniqueToParks sutp ON gsm.UniqueID = sutp.UniqueID
										WHERE gsm.UniqueID LIKE '%M%' AND sutp.UniquePark =  'GreatSmokyMountains')
	INSERT INTO #gsm
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.GreatSmokyMountains WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(gsm.UniqueID) FROM Park.GreatSmokyMountains gsm
										JOIN rpt.SpeciesUniqueToParks sutp ON gsm.UniqueID = sutp.UniqueID
										WHERE gsm.UniqueID LIKE '%I%' AND sutp.UniquePark =  'GreatSmokyMountains')

DROP TABLE IF EXISTS #finalgsm
CREATE TABLE #finalgsm
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finalgsm
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'GreatSmokyMountains',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #gsm
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@gsmTotal)*100.00, 2))ca_math

	DECLARE @gsmUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #gsm)

INSERT INTO #finalgsm
VALUES
	(
		'GreatSmokyMountain',
		'ALL',
		CAST(@gsmTotal AS FLOAT),
		100,
		CAST(@gsmUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finalgsm
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_GreatSmokyMountains_By_Category
INSERT INTO rpt.Comp_GreatSmokyMountains_By_Category
SELECT *  FROM #finalgsm

--SELECT * FROM rpt.Comp_GreatSmokyMountains_By_Category
--ORDER BY[Park Composition %] ASC
--------------------------------------------------------------------------------------------
----------------------------------------------
--ACADIA
----------------------------------------------
DECLARE @acaTotal INT = (SELECT COUNT(UniqueID) FROM Park.Acadia)

DROP TABLE IF EXISTS #aca
CREATE TABLE #aca
	(
		Category			VARCHAR(40),
		[Count]				FLOAT,
		SpeciesUniqueToPark	INT
	)
	INSERT INTO #aca
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.Acadia WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(aca.UniqueID) FROM Park.Acadia aca
										JOIN rpt.SpeciesUniqueToParks sutp ON aca.UniqueID = sutp.UniqueID
										WHERE aca.UniqueID LIKE '%B%' AND sutp.UniquePark =  'Acadia')
	INSERT INTO #aca
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.Acadia WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(aca.UniqueID) FROM Park.Acadia aca
										JOIN rpt.SpeciesUniqueToParks sutp ON aca.UniqueID = sutp.UniqueID
										WHERE aca.UniqueID LIKE '%H%' AND sutp.UniquePark =  'Acadia')
	INSERT INTO #aca
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.Acadia WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(aca.UniqueID) FROM Park.Acadia aca
										JOIN rpt.SpeciesUniqueToParks sutp ON aca.UniqueID = sutp.UniqueID
										WHERE aca.UniqueID LIKE '%F%' AND sutp.UniquePark =  'Acadia')
	INSERT INTO #aca
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.Acadia WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(aca.UniqueID) FROM Park.Acadia aca
										JOIN rpt.SpeciesUniqueToParks sutp ON aca.UniqueID = sutp.UniqueID
										WHERE aca.UniqueID LIKE '%M%' AND sutp.UniquePark =  'Acadia')
	INSERT INTO #aca
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.Acadia WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(aca.UniqueID) FROM Park.Acadia aca
										JOIN rpt.SpeciesUniqueToParks sutp ON aca.UniqueID = sutp.UniqueID
										WHERE aca.UniqueID LIKE '%I%' AND sutp.UniquePark =  'Acadia')

DROP TABLE IF EXISTS #finalaca
CREATE TABLE #finalaca
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finalaca
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'Acadia',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #aca
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@acaTotal)*100.00, 2))ca_math

	DECLARE @acaUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #aca)

INSERT INTO #finalaca
VALUES
	(
		'Acadia',
		'ALL',
		CAST(@acaTotal AS FLOAT),
		100,
		CAST(@acaUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finalaca
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_Acadia_By_Category
INSERT INTO rpt.Comp_Acadia_By_Category
SELECT *  FROM #finalaca

--SELECT * FROM rpt.Comp_Acadia_By_Category
--ORDER BY[Park Composition %] ASC
--------------------------------------------------------------------------------------------
----------------------------------------------
--YELLOWSTONE GRAND TETON
----------------------------------------------
DECLARE @ygtTotal INT = (SELECT COUNT(UniqueID) FROM Park.YellowstoneGrandTeton)

DROP TABLE IF EXISTS #ygt
CREATE TABLE #ygt
	(
		Category			VARCHAR(40),
		[Count]				FLOAT,
		SpeciesUniqueToPark	INT
	)
	INSERT INTO #ygt
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.YellowstoneGrandTeton WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(ygt.UniqueID) FROM Park.YellowstoneGrandTeton ygt
										JOIN rpt.SpeciesUniqueToParks sutp ON ygt.UniqueID = sutp.UniqueID
										WHERE ygt.UniqueID LIKE '%B%' AND sutp.UniquePark =  'YellowstoneGrandTeton')
	INSERT INTO #ygt
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.YellowstoneGrandTeton WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(ygt.UniqueID) FROM Park.YellowstoneGrandTeton ygt
										JOIN rpt.SpeciesUniqueToParks sutp ON ygt.UniqueID = sutp.UniqueID
										WHERE ygt.UniqueID LIKE '%H%' AND sutp.UniquePark =  'YellowstoneGrandTeton')
	INSERT INTO #ygt
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.YellowstoneGrandTeton WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(ygt.UniqueID) FROM Park.YellowstoneGrandTeton ygt
										JOIN rpt.SpeciesUniqueToParks sutp ON ygt.UniqueID = sutp.UniqueID
										WHERE ygt.UniqueID LIKE '%F%' AND sutp.UniquePark =  'YellowstoneGrandTeton')
	INSERT INTO #ygt
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.YellowstoneGrandTeton WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(ygt.UniqueID) FROM Park.YellowstoneGrandTeton ygt
										JOIN rpt.SpeciesUniqueToParks sutp ON ygt.UniqueID = sutp.UniqueID
										WHERE ygt.UniqueID LIKE '%M%' AND sutp.UniquePark =  'YellowstoneGrandTeton')
	INSERT INTO #ygt
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.YellowstoneGrandTeton WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(ygt.UniqueID) FROM Park.YellowstoneGrandTeton ygt
										JOIN rpt.SpeciesUniqueToParks sutp ON ygt.UniqueID = sutp.UniqueID
										WHERE ygt.UniqueID LIKE '%I%' AND sutp.UniquePark =  'YellowstoneGrandTeton')

DROP TABLE IF EXISTS #finalygt
CREATE TABLE #finalygt
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finalygt
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'YellowstoneGrandTeton',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #ygt
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@ygtTotal)*100.00, 2))ca_math

	DECLARE @ygtUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #ygt)

INSERT INTO #finalygt
VALUES
	(
		'YellowstoneGrandTeton',
		'ALL',
		CAST(@ygtTotal AS FLOAT),
		100,
		CAST(@ygtUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finalygt
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_YellowstoneGrandTeton_By_Category
INSERT INTO rpt.Comp_YellowstoneGrandTeton_By_Category
SELECT *  FROM #finalygt

--SELECT * FROM rpt.Comp_YellowstoneGrandTeton_By_Category
--ORDER BY[Park Composition %] ASC
--------------------------------------------------------------------------------------------
----------------------------------------------
--GLACIER
----------------------------------------------
DECLARE @glaTotal INT = (SELECT COUNT(UniqueID) FROM Park.Glacier)

DROP TABLE IF EXISTS #gla
CREATE TABLE #gla
	(
		Category			VARCHAR(40),
		[Count]				FLOAT,
		SpeciesUniqueToPark	INT
	)
	INSERT INTO #gla
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.Glacier WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(gla.UniqueID) FROM Park.Glacier gla
										JOIN rpt.SpeciesUniqueToParks sutp ON gla.UniqueID = sutp.UniqueID
										WHERE gla.UniqueID LIKE '%B%' AND sutp.UniquePark =  'Glacier')
	INSERT INTO #gla
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.Glacier WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(gla.UniqueID) FROM Park.Glacier gla
										JOIN rpt.SpeciesUniqueToParks sutp ON gla.UniqueID = sutp.UniqueID
										WHERE gla.UniqueID LIKE '%H%' AND sutp.UniquePark =  'Glacier')
	INSERT INTO #gla
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.Glacier WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(gla.UniqueID) FROM Park.Glacier gla
										JOIN rpt.SpeciesUniqueToParks sutp ON gla.UniqueID = sutp.UniqueID
										WHERE gla.UniqueID LIKE '%F%' AND sutp.UniquePark =  'Glacier')
	INSERT INTO #gla
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.Glacier WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(gla.UniqueID) FROM Park.Glacier gla
										JOIN rpt.SpeciesUniqueToParks sutp ON gla.UniqueID = sutp.UniqueID
										WHERE gla.UniqueID LIKE '%M%' AND sutp.UniquePark =  'Glacier')
	INSERT INTO #gla
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.Glacier WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(gla.UniqueID) FROM Park.Glacier gla
										JOIN rpt.SpeciesUniqueToParks sutp ON gla.UniqueID = sutp.UniqueID
										WHERE gla.UniqueID LIKE '%I%' AND sutp.UniquePark =  'Glacier')

DROP TABLE IF EXISTS #finalgla
CREATE TABLE #finalgla
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finalgla
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'Glacier',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #gla
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@glaTotal)*100.00, 2))ca_math

	DECLARE @glaUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #gla)

INSERT INTO #finalgla
VALUES
	(
		'Glacier',
		'ALL',
		CAST(@glaTotal AS FLOAT),
		100,
		CAST(@glaUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finalgla
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_Glacier_By_Category
INSERT INTO rpt.Comp_Glacier_By_Category
SELECT *  FROM #finalgla

--SELECT * FROM rpt.Comp_Glacier_By_Category
--ORDER BY[Park Composition %] ASC
--------------------------------------------------------------------------------------------
----------------------------------------------
--JOSHUA TREE
----------------------------------------------
DECLARE @jtTotal INT = (SELECT COUNT(UniqueID) FROM Park.JoshuaTree)

DROP TABLE IF EXISTS #jt
CREATE TABLE #jt
	(
		Category			VARCHAR(40),
		[Count]				FLOAT,
		SpeciesUniqueToPark	INT
	)
	INSERT INTO #jt
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.JoshuaTree WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(jt.UniqueID)  FROM Park.JoshuaTree jt
										JOIN rpt.SpeciesUniqueToParks sutp ON jt.UniqueID = sutp.UniqueID
										WHERE jt.UniqueID LIKE '%B%' AND sutp.UniquePark =  'JoshuaTree')
	INSERT INTO #jt
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.JoshuaTree WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(jt.UniqueID)  FROM Park.JoshuaTree jt
										JOIN rpt.SpeciesUniqueToParks sutp ON jt.UniqueID = sutp.UniqueID
										WHERE jt.UniqueID LIKE '%H%' AND sutp.UniquePark =  'JoshuaTree')
	INSERT INTO #jt
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.JoshuaTree WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(jt.UniqueID)  FROM Park.JoshuaTree jt
										JOIN rpt.SpeciesUniqueToParks sutp ON jt.UniqueID = sutp.UniqueID
										WHERE jt.UniqueID LIKE '%F%' AND sutp.UniquePark =  'JoshuaTree')
	INSERT INTO #jt
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.JoshuaTree WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(jt.UniqueID)  FROM Park.JoshuaTree jt
										JOIN rpt.SpeciesUniqueToParks sutp ON jt.UniqueID = sutp.UniqueID
										WHERE jt.UniqueID LIKE '%M%' AND sutp.UniquePark =  'JoshuaTree')
	INSERT INTO #jt
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.JoshuaTree WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(jt.UniqueID)  FROM Park.JoshuaTree jt
										JOIN rpt.SpeciesUniqueToParks sutp ON jt.UniqueID = sutp.UniqueID
										WHERE jt.UniqueID LIKE '%I%' AND sutp.UniquePark =  'JoshuaTree')

DROP TABLE IF EXISTS #finaljt
CREATE TABLE #finaljt
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finaljt
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'JoshuaTree',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #jt
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@jtTotal)*100.00, 2))ca_math

	DECLARE @jtUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #jt)

INSERT INTO #finaljt
VALUES
	(
		'JoshuaTree',
		'ALL',
		CAST(@jtTotal AS FLOAT),
		100,
		CAST(@jtUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finaljt
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_JoshuaTree_By_Category
INSERT INTO rpt.Comp_JoshuaTree_By_Category
SELECT *  FROM #finaljt

--SELECT * FROM rpt.Comp_JoshuaTree_By_Category
--ORDER BY[Park Composition %] ASC
--------------------------------------------------------------------------------------------
----------------------------------------------
--ZION
----------------------------------------------
DECLARE @zionTotal INT = (SELECT COUNT(UniqueID) FROM Park.Zion)

DROP TABLE IF EXISTS #zion
CREATE TABLE #zion
	(
		Category			VARCHAR(40),
		[Count]				FLOAT,
		SpeciesUniqueToPark	INT
	)
	INSERT INTO #zion
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.Zion WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(z.UniqueID)	FROM Park.Zion z
										JOIN rpt.SpeciesUniqueToParks sutp ON z.UniqueID = sutp.UniqueID
										WHERE z.UniqueID LIKE '%B%' AND sutp.UniquePark =  'Zion')
	INSERT INTO #zion
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.Zion WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(z.UniqueID)	FROM Park.Zion z
										JOIN rpt.SpeciesUniqueToParks sutp ON z.UniqueID = sutp.UniqueID
										WHERE z.UniqueID LIKE '%H%' AND sutp.UniquePark =  'Zion')
	INSERT INTO #zion
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.Zion WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(z.UniqueID)	FROM Park.Zion z
										JOIN rpt.SpeciesUniqueToParks sutp ON z.UniqueID = sutp.UniqueID
										WHERE z.UniqueID LIKE '%F%' AND sutp.UniquePark =  'Zion')
	INSERT INTO #zion
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.Zion WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(z.UniqueID)	FROM Park.Zion z
										JOIN rpt.SpeciesUniqueToParks sutp ON z.UniqueID = sutp.UniqueID
										WHERE z.UniqueID LIKE '%M%' AND sutp.UniquePark =  'Zion')
	INSERT INTO #zion
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.Zion WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(z.UniqueID)	FROM Park.Zion z
										JOIN rpt.SpeciesUniqueToParks sutp ON z.UniqueID = sutp.UniqueID
										WHERE z.UniqueID LIKE '%I%' AND sutp.UniquePark =  'Zion')
DROP TABLE IF EXISTS #finalz
CREATE TABLE #finalz
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finalz
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'Zion',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #zion
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@zionTotal)*100.00, 2))ca_math

	DECLARE @zionUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #zion)

INSERT INTO #finalz
VALUES
	(
		'Zion',
		'ALL',
		CAST(@zionTotal AS FLOAT),
		100,
		CAST(@zionUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finalz
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_Zion_By_Category
INSERT INTO rpt.Comp_Zion_By_Category
SELECT *  FROM #finalz

--SELECT * FROM rpt.Comp_Zion_By_Category
--ORDER BY[Park Composition %] ASC
--------------------------------------------------------------------------------------------
----------------------------------------------
--SAGUARO
----------------------------------------------
DECLARE @sagTotal INT = (SELECT COUNT(UniqueID) FROM Park.Saguaro)

DROP TABLE IF EXISTS #sag
CREATE TABLE #sag
	(
	Category			VARCHAR(40),
	[Count]				FLOAT,
	SpeciesUniqueToPark	INT
	)
	INSERT INTO #sag
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.Saguaro WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(sag.UniqueID) FROM Park.Saguaro sag
										JOIN rpt.SpeciesUniqueToParks sutp ON sag.UniqueID = sutp.UniqueID
										WHERE sag.UniqueID LIKE '%B%' AND sutp.UniquePark =  'Saguaro')
	INSERT INTO #sag
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.Saguaro WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(sag.UniqueID) FROM Park.Saguaro sag
										JOIN rpt.SpeciesUniqueToParks sutp ON sag.UniqueID = sutp.UniqueID
										WHERE sag.UniqueID LIKE '%H%' AND sutp.UniquePark =  'Saguaro')
	INSERT INTO #sag
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.Saguaro WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(sag.UniqueID) FROM Park.Saguaro sag
										JOIN rpt.SpeciesUniqueToParks sutp ON sag.UniqueID = sutp.UniqueID
										WHERE sag.UniqueID LIKE '%F%' AND sutp.UniquePark =  'Saguaro')
	INSERT INTO #sag
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.Saguaro WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(sag.UniqueID) FROM Park.Saguaro sag
										JOIN rpt.SpeciesUniqueToParks sutp ON sag.UniqueID = sutp.UniqueID
										WHERE sag.UniqueID LIKE '%M%' AND sutp.UniquePark =  'Saguaro')
	INSERT INTO #sag
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.Saguaro WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(sag.UniqueID) FROM Park.Saguaro sag
										JOIN rpt.SpeciesUniqueToParks sutp ON sag.UniqueID = sutp.UniqueID
										WHERE sag.UniqueID LIKE '%I%' AND sutp.UniquePark =  'Saguaro')

DROP TABLE IF EXISTS #finalsag
CREATE TABLE #finalsag
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finalsag
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'Saguaro',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #sag
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@sagTotal)*100.00, 2))ca_math

	DECLARE @sagUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #sag)

INSERT INTO #finalsag
VALUES
	(
		'Saguaro',
		'ALL',
		CAST(@sagTotal AS FLOAT),
		100,
		CAST(@sagUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finalsag
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_Saguaro_By_Category
INSERT INTO rpt.Comp_Saguaro_By_Category
SELECT *  FROM #finalsag

--SELECT * FROM rpt.Comp_Saguaro_By_Category
--ORDER BY[Park Composition %] ASC
--------------------------------------------------------------------------------------------
----------------------------------------------
--MICHIGAN ISLE ROYALE
----------------------------------------------
DECLARE @mirTotal INT = (SELECT COUNT(UniqueID) FROM Park.MichiganIsleRoyale)

DROP TABLE IF EXISTS #mir
CREATE TABLE #mir
	(
		Category			VARCHAR(40),
		[Count]				FLOAT,
		SpeciesUniqueToPark	INT
	)
	INSERT INTO #mir
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.MichiganIsleRoyale WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(mir.UniqueID) FROM Park.MichiganIsleRoyale mir
										JOIN rpt.SpeciesUniqueToParks sutp ON mir.UniqueID = sutp.UniqueID
										WHERE mir.UniqueID LIKE '%B%' AND sutp.UniquePark =  'MichiganIsleRoyale')
	INSERT INTO #mir
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.MichiganIsleRoyale WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(mir.UniqueID) FROM Park.MichiganIsleRoyale mir
										JOIN rpt.SpeciesUniqueToParks sutp ON mir.UniqueID = sutp.UniqueID
										WHERE mir.UniqueID LIKE '%H%' AND sutp.UniquePark =  'MichiganIsleRoyale')
	INSERT INTO #mir
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.MichiganIsleRoyale WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(mir.UniqueID) FROM Park.MichiganIsleRoyale mir
										JOIN rpt.SpeciesUniqueToParks sutp ON mir.UniqueID = sutp.UniqueID
										WHERE mir.UniqueID LIKE '%F%' AND sutp.UniquePark =  'MichiganIsleRoyale')
	INSERT INTO #mir
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.MichiganIsleRoyale WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(mir.UniqueID) FROM Park.MichiganIsleRoyale mir
										JOIN rpt.SpeciesUniqueToParks sutp ON mir.UniqueID = sutp.UniqueID
										WHERE mir.UniqueID LIKE '%M%' AND sutp.UniquePark =  'MichiganIsleRoyale')
	INSERT INTO #mir
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.MichiganIsleRoyale WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(mir.UniqueID) FROM Park.MichiganIsleRoyale mir
										JOIN rpt.SpeciesUniqueToParks sutp ON mir.UniqueID = sutp.UniqueID
										WHERE mir.UniqueID LIKE '%I%' AND sutp.UniquePark =  'MichiganIsleRoyale')

DROP TABLE IF EXISTS #finalmir
CREATE TABLE #finalmir
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finalmir
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'MichiganIsleRoyale',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #mir
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@mirTotal)*100.00, 2))ca_math

	DECLARE @mirUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #mir)

INSERT INTO #finalmir
VALUES
	(
		'MichiganIsleRoyale',
		'ALL',
		CAST(@mirTotal AS FLOAT),
		100,
		CAST(@mirUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finalmir
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_MichiganIsleRoyale_By_Category
INSERT INTO rpt.Comp_MichiganIsleRoyale_By_Category
SELECT *  FROM #finalmir

--SELECT * FROM rpt.Comp_MichiganIsleRoyale_By_Category
--ORDER BY[Park Composition %] ASC
--------------------------------------------------------------------------------------------
----------------------------------------------
--EVERGLADES
----------------------------------------------
DECLARE @evgTotal INT = (SELECT COUNT(UniqueID) FROM Park.Everglades)

DROP TABLE IF EXISTS #evg
CREATE TABLE #evg
	(
		Category			VARCHAR(40),
		[Count]				FLOAT,
		SpeciesUniqueToPark	INT
	)
	INSERT INTO #evg
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.Everglades WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(evg.UniqueID) FROM Park.Everglades evg
										JOIN rpt.SpeciesUniqueToParks sutp ON evg.UniqueID = sutp.UniqueID
										WHERE evg.UniqueID LIKE '%B%' AND sutp.UniquePark =  'Everglades')

	INSERT INTO #evg
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.Everglades WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(evg.UniqueID) FROM Park.Everglades evg
										JOIN rpt.SpeciesUniqueToParks sutp ON evg.UniqueID = sutp.UniqueID
										WHERE evg.UniqueID LIKE '%H%' AND sutp.UniquePark =  'Everglades')
	INSERT INTO #evg
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.Everglades WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(evg.UniqueID) FROM Park.Everglades evg
										JOIN rpt.SpeciesUniqueToParks sutp ON evg.UniqueID = sutp.UniqueID
										WHERE evg.UniqueID LIKE '%F%' AND sutp.UniquePark =  'Everglades')
	INSERT INTO #evg
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.Everglades WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(evg.UniqueID) FROM Park.Everglades evg
										JOIN rpt.SpeciesUniqueToParks sutp ON evg.UniqueID = sutp.UniqueID
										WHERE evg.UniqueID LIKE '%M%' AND sutp.UniquePark =  'Everglades')
	INSERT INTO #evg
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.Everglades WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(evg.UniqueID) FROM Park.Everglades evg
										JOIN rpt.SpeciesUniqueToParks sutp ON evg.UniqueID = sutp.UniqueID
										WHERE evg.UniqueID LIKE '%I%' AND sutp.UniquePark =  'Everglades')

DROP TABLE IF EXISTS #finalevg
CREATE TABLE #finalevg
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finalevg
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'Everglades',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #evg
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@evgTotal)*100.00, 2))ca_math

	DECLARE @evgUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #evg)

INSERT INTO #finalevg
VALUES
	(
		'Everglades',
		'ALL',
		CAST(@evgTotal AS FLOAT),
		100,
		CAST(@evgUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finalevg
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_Everglades_By_Category
INSERT INTO rpt.Comp_Everglades_By_Category
SELECT *  FROM #finalevg

--SELECT * FROM rpt.Comp_Everglades_By_Category
--ORDER BY[Park Composition %] ASC
--------------------------------------------------------------------------------------------
----------------------------------------------
--NORTH CASCADES OLYMPIC
----------------------------------------------
DECLARE @ncoTotal INT = (SELECT COUNT(UniqueID) FROM Park.NorthCascadesOlympic)

DROP TABLE IF EXISTS #nco
CREATE TABLE #nco
	(
		Category			VARCHAR(40),
		[Count]				FLOAT,
		SpeciesUniqueToPark	INT
	)
	INSERT INTO #nco
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.NorthCascadesOlympic WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(nco.UniqueID) FROM Park.NorthCascadesOlympic nco
										JOIN rpt.SpeciesUniqueToParks sutp ON nco.UniqueID = sutp.UniqueID
										WHERE nco.UniqueID LIKE '%B%' AND sutp.UniquePark =  'NorthCascadesOlympic')
	INSERT INTO #nco
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.NorthCascadesOlympic WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(nco.UniqueID) FROM Park.NorthCascadesOlympic nco
										JOIN rpt.SpeciesUniqueToParks sutp ON nco.UniqueID = sutp.UniqueID
										WHERE nco.UniqueID LIKE '%H%' AND sutp.UniquePark =  'NorthCascadesOlympic')
	INSERT INTO #nco
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.NorthCascadesOlympic WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(nco.UniqueID) FROM Park.NorthCascadesOlympic nco
										JOIN rpt.SpeciesUniqueToParks sutp ON nco.UniqueID = sutp.UniqueID
										WHERE nco.UniqueID LIKE '%F%' AND sutp.UniquePark =  'NorthCascadesOlympic')
	INSERT INTO #nco
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.NorthCascadesOlympic WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(nco.UniqueID) FROM Park.NorthCascadesOlympic nco
										JOIN rpt.SpeciesUniqueToParks sutp ON nco.UniqueID = sutp.UniqueID
										WHERE nco.UniqueID LIKE '%M%' AND sutp.UniquePark =  'NorthCascadesOlympic')
	INSERT INTO #nco
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.NorthCascadesOlympic WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(nco.UniqueID) FROM Park.NorthCascadesOlympic nco
										JOIN rpt.SpeciesUniqueToParks sutp ON nco.UniqueID = sutp.UniqueID
										WHERE nco.UniqueID LIKE '%I%' AND sutp.UniquePark =  'NorthCascadesOlympic')

DROP TABLE IF EXISTS #finalnco
CREATE TABLE #finalnco
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finalnco
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'NorthCascadesOlympic',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #nco
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@ncoTotal)*100.00, 2))ca_math

	DECLARE @ncoUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #nco)

INSERT INTO #finalnco
VALUES
	(
		'NorthCascadesOlympic',
		'ALL',
		CAST(@ncoTotal AS FLOAT),
		100,
		CAST(@ncoUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finalnco
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_NorthCascadesOlympic_By_Category
INSERT INTO rpt.Comp_NorthCascadesOlympic_By_Category
SELECT *  FROM #finalnco

--SELECT * FROM rpt.Comp_NorthCascadesOlympic_By_Category
--ORDER BY[Park Composition %] ASC
--------------------------------------------------------------------------------------------
----------------------------------------------
--REDWOODS
----------------------------------------------
DECLARE @redTotal INT = (SELECT COUNT(UniqueID) FROM Park.Redwoods)

DROP TABLE IF EXISTS #red
CREATE TABLE #red
	(
		Category			VARCHAR(40),
		[Count]				FLOAT,
		SpeciesUniqueToPark	INT
	)
	INSERT INTO #red
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.Redwoods WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(red.UniqueID) FROM Park.Redwoods red
										JOIN rpt.SpeciesUniqueToParks sutp ON red.UniqueID = sutp.UniqueID
										WHERE red.UniqueID LIKE '%B%' AND sutp.UniquePark =  'Redwoods')
	INSERT INTO #red
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.Redwoods WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(red.UniqueID) FROM Park.Redwoods red
										JOIN rpt.SpeciesUniqueToParks sutp ON red.UniqueID = sutp.UniqueID
										WHERE red.UniqueID LIKE '%H%' AND sutp.UniquePark =  'Redwoods')
	INSERT INTO #red
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.Redwoods WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(red.UniqueID) FROM Park.Redwoods red
										JOIN rpt.SpeciesUniqueToParks sutp ON red.UniqueID = sutp.UniqueID
										WHERE red.UniqueID LIKE '%F%' AND sutp.UniquePark =  'Redwoods')
	INSERT INTO #red
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.Redwoods WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(red.UniqueID) FROM Park.Redwoods red
										JOIN rpt.SpeciesUniqueToParks sutp ON red.UniqueID = sutp.UniqueID
										WHERE red.UniqueID LIKE '%M%' AND sutp.UniquePark =  'Redwoods')
	INSERT INTO #red
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.Redwoods WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(red.UniqueID) FROM Park.Redwoods red
										JOIN rpt.SpeciesUniqueToParks sutp ON red.UniqueID = sutp.UniqueID
										WHERE red.UniqueID LIKE '%I%' AND sutp.UniquePark =  'Redwoods')

DROP TABLE IF EXISTS #finalred
CREATE TABLE #finalred
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finalred
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'Redwoods',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #red
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@redTotal)*100.00, 2))ca_math

	DECLARE @redUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #red)

INSERT INTO #finalred
VALUES
	(
		'Redwoods',
		'ALL',
		CAST(@redTotal AS FLOAT),
		100,
		CAST(@redUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finalred
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_Redwoods_By_Category
INSERT INTO rpt.Comp_Redwoods_By_Category
SELECT *  FROM #finalred

--SELECT * FROM rpt.Comp_Redwoods_By_Category
--ORDER BY[Park Composition %] ASC
--------------------------------------------------------------------------------------------
----------------------------------------------
--YOSEMITE
----------------------------------------------
DECLARE @yosTotal INT = (SELECT COUNT(UniqueID) FROM Park.Yosemite)

DROP TABLE IF EXISTS #yos
CREATE TABLE #yos
	(
		Category			VARCHAR(40),
		[Count]				FLOAT,
		SpeciesUniqueToPark	INT
	)
	INSERT INTO #yos
		SELECT
			'Birds',
			(SELECT COUNT(UniqueID)		FROM Park.Yosemite WHERE UniqueID LIKE '%B%'),
			(SELECT COUNT(yos.UniqueID) FROM Park.Yosemite yos
										JOIN rpt.SpeciesUniqueToParks sutp ON yos.UniqueID = sutp.UniqueID
										WHERE yos.UniqueID LIKE '%B%' AND sutp.UniquePark =  'Yosemite')
	INSERT INTO #yos
		SELECT
			'Herps',
			(SELECT COUNT(UniqueID)		FROM Park.Yosemite WHERE UniqueID LIKE '%H%'),
			(SELECT COUNT(yos.UniqueID) FROM Park.Yosemite yos
										JOIN rpt.SpeciesUniqueToParks sutp ON yos.UniqueID = sutp.UniqueID
										WHERE yos.UniqueID LIKE '%H%' AND sutp.UniquePark =  'Yosemite')
	INSERT INTO #yos
		SELECT
			'Fish',
			(SELECT COUNT(UniqueID)		FROM Park.Yosemite WHERE UniqueID LIKE '%F%'),
			(SELECT COUNT(yos.UniqueID) FROM Park.Yosemite yos
										JOIN rpt.SpeciesUniqueToParks sutp ON yos.UniqueID = sutp.UniqueID
										WHERE yos.UniqueID LIKE '%F%' AND sutp.UniquePark =  'Yosemite')
	INSERT INTO #yos
		SELECT
			'Mammals',
			(SELECT COUNT(UniqueID)		FROM Park.Yosemite WHERE UniqueID LIKE '%M%'),
			(SELECT COUNT(yos.UniqueID) FROM Park.Yosemite yos
										JOIN rpt.SpeciesUniqueToParks sutp ON yos.UniqueID = sutp.UniqueID
										WHERE yos.UniqueID LIKE '%M%' AND sutp.UniquePark =  'Yosemite')
	INSERT INTO #yos
		SELECT
			'Inverts',
			(SELECT COUNT(UniqueID)		FROM Park.Yosemite WHERE UniqueID LIKE '%I%'),
			(SELECT COUNT(yos.UniqueID) FROM Park.Yosemite yos
										JOIN rpt.SpeciesUniqueToParks sutp ON yos.UniqueID = sutp.UniqueID
										WHERE yos.UniqueID LIKE '%I%' AND sutp.UniquePark =  'Yosemite')

DROP TABLE IF EXISTS #finalyos
CREATE TABLE #finalyos
	(
		Park					VARCHAR(80),
		Category				VARCHAR(40),
		[Count]					FLOAT,
		[Park Composition %]	FLOAT,
		UniqueToPark			INT
	)
	INSERT INTO #finalyos
	(
		Park,
		Category,
		[Count],
		[Park Composition %],
		UniqueToPark
	)
	SELECT 
		'Yosemite',
		Category,
		[Count],
		ca_math.pcent,
		SpeciesUniqueToPark
	FROM #yos
	CROSS APPLY(SELECT pcent = ROUND(([Count]/@yosTotal)*100.00, 2))ca_math

	DECLARE @yosUniqueSum INT = (SELECT SUM(SpeciesUniqueToPark) FROM #yos)

INSERT INTO #finalyos
VALUES
	(
		'Yosemite',
		'ALL',
		CAST(@yosTotal AS FLOAT),
		100,
		CAST(@yosUniqueSum AS FLOAT)
	)

--SELECT *  FROM #finalyos
--ORDER BY[Park Composition %] ASC

TRUNCATE TABLE rpt.Comp_Yosemite_By_Category
INSERT INTO rpt.Comp_Yosemite_By_Category
SELECT *  FROM #finalyos

--SELECT * FROM rpt.Comp_Yosemite_By_Category
--ORDER BY[Park Composition %] ASC
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


USE [FWprep]
GO

/****** Object:  StoredProcedure [etl].[Load_Park_Dynamic]    Script Date: 12/29/2023 10:44:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [etl].[Load_Park_Dynamic]


AS
/*
PURPOSE:
Loads  Park.PARK  tables


Truncates and then loads information into the Park tables
Pulls essential info from Species Tables and inserts it to the Park tables.
Uses Park Loop to dynamically update... dynamic SQL :)

--Current state, not pulling info from plants

LOG:
Date		Owner		Message
09.04.23	EMathieson	Push to Beta/ITFProd
09.07.23	EMathieson	Cleanup for GIT
12.24.23	EMathieson	Building a dynamic version of individual etl.Load_Park_PARKNAME
						Archiving individual stored procedures and switching fully to dynamic version :)
12.26.23	EMathieson	Adding notes

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

----PARK LOOP
DECLARE @Park VARCHAR(100)

DROP TABLE IF EXISTS #parkList
CREATE TABLE #parkList
	(
		Park	VARCHAR(40),
		Rnk		INT IDENTITY(1,1) PRIMARY KEY
	)
		INSERT INTO #parkList
			(
				Park
			)
			SELECT DISTINCT ParkName FROM ref.ParkDetails


DECLARE @ParkRnk INT

SET @ParkRnk = 1
WHILE (@ParkRnk <= (SELECT MAX(Rnk) FROM #parkList))
	BEGIN
	
		SET @Park = (SELECT Park FROM #parkList WHERE @ParkRnk = Rnk)

--now do the things for each park...

--------------------------------------------------------------------------------
--Herp information
--------------------------------------------------------------------------------

DECLARE @SQL1 VARCHAR(max)
	SET @SQL1= 'SELECT 
		 hps.UniqueID
		,hps.CommonName
		,hps.'+@Park+'
	FROM Species.Herps (NOLOCK) hps
	WHERE hps.'+@Park+' IS NOT NULL'

DROP TABLE IF EXISTS #herp_base
CREATE TABLE #herp_base
	(
		UniqueID			VARCHAR(5),
		CommonName			VARCHAR(100),
		Abundance			VARCHAR(50),
	)
	INSERT INTO #herp_base
		(
			 UniqueID
			,CommonName
			,Abundance
		)
		EXEC (@SQL1)


----------------------------------------------------------------------------------
----Fish information
----------------------------------------------------------------------------------
DECLARE @SQL2 VARCHAR(max)
	SET @SQL2= 'SELECT 
		 fsh.UniqueID
		,fsh.CommonName
		,fsh.'+@Park+'
	FROM Species.Fish (NOLOCK) fsh
	WHERE fsh.'+@Park+' IS NOT NULL'

DROP TABLE IF EXISTS #Fish_base
CREATE TABLE #Fish_base
	(
		UniqueID			VARCHAR(5),
		CommonName			VARCHAR(100),
		Abundance			VARCHAR(50),
	)
	INSERT INTO #Fish_base
		(
			 UniqueID
			,CommonName
			,Abundance
		)
		EXEC (@SQL2)

----------------------------------------------------------------------------------
----Mammal information
----------------------------------------------------------------------------------
DECLARE @SQL3 VARCHAR(max)
	SET @SQL3= 'SELECT 
		 mam.UniqueID
		,mam.CommonName
		,mam.'+@Park+'
	FROM Species.Mammals (NOLOCK) mam
	WHERE mam.'+@Park+' IS NOT NULL'

DROP TABLE IF EXISTS #Mammals_base
CREATE TABLE #Mammals_base
	(
		UniqueID			VARCHAR(5),
		CommonName			VARCHAR(100),
		Abundance			VARCHAR(50),
	)
	INSERT INTO #Mammals_base
		(
			 UniqueID
			,CommonName
			,Abundance
		)
		EXEC (@SQL3)

----------------------------------------------------------------------------------
----Invert information
----------------------------------------------------------------------------------
DECLARE @SQL4 VARCHAR(max)
	SET @SQL4= 'SELECT 
		 inv.UniqueID
		,inv.CommonName
		,inv.'+@Park+'
	FROM Species.Inverts (NOLOCK) inv
	WHERE inv.'+@Park+' IS NOT NULL'

DROP TABLE IF EXISTS #Inverts_base
CREATE TABLE #Inverts_base
	(
		UniqueID			VARCHAR(5),
		CommonName			VARCHAR(100),
		Abundance			VARCHAR(50),
	)
	INSERT INTO #Inverts_base
		(
			 UniqueID
			,CommonName
			,Abundance
		)
		EXEC (@SQL4)

----------------------------------------------------------------------------------
----Bird information
----------------------------------------------------------------------------------
DECLARE @SQL5 VARCHAR(max)
	SET @SQL5= 'SELECT 
		 bds.UniqueID
		,bds.CommonName
		,bds.'+@Park+'
	FROM Species.Birds (NOLOCK) bds
	WHERE bds.'+@Park+' IS NOT NULL'

DROP TABLE IF EXISTS #Birds_base
CREATE TABLE #Birds_base
	(
		UniqueID			VARCHAR(5),
		CommonName			VARCHAR(100),
		Abundance			VARCHAR(50),
	)
	INSERT INTO #Birds_base
		(
			 UniqueID
			,CommonName
			,Abundance
		)
		EXEC (@SQL5)

----------------------------------------------------------------------------------
----Putting it all together, weeee
----------------------------------------------------------------------------------
DROP TABLE IF EXISTS #temp_union
CREATE TABLE #temp_union
	(
		UniqueID			VARCHAR(5),
		CommonName			VARCHAR(100),
		Abundance			VARCHAR(50),
	)
	INSERT INTO #temp_union
		(
			 UniqueID
			,CommonName
			,Abundance
		)
		SELECT * FROM #Herp_base
		UNION
		SELECT * FROM #Birds_base
		UNION
		SELECT * FROM #Inverts_base
		UNION
		SELECT * FROM #Mammals_base
		UNION
		SELECT * FROM #Fish_base



--Clear out whats in the table now, this is not a merge
DECLARE @SQL98 VARCHAR(max)
SET @SQL98 = 'TRUNCATE TABLE Park.'+@Park+''
EXEC (@SQL98)

DECLARE @SQL99 VARCHAR(max)
SET @SQL99 = 'INSERT INTO Park.'+@Park+' SELECT * FROM #temp_union'
EXEC (@SQL99)


PRINT @ParkRnk
PRINT @Park

SET @ParkRnk = @ParkRnk +1
END

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


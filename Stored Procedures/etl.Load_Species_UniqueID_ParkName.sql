USE [FWprep]
GO

/****** Object:  StoredProcedure [etl].[Load_Species_UniqueID_ParkName]    Script Date: 12/29/2023 10:44:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE   PROCEDURE [etl].[Load_Species_UniqueID_ParkName]


AS
/*
PURPOSE:
Loads the  Species.UniqueID_ParkName  long table

LOG:
Date		Owner		Message
12.26.23	EMathieson	Initial creation with notes

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
TRUNCATE TABLE Species.UniqueID_ParkName

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

DECLARE @SQL1 VARCHAR(max)

DROP TABLE IF EXISTS #base
CREATE TABLE #base
	(
	UniqueID VARCHAR(5),
	ParkName VARCHAR(40)
	)
	

WHILE (@ParkRnk <= (SELECT MAX(Rnk) FROM #parkList))
	BEGIN
	
		SET @Park = (SELECT Park FROM #parkList WHERE @ParkRnk = Rnk)

		SET @SQL1 = 'SELECT 
			UniqueID,
			'''+@Park+'''
			FROM Species.AllSpecies
			WHERE '+@Park+' IS NOT NULL'

		INSERT INTO #base
		(
		UniqueID,
		ParkName
		)
			EXEC (@SQL1)
			--SELECT 
			--UniqueID,
			--@Park
			--FROM Species.AllSpecies
			--WHERE @Park IS NOT NULL

			--PRINT @SQL1
			
			--PRINT @ParkRnk
			PRINT @Park

			SET @ParkRnk = @ParkRnk +1
			END

INSERT INTO Species.UniqueID_ParkName 
SELECT * FROM #base 

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


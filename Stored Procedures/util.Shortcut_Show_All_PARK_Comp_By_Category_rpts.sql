USE [FWprep]
GO

/****** Object:  StoredProcedure [util].[Shortcut_Show_All_PARK_Comp_By_Category_rpts]    Script Date: 12/29/2023 10:46:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE   PROCEDURE [util].[Shortcut_Show_All_PARK_Comp_By_Category_rpts]


AS
/*
PURPOSE:
Quick shortcut using a loop to quickly query all rpt.Park_Comp_CATEGORY tables


LOG:
Date		Owner		Message
12.26.23	EMathieson	Creation

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
DECLARE @Category VARCHAR(100)

DECLARE @SQL1 VARCHAR(max)

DROP TABLE IF EXISTS #categoryList
CREATE TABLE #categoryList
	(
		Category	VARCHAR(40),
		Rnk			INT IDENTITY(1,1) PRIMARY KEY
	)
		INSERT INTO #categoryList
			(
				Category
			)
			SELECT DISTINCT Category FROM rpt.Comp_Redwoods_By_Category WHERE Category NOT LIKE 'ALL'


DECLARE @CategoryRnk INT

SET @CategoryRnk = 1
WHILE (@CategoryRnk <= (SELECT MAX(Rnk) FROM #categoryList))
	BEGIN
	
		SET @Category = (SELECT Category FROM #categoryList WHERE @CategoryRnk = Rnk)

--now do the things for each park...

SET @SQL1 = 'SELECT * FROM rpt.Park_Comp_'+@Category+' ORDER BY [Count] DESC'
EXEC (@SQL1)

SET @CategoryRnk = @CategoryRnk +1
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


USE [FWprep]
GO

/****** Object:  StoredProcedure [util].[BulkImport]    Script Date: 12/29/2023 10:45:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [util].[BulkImport]
(
@Table VARCHAR(100),
@FileName VARCHAR(100),
@Truncate VARCHAR(5)

)

AS
/*
PURPOSE:
This is a bulk insert tool.
Fill out the variables and you can easily bulk insert into a pre-existing table

Table is the table name, including the schema, but without the database name.
FileName is the base file name WITHOUT the .csv text. Files should be placed here: C:\Users\emily\Documents\SQL\BULK INSERT FILES
Truncate is either True or False

EXAMPLE:

	USE [FWPrep]
	GO
	
	DECLARE @RC int
	DECLARE @Table varchar(100)
	DECLARE @FileName varchar(100)
	DECLARE @Truncate varchar(5)
	
	-- TODO: Set parameter values here.
	
	EXECUTE @RC = [util].[BulkImport] 
	   @Table		= 'FWprep.Species.Fish'
	  ,@FileName	= 'fish.bulk.090423a'
	  ,@Truncate	= 'TRUE'
	GO



LOG:
Date		Owner		Message
09.04.23	EMathieson	Push to Beta/ITFProd
09.07.23	EMathieson	Cleanup for GIT
12.24.23	EMathieson	Push to FWprep, change to example for FWPrep

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

DECLARE @FilePath			VARCHAR(500) = 'C:\Users\emily\Documents\SQL\BULK INSERT FILES'		--Hardcoded. This is where I should place all bulk load files.
DECLARE @FullFilePath		VARCHAR(100) = @FilePath + '' + '\' + '' + @FileName + '.csv'
DECLARE @TruncateDescision	VARCHAR(500)
    SET @TruncateDescision = CASE WHEN @Truncate = 'TRUE'   THEN 'TRUNCATE TABLE' + ' ' + @Table 
															ELSE ''
															END


DECLARE @SQL VARCHAR(MAX)
SET @SQL = '
	'+@TruncateDescision+'
	BULK INSERT '+@Table+'
	FROM '''+@FullFilePath+'''
	WITH (
	FORMAT = ''CSV'',
	FIRSTROW=2,
	FIELDTERMINATOR='','',
	ROWTERMINATOR=''\n''
	);
	'
EXECUTE (@SQL)



--commenting out, unnecessary but may want to put back in later
--DECLARE @SQL2 VARCHAR(MAX)
--SET @SQL2 = 'SELECT * FROM '+@Table+''
--EXEC (@SQL2)

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


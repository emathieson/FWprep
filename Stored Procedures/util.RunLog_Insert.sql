USE [FWprep]
GO

/****** Object:  StoredProcedure [util].[RunLog_Insert]    Script Date: 12/29/2023 10:46:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [util].[RunLog_Insert]
(
	 @ObjectName						VARCHAR(512)
	,@ObjectStart						DATETIME
	,@ObjectEnd							DATETIME = NULL
	,@RowsReturned						INT
	,@RunLogID							BIGINT = NULL
	,@RunLogIdOutput					BIGINT = NULL OUTPUT

)

AS
/*
PURPOSE: Logs anything that runs...as long as it has my logging built into it...! Helpful for troubleshooting :)

LOG:
Date		Owner		Message
09.04.23	EMathieson	Push to Beta/ITFProd
09.07.23	EMathieson	Cleanup for GIT
12.24.23	EMathieson	Push to FWprep


*/

BEGIN

------------------------------------------------------------------------------yeehaw------------------------------------------------------------------------------------------------------

--Need this for first insert into table to generate RunLogID
IF  @RunLogID IS NULL
AND @ObjectEnd IS NULL

BEGIN

	DECLARE @LogOutput TABLE (RunLogID BIGINT)

	INSERT INTO util.RunLog
	(
	 ObjectName
	,ObjectStart
	,ObjectEnd
	,RunTimeSeconds
	,RowsReturned
	,ErrMessage
	)

	OUTPUT inserted.RunLogID INTO @LogOutput

	SELECT
		 ObjectName						= @ObjectName
		,ObjectStart					= @ObjectStart
		,ObjectEnd						= NULL
		,RunTimeSeconds					= NULL
		,RowsReturned					= NULL
		,ErrorMessage					= NULL

		SET @RunLogIdOutput = (SELECT RunLogID FROM @LogOutput)

END



--Need this for the EXEC at the end of my procedures
--this part updates the matching RunLog ID with its "finish running" values

IF  @RunLogID				IS NOT NULL
AND @ObjectEnd				IS NOT NULL

BEGIN

UPDATE util.RunLog WITH (TABLOCK)
SET
	 ObjectEnd					= @ObjectEnd
	,RunTimeSeconds				= DATEDIFF(SECOND, @ObjectStart, @ObjectEnd)
	,RowsReturned				= @RowsReturned
	,RecordUpdateDateTime		= GETDATE()

	WHERE RunLogID = @RunLogID
	END

END

GO


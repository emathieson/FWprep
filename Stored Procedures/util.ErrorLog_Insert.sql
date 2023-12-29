USE [FWprep]
GO

/****** Object:  StoredProcedure [util].[ErrorLog_Insert]    Script Date: 12/29/2023 10:45:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [util].[ErrorLog_Insert]
(
	@RunLogID		BIGINT	= NULL
)


AS
/*
PURPOSE:
My version of etl logging for troubleshooting.
Based off a familiar process :)

LOG:
Date		Owner		Message
09.04.23	EMathieson	Push to Beta/ITFProd
09.07.23	EMathieson	Cleanup for GIT
12.24.23	EMathieson	Push to FWprep

*/

BEGIN

------------------------------------------------------------------------------yeehaw------------------------------------------------------------------------------------------------------
--Sanity check
IF @RunLogID IS NOT NULL

BEGIN

	UPDATE util.RunLog WITH (TABLOCK)
	SET
		 ObjectEnd				= GETDATE()
		,RunTimeSeconds			= DATEDIFF(SECOND, ObjectStart, GETDATE())
		,ErrMessage				= ERROR_MESSAGE()
		,RecordUpdateDateTime	= GETDATE()

		WHERE RunLogID = @RunLogId
END

------------------------------------------------------------------------------end yeehaw------------------------------------------------------------------------------------------------------


END 
GO


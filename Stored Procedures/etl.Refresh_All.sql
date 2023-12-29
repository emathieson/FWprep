USE [FWprep]
GO

/****** Object:  StoredProcedure [etl].[Refresh_All]    Script Date: 12/29/2023 10:45:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE   PROCEDURE [etl].[Refresh_All]


AS
/*
PURPOSE:
Executes all appropriate stored procedures to refresh/reload non-manual etl loaded tables


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

EXECUTE etl.Load_Species_AllSpecies
--Dependent on the Species.Birds, Species.Herps, Species.Fish, Species.Mammals, Species.Inverts  tables being up to date. (Those tables done via the util.BulkImport procedure)
--Loads Species.AllSpecies
--Should always be first
PRINT '----------1. Finished executing etl.Load_Species_AllSpecies'


EXECUTE etl.Load_Species_UniqueID_ParkName
--Dependent on only the Species.AllSpecies table
--Loads Species.UniqueID_ParkName
PRINT '----------2. Finished executing etl.Load_Species_UniqueID_ParkName'


EXECUTE etl.Load_SpeciesUniqueToRegion
--Dependent on Species.AllSpecies table
--Loads rpt.SpeciesUniqueToRegion
PRINT '----------3. Finished executing etl.Load_SpeciesUniqueToRegion'


EXECUTE etl.Load_SpeciesUniqueToExpansion
--Dependent on Species.AllSpecies table
--Loads rpt.SpeciesUniqueToExpansion
PRINT '----------4. Finished executing etl.Load_SpeciesUniqueToExpansion'


EXECUTE etl.Load_SpeciesUniqueToPark
--Dependent on Species.AllSpecies table
--Loads rpt.SpeciesUniqueToParks
PRINT '----------5. Finished executing etl.Load_SpeciesUniqueToPark'


EXECUTE etl.Load_Park_Dynamic
--Dependent on the Species.Birds, Herps, Fish, Mammals, Inverts individual tables. 
--Loads Park.Acadia, Park.Everglades, Park.Glacier, Park.GreatSmokyMountains, Park.JoshuaTree, Park.MichiganIsleRoyale, Park.MichiganSleepingBear,
-- Park.NorthCascadesOlympic, Park.Redwoods, Park.Saguaro, Park.YellowstoneGrandTeton, Park.Yosemite, Park.Zion
PRINT '----------6. Finished executing etl.Load_Park_Dynamic'


EXECUTE etl.Load_Comp_PARK_By_Category
--Dependent on the Park.PARK tables and rpt.SpeciesUniqueToParks
--Loads rpt.Comp_Acadia_By_Category, rpt.Comp_Everglades_By_Category, rpt.Comp_Glacier_By_Category, rpt.Comp_GreatSmokyMountains_By_Category, rpt.Comp_JoshuaTree_By_Category
-- rpt.Comp_MichiganIsleRoyale_By_Category, rpt.Comp_MichiganSleepingBear_By_Category, rpt.Comp_NorthCascadesOlympic_By_Category, rpt.Comp_Redwoods_By_Category, rpt.Comp_Saguaro_By_Category, 
-- rpt.Comp_YellowstoneGrandTeton_By_Category,  rpt.Comp_Yosemite_By_Category,  rpt.Comp_Zion_By_Category tables
PRINT '----------7. Finished executing etl.Load_Comp_PARK_By_Category'


EXECUTE etl.Load_Park_Comp_CATEGORYs
--Dependent on the rpt.Comp_PARK_By_Category tables.
--Loads the rpt.ParkComp_Herps, rpt.ParkComp_Fish, rpt.ParkComp_Mammals, rpt.ParkComp_Inverts, rpt.ParkComp_Birds tables
PRINT '----------8. Finished executing etl.Load_Park_Comp_CATEGORYs'



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


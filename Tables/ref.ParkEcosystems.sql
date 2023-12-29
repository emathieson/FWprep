USE [FWprep]
GO

/****** Object:  Table [ref].[ParkEcosystems]    Script Date: 12/29/2023 10:34:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ref].[ParkEcosystems](
	[ParkName] [varchar](50) NOT NULL,
	[EcosystemName] [varchar](100) NOT NULL
) ON [PRIMARY]
GO


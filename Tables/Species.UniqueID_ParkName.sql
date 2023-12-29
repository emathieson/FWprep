USE [FWprep]
GO

/****** Object:  Table [Species].[UniqueID_ParkName]    Script Date: 12/29/2023 10:41:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Species].[UniqueID_ParkName](
	[UniqueID] [varchar](5) NOT NULL,
	[ParkName] [varchar](100) NOT NULL
) ON [PRIMARY]
GO


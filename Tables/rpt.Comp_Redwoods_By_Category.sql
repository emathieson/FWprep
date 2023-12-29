USE [FWprep]
GO

/****** Object:  Table [rpt].[Comp_Redwoods_By_Category]    Script Date: 12/29/2023 10:37:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [rpt].[Comp_Redwoods_By_Category](
	[Park] [varchar](40) NOT NULL,
	[Category] [varchar](40) NOT NULL,
	[Count] [float] NOT NULL,
	[Park Composition %] [float] NOT NULL,
	[UniqueToPark] [int] NOT NULL
) ON [PRIMARY]
GO


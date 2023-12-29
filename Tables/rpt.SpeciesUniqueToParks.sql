USE [FWprep]
GO

/****** Object:  Table [rpt].[SpeciesUniqueToParks]    Script Date: 12/29/2023 10:40:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [rpt].[SpeciesUniqueToParks](
	[UniqueID] [varchar](5) NOT NULL,
	[CommonName] [varchar](100) NOT NULL,
	[UniquePark] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UniqueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


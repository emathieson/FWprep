USE [FWprep]
GO

/****** Object:  Table [rpt].[SpeciesUniqueToExpansion]    Script Date: 12/29/2023 10:39:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [rpt].[SpeciesUniqueToExpansion](
	[UniqueID] [varchar](5) NOT NULL,
	[CommonName] [varchar](100) NOT NULL,
	[ExpansionOnlyFlag] [varchar](100) NOT NULL,
	[MichiganIsleRoyale] [varchar](100) NULL,
	[Everglades] [varchar](100) NULL,
	[NorthCascadesOlympic] [varchar](100) NULL,
	[Redwoods] [varchar](100) NULL,
	[Yosemite] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[UniqueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


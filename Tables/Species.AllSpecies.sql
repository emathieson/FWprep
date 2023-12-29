USE [FWprep]
GO

/****** Object:  Table [Species].[AllSpecies]    Script Date: 12/29/2023 10:40:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Species].[AllSpecies](
	[Category] [varchar](20) NOT NULL,
	[UniqueID] [varchar](5) NOT NULL,
	[Class] [varchar](50) NOT NULL,
	[Order] [varchar](50) NOT NULL,
	[Family] [varchar](50) NOT NULL,
	[CommonName] [varchar](100) NOT NULL,
	[ScientificName] [varchar](100) NOT NULL,
	[MichiganSleepingBear] [varchar](50) NULL,
	[GreatSmokyMountains] [varchar](50) NULL,
	[Acadia] [varchar](50) NULL,
	[YellowstoneGrandTeton] [varchar](50) NULL,
	[Glacier] [varchar](50) NULL,
	[JoshuaTree] [varchar](50) NULL,
	[Zion] [varchar](50) NULL,
	[Saguaro] [varchar](50) NULL,
	[MichiganIsleRoyale] [varchar](50) NULL,
	[Everglades] [varchar](50) NULL,
	[NorthCascadesOlympic] [varchar](50) NULL,
	[Redwoods] [varchar](50) NULL,
	[Yosemite] [varchar](50) NULL,
	[Habitat] [varchar](max) NULL,
	[DailyActivity] [varchar](200) NULL,
	[YearlyActivity] [varchar](200) NULL,
	[IUCN] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[UniqueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


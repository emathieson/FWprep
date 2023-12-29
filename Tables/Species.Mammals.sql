USE [FWprep]
GO

/****** Object:  Table [Species].[Mammals]    Script Date: 12/29/2023 10:40:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Species].[Mammals](
	[UniqueID] [varchar](5) NOT NULL,
	[Class] [varchar](50) NOT NULL,
	[Order] [varchar](50) NOT NULL,
	[Family] [varchar](50) NOT NULL,
	[ScientificName] [varchar](100) NOT NULL,
	[CommonName] [varchar](100) NOT NULL,
	[Plate] [varchar](30) NULL,
	[Ref] [varchar](30) NULL,
	[MichiganSleepingBear] [varchar](40) NULL,
	[GreatSmokyMountains] [varchar](40) NULL,
	[Acadia] [varchar](40) NULL,
	[YellowstoneGrandTeton] [varchar](40) NULL,
	[Glacier] [varchar](40) NULL,
	[JoshuaTree] [varchar](40) NULL,
	[Zion] [varchar](40) NULL,
	[Saguaro] [varchar](40) NULL,
	[MichiganIsleRoyale] [varchar](40) NULL,
	[Everglades] [varchar](40) NULL,
	[NorthCascadesOlympic] [varchar](40) NULL,
	[Redwoods] [varchar](40) NULL,
	[Yosemite] [varchar](40) NULL,
	[Habitat] [varchar](max) NULL,
	[Measurements] [varchar](max) NULL,
	[Sign] [varchar](max) NULL,
	[Notes] [varchar](max) NULL,
	[DailyActivity] [varchar](100) NULL,
	[YearlyActivity] [varchar](100) NULL,
	[IUCN] [varchar](40) NULL,
	[Diet] [varchar](500) NULL,
	[Predators] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[UniqueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


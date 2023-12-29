USE [FWprep]
GO

/****** Object:  Table [Park].[Redwoods]    Script Date: 12/29/2023 10:33:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Park].[Redwoods](
	[UniqueID] [varchar](5) NOT NULL,
	[CommonName] [varchar](100) NOT NULL,
	[Abundance] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[UniqueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


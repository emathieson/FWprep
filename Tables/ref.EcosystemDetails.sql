USE [FWprep]
GO

/****** Object:  Table [ref].[EcosytemDetails]    Script Date: 12/29/2023 10:34:24 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ref].[EcosytemDetails](
	[EcosystemName] [varchar](50) NOT NULL,
	[EcosystemDescription] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


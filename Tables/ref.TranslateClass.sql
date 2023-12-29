USE [FWprep]
GO

/****** Object:  Table [ref].[TranslateClass]    Script Date: 12/29/2023 10:34:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ref].[TranslateClass](
	[ClassName] [varchar](50) NOT NULL,
	[ClassTranslation] [varchar](50) NOT NULL
) ON [PRIMARY]
GO


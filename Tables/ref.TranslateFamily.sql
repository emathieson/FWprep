USE [FWprep]
GO

/****** Object:  Table [ref].[TranslateFamily]    Script Date: 12/29/2023 10:35:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ref].[TranslateFamily](
	[FamilyName] [varchar](50) NOT NULL,
	[FamilyTranslation] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FamilyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


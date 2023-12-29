USE [FWprep]
GO

/****** Object:  Table [rpt].[Park_Comp_Herps]    Script Date: 12/29/2023 10:38:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [rpt].[Park_Comp_Herps](
	[Park] [varchar](40) NOT NULL,
	[Category] [varchar](40) NOT NULL,
	[Count] [float] NOT NULL,
	[Park Composition %] [float] NOT NULL,
	[UniqueToPark] [int] NOT NULL
) ON [PRIMARY]
GO


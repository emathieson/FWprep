USE [FWprep]
GO

/****** Object:  Table [ref].[ParkDetails]    Script Date: 12/29/2023 10:34:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ref].[ParkDetails](
	[ParkName] [varchar](50) NOT NULL,
	[Region] [varchar](30) NOT NULL
) ON [PRIMARY]
GO


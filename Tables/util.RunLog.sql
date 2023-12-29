USE [FWprep]
GO

/****** Object:  Table [util].[RunLog]    Script Date: 12/29/2023 10:41:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [util].[RunLog](
	[RunLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[ObjectName] [nvarchar](512) NULL,
	[ObjectStart] [datetime] NOT NULL,
	[ObjectEnd] [datetime] NULL,
	[RunTimeSeconds] [int] NULL,
	[RowsReturned] [int] NULL,
	[RecordInsertDateTime] [datetime2](7) NOT NULL,
	[ErrMessage] [varchar](4000) NULL,
	[RecordUpdateDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_RunLog] PRIMARY KEY CLUSTERED 
(
	[RunLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [util].[RunLog] ADD  CONSTRAINT [DF_RunLog_RecordInsertDateTime]  DEFAULT (sysdatetime()) FOR [RecordInsertDateTime]
GO

ALTER TABLE [util].[RunLog] ADD  CONSTRAINT [DF_RunLog_RecordUpdateDateTime]  DEFAULT (getdate()) FOR [RecordUpdateDateTime]
GO


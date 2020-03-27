USE [PUREP_Staging]
GO

/****** Object:  Table [dbo].[PROJECT_DATA]    Script Date: 2020-03-06 14:35:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PROJECT_DATA](
	[PROJECT_ID] [nvarchar](1024) NOT NULL,
	[PROJECT_TYPE] [nvarchar](1024) NOT NULL,
	[TITLE] [nvarchar](1024) NOT NULL,
	[SHORT_TITLE] [nvarchar](256) NULL,
	[START_DATE] [date] NULL,
	[END_DATE] [date] NULL,
	[CURTAIL_DATE] [date] NULL,
	[CURTAIL_REASON] [nvarchar](256) NULL,
	[MANAGED_BY_ORG_ID] [nvarchar](1024) NOT NULL,
	[COLLABORATIVE_PROJECT] [bit] NOT NULL,
	[VISIBILITY] [nvarchar](1024) NULL
) ON [PRIMARY]
GO


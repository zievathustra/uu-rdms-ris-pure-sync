USE [PUREP_Staging]
GO

/****** Object:  Table [dbo].[PROJECT_IDS]    Script Date: 2020-03-06 14:37:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PROJECT_IDS](
	[PROJECT_ID] [nvarchar](max) NOT NULL,
	[ID_SOURCE] [nvarchar](max) NOT NULL,
	[ID] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


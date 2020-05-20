/*
[DATE]            2020-03-25
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
*/

USE [PUREP_Staging]
GO

/****** Object:  Table [dbo].[PROJECT_KEYWORDS]    Script Date: 2020-03-06 14:39:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PROJECT_KEYWORDS](
	[TYPE] [nvarchar](255) NULL,
	[PROJECT_ID] [nvarchar](1024) NOT NULL,
	[LOGICAL_NAME] [nvarchar](1024) NOT NULL,
	[FREE_KEYWORD] [nvarchar](1024) NULL
) ON [PRIMARY]
GO

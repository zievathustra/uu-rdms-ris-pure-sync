/*
[DATE]            2020-03-25
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
*/

USE [PUREP_Staging]
GO

/****** Object:  Table [dbo].[PROJECT_PROJECT_RELATION]    Script Date: 2020-03-06 14:41:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PROJECT_PROJECT_RELATION](
	[PROJECT_ID] [nvarchar](1024) NOT NULL,
	[TARGET_PROJECT_ID] [nvarchar](1024) NOT NULL,
	[RELATION_TYPE] [nvarchar](1024) NOT NULL
) ON [PRIMARY]
GO

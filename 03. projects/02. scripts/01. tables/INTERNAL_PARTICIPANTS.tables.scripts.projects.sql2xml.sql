/*
[DATE]            2020-03-25
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
*/

USE [PUREP_Staging]
GO

/****** Object:  Table [dbo].[INTERNAL_PARTICIPANTS]    Script Date: 2020-03-06 14:29:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[INTERNAL_PARTICIPANTS](
	[PROJECT_ID] [nvarchar](1024) NOT NULL,
	[PERSON_ID] [nvarchar](1024) NOT NULL,
	[ORGANISATION_ID] [nvarchar](1024) NOT NULL,
	[ROLE] [nvarchar](1024) NOT NULL,
	[PLANNED_RESEARCHER_COMMITMENT] [float] NULL,
	[ASSOCIATION_PERIOD_START_DATE] [date] NULL,
	[ASSOCIATION_PERIOD_END_DATE] [date] NULL
) ON [PRIMARY]
GO

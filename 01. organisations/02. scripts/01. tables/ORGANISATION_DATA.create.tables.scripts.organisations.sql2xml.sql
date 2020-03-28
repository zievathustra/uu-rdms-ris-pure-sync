/*
[DATE]		2020-03-25
[ORGANISATION]	Utrecht University
[EMPLOYEE]	Arjan Sieverink
[CONTACT1]	https://www.uu.nl/staff/JASieverink
[CONTACT2]	https://www.linkedin.com/in/arjansieverink
*/

USE [PUREP_Staging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ORGANISATION_DATA](
	[ORGANISATION_ID] [nvarchar](255) NOT NULL,
	[TYPE] [nvarchar](255) NULL,
	[NAME] [nvarchar](255) NULL,
	[START_DATE] [date] NULL,
	[END_DATE] [date] NULL
) ON [PRIMARY]
GO


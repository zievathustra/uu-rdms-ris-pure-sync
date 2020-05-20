/*
[DATE]            2020-03-25
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
*/

USE [PUREP_Staging]
GO

/****** Object:  Table [dbo].[INTERNAL_PROJECT_ORGANISATIONS]    Script Date: 2020-03-06 14:31:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[INTERNAL_PROJECT_ORGANISATIONS](
	[PROJECT_ID] [nvarchar](1024) NOT NULL,
	[ORGANISATION_ID] [nvarchar](1024) NOT NULL
) ON [PRIMARY]
GO

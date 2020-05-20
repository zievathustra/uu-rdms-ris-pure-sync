/*
[DATE]          2020-03-25
[ORGANISATION]  Utrecht University
[EMPLOYEE]      Arjan Sieverink
[CONTACT1]      https://www.uu.nl/staff/JASieverink
*/

USE [PUREP_Staging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ORGANISATION_NAME_VARIANTS](
	[ORGANISATION_ID] [nvarchar](255) NOT NULL,
	[TYPE] [nvarchar](255) NULL,
	[NAME_VARIANT] [nvarchar](255) NULL
) ON [PRIMARY]
GO

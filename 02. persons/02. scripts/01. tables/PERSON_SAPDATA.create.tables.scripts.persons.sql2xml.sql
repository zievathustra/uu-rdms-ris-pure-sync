/*
[DATE]            2020-03-25
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
*/

USE [PUREP_Staging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PERSON_SAPDATA](
    [PERSON_ID] [nvarchar](255) NOT NULL,
    [USERNAME] [nvarchar](255) NULL,
    [TITLE] [nvarchar](255) NULL,
    [POST_NOMINALS] [nvarchar](255) NULL,
    [FIRST_NAME] [nvarchar](255) NULL,
    [LAST_NAME] [nvarchar](255) NULL,
    [FIRST_NAME_KNOWN_AS] [nvarchar](255) NULL,
    [LAST_NAME_KNOWN_AS] [nvarchar](255) NULL,
    [LAST_NAME_SORT] [nvarchar](255) NULL,
    [PREVIOUS_LAST_NAME] [nvarchar](255) NULL,
    [GENDER] [nvarchar](255) NULL,
    [NATIONALITY] [nvarchar](255) NULL,
    [EMAIL] [nvarchar](255) NULL,
    [DATE_OF_BIRTH] [date] NULL,
    [RETIRAL_DATE] [date] NULL
) ON [PRIMARY]
GO

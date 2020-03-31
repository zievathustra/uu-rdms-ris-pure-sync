/*
[DATE]            2020-03-25
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
[CONTACT2]        https://www.linkedin.com/in/arjansieverink
*/

USE [PUREP_Staging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PERSON_PROFILE_INFORMATION](
    [PERSON_ID] [nvarchar](255) NOT NULL,
    [PROFILE_TYPE] [nvarchar](255) NULL,
    [TEXT] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


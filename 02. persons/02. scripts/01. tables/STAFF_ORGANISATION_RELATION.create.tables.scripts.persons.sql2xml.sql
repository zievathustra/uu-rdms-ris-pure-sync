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

CREATE TABLE [dbo].[STAFF_ORGANISATION_RELATION](
    [STAFF_ORGANISATION_RELATION_ID] [nvarchar](255) NULL,
    [PERSON_ID] [nvarchar](255) NULL,
    [ORGANISATION_ID] [nvarchar](255) NULL,
    [JOB_TITLE] [nvarchar](255) NULL,
    [EMPLOYED_AS] [nvarchar](255) NULL,
    [JOB_DESCRIPTION] [nvarchar](255) NULL,
    [EXOFFICIO_DEPARTMENTAL_ROLE] [nvarchar](255) NULL,
    [DIRECT_PHONE_NR] [nvarchar](255) NULL,
    [MOBILE_PHONE_NR] [nvarchar](255) NULL,
    [EMAIL] [nvarchar](255) NULL,
    [WORK_ADDRESS_ONE] [nvarchar](255) NULL,
    [WORK_ADDRESS_TWO] [nvarchar](255) NULL,
    [WORK_ADDRESS_THREE] [nvarchar](255) NULL,
    [WORK_POSTAL_CODE] [nvarchar](255) NULL,
    [WORK_COUNTRY] [nvarchar](255) NULL,
    [START_DATE] [date] NULL,
    [END_DATE] [date] NULL,
    [FTE] [float] NULL
) ON [PRIMARY]
GO

/*
[DATE]            2020-03-26
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
[CONTACT2]        https://www.linkedin.com/in/arjansieverink
[REMARKS]         X_ version (modified) of original script since [ntext] data type will be removed from SQL Server sometime in the near future,
                  see https://docs.microsoft.com/en-us/sql/t-sql/data-types/ntext-text-and-image-transact-sql?view=sql-server-ver15
[CHANGES]         <01>    replace [ntext] with [nvarchar](max)
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
--    [TEXT] [ntext] NULL
    [TEXT] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


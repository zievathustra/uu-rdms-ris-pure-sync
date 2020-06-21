/*
[DATE]            2020-06-10
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
[REMARKS]         Create and populate database tables and create views
*/
USE PUREP_Staging
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* TABLES */

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

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\INTERNAL_PARTICIPANTS.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[INTERNAL_PARTICIPANTS]
SELECT PROJECT_ID, PERSON_ID, ORGANISATION_ID, ROLE, PLANNED_RESEARCHER_COMMITMENT, ASSOCIATION_PERIOD_START_DATE, ASSOCIATION_PERIOD_END_DATE
FROM OPENXML(@hDoc, 'data/row')
WITH
(
PROJECT_ID [nvarchar](1024) 'PROJECT_ID',
PERSON_ID [nvarchar](1024) 'PERSON_ID',
ORGANISATION_ID [nvarchar](1024) 'PERSON_ID',
ROLE [nvarchar](1024) 'ROLE',
PLANNED_RESEARCHER_COMMITMENT [float] 'PLANNED_RESEARCHER_COMMITMENT',
ASSOCIATION_PERIOD_START_DATE [date] 'ASSOCIATION_PERIOD_START_DATE',
ASSOCIATION_PERIOD_END_DATE [date] 'ASSOCIATION_PERIOD_END_DATE'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
GO

CREATE TABLE [dbo].[INTERNAL_PROJECT_ORGANISATIONS](
    [PROJECT_ID] [nvarchar](1024) NOT NULL,
    [ORGANISATION_ID] [nvarchar](1024) NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\INTERNAL_PROJECT_ORGANISATIONS.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[INTERNAL_PROJECT_ORGANISATIONS]
SELECT PROJECT_ID, ORGANISATION_ID
FROM OPENXML(@hDoc, 'data/row')
WITH
(
PROJECT_ID [nvarchar](1024) 'PROJECT_ID',
ORGANISATION_ID [nvarchar](1024) 'ORGANISATION_ID'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
GO

CREATE TABLE [dbo].[ORGANISATION_DATA](
    [ORGANISATION_ID] [nvarchar](255) NOT NULL,
    [TYPE] [nvarchar](255) NULL,
    [NAME] [nvarchar](255) NULL,
    [START_DATE] [date] NULL,
    [END_DATE] [date] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\ORGANISATION_DATA.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[ORGANISATION_DATA]
SELECT ORGANISATION_ID, TYPE, NAME, START_DATE, END_DATE
FROM OPENXML(@hDoc, 'data/row')
WITH
(
  [ORGANISATION_ID] [nvarchar](255) 'ORGANISATION_ID',
  [TYPE] [nvarchar](255) 'TYPE',
  [NAME] [nvarchar](255) 'NAME',
  [START_DATE] [date] 'START_DATE',
  [END_DATE] [date] 'END_DATE'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
GO

CREATE TABLE [dbo].[ORGANISATION_HIERARCHY](
    [PARENT_ORGANISATION_ID] [nvarchar](255) NOT NULL,
    [CHILD_ORGANISATION_ID] [nvarchar](255) NOT NULL,
    [START_DATE] [date] NULL,
    [END_DATE] [date] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\ORGANISATION_HIERARCHY.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[ORGANISATION_HIERARCHY]
SELECT PARENT_ORGANISATION_ID, CHILD_ORGANISATION_ID, START_DATE, END_DATE
FROM OPENXML(@hDoc, 'data/row')
WITH
(
  [PARENT_ORGANISATION_ID] [nvarchar](255) 'PARENT_ORGANISATION_ID',
  [CHILD_ORGANISATION_ID] [nvarchar](255) 'CHILD_ORGANISATION_ID',
  [START_DATE] [date] 'START_DATE',
  [END_DATE] [date] 'END_DATE'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
GO

CREATE TABLE [dbo].[ORGANISATION_NAME_VARIANTS](
    [ORGANISATION_ID] [nvarchar](255) NOT NULL,
    [TYPE] [nvarchar](255) NULL,
    [NAME_VARIANT] [nvarchar](255) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\ORGANISATION_NAME_VARIANTS.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[ORGANISATION_NAME_VARIANTS]
SELECT ORGANISATION_ID, TYPE, NAME_VARIANT
FROM OPENXML(@hDoc, 'data/row')
WITH
(
  [ORGANISATION_ID] [nvarchar](255) 'ORGANISATION_ID',
  [TYPE] [nvarchar](255) 'TYPE',
  [NAME_VARIANT] [nvarchar](255) 'NAME_VARIANT'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
GO

CREATE TABLE [dbo].[PERSON_PHOTO_INFORMATION](
    [PERSON_ID] [nvarchar](255) NOT NULL,
    [PROFILE_PHOTO] [nvarchar](255) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\PERSON_PHOTO_INFORMATION.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[PERSON_PHOTO_INFORMATION]
SELECT PERSON_ID, PROFILE_PHOTO
FROM OPENXML(@hDoc, 'data/row')
WITH
(
  [PERSON_ID] [nvarchar](255) 'PERSON_ID',
  [PROFILE_PHOTO] [nvarchar](255) 'PROFILE_PHOTO'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
GO

CREATE TABLE [dbo].[PERSON_PROFILE_INFORMATION](
    [PERSON_ID] [nvarchar](255) NOT NULL,
    [PROFILE_TYPE] [nvarchar](255) NULL,
    [TEXT] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\PERSON_PROFILE_INFORMATION.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[PERSON_PROFILE_INFORMATION]
SELECT PERSON_ID, PROFILE_TYPE, TEXT
FROM OPENXML(@hDoc, 'data/row')
WITH
(
  [PERSON_ID] [nvarchar](255) 'PERSON_ID',
  [PROFILE_TYPE] [nvarchar](255) 'PROFILE_TYPE',
  [TEXT] [nvarchar](max) 'TEXT'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
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

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\PERSON_SAPDATA.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[PERSON_SAPDATA]
SELECT PERSON_ID,
       USERNAME,
       TITLE,
       POST_NOMINALS,
       FIRST_NAME,
       LAST_NAME,
       FIRST_NAME_KNOWN_AS,
       LAST_NAME_KNOWN_AS,
       LAST_NAME_SORT,
       PREVIOUS_LAST_NAME,
       GENDER,
       NATIONALITY,
       EMAIL,
       DATE_OF_BIRTH,
       RETIRAL_DATE
FROM OPENXML(@hDoc, 'data/row')
WITH
(
  [PERSON_ID] [nvarchar](255) 'PERSON_ID',
  [USERNAME] [nvarchar](255) 'USERNAME',
  [TITLE] [nvarchar](255) 'TITLE',
  [POST_NOMINALS] [nvarchar](255) 'POST_NOMINALS',
  [FIRST_NAME] [nvarchar](255) 'FIRST_NAME',
  [LAST_NAME] [nvarchar](255) 'LAST_NAME',
  [FIRST_NAME_KNOWN_AS] [nvarchar](255) 'FIRST_NAME_KNOWN_AS',
  [LAST_NAME_KNOWN_AS] [nvarchar](255) 'LAST_NAME_KNOWN_AS',
  [LAST_NAME_SORT] [nvarchar](255) 'LAST_NAME_SORT',
  [PREVIOUS_LAST_NAME] [nvarchar](255) 'PREVIOUS_LAST_NAME',
  [GENDER] [nvarchar](255) 'GENDER',
  [NATIONALITY] [nvarchar](255) 'NATIONALITY',
  [EMAIL] [nvarchar](255) 'EMAIL',
  [DATE_OF_BIRTH] [date] 'DATE_OF_BIRTH',
  [RETIRAL_DATE] [date] 'RETIRAL_DATE'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
GO

CREATE TABLE [dbo].[PROJECT_DATA](
    [PROJECT_ID] [nvarchar](1024) NOT NULL,
    [PROJECT_TYPE] [nvarchar](1024) NOT NULL,
    [TITLE] [nvarchar](1024) NOT NULL,
    [SHORT_TITLE] [nvarchar](256) NULL,
    [START_DATE] [date] NULL,
    [END_DATE] [date] NULL,
    [CURTAIL_DATE] [date] NULL,
    [CURTAIL_REASON] [nvarchar](256) NULL,
    [MANAGED_BY_ORG_ID] [nvarchar](1024) NOT NULL,
    [COLLABORATIVE_PROJECT] [bit] NOT NULL,
    [VISIBILITY] [nvarchar](1024) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\PROJECT_DATA.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[PROJECT_DATA]
SELECT PROJECT_ID,
       PROJECT_TYPE,
       TITLE,
       SHORT_TITLE,
       START_DATE,
       END_DATE,
       CURTAIL_DATE,
       CURTAIL_REASON,
       MANAGED_BY_ORG_ID,
       COLLABORATIVE_PROJECT,
       VISIBILITY
FROM OPENXML(@hDoc, 'data/row')
WITH
(
  [PROJECT_ID] [nvarchar](1024) 'PROJECT_ID',
  [PROJECT_TYPE] [nvarchar](1024) 'PROJECT_TYPE',
  [TITLE] [nvarchar](1024) 'TITLE',
  [SHORT_TITLE] [nvarchar](256) 'SHORT_TITLE',
  [START_DATE] [date] 'START_DATE',
  [END_DATE] [date] 'END_DATE',
  [CURTAIL_DATE] [date] 'CURTAIL_DATE',
  [CURTAIL_REASON] [nvarchar](256) 'CURTAIL_REASON',
  [MANAGED_BY_ORG_ID] [nvarchar](1024) 'MANAGED_BY_ORG_ID',
  [COLLABORATIVE_PROJECT] [bit] 'COLLABORATIVE_PROJECT',
  [VISIBILITY] [nvarchar](1024) 'VISIBILITY'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
GO

CREATE TABLE [dbo].[PROJECT_IDS](
    [PROJECT_ID] [nvarchar](max) NOT NULL,
    [ID_SOURCE] [nvarchar](max) NOT NULL,
    [ID] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\PROJECT_IDS.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[PROJECT_IDS]
SELECT PROJECT_ID,
       ID_SOURCE,
       ID
FROM OPENXML(@hDoc, 'data/row')
WITH
(
  [PROJECT_ID] [nvarchar](max) 'PROJECT_ID',
  [ID_SOURCE] [nvarchar](max) 'ID_SOURCE',
  [ID] [nvarchar](max) 'ID'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
GO

CREATE TABLE [dbo].[PROJECT_KEYWORDS](
    [TYPE] [nvarchar](255) NULL,
    [PROJECT_ID] [nvarchar](1024) NOT NULL,
    [LOGICAL_NAME] [nvarchar](1024) NOT NULL,
    [FREE_KEYWORD] [nvarchar](1024) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\PROJECT_KEYWORDS.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[PROJECT_KEYWORDS]
SELECT TYPE,
       PROJECT_ID,
       LOGICAL_NAME,
       FREE_KEYWORD
FROM OPENXML(@hDoc, 'data/row')
WITH
(
  [TYPE] [nvarchar](255) 'TYPE',
  [PROJECT_ID] [nvarchar](1024) 'PROJECT_ID',
  [LOGICAL_NAME] [nvarchar](1024) 'LOGICAL_NAME',
  [FREE_KEYWORD] [nvarchar](1024) 'FREE_KEYWORD'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
GO

CREATE TABLE [dbo].[PROJECT_PROJECT_RELATION](
    [PROJECT_ID] [nvarchar](1024) NOT NULL,
    [TARGET_PROJECT_ID] [nvarchar](1024) NOT NULL,
    [RELATION_TYPE] [nvarchar](1024) NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\PROJECT_PROJECT_RELATION.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[PROJECT_PROJECT_RELATION]
SELECT PROJECT_ID,
       TARGET_PROJECT_ID,
       RELATION_TYPE
FROM OPENXML(@hDoc, 'data/row')
WITH
(
  [PROJECT_ID] [nvarchar](1024) 'PROJECT_ID',
  [TARGET_PROJECT_ID] [nvarchar](1024) 'TARGET_PROJECT_ID',
  [RELATION_TYPE] [nvarchar](1024) 'RELATION_TYPE'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
GO

CREATE TABLE [dbo].[PROJECT_UPMPROJECTTYPES](
	[CLASSIFICATION_ID] [nvarchar](50) NOT NULL,
	[CLASSIFICATION_LABEL] [nvarchar](50) NOT NULL,
	[CLASSIFICATION_URI] [nvarchar](100) NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\PROJECT_UPMPROJECTTYPES.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[PROJECT_UPMPROJECTTYPES]
SELECT CLASSIFICATION_ID,
       CLASSIFICATION_LABEL,
       CLASSIFICATION_URI
FROM OPENXML(@hDoc, 'data/row')
WITH
(
  [CLASSIFICATION_ID] [nvarchar](50) 'CLASSIFICATION_ID',
	[CLASSIFICATION_LABEL] [nvarchar](50) 'CLASSIFICATION_LABEL',
	[CLASSIFICATION_URI] [nvarchar](100) 'CLASSIFICATION_URI'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
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

CREATE TABLE [dbo].[XMLWITHOPENXML](
    Id INT IDENTITY PRIMARY KEY,
    XMLData XML,
    LoadedDateTime DATETIME
) ON [PRIMARY]

INSERT INTO [dbo].[XMLWITHOPENXML](XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\08. input\STAFF_ORGANISATION_RELATION.xml', SINGLE_BLOB) AS x;

DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM [dbo].[XMLWITHOPENXML]

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO [dbo].[STAFF_ORGANISATION_RELATION]
SELECT STAFF_ORGANISATION_RELATION_ID,
       PERSON_ID,
       ORGANISATION_ID,
       JOB_TITLE,
       EMPLOYED_AS,
       JOB_DESCRIPTION,
       EXOFFICIO_DEPARTMENTAL_ROLE,
       DIRECT_PHONE_NR,
       MOBILE_PHONE_NR,
       EMAIL,
       WORK_ADDRESS_ONE,
       WORK_ADDRESS_TWO,
       WORK_ADDRESS_THREE,
       WORK_POSTAL_CODE,
       WORK_COUNTRY,
       START_DATE,
       END_DATE,
       FTE
FROM OPENXML(@hDoc, 'data/row')
WITH
(
  [STAFF_ORGANISATION_RELATION_ID] [nvarchar](255) 'STAFF_ORGANISATION_RELATION_ID',
  [PERSON_ID] [nvarchar](255) 'PERSON_ID',
  [ORGANISATION_ID] [nvarchar](255) 'ORGANISATION_ID',
  [JOB_TITLE] [nvarchar](255) 'JOB_TITLE',
  [EMPLOYED_AS] [nvarchar](255) 'EMPLOYED_AS',
  [JOB_DESCRIPTION] [nvarchar](255) 'JOB_DESCRIPTION',
  [EXOFFICIO_DEPARTMENTAL_ROLE] [nvarchar](255) 'EXOFFICIO_DEPARTMENTAL_ROLE',
  [DIRECT_PHONE_NR] [nvarchar](255) 'DIRECT_PHONE_NR',
  [MOBILE_PHONE_NR] [nvarchar](255) 'MOBILE_PHONE_NR',
  [EMAIL] [nvarchar](255) 'EMAIL',
  [WORK_ADDRESS_ONE] [nvarchar](255) 'WORK_ADDRESS_ONE',
  [WORK_ADDRESS_TWO] [nvarchar](255) 'WORK_ADDRESS_TWO',
  [WORK_ADDRESS_THREE] [nvarchar](255) 'WORK_ADDRESS_THREE',
  [WORK_POSTAL_CODE] [nvarchar](255) 'WORK_POSTAL_CODE',
  [WORK_COUNTRY] [nvarchar](255) 'WORK_COUNTRY',
  [START_DATE] [date] 'START_DATE',
  [END_DATE] [date] 'END_DATE',
  [FTE] [float] 'FTE'
)

EXEC sp_xml_removedocument @hDoc

DROP TABLE [dbo].[XMLWITHOPENXML]
GO

/* VIEWS */

CREATE VIEW [dbo].[PERSON_DATA]
AS
SELECT
    dbo.PERSON_SAPDATA.PERSON_ID
    ,dbo.PERSON_SAPDATA.USERNAME
    ,dbo.PERSON_SAPDATA.TITLE
    ,dbo.PERSON_SAPDATA.POST_NOMINALS
    ,dbo.PERSON_SAPDATA.FIRST_NAME
    ,dbo.PERSON_SAPDATA.LAST_NAME
    ,dbo.PERSON_SAPDATA.FIRST_NAME_KNOWN_AS
    ,dbo.PERSON_SAPDATA.LAST_NAME_KNOWN_AS
    ,dbo.PERSON_SAPDATA.LAST_NAME_SORT
    ,dbo.PERSON_SAPDATA.PREVIOUS_LAST_NAME
    ,dbo.PERSON_SAPDATA.GENDER
    ,dbo.PERSON_SAPDATA.NATIONALITY
    ,dbo.PERSON_SAPDATA.EMAIL
    ,dbo.PERSON_SAPDATA.DATE_OF_BIRTH
    ,dbo.PERSON_SAPDATA.RETIRAL_DATE
    ,(SELECT COUNT(
       PERSON_ID)
    FROM dbo.STAFF_ORGANISATION_RELATION
    WHERE dbo.STAFF_ORGANISATION_RELATION.PERSON_ID = dbo.PERSON_SAPDATA.PERSON_ID)
    as "NUMBEROFAFFILIATIONS"
FROM dbo.PERSON_SAPDATA
WHERE dbo.PERSON_SAPDATA.USERNAME <> '' AND dbo.PERSON_SAPDATA.EMAIL <> ''

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "PERSON_SAPDATA"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 136
               Right = 264
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PERSON_PHOTO_INFORMATION"
            Begin Extent =
               Top = 6
               Left = 302
               Bottom = 173
               Right = 481
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_DATA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_DATA'
GO

CREATE VIEW [dbo].[PERSON_NAMES]
AS
SELECT     PERSON_ID, CONCAT(PERSON_ID, '_knownas') as "ID", 'knownas' as TYPE, FIRST_NAME_KNOWN_AS as "FIRST_NAME", LAST_NAME_KNOWN_AS as "LAST_NAME"
FROM        dbo.PERSON_SAPDATA
UNION ALL
SELECT     PERSON_ID, CONCAT(PERSON_ID, '_former') as "ID", 'former' as TYPE, '' as "FIRST_NAME", PREVIOUS_LAST_NAME as "LAST_NAME"
FROM        dbo.PERSON_SAPDATA
WHERE PREVIOUS_LAST_NAME <> ''
UNION ALL
SELECT     PERSON_ID, CONCAT(PERSON_ID, '_sort') as "ID", 'sort' as TYPE, '' as "FIRST_NAME", LAST_NAME_SORT as "LAST_NAME"
FROM        dbo.PERSON_SAPDATA

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "PERSON_SAPDATA"
            Begin Extent =
               Top = 7
               Left = 48
               Bottom = 170
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 8
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_NAMES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_NAMES'
GO

CREATE VIEW [dbo].[PERSON_PHOTOS]
AS
SELECT     PERSON_ID, CONCAT(PERSON_ID, '_portrait') as "ID", 'portrait' as TYPE, PROFILE_PHOTO as "VALUE", 'HTTP' as "PROTOCOL"
FROM        dbo.PERSON_PHOTO_INFORMATION

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "PERSON_PHOTO_INFORMATION"
            Begin Extent =
               Top = 7
               Left = 48
               Bottom = 170
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 8
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_PHOTOS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_PHOTOS'
GO

CREATE VIEW [dbo].[PERSON_PROFILES]
AS
SELECT        PERSON_ID, PROFILE_TYPE, TEXT AS PROFILE_TEXT
FROM            dbo.PERSON_PROFILE_INFORMATION
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[24] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "PERSON_PROFILE_INFORMATION"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 119
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_PROFILES'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_PROFILES'
GO

CREATE VIEW [dbo].[PERSON_TITLES]
AS
SELECT     PERSON_ID, CONCAT(PERSON_ID, '_generic') as "ID", 'generic' as TYPE, TITLE as "VALUE"
FROM        dbo.PERSON_SAPDATA
WHERE TITLE <> ''
UNION ALL
SELECT     PERSON_ID, CONCAT(PERSON_ID, '_postnominal') as "ID", 'postnominal' as TYPE, POST_NOMINALS as "VALUE"
FROM        dbo.PERSON_SAPDATA
WHERE POST_NOMINALS <> ''


GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "PERSON_SAPDATA"
            Begin Extent =
               Top = 7
               Left = 48
               Bottom = 170
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 8
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_TITLES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_TITLES'
GO

CREATE VIEW [dbo].[PROJECT_DATA_PLUS]
AS
SELECT dbo.PROJECT_DATA.PROJECT_ID, dbo.PROJECT_DATA.PROJECT_TYPE, dbo.PROJECT_DATA.TITLE, dbo.PROJECT_DATA.SHORT_TITLE, dbo.PROJECT_DATA.START_DATE, dbo.PROJECT_DATA.END_DATE, dbo.PROJECT_DATA.CURTAIL_DATE, dbo.PROJECT_DATA.CURTAIL_REASON, dbo.PROJECT_DATA.MANAGED_BY_ORG_ID, dbo.PROJECT_DATA.COLLABORATIVE_PROJECT, dbo.PROJECT_DATA.VISIBILITY,
          dbo.PROJECT_UPMPROJECTTYPES.CLASSIFICATION_ID, dbo.PROJECT_UPMPROJECTTYPES.CLASSIFICATION_URI
FROM   dbo.PROJECT_DATA INNER JOIN
          dbo.PROJECT_UPMPROJECTTYPES ON dbo.PROJECT_DATA.PROJECT_TYPE = dbo.PROJECT_UPMPROJECTTYPES.CLASSIFICATION_LABEL
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "PROJECT_DATA_1"
            Begin Extent =
               Top = 13
               Left = 86
               Bottom = 293
               Right = 525
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "PROJECT_UPMPROJECTTYPES"
            Begin Extent =
               Top = 13
               Left = 611
               Bottom = 254
               Right = 952
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PROJECT_DATA_PLUS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PROJECT_DATA_PLUS'
GO

CREATE VIEW [dbo].STAFF_PERSON_COMMS
AS
SELECT     STAFF_ORGANISATION_RELATION_ID, PERSON_ID, 'phone' as TYPE, DIRECT_PHONE_NR as "VALUE"
FROM        dbo.STAFF_ORGANISATION_RELATION
UNION ALL
SELECT     STAFF_ORGANISATION_RELATION_ID, PERSON_ID, 'mobilephone' as TYPE, MOBILE_PHONE_NR as "VALUE"
FROM        dbo.STAFF_ORGANISATION_RELATION
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "STAFF_ORGANISATION_RELATION"
            Begin Extent =
               Top = 7
               Left = 48
               Bottom = 170
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 8
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'STAFF_PERSON_COMMS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'STAFF_PERSON_COMMS'
GO

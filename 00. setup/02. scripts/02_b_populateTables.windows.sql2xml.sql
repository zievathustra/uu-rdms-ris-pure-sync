/*
[DATE]          2020-05-08
[ORGANISATION]  Utrecht University
[EMPLOYEE]      Arjan Sieverink
[CONTACT1]      https://www.uu.nl/staff/JASieverink
[REMARKS]       Populate database tables via BULK INSERT
*/

USE PUREP_Staging
GO

DECLARE @path2typefolder nvarchar(255);
DECLARE @path2subfolder nvarchar(255);
SET @path2typefolder = 'C:\\Users\\arjan\\Universiteit Utrecht\\Team Pure2AWS - Documents\\General\\sql2xmlData\\';
SET @path2subfolder = '\\data\\import2sql\\';

BULK
INSERT dbo.ORGANISATION_DATA
FROM @path2typefolder + 'organisations' + @path2subfolder + 'X_ORGANISATION_DATA.import2sql.data.organisations.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.ORGANISATION_HIERARCHY
FROM @path2typefolder + 'organisations' + @path2subfolder + 'X_ORGANISATION_HIERARCHY.import2sql.data.organisations.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.ORGANISATION_NAME_VARIANTS
FROM @path2typefolder + 'organisations' + @path2subfolder + 'ORGANISATION_NAME_VARIANTS.import2sql.data.organisations.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PERSON_SAPDATA
FROM @path2typefolder + 'persons' + @path2subfolder + 'X_PERSON_SAPDATA.import2sql.data.persons.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PERSON_PHOTO_INFORMATION
FROM @path2typefolder + 'persons' + @path2subfolder + 'PERSON_PHOTO_INFORMATION.import2sql.data.persons.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.STAFF_ORGANISATION_RELATION
FROM @path2typefolder + 'persons' + @path2subfolder + 'X_STAFF_ORGANISATION_RELATION.import2sql.data.persons.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO
BULK
INSERT dbo.INTERNAL_PARTICIPANTS
FROM @path2typefolder + 'projects' + @path2subfolder + 'X_INTERNAL_PARTICIPANTS.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.INTERNAL_PROJECT_ORGANISATIONS
FROM @path2typefolder + 'projects' + @path2subfolder + 'INTERNAL_PROJECT_ORGANISATIONS.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PROJECT_DATA
FROM @path2typefolder + 'projects' + @path2subfolder + 'X_PROJECT_DATA.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PROJECT_IDS
FROM @path2typefolder + 'projects' + @path2subfolder + 'PROJECT_IDS.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PROJECT_KEYWORDS
FROM @path2typefolder + 'projects' + @path2subfolder + 'PROJECT_KEYWORDS.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PROJECT_PROJECT_RELATION
FROM @path2typefolder + 'projects' + @path2subfolder + 'PROJECT_PROJECT_RELATION.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

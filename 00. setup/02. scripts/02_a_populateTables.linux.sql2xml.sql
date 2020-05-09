/*
[DATE]          2020-05-08
[ORGANISATION]  Utrecht University
[EMPLOYEE]      Arjan Sieverink
[CONTACT1]      https://www.uu.nl/staff/JASieverink
[REMARKS]       Populate database tables via BULK INSERT
*/

USE PUREP_Staging
GO

BULK
INSERT dbo.ORGANISATION_DATA
FROM '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/organisations/data/import2sql/X_ORGANISATION_DATA.import2sql.data.organisations.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.ORGANISATION_HIERARCHY
FROM '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/organisations/data/import2sql/X_ORGANISATION_HIERARCHY.import2sql.data.organisations.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.ORGANISATION_NAME_VARIANTS
FROM '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/organisations/data/import2sql/ORGANISATION_NAME_VARIANTS.import2sql.data.organisations.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PERSON_SAPDATA
FROM '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/persons/data/import2sql/X_PERSON_SAPDATA.import2sql.data.persons.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PERSON_PHOTO_INFORMATION
FROM '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/persons/data/import2sql/PERSON_PHOTO_INFORMATION.import2sql.data.persons.sql2xml.csv'
WITH
(
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.STAFF_ORGANISATION_RELATION
FROM '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/persons/data/import2sql/X_STAFF_ORGANISATION_RELATION.import2sql.data.persons.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.INTERNAL_PARTICIPANTS
FROM '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/projects/data/import2sql/X_INTERNAL_PARTICIPANTS.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.INTERNAL_PROJECT_ORGANISATIONS
FROM '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/projects/data/import2sql/INTERNAL_PROJECT_ORGANISATIONS.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PROJECT_DATA
FROM '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/projects/data/import2sql/X_PROJECT_DATA.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PROJECT_IDS
FROM '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/projects/data/import2sql/PROJECT_IDS.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PROJECT_KEYWORDS
FROM '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/projects/data/import2sql/PROJECT_KEYWORDS.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PROJECT_PROJECT_RELATION
FROM '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/projects/data/import2sql/PROJECT_PROJECT_RELATION.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

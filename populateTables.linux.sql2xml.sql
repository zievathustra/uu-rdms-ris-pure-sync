/*
[DATE]			2020-03-26
[ORGANISATION]	Utrecht University
[EMPLOYEE]		Arjan Sieverink
[CONTACT1]		https://www.uu.nl/staff/JASieverink
[CONTACT2]		https://www.linkedin.com/in/arjansieverink
[REMARKS]		Populate database tables via BULK INSERT
*/

USE PUREP_Staging
GO

BULK
INSERT dbo.ORGANISATION_DATA
FROM '/home/sieve002/uusharepoint/Team Pure2AWS - Documents/General/sql2xmlData/organisations/data/import2sql/X_ORGANISATION_DATA.import2sql.data.organisations.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.ORGANISATION_HIERARCHY
FROM '/home/sieve002/uusharepoint/Team Pure2AWS - Documents/General/sql2xmlData/organisations/data/import2sql/X_ORGANISATION_HIERARCHY.import2sql.data.organisations.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.ORGANISATION_NAME_VARIANTS
FROM '/home/sieve002/uusharepoint/Team Pure2AWS - Documents/General/sql2xmlData/organisations/data/import2sql/ORGANISATION_NAME_VARIANTS.import2sql.data.organisations.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PERSON_SAPDATA
FROM '/home/sieve002/uusharepoint/Team Pure2AWS - Documents/General/sql2xmlData/persons/data/import2sql/X_PERSON_SAPDATA.import2sql.data.persons.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.PERSON_PHOTO_INFORMATION
FROM '/home/sieve002/uusharepoint/Team Pure2AWS - Documents/General/sql2xmlData/persons/data/import2sql/PERSON_PHOTO_INFORMATION.import2sql.data.persons.sql2xml.csv'
WITH
(
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT dbo.STAFF_ORGANISATION_RELATION
FROM '/home/sieve002/uusharepoint/Team Pure2AWS - Documents/General/sql2xmlData/persons/data/import2sql/X_STAFF_ORGANISATION_RELATION.import2sql.data.persons.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

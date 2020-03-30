/*
[DATE]		2020-03-25
[ORGANISATION]	Utrecht University
[EMPLOYEE]	Arjan Sieverink
[CONTACT1]	https://www.uu.nl/staff/JASieverink
[CONTACT2]	https://www.linkedin.com/in/arjansieverink
*/

USE PUREP_Staging
GO

BULK
INSERT dbo.ORGANISATION_HIERARCHY
FROM '/home/sieve002/uusharepoint/Team Pure2AWS - Documents/General/sql2xmlData/organisations/data/import2sql/ORGANISATION_HIERARCHY.import2sql.data.persons.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO
/*
2020-03-25, Utrecht University, Arjan Sieverink, https://www.uu.nl/staff/JASieverink, https://www.linkedin.com/in/arjansieverink
*/
USE PUREP_Staging
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

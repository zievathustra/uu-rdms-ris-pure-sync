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
INSERT dbo.PERSON_PHOTO_INFORMATION
FROM '/home/sieve002/uusharepoint/Team Pure2AWS - Documents/General/sql2xmlData/persons/data/import2sql/PERSON_PHOTO_INFORMATION.import2sql.data.persons.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO
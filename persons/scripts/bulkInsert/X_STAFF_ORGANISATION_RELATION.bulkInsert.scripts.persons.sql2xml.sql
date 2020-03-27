/*
[DATE]		2020-03-25
[ORGANISATION]	Utrecht University
[EMPLOYEE]	Arjan Sieverink
[CONTACT1]	https://www.uu.nl/staff/JASieverink
[CONTACT2]	https://www.linkedin.com/in/arjansieverink
[REMARKS]	X_ version (modified) of original script since data in csv file needed manipulation
[CHANGES]	<01>	replace '" "' values with <nothing>
		<02>	replace 'NULL' with <nothing>
*/

USE PUREP_Staging
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

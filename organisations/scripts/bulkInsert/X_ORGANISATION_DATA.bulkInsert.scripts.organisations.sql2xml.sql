/*
[DATE]		2020-03-25
[ORGANISATION]	Utrecht University
[EMPLOYEE]	Arjan Sieverink
[CONTACT1]	https://www.uu.nl/staff/JASieverink
[CONTACT2]	https://www.linkedin.com/in/arjansieverink
[REMARKS]	X_ version (modified) of original script since data in csv file needed manipulation
[CHANGES]	<01>	replace '" "' values with <nothing> in source fie
		<02>	replace 'NULL' values with <nothing> in source file
*/
USE PUREP_Staging
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

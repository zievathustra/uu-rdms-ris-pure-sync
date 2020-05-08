/*
2020-05-07, Utrecht University, Arjan Sieverink, https://www.uu.nl/staff/JASieverink
*/
USE PUREP_Staging
BULK
INSERT dbo.INTERNAL_PARTICIPANTS
FROM 'C:\Users\Sieve002\Universiteit Utrecht\Team Pure2AWS - Documents\General\sql2xmlData\projects\data\import2sql\X_INTERNAL_PARTICIPANTS.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO
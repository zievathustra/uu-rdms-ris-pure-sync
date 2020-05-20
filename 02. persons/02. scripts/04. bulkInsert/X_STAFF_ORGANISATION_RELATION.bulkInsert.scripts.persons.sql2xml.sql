/*
[DATE]            2020-03-25
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
[REMARKS]         X_ version (modified) of original script since data in csv file needed manipulation
[CHANGES]         <01>    replace '" "' values with <nothing>
                  <02>    replace 'NULL' with <nothing>
*/

USE PUREP_Staging
GO

DECLARE @path2typefolder nvarchar(255);
DECLARE @path2subfolder nvarchar(255);
SET @path2typefolder = '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/';
SET @path2subfolder = '/data/import2sql/';

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

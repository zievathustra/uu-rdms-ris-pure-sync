/*
[DATE]            2020-03-25
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
[REMARKS]         X_ version (modified) of original script since data in csv file needed manipulation
[CHANGES]        <01>    replace '" "' values with <nothing> in source fie
                 <02>    replace 'NULL' values with <nothing> in source file
*/

USE PUREP_Staging
GO

DECLARE @path2typefolder nvarchar(255);
DECLARE @path2subfolder nvarchar(255);
SET @path2typefolder = '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/';
SET @path2subfolder = '/data/import2sql/';

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

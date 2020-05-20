/*
[DATE]          2020-03-25
[ORGANISATION]  Utrecht University
[EMPLOYEE]      Arjan Sieverink
[CONTACT1]      https://www.uu.nl/staff/JASieverink
*/

USE PUREP_Staging
GO

DECLARE @path2typefolder nvarchar(255);
DECLARE @path2subfolder nvarchar(255);
SET @path2typefolder = '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/';
SET @path2subfolder = '/data/import2sql/';

BULK
INSERT dbo.ORGANISATION_NAME_VARIANTS
FROM @path2typefolder + 'organisations' + @path2subfolder + 'ORGANISATION_NAME_VARIANTS.import2sql.data.organisations.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

//*
[DATE]            2020-05-07
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
*/

USE PUREP_Staging
GO

DECLARE @path2typefolder nvarchar(255);
DECLARE @path2subfolder nvarchar(255);
SET @path2typefolder = '/home/sieve002/Insync/j.a.sieverink@uu.nl/OneDrive Biz - SharePoint/Team Pure2AWS - Documents/General/sql2xmlData/';
SET @path2subfolder = '/data/import2sql/';

BULK
INSERT dbo.INTERNAL_PROJECT_ORGANISATIONS
FROM @path2typefolder + 'projects'+ @path2subfolder + 'INTERNAL_PROJECT_ORGANISATIONS.import2sql.data.projects.sql2xml.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO

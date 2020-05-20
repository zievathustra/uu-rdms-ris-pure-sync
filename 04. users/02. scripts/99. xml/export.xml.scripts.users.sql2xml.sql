USE PUREP_Staging
GO

DECLARE @x xml;
DECLARE @file nvarchar(255);
SET @file = 'D:\MSSQL\XML_OUTPUT\USERS\users.xml';

WITH xmlnamespaces(
      'v1.user-sync.pure.atira.dk' as v1,
      'v3.commons.pure.atira.dk' as v3)
SELECT @x = (
SELECT 
      tblData.person_id as "@id",
      tblData.username as "v1:userName",
      tblData.email as "v1:email",
      tblData.first_name as "v1:name/v3:firstname",
      tblData.last_name as "v1:name/v3:lastname"
FROM [dbo].[PERSON_SAPDATA] as tblData
ORDER BY tblData.person_id
FOR XML PATH('v1:user'), ROOT('v1:users'), ELEMENTS XSINIL)

EXEC dbo.XMLExportToFile @x, @file
GO
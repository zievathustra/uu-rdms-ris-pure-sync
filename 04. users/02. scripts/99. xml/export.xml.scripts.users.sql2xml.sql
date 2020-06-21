USE PUREP_Staging
GO

DECLARE @x xml;
DECLARE @file nvarchar(255);
SET @file = 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\09. ouput\users.xml';

WITH xmlnamespaces(
      'v1.user-sync.pure.atira.dk' as v1,
      'v3.commons.pure.atira.dk' as v3)
SELECT @x = (
SELECT
      vwPersons.person_id as "@id",
      vwPersons.username as "v1:userName",
      vwPersons.email as "v1:email",
      vwPersons.first_name as "v1:name/v3:firstname",
      vwPersons.last_name as "v1:name/v3:lastname"
FROM [dbo].[PERSON_DATA] as vwPersons
ORDER BY vwPersons.person_id
FOR XML PATH('v1:user'), ROOT('v1:users'))

EXEC dbo.XMLExportToFile @x, @file
GO

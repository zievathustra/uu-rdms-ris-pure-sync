/*
[DATE]            2020-03-25
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
[CONTACT2]        https://www.linkedin.com/in/arjansieverink
*/

USE [PUREP_Staging]
GO

WITH xmlnamespaces(
      'v1.user-sync.pure.atira.dk' as v1,
      'v3.commons.pure.atira.dk' as v3)
SELECT 
      tblData.person_id as "@id",
      tblData.username as "v1:userName",
      tblData.email as "v1:email",
      tblData.first_name as "v1:name/v3:firstname",
      tblData.last_name as "v1:name/v3:lastname"
FROM [dbo].[PERSON_SAPDATA] as tblData
ORDER BY tblData.person_id
FOR XML PATH('v1:user'), ROOT('v1:users'), ELEMENTS XSINIL;
GO
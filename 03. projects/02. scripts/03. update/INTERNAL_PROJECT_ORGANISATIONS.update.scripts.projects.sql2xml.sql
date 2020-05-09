/*
[DATE]            2020-05-08
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
[REMARKS]         Some tables contain CR/LF characters. FOR XML... escapes these characters
                  to &#x0d; when formatting the output xml. The update script removes the CR/LF up front.
*/

USE PUREP_Staging
GO

UPDATE dbo.INTERNAL_PROJECT_ORGANISATIONS
    SET ORGANISATION_ID = REPLACE(REPLACE(ORGANISATION_ID, CHAR(13), ''), CHAR(10), '')
GO

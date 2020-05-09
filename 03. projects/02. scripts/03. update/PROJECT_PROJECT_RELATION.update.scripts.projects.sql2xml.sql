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

UPDATE dbo.PROJECT_PROJECT_RELATION
    SET RELATION_TYPE = REPLACE(REPLACE(RELATION_TYPE, CHAR(13), ''), CHAR(10), '')
GO

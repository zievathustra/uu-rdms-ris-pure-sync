/*
[DATE]		2020-03-26
[ORGANISATION]	Utrecht University
[EMPLOYEE]	Arjan Sieverink
[CONTACT1]	https://www.uu.nl/staff/JASieverink
[CONTACT2]	https://www.linkedin.com/in/arjansieverink
[REMARKS]	Reserved characters in table columns may break the script generating the xml with an error like
		'FOR XML could not serialize the data for node because it contains a character (0x000E)'.
		Identify the records as follows:
			SELECT TEXT FROM dbo.PERSON_PROFILE_INFORMATION WHERE TEXT like '%' + char(0x000C) + '%'
 		Use the UPDATE statement to replace such characters.
*/


USE PUREP_Staging
GO

UPDATE dbo.PERSON_PROFILE_INFORMATION
	SET TEXT = REPLACE(TEXT, char(0x000C), '')
WHERE TEXT like '%' + char(0x000C) + '%'
GO

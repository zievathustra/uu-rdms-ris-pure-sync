USE PUREP_Staging
GO

UPDATE dbo.PERSON_PROFILE_INFORMATION
    SET TEXT = REPLACE(TEXT, char(0x000C), '')
WHERE TEXT like '%' + char(0x000C) + '%'

GO

DECLARE @x xml;
DECLARE @file nvarchar(255);
SET @file = 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\09. ouput\persons.xml';

WITH xmlnamespaces(
    'v1.unified-person-sync.pure.atira.dk' as v1,
    'v3.commons.pure.atira.dk' as v3
)
SELECT @x = (
SELECT
    vwPersons.PERSON_ID as "@id"
    ,'false' as "@managedInPure"
    ,vwPersons.FIRST_NAME as "v1:name/v3:firstname"
    ,vwPersons.LAST_NAME as "v1:name/v3:lastname"
   ,(SELECT
        vwNames.ID as "v1:classifiedName/@id"
        ,vwNames.FIRST_NAME as "v1:classifiedName/v1:name/v3:firstname"
        ,vwNames.LAST_NAME as "v1:classifiedName/v1:name/v3:lastname"
        ,vwNames.[TYPE] as "v1:classifiedName/v1:typeClassification"
    FROM dbo.PERSON_NAMES as vwNames
    WHERE vwNames.PERSON_ID = vwPersons.PERSON_ID
    FOR XML PATH(''), ROOT('v1:names'), TYPE)
   ,(SELECT
        vwTitles.ID as "v1:title/@id"
        ,vwTitles.TYPE as "v1:title/v1:typeClassification"
        ,'en' as "v1:title/v1:value/v3:text/@lang"
        ,'GB' as "v1:title/v1:value/v3:text/@country"
        ,vwTitles.VALUE as "v1:title/v1:value/v3:text"
    FROM dbo.PERSON_TITLES as vwTitles
    WHERE vwTitles.PERSON_ID = vwPersons.PERSON_ID
    FOR XML PATH(''), ROOT('v1:titles'), TYPE)
    ,'Unknown' as "v1:gender"
    ,(SELECT
        vwPhotos.ID as "v1:personPhoto/@id"
        ,vwPhotos.TYPE as "v1:personPhoto/v1:classification"
        ,vwPhotos.VALUE as "v1:personPhoto/v1:data/v1:http/v1:url"
    FROM dbo.PERSON_PHOTOS as vwPhotos
    WHERE vwPhotos.PERSON_ID = vwPersons.PERSON_ID
    FOR XML PATH(''), ROOT('v1:photos'), TYPE)
    ,(SELECT
        tblAffiliations.STAFF_ORGANISATION_RELATION_ID as "@id"
        ,'false' as "@managedInPure"
        ,tblAffiliations.ORGANISATION_ID as "v1:affiliationId"
        ,tblAffiliations.STAFF_ORGANISATION_RELATION_ID as "v1:addresses/v3:classifiedAddress/@id"
        ,'postal' as "v1:addresses/v3:classifiedAddress/v3:addressType"
        ,REPLACE(tblAffiliations.WORK_ADDRESS_THREE, WORK_POSTAL_CODE + '  ','') as "v1:addresses/v3:classifiedAddress/v3:city"
        ,tblAffiliations.WORK_POSTAL_CODE as "v1:addresses/v3:classifiedAddress/v3:postalCode"
        ,tblAffiliations.WORK_ADDRESS_TWO as "v1:addresses/v3:classifiedAddress/v3:street"
        ,CASE
              WHEN tblAffiliations.WORK_COUNTRY <> '' THEN tblAffiliations.WORK_COUNTRY
        END as "v1:addresses/v3:classifiedAddress/v3:country"
        ,tblAffiliations.WORK_ADDRESS_ONE as "v1:addresses/v3:classifiedAddress/v3:building"
        ,tblAffiliations.WORK_ADDRESS_ONE + CHAR(10) + tblAffiliations.WORK_ADDRESS_TWO + CHAR(10) + tblAffiliations.WORK_ADDRESS_THREE as "v1:addresses/v3:classifiedAddress/v3:displayFormat"
        ,(SELECT
            vwComms.TYPE + '@' + vwComms.STAFF_ORGANISATION_RELATION_ID as "@id"
           ,vwComms.TYPE as "v3:classification"
           ,vwComms.VALUE as "v3:value"
        FROM dbo.STAFF_PERSON_COMMS as vwComms
        WHERE vwComms.STAFF_ORGANISATION_RELATION_ID = tblAffiliations.STAFF_ORGANISATION_RELATION_ID AND ISNULL(vwComms.VALUE,'') <> ''
        FOR XML PATH('v3:classifiedPhoneNumber'), ROOT('v1:phoneNumbers'), TYPE)
        ,CASE
            WHEN ISNULL(tblAffiliations.EMAIL, '') <> '' THEN  tblAffiliations.STAFF_ORGANISATION_RELATION_ID
        END as "v1:emails/v3:classifiedEmail/@id"
        ,CASE
            WHEN ISNULL(tblAffiliations.EMAIL, '') <> '' THEN 'email'
        END as "v1:emails/v3:classifiedEmail/v3:classification"
        ,CASE
            WHEN ISNULL(tblAffiliations.EMAIL, '') <> '' THEN tblAffiliations.EMAIL
        END as "v1:emails/v3:classifiedEmail/v3:value"
        ,tblAffiliations.EMPLOYED_AS as "v1:employmentType"
        ,'false' as "v1:primaryAssociation"
        ,tblAffiliations.ORGANISATION_ID as "v1:organisation/v3:source_id"
        ,tblAffiliations.START_DATE as "v1:period/v3:startDate"
        ,CASE
             WHEN isnull(tblAffiliations.END_DATE,'') <> '' THEN tblAffiliations.END_DATE
        END as "v1:period/v3:endDate"
        ,CASE
            WHEN tblAffiliations.EXOFFICIO_DEPARTMENTAL_ROLE <> ' ' THEN 'exofficio'
        END as "v1:keywords/v3:logicalGroup/@logicalName"
        ,CASE
            WHEN tblAffiliations.EXOFFICIO_DEPARTMENTAL_ROLE <> ' ' THEN tblAffiliations.EXOFFICIO_DEPARTMENTAL_ROLE
        END as "v1:keywords/v3:logicalGroup/v3:structuredKeywords/v3:structuredKeyword/@classification"
        ,'academic' as "v1:staffType"
        ,tblAffiliations.JOB_TITLE as "v1:jobTitle"
    FROM dbo.STAFF_ORGANISATION_RELATION as tblAffiliations
    WHERE tblAffiliations.PERSON_ID = vwPersons.PERSON_ID
    FOR XML PATH('v1:staffOrganisationAssociation'), ROOT('v1:organisationAssociations'), TYPE)
    ,(SELECT
        vwProfiles.PERSON_ID + '_' + vwProfiles.PROFILE_TYPE as "v1:personCustomField/@id"
        ,vwProfiles.PROFILE_TYPE as "v1:personCustomField/v1:typeClassification"
        ,vwProfiles.PROFILE_TEXT as "v1:personCustomField/v1:value/v3:text"
    FROM dbo.PERSON_PROFILES as vwProfiles
    WHERE vwProfiles.PERSON_ID = vwPersons.PERSON_ID
    FOR XML PATH(''), ROOT('v1:profileInformation'), TYPE)
    ,vwPersons.PERSON_ID as "v1:user/@id"
    ,'employee' as "v1:personIds/v3:id/@type"
    ,vwPersons.PERSON_ID as "v1:personIds/v3:id/@id"
    ,vwPersons.PERSON_ID as "v1:personIds/v3:id"
FROM dbo.PERSON_DATA as vwPersons
WHERE vwPersons.NUMBEROFAFFILIATIONS>0
ORDER BY vwPersons.PERSON_ID
FOR XML PATH('v1:person'), ROOT('v1:persons')
)

EXEC dbo.XMLExportToFile @x, @file
GO

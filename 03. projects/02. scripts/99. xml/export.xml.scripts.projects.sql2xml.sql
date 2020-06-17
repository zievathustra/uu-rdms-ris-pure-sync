USE PUREP_Staging
GO

UPDATE dbo.INTERNAL_PROJECT_ORGANISATIONS
    SET ORGANISATION_ID = REPLACE(REPLACE(ORGANISATION_ID, CHAR(13), ''), CHAR(10), '')

GO

UPDATE dbo.PROJECT_PROJECT_RELATION
    SET RELATION_TYPE = REPLACE(REPLACE(RELATION_TYPE, CHAR(13), ''), CHAR(10), '')

GO

DECLARE @x xml;
DECLARE @file nvarchar(255);
SET @file = 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\09. ouput\projects.xml';

WITH xmlnamespaces(
    'v1.upmproject.pure.atira.dk' as v1,
    'v3.commons.pure.atira.dk' as v3
)
SELECT @x = (
SELECT
    vwProjects.PROJECT_ID as "@id"
    ,vwProjects.classification_id as "@type"
    ,'false' as "@managedInPure"
    ,'en' as "v1:title/v3:text/@lang"
    ,'GB' as "v1:title/v3:text/@country"
    ,vwProjects.TITLE as "v1:title/v3:text"
    ,'en' as "v1:shortTitle/v3:text/@lang"
    ,'GB' as "v1:shortTitle/v3:text/@country"
    ,vwProjects.SHORT_TITLE as "v1:shortTitle/v3:text"
    ,vwProjects.START_DATE as "v1:startDate"
    ,CASE
         WHEN isnull(vwProjects.END_DATE,'') <> '' THEN vwProjects.END_DATE
    END as "v1:endDate"
    ,(SELECT
        tblParticipants.PERSON_ID as "v1:internalParticipant/v1:personId"
        ,tblParticipants.ORGANISATION_ID as "v1:internalParticipant/v1:organisationIds/v1:organisation/@id"
        ,LOWER(tblParticipants.ROLE) as "v1:internalParticipant/v1:role"
        ,tblParticipants.ASSOCIATION_PERIOD_START_DATE as "v1:internalParticipant/v1:associationStartDate"
        ,CASE
            WHEN isnull(tblParticipants.ASSOCIATION_PERIOD_END_DATE,'') <> '' THEN tblParticipants.ASSOCIATION_PERIOD_END_DATE
         END as "v1:internalParticipant/v1:associationEndDate"
      FROM dbo.INTERNAL_PARTICIPANTS as tblParticipants
      WHERE tblParticipants.PROJECT_ID = vwProjects.PROJECT_ID
      FOR XML PATH(''), ROOT('v1:internalParticipants'), TYPE)
    ,(SELECT
        tblProjectOrganisations.ORGANISATION_ID as "v1:organisation/@id"
    FROM dbo.INTERNAL_PROJECT_ORGANISATIONS as tblProjectOrganisations
    WHERE tblProjectOrganisations.PROJECT_ID = vwProjects.PROJECT_ID
    FOR XML PATH(''), ROOT('v1:organisations'), TYPE)
    ,vwProjects.MANAGED_BY_ORG_ID as "v1:managedByOrganisation/@id"
    ,(SELECT
        tblRelatedProjects.TARGET_PROJECT_ID as "v1:relatedProject/v1:targetProjectId"
        ,tblRelatedProjects.RELATION_TYPE as "v1:relatedProject/v1:relationType"
    FROM dbo.PROJECT_PROJECT_RELATION as tblRelatedProjects
    WHERE tblRelatedProjects.PROJECT_ID = vwProjects.PROJECT_ID
    FOR XML PATH(''), ROOT('v1:relatedProjects'), TYPE)
    ,CASE
	    WHEN (SELECT COUNT(PROJECT_ID) FROM dbo.PROJECT_KEYWORDS as tblKeywords WHERE tblKeywords.PROJECT_ID = vwProjects.PROJECT_ID) > 0 THEN
		(SELECT 
			'/dk/atira/pure/project/keywords/my_structured_keywords' as "@logicalName"
			,(SELECT
					tblKeywords.LOGICAL_NAME + '/' + tblKeywords.TYPE as "v3:structuredKeyword/@classification"
			FROM dbo.PROJECT_KEYWORDS as tblKeywords
			WHERE tblKeywords.PROJECT_ID = vwProjects.PROJECT_ID
			FOR XML PATH(''), ROOT('v3:structuredKeywords'), TYPE)
		  FOR XML PATH('v3:logicalGroup'), ROOT('v1:keywords'), TYPE)
	END
    ,dbo.fProperCase(vwProjects.VISIBILITY,null,null) as "v1:visibility"
FROM dbo.PROJECT_DATA_PLUS as vwProjects
FOR XML PATH('v1:upmproject'), ROOT('v1:upmprojects')
)

EXEC dbo.XMLExportToFile @x, @file
GO
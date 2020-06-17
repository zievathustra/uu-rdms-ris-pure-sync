USE PUREP_Staging
GO

DECLARE @x xml;
DECLARE @file nvarchar(255);
SET @file = 'C:\Users\arjan\OneDrive - Universiteit Utrecht\uu-rdms-ris-pure-sync\09. ouput\organisations.xml';

WITH xmlnamespaces(
      'v1.organisation-sync.pure.atira.dk' as v1
      ,'v3.commons.pure.atira.dk' as v3)
SELECT @x = (
SELECT
      'false' as "@managedInPure"
      ,tblData.organisation_id as "v1:organisationId"
      ,tblData.type as "v1:type"
      ,'en' as "v1:name/v3:text/@lang"
      ,'NL' as "v1:name/v3:text/@country",
      tblData.name as "v1:name/v3:text"
      ,tblData.start_date as "v1:startDate"
      ,CASE
            WHEN isnull(tblData.END_DATE,'') <> '' THEN tblData.END_DATE
      END as "v1:endDate"
      ,'Public' as "v1:visibility"
      ,tblHierarchy.parent_organisation_id as "v1:parentOrganisationId"
      ,(
      SELECT 
            tblNameVars.type as "v1:nameVariant/v1:type"
            ,'en' as "v1:nameVariant/v1:name/v3:text/@lang"
            ,'NL' as "v1:nameVariant/v1:name/v3:text/@country"
            ,tblNameVars.name_variant as "v1:nameVariant/v1:name/v3:text"
      FROM [dbo].ORGANISATION_NAME_VARIANTS as tblNameVars
      WHERE tblNameVars.organisation_id = tblData.organisation_id
      FOR XML PATH(''),ROOT('v1:nameVariants'), TYPE
      )
FROM [dbo].[ORGANISATION_DATA] as tblData
LEFT OUTER JOIN [dbo].ORGANISATION_HIERARCHY as tblHierarchy ON tblData.organisation_id = tblHierarchy.child_organisation_id
ORDER BY tblData.type, tblData.ORGANISATION_ID
FOR XML PATH('v1:organisation'),ROOT('v1:organisations'))

EXEC dbo.XMLExportToFile @x, @file
GO
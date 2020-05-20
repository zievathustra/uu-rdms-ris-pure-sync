USE [PUREP_Staging]
GO

/****** Object:  StoredProcedure [dbo].[GetOrganisations]    Script Date: 5/11/2020 13:44:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		SIEVE002
-- Create date: 2020-05-11
-- Description:	Get Organisations
-- =============================================
CREATE PROCEDURE [dbo].[GetOrganisations] 
	-- Add the parameters for the stored procedure here
	-- @p1 int = 0, 
	-- @p2 int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	WITH xmlnamespaces(
		  'v1.organisation-sync.pure.atira.dk' as v1
		  ,'v3.commons.pure.atira.dk' as v3)

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
	FOR XML PATH('v1:organisation'),ROOT('v1:organisations'), TYPE

END
GO


USE [PUREP_Staging]
GO

/****** Object:  StoredProcedure [dbo].[GetProjects]    Script Date: 5/11/2020 13:45:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		SIEVE002
-- Create date: 2020-05-10
-- Description:	Get Projects
-- =============================================
CREATE PROCEDURE [dbo].[GetProjects] 
	-- Add the parameters for the stored procedure here
	--@p1 int = 0, 
	--@p2 int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	WITH xmlnamespaces(
    'v1.upmproject.pure.atira.dk' as "v1",
    'v3.commons.pure.atira.dk' as "v3"
    )

	SELECT
		tblProjects.PROJECT_ID as "@id"
		,tblProjects.PROJECT_TYPE as "@type"
		,'false' as "@managedInPure"
		,'en' as "v1:title/v3:text/@lang"
		,'GB' as "v1:title/v3:text/@country"
		,tblProjects.TITLE as "v1:title/v3:text"
		,'en' as "v1:shortTitle/v3:text/@lang"
		,'GB' as "v1:shortTitle/v3:text/@country"
		,tblProjects.SHORT_TITLE as "v1:shortTitle/v3:text"
		,tblProjects.START_DATE as "v1:startDate"
		,CASE
			 WHEN isnull(tblProjects.END_DATE,'') <> '' THEN tblProjects.END_DATE
		END as "v1:endDate"
		,(SELECT
			tblParticipants.PERSON_ID as "v1:internalParticipant/v1:personId"
			,tblParticipants.ORGANISATION_ID as "v1:internalParticipant/v1:organisationIds/v1:organisationId"
			,tblParticipants.ROLE as "v1:internalParticipant/v1:role"
			,tblParticipants.ASSOCIATION_PERIOD_START_DATE as "v1:internalParticipant/v1:associationStartDate"
			,CASE
				WHEN isnull(tblParticipants.ASSOCIATION_PERIOD_END_DATE,'') <> '' THEN tblParticipants.ASSOCIATION_PERIOD_END_DATE
			 END as "v1:internalParticipant/v1:associationEndDate"
		  FROM dbo.INTERNAL_PARTICIPANTS as tblParticipants
		  WHERE tblParticipants.PROJECT_ID = tblProjects.PROJECT_ID
		  FOR XML PATH(''), ROOT('v1:internalParticipants'), TYPE)
		,(SELECT
			tblProjectOrganisations.ORGANISATION_ID as "v1:organisation/@id"
		FROM dbo.INTERNAL_PROJECT_ORGANISATIONS as tblProjectOrganisations
		WHERE tblProjectOrganisations.PROJECT_ID = tblProjects.PROJECT_ID
		FOR XML PATH(''), ROOT('v1:organisations'), TYPE)
		,tblProjects.MANAGED_BY_ORG_ID as "v1:managedByOrganisation/@id"
		,(SELECT
			tblRelatedProjects.TARGET_PROJECT_ID as "v1:relatedProject/v1:targetProjectId"
			,tblRelatedProjects.RELATION_TYPE as "v1:relatedProject/v1:relationType"
		FROM dbo.PROJECT_PROJECT_RELATION as tblRelatedProjects
		WHERE tblRelatedProjects.PROJECT_ID = tblProjects.PROJECT_ID
		FOR XML PATH(''), ROOT('v1:relatedProjects'), TYPE)
		,(SELECT
			'my_structured_keywords' as "@logicalName"
			,(SELECT
					tblKeywords.LOGICAL_NAME + '/' + tblKeywords.TYPE as "v3:structuredKeyword/@classification"
			FROM dbo.PROJECT_KEYWORDS as tblKeywords
			WHERE tblKeywords.PROJECT_ID = tblProjects.PROJECT_ID
			FOR XML PATH(''), ROOT('v3:structuredKeywords'), TYPE)
		  FOR XML PATH('v3:logicalGroup'), ROOT('v1:keywords'), TYPE)
	FROM dbo.PROJECT_DATA as tblProjects
	FOR XML PATH('v1:upmproject'), ROOT('v1:upmprojects'), TYPE
	
END
GO


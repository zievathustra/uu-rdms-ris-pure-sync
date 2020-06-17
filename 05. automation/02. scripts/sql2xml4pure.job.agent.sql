USE [msdb]
GO

/****** Object:  Job [sql2xml4Pure]    Script Date: 07-Jun-20 19:25:48 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 07-Jun-20 19:25:48 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'sql2xml4Pure', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Export organisation, person, project and user information from SQL Server tables to xml for import into Pure.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'IDEAPAD\arjan', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [sql2xml4Pure-Organisations]    Script Date: 07-Jun-20 19:25:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sql2xml4Pure-Organisations', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE PUREP_Staging
GO

DECLARE @x xml;
DECLARE @file nvarchar(255);
SET @file = ''D:\MSSQL\XML_OUTPUT\ORGANISATIONS\organisations.xml'';

WITH xmlnamespaces(
      ''v1.organisation-sync.pure.atira.dk'' as v1
      ,''v3.commons.pure.atira.dk'' as v3)
SELECT @x = (
SELECT
      ''false'' as "@managedInPure"
      ,tblData.organisation_id as "v1:organisationId"
      ,tblData.type as "v1:type"
      ,''en'' as "v1:name/v3:text/@lang"
      ,''NL'' as "v1:name/v3:text/@country",
      tblData.name as "v1:name/v3:text"
      ,tblData.start_date as "v1:startDate"
      ,CASE
            WHEN isnull(tblData.END_DATE,'''') <> '''' THEN tblData.END_DATE
      END as "v1:endDate"
      ,''Public'' as "v1:visibility"
      ,tblHierarchy.parent_organisation_id as "v1:parentOrganisationId"
      ,(
      SELECT 
            tblNameVars.type as "v1:nameVariant/v1:type"
            ,''en'' as "v1:nameVariant/v1:name/v3:text/@lang"
            ,''NL'' as "v1:nameVariant/v1:name/v3:text/@country"
            ,tblNameVars.name_variant as "v1:nameVariant/v1:name/v3:text"
      FROM [dbo].ORGANISATION_NAME_VARIANTS as tblNameVars
      WHERE tblNameVars.organisation_id = tblData.organisation_id
      FOR XML PATH(''''),ROOT(''v1:nameVariants''), TYPE
      )
FROM [dbo].[ORGANISATION_DATA] as tblData
LEFT OUTER JOIN [dbo].ORGANISATION_HIERARCHY as tblHierarchy ON tblData.organisation_id = tblHierarchy.child_organisation_id
ORDER BY tblData.type, tblData.ORGANISATION_ID
FOR XML PATH(''v1:organisation''),ROOT(''v1:organisations''))

EXEC dbo.XMLExportToFile @x, @file
GO', 
		@database_name=N'PUREP_Staging', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [sql2xml4Pure-Persons]    Script Date: 07-Jun-20 19:25:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sql2xml4Pure-Persons', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE PUREP_Staging
GO

UPDATE dbo.PERSON_PROFILE_INFORMATION
    SET TEXT = REPLACE(TEXT, char(0x000C), '''')
WHERE TEXT like ''%'' + char(0x000C) + ''%''

GO

DECLARE @x xml;
DECLARE @file nvarchar(255);
SET @file = ''D:\MSSQL\XML_OUTPUT\PERSONS\persons.xml'';

WITH xmlnamespaces(
    ''v1.unified-person-sync.pure.atira.dk'' as v1,
    ''v3.commons.pure.atira.dk'' as v3
)
SELECT @x = (
SELECT
    vwPersons.PERSON_ID as "@id"
    ,''false'' as "@managedInPure"
    ,vwPersons.FIRST_NAME as "v1:name/v3:firstname"
    ,vwPersons.LAST_NAME as "v1:name/v3:lastname"
   ,(SELECT
        vwNames.ID as "v1:classifiedName/@id"
        ,vwNames.FIRST_NAME as "v1:classifiedName/v1:name/v3:firstname"
        ,vwNames.LAST_NAME as "v1:classifiedName/v1:name/v3:lastname"
        ,vwNames.[TYPE] as "v1:classifiedName/v1:typeClassification"
    FROM dbo.PERSON_NAMES as vwNames
    WHERE vwNames.PERSON_ID = vwPersons.PERSON_ID
    FOR XML PATH(''''), ROOT(''v1:names''), TYPE)
   ,(SELECT 
        vwTitles.ID as "v1:title/@id"
        ,vwTitles.TYPE as "v1:title/v1:typeClassification"
        ,''en'' as "v1:title/v1:value/v3:text/@lang"
        ,''GB'' as "v1:title/v1:value/v3:text/@country"
        ,vwTitles.VALUE as "v1:title/v1:value/v3:text"
    FROM dbo.PERSON_TITLES as vwTitles
    WHERE vwTitles.PERSON_ID = vwPersons.PERSON_ID
    FOR XML PATH(''''), ROOT(''v1:titles''), TYPE)
    ,''Unknown'' as "v1:gender"
    ,(SELECT
        vwPhotos.ID as "v1:personPhoto/@id"
        ,vwPhotos.TYPE as "v1:personPhoto/v1:classification"
        ,vwPhotos.VALUE as "v1:personPhoto/v1:data/v1:http/v1:url"
    FROM dbo.PERSON_PHOTOS as vwPhotos
    WHERE vwPhotos.PERSON_ID = vwPersons.PERSON_ID
    FOR XML PATH(''''), ROOT(''v1:photos''), TYPE)
    ,(SELECT
        tblAffiliations.STAFF_ORGANISATION_RELATION_ID as "@id"
        ,''false'' as "@managedInPure"
        ,tblAffiliations.ORGANISATION_ID as "v1:affiliationId"
        ,tblAffiliations.STAFF_ORGANISATION_RELATION_ID as "v1:addresses/v3:classifiedAddress/@id"
        ,''postal'' as "v1:addresses/v3:classifiedAddress/v3:addressType"
        ,REPLACE(tblAffiliations.WORK_ADDRESS_THREE, WORK_POSTAL_CODE + ''  '','''') as "v1:addresses/v3:classifiedAddress/v3:city"
        ,tblAffiliations.WORK_POSTAL_CODE as "v1:addresses/v3:classifiedAddress/v3:postalCode"
        ,tblAffiliations.WORK_ADDRESS_TWO as "v1:addresses/v3:classifiedAddress/v3:street"
        ,CASE
              WHEN tblAffiliations.WORK_COUNTRY <> '''' THEN tblAffiliations.WORK_COUNTRY
        END as "v1:addresses/v3:classifiedAddress/v3:country"
        ,tblAffiliations.WORK_ADDRESS_ONE as "v1:addresses/v3:classifiedAddress/v3:building"
        ,tblAffiliations.WORK_ADDRESS_ONE + CHAR(10) + tblAffiliations.WORK_ADDRESS_TWO + CHAR(10) + tblAffiliations.WORK_ADDRESS_THREE as "v1:addresses/v3:classifiedAddress/v3:displayFormat"
        ,(SELECT
            vwComms.STAFF_ORGANISATION_RELATION_ID as "@id"
           ,vwComms.TYPE as "v3:classification"
           ,vwComms.VALUE as "v3:value"
        FROM dbo.STAFF_PERSON_COMMS as vwComms
        WHERE vwComms.STAFF_ORGANISATION_RELATION_ID = tblAffiliations.STAFF_ORGANISATION_RELATION_ID AND ISNULL(vwComms.VALUE,'''') <> ''''
        FOR XML PATH(''v3:classifiedPhoneNumber''), ROOT(''v1:phoneNumbers''), TYPE)
        ,CASE
            WHEN ISNULL(tblAffiliations.EMAIL, '''') <> '''' THEN  tblAffiliations.STAFF_ORGANISATION_RELATION_ID 
        END as "v1:emails/v3:classifiedEmail/@id"
        ,CASE
            WHEN ISNULL(tblAffiliations.EMAIL, '''') <> '''' THEN ''email'' 
        END as "v1:emails/v3:classifiedEmail/v3:classification"
        ,CASE
            WHEN ISNULL(tblAffiliations.EMAIL, '''') <> '''' THEN tblAffiliations.EMAIL 
        END as "v1:emails/v3:classifiedEmail/v3:value"
        ,tblAffiliations.EMPLOYED_AS as "v1:employmentType"
        ,''false'' as "v1:primaryAssociation"
        ,tblAffiliations.ORGANISATION_ID as "v1:organisation/v3:source_id"
        ,tblAffiliations.START_DATE as "v1:period/v3:startDate"
        ,CASE
             WHEN isnull(tblAffiliations.END_DATE,'''') <> '''' THEN tblAffiliations.END_DATE
        END as "v1:period/v3:endDate"
        ,CASE
            WHEN tblAffiliations.EXOFFICIO_DEPARTMENTAL_ROLE <> '' '' THEN ''exofficio''
        END as "v1:keywords/v3:logicalGroup/@logicalName"
        ,CASE
            WHEN tblAffiliations.EXOFFICIO_DEPARTMENTAL_ROLE <> '' '' THEN tblAffiliations.EXOFFICIO_DEPARTMENTAL_ROLE
        END as "v1:keywords/v3:logicalGroup/v3:structuredKeywords/v3:structuredKeyword/@classification"
        ,''academic'' as "v1:staffType"
        ,tblAffiliations.JOB_TITLE as "v1:jobTitle"
    FROM dbo.STAFF_ORGANISATION_RELATION as tblAffiliations
    WHERE tblAffiliations.PERSON_ID = vwPersons.PERSON_ID
    FOR XML PATH(''v1:staffOrganisationAssociation''), ROOT(''v1:organisationAssociations''), TYPE)
    ,(SELECT
        vwProfiles.PERSON_ID + ''_'' + vwProfiles.PROFILE_TYPE as "v1:personCustomField/@id"
        ,vwProfiles.PROFILE_TYPE as "v1:personCustomField/v1:typeClassification"
        ,vwProfiles.PROFILE_TEXT as "v1:personCustomField/v1:value/v3:text"
    FROM dbo.PERSON_PROFILES as vwProfiles
    WHERE vwProfiles.PERSON_ID = vwPersons.PERSON_ID
    FOR XML PATH(''''), ROOT(''v1:profileInformation''), TYPE)
    ,vwPersons.PERSON_ID as "v1:user/@id"
    ,''employee'' as "v1:personIds/v3:id/@type"
    ,vwPersons.PERSON_ID as "v1:personIds/v3:id/@id"
    ,vwPersons.PERSON_ID as "v1:personIds/v3:id"
FROM dbo.PERSON_DATA as vwPersons
WHERE vwPersons.NUMBEROFAFFILIATIONS>0
ORDER BY vwPersons.PERSON_ID
FOR XML PATH(''v1:person''), ROOT(''v1:persons'')
)

EXEC dbo.XMLExportToFile @x, @file
GO', 
		@database_name=N'PUREP_Staging', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [sql2xml4Pure-Projects]    Script Date: 07-Jun-20 19:25:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sql2xml4Pure-Projects', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE PUREP_Staging
GO

UPDATE dbo.INTERNAL_PROJECT_ORGANISATIONS
    SET ORGANISATION_ID = REPLACE(REPLACE(ORGANISATION_ID, CHAR(13), ''''), CHAR(10), '''')

GO

UPDATE dbo.PROJECT_PROJECT_RELATION
    SET RELATION_TYPE = REPLACE(REPLACE(RELATION_TYPE, CHAR(13), ''''), CHAR(10), '''')

GO

DECLARE @x xml;
DECLARE @file nvarchar(255);
SET @file = ''D:\MSSQL\XML_OUTPUT\PROJECTS\projects.xml'';

WITH xmlnamespaces(
    ''v1.upmproject.pure.atira.dk'' as v1,
    ''v3.commons.pure.atira.dk'' as v3
)
SELECT @x = (
SELECT
    vwProjects.PROJECT_ID as "@id"
    ,vwProjects.classification_id as "@type"
    ,''false'' as "@managedInPure"
    ,''en'' as "v1:title/v3:text/@lang"
    ,''GB'' as "v1:title/v3:text/@country"
    ,vwProjects.TITLE as "v1:title/v3:text"
    ,''en'' as "v1:shortTitle/v3:text/@lang"
    ,''GB'' as "v1:shortTitle/v3:text/@country"
    ,vwProjects.SHORT_TITLE as "v1:shortTitle/v3:text"
    ,vwProjects.START_DATE as "v1:startDate"
    ,CASE
         WHEN isnull(vwProjects.END_DATE,'''') <> '''' THEN vwProjects.END_DATE
    END as "v1:endDate"
    ,(SELECT
        tblParticipants.PERSON_ID as "v1:internalParticipant/v1:personId"
        ,tblParticipants.ORGANISATION_ID as "v1:internalParticipant/v1:organisationIds/v1:organisation/@id"
        ,LOWER(tblParticipants.ROLE) as "v1:internalParticipant/v1:role"
        ,tblParticipants.ASSOCIATION_PERIOD_START_DATE as "v1:internalParticipant/v1:associationStartDate"
        ,CASE
            WHEN isnull(tblParticipants.ASSOCIATION_PERIOD_END_DATE,'''') <> '''' THEN tblParticipants.ASSOCIATION_PERIOD_END_DATE
         END as "v1:internalParticipant/v1:associationEndDate"
      FROM dbo.INTERNAL_PARTICIPANTS as tblParticipants
      WHERE tblParticipants.PROJECT_ID = vwProjects.PROJECT_ID
      FOR XML PATH(''''), ROOT(''v1:internalParticipants''), TYPE)
    ,(SELECT
        tblProjectOrganisations.ORGANISATION_ID as "v1:organisation/@id"
    FROM dbo.INTERNAL_PROJECT_ORGANISATIONS as tblProjectOrganisations
    WHERE tblProjectOrganisations.PROJECT_ID = vwProjects.PROJECT_ID
    FOR XML PATH(''''), ROOT(''v1:organisations''), TYPE)
    ,vwProjects.MANAGED_BY_ORG_ID as "v1:managedByOrganisation/@id"
    ,(SELECT
        tblRelatedProjects.TARGET_PROJECT_ID as "v1:relatedProject/v1:targetProjectId"
        ,tblRelatedProjects.RELATION_TYPE as "v1:relatedProject/v1:relationType"
    FROM dbo.PROJECT_PROJECT_RELATION as tblRelatedProjects
    WHERE tblRelatedProjects.PROJECT_ID = vwProjects.PROJECT_ID
    FOR XML PATH(''''), ROOT(''v1:relatedProjects''), TYPE)
    ,CASE
	    WHEN (SELECT COUNT(PROJECT_ID) FROM dbo.PROJECT_KEYWORDS as tblKeywords WHERE tblKeywords.PROJECT_ID = vwProjects.PROJECT_ID) > 0 THEN
		(SELECT 
			''my_structured_keywords'' as "@logicalName"
			,(SELECT
					tblKeywords.LOGICAL_NAME + ''/'' + tblKeywords.TYPE as "v3:structuredKeyword/@classification"
			FROM dbo.PROJECT_KEYWORDS as tblKeywords
			WHERE tblKeywords.PROJECT_ID = vwProjects.PROJECT_ID
			FOR XML PATH(''''), ROOT(''v3:structuredKeywords''), TYPE)
		  FOR XML PATH(''v3:logicalGroup''), ROOT(''v1:keywords''), TYPE)
	END
    ,dbo.fProperCase(vwProjects.VISIBILITY,null,null) as "v1:visibility"
FROM dbo.PROJECT_DATA_PLUS as vwProjects
FOR XML PATH(''v1:upmproject''), ROOT(''v1:upmprojects'')
)

EXEC dbo.XMLExportToFile @x, @file
GO', 
		@database_name=N'PUREP_Staging', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [sql2xml4Pure-Users]    Script Date: 07-Jun-20 19:25:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sql2xml4Pure-Users', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE PUREP_Staging
GO

DECLARE @x xml;
DECLARE @file nvarchar(255);
SET @file = ''D:\MSSQL\XML_OUTPUT\USERS\users.xml'';

WITH xmlnamespaces(
      ''v1.user-sync.pure.atira.dk'' as v1,
      ''v3.commons.pure.atira.dk'' as v3)
SELECT @x = (
SELECT 
      tblData.person_id as "@id",
      tblData.username as "v1:userName",
      tblData.email as "v1:email",
      tblData.first_name as "v1:name/v3:firstname",
      tblData.last_name as "v1:name/v3:lastname"
FROM [dbo].[PERSON_SAPDATA] as tblData
WHERE ISNULL(tblData.username, '''') <> ''''
ORDER BY tblData.person_id
FOR XML PATH(''v1:user''), ROOT(''v1:users''))

EXEC dbo.XMLExportToFile @x, @file
GO', 
		@database_name=N'PUREP_Staging', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'sql2xml4Pure', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=127, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20200520, 
		@active_end_date=99991231, 
		@active_start_time=230000, 
		@active_end_time=235959, 
		@schedule_uid=N'3c031f90-b540-4d51-bbf5-903d1b4b03fe'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


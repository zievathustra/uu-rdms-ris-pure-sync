CREATE TABLE [dbo].[STAFF_ORGANISATION_RELATION] (
    [STAFF_ORGANISATION_RELATION_ID] NVARCHAR (255) NULL,
    [PERSON_ID]                      NVARCHAR (255) NULL,
    [ORGANISATION_ID]                NVARCHAR (255) NULL,
    [JOB_TITLE]                      NVARCHAR (255) NULL,
    [EMPLOYED_AS]                    NVARCHAR (255) NULL,
    [JOB_DESCRIPTION]                NVARCHAR (255) NULL,
    [EXOFFICIO_DEPARTMENTAL_ROLE]    NVARCHAR (255) NULL,
    [DIRECT_PHONE_NR]                NVARCHAR (255) NULL,
    [MOBILE_PHONE_NR]                NVARCHAR (255) NULL,
    [EMAIL]                          NVARCHAR (255) NULL,
    [WORK_ADDRESS_ONE]               NVARCHAR (255) NULL,
    [WORK_ADDRESS_TWO]               NVARCHAR (255) NULL,
    [WORK_ADDRESS_THREE]             NVARCHAR (255) NULL,
    [WORK_POSTAL_CODE]               NVARCHAR (255) NULL,
    [WORK_COUNTRY]                   NVARCHAR (255) NULL,
    [START_DATE]                     DATE           NULL,
    [END_DATE]                       DATE           NULL,
    [FTE]                            FLOAT (53)     NULL
);


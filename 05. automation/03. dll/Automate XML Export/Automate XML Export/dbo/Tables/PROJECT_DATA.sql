CREATE TABLE [dbo].[PROJECT_DATA] (
    [PROJECT_ID]            NVARCHAR (1024) NOT NULL,
    [PROJECT_TYPE]          NVARCHAR (1024) NOT NULL,
    [TITLE]                 NVARCHAR (1024) NOT NULL,
    [SHORT_TITLE]           NVARCHAR (256)  NULL,
    [START_DATE]            DATE            NULL,
    [END_DATE]              DATE            NULL,
    [CURTAIL_DATE]          DATE            NULL,
    [CURTAIL_REASON]        NVARCHAR (256)  NULL,
    [MANAGED_BY_ORG_ID]     NVARCHAR (1024) NOT NULL,
    [COLLABORATIVE_PROJECT] BIT             NOT NULL,
    [VISIBILITY]            NVARCHAR (1024) NULL
);


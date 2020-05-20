/*
[DATE]            2020-03-26
[ORGANISATION]    Utrecht University
[EMPLOYEE]        Arjan Sieverink
[CONTACT1]        https://www.uu.nl/staff/JASieverink
[REMARKS]         Create database tables and views
*/
USE PUREP_Staging
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* TABLES */

CREATE TABLE [dbo].[ORGANISATION_DATA](
    [ORGANISATION_ID] [nvarchar](255) NOT NULL,
    [TYPE] [nvarchar](255) NULL,
    [NAME] [nvarchar](255) NULL,
    [START_DATE] [date] NULL,
    [END_DATE] [date] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ORGANISATION_HIERARCHY](
    [PARENT_ORGANISATION_ID] [nvarchar](255) NOT NULL,
    [CHILD_ORGANISATION_ID] [nvarchar](255) NOT NULL,
    [START_DATE] [date] NULL,
    [END_DATE] [date] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ORGANISATION_NAME_VARIANTS](
    [ORGANISATION_ID] [nvarchar](255) NOT NULL,
    [TYPE] [nvarchar](255) NULL,
    [NAME_VARIANT] [nvarchar](255) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PERSON_PHOTO_INFORMATION](
    [PERSON_ID] [nvarchar](255) NOT NULL,
    [PROFILE_PHOTO] [nvarchar](255) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PERSON_PROFILE_INFORMATION](
    [PERSON_ID] [nvarchar](255) NOT NULL,
    [PROFILE_TYPE] [nvarchar](255) NULL,
    [TEXT] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[PERSON_SAPDATA](
    [PERSON_ID] [nvarchar](255) NOT NULL,
    [USERNAME] [nvarchar](255) NULL,
    [TITLE] [nvarchar](255) NULL,
    [POST_NOMINALS] [nvarchar](255) NULL,
    [FIRST_NAME] [nvarchar](255) NULL,
    [LAST_NAME] [nvarchar](255) NULL,
    [FIRST_NAME_KNOWN_AS] [nvarchar](255) NULL,
    [LAST_NAME_KNOWN_AS] [nvarchar](255) NULL,
    [LAST_NAME_SORT] [nvarchar](255) NULL,
    [PREVIOUS_LAST_NAME] [nvarchar](255) NULL,
    [GENDER] [nvarchar](255) NULL,
    [NATIONALITY] [nvarchar](255) NULL,
    [EMAIL] [nvarchar](255) NULL,
    [DATE_OF_BIRTH] [date] NULL,
    [RETIRAL_DATE] [date] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[STAFF_ORGANISATION_RELATION](
    [STAFF_ORGANISATION_RELATION_ID] [nvarchar](255) NULL,
    [PERSON_ID] [nvarchar](255) NULL,
    [ORGANISATION_ID] [nvarchar](255) NULL,
    [JOB_TITLE] [nvarchar](255) NULL,
    [EMPLOYED_AS] [nvarchar](255) NULL,
    [JOB_DESCRIPTION] [nvarchar](255) NULL,
    [EXOFFICIO_DEPARTMENTAL_ROLE] [nvarchar](255) NULL,
    [DIRECT_PHONE_NR] [nvarchar](255) NULL,
    [MOBILE_PHONE_NR] [nvarchar](255) NULL,
    [EMAIL] [nvarchar](255) NULL,
    [WORK_ADDRESS_ONE] [nvarchar](255) NULL,
    [WORK_ADDRESS_TWO] [nvarchar](255) NULL,
    [WORK_ADDRESS_THREE] [nvarchar](255) NULL,
    [WORK_POSTAL_CODE] [nvarchar](255) NULL,
    [WORK_COUNTRY] [nvarchar](255) NULL,
    [START_DATE] [date] NULL,
    [END_DATE] [date] NULL,
    [FTE] [float] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[INTERNAL_PARTICIPANTS](
    [PROJECT_ID] [nvarchar](1024) NOT NULL,
    [PERSON_ID] [nvarchar](1024) NOT NULL,
    [ORGANISATION_ID] [nvarchar](1024) NOT NULL,
    [ROLE] [nvarchar](1024) NOT NULL,
    [PLANNED_RESEARCHER_COMMITMENT] [float] NULL,
    [ASSOCIATION_PERIOD_START_DATE] [date] NULL,
    [ASSOCIATION_PERIOD_END_DATE] [date] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[INTERNAL_PROJECT_ORGANISATIONS](
    [PROJECT_ID] [nvarchar](1024) NOT NULL,
    [ORGANISATION_ID] [nvarchar](1024) NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PROJECT_DATA](
    [PROJECT_ID] [nvarchar](1024) NOT NULL,
    [PROJECT_TYPE] [nvarchar](1024) NOT NULL,
    [TITLE] [nvarchar](1024) NOT NULL,
    [SHORT_TITLE] [nvarchar](256) NULL,
    [START_DATE] [date] NULL,
    [END_DATE] [date] NULL,
    [CURTAIL_DATE] [date] NULL,
    [CURTAIL_REASON] [nvarchar](256) NULL,
    [MANAGED_BY_ORG_ID] [nvarchar](1024) NOT NULL,
    [COLLABORATIVE_PROJECT] [bit] NOT NULL,
    [VISIBILITY] [nvarchar](1024) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PROJECT_IDS](
    [PROJECT_ID] [nvarchar](max) NOT NULL,
    [ID_SOURCE] [nvarchar](max) NOT NULL,
    [ID] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[PROJECT_KEYWORDS](
    [TYPE] [nvarchar](255) NULL,
    [PROJECT_ID] [nvarchar](1024) NOT NULL,
    [LOGICAL_NAME] [nvarchar](1024) NOT NULL,
    [FREE_KEYWORD] [nvarchar](1024) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PROJECT_PROJECT_RELATION](
    [PROJECT_ID] [nvarchar](1024) NOT NULL,
    [TARGET_PROJECT_ID] [nvarchar](1024) NOT NULL,
    [RELATION_TYPE] [nvarchar](1024) NOT NULL
) ON [PRIMARY]
GO

/* VIEWS */

CREATE VIEW [dbo].[PERSON_DATA]
AS
SELECT
    dbo.PERSON_SAPDATA.PERSON_ID
    ,dbo.PERSON_SAPDATA.USERNAME
    ,dbo.PERSON_SAPDATA.TITLE
    ,dbo.PERSON_SAPDATA.POST_NOMINALS
    ,dbo.PERSON_SAPDATA.FIRST_NAME
    ,dbo.PERSON_SAPDATA.LAST_NAME
    ,dbo.PERSON_SAPDATA.FIRST_NAME_KNOWN_AS
    ,dbo.PERSON_SAPDATA.LAST_NAME_KNOWN_AS
    ,dbo.PERSON_SAPDATA.LAST_NAME_SORT
    ,dbo.PERSON_SAPDATA.PREVIOUS_LAST_NAME
    ,dbo.PERSON_SAPDATA.GENDER
    ,dbo.PERSON_SAPDATA.NATIONALITY
    ,dbo.PERSON_SAPDATA.EMAIL
    ,dbo.PERSON_SAPDATA.DATE_OF_BIRTH
    ,dbo.PERSON_SAPDATA.RETIRAL_DATE
    ,(SELECT COUNT(
       PERSON_ID)
    FROM dbo.STAFF_ORGANISATION_RELATION
    WHERE dbo.STAFF_ORGANISATION_RELATION.PERSON_ID = dbo.PERSON_SAPDATA.PERSON_ID)
    as "NUMBEROFAFFILIATIONS"
FROM dbo.PERSON_SAPDATA

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PERSON_SAPDATA"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 264
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PERSON_PHOTO_INFORMATION"
            Begin Extent = 
               Top = 6
               Left = 302
               Bottom = 173
               Right = 481
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_DATA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_DATA'
GO

CREATE VIEW [dbo].[PERSON_NAMES]
AS
SELECT     PERSON_ID, CONCAT(PERSON_ID, '_knownas') as "ID", 'knownas' as TYPE, FIRST_NAME_KNOWN_AS as "FIRST_NAME", LAST_NAME_KNOWN_AS as "LAST_NAME"
FROM        dbo.PERSON_SAPDATA
UNION ALL
SELECT     PERSON_ID, CONCAT(PERSON_ID, '_former') as "ID", 'former' as TYPE, '' as "FIRST_NAME", PREVIOUS_LAST_NAME as "LAST_NAME"
FROM        dbo.PERSON_SAPDATA
WHERE PREVIOUS_LAST_NAME <> ''
UNION ALL
SELECT     PERSON_ID, CONCAT(PERSON_ID, '_sort') as "ID", 'sort' as TYPE, '' as "FIRST_NAME", LAST_NAME_SORT as "LAST_NAME"
FROM        dbo.PERSON_SAPDATA

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PERSON_SAPDATA"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 8
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_NAMES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_NAMES'
GO

CREATE VIEW [dbo].[PERSON_PHOTOS]
AS
SELECT     PERSON_ID, CONCAT(PERSON_ID, '_portrait') as "ID", 'portrait' as TYPE, PROFILE_PHOTO as "VALUE", 'HTTP' as "PROTOCOL"
FROM        dbo.PERSON_PHOTO_INFORMATION

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PERSON_PHOTO_INFORMATION"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 8
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_PHOTOS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_PHOTOS'
GO

CREATE VIEW [dbo].[PERSON_TITLES]
AS
SELECT     PERSON_ID, CONCAT(PERSON_ID, '_generic') as "ID", 'generic' as TYPE, TITLE as "VALUE"
FROM        dbo.PERSON_SAPDATA
WHERE TITLE <> ''
UNION ALL
SELECT     PERSON_ID, CONCAT(PERSON_ID, '_postnominal') as "ID", 'postnominal' as TYPE, POST_NOMINALS as "VALUE"
FROM        dbo.PERSON_SAPDATA
WHERE POST_NOMINALS <> ''


GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PERSON_SAPDATA"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 8
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_TITLES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_TITLES'
GO

CREATE VIEW [dbo].STAFF_PERSON_COMMS
AS
SELECT     STAFF_ORGANISATION_RELATION_ID, PERSON_ID, 'phone' as TYPE, DIRECT_PHONE_NR as "VALUE"
FROM        dbo.STAFF_ORGANISATION_RELATION
UNION ALL
SELECT     STAFF_ORGANISATION_RELATION_ID, PERSON_ID, 'mobile' as TYPE, MOBILE_PHONE_NR as "VALUE"
FROM        dbo.STAFF_ORGANISATION_RELATION
UNION ALL
SELECT     STAFF_ORGANISATION_RELATION_ID, PERSON_ID, 'email' as TYPE, EMAIL as "VALUE"
FROM        dbo.STAFF_ORGANISATION_RELATION

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "STAFF_ORGANISATION_RELATION"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 8
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'STAFF_PERSON_COMMS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'STAFF_PERSON_COMMS'
GO

CREATE VIEW [dbo].[PERSON_PROFILES]
AS
SELECT        PERSON_ID, PROFILE_TYPE, TEXT AS PROFILE_TEXT
FROM            dbo.PERSON_PROFILE_INFORMATION
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[24] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PERSON_PROFILE_INFORMATION"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_PROFILES'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PERSON_PROFILES'
GO
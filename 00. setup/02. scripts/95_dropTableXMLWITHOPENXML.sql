IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[XMLWITHOPENXML]') AND type in (N'U'))
DROP TABLE [dbo].[XMLWITHOPENXML]
GO
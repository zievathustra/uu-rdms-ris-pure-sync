USE [PUREP_Staging]
GO

/****** Object:  StoredProcedure [dbo].[XmlExportToFile]    Script Date: 27-May-20 16:29:42 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[XmlExportToFile]
	@p1 [xml],
	@p2 [nvarchar](max)
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [Automate_XML_Export].[StoredProcedures].[XMLExport]
GO



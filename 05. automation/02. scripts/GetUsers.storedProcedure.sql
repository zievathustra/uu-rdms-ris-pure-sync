USE [PUREP_Staging]
GO

/****** Object:  StoredProcedure [dbo].[GetUsers]    Script Date: 5/11/2020 13:46:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		SIEVE002
-- Create date: 2020-05-11
-- Description:	Get Users
-- =============================================
CREATE PROCEDURE [dbo].[GetUsers] 
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
      'v1.user-sync.pure.atira.dk' as v1,
      'v3.commons.pure.atira.dk' as v3)

	SELECT 
		  tblData.person_id as "@id",
		  tblData.username as "v1:userName",
		  tblData.email as "v1:email",
		  tblData.first_name as "v1:name/v3:firstname",
		  tblData.last_name as "v1:name/v3:lastname"
	FROM [dbo].[PERSON_SAPDATA] as tblData
	ORDER BY tblData.person_id
	FOR XML PATH('v1:user'), ROOT('v1:users'), TYPE, ELEMENTS XSINIL

END
GO


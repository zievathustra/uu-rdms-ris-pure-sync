# **Pure synchronisations: Automation**

## Introduction
The SQL Server platform offers several options to automate (query) tasks using T-SQL. I checked three different types of automation solutions:
- the **b** ulk **c** opy **p** rogram utility, [bcp](https://docs.microsoft.com/en-us/sql/tools/bcp-utility?view=sql-server-ver15),
- SQL Server Integration Services, [SSIS](https://docs.microsoft.com/en-us/sql/integration-services/packages/run-integration-services-ssis-packages?view=sql-server-ver15) and its dtsx packages and
- [Assemblies](https://docs.microsoft.com/en-us/sql/relational-databases/clr-integration/assemblies-database-engine?view=sql-server-ver15) using Common Language Runtime aka [CLR stored procedures](https://msdn.microsoft.com/library/bbdd51b2-a9b4-4916-ba6f-7957ac6c3f33).

Each type has its own pros and cons. In the end, I chose CLR over bcp and SSIS, since bcp and SSIS did the job but failed to create xml files formatted in such a way that they would pass Pure import validation.

Please note that currently, CLR is supported **on the Windows platform only**.

## Setup
This post on [stackoverflow](https://stackoverflow.com/a/29605579) put me on the right path. I needed nothing more than a piece of code that puts T-SQL output xml nicely formatted into a file on disk. The code does just that. Another post on [www.codeproject.com](https://www.codeproject.com/tips/841439/create-run-debug-and-deploy-sql-clr-function-with) got me started building a solution.

### Create assembly
SQL server accepts a dll file as input for an assembly asset. The procedure is straightforward:
- import the code into a project in an IDE (I used Visual Studio 19),
- compile the code to a dll and
- store the dll on disk for later retrieval.

### Add assembly to database engine
The newly created dll needs to be stored in the staging database. This can be done using the 'New assembly' option under [database]\Programmability\Assemblies which provides a GUI for uploading the dll. Alternatively, adding the assembly can be [scripted in T-SQL](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-assembly-transact-sql?view=sql-server-ver15), too.

Example:

```tsql
CREATE ASSEMBLY assembly_name  
[ AUTHORIZATION owner_name ]  
FROM { <client_assembly_specifier> | <assembly_bits> [ ,...n ] }  
[ WITH PERMISSION_SET = { SAFE | EXTERNAL_ACCESS | UNSAFE } ]  
[ ; ]  
<client_assembly_specifier> :: =  
        '[\\computer_name\]share_name\[path\]manifest_file_name'  
  | '[local_path\]manifest_file_name'  

<assembly_bits> :: =  
{ varbinary_literal | varbinary_expression }
```

Please note the PERMISSION_SET parameter. By design, a CLR dll needs this parameter to be set to EXTERNAL_ACCESS and SQL Server obviously has some built-in restrictions requiring additional security measures to be taken up front. Read this [post on SQLServerCentral](https://www.sqlservercentral.com/articles/how-to-create-a-clr-assembly-on-a-remote-server-with-limited-permissions) for instructions on setting things up 'properly'. Since I built a staging example, I chose to implement a quick & dirty workaround by setting a database property:

```tsql
ALTER DATABASE [database] SET TRUSTWORTHY ON
```

### Create stored procedure
An assembly is just a database asset and it needs a calling function to be put to work. A stored procedure operates as such a calling function and it may be called itself from T-SQL in, let's say, a SQL Server Agent job. A stored procedure may be created via [database]\Programmability\Stored Procedures\New\Stored Procedure in SSMS using the GUI. Scripting is the easily repeatable alternative:

```tsql
USE [database]
GO

/****** Object:  StoredProcedure [dbo].[XmlExportToFile] ******/
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
```
Please observe the **parameters** @p1 and @p2 to be used with the newly created stored procedure. These parameters feed the proper arguments to the method called in the dll.

Please also observe the naming convention used on the line before last starting with EXTERNAL NAME:
- [Automate_XML_Export] identifies the **assembly**
- [StoredProcedures] identifies the **class** containing the method to be called
- [XMLExport] identifies the **method** that does the actual work

### SQL Server Agent
SQL Server Agent runs as a service next to SQL Server. It allows for composing and scheduling jobs that automate, a.o., queries.

#### Job configuration
In SSMS, navigate to the SQL Server Agent\Jobs section in the SQL Server context and right-click to add a new job. The job window opens in the **General** tab. Name the job, accept the default value *[Uncategorized (local)]* and fill out the *Description* section with a brief description of the purpose of the job. Proceed to the **Steps** tab to configure procedure details for all four content types.

##### Composing steps
Since we have four content types, four steps need to be configured. Create the first step and be sure to
- name the step,
- assign the proper type, **Transact-SQL script (T-SQL)**,
- copy the SQL code into the *Command* section,
- click the *Advanced* page on the left side and configure the *On success* and *On failure* actions and
- finish by pressing OK at the bottom of the window.

Repeat this routine for the other three steps. The SQL code pasted into the *Command* section should look like the example below. Details of all content types are provided in the **02. scripts\99. xml** sections of this repository.

Example, step 4 for exporting user information:
```tqsl
USE PUREP_Staging
GO

DECLARE @x xml;
DECLARE @file nvarchar(255);
SET @file = 'C:\users.xml';

WITH xmlnamespaces(
      'v1.user-sync.pure.atira.dk' as v1,
      'v3.commons.pure.atira.dk' as v3)
SELECT @x = (
SELECT
      tblData.person_id as "@id",
      tblData.username as "v1:userName",
      tblData.email as "v1:email",
      tblData.first_name as "v1:name/v3:firstname",
      tblData.last_name as "v1:name/v3:lastname"
FROM [dbo].[PERSON_SAPDATA] as tblData
WHERE ISNULL(tblData.username, '') <> ''
ORDER BY tblData.person_id
FOR XML PATH('v1:user'), ROOT('v1:users'))

EXEC dbo.XMLExportToFile @x, @file
GO
```
##### Scheduling the job
This is the easy part. Open the **Schedules** tab and create a new schedule as you see fit.

#### Testing the job
Navigate to the job in SSMS and right-click, select *Start Job at Step*.

#### Changing job details
Navigate to the job in SSMS and right-click, select *Properties*.

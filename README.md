# **Pure synchronisations: SQL to xml**

## Introduction
Currently, synchronisations of organisations, persons, projects and users from UU systems are configured to run via a **jdbc connection**. Since UU hosts Pure on its own infrastructure, this is fine for now. As we plan to move Pure to Elsevier hosting at Amazon Web Services (AWS), a jdbc connection is considered a **security risk**. While mitigating solutions like tunneling the connection through OpenSSH are readily available, we think that, from an **architectural point of view**, it would be better to not use database connections at all. Therefore, we decided to move to **exchanging xml files**.

## Elsevier documentation
How to setup synchronisations through xml files is well-documented, *to a point that is*. Table and view specifications and references to the appropriate classification schemes are excellent. (Advanced) xml example and xsd files could do with some explanation at times. Furthermore, the example files should be ready for testing via bulk import, I think.

The documentation may be found in the [Elsevier Pure Client Space](https://doc.pure.elsevier.com/pages/viewpage.action?pageId=37685723) (user account needed, have your Pure contact request one for you via [Pure Support](https://support.pure.elsevier.com/secure/Dashboard.jspa)). Synchronisation topics are listed under the Technical User Guides in an appropriately named section, [Synchronizations](https://doc.pure.elsevier.com/display/PureClient/Synchronizations?src=sidebar).

## Closing the gap
What the Elsevier documentation does **not** tell you is **how** to get from tables or views to xml. After hitting just another set of search results that would not do the trick, I happened upon

```SQL
FOR XML PATH()
```
and yes, that got me started. Try this, no database needed:

```SQL
SELECT
    'yoda' as "@id"
    ,'male' as "gender"
    ,'Frank Oz' as "voicedBy"
    ,'Jedi Master' as "title"
    ,'1980' as "appearances/appearance/@year"
    ,'The Empire Strikes Back' as "appearances/appearance"
FOR XML PATH('character'),ROOT('characters')
```
should result in

```XML
<characters>
	<character id="yoda">
		<gender>male</gender>
		<voicedBy>Frank Oz</voicedBy>
		<title>Jedi Master</title>
		<appearances>
			<appearance year="1980">The Empire Strikes Back</appearance>
		</appearances>
	</character>
</characters>
```
Pretty straightforward as a principle, a tad bit more challenging when working with tables, views, nested queries and the likes. Please refer to the content type specific sections for further details. Read up on FOR XML [here](https://docs.microsoft.com/en-us/sql/relational-databases/xml/for-xml-sql-server?view=sql-server-ver15).

## Repository setup
This repo is divided into five main topics:
00. Setup
01. Organisations
02. Persons
03. Projects
04. Users
05. Automation

Each section has its own README.md with details on documentation, scripts and things to consider when setting up and running your own staging environment. The *Setup* topic deals with setting up a local SQL Server staging server on both a Windows and Linux client. The other topics cover the four main Pure synchronisations and running the automated export to xml files.

## Disclaimer
I'm no T-SQL guru...so I started with basic knowledge, I searched the net and where I hit a wall I tried and failed until I got it working again, step by step. Please allow for code that won't win awards and feel free to share your suggestions for improvement.

You're welcome to find me at [Utrecht University](https://www.uu.nl/staff/JASieverink).

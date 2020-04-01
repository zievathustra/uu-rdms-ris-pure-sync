# **Pure synchronisations: Setup**

Obviously, when figuring out how to get from tables and views to importable
 xml, one needs a setup to code and test. Accommodating my own preferences, I
  chose to set up machines for both Windows and Linux. While *en route* this
   choice proved to be a useful one as, sometimes, tool behaviour varied with
    the underlying operating system.

## Machines

### HP EliteBook 840 G3 running Linux

- Pop!OS 19.10
- Microsoft SQL Server 19
- Microsoft Azure Data Studio 1.16

### Lenovo ThinkPad X131e running Windows

- Windows 10 Pro
- Microsoft SQL Server 19
- Microsoft SQL Server Management Studio 18.4

Please find version details at [99. tools/tools.setup.sql2xml.txt](99. tools/tools.setup.sql2xml.txt).

### Caveats

#### Microsoft Azure Data Studio (MADS)

1. *Out-of-the-box* MADS offers *query* functionality, which is all you need
, basically. Tool tip functions that come in handy like 'New database' and
 'Import
 flat file' are available via add-ons in **vsix** format.
2. The Pure xsd / xml is set up to use **namespaces**. Please observe that
 when **opening** the result xml after running a sql2xml script namespace
  identifiers for v1: will be missing *from the formatted xml view*.

#### Microsoft SQL Server Management Studio (SSMS)

1. *Out-of-the-box* SSMS will yield an error when saving large xml files
, > 10Mb that is. This is to do with a default registry setting, so it can be
 set to another value. Using the registry editor turns out to be cumbersome
  as SSMS resets to default upon restart. Persistently setting the value is
   [documented here](https://developercommunity.visualstudio.com/content/problem/39940/the-registry-key-maxfilesizesupportedbylanguageser.html).

## Creating tables and views

Section **02. scripts** contains scripts to create (and drop) the tables and
 views. Tables listed follow the specifications of the production setup at
  Utrecht University, so tweak them to accommodate for your situation.

## Populating tables and views

Section **02. scripts** also contains a script for populating the database
 tables with actual data, csv files in our case. Table designs, obviously
 , dictate record layouts. I prefer BULK INSERT operations over flat file
  imports. BULK INSERTs are fast, they can be combined in a query and require
   a minimum of user interaction. Furthermore, table designs, data types in
    particular are well observed whereas flat file import applies its own
     logic resulting in manual corrections during or after import.

With our data I was able to BULK INSERT all tables but one
: PERSON_PROFILE_INFORMATION. Somehow, the content of the
 TEXT column (of one or more records) resulted in errors I could not easily
  fix in the source file. Since the table has only three columns, I opted for
   flat file import instead.

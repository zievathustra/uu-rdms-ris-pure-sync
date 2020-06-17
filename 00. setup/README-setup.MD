# **Pure synchronisations: Setup**

Obviously, when figuring out how to get from tables and views to importable
 xml, one needs a setup to code and test. Accommodating my own preferences, I
  chose to set up machines for both Windows and Linux. While *en route* this
   choice proved to be a useful one as, sometimes, tool behaviour varied with
    the underlying operating system.

## Machines

### HP EliteBook 840 G3 running Linux

- Ubuntu 20.04 LTS
- Microsoft SQL Server 19 CU3 (via Docker image runnin on Ubuntu 18.04)
- Microsoft Azure Data Studio 1.18.0

### Lenovo Y50-70 running Windows

- Windows 10 Home
- Microsoft SQL Server 19
- Microsoft SQL Server Management Studio 18.4

Please find version details at [99. tools/tools.setup.sql2xml.txt](https://github.com/zievathustra/uu-rdms-ris-pure-sync/blob/master/00.%20setup/99.%20tools/tools.setup.sql2xml.txt).

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

Section **02. scripts** contains scripts to create and populate (and drop) the tables and
 views. Tables listed follow the specifications of the production setup at
  Utrecht University, so tweak them to accommodate for your situation.

## Populating tables and views

The script that populates the tables uses xml files as import source. I found this to be better in terms of management and readability when setting up and testing the population routines. SSMS does not seem to offer an export to xml function out-of-the-box, so I opted for MADS as the preferred tool to extract table data from our production system.

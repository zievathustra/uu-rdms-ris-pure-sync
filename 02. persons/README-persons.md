# **Pure synchronisations: Persons**

## Tables

The *persons* synchronisation uses four tables:

- Photo information (PHOTO_INFORMATION)
- Profie information (PROFILE_INFORMATION)
- SAP person details (SAPDATA)
- Affiliations (STAFF_ORGANISATION_RELATION)

Please refer to [02. persons/02. scripts/01. tables](02. scripts/01. tables) for individual table creation scripts.

### Table update: PERSON_PROFILE_INFORMATION

Tests revealed that **the UU dataset** of person profiles, while packed with HTML tags that were handled correctly, also contained reserved characters that made the query break. I found out the issue affected just one character for one row in the table, so instead of running a replace routine on all rows via a separate VIEW, I opted for a table UPDATE.

Please refer to [02. persons/02. scripts/03. update](02. scripts/03. update) for individual table update scripts.

## Views

In order to filter only persons with affiliations and correctly process
 (multi value) elements according to Pure classification schemes, the *persons* synchronisation also uses five **views**:

- SAP person details including # of affiliations (DATA)
- Name variants (NAMES)
- Photo details (PHOTOS)
- Profile details (PROFILES)
- Affiliation specific address information (STAFF_PERSON_COMMS)

Please refer to [02. persons/02. scripts/02. views](02. scripts/02. views) for individual view creation scripts. Scripts marked 'X_' at the beginning of the file name are alternate versions. The how and why is documented in the script itself.

## Transform to xml

The basic syntax of a transformation query looks like this:

```tsql
USE [DATABASE]
GO

WITH xmlnamespaces (ns1, ns2)
SELECT
    'false' as "@boolean"
    'someValue' as "ns1:column1/ns2:text/@attribute"
    ,[DATABASE].column1 as "ns1:column1"
    ,[DATABASE].column2 as "ns1:column2"
FROM [DATABASE]
FOR XML PATH('ns1:path'), ROOT('ns1:root')
GO
```

The query will result in xml lines formatted as follows
```xml
<ns1:root>
    <ns1:path boolean="false">
        <ns1:column1>
            <ns2:text attribute="someValue">...</ns2:text>
        </ns1:column1>
        <ns1:column2>...</ns1:column2>
    </ns1:path>
</ns1:root>
```

### Namespaces

The Pure import relies on namespaces for proper xml validation. For
 *organisations* these namespaces are used:

 ```tsql
WITH xmlnamespaces(
      'v1.unified-person-sync.pure.atira.dk' as v1
      ,'v3.commons.pure.atira.dk' as v3)
```
### Element attributes

Element attributes are marked with a @-sign. If not assigned to a specific element within SELECT, the attribute is assigned to the containing PATH element as demonstrated in the basic example above.

### NULL columns

The Pure import easily breaks on NULL values. Since this issue covers table columns that *allow* NULL values by design, simply skipping the column using a CASE statement is the best way out.

Example:

```tsql
CASE
    WHEN isnull(tblData.END_DATE,'') <> '' THEN tblData.END_DATE
END as "v1:endDate"
```  

### Multi value elements

The *organisations* import xml combines data from several tables. For one-to-one relationships between tables one of the JOIN statements may do as illustrated by combining DATA and HIERARCHY. DATA and NAME_VARIANTS, however, is a one-to-many relationship. This may be solved by nesting an extra SELECT as illustrated below:

 ```tsql
SELECT
    ...
    ,(SELECT
        vwProfiles.PERSON_ID + '_' + vwProfiles.PROFILE_TYPE as "v1:personCustomField/@id"
        ,vwProfiles.PROFILE_TYPE as "v1:personCustomField/v1:typeClassification"
        ,vwProfiles.PROFILE_TEXT as "v1:personCustomField/v1:value/v3:text"
    FROM dbo.PERSON_PROFILES as vwProfiles
    WHERE vwProfiles.PERSON_ID = vwPersons.PERSON_ID
    FOR XML PATH(''), ROOT('v1:profileInformation'), TYPE)
    ...
FROM dbo.PERSON_DATA as vwPersons
...
...
FOR XML PATH('v1:person'), ROOT('v1:persons')

```

Please observe the **TYPE directive** in the nested FOR XML, ensuring name variants are returned as *xml* data type instead of text.

### Specials

For UU, tables and their data are a given since they originate from SAP. Occasionally, consistency issues need to be addressed as is the case with persons and affiliations. Furthermore, some table columns need some TLC in order to end up properly in xml. These *specials* are listed below.

#### WHERE clause in main SELECT

Given the UU dataset, the PERSON_SAPDATA table contains a number of rows that have zero rows in STAFF_ORGANISATION_RELATION. In other words, these persons have not affiliation. I opted for exclusion of those records as they break the Pure import during validation. Person candidates for xml are therefore selected as follows.

```tsql
WHERE vwPersons.NUMBEROFAFFILIATIONS>0
```

#### Address information on affiliations

Some address details in the UU dataset needed some extra work to get the right xml data. I opted for a solution in the code, not for an extra view. No special reason, it just evolved this way when coding and testing.

##### City

City is not listed as a column in the table, but it is available in another column in concatenation with ZIP code, which in turn is available in a separate column.The data show a specific mask, ZIP  + '  ' + City, so I simply did a replace like this

```tsql
REPLACE(tblAffiliations.WORK_ADDRESS_THREE, WORK_POSTAL_CODE + '  ','') as "v1:addresses/v3:classifiedAddress/v3:city"
```
##### Country

The WORK_COUNTRY column in the UU dataset allows for NULL values. These would translate to empty, '' in xml. Pure, however, does not accept empty values as the corresponding field is bound to the ISO-3166-1 country code classification. Therefore, consider skipping the column when empty like

```tsql
CASE
    WHEN tblAffiliations.WORK_COUNTRY <> '' THEN tblAffiliations.WORK_COUNTRY
END as "v1:addresses/v3:classifiedAddress/v3:country"
```   
##### Displayformat

Displayformat is the nicely formatted (postal, visiting) address in Pure. It's not available in a table column, so it's concatenated in the script as follows.

```tsql
tblAffiliations.WORK_ADDRESS_ONE + CHAR(10) + tblAffiliations.WORK_ADDRESS_TWO + CHAR(10) + tblAffiliations.WORK_ADDRESS_THREE as "v1:addresses/v3:classifiedAddress/v3:displayFormat"
```

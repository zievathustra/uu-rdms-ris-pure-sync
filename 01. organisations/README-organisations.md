# **Pure synchronisations: Organisations**

## Tables

The *organisations* synchronisation usse three tables:

- organisation attributes (_DATA)
- organisation hierarchy (_HIERARCHY)
- alternative names (short, web; _NAME_VARIANTS)

Please refer to [01. organisations/02. scripts/01. tables](../01.%20organisations/02.%20scripts/01.%20tables) for
 individual table creation scripts.
 
## Bulk inserts

Bulk insert scripts for attributes, hierarchy and name variants may be found
 in [01. organisations/02. scripts/04. bulkInsert](../01.%20organisations/02.%20scripts/04.%20bulkInsert).
  
Change the source file locations to meet your own setup. Please observe that
 scripts marked *X_* at the beginning of the file name are alternate versions
  of the same code referring to a different, 'manipulated' file. The how and
   why is documented in the script itself.
     
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
      'v1.organisation-sync.pure.atira.dk' as v1
      ,'v3.commons.pure.atira.dk' as v3)
```
### Element attributes

Element attributes are marked with a @-sign. If not assigned to a specific
 element within SELECT, the attribute is assigned to the containing PATH
  element as demonstrated in the basic example above.
 
### NULL columns

The Pure import easily breaks on NULL values. Since this issue covers table
 columns that *allow* NULL values by design, simply skipping the column using
  a CASE statement is the best way out. Example:
  
```tsql
CASE
    WHEN isnull(tblData.END_DATE,'') <> '' THEN tblData.END_DATE
END as "v1:endDate"
```  

### Multi value elements

The *organisations* import xml combines data from several tables. For one-to
-one relationships between tables one of the JOIN statements may do as
 illustrated by combining _DATA and _HIERARCHY. _DATA and _NAME_VARIANTS
 , however, is a one-to-many relationship. This may be solved by nesting an
  extra SELECT as illustrated below: 
  
 ```tsql
SELECT
      ...
      ,(
      SELECT 
            tblNameVars.type as "v1:nameVariant/v1:type"
            ,'en' as "v1:nameVariant/v1:name/v3:text/@lang"
            ,'NL' as "v1:nameVariant/v1:name/v3:text/@country"
            ,tblNameVars.name_variant as "v1:nameVariant/v1:name/v3:text"
      FROM [dbo].ORGANISATION_NAME_VARIANTS as tblNameVars
      WHERE tblNameVars.organisation_id = tblData.organisation_id
      FOR XML PATH(''),ROOT('v1:nameVariants'), TYPE
      )
FROM [dbo].[ORGANISATION_DATA] as tblData
...
...
FOR XML PATH('v1:organisation'),ROOT('v1:organisations')
```

Please observe the **TYPE directive** in the nested FOR XML, ensuring name
 variants are returned as *xml* data type instead of text.
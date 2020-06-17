# **Pure synchronisations: Projects**

## Tables

The *projects* synchronisation uses six tables:

- Project participants (INTERNAL_PARTICIPANTS)
- Project organisations (INTERNAL_PROJECT_ORGANISATIONS)
- Project details (PROJECT_DATA)
- Project keywords (PROJECT_KEYWORDS)
- Project hierarchy (PROJECT_PROJECT_RELATION)
- Project types (PROJECT_UPMPROJECTTYPES)

### Table update: INTERNAL_PROJECT_ORGANISATIONS

Tests revealed that **the UU dataset** of project organisations contained reserved characters (CR/LF) that made the query break. I found out the issue affected a limited number of rows, so instead of running a replace routine on all rows via a separate VIEW, I opted for a table UPDATE.

### Table update: PROJECT_PROJECT_RELATION
Tests revealed that **the UU dataset** of the project hierarchy contained reserved characters (CR/LF) that made the query break. I found out the issue affected a limited number of rows, so instead of running a replace routine on all rows via a separate VIEW, I opted for a table UPDATE.

Please refer to [03. projects/02. scripts/03. update]() for individual table update scripts.

## Views

In order to provide all mandatory data upon import, the standard PROJECT_DATA table needed to be extended with project type information. I created an extra table, PROJECT_UPMPROJECTTYPES, to store the project types configured in Pure and I created the view **PROJECT_DATA_PLUS** to include the appropriate columns.


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
 *projects* these namespaces are used:

 ```tsql
 WITH xmlnamespaces(
     'v1.upmproject.pure.atira.dk' as v1,
     'v3.commons.pure.atira.dk' as v3
 )
```
### Element attributes

Element attributes are marked with a @-sign. If not assigned to a specific element within SELECT, the attribute is assigned to the containing PATH element as demonstrated in the basic example above.

### NULL columns

The Pure import easily breaks on NULL values. Since this issue covers table columns that *allow* NULL values by design, simply skipping the column using a CASE statement is the best way out. Example:

```tsql
CASE
    WHEN isnull(tblData.END_DATE,'') <> '' THEN tblData.END_DATE
END as "v1:endDate"
```  

### Multi value elements

The *projects* export xml combines data from several tables. For one-to-one relationships between tables a JOIN statement will do. One-to-many relationships, however, need to be handled differently, i.e. by nesting extra SELECT statements as illustrated below:

 ```tsql
SELECT
    ...
    ,(SELECT
        'my_structured_keywords' as "@logicalName"
        ,(SELECT
                tblKeywords.LOGICAL_NAME + '/' + tblKeywords.TYPE as "v3:structuredKeyword/@classification"
        FROM dbo.PROJECT_KEYWORDS as tblKeywords
        WHERE tblKeywords.PROJECT_ID = tblProjects.PROJECT_ID
        FOR XML PATH(''), ROOT('v3:structuredKeywords'), TYPE)
      FOR XML PATH('v3:logicalGroup'), ROOT('v1:keywords'), TYPE)
    ...
FROM dbo.PRJECT_DATA_PLUS as vwProjects
...
...
FOR XML PATH('v1:upmproject'), ROOT('v1:upmprojects')

```

Please observe the **TYPE directive** in the nested FOR XML, ensuring keywords are returned as *xml* data type instead of text.

# **Pure synchronisations: Users**

By all means, the *users* synchronisation is simple. No nested queries, no special data, just a limited set of columns from the Persons table.

## Tables

The *users* synchronisation uses one table:

- SAP person details **view** (PERSON_DATA)

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

The Pure import relies on namespaces for proper xml validation. For  *users* these namespaces are used:

 ```tsql
WITH xmlnamespaces(
      'v1.user-sync.pure.atira.dk' as v1
      ,'v3.commons.pure.atira.dk' as v3)
```
### Element attributes

Element attributes are marked with a @-sign. If not assigned to a specific element within SELECT, the attribute is assigned to the containing PATH element as demonstrated in the basic example above.

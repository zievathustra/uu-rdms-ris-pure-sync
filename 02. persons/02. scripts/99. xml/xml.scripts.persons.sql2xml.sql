/*
[DATE]		2020-03-26
[ORGANISATION]	Utrecht University
[EMPLOYEE]	Arjan Sieverink
[CONTACT1]	https://www.uu.nl/staff/JASieverink
[CONTACT2]	https://www.linkedin.com/in/arjansieverink
*/

use PUREP_Staging
go

with xmlnamespaces(
    'v1.unified-person-sync.pure.atira.dk' as "v1",
    'v3.commons.pure.atira.dk' as "v3"
)
select
--select top 100
    tblPersons.PERSON_ID as "@id"
    ,'false' as "@managedInPure"
    ,tblPersons.FIRST_NAME as "v1:name/v3:firstname"
    ,tblPersons.LAST_NAME as "v1:name/v3:lastname"
   ,(select
        vwNames.ID as "v1:classifiedName/@id"
        ,vwNames.FIRST_NAME as "v1:classifiedName/v1:name/v3:firstname"
        ,vwNames.LAST_NAME as "v1:classifiedName/v1:name/v3:lastname"
        ,vwNames.[TYPE] as "v1:classifiedName/v1:typeClassification"
    from dbo.PERSON_NAMES as vwNames
    where vwNames.PERSON_ID = tblPersons.PERSON_ID
    for xml path(''), root('v1:names'), type)
   ,(select 
        vwTitles.ID as "v1:title/@id"
        ,vwTitles.TYPE as "v1:title/v1:typeClassification"
        ,'en' as "v1:title/v1:value/v3:text/@lang"
        ,'GB' as "v1:title/v1:value/v3:text/@country"
        ,vwTitles.VALUE as "v1:title/v1:value/v3:text"
    from dbo.PERSON_TITLES as vwTitles
    where vwTitles.PERSON_ID = tblPersons.PERSON_ID
    for xml path(''), root('v1:titles'), type)
    ,'Unknown' as "v1:gender"
-- minOccurs=0 according to xsd    ,'' as "v1:dateOfBirth"
-- minOccurs=0 according to xsd    ,'' as "v1:nationality"
-- minOccurs=0 according to xsd    ,'' as "v1:retiralDate"
    ,(select 
        vwPhotos.ID as "v1:personPhoto/@id"
        ,vwPhotos.TYPE as "v1:personPhoto/v1:classification"
        ,vwPhotos.VALUE as "v1:personPhoto/v1:data/v1:http/v1:url"
    from dbo.PERSON_PHOTOS as vwPhotos
    where vwPhotos.PERSON_ID = tblPersons.PERSON_ID
    for xml path(''), root('v1:photos'), type)
    ,(select
        tblAffiliations.STAFF_ORGANISATION_RELATION_ID as "@id"
        ,'false' as "@managedInPure"
        ,tblAffiliations.ORGANISATION_ID as "v1:affiliationId"
        ,tblAffiliations.STAFF_ORGANISATION_RELATION_ID as "v1:addresses/v3:classifiedAddress/@id"
		,'postal' as "v1:addresses/v3:classifiedAddress/v3:addressType"
		,REPLACE(tblAffiliations.WORK_ADDRESS_THREE, WORK_POSTAL_CODE + '  ','') as "v1:addresses/v3:classifiedAddress/v3:city"
		,tblAffiliations.WORK_POSTAL_CODE as "v1:addresses/v3:classifiedAddress/v3:postalCode"
		,tblAffiliations.WORK_ADDRESS_TWO as "v1:addresses/v3:classifiedAddress/v3:street"
		,case
		      when tblAffiliations.WORK_COUNTRY <> '' then tblAffiliations.WORK_COUNTRY
		end as "v1:addresses/v3:classifiedAddress/v3:country"
		,tblAffiliations.WORK_ADDRESS_ONE as "v1:addresses/v3:classifiedAddress/v3:building"
		,tblAffiliations.WORK_ADDRESS_ONE + CHAR(10) + tblAffiliations.WORK_ADDRESS_TWO + CHAR(10) + tblAffiliations.WORK_ADDRESS_THREE as "v1:addresses/v3:classifiedAddress/v3:displayFormat"
        ,(select
		    vwComms.STAFF_ORGANISATION_RELATION_ID as "@id"
			,vwComms.TYPE as "v3:classification"
			,vwComms.VALUE as "v3:value"
		from dbo.STAFF_PERSON_COMMS as vwComms
		where vwComms.STAFF_ORGANISATION_RELATION_ID = tblAffiliations.STAFF_ORGANISATION_RELATION_ID
		for xml path('v3:classifiedPhoneNumber'), root('v1:phoneNumbers'), type)
		,tblAffiliations.STAFF_ORGANISATION_RELATION_ID as "v1:emails/v3:classifiedEmail/@id"
		,'email' as "v1:emails/v3:classifiedEmail/v3:classification"
		,tblAffiliations.EMAIL as "v1:emails/v3:classifiedEmail/v3:value"
		,tblAffiliations.EMPLOYED_AS as "v1:employmentType"
        ,'false' as "v1:primaryAssociation"
        ,tblAffiliations.ORGANISATION_ID as "v1:organisation/v3:source_id"
        ,tblAffiliations.START_DATE as "v1:period/v3:startDate"
--END_DATE is of type NVARCHAR		
        ,case
		     when isdate(tblAffiliations.END_DATE)=1 then tblAffiliations.END_DATE
	    end as "v1:period/v3:endDate"
--END_DATE is of type DATE		
--		,case
--		     when isnull(tblAffiliations.END_DATE,'') <> '' then tblAffiliations.END_DATE
--	    end as "v1:period/v3:endDate"
		,case
		    when tblAffiliations.EXOFFICIO_DEPARTMENTAL_ROLE <> ' ' then 'exofficio'
		end as "v1:keywords/v3:logicalGroup/@logicalName"
		,case
		    when tblAffiliations.EXOFFICIO_DEPARTMENTAL_ROLE <> ' ' then tblAffiliations.EXOFFICIO_DEPARTMENTAL_ROLE
		end as "v1:keywords/v3:logicalGroup/v3:structuredKeywords/v3:structuredKeyword/@classification"
        ,'academic' as "v1:staffType"
        ,tblAffiliations.JOB_TITLE as "v1:jobTitle"
    from dbo.STAFF_ORGANISATION_RELATION as tblAffiliations
    where tblAffiliations.PERSON_ID = tblPersons.PERSON_ID
    for xml path('v1:staffOrganisationAssociation'), root('v1:organisationAssociations'), type)
	,(select
    vwProfiles.PERSON_ID + '_' + vwProfiles.PROFILE_TYPE as "v1:personCustomField/@id"
        ,vwProfiles.PROFILE_TYPE as "v1:personCustomField/v1:typeClassification"
		,vwProfiles.PROFILE_TEXT as "v1:personCustomField/v1:value/v3:text"
	from dbo.PERSON_PROFILES as vwProfiles
	where vwProfiles.PERSON_ID = tblPersons.PERSON_ID
	for xml path(''), root('v1:profileInformation'), type)
	,tblPersons.PERSON_ID as "v1:user/@id"
	,'employee' as "v1:personIds/v3:id/@type"
	,tblPersons.PERSON_ID as "v1:personIds/v3:id/@id"
	,tblPersons.PERSON_ID as "v1:personIds/v3:id"
from dbo.PERSON_DATA as tblPersons
where tblPersons.NUMBEROFAFFILIATIONS>0
order by tblPersons.PERSON_ID
for xml path('v1:person'), root('v1:persons')

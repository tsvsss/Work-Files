		--SELECT UPDATEXML(v_soap_xml,'//*:FullName/text()','Usama bin Muhammad bin Awadnull')  INTO v_soap_xml from dual;
		--SELECT UPDATEXML(v_soap_xml,'//*:GivenNames/text()','BIN LADIN')  INTO v_soap_xml from dual;
		--SELECT UPDATEXML(v_soap_xml,'//*:EntityName/text()','Central Bank of Cuba')  INTO v_soap_xml from dual;

select *
from  WC_SCREENING_REQUEST
where entity_type = 'INDIVIDUAL'
order by wc_screening_request_id desc
;

select *
from  WC_SCREENING_REQUEST
where entity_type = 'ORGANISATION'
order by wc_screening_request_id desc
;

SELECT *
FROM all_scheduler_jobs
order by start_date desc
;

SELECT count(*)
FROM all_scheduler_jobs
order by start_date desc
;

begin
dbms_scheduler.drop_job(job_name => 'OWS_I_2019030314_1_JOB');
end;
/

begin
dbms_scheduler.drop_job(job_name => 'OWS_ENTITY_SCREENING_JOB1');
end;
/

begin
dbms_scheduler.enable (name =>  'OWS_INDIVIDUAL_SCREENING_JOB9');
end;
/

begin
dbms_scheduler.enable (name =>  'OWS_ENTITY_SCREENING_JOB4');
end;
/

select length('DataConfidenceComment') from dual;
      
      select t.value_xml.getClobVal()
      from xwrl_parameters t
      WHERE
         t.id = 'XML'
         AND t.key = 'REQUEST_INDIVIDUAL'      
         ;

      select t.value_xml.extract('/')
      from xwrl_parameters t
      WHERE
         t.id = 'XML'
         AND t.key = 'REQUEST_INDIVIDUAL'      
         ;      

SELECT XMLSERIALIZE(Document XMLTYPE(t.value_xml.getClobVal()) AS CLOB INDENT SIZE = 2)          
      from xwrl_parameters t
      WHERE
         t.id = 'XML'
         AND t.key = 'REQUEST_INDIVIDUAL'      
         ;   

SELECT x.key, x.value
      FROM
         xwrl_parameters t,
         XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS key varchar2(2700) PATH 'name()'
         , value varchar2(2700) PATH 'text()'
       ) x
      WHERE
         t.id = 'XML'
         AND t.key = 'REQUEST_INDIVIDUAL'
         ; 

select t.value_xml
from xwrl_parameters t
where          t.id = 'XML'
         AND t.key = 'REQUEST_INDIVIDUAL'
;

/*
declare function local:strip-namespace($inputRequest as element()) as element()
         {
            element {fn:name($inputRequest)}
            {
              for $child in $inputRequest /(@*,node())
                return
                  if ($child instance of element())
                  then local:strip-namespace($child)
                  else $child
            }
*/

SELECT xmlquery('declare namespace soap="http://schemas.xmlsoap.org/soap/envelope"; 
declare namespace ws="http://www.datanomic.com/ws"; 
         //ws:request/ws:ListSubKey'
                 PASSING   t.value_xml
                 RETURNING content) xml
from xwrl_parameters t
where          t.id = 'XML'
         AND t.key = 'REQUEST_INDIVIDUAL';

SELECT t.value_xml
from xwrl_parameters t
where          t.id = 'XML'
         AND t.key = 'REQUEST_INDIVIDUAL';

WITH testdata(xmlfile) AS (  
SELECT t.value_xml
from xwrl_parameters t
where          t.id = 'XML'
         AND t.key = 'REQUEST_INDIVIDUAL')  
SELECT XMLQUERY(  
    'declare namespace ws="http://www.datanomic.com/ws";
copy $tmp := .  
     modify replace value of node $tmp//*/ws:request/ws:ListSubKey with "test"  
     return $tmp 
 '  PASSING xmlfile RETURNING CONTENT)  xml
FROM testdata  
;

SELECT XMLQUERY(  
    'declare namespace ws="http://www.datanomic.com/ws"; copy $tmp := .  modify (replace value of node $tmp//*/ws:request/ws:FullName with "Usama bin Laden" ,replace value of node $tmp//*/ws:request/ws:GivenNames with "BIN LADIN") return $tmp  ' 
    PASSING t.value_xml RETURNING CONTENT)  xml
from xwrl_parameters t
where          t.id = 'XML'
AND t.key = 'REQUEST_INDIVIDUAL'
;

WITH testdata(xmlfile) AS (  
SELECT xmltype(  
'<pubDat>  
      <bNumber>string</bNumber>  
      <fld>string</fld>  
      <dbInstance>string</dbInstance>  
</pubDat>')   
FROM dual)  
SELECT XMLQUERY(  
    'copy $tmp := .  
     modify replace value of node $tmp/pubDat/bNumber with "test"  
     return $tmp  
    '  
PASSING xmlfile RETURNING CONTENT)  
FROM testdata  
;

-- EDQ limits field size to 2700 chars in general when it comes to snapshotting data and truncates otherwise

SELECT 'if p_'||x.value||' is not null then pList('||rownum||').key := '||''''||x.value||''''||'; '||'pList('||rownum||').value := p_'||x.value||'; end if;'
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS value varchar2(2700) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'REQUEST_ENTITY' 
and x.value <> 'request';	


--------------------------------

--select ',replace(x.'||x.value||','||''''||'?'||''''||',null) '||x.value
--SELECT x.value||' varchar2(2700), '
--SELECT x.value||' varchar2(2700) path '||''''||'ws:'||x.value||''''||','
select 'v_rec.'||x.value||' := c1rec.'||x.value||';'
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS value varchar2(2700) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'REQUEST_INDIVIDUAL' 
and x.value <> 'request';	

--select ',replace(x.'||x.value||','||''''||'?'||''''||',null) '||x.value
--SELECT x.value||' varchar2(2700), '
--SELECT x.value||' varchar2(2700) path '||''''||'ws:'||x.value||''''||','
--select 'v_rec.'||x.value||' := c1rec.'||x.value||';'

SELECT 'dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name,  argument_position => '||to_char(x.rec+3)||', argument_type => '||''''||'VARCHAR2'||''''||',default_value => '||''''||''''||');'
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS rec for ordinality,value varchar2(2700) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'REQUEST_INDIVIDUAL' 
and x.value <> 'request'
order by x.rec;

SELECT 'dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => '||''''||x.value||''''||', argument_position => '||to_char(x.rec+3)||', argument_type => '||''''||'VARCHAR2'||''''||',default_value => '||''''||''''||');'
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS rec for ordinality,value varchar2(2700) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'REQUEST_ENTITY' 
and x.value <> 'request'
order by x.rec;


SELECT 'dbms_scheduler.SET_JOB_ARGUMENT_VALUE(job_name => '||''''||'OWS_ENTITY_SCREENING_JOB'||''''||',  argument_name => '||''''||x.value||''''||', argument_value => '||''''||''''||'); -- '||x.value
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS rec for ordinality,value varchar2(2700) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'REQUEST_ENTITY' 
and x.value <> 'request'
order by x.rec;

SELECT 'dbms_scheduler.SET_JOB_ARGUMENT_VALUE(job_name => v_job_name, argument_position  => '||to_char(x.rec+3)||', argument_value => '||'NULL'||'); -- '||x.value
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS rec for ordinality,value varchar2(2700) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'REQUEST_INDIVIDUAL' 
and x.value <> 'request'
order by x.rec;

SELECT 'dbms_scheduler.SET_JOB_ARGUMENT_VALUE(job_name => v_job_name, argument_position => '||to_char(x.rec+3)||', argument_value => '||'NULL'||'); -- '||x.value
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS rec for ordinality,value varchar2(2700) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'REQUEST_ENTITY' 
and x.value <> 'request'
order by x.rec;

-----------

--SELECT x.value||' varchar2(2700), '
-- SELECT x.value||' varchar2(2700) path '||''''||'dn:'||x.value||''''||',' 
--select 'x.'||x.value||','
select 'v_rec.'||x.value||' := c1rec.'||x.value||';'
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS value varchar2(2700) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'RESPONSE_INDIVIDUAL' 
and x.value NOT IN ('response','record')
;

--SELECT x.value||' varchar2(2700), '
--SELECT x.value||' varchar2(2700) path '||''''||'dn:'||x.value||''''||','
--select 'x.'||x.value||','
select 'v_rec.'||x.value||' := c1rec.'||x.value||';'
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS value varchar2(2700) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'RESPONSE_ENTITY' 
and x.value NOT IN ('response','record')
;


select *
from xwrl_requests
order by id desc;

SELECT t.request
from xwrl_requests t
 where t.id = :Individual
;

SELECT t.response
from xwrl_requests t
 where t.id = :Individual
;


   /***  REQUESTS ***/

/* List XML as Columns for Individuals*/

SELECT t.id
,replace(x.ListSubKey,'?',null) ListSubKey
,replace(x.ListRecordType,'?',null) ListRecordType
,replace(x.ListRecordOrigin,'?',null) ListRecordOrigin
,replace(x.CustId,'?',null) CustId
,replace(x.CustSubId,'?',null) CustSubId
,replace(x.PassportNumber,'?',null) PassportNumber
,replace(x.NationalId,'?',null) NationalId
,replace(x.Title,'?',null) Title
,replace(x.FullName,'?',null) FullName
,replace(x.GivenNames,'?',null) GivenNames
,replace(x.FamilyName,'?',null) FamilyName
,replace(x.NameType,'?',null) NameType
,replace(x.NameQuality,'?',null) NameQuality
,replace(x.PrimaryName,'?',null) PrimaryName
,replace(x.OriginalScriptName,'?',null) OriginalScriptName
,replace(x.Gender,'?',null) Gender
,replace(x.DateOfBirth,'?',null) DateOfBirth
,replace(x.YearOfBirth,'?',null) YearOfBirth
,replace(x.Occupation,'?',null) Occupation
,replace(x.Address1,'?',null) Address1
,replace(x.Address2,'?',null) Address2
,replace(x.Address3,'?',null) Address3
,replace(x.Address4,'?',null) Address4
,replace(x.City,'?',null) City
,replace(x.State,'?',null) State
,replace(x.PostalCode,'?',null) PostalCode
,replace(x.AddressCountryCode,'?',null) AddressCountryCode
,replace(x.ResidencyCountryCode,'?',null) ResidencyCountryCode
,replace(x.CountryOfBirthCode,'?',null) CountryOfBirthCode
,replace(x.NationalityCountryCodes,'?',null) NationalityCountryCodes
,replace(x.ProfileHyperlink,'?',null) ProfileHyperlink
,replace(x.RiskScore,'?',null) RiskScore
,replace(x.DataConfidenceScore,'?',null) DataConfidenceScore
,replace(x.DataConfidenceComment,'?',null) DataConfidenceComment
,replace(x.CustomString1,'?',null) CustomString1
,replace(x.CustomString2,'?',null) CustomString2
,replace(x.CustomString3,'?',null) CustomString3
,replace(x.CustomString4,'?',null) CustomString4
,replace(x.CustomString5,'?',null) CustomString5
,replace(x.CustomString6,'?',null) CustomString6
,replace(x.CustomString7,'?',null) CustomString7
,replace(x.CustomString8,'?',null) CustomString8
,replace(x.CustomString9,'?',null) CustomString9
,replace(x.CustomString10,'?',null) CustomString10
,replace(x.CustomString11,'?',null) CustomString11
,replace(x.CustomString12,'?',null) CustomString12
,replace(x.CustomString13,'?',null) CustomString13
,replace(x.CustomString14,'?',null) CustomString14
,replace(x.CustomString15,'?',null) CustomString15
,replace(x.CustomString16,'?',null) CustomString16
,replace(x.CustomString17,'?',null) CustomString17
,replace(x.CustomString18,'?',null) CustomString18
,replace(x.CustomString19,'?',null) CustomString19
,replace(x.CustomString20,'?',null) CustomString20
,replace(x.CustomString21,'?',null) CustomString21
,replace(x.CustomString22,'?',null) CustomString22
,replace(x.CustomString23,'?',null) CustomString23
,replace(x.CustomString24,'?',null) CustomString24
,replace(x.CustomString25,'?',null) CustomString25
,replace(x.CustomString26,'?',null) CustomString26
,replace(x.CustomString27,'?',null) CustomString27
,replace(x.CustomString28,'?',null) CustomString28
,replace(x.CustomString29,'?',null) CustomString29
,replace(x.CustomString30,'?',null) CustomString30
,replace(x.CustomString31,'?',null) CustomString31
,replace(x.CustomString32,'?',null) CustomString32
,replace(x.CustomString33,'?',null) CustomString33
,replace(x.CustomString34,'?',null) CustomString34
,replace(x.CustomString35,'?',null) CustomString35
,replace(x.CustomString36,'?',null) CustomString36
,replace(x.CustomString37,'?',null) CustomString37
,replace(x.CustomString38,'?',null) CustomString38
,replace(x.CustomString39,'?',null) CustomString39
,replace(x.CustomString40,'?',null) CustomString40
,replace(x.CustomDate1,'?',null) CustomDate1
,replace(x.CustomDate2,'?',null) CustomDate2
,replace(x.CustomDate3,'?',null) CustomDate3
,replace(x.CustomDate4,'?',null) CustomDate4
,replace(x.CustomDate5,'?',null) CustomDate5
,replace(x.CustomNumber1,'?',null) CustomNumber1
,replace(x.CustomNumber2,'?',null) CustomNumber2
,replace(x.CustomNumber3,'?',null) CustomNumber3
,replace(x.CustomNumber4,'?',null) CustomNumber4
,replace(x.CustomNumber5,'?',null) CustomNumber5
from xwrl_requests t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "env", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:request'
         PASSING t.request
         columns          
         rec for ordinality,
         ListSubKey varchar2(2700) path 'ws:ListSubKey',
ListRecordType varchar2(2700) path 'ws:ListRecordType',
ListRecordOrigin varchar2(2700) path 'ws:ListRecordOrigin',
CustId varchar2(2700) path 'ws:CustId',
CustSubId varchar2(2700) path 'ws:CustSubId',
PassportNumber varchar2(2700) path 'ws:PassportNumber',
NationalId varchar2(2700) path 'ws:NationalId',
Title varchar2(2700) path 'ws:Title',
FullName varchar2(2700) path 'ws:FullName',
GivenNames varchar2(2700) path 'ws:GivenNames',
FamilyName varchar2(2700) path 'ws:FamilyName',
NameType varchar2(2700) path 'ws:NameType',
NameQuality varchar2(2700) path 'ws:NameQuality',
PrimaryName varchar2(2700) path 'ws:PrimaryName',
OriginalScriptName varchar2(2700) path 'ws:OriginalScriptName',
Gender varchar2(2700) path 'ws:Gender',
DateOfBirth varchar2(2700) path 'ws:DateOfBirth',
YearOfBirth varchar2(2700) path 'ws:YearOfBirth',
Occupation varchar2(2700) path 'ws:Occupation',
Address1 varchar2(2700) path 'ws:Address1',
Address2 varchar2(2700) path 'ws:Address2',
Address3 varchar2(2700) path 'ws:Address3',
Address4 varchar2(2700) path 'ws:Address4',
City varchar2(2700) path 'ws:City',
State varchar2(2700) path 'ws:State',
PostalCode varchar2(2700) path 'ws:PostalCode',
AddressCountryCode varchar2(2700) path 'ws:AddressCountryCode',
ResidencyCountryCode varchar2(2700) path 'ws:ResidencyCountryCode',
CountryOfBirthCode varchar2(2700) path 'ws:CountryOfBirthCode',
NationalityCountryCodes varchar2(2700) path 'ws:NationalityCountryCodes',
ProfileHyperlink varchar2(2700) path 'ws:ProfileHyperlink',
RiskScore varchar2(2700) path 'ws:RiskScore',
DataConfidenceScore varchar2(2700) path 'ws:DataConfidenceScore',
DataConfidenceComment varchar2(2700) path 'ws:DataConfidenceComment',
CustomString1 varchar2(2700) path 'ws:CustomString1',
CustomString2 varchar2(2700) path 'ws:CustomString2',
CustomString3 varchar2(2700) path 'ws:CustomString3',
CustomString4 varchar2(2700) path 'ws:CustomString4',
CustomString5 varchar2(2700) path 'ws:CustomString5',
CustomString6 varchar2(2700) path 'ws:CustomString6',
CustomString7 varchar2(2700) path 'ws:CustomString7',
CustomString8 varchar2(2700) path 'ws:CustomString8',
CustomString9 varchar2(2700) path 'ws:CustomString9',
CustomString10 varchar2(2700) path 'ws:CustomString10',
CustomString11 varchar2(2700) path 'ws:CustomString11',
CustomString12 varchar2(2700) path 'ws:CustomString12',
CustomString13 varchar2(2700) path 'ws:CustomString13',
CustomString14 varchar2(2700) path 'ws:CustomString14',
CustomString15 varchar2(2700) path 'ws:CustomString15',
CustomString16 varchar2(2700) path 'ws:CustomString16',
CustomString17 varchar2(2700) path 'ws:CustomString17',
CustomString18 varchar2(2700) path 'ws:CustomString18',
CustomString19 varchar2(2700) path 'ws:CustomString19',
CustomString20 varchar2(2700) path 'ws:CustomString20',
CustomString21 varchar2(2700) path 'ws:CustomString21',
CustomString22 varchar2(2700) path 'ws:CustomString22',
CustomString23 varchar2(2700) path 'ws:CustomString23',
CustomString24 varchar2(2700) path 'ws:CustomString24',
CustomString25 varchar2(2700) path 'ws:CustomString25',
CustomString26 varchar2(2700) path 'ws:CustomString26',
CustomString27 varchar2(2700) path 'ws:CustomString27',
CustomString28 varchar2(2700) path 'ws:CustomString28',
CustomString29 varchar2(2700) path 'ws:CustomString29',
CustomString30 varchar2(2700) path 'ws:CustomString30',
CustomString31 varchar2(2700) path 'ws:CustomString31',
CustomString32 varchar2(2700) path 'ws:CustomString32',
CustomString33 varchar2(2700) path 'ws:CustomString33',
CustomString34 varchar2(2700) path 'ws:CustomString34',
CustomString35 varchar2(2700) path 'ws:CustomString35',
CustomString36 varchar2(2700) path 'ws:CustomString36',
CustomString37 varchar2(2700) path 'ws:CustomString37',
CustomString38 varchar2(2700) path 'ws:CustomString38',
CustomString39 varchar2(2700) path 'ws:CustomString39',
CustomString40 varchar2(2700) path 'ws:CustomString40',
CustomDate1 varchar2(2700) path 'ws:CustomDate1',
CustomDate2 varchar2(2700) path 'ws:CustomDate2',
CustomDate3 varchar2(2700) path 'ws:CustomDate3',
CustomDate4 varchar2(2700) path 'ws:CustomDate4',
CustomDate5 varchar2(2700) path 'ws:CustomDate5',
CustomNumber1 varchar2(2700) path 'ws:CustomNumber1',
CustomNumber2 varchar2(2700) path 'ws:CustomNumber2',
CustomNumber3 varchar2(2700) path 'ws:CustomNumber3',
CustomNumber4 varchar2(2700) path 'ws:CustomNumber4',
CustomNumber5 varchar2(2700) path 'ws:CustomNumber5'
 ) x
      where t.id = :Individual  -- Individual
;

/* List XML as Columns for Entities */

SELECT t.id
,replace(x.ListSubKey,'?',null) ListSubKey
,replace(x.ListRecordType,'?',null) ListRecordType
,replace(x.ListRecordOrigin,'?',null) ListRecordOrigin
,replace(x.CustId,'?',null) CustId
,replace(x.CustSubId,'?',null) CustSubId
,replace(x.RegistrationNumber,'?',null) RegistrationNumber
,replace(x.EntityName,'?',null) EntityName
,replace(x.NameType,'?',null) NameType
,replace(x.NameQuality,'?',null) NameQuality
,replace(x.PrimaryName,'?',null) PrimaryName
,replace(x.OriginalScriptName,'?',null) OriginalScriptName
,replace(x.AliasIsAcronym,'?',null) AliasIsAcronym
,replace(x.Address1,'?',null) Address1
,replace(x.Address2,'?',null) Address2
,replace(x.Address3,'?',null) Address3
,replace(x.Address4,'?',null) Address4
,replace(x.City,'?',null) City
,replace(x.State,'?',null) State
,replace(x.PostalCode,'?',null) PostalCode
,replace(x.AddressCountryCode,'?',null) AddressCountryCode
,replace(x.RegistrationCountryCode,'?',null) RegistrationCountryCode
,replace(x.OperatingCountryCodes,'?',null) OperatingCountryCodes
,replace(x.ProfileHyperlink,'?',null) ProfileHyperlink
,replace(x.RiskScore,'?',null) RiskScore
,replace(x.DataConfidenceScore,'?',null) DataConfidenceScore
,replace(x.DataConfidenceComment,'?',null) DataConfidenceComment
,replace(x.CustomString1,'?',null) CustomString1
,replace(x.CustomString2,'?',null) CustomString2
,replace(x.CustomString3,'?',null) CustomString3
,replace(x.CustomString4,'?',null) CustomString4
,replace(x.CustomString5,'?',null) CustomString5
,replace(x.CustomString6,'?',null) CustomString6
,replace(x.CustomString7,'?',null) CustomString7
,replace(x.CustomString8,'?',null) CustomString8
,replace(x.CustomString9,'?',null) CustomString9
,replace(x.CustomString10,'?',null) CustomString10
,replace(x.CustomString11,'?',null) CustomString11
,replace(x.CustomString12,'?',null) CustomString12
,replace(x.CustomString13,'?',null) CustomString13
,replace(x.CustomString14,'?',null) CustomString14
,replace(x.CustomString15,'?',null) CustomString15
,replace(x.CustomString16,'?',null) CustomString16
,replace(x.CustomString17,'?',null) CustomString17
,replace(x.CustomString18,'?',null) CustomString18
,replace(x.CustomString19,'?',null) CustomString19
,replace(x.CustomString20,'?',null) CustomString20
,replace(x.CustomString21,'?',null) CustomString21
,replace(x.CustomString22,'?',null) CustomString22
,replace(x.CustomString23,'?',null) CustomString23
,replace(x.CustomString24,'?',null) CustomString24
,replace(x.CustomString25,'?',null) CustomString25
,replace(x.CustomString26,'?',null) CustomString26
,replace(x.CustomString27,'?',null) CustomString27
,replace(x.CustomString28,'?',null) CustomString28
,replace(x.CustomString29,'?',null) CustomString29
,replace(x.CustomString30,'?',null) CustomString30
,replace(x.CustomString31,'?',null) CustomString31
,replace(x.CustomString32,'?',null) CustomString32
,replace(x.CustomString33,'?',null) CustomString33
,replace(x.CustomString34,'?',null) CustomString34
,replace(x.CustomString35,'?',null) CustomString35
,replace(x.CustomString36,'?',null) CustomString36
,replace(x.CustomString37,'?',null) CustomString37
,replace(x.CustomString38,'?',null) CustomString38
,replace(x.CustomString39,'?',null) CustomString39
,replace(x.CustomString40,'?',null) CustomString40
,replace(x.CustomDate1,'?',null) CustomDate1
,replace(x.CustomDate2,'?',null) CustomDate2
,replace(x.CustomDate3,'?',null) CustomDate3
,replace(x.CustomDate4,'?',null) CustomDate4
,replace(x.CustomDate5,'?',null) CustomDate5
,replace(x.CustomNumber1,'?',null) CustomNumber1
,replace(x.CustomNumber2,'?',null) CustomNumber2
,replace(x.CustomNumber3,'?',null) CustomNumber3
,replace(x.CustomNumber4,'?',null) CustomNumber4
,replace(x.CustomNumber5,'?',null) CustomNumber5
from xwrl_requests t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "env", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:request'
         PASSING t.request
         columns 
         rec for ordinality,
         ListSubKey varchar2(2700) path 'ws:ListSubKey',
ListRecordType varchar2(2700) path 'ws:ListRecordType',
ListRecordOrigin varchar2(2700) path 'ws:ListRecordOrigin',
CustId varchar2(2700) path 'ws:CustId',
CustSubId varchar2(2700) path 'ws:CustSubId',
RegistrationNumber varchar2(2700) path 'ws:RegistrationNumber',
EntityName varchar2(2700) path 'ws:EntityName',
NameType varchar2(2700) path 'ws:NameType',
NameQuality varchar2(2700) path 'ws:NameQuality',
PrimaryName varchar2(2700) path 'ws:PrimaryName',
OriginalScriptName varchar2(2700) path 'ws:OriginalScriptName',
AliasIsAcronym varchar2(2700) path 'ws:AliasIsAcronym',
Address1 varchar2(2700) path 'ws:Address1',
Address2 varchar2(2700) path 'ws:Address2',
Address3 varchar2(2700) path 'ws:Address3',
Address4 varchar2(2700) path 'ws:Address4',
City varchar2(2700) path 'ws:City',
State varchar2(2700) path 'ws:State',
PostalCode varchar2(2700) path 'ws:PostalCode',
AddressCountryCode varchar2(2700) path 'ws:AddressCountryCode',
RegistrationCountryCode varchar2(2700) path 'ws:RegistrationCountryCode',
OperatingCountryCodes varchar2(2700) path 'ws:OperatingCountryCodes',
ProfileHyperlink varchar2(2700) path 'ws:ProfileHyperlink',
RiskScore varchar2(2700) path 'ws:RiskScore',
DataConfidenceScore varchar2(2700) path 'ws:DataConfidenceScore',
DataConfidenceComment varchar2(2700) path 'ws:DataConfidenceComment',
CustomString1 varchar2(2700) path 'ws:CustomString1',
CustomString2 varchar2(2700) path 'ws:CustomString2',
CustomString3 varchar2(2700) path 'ws:CustomString3',
CustomString4 varchar2(2700) path 'ws:CustomString4',
CustomString5 varchar2(2700) path 'ws:CustomString5',
CustomString6 varchar2(2700) path 'ws:CustomString6',
CustomString7 varchar2(2700) path 'ws:CustomString7',
CustomString8 varchar2(2700) path 'ws:CustomString8',
CustomString9 varchar2(2700) path 'ws:CustomString9',
CustomString10 varchar2(2700) path 'ws:CustomString10',
CustomString11 varchar2(2700) path 'ws:CustomString11',
CustomString12 varchar2(2700) path 'ws:CustomString12',
CustomString13 varchar2(2700) path 'ws:CustomString13',
CustomString14 varchar2(2700) path 'ws:CustomString14',
CustomString15 varchar2(2700) path 'ws:CustomString15',
CustomString16 varchar2(2700) path 'ws:CustomString16',
CustomString17 varchar2(2700) path 'ws:CustomString17',
CustomString18 varchar2(2700) path 'ws:CustomString18',
CustomString19 varchar2(2700) path 'ws:CustomString19',
CustomString20 varchar2(2700) path 'ws:CustomString20',
CustomString21 varchar2(2700) path 'ws:CustomString21',
CustomString22 varchar2(2700) path 'ws:CustomString22',
CustomString23 varchar2(2700) path 'ws:CustomString23',
CustomString24 varchar2(2700) path 'ws:CustomString24',
CustomString25 varchar2(2700) path 'ws:CustomString25',
CustomString26 varchar2(2700) path 'ws:CustomString26',
CustomString27 varchar2(2700) path 'ws:CustomString27',
CustomString28 varchar2(2700) path 'ws:CustomString28',
CustomString29 varchar2(2700) path 'ws:CustomString29',
CustomString30 varchar2(2700) path 'ws:CustomString30',
CustomString31 varchar2(2700) path 'ws:CustomString31',
CustomString32 varchar2(2700) path 'ws:CustomString32',
CustomString33 varchar2(2700) path 'ws:CustomString33',
CustomString34 varchar2(2700) path 'ws:CustomString34',
CustomString35 varchar2(2700) path 'ws:CustomString35',
CustomString36 varchar2(2700) path 'ws:CustomString36',
CustomString37 varchar2(2700) path 'ws:CustomString37',
CustomString38 varchar2(2700) path 'ws:CustomString38',
CustomString39 varchar2(2700) path 'ws:CustomString39',
CustomString40 varchar2(2700) path 'ws:CustomString40',
CustomDate1 varchar2(2700) path 'ws:CustomDate1',
CustomDate2 varchar2(2700) path 'ws:CustomDate2',
CustomDate3 varchar2(2700) path 'ws:CustomDate3',
CustomDate4 varchar2(2700) path 'ws:CustomDate4',
CustomDate5 varchar2(2700) path 'ws:CustomDate5',
CustomNumber1 varchar2(2700) path 'ws:CustomNumber1',
CustomNumber2 varchar2(2700) path 'ws:CustomNumber2',
CustomNumber3 varchar2(2700) path 'ws:CustomNumber3',
CustomNumber4 varchar2(2700) path 'ws:CustomNumber4',
CustomNumber5 varchar2(2700) path 'ws:CustomNumber5'
 ) x
      where t.id = :Entity -- Entity
;

/* List XML as Rows for Individuals or Entities*/

SELECT t.id,t.path,x.rw,x.key,replace(x.value,'?',null) value
from xwrl_requests t,
  XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:request/ws:*'
         PASSING t.request
         columns   rw for ordinality,
         key varchar2(100)  path 'name()',
          value varchar2(2700)  path 'text()'
       )  x
      where t.id = :Id  -- Individual or Entity
;

/*** RESPONSES ***/

/* List XML as Columns for Individuals*/

SELECT t.id,
x.rec,
x.ListKey,
x.ListSubKey,
x.ListRecordType,
x.ListRecordOrigin,
x.ListId,
x.ListGivenNames,
x.ListFamilyName,
x.ListFullName,
x.ListNameType,
x.ListPrimaryName,
x.ListOriginalScriptName,
x.ListDOB,
x.ListCity,
x.ListCountry,
x.ListCountryOfBirth,
x.ListNationality,
x.MatchRule,
x.MatchScore,
x.CaseKey,
x.AlertId,
x.RiskScore,
x.RiskScorePEP
from xwrl_requests t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "env", 'http://www.datanomic.com/ws' as "dn"),
         '//dn:response/dn:record'
         PASSING t.response
         columns 
          rec for ordinality,
          ListKey varchar2(2700) path 'dn:ListKey',
ListSubKey varchar2(2700) path 'dn:ListSubKey',
ListRecordType varchar2(2700) path 'dn:ListRecordType',
ListRecordOrigin varchar2(2700) path 'dn:ListRecordOrigin',
ListId varchar2(2700) path 'dn:ListId',
ListGivenNames varchar2(2700) path 'dn:ListGivenNames',
ListFamilyName varchar2(2700) path 'dn:ListFamilyName',
ListFullName varchar2(2700) path 'dn:ListFullName',
ListNameType varchar2(2700) path 'dn:ListNameType',
ListPrimaryName varchar2(2700) path 'dn:ListPrimaryName',
ListOriginalScriptName varchar2(2700) path 'dn:ListOriginalScriptName',
ListDOB varchar2(2700) path 'dn:ListDOB',
ListCity varchar2(2700) path 'dn:ListCity',
ListCountry varchar2(2700) path 'dn:ListCountry',
ListCountryOfBirth varchar2(2700) path 'dn:ListCountryOfBirth',
ListNationality varchar2(2700) path 'dn:ListNationality',
MatchRule varchar2(2700) path 'dn:MatchRule',
MatchScore varchar2(2700) path 'dn:MatchScore',
CaseKey varchar2(2700) path 'dn:CaseKey',
AlertId varchar2(2700) path 'dn:AlertId',
RiskScore varchar2(2700) path 'dn:RiskScore',
RiskScorePEP varchar2(2700) path 'dn:RiskScorePEP'
       ) x
      where t.id = :Individual  -- Individual
;

/* List XML as Columns for Entities */

SELECT t.id, 
x.rec,
x.ListKey,
x.ListSubKey,
x.ListRecordType,
x.ListRecordOrigin,
x.ListId,
x.ListEntityName,
x.ListPrimaryName,
x.ListOriginalScriptName,
x.ListNameType,
x.ListCity,
x.ListCountry,
x.ListOperatingCountries,
x.ListRegistrationCountries,
x.MatchRule,
x.MatchScore,
x.CaseKey,
x.AlertId,
x.RiskScore,
x.RiskScorePEP
from xwrl_requests t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "env", 'http://www.datanomic.com/ws' as "dn"),
         '//dn:response/dn:record'
         PASSING t.response
         columns  rec for ordinality,
         ListKey varchar2(2700) path 'dn:ListKey',
ListSubKey varchar2(2700) path 'dn:ListSubKey',
ListRecordType varchar2(2700) path 'dn:ListRecordType',
ListRecordOrigin varchar2(2700) path 'dn:ListRecordOrigin',
ListId varchar2(2700) path 'dn:ListId',
ListEntityName varchar2(2700) path 'dn:ListEntityName',
ListPrimaryName varchar2(2700) path 'dn:ListPrimaryName',
ListOriginalScriptName varchar2(2700) path 'dn:ListOriginalScriptName',
ListNameType varchar2(2700) path 'dn:ListNameType',
ListCity varchar2(2700) path 'dn:ListCity',
ListCountry varchar2(2700) path 'dn:ListCountry',
ListOperatingCountries varchar2(2700) path 'dn:ListOperatingCountries',
ListRegistrationCountries varchar2(2700) path 'dn:ListRegistrationCountries',
MatchRule varchar2(2700) path 'dn:MatchRule',
MatchScore varchar2(2700) path 'dn:MatchScore',
CaseKey varchar2(2700) path 'dn:CaseKey',
AlertId varchar2(2700) path 'dn:AlertId',
RiskScore varchar2(2700) path 'dn:RiskScore',
RiskScorePEP varchar2(2700) path 'dn:RiskScorePEP'
       ) x
      where t.id = :Entity -- Entity
;

/* List XML as Rows */

SELECT t.id,t.path,resp.ows_id,rec.rec_row,det.det_row,det.key,det.value
from xwrl_requests t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "env", 'http://www.datanomic.com/ws' as "dn"),
         '//dn:response'
         PASSING t.response
         columns  ows_id    varchar2(50) path '@id'
         ,record_list xmltype path '*'
       ) resp
       ,xmltable(
       '/*'
       passing resp.record_list
       columns rec_row for ordinality
       ,detail_list xmltype path '*') rec
        ,xmltable(
       '/*'
       passing rec.detail_list
       columns det_row for ordinality,
       key varchar2(100)  path 'name()',
          value varchar2(2700)  path 'text()') det
      where t.id = :Id  -- Individual or Entity.det_row      
      order by rec.rec_row,det.det_row
;

SELECT *
FROM all_scheduler_jobs
order by start_date desc
;

SELECT count(*)
FROM all_scheduler_jobs
order by start_date desc
;

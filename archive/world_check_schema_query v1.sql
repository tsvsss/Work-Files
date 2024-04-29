

SELECT x.value
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS value VARCHAR2(200) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'REQUEST_INDIVIDUAL' 
and x.value <> 'request';	

SELECT x.value
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS value VARCHAR2(200) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'REQUEST_ENTITY' 
and x.value <> 'request';	



SELECT x.value
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS value VARCHAR2(200) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'RESPONSE_INDIVIDUAL' 
and x.value <> 'response'
and x.value <> 'record'
;	

SELECT x.value
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS value VARCHAR2(200) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'RESPONSE_ENTITY' 
and x.value <> 'response'
and x.value <> 'record'
;	

/*
DELETE FROM xwrl_parameters
where id = 'XML'
and key in ('INDIVIDUAL','ENTITY','RESPONSE');

DELETE FROM xwrl_requests;
*/

select * from xwrl_keywords;

select * from xwrl_location_types;

select * from xwrl_parameters
where id = 'XML';

select *
from xwrl_requests
order by id desc;



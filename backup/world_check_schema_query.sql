

SELECT x.value
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS value VARCHAR2(200) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'INDIVIDUAL' 
and x.value <> 'request';	

SELECT x.value
from xwrl_parameters t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS value VARCHAR2(200) PATH 'name()'
       ) x
where t.id = 'XML'
and t.key  = 'ENTITY' 
and x.value <> 'request';	

DELETE FROM xwrl_parameters
where id = 'XML'
and key in ('INDIVIDUAL','ENTITY','RESPONSE');

DELETE FROM xwrl_requests;


select name_screened
from WC_SCREENING_REQUEST
where entity_type = 'ORGANISATION'
--where entity_type = 'INDIVIDUAL'
and trunc(creation_date) = trunc(sysdate)
;

select * from xwrl_keywords;

select * from xwrl_location_types;

select * from xwrl_parameters;

select * from xwrl_requests order by id desc;

select * from xwrl_requests WHERE id = 1542;

select * from xwrl_request_ind_columns order by request_id desc;
select * from xwrl_request_entity_columns order by request_id desc;
select * from xwrl_request_rows order by request_id desc, rw;
select * from xwrl_response_ind_columns order by request_id desc, rec;
select * from xwrl_response_entity_columns order by request_id desc;
select * from xwrl_response_rows order by request_id desc, rec_row, det_row;


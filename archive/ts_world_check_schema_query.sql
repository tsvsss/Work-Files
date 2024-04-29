

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


--DELETE FROM xwrl_parameters where id = 'XML' and key in ('INDIVIDUAL','ENTITY','RESPONSE');
--DELETE FROM xwrl_requests;


select *
from WC_SCREENING_REQUEST
order by wc_screening_request_id desc
;

select trunc(creation_date), count(*)
from WC_SCREENING_REQUEST
where trunc(creation_date) > sysdate - 30
group by trunc(creation_date)
;



      SELECT
         wsr.wc_screening_request_id
         , wsr.name_screened
      FROM
         wc_screening_request   wsr
         , xwrl_requests          xr
      WHERE
         wsr.wc_screening_request_id = xr.wc_screening_request_id (+)
         AND wsr.entity_type = 'ORGANISATION'
      --AND trunc (wsr.creation_date) >= trunc (SYSDATE) - 30
         AND xr.wc_screening_request_id IS NULL
         --AND ROWNUM < v_rownum
;

select * from xwrl_keywords;
`
select * from xwrl_location_types;

select * from xwrl_parameters ORDER BY 1,2;

select *
from xwrl_requests r
where r.status = 'ERROR' order by id desc;

select *
from all_scheduler_job_run_details
where job_name = 'OWS_I_2019030707_236_JOB';

select * from xwrl_requests  
where status = 'ERROR'
and error_code = 'ORA-29276'
and substr(job_id,1,5) <> 'OWS_R'
order by id desc;

select * from xwrl_requests  order by id desc;

select * from xwrl_request_ind_columns order by request_id desc;
select * from xwrl_request_entity_columns order by request_id desc;
select * from xwrl_request_rows order by request_id desc, rw;
select * from xwrl_response_ind_columns order by request_id desc, rec;
select * from xwrl_response_entity_columns order by request_id desc;
select * from xwrl_response_rows order by request_id desc, rec_row, det_row;


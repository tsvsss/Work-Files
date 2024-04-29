/* Check Requests for current Trade Compliance Module */

select *
from WC_SCREENING_REQUEST
order by wc_screening_request_id desc
;

select trunc(creation_date), count(*)
from WC_SCREENING_REQUEST
where trunc(creation_date) > sysdate - 30
group by trunc(creation_date)
;

select trunc(creation_date,'hh24') + (trunc(to_char(creation_date,'mi')/:n)*:n)/24/60, count(*)
 from WC_SCREENING_REQUEST
 --where trunc(creation_date) = to_date('03/12/2019','MM/DD/YYYY')
 where trunc(creation_date) >= trunc(sysdate) - 365
 group by trunc(creation_date,'hh24') + (trunc(to_char(creation_date,'mi')/:n)*:n)/24/60
 order by 2 desc;


/* Schema Tables */

select * from xwrl_keywords;
select * from xwrl_location_types;
select * from xwrl_parameters order by id, key;
select * from xwrl_requests  order by id desc;
select * from xwrl_request_ind_columns order by request_id desc;
select * from xwrl_request_entity_columns order by request_id desc;
select * from xwrl_request_rows order by request_id desc, rw;
select * from xwrl_response_ind_columns order by request_id desc, rec;
select * from xwrl_response_entity_columns order by request_id desc;
select * from xwrl_response_rows order by request_id desc, rec_row, det_row;

/* Schema Queries */

select * from xwrl_parameters
where ID in ('LOADBALANCER','FREQUENCY','LOADBALANCE_SERVER','PRIMARY_SERVER','SECONDARY_SERVER')
;

-- Request Records

select id, resubmit_id, server, path, request, response, job_id, matches, status, error_code, error_message, creation_date from xwrl_requests  order by id desc;

-- Recursive Check for Rebmits

with resubmit as (select resubmit_id
from xwrl_requests
where resubmit_id is not null) 
select x.id, x.resubmit_id, x.server, path, x.request, x.response, x.job_id, x.matches, x.status, x.error_code, x.error_message, x.creation_date 
from xwrl_requests  x
,resubmit
where x.id = resubmit.resubmit_id
order by id desc;

/* Check Request Records by Status */

SELECT  UNIQUE status from xwrl_requests;

select id, resubmit_id, server, path, request, response, job_id, matches, status, error_code, error_message, creation_date from xwrl_requests
where status = 'ERROR' order by id desc;

select id, resubmit_id, server, path, request, response, job_id, matches, status, error_code, error_message, creation_date from xwrl_requests
where status = 'RESUBMIT' order by id desc;

select id, resubmit_id, server, path, request, response, job_id, matches, status, error_code, error_message, creation_date from xwrl_requests
where status = 'FAILED' order by id desc;

select id, resubmit_id, server, path, request, response, job_id, matches, status, error_code, error_message, creation_date from xwrl_requests
where status =  'COMPLETE' order by id desc;


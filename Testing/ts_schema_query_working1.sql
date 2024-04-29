
declare
cursor c1 is
select id
from xwrl_requests
where id between 54332 and 54382
--where id = 13655
--WHERE BATCH_ID = 1183
--where case_state = 'E'
--and id = 10393
--where batch_id is null
--where name_screened is null
----WHERE STATUS = 'RESUBMIT'
--where status = 'ERROR'
--where case_id is null
--and job_id is not null
--where  id between 2475 and 2494
--where server = 'IRIPRODOWS-SEC'
--and created_by is null
--WHERE status = 'INVALID'
--where status = 'ERROR'
--where batch_id in (1141)
-- whEre source_table  = 'SICD_SEFARERS'
--AND source_id = 599999
--where case_id = 'OWS-201911-171057-E58D09-INDx'
--where id < 19000
--where id = -1

;

v_ctr integer := 0;

begin


for  c1rec in c1 loop

v_ctr := v_ctr + 1;

begin


delete from xwrl_response_ind_columns where request_id = c1rec.id;
delete from xwrl_response_entity_columns where request_id = c1rec.id;
delete xwrl_response_rows where request_id = c1rec.id;
DELETE from xwrl_alert_documents where request_id = c1rec.id;
DELETE from xwrl_case_documents where request_id = c1rec.id;
DELETE from xwrl_request_ind_columns where request_id = c1rec.id;
DELETE from xwrl_request_entity_columns where request_id = c1rec.id;
DELETE from xwrl_request_rows where request_id = c1rec.id;
delete from xwrl_requests where id = c1rec.id;

--exception 
--when others then null;
end;

end loop;

dbms_output.put_line('Records processed: '||v_ctr);

end;
/

select * 
from xwrl_requests 
--where status = 'ERROR'
--where case_id is null
order by id desc
;


select * 
from xwrl_requests 
--where status = 'ERROR'
where name_screened is null
order by id desc;

/* Check Requests for current Trade Compliance Module */

select *
from WC_SCREENING_REQUEST
--where WC_SCREENING_REQUEST_ID = :WC_SCREENING_REQUEST_ID
where rownum < 10
order by wc_screening_request_id desc
;

select  notes, count(*)
from WC_SCREENING_REQUEST
where notes is not null
group by notes
having count(*) > 1
order by 2 desc
;

select *
from wc_matches
where WC_SCREENING_REQUEST_ID = :WC_SCREENING_REQUEST_ID
order by wc_screening_request_id desc
;

select *
from wc_content
where WC_SCREENING_REQUEST_ID = :WC_SCREENING_REQUEST_ID
;

select xml_response
from wc_content
where WC_SCREENING_REQUEST_ID = :WC_SCREENING_REQUEST_ID
and wc_content_id = :wc_content_id
;

SELECT count(*)
FROM  XWRL_REQUESTS XwrlRequests  
;
RMI_OWS_COMMON_UTIL

SELECT count(*)
FROM  XWRL_REQUESTS XwrlRequests  
,WC_SCREENING_REQUEST Wc  
WHERE XwrlRequests.WC_SCREENING_REQUEST_ID = Wc.WC_SCREENING_REQUEST_ID (+)
;

with matches as (select wm.WC_SCREENING_REQUEST_ID, max(wm.number_of_matches)
from wc_matches wm
group by wm.WC_SCREENING_REQUEST_ID)
SELECT count(*)
FROM  XWRL_REQUESTS XwrlRequests  
,WC_SCREENING_REQUEST Wc  
,matches Wm
WHERE XwrlRequests.WC_SCREENING_REQUEST_ID = Wc.WC_SCREENING_REQUEST_ID (+)
AND XwrlRequests.WC_SCREENING_REQUEST_ID = Wm.WC_SCREENING_REQUEST_ID (+)
;

SELECT XwrlRequests.WC_SCREENING_REQUEST_ID,  count(*)
FROM  XWRL_REQUESTS XwrlRequests  
,WC_SCREENING_REQUEST Wc  
,WC_MATCHES Wm
WHERE XwrlRequests.WC_SCREENING_REQUEST_ID = Wc.WC_SCREENING_REQUEST_ID (+)
AND XwrlRequests.WC_SCREENING_REQUEST_ID = Wm.WC_SCREENING_REQUEST_ID (+)
group by XwrlRequests.WC_SCREENING_REQUEST_ID
having count(*) > 1
;

with matches as (select wm.WC_SCREENING_REQUEST_ID, max(wm.number_of_matches) TC_MATCHES
from wc_matches wm
group by wm.WC_SCREENING_REQUEST_ID)
SELECT XwrlRequests.ID,    
       XwrlRequests.RESUBMIT_ID,    
       XwrlRequests.SOURCE_TABLE,    
       XwrlRequests.SOURCE_ID,    
       XwrlRequests.WC_SCREENING_REQUEST_ID,    
       XwrlRequests.SERVER,    
       XwrlRequests.PATH,    
       XwrlRequests.SOAP_QUERY,    
       XwrlRequests.REQUEST,    
       XwrlRequests.RESPONSE,    
       XwrlRequests.JOB_ID,    
       XwrlRequests.MATCHES,    
       XwrlRequests.STATUS,    
       XwrlRequests.ERROR_CODE,    
       XwrlRequests.ERROR_MESSAGE,    
       XwrlRequests.LAST_UPDATE_DATE,    
       XwrlRequests.LAST_UPDATED_BY,    
       XwrlRequests.CREATION_DATE,    
       XwrlRequests.CREATED_BY,    
       XwrlRequests.LAST_UPDATE_LOGIN,   
       Wc.NAME_SCREENED NAME_SCREENED, 
       Wc.DATE_OF_BIRTH DATE_OF_BIRTH,
       Wm.TC_MATCHES
FROM  XWRL_REQUESTS XwrlRequests  
,WC_SCREENING_REQUEST Wc  
,matches Wm
WHERE XwrlRequests.WC_SCREENING_REQUEST_ID = Wc.WC_SCREENING_REQUEST_ID (+)
AND XwrlRequests.WC_SCREENING_REQUEST_ID = Wm.WC_SCREENING_REQUEST_ID (+)
;



select trunc(creation_date), count(*)
from WC_SCREENING_REQUEST
where trunc(creation_date) > sysdate - 30
group by trunc(creation_date)
;

select *
from WC_SCREENING_REQUEST
where WC_SCREENING_REQUEST_ID = :WC_SCREENING_REQUEST_ID
;



select c.WC_SCREENING_REQUEST_ID
,c.wc_matches_id
,c.wc_content_id
from wc_content c
,xwrl_requests r
where c.WC_SCREENING_REQUEST_ID = r.WC_SCREENING_REQUEST_ID
and c.WC_SCREENING_REQUEST_ID = :WC_SCREENING_REQUEST_ID
order by c.WC_SCREENING_REQUEST_ID desc
;

select *
from xwrl_wc_contents
where WC_SCREENING_REQUEST_ID = :WC_SCREENING_REQUEST_ID
;



select wm.WC_SCREENING_REQUEST_ID, wm.number_of_matches
from wc_matches wm
where wm.WC_SCREENING_REQUEST_ID = :WC_SCREENING_REQUEST_ID
and wm.creation_date = (select max(x.creation_date) from wc_matches x where x.wc_screening_request_id = wm.WC_SCREENING_REQUEST_ID)
;

select * from xwrl_keywords;

select * from xwrl_location_types;

select trunc(creation_date,'hh24') + (trunc(to_char(creation_date,'mi')/:time_interval)*:time_interval)/24/60 time_interval, count(*)
 from WC_SCREENING_REQUEST
 --where trunc(creation_date) = to_date('03/12/2019','MM/DD/YYYY')
 where trunc(creation_date) >= trunc(sysdate) - 365
 group by trunc(creation_date,'hh24') + (trunc(to_char(creation_date,'mi')/:time_interval)*:time_interval)/24/60
 order by 2 desc;

select trunc(ACTUAL_START_DATE,'hh24') + (trunc(to_char(ACTUAL_START_DATE,'mi')/:time_interval)*:time_interval)/24/60 time_interval, count(*) requests,  ROUND(avg(EXTRACT( MINUTE FROM run_duration )),2) avg_time
 from all_scheduler_job_run_details
 --where trunc(creation_date) = to_date('03/12/2019','MM/DD/YYYY')
 where trunc(ACTUAL_START_DATE) >= trunc(sysdate) - 365
 group by trunc(ACTUAL_START_DATE,'hh24') + (trunc(to_char(ACTUAL_START_DATE,'mi')/:time_interval)*:time_interval)/24/60
 order by 1 desc;

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


select * from xwrl_request_ind_columns 
where request_id = 12497;


/* Schema Queries */

select * from xwrl_parameters
where ID in ('LOADBALANCER','FREQUENCY','LOADBALANCE_SERVER','PRIMARY_SERVER','SECONDARY_SERVER')
;

-- Request Records

select id, resubmit_id, server, path, request, response, job_id, matches, status, error_code, error_message, creation_date 
from xwrl_requests  
where status = 'ERROR'
order by error_code, id desc;

select id, SOURCE_TABLE, SOURCE_ID,  status, error_code, error_message, creation_date from xwrl_requests  
where path = 'ENTITY'
--where path = 'INDIVIDUAL'
--AND ERROR_CODE = 'ORA--20100'
order by error_code, id desc;

-- Recursive Check for Rebmits

with resubmit as (select resubmit_id
from xwrl_requests
where resubmit_id is not null) 
select x.id, x.resubmit_id, x.server, path, x.request, x.response, x.job_id, x.matches, x.status, x.error_code, x.error_message, x.creation_date 
from xwrl_requests  x
,resubmit
where x.id = resubmit.resubmit_id
order by id desc;


with resubmit as (select resubmit_id
from xwrl_requests
where resubmit_id is not null) 
select x.id, x.resubmit_id, x.server, path, x.request, x.response, x.job_id, x.matches, x.status, x.error_code, x.error_message, x.creation_date, det.*
from xwrl_requests  x
,resubmit
,all_scheduler_job_run_details det
where x.id = resubmit.resubmit_id
and x.job_id = det.job_name
and rownum < 100
order by id desc;

select *
from all_scheduler_job_run_details
--where job_name = :job_id
;

select *
from xwrl_requests
;

select * from xwrl_request_ind_columns

;

alter table xwrl.xwrl_requests add (parent_id integer);

select *
from all_objects
where object_name LIKE 'XWRL_REQUEST_IND%'
;

select * from xwrl_request_entity_columns
;

select *
from WC_SCREENING_REQUEST
where alias_wc_screening_request_id is not null
;

select unique category from xwrl_response_ind_columns;

select unique category from xwrl_response_entity_columns;

select iso_alpha2_code country_code
,iso_description country_name
,country_code legacy_country_code
,sanction_status
from sicd_countries
where sanction_status <> 'NONE'
;

select *
from xwrl_parameters
;

alter table  xwrl.xwrl_requests add (city_of_residence_id number);

/* Check Request Records by Status */

SELECT  UNIQUE error_code, error_message
from xwrl_requests
where error_code is not null;

select id, resubmit_id, server, path, request, response, job_id, matches, status, error_code, error_message, creation_date from xwrl_requests
where status = 'INITIALIZED' order by id desc;

select id, resubmit_id, server, path, request, response, job_id, matches, status, error_code, error_message, creation_date from xwrl_requests
where status = 'ERROR' order by id desc;

select id, resubmit_id, server, path, request, response, job_id, matches, status, error_code, error_message, creation_date from xwrl_requests
where status = 'RESUBMIT' order by id desc;

select id, resubmit_id, server, path, request, response, job_id, matches, status, error_code, error_message, creation_date from xwrl_requests
where status = 'FAILED' order by id desc;

select id, resubmit_id, server, path, request, response, job_id, matches, status, error_code, error_message, creation_date from xwrl_requests
where status =  'COMPLETE' order by id desc;

SELECT
   trunc (d.actual_start_date, 'hh24') + (trunc (TO_CHAR (d.actual_start_date, 'mi') / :time_interval) * :time_interval) / 24 / 60 time_interval
   , COUNT (*) requests
   , round (AVG (EXTRACT (SECOND FROM d.run_duration)), 2) avg_time_sec
   , MIN (EXTRACT (SECOND FROM d.run_duration)) min_time_sec
   , MAX (EXTRACT (SECOND FROM d.run_duration)) max_time_sec
   , round(sum( vsize (r.request))/1024,2) sum_request_size_mb
   ,round(sum( vsize (r.response))/1024,2) sum_response_size_mb
 from all_scheduler_job_run_details d
 ,xwrl_requests r
 where d.job_name = r.job_id
 and trunc(d.ACTUAL_START_DATE) >= trunc(sysdate) - 365
 group by trunc (d.actual_start_date, 'hh24') + (trunc (TO_CHAR (d.actual_start_date, 'mi') / :time_interval) * :time_interval) / 24/ 60 order by 1 desc;

/* Request Data */


/*
delete from xwrl_request_ind_columns
where request_id > 11728;

delete from xwrl_request_entity_columns
where request_id > 11728;

delete from XWRL_REQUEST_ROWS
where request_id > 11728;

delete from XWRL_RESPONSE_IND_COLUMNS
where request_id > 11728;

delete from XWRL_RESPONSE_ENTITY_COLUMNS
where request_id > 11728;

delete from XWRL_RESPONSE_ROWS
where request_id > 11728;

delete from xwrl_requests
where id > 11728;
*/

select id, resubmit_id, server, path, request, response, job_id, matches, status, error_code, error_message, creation_date, last_update_date from xwrl_requests  order by id desc
;

select r.id, r.resubmit_id, r.server, r.path, r.request, r.response, r.job_id, r.matches, r.status, r.error_code, r.error_message, r.creation_date, det.run_duration, det.req_start_date, det.actual_start_date from xwrl_requests  r ,all_scheduler_job_run_details det where r.job_id = det.job_name order by id desc
;

/* Check Master Scheduler Jobs */

select owner, job_name
--,program_owner
--,program_name
,enabled
 ,state
 ,next_run_date
 , job_type
, job_action
--, number_of_arguments
, schedule_type, start_date, repeat_interval,  run_count, comments
FROM all_scheduler_jobs
where job_name like 'PROCESS%'
order by start_date desc
;

select owner, job_name
--,program_owner
--,program_name
,enabled
 ,state
 ,next_run_date
 , job_type
, job_action
--, number_of_arguments
, schedule_type, start_date, repeat_interval,  run_count, comments
FROM all_scheduler_jobs
where job_name like 'OWS%'
order by start_date desc
;

/* Key Metrics */

select entry_name, entry_value
from (SELECT 'Running Jobs: ' entry_name, to_char(count(*))  entry_value, 10 FROM all_scheduler_jobs where job_name like 'OWS%'
union
select  job_name,enabled||' '||to_char(next_run_date,'MM/DD/YYYY HH24:MI'),20 FROM all_scheduler_jobs where job_name like 'PROCESS%'
UNION
select 'Complete: '  entry_name, to_char(count(*)) entry_value, 30 order_by from xwrl_requests where status =  'COMPLETE'
union
select 'Error: ',to_char(count(*)) ,40  from xwrl_requests where status =  'ERROR'
union
select 'Resubmit: ',to_char(count(*)),50  from xwrl_requests where status =  'RESUBMIT'
union
select 'Failed: ',to_char(count(*)),60  from xwrl_requests where status =  'FAILED'
union
select 'Instance', xwrl_utils.get_instance,70 from dual
union
select 'Max Jobs', to_char(xwrl_utils.get_max_jobs),90 from dual
union
select 'Max Pause', to_char(xwrl_utils.get_max_pause),100 from dual
union
/*select 'Ratio', to_char(xwrl_utils.get_ratio),110 from dual
union
select 'Frequency',to_char(xwrl_utils.get_frequency),110 from dual
union*/
select 'Loadbalancer',xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance),120 from dual
union
select 'Primary Server',xwrl_utils.get_wl_server ('PRIMARY_SERVER',xwrl_utils.get_instance),130 from dual
union
select 'Secondary Server',xwrl_utils.get_wl_server ('SECONDARY_SERVER',xwrl_utils.get_instance),140 from dual
union
select 'Job Queue Processes',value,150 from v$parameter where name='job_queue_processes'
order by 3)
;

SELECT
   trunc (d.actual_start_date, 'hh24') + (trunc (TO_CHAR (d.actual_start_date, 'mi') / :time_interval) * :time_interval) / 24 / 60 time_interval
   , COUNT (*) requests
   , round (AVG (EXTRACT (SECOND FROM d.run_duration)), 2) avg_time_sec
   , MIN (EXTRACT (SECOND FROM d.run_duration)) min_time_sec
   , MAX (EXTRACT (SECOND FROM d.run_duration)) max_time_sec
   , round(sum( vsize (r.request))/1024,2) sum_request_size_mb
   ,round(sum( vsize (r.response))/1024,2) sum_response_size_mb
 from all_scheduler_job_run_details d
 ,xwrl_requests r
 where d.job_name = r.job_id
 and trunc(d.ACTUAL_START_DATE) >= trunc(sysdate) - 365
 group by trunc (d.actual_start_date, 'hh24') + (trunc (TO_CHAR (d.actual_start_date, 'mi') / :time_interval) * :time_interval) / 24/ 60 order by 1 desc;
 
 
 select * from xwrl_alert_clearing_xref
 order by id desc
 ;
 
 /*
 delete from xwrl_alert_clearing_xref
 where id >= 10565856;
 */
 
 select count(*) from xwrl_alert_clearing_xref;

SELECT COUNT(*)
FROM (select source_table, source_id
from xwrl_alert_clearing_xref 
where source_table = 'SICD_SEAFARERS'
group by source_table, source_id)
;

select * from xwrl_alert_clearing_xref order by id desc;

select * from xwrl_alert_clearing_xref 
where source_table = 'SICD_SEAFARERS'
order by id desc;


SELECT ID, KEY, VALUE_STRING, SORT_ORDER, DISPLAY_FLAG
FROM XWRL_PARAMETERS
WHERE ID = 'RESPONSE_ROWS'
AND DISPLAY_FLAG = 'Y'
ORDER BY SORT_ORDER;

select *
from xwrl_response_rows
--where id = 8378999
order by id desc
;

with params as (
SELECT ID parm_id, KEY parm_key, VALUE_STRING parm_label, SORT_ORDER parm_sort_id, DISPLAY_FLAG parm_display
FROM XWRL_PARAMETERS
WHERE ID = 'RESPONSE_ROWS'
--AND DISPLAY_FLAG = 'Y'
ORDER BY SORT_ORDER)
select *
from xwrl_response_rows resp
,params
where resp.key = params.parm_key
order by resp.id desc;


select  *
from (
with params as (
SELECT ID parm_id, KEY parm_key, VALUE_STRING parm_label, SORT_ORDER parm_sort_id, DISPLAY_FLAG parm_display
FROM XWRL_PARAMETERS
WHERE ID = 'RESPONSE_ROWS'
--AND DISPLAY_FLAG = 'Y'
--ORDER BY SORT_ORDER
)
select resp.id id, resp.label, resp.sort_id, resp.display, params.parm_key, params.parm_label, params.parm_sort_id, params.parm_display
from xwrl_response_rows resp
,params
where resp.key = params.parm_key
--and resp. id = 8378999
--and rownum < 100
order by resp.id desc
);

declare 

cursor c1 is

select  *
from (
with params as (
SELECT ID parm_id, KEY parm_key, VALUE_STRING parm_label, SORT_ORDER parm_sort_id, DISPLAY_FLAG parm_display
FROM XWRL_PARAMETERS
WHERE ID = 'RESPONSE_ROWS'
--AND DISPLAY_FLAG = 'Y'
--ORDER BY SORT_ORDER
)
select resp.id id, resp.label, resp.sort_id, resp.display, params.parm_key, params.parm_label, params.parm_sort_id, params.parm_display
from xwrl_response_rows resp
,params
where resp.key = params.parm_key
--and resp. id = 8378999
--and rownum < 100
and resp.display is null
order by resp.id desc
);

begin

for c1rec in c1 loop

/*
dbms_output.put_line('c1rec.id: '||c1rec.id);
dbms_output.put_line('c1rec.parm_label: '||c1rec.parm_label);
dbms_output.put_line('c1rec.parm_label: '||c1rec.parm_display);
dbms_output.put_line('c1rec.parm_label: '||c1rec.parm_sort_id);
*/

/*

update xwrl_response_rows
set label = c1rec.parm_label
,display = c1rec.parm_display
,sort_id = c1rec.parm_sort_id
where id = c1rec.id;

*/


end loop;

end;
/

select *
from xwrl_parameters
;

select *
from xwrl_parameters
where id = 'CASE_STATUS'
ORDER BY SORT_ORDER
;

select *
from xwrl_parameters
where id = 'CASE_STATE'
ORDER BY SORT_ORDER
;


select *
from xwrl_parameters
where id = 'CASE_WORK_FLOW'
ORDER BY SORT_ORDER
;



SELECT
         t.id,
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
x.RiskScorePEP,
x.Category,
x.dnPassportNumber,
x.dnNationalId,
x.dnTitle,
x.dnYOB,
x.dnGender,
x.DeceasedFlag,
x.DeceasedDate,
x.dnOccupation,
x.dnAddress,
x.dnCity,
x.dnState,
x.dnPostalCode,
x.dnAddressCountryCode,
x.dnResidencyCountryCode,
x.dnCountryOfBirthCode,
x.dnNationalityCountryCodes,
x.ExternalSources,
x.CachedExtSources,
x.dnAddedDate,
x.dnLastUpdatedDate
      FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "dn"), '//dn:response/dn:record' PASSING t.response COLUMNS rec FOR ORDINALITY, 
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
RiskScorePEP varchar2(2700) path 'dn:RiskScorePEP',
Category varchar2(2700) path 'dn:Category',
dnPassportNumber varchar2(2700) path 'dn:dnPassportNumber',
dnNationalId varchar2(2700) path 'dn:dnNationalId',
dnTitle varchar2(2700) path 'dn:dnTitle',
dnYOB varchar2(2700) path 'dn:dnYOB',
dnGender varchar2(2700) path 'dn:dnGender',
DeceasedFlag varchar2(2700) path 'dn:DeceasedFlag',
DeceasedDate varchar2(2700) path 'dn:DeceasedDate',
dnOccupation varchar2(2700) path 'dn:dnOccupation',
dnAddress varchar2(2700) path 'dn:dnAddress',
dnCity varchar2(2700) path 'dn:dnCity',
dnState varchar2(2700) path 'dn:dnState',
dnPostalCode varchar2(2700) path 'dn:dnPostalCode',
dnAddressCountryCode varchar2(2700) path 'dn:dnAddressCountryCode',
dnResidencyCountryCode varchar2(2700) path 'dn:dnResidencyCountryCode',
dnCountryOfBirthCode varchar2(2700) path 'dn:dnCountryOfBirthCode',
dnNationalityCountryCodes varchar2(2700) path 'dn:dnNationalityCountryCodes',
ExternalSources varchar2(2700) path 'dn:ExternalSources',
CachedExtSources varchar2(2700) path 'dn:CachedExtSources',
dnAddedDate varchar2(2700) path 'dn:dnAddedDate',
dnLastUpdatedDate varchar2(2700) path 'dn:dnLastUpdatedDate'
		 ) x
      WHERE
         t.id = 1054
         ;
         
         
SELECT
         t.id
         ,x.id case_id
FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "dn"), '//dn:response' PASSING t.response COLUMNS rec FOR ORDINALITY,id varchar2(2700) path '@id'
         ) x
      WHERE
         t.id = 1051
         ;


select *
from xwrl_requests
--where source_table = 'NRMI_CERTIFICATES_KP'
where case_id is null
order by id desc
;

/*

update xwrl_requests
set case_state = 'E'
where status = 'Error';

*/

select *
from  jtf_rs_salesreps
where  salesrep_id >= 100000000
and end_date_active is null
and name is not null
and gl_id_rev is null
order by name
;


select salesrep_id office_id, upper(name) office
from  jtf_rs_salesreps
where  salesrep_id >= 100000000
and end_date_active is null
and name is not null
and gl_id_rev is null
order by upper(name)
;

select *
from vssl_offices
where salesrep_id is not null
and enable = 'Y'
order by description
;



select * from xwrl_requests 
--where name_screened is null
order by id desc;

select * from xwrl_request_ind_columns order by id desc;
select * from xwrl_request_entity_columns order by id desc;


declare

cursor c1 is
select *
from xwrl_request_ind_columns;

x_name_screened varchar2(2700);

begin

for c1rec in c1 loop

      if c1rec.fullname is not null then
            x_name_screened := c1rec.fullname;
      else
            x_name_screened := ltrim(c1rec.givennames||' '|| c1rec.familyname);
      end if;
      /*
      
      update xwrl_requests
      set name_screened = x_name_screened
      where id = c1rec.request_id;
      */
      end loop;
      
      ----commit;
      
end;       
/

declare

cursor c1 is
select *
from xwrl_request_entity_columns;

x_name_screened varchar2(2700);

begin

for c1rec in c1 loop
/*
      
      update xwrl_requests
      set name_screened = c1rec.entityname
      where id = c1rec.request_id;
    */  
      end loop;
      
      ----commit;
      
end;     
/

declare

cursor c1 is
select *
from xwrl_request_ind_columns;

x_name_screened varchar2(2700);

begin

for c1rec in c1 loop

      if c1rec.dateofbirth is not null then
      /*
      update xwrl_requests
      set date_of_birth = c1rec.dateofbirth
      where id = c1rec.request_id;
      */
      end if;
      
      end loop;
      
      ----commit;
      
end;     
/


   SELECT   EXTRACT( YEAR FROM to_date('19240802','YYYYMMDD') )  FROM  DUAL;

   SELECT   LPAD(EXTRACT( MONTH FROM to_date('19240802','YYYYMMDD') ),2,0) FROM  DUAL;

   SELECT   LPAD(EXTRACT( DAY FROM to_date('19240802','YYYYMMDD') ),2,0)  FROM  DUAL;



SELECT            *

FROM               wc_city_list

--WHERE            COUNTRY_CODE = :COUNTRY_code

ORDER BY       sort_order

             , city_name
             ;

-- Office

select salesrep_id, code, description
from vssl_offices
where salesrep_id is not null
and enable = 'Y'
order by description;

-- Country

SELECT territory_short_name Country_Name

                         , description Country_Full_Name

              , territory_code TERRITORY_CODE

              , iso_territory_code ISO_TERRITORY_CODE

FROM   fnd_territories_vl

ORDER BY 1
;

-- city (UKRA, RUSS)

SELECT            city_name

                         , subdivision

                          , wc_city_list_id

FROM               wc_city_list

WHERE            COUNTRY_CODE = :COUNTRY_code

ORDER BY       sort_order

             , city_name
             ;

 declare
 cursor c1 is
 select *
 from xwrl_requests
 where priority is null;
 
 x_priority integer;
 
 begin
 x_priority := 3;
 
 for c1rec in c1 loop
 
   if c1rec.matches !=  0 then
       x_priority := 2;
       end if;
       /*
       update xwrl_requests
       set priority = x_priority
       where id = c1r.id;
 */
 end loop;
 
 ----commit;
 
 end;
 /
 
 
  declare
 cursor c1 is
 select *
 from xwrl_requests
 where risk_level is null;
 
 x_priority integer;
 
 begin
 x_priority := 1;
 
 for c1rec in c1 loop
 
   if c1rec.matches !=  0 then
       x_priority := 2;
       end if;
       
       update xwrl_requests
       set risk_level = x_priority
       where id = c1rec.id;
 
 end loop;
 
 --commit;
 
 end;
 /

select *
from all_tables
where table_name like upper('%iri_edocs%');

select *
from IRI_EDOCS_PARAMS;

select *
from iri_edocs_categories
order by document_type
;

select *
from all_tab_columns
where owner = 'VSSL'
and column_name = 'DOCUMENT_TYPE';

select *
from all_tab_columns
where owner = 'VSSL'
and column_name LIKE '%DEPT%';

SELECT *
FROM all_tables where table_NAME like 'INV%'
order by table_name;

select *
from INV_INCIDENTS
;

SELECT *
FROM REG11_WORLDCHECK_DOCUMENTS;

select unique document_type
from iri_edocs_categories
where document_type is not null
order by document_type
;


SELECT VALUE_STRING FROM XWRL_PARAMETERS WHERE ID = 'CASE_DEPARTMENTS' AND KEY  = 'CORP';


SELECT key, VALUE_STRING FROM XWRL_PARAMETERS WHERE ID = 'CASE_REJECTION';


select count (*)  from xwrl_requests;

select * from xwrl_requests
where id = 1040;

SELECT KEY, VALUE_STRING, SORT_ORDER FROM XWRL_PARAMETERS WHERE ID = 'CASE_STATE' ;
SELECT KEY, VALUE_STRING, SORT_ORDER FROM XWRL_PARAMETERS WHERE ID = 'CASE_STATUS' ;
SELECT KEY, VALUE_STRING, SORT_ORDER FROM XWRL_PARAMETERS WHERE ID = 'CASE_WORK_FLOW' ;
SELECT KEY, VALUE_STRING, SORT_ORDER FROM XWRL_PARAMETERS WHERE ID = 'CASE_PRIORITY' ;
SELECT KEY, VALUE_STRING, SORT_ORDER FROM XWRL_PARAMETERS WHERE ID = 'CASE_RISK' ;
SELECT KEY, VALUE_STRING, SORT_ORDER FROM XWRL_PARAMETERS WHERE ID = 'CASE_DEPARTMENTS' ;
SELECT KEY, VALUE_STRING, SORT_ORDER FROM XWRL_PARAMETERS WHERE ID = 'CASE_REJECTION' ;


select *
from OWS_STATUSBOARD_V;


SELECT XwrlRequests.ID, 
       XwrlRequests.RESUBMIT_ID, 
       XwrlRequests.SOURCE_TABLE, 
       XwrlRequests.SOURCE_ID, 
       XwrlRequests.WC_SCREENING_REQUEST_ID, 
       XwrlRequests.SERVER, 
       XwrlRequests.PATH, 
       XwrlRequests.SOAP_QUERY, 
       XwrlRequests.REQUEST, 
       XwrlRequests.RESPONSE, 
       XwrlRequests.JOB_ID, 
       XwrlRequests.MATCHES, 
       XwrlRequests.STATUS, 
       XwrlRequests.ERROR_CODE, 
       XwrlRequests.ERROR_MESSAGE, 
       XwrlRequests.LAST_UPDATE_DATE, 
       XwrlRequests.LAST_UPDATED_BY, 
       XwrlRequests.CREATION_DATE, 
       XwrlRequests.CREATED_BY, 
       XwrlRequests.LAST_UPDATE_LOGIN, 
       XwrlRequests.CASE_ID, 
       XwrlRequests.NAME_SCREENED, 
       XwrlRequests.DATE_OF_BIRTH, 
       XwrlRequests.IMO_NUMBER, 
       XwrlRequests.VESSEL_INDICATOR, 
       XwrlRequests.DEPARTMENT, 
       XwrlRequests.OFFICE, 
       XwrlRequests.CASE_STATE, 
       XwrlRequests.CASE_WORKFLOW, 
       XwrlRequests.CASE_STATUS, 
       XwrlRequests.REJECTION_REASON, 
       XwrlRequests.PRIORITY, 
       XwrlRequests.RISK_LEVEL, 
       XwrlRequests.DOCUMENT_TYPE, 
       XwrlRequests.CLOSED_DATE, 
       XwrlRequests.ASSIGNED_TO, 
       XwrlRequests.COUNTRY_OF_RESIDENCE, 
       XwrlRequests.CITY_OF_RESIDENCE, 
       XwrlRequests.SUBDIVISION_CITY_OF_RESIDENCE
FROM  XWRL_REQUESTS XwrlRequests
--where case_id = :case_number;
--where case_id is null
--where XwrlRequests.CREATED_BY = 9021
order by id desc
;

SELECT * FROM SICD_COUNTRIES WHERE COUNTRY_CODE LIKE 'RUS%';

SELECT * FROM SICD_COUNTRIES WHERE COUNTRY_CODE IN ('UKRA','RUSS');


SELECT *
FROM WC_CITY_LIST;

SELECT KEY AS OptionKey,VALUE_STRING AS OptionValue     
FROM XWRL_PARAMETERS     
WHERE ID = 'CASE_DOCUMENTS'  
ORDER BY SORT_ORDER ASC;

SELECT KEY AS OptionKey,VALUE_STRING AS OptionValue     
FROM XWRL_PARAMETERS     
WHERE ID = 'CASE_TYPE'  
ORDER BY SORT_ORDER ASC;

SELECT KEY AS OptionKey,VALUE_STRING AS OptionValue     
FROM XWRL_PARAMETERS     
WHERE ID = 'CASE_RESTRICTED_COUNTRIES'  
ORDER BY SORT_ORDER ASC;


with rs as (SELECT KEY ,VALUE_STRING AS restricted_country
FROM XWRL_PARAMETERS     
WHERE ID = 'CASE_RESTRICTED_COUNTRIES' )
SELECT w.wc_city_list_id
,w.city_name
,w.subdivision
,w.country_code
,w.status
,rs.restricted_country
FROM wc_city_list w
,rs
where w.country_code = rs.key
and w.status <> 'TC_OK'
order by w.country_code, w.city_name
;

SELECT *
FROM FND_USER
;

SELECT f.user_id
,f.user_name
,f.description
,f.email_address
FROM FND_USER f
where end_date is null
and description like ('%'|| :name ||'%')
;

 with assigned as (select  KEY as key ,VALUE_STRING AS restricted_country
FROM XWRL_PARAMETERS     
WHERE ID = 'CASE_ASSIGNMENT' )
SELECT f.user_id
,f.user_name
,f.description
,f.email_address
FROM FND_USER f
,assigned
where  f.user_id = assigned.key
and end_date is null
;


with rs as (SELECT KEY ,VALUE_STRING AS restricted_country    
FROM XWRL_PARAMETERS         
WHERE ID = 'CASE_RESTRICTED_COUNTRIES' )    
SELECT w.wc_city_list_id    
,w.city_name    
,w.subdivision    
,w.country_code    
,w.status    
,rs.restricted_country  restricted_country  
FROM wc_city_list w    
,rs    
where w.country_code = rs.key    
and w.status <> 'TC_OK'     
order by w.country_code, w.city_name
;

SELECT w.wc_city_list_id    
,w.city_name    
,w.subdivision    
,w.country_code    
,w.status    
,rs.restricted_country  restricted_country  
FROM wc_city_list w    
, (SELECT KEY ,VALUE_STRING AS restricted_country    
FROM XWRL_PARAMETERS         
WHERE ID = 'CASE_RESTRICTED_COUNTRIES' )    rs    
where w.country_code = rs.key    
and w.status <> 'TC_OK'     
order by w.country_code, w.city_name
;





select note 
from xwrl_note_templates 
where note_type = 'CLEAR' 
and note_category = 'INDIVIDUAL';

select note  
from xwrl_note_templates  
where note_type = 'CLEAR'  
and note_category = 'ENTITY';

select ID, KEY, VALUE_STRING
from xwrl_parameters
where id = 'TRADE_URL'
;

;

select *
from wc_screening_request
order by wc_screening_request_id desc
;




      SELECT
         wsr.wc_screening_request_id
         , wsr.name_screened
         , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
      FROM
         wc_screening_request   wsr
         , xwrl_requests          xr
      WHERE wsr.wc_screening_request_id = xr.wc_screening_request_id (+)
         AND wsr.entity_type = 'INDIVIDUAL'
         --AND wsr.wc_screening_request_id <= 792946 -- This value is based on lowest max id  from IRITEST based on instances  IRIPROD, IRITEST, IRIDEV and IRIDR 
         --Note: Organization is used because it has the most consistent result set across all DB instances
         AND trunc (wsr.creation_date) >= trunc((select max(x.creation_date) - 30 from wc_screening_request x where x.entity_type = 'ORGANISATION'))
         AND xr.wc_screening_request_id IS NULL
         AND ROWNUM <= v_rownum
         
         
         ;
         
         
declare

x_response integer;

begin

xwrl_ows_utils.test_db_link(x_response);
dbms_output.put_line('Response: '||x_response);

exception 
       when others then null;
       dbms_output.put_line ('Error: db_link_not_active'); 

end;
/

select count(*)
FROM
         wc_screening_request   wsr
         ,WORLDCHECK_EXTERNAL_XREF xref
         ,     ( SELECT
         max(wsr.wc_screening_request_id) wc_screening_request_id
         ,xref.source_table
         ,xref.source_table_id
      FROM
         wc_screening_request   wsr
         ,WORLDCHECK_EXTERNAL_XREF xref 
      WHERE  wsr.wc_screening_request_id = xref.wc_screening_request_id (+)      
      group by        xref.source_table
         ,xref.source_table_id) a
      WHERE  wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      and  wsr.wc_screening_request_id = a.wc_screening_request_id
         AND wsr.entity_type = 'INDIVIDUAL'
         --AND wsr.wc_screening_request_id <= 792946 -- This value is based on lowest max id  from IRITEST based on instances  IRIPROD, IRITEST, IRIDEV and IRIDR 
         --Note: Organization is used because it has the most consistent result set across all DB instances
        -- AND trunc (wsr.creation_date) >= trunc((select max(x.creation_date) - 30 from wc_screening_request x where x.entity_type = 'INDIVIDUAL'))
         and wsr.status <> 'Approved'
         and not exists (select 1 from xwrl_requests x   where x.wc_screening_request_id = wsr.wc_screening_request_id)
          --AND ROWNUM <= v_rownum
      ORDER BY
         1 DESC;


select count(*)
FROM
         wc_screening_request   wsr
         ,WORLDCHECK_EXTERNAL_XREF xref
         ,     ( SELECT
         max(wsr.wc_screening_request_id) wc_screening_request_id
         ,xref.source_table
         ,xref.source_table_id
      FROM
         wc_screening_request   wsr
         ,WORLDCHECK_EXTERNAL_XREF xref 
      WHERE  wsr.wc_screening_request_id = xref.wc_screening_request_id (+)      
      group by        xref.source_table
         ,xref.source_table_id) a
      WHERE  wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      and  wsr.wc_screening_request_id = a.wc_screening_request_id
         AND wsr.entity_type <> 'INDIVIDUAL'
         --AND wsr.wc_screening_request_id <= 792946 -- This value is based on lowest max id  from IRITEST based on instances  IRIPROD, IRITEST, IRIDEV and IRIDR 
         --Note: Organization is used because it has the most consistent result set across all DB instances
        -- AND trunc (wsr.creation_date) >= trunc((select max(x.creation_date) - 30 from wc_screening_request x where x.entity_type = 'INDIVIDUAL'))
         and wsr.status <> 'Approved'
         and not exists (select 1 from xwrl_requests x   where x.wc_screening_request_id = wsr.wc_screening_request_id)
          --AND ROWNUM <= v_rownum
      ORDER BY
         1 DESC;

      SELECT
         max(wsr.wc_screening_request_id) wc_screening_request_id
         ,xref.source_table
         ,xref.source_table_id
      FROM
         wc_screening_request   wsr
         ,WORLDCHECK_EXTERNAL_XREF xref
      WHERE  wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      group by        xref.source_table
         ,xref.source_table_id
         ;


SELECT COUNTRY_CODE, COUNTRY_NAME 
FROM SICD_COUNTRIES 
WHERE STATUS = 'Active';

select iso_alpha2_code country_code, country_name
from SICD_COUNTRIES
WHERE STATUS = 'Active'
and iso_alpha2_code is not null
order by country_name
;

select *
from fnd_user
;

SELECT f.user_id  
,f.user_name  
,nvl(f.description ,f.user_name)  description
,f.email_address  
,f.end_date
FROM FND_USER f  
order by f.description;

SELECT f.user_id  
,f.user_name  
,f.description  
,f.email_address  
,f.end_date
FROM FND_USER f  
where f.end_date is null
order by f.description
;


SELECT xwrl_utils.get_max_jobs FROM DUAL;

SELECT XwrlRequests.ID, 
       XwrlRequests.RESUBMIT_ID, 
       XwrlRequests.SOURCE_TABLE, 
       XwrlRequests.SOURCE_ID, 
       XwrlRequests.WC_SCREENING_REQUEST_ID, 
       XwrlRequests.SERVER, 
       XwrlRequests.JOB_ID, 
       XwrlRequests.STATUS, 
       XwrlRequests.ERROR_CODE, 
       XwrlRequests.ERROR_MESSAGE, 
       XwrlRequests.CASE_ID, 
       XwrlRequests.NAME_SCREENED, 
       XwrlRequests.DATE_OF_BIRTH, 
       XwrlRequests.IMO_NUMBER, 
       XwrlRequests.VESSEL_INDICATOR, 
       XwrlRequests.PATH, 
       XwrlRequests.CASE_STATE, 
       XwrlRequests.CASE_WORKFLOW, 
       XwrlRequests.CASE_STATUS, 
       XwrlRequests.PRIORITY, 
       XwrlRequests.RISK_LEVEL, 
       XwrlRequests.REJECTION_REASON, 
       XwrlRequests.MATCHES, 
       XwrlRequests.DEPARTMENT, 
       XwrlRequests.OFFICE, 
       XwrlRequests.DOCUMENT_TYPE, 
       XwrlRequests.ASSIGNED_TO, 
       XwrlRequests.COUNTRY_OF_RESIDENCE, 
       XwrlRequests.CITY_OF_RESIDENCE, 
       XwrlRequests.SUBDIVISION_CITY_OF_RESIDENCE, 
       XwrlRequests.CLOSED_DATE, 
       XwrlRequests.LAST_UPDATE_DATE, 
       XwrlRequests.LAST_UPDATED_BY, 
       XwrlRequests.CREATION_DATE, 
       XwrlRequests.CREATED_BY, 
       XwrlRequests.LAST_UPDATE_LOGIN
FROM  XWRL_REQUESTS XwrlRequests
where case_id is null
order by id desc;

SELECT f.user_id  
,f.user_name  
,f.description  
,f.email_address  
,f.end_date
FROM FND_USER f  
where f.end_date is null
order by f.description
;

SELECT count(*)
FROM FND_USER f  
where f.end_date is null
order by f.description
;

select *
from all_objects
where object_name = 'XWRL_REQUESTS';

SELECT XwrlRequests.ID, 
XwrlRequests.request,
XwrlRequests.response,
       XwrlRequests.RESUBMIT_ID, 
       XwrlRequests.SOURCE_TABLE, 
       XwrlRequests.SOURCE_ID, 
       XwrlRequests.WC_SCREENING_REQUEST_ID, 
       XwrlRequests.SERVER, 
       XwrlRequests.JOB_ID, 
       XwrlRequests.STATUS, 
       XwrlRequests.ERROR_CODE, 
       XwrlRequests.ERROR_MESSAGE, 
       XwrlRequests.CASE_ID, 
       XwrlRequests.NAME_SCREENED, 
       XwrlRequests.DATE_OF_BIRTH, 
       XwrlRequests.IMO_NUMBER, 
       XwrlRequests.VESSEL_INDICATOR, 
       XwrlRequests.PATH, 
       XwrlRequests.CASE_STATE, 
       XwrlRequests.CASE_WORKFLOW, 
       XwrlRequests.CASE_STATUS, 
       XwrlRequests.PRIORITY, 
       XwrlRequests.RISK_LEVEL, 
       XwrlRequests.REJECTION_REASON, 
       XwrlRequests.MATCHES, 
       XwrlRequests.DEPARTMENT, 
       XwrlRequests.OFFICE, 
       XwrlRequests.DOCUMENT_TYPE, 
       XwrlRequests.ASSIGNED_TO, 
       XwrlRequests.COUNTRY_OF_RESIDENCE, 
       XwrlRequests.CITY_OF_RESIDENCE, 
       XwrlRequests.SUBDIVISION_CITY_OF_RESIDENCE, 
       XwrlRequests.CLOSED_DATE, 
       XwrlRequests.LAST_UPDATE_DATE, 
       XwrlRequests.LAST_UPDATED_BY, 
       XwrlRequests.CREATION_DATE, 
       XwrlRequests.CREATED_BY, 
       XwrlRequests.LAST_UPDATE_LOGIN
       ,a.description created_by_attr
       ,b.description  LAST_UPDATED_BY_attr
FROM  XWRL_REQUESTS XwrlRequests
,(SELECT f.user_id  
,f.user_name  
,nvl(f.description ,f.user_name)  description 
,f.email_address  
,f.end_date
FROM FND_USER f  
where f.end_date is null
order by f.description) a
,(SELECT f.user_id  
,f.user_name  
,nvl(f.description ,f.user_name)  description 
,f.email_address  
,f.end_date
FROM FND_USER f  
where f.end_date is null
order by f.description) b
where  XwrlRequests.CREATED_BY = a.user_id
and  XwrlRequests.LAST_UPDATED_BY = b.user_id
and trunc(XwrlRequests.creation_date) = trunc(sysdate)
order by id desc;

select *
FROM  XWRL_REQUESTS
---where STATUS = 'RESUBMIT'
order by id desc;

select * from v$database;

select *
from xwrl_requests
--where case_id is null
--where name_screened = 'ARNEL ANTONIO DALO';
--where id = 2435;
order by id desc
;


SELECT COUNT(*) INTO v_risk_count FROM xwrl_response_ind_columns WHERE request_id = v_id  and listrecordtype = 'SAN';


      SELECT
         wsr.wc_screening_request_id
         , wsr.name_screened
         , wsr.entity_type
         , decode(wsr.entity_type,'VESSEL','Y',NULL) vessel_indicator
         ,wsr.created_by
         ,wsr.corp_residence_country_code
         ,wsr.city_name
         ,wsr.wc_city_list_id
         ,wsr.imo_number
         ,xref.source_table
         ,xref.source_table_id         
       FROM
         wc_screening_request   wsr
         ,WORLDCHECK_EXTERNAL_XREF xref
      WHERE  wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
         AND wsr.entity_type <> 'INDIVIDUAL';
         
      SELECT
         wsr.wc_screening_request_id
         , wsr.name_screened
         , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
         ,wsr.created_by
         ,wsr.sex
         ,wsr.passport_number
         ,wsr.passport_issuing_country_code
         ,wsr.citizenship_country_code
         ,wsr.residence_country_code
         ,wsr.city_name
         ,wsr.wc_city_list_id
         ,xref.source_table
         ,xref.source_table_id
      FROM
         wc_screening_request   wsr
         ,WORLDCHECK_EXTERNAL_XREF xref
      WHERE  wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
         AND wsr.entity_type = 'INDIVIDUAL'
         ;
         
         
     SELECT
wsr.*
       FROM
         wc_screening_request   wsr
         ,WORLDCHECK_EXTERNAL_XREF xref
         ,     ( SELECT
         max(wsr.wc_screening_request_id) wc_screening_request_id
         ,xref.source_table
         ,xref.source_table_id
      FROM
         wc_screening_request   wsr
         ,WORLDCHECK_EXTERNAL_XREF xref 
      WHERE  wsr.wc_screening_request_id = xref.wc_screening_request_id (+)      
      group by        xref.source_table
         ,xref.source_table_id) a
      WHERE  wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      and  wsr.wc_screening_request_id = a.wc_screening_request_id
        AND wsr.entity_type = 'ORGANISATION'
        and xref.source_tabLE = 'VSSL_VESSELS'
      --AND wsr.wc_screening_request_id <= 792946 -- This value is based on lowest max id  from IRITEST based on instances  IRIPROD, IRITEST, IRIDEV and IRIDR 
         --Note: Organization is used because it has the most consistent result set across all DB instances
         --AND trunc (wsr.creation_date) >= trunc((select max(x.creation_date) - 30 from wc_screening_request x where x.entity_type <> 'INDIVIDUAL'))         
         and wsr.status <> 'Approved'
         and not exists (select 1 from xwrl_requests x   where x.wc_screening_request_id = wsr.wc_screening_request_id);


SELECT UNIQUE ENTITY_TYPE FROM wc_screening_request;

SELECT
         max(wsr.wc_screening_request_id) wc_screening_request_id
         ,xref.source_table
         ,xref.source_table_id
      FROM
         wc_screening_request   wsr
         ,WORLDCHECK_EXTERNAL_XREF xref 
      WHERE  wsr.wc_screening_request_id = xref.wc_screening_request_id (+)      
      and xref.source_table = 'VSSL_VESSELS'
      group by        xref.source_table
         ,xref.source_table_id
         ;


select *
from xwrl_parameters
--where id like 'CASE%'
where id = 'CASE_ALERT_STATE'
order by id, decode(sort_order,null,value_string,sort_order)
;


select id, key, value_string
from xwrl_parameters
--where id like 'CASE%'
where id = 'CASE_ALERT_STATE'
order by sort_order
;

select *
from wc_screening_request
where name_screened = 'WAN HAI LI'
;


select *
from WORLDCHECK_EXTERNAL_XREF
where wc_screening_request_id = 474129
;

select *
from vssl_vessels
where former_name =  'WAN HAI LI'
--where vessel_pk = 15379
;

select unique source_table_column
from WORLDCHECK_EXTERNAL_XREF
where source_table = 'VSSL_VESSELS'
;

      SELECT
         wsr.wc_screening_request_id
         , wsr.name_screened
         , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
         ,wsr.created_by
         ,wsr.sex
         ,wsr.passport_number
         ,wsr.passport_issuing_country_code
         ,wsr.citizenship_country_code
         ,wsr.residence_country_code
         ,wsr.city_name
         ,wsr.wc_city_list_id
         ,wsr.alias_wc_screening_request_id
         ,wsr.last_updated_by
      FROM
         wc_screening_request   wsr
      WHERE  wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
         AND wsr.entity_type = 'INDIVIDUAL'
         AND wsr.alias_wc_screening_request_id IS NULL
         --AND wsr.wc_screening_request_id <= 792946 -- This value is based on lowest max id  from IRITEST based on instances  IRIPROD, IRITEST, IRIDEV and IRIDR 
         --Note: Organization is used because it has the most consistent result set across all DB instances
        -- AND trunc (wsr.creation_date) >= trunc((select max(x.creation_date) - 30 from wc_screening_request x where x.entity_type = 'INDIVIDUAL'))
        and wsr.status IN ('Provisional','Legal Review','Pending','Sr. Legal Review')
         and not exists (select 1 from xwrl_requests x   where x.wc_screening_request_id = wsr.wc_screening_request_id);
         
     SELECT
         wsr.wc_screening_request_id
         , wsr.name_screened
         , wsr.entity_type
         , decode(wsr.entity_type,'VESSEL','Y',NULL) vessel_indicator
         ,wsr.created_by
         ,wsr.corp_residence_country_code
         ,wsr.city_name
         ,wsr.wc_city_list_id
         ,wsr.alias_wc_screening_request_id
         ,wsr.last_updated_by
       FROM
         wc_screening_request   wsr
      where wsr.entity_type = 'ORGANISATION'
         AND wsr.alias_wc_screening_request_id IS NULL
      --AND wsr.wc_screening_request_id <= 792946 -- This value is based on lowest max id  from IRITEST based on instances  IRIPROD, IRITEST, IRIDEV and IRIDR 
         --Note: Organization is used because it has the most consistent result set across all DB instances
         --AND trunc (wsr.creation_date) >= trunc((select max(x.creation_date) - 30 from wc_screening_request x where x.entity_type <> 'INDIVIDUAL'))         
         and wsr.status IN ('Provisional','Legal Review','Pending','Sr. Legal Review')
         and not exists (select 1 from xwrl_requests x   where x.wc_screening_request_id = wsr.wc_screening_request_id)
         ;
         
         select *
         from wc_screening_request
         where wc_screening_request_id = 6689;
         
         select *
         from          WORLDCHECK_EXTERNAL_XREF
         where wc_screening_request_id = 6689
         ;
         
         select *
         from corp_main
         where corp_id = 1059670;
         
         
         select *
         from wc_content
         ;
         
         
SELECT
         wsr.wc_screening_request_id
         , wsr.name_screened
         , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
         ,wsr.created_by
         ,wsr.sex
         ,wsr.passport_number
         ,wsr.passport_issuing_country_code
         ,wsr.citizenship_country_code
         ,wsr.residence_country_code
         ,wsr.city_name
         ,wsr.wc_city_list_id
         ,wsr.alias_wc_screening_request_id
         ,wsr.last_updated_by
      FROM
         wc_screening_request   wsr
         ,WORLDCHECK_EXTERNAL_XREF a
      WHERE wsr.wc_screening_request_id = a.wc_screening_request_id (+)
      and wsr.entity_type = 'INDIVIDUAL'
         AND wsr.alias_wc_screening_request_id IS NULL
         --AND wsr.wc_screening_request_id <= 792946 -- This value is based on lowest max id  from IRITEST based on instances  IRIPROD, IRITEST, IRIDEV and IRIDR 
         --Note: Organization is used because it has the most consistent result set across all DB instances
        -- AND trunc (wsr.creation_date) >= trunc((select max(x.creation_date) - 30 from wc_screening_request x where x.entity_type = 'INDIVIDUAL'))
        and wsr.status IN ('Provisional','Legal Review','Pending','Sr. Legal Review')
         and not exists (select 1 from xwrl_requests x   where x.wc_screening_request_id = wsr.wc_screening_request_id)
          --AND ROWNUM <= v_rownum
      ORDER BY
         1 DESC;         
         
         select *
         from wc_screening_request
         where alias_wc_screening_request_id IS NULL
         and wc_screening_request_id = 909563;
         
         select *
         from WORLDCHECK_EXTERNAL_XREF
         where wc_screening_request_id = 909563;
         
         
         select x.wc_screening_request_id, x.source_table, x.source_table_id
         from WORLDCHECK_EXTERNAL_XREF x
         group by x.wc_screening_request_id, x.source_table, x.source_table_id
         having count(*) = 1;
       
       
         SELECT
         count(*)
      FROM
         wc_screening_request   wsr
      WHERE   wsr.entity_type = 'INDIVIDUAL'
         AND wsr.alias_wc_screening_request_id IS NULL
         --AND wsr.wc_screening_request_id <= 792946 -- This value is based on lowest max id  from IRITEST based on instances  IRIPROD, IRITEST, IRIDEV and IRIDR 
         --Note: Organization is used because it has the most consistent result set across all DB instances
        -- AND trunc (wsr.creation_date) >= trunc((select max(x.creation_date) - 30 from wc_screening_request x where x.entity_type = 'INDIVIDUAL'))
        and wsr.status IN ('Provisional','Legal Review','Pending','Sr. Legal Review')
         and not exists (select 1 from xwrl_requests x   where x.wc_screening_request_id = wsr.wc_screening_request_id)      ;
         
         
         SELECT
         count(*)
      FROM
         wc_screening_request   wsr
         ,(select x.wc_screening_request_id, x.source_table, x.source_table_id
         from WORLDCHECK_EXTERNAL_XREF x
         group by x.wc_screening_request_id, x.source_table, x.source_table_id
         having count(*) = 1) xref
      WHERE  wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
         AND wsr.entity_type = 'INDIVIDUAL'
         AND wsr.alias_wc_screening_request_id IS NULL
         --AND wsr.wc_screening_request_id <= 792946 -- This value is based on lowest max id  from IRITEST based on instances  IRIPROD, IRITEST, IRIDEV and IRIDR 
         --Note: Organization is used because it has the most consistent result set across all DB instances
        -- AND trunc (wsr.creation_date) >= trunc((select max(x.creation_date) - 30 from wc_screening_request x where x.entity_type = 'INDIVIDUAL'))
        and wsr.status IN ('Provisional','Legal Review','Pending','Sr. Legal Review')
         and not exists (select 1 from xwrl_requests x   where x.wc_screening_request_id = wsr.wc_screening_request_id)         
         ;
         
         
         select    wc_screening_request_id
               , wc_matches_id
               , wc_content_id
               , source_table
               , source_id
         from xwrl_alert_clearing_xref
         group by wc_screening_request_id
               , wc_matches_id
               , wc_content_id
               , source_table
               , source_id;
               
SELECT
      c.wc_screening_request_id
      , c.wc_matches_id
      , c.wc_content_id
   --, c.matchentityidentifier
   --, c.matchstatus
   --, x.worldcheck_external_xref_id
      , x.source_table
      , x.source_table_column
      , x.source_table_id
      , substr (c.matchentityidentifier, instr (c.matchentityidentifier, '_', - 1) + 1, length (c.matchentityidentifier)) listid
      , c.notes
   FROM
      wc_content                 c
      , worldcheck_external_xref   x
   WHERE
      c.wc_screening_request_id = x.wc_screening_request_id
   --AND c.wc_screening_request_id = nvl (:wc_screening_request_id, c.wc_screening_request_id)
      AND c.matchstatus = 'NEGATIVE'
      and not exists (  select    ref.wc_screening_request_id
               ,ref. wc_matches_id
               , ref.wc_content_id
               , ref.source_table
               , ref.source_id
         from xwrl_alert_clearing_xref ref
         where rwc_screening_request_id =  c.wc_screening_request_id 
         and ref. wc_matches_id =c.wc_matches_id 
          and ref.wc_content_id = c.wc_content_id
          and ref.source_table = x.source_table
      and ref.source_id = x.source_table_id
         group by wc_screening_request_id
               , wc_matches_id
               , wc_content_id
               , source_table
               , source_id)
   ORDER BY
      c.wc_content_id DESC;               


select *
from all_objects
where object_name like 'XWRL\_%' ESCAPE '\'
AND OBJECT_TYPE NOT IN ('SYNONYM','PACKAGE','PACKAGE BODY')
AND OWNER = 'APPS';               

select *
from xwrl_requests 
--where status  = 'ERROR'
--WHERE case_state = 'E'
order by id desc
;

select name
from v$database;

select count(*)
from xwrl_requests;

select id
from xwrl_requests 
WHERE CASE_ID IS NULL
;


SELECT XwrlRequests.ID, 
       XwrlRequests.RESUBMIT_ID, 
       XwrlRequests.SOURCE_TABLE, 
       XwrlRequests.SOURCE_ID, 
       XwrlRequests.WC_SCREENING_REQUEST_ID, 
       XwrlRequests.SERVER, 
       XwrlRequests.PATH, 
       XwrlRequests.JOB_ID, 
       XwrlRequests.MATCHES, 
       XwrlRequests.Request,
       XwrlRequests.Response,       
       XwrlRequests.STATUS, 
       XwrlRequests.ERROR_CODE, 
       XwrlRequests.ERROR_MESSAGE, 
       XwrlRequests.LAST_UPDATE_DATE, 
       XwrlRequests.LAST_UPDATED_BY, 
       XwrlRequests.CREATION_DATE, 
       XwrlRequests.CREATED_BY, 
       XwrlRequests.LAST_UPDATE_LOGIN, 
       XwrlRequests.CASE_ID, 
       XwrlRequests.NAME_SCREENED, 
       XwrlRequests.DATE_OF_BIRTH, 
       XwrlRequests.IMO_NUMBER, 
       XwrlRequests.VESSEL_INDICATOR, 
       XwrlRequests.DEPARTMENT, 
       XwrlRequests.OFFICE, 
       XwrlRequests.CASE_STATE, 
       XwrlRequests.CASE_WORKFLOW, 
       XwrlRequests.CASE_STATUS, 
       XwrlRequests.REJECTION_REASON, 
       XwrlRequests.PRIORITY, 
       XwrlRequests.RISK_LEVEL, 
       XwrlRequests.DOCUMENT_TYPE, 
       XwrlRequests.CLOSED_DATE, 
       XwrlRequests.ASSIGNED_TO, 
       XwrlRequests.COUNTRY_OF_RESIDENCE, 
       XwrlRequests.CITY_OF_RESIDENCE, 
       XwrlRequests.SUBDIVISION_CITY_OF_RESIDENCE
FROM  XWRL_REQUESTS XwrlRequests
--where id = :case_number
--where case_id is null
--where XwrlRequests.CREATED_BY = 9021
--order by id desc
--WHERE server = 'IRIPRODOWS-SEC'
where status = 'RESUBMIT'
;



update xwrl_requests
set status = 'ERROR'
WHERE server = 'IRIPRODOWS-SEC'
;


update xwrl_requests
set server = 'IRIPRODOWS-PRI'
where status = 'ERROR';

update xwrl_requests
set server = 'IRIPRODOWS-PRI'
where status = 'RESUBMIT';

select * from xwrl_response_ind_columns;

select * from xwrl_requests where case_id = 'OWS-201910-301725-474CC7-ENT';

select * from xwrl_response_entity_columns where casekey = 'OWS-201910-301725-474CC7-ENT';

DECLARE
    p_user            VARCHAR2(200);
    p_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
    x_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;
    x_status          VARCHAR2(200);
BEGIN
    p_user := 'TSUAZO';

  -- 1st record
    p_alert_in_tbl(1).alert_id  := 'SEN-9596561';  -- Note: The first 3 char must match the LISTRECORDTYPE of the alert record  
    p_alert_in_tbl(1).to_state := 'EDD - False Positive';  -- Note: The first 3 char must match the LISTRECORDTYPE of the alert record  
    p_alert_in_tbl(1).comment := 'Close Alert';
    xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com ( p_user => p_user,p_alert_in_tbl => p_alert_in_tbl,x_alert_out_tbl => x_alert_out_tbl
,x_status => x_status );

    FOR j IN x_alert_out_tbl.first..x_alert_out_tbl.last LOOP
        dbms_output.put_line('ALert ID: '
                               || x_alert_out_tbl(j).alert_id
                               || ' New State: '
                               || x_alert_out_tbl(j).new_state
                               || ' status: '
                               || x_alert_out_tbl(j).status
                               || ' err_msg: '
                               || x_alert_out_tbl(j).err_msg
                               || ' Overall status: '
                               || x_status);
    END LOOP;

    --commit;
END;
/

with primary as (
      SELECT  unique
         wsr.wc_screening_request_id
         , wsr.name_screened
         ,wsr.entity_type
         , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
         ,wsr.sex
         ,wsr.passport_number
         ,wsr.passport_issuing_country_code
         ,wsr.citizenship_country_code
         ,wsr.residence_country_code
         ,wsr.city_name
         ,wsr.wc_city_list_id
         ,wsr.alias_wc_screening_request_id
                  ,wsr.created_by
         ,wsr.last_updated_by
      FROM         wc_screening_request   wsr
      WHERE wsr.entity_type = 'INDIVIDUAL')
, alias as (
      SELECT unique
         wsr.wc_screening_request_id
         , wsr.name_screened
         ,wsr.entity_type
         , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
         ,wsr.sex
         ,wsr.passport_number
         ,wsr.passport_issuing_country_code
         ,wsr.citizenship_country_code
         ,wsr.residence_country_code
         ,wsr.city_name
         ,wsr.wc_city_list_id
         ,wsr.alias_wc_screening_request_id
                  ,wsr.created_by
         ,wsr.last_updated_by
      FROM         wc_screening_request   wsr
      WHERE wsr.entity_type = 'INDIVIDUAL')      
select *
from primary
,alias
where primary.wc_screening_request_id = alias.alias_wc_screening_request_id
order by primary.name_screened, primary.wc_screening_request_id desc
;

select *
from sicd_countries
;

select id         
,relationship_type
, parent_id
         , entity_type
         , status
         , source_table
         , source_table_column
         , source_id
         , full_name
         , date_of_birth
         ,sex
         , passport_number
         , passport_issuing_country_code
         , citizenship_country_code
         , country_of_residence
         , city_of_residence_id
         , created_by
         , creation_date
         , last_updated_by
         , last_update_date
from xwrl_party_alias 
;


select count(*)
from xwrl_party_alias
;


SELECT KEY AS OptionKey,VALUE_STRING AS OptionValue      
FROM XWRL_PARAMETERS      
WHERE ID = 'CASE_RESTRICTED_COUNTRIES'   
ORDER BY SORT_ORDER ASC;


SELECT KEY AS OptionKey,VALUE_STRING AS OptionValue      
FROM XWRL_PARAMETERS      
WHERE ID = 'CASE_RESTRICTIONS' ;

SELECT KEY AS OptionKey,VALUE_STRING AS OptionValue      
FROM XWRL_PARAMETERS      
WHERE ID = 'CASE_DEPARTMENTS' ;


SELECT KEY AS OptionKey,VALUE_STRING AS OptionValue      
FROM XWRL_PARAMETERS      
WHERE ID = 'CASE_STATE'
order by sort_order
;


SELECT KEY AS OptionKey,VALUE_STRING AS OptionValue      
FROM XWRL_PARAMETERS      
WHERE ID = 'CASE_WORK_FLOW'
order by sort_order
;


select count(*)
from (
   SELECT
      c.wc_screening_request_id
      , c.wc_matches_id
      , c.wc_content_id
   --, c.matchentityidentifier
   --, c.matchstatus
   --, x.worldcheck_external_xref_id
      , x.source_table
      , x.source_table_column
      , x.source_table_id
      , substr (c.matchentityidentifier, instr (c.matchentityidentifier, '_', - 1) + 1, length (c.matchentityidentifier)) listid
      , c.notes
   FROM
      wc_content                 c
      , worldcheck_external_xref   x
   WHERE
      c.wc_screening_request_id = x.wc_screening_request_id
   --AND c.wc_screening_request_id = nvl (:wc_screening_request_id, c.wc_screening_request_id)
      AND c.matchstatus = 'NEGATIVE'
);               


SELECT count(*)
   FROM
      wc_screening_request wsr
   WHERE
      wsr.entity_type = 'INDIVIDUAL'
      and wsr.alias_wc_screening_request_id is null
      ;

select count(*)
from (
  SELECT 
      wsr.wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
      , wsr.sex
      , wsr.passport_number
      , wsr.passport_issuing_country_code
      , wsr.citizenship_country_code
      , wsr.residence_country_code
      , wsr.city_name
      , wsr.wc_city_list_id
      , wsr.alias_wc_screening_request_id
      , wsr.created_by
      , wsr.creation_date
      , wsr.last_updated_by
      , wsr.last_update_date
   FROM
      wc_screening_request wsr
);
      
SELECT 
      wsr.wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
      , wsr.sex
      , wsr.passport_number
      , wsr.passport_issuing_country_code
      , wsr.citizenship_country_code
      , wsr.residence_country_code
      , wsr.city_name
      , wsr.wc_city_list_id
      , wsr.alias_wc_screening_request_id
      , wsr.created_by
      , wsr.creation_date
      , wsr.last_updated_by
      , wsr.last_update_date
   FROM
      wc_screening_request wsr
      order by wsr.wc_screening_request_id desc;


SELECT 
      wsr.wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
      , wsr.sex
      , wsr.passport_number
      , wsr.passport_issuing_country_code
      , wsr.citizenship_country_code
      , wsr.residence_country_code
      , wsr.city_name
      , wsr.wc_city_list_id
      , wsr.alias_wc_screening_request_id
      , wsr.created_by
      , wsr.creation_date
      , wsr.last_updated_by
      , wsr.last_update_date
   FROM
      wc_screening_request wsr      
      where wc_screening_request_id < 400000
      --and name_screened LIKE ('%KUMAR%')
      order by wc_screening_request_id desc
      ;

select xref.wc_screening_request_id, xref.source_table, xref.source_table_column, xref.source_table_id      , xref.created_by
      , xref.creation_date
      , xref.last_updated_by
      , xref.last_update_date
from worldcheck_external_xref xref
where xref.wc_screening_request_id = :request_id;      

select *
from worldcheck_external_xref xref
where xref.wc_screening_request_id = :request_id;      
      
SELECT
      c.wc_screening_request_id
      , c.wc_matches_id
      , c.wc_content_id
      , substr (c.matchentityidentifier, instr (c.matchentityidentifier, '_', - 1) + 1, length (c.matchentityidentifier)) listid
      , c.notes
      ,c.created_by
      ,c.creation_date
      ,c.last_updated_by
      ,c.last_update_date
   FROM
      wc_content  c
      where c.notes is not null
      and c.wc_screening_request_id = :request_id;
      
SELECT *
FROM
      wc_content  c
      where c.notes is not null
      and c.wc_screening_request_id = :request_id;      

select count(*) from xwrl_alert_clearing_xref_2019;

create table xwrl_alert_clearing_xref_2019 as (select * from xwrl_alert_clearing_xref where case_key is not null);

select count(*) from xwrl_alert_clearing_xref where case_key is not null;

select * from xwrl_alert_clearing_xref where case_key is not null;

select count(*) 
from xwrl_alert_clearing_xref;


select *
from xwrl_alert_clearing_xref;

with xref as (select unique wc_screening_request_id from xwrl_alert_clearing_xref)
   SELECT UNIQUE
      wsr.wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
      , wsr.sex
      , wsr.passport_number
      , wsr.passport_issuing_country_code
      , wsr.citizenship_country_code
      , wsr.residence_country_code
      , wsr.city_name
      , wsr.wc_city_list_id
      , wsr.alias_wc_screening_request_id
      , wsr.created_by
      , wsr.creation_date
      , wsr.last_updated_by
      , wsr.last_update_date
   FROM
      wc_screening_request wsr
      ,xref
      where wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      and xref.wc_screening_request_id is null
      --where rownum < 100
;



select count(*) from xwrl_alert_clearing_xref;

SELECT * FROM xwrl_party_alias;

 with xref as (select unique source_id  wc_screening_request_id from xwrl_party_alias where source_table = 'WC_SCREENING_REQUEST')
   SELECT UNIQUE
      wsr.wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
      , wsr.sex
      , wsr.passport_number
      , wsr.passport_issuing_country_code
      , wsr.citizenship_country_code
      , wsr.residence_country_code
      , wsr.city_name
      , wsr.wc_city_list_id
      , wsr.alias_wc_screening_request_id
      , wsr.created_by
      , wsr.creation_date
      , wsr.last_updated_by
      , wsr.last_update_date
   FROM
      wc_screening_request wsr
      ,XREF
   WHERE wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      and xref.wc_screening_request_id is null
      AND wsr.entity_type = 'INDIVIDUAL'      
      and wsr.alias_wc_screening_request_id is null;
      
      
   with xref as (select unique wc_screening_request_id from xwrl_requests)
   SELECT  UNIQUE
      wsr.wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
      , wsr.sex
      , wsr.passport_number
      , wsr.passport_issuing_country_code
      , wsr.citizenship_country_code
      , wsr.residence_country_code
      , wsr.city_name
      , wsr.wc_city_list_id
      , wsr.alias_wc_screening_request_id
      , wsr.created_by
      , wsr.creation_date
      , wsr.last_updated_by
      , wsr.last_update_date
   FROM
      wc_screening_request wsr
      ,xref
      where wsr.wc_screening_request_id = xref.wc_screening_request_id (+)      
      and xref.wc_screening_request_id is null
      AND wsr.entity_type = 'INDIVIDUAL'
      and (wsr.status IN ('Provisional','Legal Review','Pending','Sr. Legal Review')      
      or wsr. status = 'Approved'
         and trunc(status_date) > trunc(sysdate) - 2)
      order by 1 desc
      ;
      
select * from wc_screening_request      
where  status = 'Approved'
and trunc(status_date) > trunc(sysdate) - 2
;

select extents 
  from dba_segments 
  where owner='XWRL' 
  and segment_name='XWRL_PARTY_ALIAS' ;
 
 SELECT nvl(ses.username,'ORACLE PROC')||' ('||ses.sid||')' USERNAME,
       SID,   
       MACHINE, 
       REPLACE(SQL.SQL_TEXT,CHR(10),'') STMT, 
      ltrim(to_char(floor(SES.LAST_CALL_ET/3600), '09')) || ':'
       || ltrim(to_char(floor(mod(SES.LAST_CALL_ET, 3600)/60), '09')) || ':'
       || ltrim(to_char(mod(SES.LAST_CALL_ET, 60), '09'))    RUNT 
  FROM V$SESSION SES,   
       V$SQLtext_with_newlines SQL 
 where SES.STATUS = 'ACTIVE'
   and SES.USERNAME is not null
   and SES.SQL_ADDRESS    = SQL.ADDRESS 
   and SES.SQL_HASH_VALUE = SQL.HASH_VALUE 
   and Ses.AUDSID <> userenv('SESSIONID') 
 order by runt desc, 1,sql.piece;
 
 select x.sid
      ,x.serial#
      ,x.username
      ,x.sql_id
      ,x.sql_child_number
      ,optimizer_mode
      ,hash_value
      ,address
      ,sql_text
from   v$sqlarea sqlarea
      ,v$session x
where  x.sql_hash_value = sqlarea.hash_value
and    x.sql_address    = sqlarea.address
and    x.username       is not null;
 
 --truncate table xwrl.xwrl_party_alias;

select * from xwrl.xwrl_party_alias
order by id;

select count(*) from xwrl.xwrl_party_alias;
      
 --truncate table xwrl.xwrl_alert_clearing_xref  ;

select * from xwrl_alert_clearing_xref;

select count(*) from xwrl_alert_clearing_xref;


      
with xref as (select unique wc_screening_request_id from xwrl_requests)
   SELECT  UNIQUE
         wsr.wc_screening_request_id
         , wsr.name_screened
         , wsr.entity_type
         , decode(wsr.entity_type,'VESSEL','Y',NULL) vessel_indicator        
         ,wsr.corp_residence_country_code
         ,wsr.city_name
         ,wsr.wc_city_list_id
         ,wsr.imo_number
         ,wsr.alias_wc_screening_request_id
          ,wsr.created_by
         ,wsr.last_updated_by
   FROM
      wc_screening_request wsr
      ,xref
      where wsr.wc_screening_request_id = xref.wc_screening_request_id (+)      
      and xref.wc_screening_request_id is null
      AND wsr.entity_type <> 'INDIVIDUAL'
      and (wsr.status IN ('Provisional','Legal Review','Pending','Sr. Legal Review')      
      or wsr. status = 'Approved'
         and trunc(status_date) > trunc(sysdate) - 2)
      order by 1 desc      ;


select * from corp_main
order by corp_id desc;
      
select length('relationship_master_id') from dual;      
      
select * from WC_SCREENING_REQUEST;
select * from WORLDCHECK_EXTERNAL_XREF;  
select * from xwrl_party_xref order by id desc;

select *
from WORLDCHECK_EXTERNAL_XREF xref
,WC_SCREENING_REQUEST req
where xref.wc_screening_request_id = req.wc_screening_request_id
and req.alias_wc_screening_request_id is null
;


select *
from WC_SCREENING_REQUEST
where entity_type = 'ORGANISATION'
order by 1 desc
;

select *
from WC_SCREENING_REQUEST
where wc_screening_request_id = :p_request_id
;

select *
from WC_SCREENING_REQUEST
where alias_wc_screening_request_id = :p_request_id
;

select *
from WORLDCHECK_EXTERNAL_XREF
where wc_screening_request_id = :p_request_id
;

select *
from REG11_HEADER
where REG11_HEADER_ID = 14054;


select *
from all_source
where lower( text ) like ('%world_check_iface.create_xref_tree_table%');
;


select * 
from WC_SCREENING_REQUEST req
where REQ.entity_type <> 'INDIVIDUAL';

select req.*
from WORLDCHECK_EXTERNAL_XREF xref
,WC_SCREENING_REQUEST req
where xref.wc_screening_request_id = req.wc_screening_request_id
and req.alias_wc_screening_request_id is null
and xref.source_table = 'CORP_MAIN'
order by req.wc_screening_request_id desc
;

select req.wc_screening_request_id, req.name_screened, x.count
from WC_SCREENING_REQUEST req
,(select xref.wc_screening_request_id, count(*) count
  from WORLDCHECK_EXTERNAL_XREF xref
  group by xref.wc_screening_request_id
  having count(*) > 5) x
  where req.wc_screening_request_id = x.wc_screening_request_id
  and req.entity_type = 'INDIVIDUAL'
  order by 1 desc
  ;


/* Entity Alias */

select req.wc_screening_request_id, req.name_screened, x.count
from WC_SCREENING_REQUEST req
,(select xref.wc_screening_request_id, count(*) count
  from WORLDCHECK_EXTERNAL_XREF xref
  group by xref.wc_screening_request_id
  having count(*) > 5) x
  where req.wc_screening_request_id = x.wc_screening_request_id
  and req.entity_type = 'ORGANISATION'
  order by 1 desc
  ;

select *
from WC_SCREENING_REQUEST req
where req.wc_screening_request_id = :p_request_id;

select *
from WC_SCREENING_REQUEST req
where req.alias_wc_screening_request_id = :p_request_id;

select *
from WORLDCHECK_EXTERNAL_XREF xref
where xref.wc_screening_request_id = :p_request_id;

select xref.wc_screening_request_id, c.corp_name1,c.corp_number, c.corp_id
from WORLDCHECK_EXTERNAL_XREF xref
,corp_main c
where xref.wc_screening_request_id = :p_request_id
and xref.source_table = 'CORP_MAIN'
and c.corp_id = xref.source_table_id
;

select *
from corp_main
where corp_id = 1058203;

declare

v_xref_tree_rec WORLD_CHECK_IFACE.xref_tree_tab;

begin

world_check_iface.create_xref_tree_table (:p_request_id,  v_xref_tree_rec) ;

for i in 1..v_xref_tree_rec.count loop

      dbms_output.put_line('WC_SCREENING_REQUEST_ID: '||v_xref_tree_rec(i).WC_SCREENING_REQUEST_ID);
      dbms_output.put_line('NAME_SCREENED: '||v_xref_tree_rec(i).NAME_SCREENED);
      dbms_output.put_line('MATCH_SCORE: '||v_xref_tree_rec(i).MATCH_SCORE);
      dbms_output.put_line('NODE_ID: '||v_xref_tree_rec(i).NODE_ID);
      dbms_output.put_line('PARENT_NODE_ID: '||v_xref_tree_rec(i).PARENT_NODE_ID);
      dbms_output.put_line('REFERENCE_DESCRIPTION: '||v_xref_tree_rec(i).REFERENCE_DESCRIPTION);
      dbms_output.put_line('WORLDCHECK_EXTERNAL_XREF_ID: '||v_xref_tree_rec(i).WORLDCHECK_EXTERNAL_XREF_ID);

end loop;

end;
/

select *
from WC_SCREENING_REQUEST
where wc_screening_request_id = 900131;

select *
from WORLDCHECK_EXTERNAL_XREF
where wc_screening_request_id = 900131;
--where WORLDCHECK_EXTERNAL_XREF_ID = 1056050
;

select *
from xwrl_requests
where path = 'ENTITY'
and vessel_indicator = 'Y'
order by priority, risk_level desc
;

      SELECT
         col.id
         , col.request_id
--         , r.source_table
--         , r.source_id
         , col.listid
         , col.alertid
         ,col.listrecordtype
         , col.x_state
         , col.listrecordtype||' - False Positive' to_state
         --,clear.to_state
         --, clear.note
      FROM
         xwrl_response_entity_columns   col
         WHERE REQUEST_ID = :P_REQUEST_ID
         ;


      SELECT
         col.id
         , col.request_id
         , r.source_table
         , r.source_id
         , col.listid
         , col.alertid
         ,col.listrecordtype
         , col.x_state
         , col.listrecordtype||' - False Positive' to_state
         --,clear.to_state
         , clear.note
      FROM
         xwrl_response_entity_columns   col
         , xwrl_requests                  r
         , (
            WITH max_tab AS (
               SELECT
                  x.source_table
                  , x.source_id
                  , x.list_id
                  , MAX (id) id
               FROM
                  xwrl_alert_clearing_xref x
               GROUP BY
                  x.source_table
                  , x.source_id
                  , x.list_id
            )
            SELECT
               x.source_table
               , x.source_id
               , x.list_id
               , x.to_state
               , x.note
            FROM
               xwrl_alert_clearing_xref x
               , max_tab
            WHERE
               x.source_table = max_tab.source_table
               AND x.source_id = max_tab.source_id
               AND x.id = max_tab.id
         ) clear
      WHERE
         col.request_id = r.id
         AND r.source_table = clear.source_table
         AND r.source_id = clear.source_id
         AND col.listid = clear.list_id
         AND col.request_id = :p_request_id;
         
         
         
select *
from xwrl_party_alias;

select *
from all_objects
where owner = 'APPS'
and object_name like '%XWRL\_%' escape '\'
and object_type = 'SYNONYM'
;

select *
from all_indexes
where LOWER(table_name) = 'xwrl_alert_clearing_xref'
;

select *
from all_objects
where owner = 'APPS'
and object_name like '%XWRL\_%' escape '\'
and object_type not in ('SYNONYM','PACKAGE','PACKAGE BODY')
;
select 'drop trigger '||object_name||';'
from all_objects
where owner = 'APPS'
and object_name like '%XWRL\_%' escape '\'
and object_type = 'TRIGGER'
--and object_type not in ('SYNONYM','PACKAGE','PACKAGE BODY')
;


select *
from all_tables
where owner = 'XWRL'
;

select 'alter table xwrl.'||table_name||' nologging;'
from all_tables
where owner = 'XWRL'
;

select 'alter table xwrl.'||table_name||' logging;'
from all_tables
where owner = 'XWRL'
;

select TABLE_NAME, logging
from all_tables
where owner = 'XWRL'
;

SELECT O.OBJECT_NAME, S.SID, S.SERIAL#, P.SPID, S.PROGRAM,S.USERNAME,
S.MACHINE,S.PORT , S.LOGON_TIME,SQ.SQL_FULLTEXT 
FROM V$LOCKED_OBJECT L, DBA_OBJECTS O, V$SESSION S, 
V$PROCESS P, V$SQL SQ 
WHERE L.OBJECT_ID = O.OBJECT_ID 
AND L.SESSION_ID = S.SID AND S.PADDR = P.ADDR 
AND S.SQL_ADDRESS = SQ.ADDRESS;

alter system kill session '1889,7552';

/*

drop index xwrl_party_master_idx1;
drop INDEX xwrl_party_master_idx2;


truncate table xwrl_party_xref;
truncate table xwrl_party_alias;
alter table    xwrl_party_alias DISABLE constraint    xwrl_party_alias_fk1;
truncate table xwrl_party_master;


alter table    xwrl_party_alias enABLE constraint    xwrl_party_alias_fk1;
*/

   with xref as (select unique wc_screening_request_id from xwrl_party_alias)
   SELECT count(*)
   FROM
      wc_screening_request wsr
      ,XREF
   WHERE wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      and wsr.alias_wc_screening_request_id is null
      and xref.wc_screening_request_id is null
      AND wsr.entity_type = 'INDIVIDUAL'      
      ORDER BY 1 DESC
      ;
select count(*)
from (
    with xref as (select unique wc_screening_request_id from xwrl_party_alias)
   SELECT UNIQUE
      wsr.wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
      , wsr.sex
      , wsr.passport_number
      , wsr.passport_issuing_country_code
      , wsr.citizenship_country_code
      , wsr.residence_country_code
      , wsr.city_name
      , wsr.wc_city_list_id
      , wsr.alias_wc_screening_request_id
      , wsr.created_by
      , wsr.creation_date
      , wsr.last_updated_by
      , wsr.last_update_date
   FROM
      wc_screening_request wsr
      ,XREF
   WHERE wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      and wsr.alias_wc_screening_request_id is null
      and xref.wc_screening_request_id is null
      AND wsr.entity_type = 'INDIVIDUAL'      )
      --ORDER BY 1 DESC
      ;


   SELECT  UNIQUE
         wsr.wc_screening_request_id
         , wsr.name_screened
         , wsr.entity_type
         , decode(wsr.entity_type,'VESSEL','Y',NULL) vessel_indicator        
         ,wsr.corp_residence_country_code
         ,wsr.city_name
         ,wsr.wc_city_list_id
         ,wsr.imo_number
         ,wsr.alias_wc_screening_request_id
          ,wsr.created_by
         ,wsr.last_updated_by
   FROM
      wc_screening_request wsr
   WHERE wsr.alias_wc_screening_request_id is not null
      and wsr.entity_type  <> 'INDIVIDUAL' 
      --AND wsr.alias_wc_screening_request_id = p_request_id
      
      
      ;
      
      select *
      from wc_screening_request
;
      select count(*)
      from xwrl_party_master;
      
      select * from xwrl_party_master
     -- where full_name = 'MALCOLM NICKERSON'
     order by 1 desc
      ;
      
      select count(*)
      from (
      SELECT max( wsr.wc_screening_request_id)  wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
   FROM
      wc_screening_request wsr
   WHERE wsr.alias_wc_screening_request_id is null
      AND wsr.entity_type = 'INDIVIDUAL'      
      group by wsr.name_screened
      , wsr.entity_type
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') )
      --order by name_screened, wc_screening_request_id desc
      ;
      
      
      
      
      
select count(*)
from (
      SELECT UNIQUE       
       wsr.name_screened
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD')  date_of_birth
      FROM wc_screening_request wsr
      where wsr.entity_type = 'INDIVIDUAL'
      )
      ;
      
select count(*)
from (
      SELECT UNIQUE       
       wsr.name_screened
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD')  date_of_birth
      FROM wc_screening_request wsr
      where wsr.entity_type = 'INDIVIDUAL'
      AND WSR.date_of_birth is null
      )
      ;      
      
      
      Source Table = XWRL_PARTY_MASTER

Source Table Column = ID

Source ID = 810039


select *
from xwrl_party_alias
where ID = 768060;
-- PRASHANTKUMAR BARIA

select *
from xwrl_party_alias
where ID = 768060;

select *
from xwrl_party_master
where id = 1001482
;


select *
from xwrl_party_master
where id = :p_id;

select *
from xwrl_party_alias
where master_id  = :p_id;

select id, master_id, relationship_type, entity_type, status, source_table, source_id, full_name
, family_name, given_name, date_of_birth, sex, creation_date, created_by, last_updated_by, last_update_date, wc_screening_request_id, state
from xwrl_party_alias
where full_name = 'PRASHANTKUMAR BARIA';

select id, full_name
from xwrl_party_master
where id = 639603;


select count(*)
from xwrl_party_alias alias
,xwrl_party_master master
where alias.master_id = master.id (+)
and master.id is null
;


declare
cursor c1 is select alias.id
from xwrl_party_alias alias
,xwrl_party_master master
where alias.master_id = master.id (+)
and master.id is null
;

begin

for c1rec in c1 loop

delete from xwrl_party_alias where id = c1rec.id;
--commit;

end loop;

end;
/

select *
from xwrl_requests
;

select *
from wc_screening_request
where entity_type <> 'INDIVIDUAL'
order by 1 desc
;

select wsr.wc_screening_request_id, wsr.status, wsr.name_screened, wsr.entity_type, wsr.alias_wc_screening_request_id
,wsrx.wc_screening_request_id, wsrx.status, wsrx.name_screened, wsrx.entity_type, wsrx.alias_wc_screening_request_id
from wc_screening_request wsr
,wc_screening_request wsrx
where  wsr.wc_screening_request_id = wsrx.alias_wc_screening_request_id
and wsr.entity_type <> 'INDIVIDUAL'
and wsrx.entity_type = 'INDIVIDUAL'
order by 1 desc
;

select wsr.wc_screening_request_id, wsr.status, wsr.name_screened, wsr.entity_type, wsr.alias_wc_screening_request_id
,wsrx.wc_screening_request_id, wsrx.status, wsrx.name_screened, wsrx.entity_type, wsrx.alias_wc_screening_request_id
from wc_screening_request wsr
,wc_screening_request wsrx
where  wsr.wc_screening_request_id = wsrx.alias_wc_screening_request_id
and wsr.entity_type = 'INDIVIDUAL'
and wsrx.entity_type <> 'INDIVIDUAL'
order by 1 desc
;

select wsr.wc_screening_request_id, wsr.status, wsr.name_screened, wsr.entity_type, wsr.alias_wc_screening_request_id
,xref.source_table, xref.source_table_column, xref.source_table_id
,cm.corp_name1
,cm.corp_number
from wc_screening_request wsr
,WORLDCHECK_EXTERNAL_XREF xref
,corp_main cm
where  wsr.wc_screening_request_id = xref.wc_screening_request_id
and xref.source_table_id = cm.corp_id
and wsr.entity_type = 'INDIVIDUAL'
--and xref.source_table <> 'SICD_SEAFARERS'
and xref.source_table = 'CORP_MAIN'
and xref.source_table_id is not null
and cm.corp_number = 'R9517'
order by xref.source_table_id desc
;

select *
from wc_screening_request
where name_screened = 'ALEKSANDRA BOGDANOVIC' -- Primary Name
;

select *
from WORLDCHECK_EXTERNAL_XREF
where wc_screening_request_id  = '912328'
;


-- R9517

select *
from WORLDCHECK_EXTERNAL_XREF
order by 1 desc;



select * 
from xwrl_response_ind_columns
where request_id = 14528 
order by request_id, matchscore desc;

select *
from dba_tablespaces
;


select USERNAME, DEFAULT_TABLESPACE, TEMPORARY_TABLESPACE
from DBA_USERS
 where USERNAME='XWRL';
 
 select *
from all_tables
where owner = 'XWRL'
;

SELECT *
FROM all_indexes
where owner = 'XWRL'
--and uniqueness = 'UNIQUE'
--and  index_name not like '%PK'
--and  index_name like '%UK'
--and tablespace_name = 'APPS_TS_TX_DATA'
--and tablespace_name = 'APPS_TS_TX_IDX'
order by table_name, index_name
;

select 'drop index '||index_name||';'
FROM all_indexes
where owner = 'XWRL'
and  index_name not like '%PK'
order by table_name, index_name
;

select *
from XWRL_PARTY_MASTER;

drop index XWRL_ALERT_CLEARING_XREF_IDX1;

exec fnd_stats.gather_table_stats('SCHEMA_NAME','Table_Name',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');

select 'exec fnd_stats.gather_table_stats('||chr(39)||owner||chr(39)||','||chr(39)||table_name||chr(39)||',100,NULL,NULL,'||chr(39)||'NOBACKUP'||chr(39)||',TRUE,'||chr(39)||'DEFAULT'||chr(39)||');'
from all_tables
where owner = 'XWRL'
order by table_name
;

select *
from wc_screening_request
where wc_screening_request_id = 17561;

select * 
from WORLDCHECK_EXTERNAL_XREF
where wc_screening_request_id = 17561;

select * from WORLDCHECK_EXTERNAL_XREF
WHERE CREATION_DATE >= TRUNC(TO_DATE('01-NOV-2019','DD-MON-YYYY'));
ORDER BY 1 DESC;


select source_table, source_table_column, source_table_id, count(*)
from WORLDCHECK_EXTERNAL_XREF
group by source_table, source_table_column, source_table_id
;

select count(*)
from (select source_table, source_table_column, source_table_id, count(*)
from WORLDCHECK_EXTERNAL_XREF
group by source_table, source_table_column, source_table_id)
;

select count(*)
from (select xref.source_table,xref. source_table_column,xref. source_table_id, max(xref.wc_screening_request_id)
from WORLDCHECK_EXTERNAL_XREF xref
group by xref.source_table,xref. source_table_column,xref. source_table_id
)
;

select *
from wc_screening_request
where wc_screening_request_id = :p_request;

select *
from  WORLDCHECK_EXTERNAL_XREF xref
where wc_screening_request_id = :p_request
order by 1 desc;

select *
from NRMI_CERTIFICATES
where NRMI_CERTIFICATES_ID = 12539;

select *
from NRMI_VESSELS
where NRMI_VESSELS_ID = 2152;

/*
VESSEL	Migrated	Enabled	REG11_HEADER	REG11_HEADER_ID	9952
ORGANISATION	Migrated	Enabled	REG11_HEADER	REG11_HEADER_ID	9952
*/

select unique entity_type, source_table, source_table_column
from xwrl_party_master
where source_table = 'REG11_HEADER'
and source_table_column = 'REG11_HEADER_ID'
;

select *
from xwrl_party_master
where source_table = 'REG11_HEADER'
and source_table_column = 'REG11_HEADER_ID'
--and source_id = 9952
;

select * 
from REG11_HEADER
where REG11_HEADER_ID = 9952;



select relationship_type, entity_type, source_table, source_table_column, source_id,  full_name
from xwrl_party_master
where source_table = 'REG11_HEADER'
and source_table_column = 'REG11_HEADER_ID'
and source_id = 9952;

select reg11_header_id, imo_number, vessel_pk, vessel_uk, current_name, reg_name, registered_owner_name
from REG11_HEADER
where REG11_HEADER_ID = 9952;


select mst.relationship_type, mst.entity_type, mst.source_table, mst.source_table_column, mst.source_id,  mst.full_name
from xwrl_party_master mst
where mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'CORP_MAIN'
and source_table_column = 'CORP_ID'
and source_id = 1056128;
;

select mst.relationship_type, mst.entity_type, mst.source_table, mst.source_table_column, mst.source_id,  mst.full_name
from xwrl_party_master mst
where mst.entity_type = 'ORGANISATION'
and mst.source_table = 'CORP_MAIN'
and source_table_column = 'CORP_ID'
and source_id = 1056128;

select mst.relationship_type, mst.entity_type
, mst.source_table, mst.source_table_column, mst.source_id
, mst.full_name, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id) target_column_data
from xwrl_party_master mst
where  entity_type = 'ORGANISATION'
and source_table = 'CORP_MAIN'
and source_table_column = 'CORP_ID'
and source_id = 1056128;

xwrl_data_processing.verify_master_fullname

select *
from xwrl_party_master mst
where  entity_type = 'ORGANISATION'
and source_table = 'CORP_MAIN'
and source_table_column = 'CORP_ID'
and source_id = 1056128;



select *
from corp_main 
where corp_id = 1056128
;

select *
from wc_screening_request 
where wc_screening_request_id in (622041,6689)
;

select  *
from WORLDCHECK_EXTERNAL_XREF
where wc_screening_request_id in (622041,6689)

;


select count(*)
from xwrl_party_master
where entity_type = 'ORGANISATION'
;

select count(*)
from xwrl_party_master
where entity_type = 'ORGANISATION'
AND source_table = 'CORP_MAIN';

select id, state, status, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.entity_type
,mst.state
,mst.status
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id) target_full_name
from xwrl_party_master mst
where  entity_type = 'ORGANISATION'
and source_table = 'CORP_MAIN'
and source_table_column = 'CORP_ID'
and  mst.source_id = 1097402
)
--where full_name = target_full_name
--and state <> 'Verified'
where full_name <> target_full_name

;

select count(*)
from (select id, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id) target_full_name
from xwrl_party_master mst
where  entity_type = 'ORGANISATION'
and source_table = 'CORP_MAIN'
and source_table_column = 'CORP_ID')
where full_name <> target_full_name)
;

select count(*)
from (select id, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id) target_full_name
from xwrl_party_master mst
where  entity_type = 'ORGANISATION'
and source_table = 'CORP_MAIN'
and source_table_column = 'CORP_ID')
where full_name = target_full_name)
and state <> 'Verified'
;

select *
from xwrl_party_master
where state = 'Verified'
order by id desc
;

select *
from xwrl_party_master
where state <> 'Verified'
and source_table = 'SICD_SEAFARERS'
order by id desc
;

select *
from corp_main
where corp_id = :p_corp_id --90595
;
select count(*)
from xwrl_party_master 
where state <> 'Verified'
order by id desc;

/* Data Cleanup */

/* NOTE Use to move Alias records in XWRL_PARTY_MASTER to XWRL_MASTER_ALIAS 
    Find the verified master record
    Copy the Migrated record to Alias
    mark the older records to Delete Alias
*/

select entity_type, source_table, source_table_column, source_id, full_name, count(*)
from xwrl_party_master 
where state = 'Migrated'
group by  entity_type, source_table, source_table_column, source_id, full_name
having count(*) > 1
order by 1, 2
;

/* NOTE Use to delete duplicate records in XWRL_PARTY_MASTER to XWRL_MASTER_ALIAS 
     Find the newest master record,
     mark the older records to Delete Duplicate

*/

select entity_type, source_table, source_table_column, source_id, count(*)
from xwrl_party_master 
where state = 'Verified'
group by entity_type, source_table, source_table_column, source_id
having count(*) > 1
order by 1, 2
;

select entity_type, state, source_table, source_table_column, source_id, count(*)
from xwrl_party_master 
where state = 'Verified'
group by entity_type, state, source_table, source_table_column, source_id
having count(*) > 1
order by 1, 2
;

select *
from xwrl_party_master
--where note is not null
;

select *
from xwrl_party_master
where entity_type = 'INDIVIDUAL'
and source_table = 'AR_CUSTOMERS'
and source_table_column = 'CUSTOMER_ID'
and source_id = 1371
--where note is not null
;

update xwrl_party_master
set state = 'Migrated'
,note = null
where state = 'Delete - Standalone';




select * from xwrl_party_master 
where state = 'Verified'
and source_table = 'VSSL_VESSELS'
--AND entity_type = 'VESSEL'
order by id desc;

select * from xwrl_party_master 
where source_table = 'REG11_HEADER'
--and entity_type <> 'INDIVIDUAL'
--and state = 'Verified'
and state <> 'Verified'
--AND entity_type = 'VESSEL'
--and source_id = :p_source_id
order by id desc;

select * from xwrl_party_master 
where source_table = 'REG11_HEADER'
--and entity_type <> 'INDIVIDUAL'
--and state = 'Verified'
and state <> 'Verified'
--AND entity_type = 'VESSEL'
and source_id = :p_source_id
order by id desc;

select *
from xwrl_party_master
where source_table = :p_source_table
and state < > 'Verified'
;

select *
from REG11_HEADER	
where REG11_HEADER_ID = :p_source_id
;

-- ANGELOS ECONOMOU
-- VERGOTIS GEORGE

/* Statistics */

select entity_type,  state, count(*) row_count
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
group by entity_type,  state
order by entity_type, state desc
;


select entity_type, source_table, source_table_column,  state, count(*) row_count
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
--and state = 'Migrated'
group by entity_type, source_table, source_table_column, state
order by  source_table, source_table_column, state desc
;

select source_table, source_table_column, source_target_column, state, count(*) row_count
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
group by source_table, source_table_column, source_target_column, state
order by  source_table, source_table_column, state desc
;

select entity_type,source_table, source_table_column, source_target_column, state, count(*) row_count
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
group by entity_type,source_table, source_table_column, source_target_column, state
order by entity_type, source_table, source_table_column, state desc
;



select source_table, source_table_column, source_target_column, state, count(*) row_count
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
and state = 'Migrated'
group by source_table, source_table_column, source_target_column, state
order by  source_table, source_table_column, state desc
;

select entity_type, source_table, source_table_column,  state, count(*) row_count
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
and state = 'Migrated'
group by entity_type, source_table, source_table_column, state
order by  source_table, source_table_column, state desc
;

select *
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
and source_table_column = NVL(:p_source_table_column,source_table_column)
--and source_id = 1112202
and state = 'Migrated'
order by id desc
;

select *
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
and source_table_column = NVL(:p_source_table_column,source_table_column)
--and source_id = 1112202
and entity_type = 'INDIVIDUAL'
and state = 'Migrated'
order by id desc
;



select *
from xwrl_party_master
where xref_source_table is not null;


WITH MST AS (select FULL_NAME, SOURCE_TABLE, SOURCE_TABLE_COLUMN, SOURCE_ID, CORP_ID, CORP_NUMBER, CORP_NAME1
from xwrl_party_master
,CORP_MAIN
where source_table = NVL(:p_source_table,source_table)
and source_table_column = NVL(:p_source_table_column,source_table_column)
and source_id = 2147
AND CORP_ID = SOURCE_ID
and entity_type = 'INDIVIDUAL'
and state = 'Migrated'
)
SELECT AR.CONTACT_ID, AR.CUSTOMER_ID, AR.FIRST_NAME, AR.LAST_NAME, AR.JOB_TITLE, MST.FULL_NAME, MST.SOURCE_TABLE, MST.SOURCE_TABLE_COLUMN, MST.SOURCE_ID, MST.CORP_ID, MST.CORP_NUMBER, CORP_NAME1, AC.CUSTOMER_ID, AC.CUSTOMER_NUMBER, AC.CUSTOMER_NAME
FROM AR_CONTACTS_V AR
,AR_CUSTOMERS AC
,MST
WHERE AR.CUSTOMER_ID = AC.CUSTOMER_ID  
AND LTRIM(AR.FIRST_NAME||' '||AR.LAST_NAME) = MST.FULL_NAME
;

select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, customer_id, customer_name
--, contact_id
--, full_name2
--, job_title
, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
,ar.customer_id
,ar.customer_name
--,acv.CONTACT_ID
--,LTRIM(FIRST_NAME||' '||LAST_NAME) FULL_NAME2
--, JOB_TITLE
--, xwrl_data_processing.verify_master_fullname('AR_CONTACTS_V', 'CONTACT_ID', acv.CONTACT_ID) target_full_name
, xwrl_data_processing.verify_master_fullname('AR_CUSTOMERS', 'CUSTOMER_ID', AR.CUSTOMER_ID) target_full_name
from xwrl_party_master mst
,CORP_MAIN CM
,CORP_ACTIVITY CA
,AR_CUSTOMERS ar
--,AR_CONTACTS_V acv
where  mst.source_id  = CM.CORP_ID
and CM.CORP_ID =  CA.MAIN_CORP_ID 
and CA.agt_agt_id   = ar.customer_id
--and ar.customer_id = acv.customer_id
--and acv.contact_id is not null
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'CORP_MAIN'
and mst.source_table_column = 'CORP_ID'
and mst.source_id = 2147
)
--where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
--and state <> 'Verified'  
--where state <> 'Verified'  
;

update xwrl_party_master
set state = 'Migrated'
where state like 'Delete%'
;

-- current_agent 40396525   Qaulified Intermediary
-- customer_id 41573685 Billing Agent



select *
from corp_main
;

SELECT *
FROM CORP_AGENTS
WHERE MAIN_CORP_ID = 1068926  --- CONTACT_ID 310482
;


SELECT * 
FROM AR_CONTACTS_V 
WHERE CONTACT_ID = 310482
;


SELECT *
FROM CORP_ACTIVITY
WHERE MAIN_CORP_ID = 2147 
;

-- agt_agt_id


SELECT *
FROM CORP_MAIN
WHERE CORP_ID = 2147   --  YANG CHUNDI
;



-- CUSTOMER_ID 40512684
-- CURRENT_AGENT 40512684

SELECT *
FROM AR_CUSTOMERS
WHERE CUSTOMER_ID = 40393076     -- 98049-CORP  SP ATHENS SCHIFFFAHRTS GMBH & CO. KG
;


-- current_agent 40396525   Qaulified Intermediary
-- customer_id 41573685 Billing Agent


SELECT * 
FROM AR_CONTACTS_V
WHERE CUSTOMER_ID = 41571032   -- FALK HOLTMANN
--WHERE CONTACT_ID = 1149994
;

SELECT * 
FROM AR_CONTACTS_V
WHERE LAST_NAME = 'YANG'
AND FIRST_NAME  = 'CHUNDI'
;

SELECT CONTACT_ID, CUSTOMER_ID, ADDRESS_ID, LTRIM(FIRST_NAME||' '||LAST_NAME) FULL_NAME, JOB_TITLE
FROM AR_CONTACTS_V
WHERE CONTACT_ID = 1149994
;


SELECT UNIQUE JOB_TITLE
FROM AR_CONTACTS_V
ORDER BY 1
;

SELECT *
FROM AR_CUSTOMERS;


select *
from xwrl_party_master
where source_table = 'NRMI_VESSELS_vssl'
and source_id = :p_source_id
;

select *
from nrmi_vessels
where NRMI_VESSELS_ID = :p_source_id
;

-- VESSEL_NAME
-- REGISTERED_OWNER_NAME
-- ADDRESS_REG_OWN

select *
from NRMI_VESSELS
;

-- NRMI_VESSELS_vssl
-- NRMI_VESSELS_reg_own

select *
from NRMI_KNOWN_PARTIES
;

select *
from vssl.NRMI_VESSELS_KNOWN_PARTY;

-- KP_NAME




select * from NRMI_VESSELS_reg_own;

-- RQ_NAME
-- BT_CUSTOMER_NAME

select *
from NRMI_CERTIFICATES
;

-- NRMI_CERTIFICATES_bt
-- NRMI_CERTIFICATES_rq


select beneficial_owner_name
from REG11_HEADER	
where beneficial_owner_name is not null
 and REGEXP_LIKE (trim(both from beneficial_owner_name), '[^A-Za-z]')
;

select beneficial_owner_name
from REG11_HEADER	
where beneficial_owner_name is not null
--where beneficial_owner_name = 'PAPADAKIS ADONIOS'
--and REGEXP_LIKE (trim(both from beneficial_owner_name), '[^A-Za-z]')
and translate( beneficial_owner_name, chr(0) || 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,- ', chr(0) ) is not null
order by 1
;

select *
from VSSL_BENEFICIAL_OWNER
;

select *
from VSSL_BENEFICIAL_OWNER_IFACE
;

select level-1 as asc_code, decode(chr(level-1), regexp_substr(chr(level-1), '[[:print:]]'), CHR(level-1)) as chr,
           decode(chr(level-1), regexp_substr(chr(level-1), '[[:graph:]]'), 1) is_graph,
           decode(chr(level-1), regexp_substr(chr(level-1), '[[:blank:]]'), 1) is_blank,
           decode(chr(level-1), regexp_substr(chr(level-1), '[[:alnum:]]'), 1) is_alnum,
           decode(chr(level-1), regexp_substr(chr(level-1), '[[:alpha:]]'), 1) is_alpha,
           decode(chr(level-1), regexp_substr(chr(level-1), '[[:digit:]]'), 1) is_digit,
           decode(chr(level-1), regexp_substr(chr(level-1), '[[:cntrl:]]'), 1) is_cntrl,
           decode(chr(level-1), regexp_substr(chr(level-1), '[[:lower:]]'), 1) is_lower,
           decode(chr(level-1), regexp_substr(chr(level-1), '[[:upper:]]'), 1) is_upper,
          decode(chr(level-1), regexp_substr(chr(level-1), '[[:print:]]'), 1) is_print,
          decode(chr(level-1), regexp_substr(chr(level-1), '[[:punct:]]'), 1) is_punct,
          decode(chr(level-1), regexp_substr(chr(level-1), '[[:space:]]'), 1) is_space,
          decode(chr(level-1), regexp_substr(chr(level-1), '[[:xdigit:]]'), 1) is_xdigit
     from dual
   connect by level <= 256
 ;

select *
from REG11_HEADER	
where REG11_HEADER_ID = :p_source_id
;
-- ORGANISATION
-- REGISTERED_OWNER_NAME
-- BENEFICIAL_OWNER_NAME
-- ISM_MANAGER

-- DIONI SHIP MANAGEMENT LTD

CURRENT_NAME
REG_NAME
REGISTERED_OWNER_NAME
BENEFICIAL_OWNER_NAME

JIA YUE	
GH SEABISCUIT	
GH SEABISCUIT LLC


select *
from reg11_header
where reg11_header_id = 7919
;

select *
from vssl_vessels
where vessel_pk = :p_vessel_pk
;


select entity_type, count(*)
from xwrl_party_master
group by entity_type
;

--  AR_CUSTOMERS	CUSTOMER_ID	41698593


select *
from xwrl_party_master
where source_table = 'AR_CUSTOMERS'
and source_table_column = 'CUSTOMER_ID'
and source_id = 41812250;

select * 
from ar_customers
where customer_id = 41698593;


-- SICD_SEAFARERS	SEAFARER_ID	814912    ARJUN BHIM SINGH VERMA

select *
from xwrl_party_master
where source_table = 'SICD_SEAFARERS'
and source_table_column = 'SEAFARER_ID'
and source_id = 814912;

SELECT ltrim(first_name||' '||last_name)
FROM SICD_SEAFARERS
WHERE SEAFARER_ID = 814912;

select 'ltrim(first_name'||CHR(39)||' '||CHR(39)||'last_name)'
from dual;

/*
update xwrl_party_master
set state = 'Migrated'
;

update xwrl_party_master
set state = 'Migrated'
WHERE SOURCE_TABLE = 'REG11_HEADER'
*/


select *
from xwrl_parameters
where id = 'CASE_ALERT_STATE_UI'
;

select *
from xwrl_requests
where id = 	7967;

select * 
from xwrl_party_master
where relationship_type = 'Primary'
and entity_type = 'ORGANISATION'
and state = 'Verified'
order by source_table, source_table_column
;

select * 
from xwrl_party_master
where relationship_type = 'Standalone'
and state in ( 'Verified','Migrated')
order by source_table, source_table_column;

select *
from xwrl_party_xref;


select *
from xwrl_party_master
where id = 1659899;

select *
from xwrl_party_master
where id = 1740442;

select xref.state, xref.status,xref.start_date, xref.end_date
,a.*
,b.*
from xwrl_party_xref xref
,(select id, relationship_type, entity_type, state, status, source_table, source_table_column, source_id, full_name
from xwrl_party_master) a
,(select id, relationship_type, entity_type, state, status, source_table, source_table_column, source_id, full_name
from xwrl_party_master) b
where xref.master_id = a.id
and xref.relationship_master_id = b.id
;

select count(*)
from xwrl_party_master
;

-- OWS-201911-071115-A547D1-IND
-- 11419

select * from xwrl_requests where case_id = :p_case_id;

select * from xwrl_request_ind_columns where request_id = :p_request_id;


select *
      from v$sql v
      --where sql_id = :p_sql_id
      where upper(sql_text) like upper('%insert into xwrl_party_xref%')
      ;
      
select *
from v$sqltext_with_newlines
 --where upper(sql_text) like upper('%insert into xwrl_party_xref%')
 where sql_id = :p_sql_id
;

/*
acyds7nsww02n
4hp7n0h2nnhkt
71pzqr0ayd9jy
dnkq73by4tty9
3vrd0khfr5v0p  -- this one
6yarcm4a4qzyd
2bq8qharnrajp
*/

select *
from v$sqltext_with_newlines
where sql_id = :p_sql_id
order by piece
/
      
--INSERT INTO XWRL_PARTY_XREF ( MASTER_ID , RELATIONSHIP_MASTER_ID , STATE , STATUS , START_DATE , CREATED_BY , CREATION_DATE , LAST_UPDATED_BY , LAST_UPDATE_DATE ) VALUES ( :B6 ,:B5 , 'Migrated' , 'Enabled' , :B3 , :B4 , :B3 , :B2 , :B1 )      

select unique entity_type
from xwrl_party_master;

select *
from xwrl_party_master;

select *
from xwrl_party_alias;

select *
from xwrl.XWRL_PARTY_XREf
order by id desc
;

select count(*)
from xwrl.XWRL_PARTY_XREf
order by id desc
;

select relationship_type, count(*)
from XWRL_PARTY_XREf
group by relationship_type;

            SELECT
               COUNT (*)
            --INTO v_rec_count
            FROM
               xwrl_party_xref mst
            WHERE
               mst.master_id = 1
               AND mst.relationship_master_id = 1;
               
               
select *
from xwrl_parameters
--where id = 'CASE_RESTRICTIONS'
;


select id, key, value_string
from xwrl_parameters
where id in  ('TRADE_URL','STATUSBOARD_URL')
ORDER BY 1, 2
;
               
select key, value_string, sort_order
from xwrl_parameters
where id = 'RESPONSE_ROWS'
order by sort_order
;

/*

update xwrl_parameters
set display_flag = 'Y'
,sort_order = 185
where id = 'RESPONSE_ROWS'
and key = 'Category';

update xwrl_party_master
set start_date = creation_date;

update xwrl_party_alias
set start_date = creation_date;

update xwrl_parameters
set value_string = 'https://iriadf-dr.register-iri.com/TradeCompliance/faces/Statusboard'
where id = 'TRADE_URL';

*/

-- 1017
-- 18731
/*
alter  trigger XWRL.XWRL_REQUESTS_INS_UPD disable;

update xwrl_response_rows
set display = 'Y'
,sort_id = 185
where label = 'Category'
;

commit;

alter  trigger XWRL.XWRL_REQUESTS_INS_UPD enable;
*/

            SELECT w.subdivision        
              --INTO l_subdivision
              FROM apps.wc_city_list w       
                 ,(SELECT iso_alpha2_code
                          ,country_code
                          ,country_name AS restricted_country       
                      FROM apps.sicd_countries
                  ) rs       
            WHERE w.country_code  = rs.COUNTRY_CODE  
              AND w.status        <> 'TC_OK'
              AND wc_city_list_id = NVL(:p_city_of_residence,:p_city_of_residence_id);

select * from wc_city_list;

SELECT iso_alpha2_code
                          ,country_code
                          ,country_name AS restricted_country       
                      FROM sicd_countries;

select *
from dba_tab_privs
where grantee = 'XWRL'
and owner = 'APPS'
ORDER BY TABLE_NAME

;

SELECT *
FROM ALL_TABLES
WHERE TABLE_NAME = 'WC_CITY_LIST';

select id, batch_id, name_screened,country_of_nationality
from xwrl_requests
where batch_id = 900;


 SELECT w.subdivision        
              FROM apps.wc_city_lisT W;
              
              
              SELECT *
              FROM  xwrl.xwrl_requests;
              
              
              
select table_name, logging
from all_tables
where owner = 'XWRL';


select *
from xwrl_party_master
where source_table = 'VSSL_CONTACTS_V'
;


select * 
from xwrl_parameters 
where id = 'RESPONSE_ROWS'
order by SORT_ORDER;


select * 
from xwrl_parameters 
where id = 'RESPONSE_ROWS'
AND display_flag = 'Y'
order by SORT_ORDER;

select * 
from xwrl_parameters 
where id = 'RESPONSE_ROWS'
and value_string like '%Count%'
order by SORT_ORDER;


select * 
from xwrl_parameters 
where id = 'RESPONSE_ROWS'
--AND display_flag = 'N'
order by SORT_ORDER
--order by key
;


select id, key, value_string, sort_order
from xwrl_parameters 
where id = 'RESPONSE_ROWS'
AND display_flag = 'Y'
order by SORT_ORDER
;
--order by key
;


   SELECT
      xref.source_table
      , xref.source_table_column
      , xref.source_table_id
   FROM
      worldcheck_external_xref xref
   --WHERE      ROWNUM < 1000
   GROUP BY
      xref.source_table
      , xref.source_table_column
      , xref.source_table_id;
      
 WITH xref AS (
      SELECT UNIQUE
         wc_screening_request_id
      FROM
         xwrl_party_alias
   )
   SELECT
      wsr.wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
      , wsr.sex
      , wsr.passport_number
      , wsr.passport_issuing_country_code
      , wsr.citizenship_country_code
      , wsr.residence_country_code
      , wsr.city_name
      , wsr.wc_city_list_id
      , wsr.alias_wc_screening_request_id
      , wsr.created_by
      , wsr.creation_date
      , wsr.last_updated_by
      , wsr.last_update_date
      ,extxref.source_table
      , extxref.source_table_column
       ,extxref.source_table_id
   FROM
      wc_screening_request       wsr
      , worldcheck_external_xref   extxref
      , xref
   WHERE
      wsr.wc_screening_request_id = extxref.wc_screening_request_id
      AND wsr.entity_type = 'INDIVIDUAL'
      -- AND extxref.source_table = p_source_table
      -- AND extxref.source_table_column = p_source_table_column
      -- AND extxref.source_table_id = p_source_table_id
      -- AND wsr.alias_wc_screening_request_id  =  p_request_id -- Get Alias
      AND wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      AND xref.wc_screening_request_id IS NULL;
 
 select count(*)
 from
 (select a.unique_key, b.unique_key, source_table, source_table_column, source_table_id
from 
(
     SELECT   extxref.source_table||extxref.source_table_column||extxref.source_table_id unique_key, extxref.source_table, extxref.source_table_column,extxref.source_table_id
      FROM   worldcheck_external_xref extxref
      GROUP BY extxref.source_table||extxref.source_table_column||extxref.source_table_id,  extxref.source_table, extxref.source_table_column,extxref.source_table_id
      ) a
      ,(
      SELECT    mst.source_table||mst.source_table_column||mst.source_id unique_key
      FROM xwrl_party_master mst
      GROUP BY mst.source_table||mst.source_table_column||mst.source_id
      )   b
where a.unique_key = b.unique_key (+)
and b.unique_key is null)
;
   
select a.unique_key, b.unique_key, source_table, source_table_column, source_table_id
from 
(
     SELECT   extxref.source_table||extxref.source_table_column||extxref.source_table_id unique_key, extxref.source_table, extxref.source_table_column,extxref.source_table_id
      FROM   worldcheck_external_xref extxref
      GROUP BY extxref.source_table||extxref.source_table_column||extxref.source_table_id,  extxref.source_table, extxref.source_table_column,extxref.source_table_id
      ) a
      ,(
      SELECT    mst.source_table||mst.source_table_column||mst.source_id unique_key
      FROM xwrl_party_master mst
      GROUP BY mst.source_table||mst.source_table_column||mst.source_id
      )   b
where a.unique_key = b.unique_key (+)
and b.unique_key is null
;




select entity_type, category, sum(rec_count)
from 
(select 'INDIVIDUAL' entity_type, category, count(*) rec_count
from xwrl_response_ind_columns
where category is not null
group by category
union
select  'ENTITY' entity_type,  category, count(*)  rec_count
from xwrl_response_entity_columns
where category is not null
group by category
)
group by entity_type, category
order by 1, 2
;


select *
from all_objects
where object_name = 'XWRL_PARTY_MASTER_UK'
;

SELECT COUNT(*)
FROM xwrl_party_master
where source_key is null;


select *
from worldcheck_external_xref;


select *
from wc_content;

update xwrl_alert_clearing_xref
set source_key = source_table||source_table_column||source_id;




ALTER TABLE xwrl_alert_clearing_xref drop CONSTRAINT xwrl_alert_clearing_xref_uk;
ALTER TABLE xwrl_alert_clearing_xref ADD CONSTRAINT xwrl_alert_clearing_xref_uk unique ( source_key, list_id );

select *
from worldcheck_external_xref
;

   select a.unique_key,  a.source_table, a.source_table_column, a.source_table_id, b.unique_key
   from 
   (
        SELECT   extxref.source_table||extxref.source_table_column||extxref.source_table_id unique_key, extxref.source_table, extxref.source_table_column,extxref.source_table_id
         FROM   worldcheck_external_xref extxref
         GROUP BY extxref.source_table||extxref.source_table_column||extxref.source_table_id,  extxref.source_table, extxref.source_table_column,extxref.source_table_id
         ) a
         ,(
         SELECT    mst.source_key unique_key
         FROM xwrl_party_master mst
         GROUP BY mst.source_key
         )   b
   where a.unique_key = b.unique_key (+)
   and b.unique_key is null;


   select a.wc_screening_request_id, a.unique_key,  a.source_table, a.source_table_column, a.source_table_id, b.unique_key
   from 
   (
        SELECT   extxref.wc_screening_request_id, extxref.source_table||extxref.source_table_column||extxref.source_table_id unique_key, extxref.source_table, extxref.source_table_column,extxref.source_table_id
         FROM   worldcheck_external_xref extxref
         GROUP BY extxref.wc_screening_request_id, extxref.source_table||extxref.source_table_column||extxref.source_table_id,  extxref.source_table, extxref.source_table_column,extxref.source_table_id
         ) a
         ,(
         SELECT    mst.source_key unique_key
         FROM xwrl_party_master mst
         GROUP BY mst.source_key
         )   b
   where a.unique_key = b.unique_key (+)
   and a.wc_screening_request_id = 1328
   and b.unique_key is null;


select count(*)
from (
   select a.unique_key,  a.source_table, a.source_table_column, a.source_table_id, b.unique_key
   from 
   (
        SELECT   extxref.source_table||extxref.source_table_column||extxref.source_table_id unique_key, extxref.source_table, extxref.source_table_column,extxref.source_table_id
         FROM   worldcheck_external_xref extxref
         GROUP BY extxref.source_table||extxref.source_table_column||extxref.source_table_id,  extxref.source_table, extxref.source_table_column,extxref.source_table_id
         ) a
         ,(
         SELECT    mst.source_key unique_key
         FROM xwrl_party_master mst
         GROUP BY mst.source_key
         )   b
   where a.unique_key = b.unique_key (+)
   and b.unique_key is null
   )
   ;


select *
from xwrl_party_master
;

select *
from xwrl_party_master
--where source_key = 'SICD_SEAFARERSSEAFARER_ID797399'
where wc_screening_request_id = '1328'
;

with corp as (select corp_id from corp_main)
select *
from xwrl_requests req
,corp
where req.source_table = 'CORP_MAIN'
and req.source_table_column = 'CORP_ID'
and req.source_id not in corp.corp_id
;

select *
from xwrl_requests;

select * from corp_main
;


with party as (select source_id from xwrl_requests where source_table = 'CORP_MAIN' )
select corp_number, corp_name1 corp_name
from corp_main
,party
where corp_id < > party.source_id
group by corp_number, corp_name1 
order by corp_number desc
;


select count(*)
from wc_content
;


select *
from wc_content
--where matchstatus <> 'NEGATIVE'
--where matchtype <> 'WATCHLIST'
;

select *
from xwrl_alert_clearing_xref
;


select *
from xwrl_party_master
where source_key = 'CORP_MAINCORP_ID1076203'
;


SELECT xwrl_batch_seq.NEXTVAL from dual;


select *
from xwrl_party_master
where id = 1293
;

select *
from xwrl_party_alias
where master_id = :p_master_id
;

select master_id, count(*)
from xwrl_party_alias
group by master_id
having count(*) > 1
;

select mst.source_table, mst.source_id, alias.full_name
from xwrl_party_alias alias
,xwrl_party_master mst
where alias.master_id  = mst.id
and mst.id = 1293
;

select *
from xwrl_requests
order by id desc
;

select entity_type
from xwrl_party_alias
group by entity_type
;


select entity_type
from xwrl_party_alias
group by entity_type
;

update xwrl_party_alias
set entity_type = 'ORGANISATION'
where entity_type = 'ORGANIZATION';


select * from xwrl_party_master order by id desc;

select count(*)
from (select unique wc_screening_request_id
from xwrl_party_master);


select * from wc_screening_request;

select * from worldcheck_external_xref;

select CITY_OF_RESIDENCE_ID
from xwrl_party_master
;

select *
from xwrl_requests
order by id desc;

select xwrl_utils.get_ebs_pause  "EBS_Pause_Time" from dual;


select 'Alias ', round(avg(rec_count)) avg_count
from (select mst.relationship_type, mst.state, mst.status, mst.source_table, mst.source_table_column, mst.source_id, count(*) rec_count
from xwrl_party_master mst
,xwrl_party_alias xref
where mst.id = xref.master_id
group by mst.relationship_type, mst.state, mst.status, mst.source_table, mst.source_table_column, mst.source_id)
;


select 'Cross Reference ',round(avg(rec_count)) avg_count
from (select mst.relationship_type, mst.state, mst.status, mst.source_table, mst.source_table_column, mst.source_id, count(*) rec_count
from xwrl_party_master mst
,xwrl_party_xref xref
where mst.id = xref.master_id
group by mst.relationship_type, mst.state, mst.status, mst.source_table, mst.source_table_column, mst.source_id)
;
select *
from xwrl_requests
order by id desc;

select mst.relationship_type, mst.state, mst.status, mst.source_table, mst.source_table_column, mst.source_id, count(*)
from xwrl_party_master mst
,xwrl_party_alias xref
where mst.id = xref.master_id
group by mst.relationship_type, mst.state, mst.status, mst.source_table, mst.source_table_column, mst.source_id
having count(*) >=  5;


select mst.relationship_type, mst.state, mst.status, mst.source_table, mst.source_table_column, mst.source_id, count(*)
from xwrl_party_master mst
,xwrl_party_xref xref
where mst.id = xref.master_id
group by mst.relationship_type, mst.state, mst.status, mst.source_table, mst.source_table_column, mst.source_id
having count(*) >=  10;

select corp_number, corp_name1
from corp_main 
where corp_id = :p_corp_id
;

declare

v_source_table varchar2(4000);
v_source_table_column varchar2(4000);
v_source_id varchar2(4000);

x_batch_id integer;
x_return_status varchar2(4000);
x_return_msg varchar2(4000);

begin

v_source_table := 'AR_CUSTOMERS';
v_source_table_column := 'CUSTOMER_ID';
v_source_id :=  41568434;

rmi_ows_common_util.create_batch_vetting (
                   p_source_table             => v_source_table,
                    p_source_table_column      => v_source_table_column,
                    p_source_id                => v_source_id,
                    x_batch_id                 => x_batch_id,
                    x_return_status            => x_return_status,
                    x_return_msg               => x_return_msg
                    );

dbms_output.put_line('x_batch_id: '||x_batch_id);
dbms_output.put_line('x_return_status: '||x_return_status);
dbms_output.put_line('x_return_msg: '||x_return_msg);

end;
/

select *
from xwrl_party_alias
where last_update_login is not null
order by 1 desc;

select *
from xwrl_party_master
where last_update_login is not null
order by 1
;




select id
,DATE_OF_BIRTH
,SEX
,IMO_NUMBER
,VESSEL_INDICATOR
,PASSPORT_NUMBER
,PASSPORT_ISSUING_COUNTRY_CODE
,CITIZENSHIP_COUNTRY_CODE
,COUNTRY_OF_RESIDENCE
,CITY_OF_RESIDENCE_ID
,DATE_OF_BIRTH||SEX||IMO_NUMBER||VESSEL_INDICATOR||PASSPORT_NUMBER||PASSPORT_ISSUING_COUNTRY_CODE||CITIZENSHIP_COUNTRY_CODE||COUNTRY_OF_RESIDENCE||CITY_OF_RESIDENCE_ID rec_key
from xwrl_party_master;

select  id
,DATE_OF_BIRTH
,SEX
,IMO_NUMBER
,VESSEL_INDICATOR
,PASSPORT_NUMBER
,PASSPORT_ISSUING_COUNTRY_CODE
,CITIZENSHIP_COUNTRY_CODE
,COUNTRY_OF_RESIDENCE
,CITY_OF_RESIDENCE_ID
,DATE_OF_BIRTH||SEX||IMO_NUMBER||VESSEL_INDICATOR||PASSPORT_NUMBER||PASSPORT_ISSUING_COUNTRY_CODE||CITIZENSHIP_COUNTRY_CODE||COUNTRY_OF_RESIDENCE||CITY_OF_RESIDENCE_ID rec_key
from xwrl_party_alias
where last_update_login is null;





select *
from all_tables
where table_name like '%LOG'
AND OWNER = 'VSSL'
order by OWNER, table_name
;

SELECT * FROM  INSP_AUDIT_LOG;

SELECT * FROM INSP_CONTACT_NOTES;


declare

v_source_table varchar2(100);
v_source_table_column varchar2(100);
v_source_table_id integer;
x_result varchar2(4000);
                    


select x_state, substr(x_state,7,length(x_state)) state_attr
from xwrl_response_ind_columns
group by x_state
;

declare

cursor c1 is 
select column_name, data_type, count(*) over () rec_count
from all_tab_columns
where table_name = 'XWRL_REQUESTS'
and data_type not in ('XMLTYPE')
;

v_column varchar2(4000);
v_count integer;

begin

v_count := 0;

for c1rec in c1 loop
   
   if c1rec.rec_count = c1%rowcount then
         v_column := v_column||c1rec.column_name;
   else
         v_column := v_column||c1rec.column_name||',';
   end if;

end loop;

   dbms_output.put_line('v_column '||v_column);

end;
/

select *
from XLGL_MATTER
;

select *
from XLGL_AUDIT_LOGS
;

select *
from insp_audit_log
;

select *
from INSP_audit_log
;

select *
from INSP_CONTACT_NOTES
;


;




      select column_name, data_type, count(*) over () rec_count
      from all_tab_columns
      where table_name = :p_table_name
      --and data_type not in ('XMLTYPE')
      ;
   
      select 'if :old.'||column_name||' <> :new.'||column_name||' then '
      from all_tab_columns
      where table_name = p_table_name
      and column_name = p_column_name;
          
      select 'v_rec.'||column_name||' := :old.'||column_name||';'
      from all_tab_columns
      where table_name = :p_table_name
      and column_name = :p_column_name;
      ;
      

      select 'v_rec.'||column_name||' := :old.'||column_name||';'
      from all_tab_columns
      where table_name = :p_table_name
      and column_name = :p_column_name;
      ;      
      
      select table_name p_table_name, column_name p_table_column, ':NEW.'||column_name p_new_value, ':OLD.'||column_name p_old_value' '
      from all_tab_columns
      where table_name = 'XWRL_REQUESTS'
      and data_type not in ('XMLTYPE')
      ;
      

      

select *
from xwrl_requests
where id = 1017;

select *
from mt_log
order by 1 desc
;      

--truncate table xwrl.xwrl_audit_log;
      
select *
from xwrl_audit_log
ORDER BY 1 DESC;
;      


      
-- xwrl_requests      
-- xwrl_response_ind_columns
-- xwrl_response_entity_columns
-- xwrl_case_notes
-- xwrl_alert_notes
-- xwrl_case_documents

truncate table tmp_sql;
      
begin
--xwrl_data_utils.create_trigger_logic(upper('xwrl_requests'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_response_ind_columns'),  'ID',  null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_response_entity_columns'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_case_notes'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_alert_notes'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_case_documents'),  'ID', null);
end;
/

select * from tmp_sql;


select REGEXP_REPLACE(UPPER('Ke$sha Smith'), '[^0-9A-Za-z ]', '')
from dual;


select REGEXP_REPLACE(UPPER('John Smith, Jr.'), '[^0-9A-Za-z ]', '')
from dual;


select *
from all_indexes
where owner = 'XWRL'
;


select count(*)
from all_indexes
where owner = 'XWRL'
;

SELECT *
FROM ALL_TABLES
WHERE OWNER = 'SICD'
;

SELECT *
FROM ALL_TABLES
WHERE TABLE_NAME LIKE 'EXSICD%'
;

select *
from EXSICD_SEAFARER_QUERY;

select 'DROP INDEX '||INDEX_NAME||';' -- 82
from all_indexes
where owner = 'XWRL'
;

SELECT *
FROM EXSICD_SEAFARERS_IFACE
WHERE SEAFARER_ID = 1312910
ORDER BY ESI_ID DESC
;



select *
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
and source_table_column = NVL(:p_source_table_column,source_table_column)
--and source_id = 1112202
and state = 'Migrated'
and entity_type = 'VESSEL'
order by id desc
;

SELECT *
FROM SICD_SEAFARERS
WHERE SEAFARER_ID = 1312570 --SEBASTIAN MONTERO BALIGUAT
;

SELECT *
FROM EXSICD_SEAFARERS_IFACE
WHERE SEAFARER_ID = 1312570 -- SEBASTIAN MONTERO BALIGUA
;

select *
from all_tab_columns
where column_name = 'SEAFARER_ID'
ORDER BY OWNER, TABLE_NAME
;

select *
from WC_SCREENING_REQUEST
where wc_screening_request_id = 914905;

select *
from WORLDCHECK_EXTERNAL_XREF
where wc_screening_request_id = 914905;


select *
from sicd_seafarers
where first_name = 'MENG'
and last_name = 'LIU'
;

select *
from EXSICD_SEAFARER_SEARCH
WHERE SEAFARER_ID = 1312570;

select *
from SICD_DOCS_UA
WHERE SEAFARER_ID = 1312570;

select *
from EXSICD_PENDING_CRA
WHERE SEAFARER_ID = 1312570;

select *
from mlc_complaints
WHERE SEAFARER_ID = 1312570;


select *
from crew_members
WHERE SEAFARER_ID = 1312570;

select *
from YACHT_SEAFARERS_IFACE
WHERE SEAFARER_ID = 1312570;

SELECT * 
FROM nrmi_vessels;


select *
from xwrl_party_master
;




select unique relationship_type
from xwrl_party_master
;

select unique state
from xwrl_party_master
;

select unique status
from xwrl_party_master
;

select *
from xwrl_party_master
where state not like 'Delete%';


select *
from xwrl_requests
;


select mst.id, mst.source_table, mst.source_table_column, mst.source_id, mst.wc_screening_request_id
from xwrl_party_master mst
,xwrl_requests req
where mst.id = req.master_id (+) 
and mst.state not like 'Delete%'
and req.master_id is null
order by mst.wc_screening_request_id desc
;



   select mst.id, mst.source_table, mst.source_table_column, mst.source_id
      from xwrl_party_master mst
      ,xwrl_requests req
      where mst.id = req.master_id (+) 
      and mst.state not like 'Delete%'
      and req.master_id is null
      and rownum < p_row_num
      ;

SELECT *
FROM XWRL_PARTY_MASTER
;

select *
from sicd_seafarers
where first_name = 'MENG'
and last_name = 'LIU'
;

SELECT SYSDATE, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'YYYYMMDD')
FROM DUAL;
      
select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id) target_full_name
from xwrl_party_master mst
,sicd_seafarers seaf
where seaf.seafarer_id = mst.source_id  
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'SICD_SEAFARERS'
and mst.source_table_column = 'SEAFARER_ID'
AND REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(ltrim(first_name||' '||last_name)), '[^0-9A-Za-z]', '') 
AND mst.date_of_birth = TO_CHAR(seaf.BIRTH_DATE,'YYYYMMDD')
and mst.state = 'Migrated'
;

      
select seafarer_id, REGEXP_REPLACE(UPPER(ltrim(first_name||' '||last_name)), '[^0-9A-Za-z]', ' ') 
from sicd_seafarers
;

select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.full_name
, REGEXP_REPLACE(UPPER(ltrim(first_name||' '||last_name)), '[^0-9A-Za-z]', ' ')  seaf_name
, mst.source_id
, seaf.seafarer_id
from xwrl_party_master mst
, sicd_seafarers seaf
WHERE REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(ltrim(first_name||' '||last_name)), '[^0-9A-Za-z]', '')  
AND mst.date_of_birth = TO_CHAR(seaf.BIRTH_DATE,'YYYYMMDD')
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'SICD_SEAFARERS'
and mst.source_table_column = 'SEAFARER_ID'
and mst.state = 'Migrated'
;


-- ROBERT MAYE

select *
from AR_CONTACTS_V
where REGEXP_REPLACE(UPPER(ltrim(first_name||' '||last_name)), '[^0-9A-Za-z]', ' ')  = 'YANG CHUNDI'
;

select *
from ar_customers
--where customer_id = 41587319 --- 101264-CORP  NAVIG8 EUROPE LTD.
where REGEXP_REPLACE(UPPER(customer_name), '[^0-9A-Za-z]', ' ')  = 'YANG CHUNDI'
;

select *
from corp_main
where corp_id = 1056128 --- Navig8 Group Holdings Inc
;

select *
from AR_CONTACTS_V;


select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
,ar.customer_id
,ar.customer_number
,substr(ar.customer_number,instr(ar.customer_number,'-',1)+1,length(ar.customer_number))
,acv.CONTACT_ID
--,LTRIM(FIRST_NAME||' '||LAST_NAME) FULL_NAME2
, JOB_TITLE
, xwrl_data_processing.verify_master_fullname('AR_CONTACTS_V', 'CONTACT_ID', acv.CONTACT_ID) target_full_name
from xwrl_party_master mst
,corp_main cm
,AR_CUSTOMERS ar
,AR_CONTACTS_V acv
where  mst.source_id  =  cm.corp_id
and cm.customer_id = ar.customer_id
and ar.customer_id = acv.customer_id
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'CORP_MAIN'
and mst.source_table_column = 'CORP_ID'

--and mst.source_id = 41568466
;

select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
,cm.corp_id
,cm.customer_id corp_customer_id
,cm.current_agent corp_current_agent
,cm.contact_id
,ar.customer_id
,av.CONTACT_ID
,REGEXP_REPLACE(UPPER(ltrim(av.first_name||' '||av.last_name)), '[^0-9A-Za-z]', ' ')   contact_name
from xwrl_party_master mst
, corp_main cm
, AR_CONTACTS_V av
,AR_CUSTOMERS ar
WHERE cm.corp_id = mst.source_id
and REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', ' ') = REGEXP_REPLACE(UPPER(ltrim(av.first_name||' '||av.last_name)), '[^0-9A-Za-z]', ' ')  
AND av.customer_id = ar.customer_id
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'CORP_MAIN'
and mst.source_table_column = 'CORP_ID'
and substr(ar.customer_number,instr(ar.customer_number,'-',1)+1,length(ar.customer_number)) = 'CORP'
and mst.state <> 'Verified'  
--and mst.full_name = 'KURT PLANKL'
;

select *
from ar_customers
where customer_id = 41442674  -- SEWARD & KISSEL L.L.P.
;

select *
from AR_CONTACTS_V
where contact_id in ( 1169192, 1158029) -- SEWARD & KISSEL L.L.P.
;

-- 1169192
-- 1158029


select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
,av.CONTACT_ID
,av.job_title
,REGEXP_REPLACE(UPPER(ltrim(av.first_name||' '||av.last_name)), '[^0-9A-Za-z]', ' ')   contact_name
from xwrl_party_master mst
, AR_CONTACTS_V av
WHERE  REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', ' ') = REGEXP_REPLACE(UPPER(ltrim(av.first_name||' '||av.last_name)), '[^0-9A-Za-z]', ' ')  
AND mst.entity_type = 'INDIVIDUAL'
--and substr(ar.customer_number,instr(ar.customer_number,'-',1)+1,length(ar.customer_number)) = 'CORP'
and mst.state <> 'Verified'  
;

select *
from xwrl_party_master
;

select *
from xwrl_requests
;

   select mst.id, mst.source_table, mst.source_table_column, mst.source_id, mst.wc_screening_request_id
   from xwrl_party_master mst
   ,xwrl_requests req
   where  (mst.source_table||mst.source_id ) = (req.source_table||req.source_id) (+)
   and mst.state not like 'Delete%'
   and req.source_table||req.source_id is null
   and rownum <= :p_row_num
   order by mst.wc_screening_request_id desc
   ;
   
   select  xmst.id, xmst.state, xmst.source_table, xmst.source_table_column, xmst.source_id, xmst.wc_screening_request_id
   from (select mst.id, mst.state, mst.source_table, mst.source_table_column, mst.source_id, mst.wc_screening_request_id, mst.source_table||mst.source_id source_key
   from xwrl_party_master mst ) xmst
   ,(select req.id,  req.source_table, req.source_id, req.wc_screening_request_id, req.source_table||req.source_id source_key
   from xwrl_requests req) xreq
   where xmst.source_key = xreq.source_key (+) 
   and xmst.state not like 'Delete%'
   and xreq.source_key is null
   and rownum <= :p_row_num
   order by xmst.wc_screening_request_id desc
   ;   
   
   select xwrl_utils.get_max_jobs from dual;

select *
from xwrl_party_master
;

select *
from sicd_countries
;

select iso_alpha2_code
from sicd_countries
where country_code = 'xxxx';

   select  xmst.id
   , xmst.state
   , xmst.source_table
   , xmst.source_table_column
   , xmst.source_id   
   , xmst.wc_screening_request_id
   from (select mst.id
   , mst.state
   , nvl(mst.xref_source_table,mst.source_table) source_table
   , nvl(mst.xref_source_table_column,mst.source_table_column) source_table_column
   , nvl(mst.xref_source_id,mst.source_id) source_id
   , mst.wc_screening_request_id
   , nvl(mst.xref_source_table||xref_source_id,mst.source_table||mst.source_id) source_key
   from xwrl_party_master mst ) xmst
   ,(select req.id,  req.source_table, req.source_id, req.wc_screening_request_id, req.source_table||req.source_id source_key
   from xwrl_requests req) xreq
   where xmst.source_key = xreq.source_key (+) 
   and xmst.state not like 'Delete%'
   and xreq.source_key is null
   and rownum <= :p_row_num
   order by xmst.wc_screening_request_id desc
   
   ;
   
   
   
   
    BEGIN

      /* TSUAZO 11/19/2019 Disable WC Data Processing */
      dbms_scheduler.disable (name => 'PROCESS_WC_DATA_INDIVIDUAL');
      dbms_scheduler.disable (name => 'PROCESS_WC_DATA_ENTITY');
      dbms_scheduler.disable (name => 'PROCESS_OWS_ERRORS');
      dbms_scheduler.disable (name => 'PROCESS_WC_XML_PARSER');


   END ;
   /
   
   
declare


   
      BEGIN

      /* TSUAZO 11/19/2019 Disable WC Data Processing */
      dbms_scheduler.set_attribute (name => 'PROCESS_WC_DATA_INDIVIDUAL', attribute => 'END_DATE', value => to_timestamp (p_end_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.enable (name => 'PROCESS_WC_DATA_INDIVIDUAL');
      dbms_scheduler.set_attribute (name => 'PROCESS_WC_DATA_ENTITY', attribute => 'END_DATE', value => to_timestamp (p_end_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.enable (name => 'PROCESS_WC_DATA_ENTITY');
      dbms_scheduler.set_attribute (name => 'PROCESS_OWS_ERRORS', attribute => 'END_DATE', value => to_timestamp (p_end_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.enable (name => 'PROCESS_OWS_ERRORS');
      dbms_scheduler.set_attribute (name => 'PROCESS_WC_XML_PARSER', attribute => 'END_DATE', value => to_timestamp (p_end_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.enable (name => 'PROCESS_WC_XML_PARSER');


   END;
   /
   
   
   select * 
   from xwrl_requests
   where batch_id = 1197;
   
   
   SELECT *
   FROM all_scheduler_jobs;
   
   
   
   select *
   from xwrl_party_master
   WHERE COUNTRY_OF_RESIDENCE = 'RU'
   AND  CITY_OF_RESIDENCE_ID = 488
   ;
   
   select *
   from xwrl_party_master
   where source_table = 'SICD_SEAFARERS'
   and source_id = 1088238;
   
      select *
   from xwrl_party_master
   where source_table = 'SICD_SEAFARERS'
   and source_id = 1088238;
   
         select *
   from xwrl_party_alias;
   
   SELECT *
   FROM XWRL_PARTY_MASTER
   WHERE  ENTITY_TYPE = 'ORGANISATION'
   ;
   
   
select * 
from xwrl_requests
ORDER BY ID DESC;


select *
from xwrl_party_master
order by id desc;

select mst.relationship_type, mst.state, mst.status, mst.source_table, mst.source_table_column, mst.source_id, count(*)
from xwrl_party_master mst
,xwrl_party_alias xref
where mst.id = xref.master_id
group by mst.relationship_type, mst.state, mst.status, mst.source_table, mst.source_table_column, mst.source_id
having count(*) >=  1;


select mst.relationship_type, mst.state, mst.status, mst.source_table, mst.source_table_column, mst.source_id, count(*)
from xwrl_party_master mst
,xwrl_party_xref xref
where mst.id = xref.master_id
group by mst.relationship_type, mst.state, mst.status, mst.source_table, mst.source_table_column, mst.source_id
having count(*) >=  1;

select * from xwrl_requests 
where error_message = 'Please see response.'
;


select *
from xwrl_party_xref
where master_id = relationship_master_id
;


select * from xwrl_requests 
where status = 'RESUBMIT';

select  xwrl_utils.get_wl_server ('LOADBALANCE_SERVER', 'IRIPROD') from dual;

begin
      utl_http.set_response_error_check (true);
      utl_http.set_detailed_excp_support (true);
      end;
      /

select *
from xwrl_parameters
;
select *
from xwrl_party_master;


  select  count(*)
   from (select mst.id
   , mst.state
   , nvl(mst.xref_source_table,mst.source_table) source_table
   , nvl(mst.xref_source_table_column,mst.source_table_column) source_table_column
   , nvl(mst.xref_source_id,mst.source_id) source_id
   , mst.wc_screening_request_id
   , nvl(mst.xref_source_table||xref_source_id,mst.source_table||mst.source_id) source_key
   from xwrl_party_master mst ) xmst
   ,(select req.id,  req.source_table, req.source_id, req.wc_screening_request_id, req.source_table||req.source_id source_key
   from xwrl_requests req) xreq
   where xmst.source_key = xreq.source_key (+) 
   and xmst.state not like 'Delete%'
   and xreq.source_key is null
   --and rownum <= p_row_num
   order by xmst.wc_screening_request_id desc;

   select  xmst.id
   , xmst.state
   , xmst.source_table
   , xmst.source_table_column
   , xmst.source_id   
   , xmst.wc_screening_request_id
   from (select mst.id
   , mst.state
   , nvl(mst.xref_source_table,mst.source_table) source_table
   , nvl(mst.xref_source_table_column,mst.source_table_column) source_table_column
   , nvl(mst.xref_source_id,mst.source_id) source_id
   , mst.wc_screening_request_id
   , nvl(mst.xref_source_table||xref_source_id,mst.source_table||mst.source_id) source_key
   from xwrl_party_master mst ) xmst
   ,(select req.id,  req.source_table, req.source_id, req.wc_screening_request_id, req.source_table||req.source_id source_key
   from xwrl_requests req) xreq
   where xmst.source_key = xreq.source_key (+) 
   and xmst.state not like 'Delete%'
   and xreq.source_key is null
   --and rownum <= p_row_num
   order by xmst.wc_screening_request_id desc;
   
   
   select * from xwrl_requests 
where status = 'RESUBMIT';
/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_jobs.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                               $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : apps_create_jobs.sql                                                                        *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                      *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    :                                                                                             *
* Last Reviewed Date  :                                                                                             *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO          15-NOV-2019  I      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/
/*
DECLARE
   v_job_name       VARCHAR2 (1000);
BEGIN
      v_job_name := 'PROCESS_WC_DATA_INDIVIDUAL';
      dbms_scheduler.drop_job(job_name => v_job_name);
 END;
  /
DECLARE
   v_job_name       VARCHAR2 (1000);  
 BEGIN
      v_job_name := 'PROCESS_WC_DATA_ENTITY';
     dbms_scheduler.drop_job(job_name => v_job_name);
 END;
 /

 DECLARE
   v_job_name       VARCHAR2 (1000);
 BEGIN
     v_job_name := 'PROCESS_WC_XML_PARSER';
     dbms_scheduler.drop_job(job_name => v_job_name);
 END;
/
*/

BEGIN
DBMS_SCHEDULER.DROP_JOB_CLASS (
   job_class_name              => 'OWS_JOB_CLASS');
END;
/

BEGIN
DBMS_SCHEDULER.CREATE_JOB_CLASS (
   job_class_name              => 'OWS_JOB_CLASS',
   comments                    => 'This is an OWS job class');
END;
/

/* Process WC Individuals */
/*
DECLARE

   v_job_name       VARCHAR2 (1000);
   v_frequency integer;

BEGIN

      v_job_name := 'PROCESS_WC_DATA_INDIVIDUAL';
      v_frequency := xwrl_utils.get_frequency;
      
      dbms_scheduler.create_job (job_name => v_job_name
      , job_type => 'STORED_PROCEDURE'
      ,job_class => 'OWS_JOB_CLASS'
      ,job_action => 'XWRL_DATA_PROCESSING.PROCESS_WC_DATA_INDIVIDUAL'      
      , start_date => timestamp '2019-05-02 12:15:00'
      ,repeat_interval => 'FREQ=MINUTELY; INTERVAL='||v_frequency
      , end_date => NULL
      ,enabled => FALSE
      , comments => 'Process WC Individual data');

END;
/
*/
/* Process WC Entities */
/*
DECLARE

   v_job_name       VARCHAR2 (1000);
v_frequency integer;

BEGIN

      v_job_name := 'PROCESS_WC_DATA_ENTITY';
      v_frequency := xwrl_utils.get_frequency;

      dbms_scheduler.create_job (job_name => v_job_name
      , job_type => 'STORED_PROCEDURE'
      ,job_class => 'OWS_JOB_CLASS'
      ,job_action => 'XWRL_DATA_PROCESSING.PROCESS_WC_DATA_ENTITY'
      , start_date => timestamp '2019-05-02 12:15:00'
      ,repeat_interval => 'FREQ=MINUTELY; INTERVAL='||to_char(v_frequency)
      , end_date => NULL
      ,enabled => FALSE
      , comments => 'Process WC Entity data');

END;
/
*/

/* Process OWS Errors */

 DECLARE
   v_job_name       VARCHAR2 (1000);
 BEGIN
     v_job_name := 'PROCESS_OWS_ERRORS';
     dbms_scheduler.drop_job(job_name => v_job_name);
 END;
/

DECLARE

   v_job_name       VARCHAR2 (1000);
   v_frequency integer;

BEGIN

      v_job_name := 'PROCESS_OWS_ERRORS';
      v_frequency := xwrl_utils.get_frequency;
 
      dbms_scheduler.create_job (job_name => v_job_name
      , job_type => 'STORED_PROCEDURE'
      ,job_class => 'OWS_JOB_CLASS'
      ,job_action => 'XWRL_DATA_PROCESSING.PROCESS_OWS_ERROR_RESUBMIT'
      , start_date => timestamp '2019-05-02 12:15:00'
      ,repeat_interval => 'FREQ=MINUTELY; INTERVAL='||v_frequency
      , end_date => NULL
      ,enabled => FALSE
      , comments => 'Process OWS Errors for Resubmit');

END;
/


 DECLARE
   v_job_name       VARCHAR2 (1000);
 BEGIN
     v_job_name := 'PROCESS_MASTER_RECORDS';
     dbms_scheduler.drop_job(job_name => v_job_name);
 END;
/

DECLARE

   v_job_name       VARCHAR2 (1000);
   v_frequency integer;

BEGIN

      v_job_name := 'PROCESS_MASTER_RECORDS';
      v_frequency := xwrl_utils.get_frequency;
 
      dbms_scheduler.create_job (job_name => v_job_name
      , job_type => 'STORED_PROCEDURE'
      ,job_action => 'XWRL_DATA_PROCESSING.PROCESS_MASTER_RECORDS'
      , start_date => timestamp '2019-11-19 12:15:00'
      ,repeat_interval => 'FREQ=MINUTELY; INTERVAL='||v_frequency
      , end_date => NULL
      ,enabled => FALSE
      , comments => 'Process Master Records');

END;
/
select state, count(*)
from all_scheduler_jobs
--where job_name like 'OWS%'
--where job_name = 'OWS_E_201903300203_50_JOB'
group by state;

select owner, job_name
--,program_owner
--,program_name
,enabled
 ,state
 ,next_run_date
, job_type
, job_action
--, number_of_arguments
, schedule_type, start_date, repeat_interval,  run_count, comments
FROM all_scheduler_jobs
where job_name like 'OWS%'
order by next_run_date;

select *
from xwrl_parameters
order by id, key;


   select  xmst.id
   , xmst.state
   , xmst.source_table
   , xmst.source_table_column
   , xmst.source_id   
   , xmst.wc_screening_request_id
   from (select mst.id
   , mst.state
   , nvl(mst.xref_source_table,mst.source_table) source_table
   , nvl(mst.xref_source_table_column,mst.source_table_column) source_table_column
   , nvl(mst.xref_source_id,mst.source_id) source_id
   , mst.wc_screening_request_id
   , nvl(mst.xref_source_table||xref_source_id,mst.source_table||mst.source_id) source_key
   from xwrl_party_master mst ) xmst
   ,(select req.id,  req.source_table, req.source_id, req.wc_screening_request_id, req.source_table||req.source_id source_key
   from xwrl_requests req) xreq
   where xmst.source_key = xreq.source_key (+) 
   and xmst.state not like 'Delete%'
   and xreq.source_key is null
   and rownum <= :p_row_num
   order by xmst.wc_screening_request_id desc
   ;
   
   
         SELECT value_string

        FROM xwrl_parameters
       WHERE ID = 'TRADE_URL' AND KEY = 'IRIPROD';
       
          select  xmst.id
   , xmst.state
   , xmst.source_table
   , xmst.source_table_column
   , xmst.source_id   
   , xmst.wc_screening_request_id
   from (select mst.id
   , mst.state
   , mst.source_table 
   , mst.source_table_column 
   , mst.source_id 
   , mst.wc_screening_request_id
   , mst.source_table||mst.source_table_column||mst.source_id source_key
   from xwrl_party_master mst ) xmst
   ,(select req.id,  req.source_table, req.source_id, req.wc_screening_request_id, req.source_table||req.source_id source_key
   from xwrl_requests req) xreq
   where xmst.source_key = xreq.source_key (+) 
   and xmst.state not like 'Delete%'
   and xreq.source_key is null
   --and rownum <= p_row_num
   order by xmst.wc_screening_request_id desc
   ;
   
   
   
   select *
   from xwrl_requests
   where status = 'ERROR'
   ;
   
   select KEY, VALUE_STRING
   from xwrl_parameters
   where ID = 'CASE_WORK_FLOW'
   ;
   
   select B.VALUE_STRING WORK_FLOW, COUNT(*) RECORD_COUNT
   from xwrl_requests A
   , ( select KEY, VALUE_STRING
   from xwrl_parameters
   where ID = 'CASE_WORK_FLOW') B
   WHERE A.case_workflow = B.KEY
   group by B.VALUE_STRING
   ORDER BY 2 DESC
   ;

   select count(*)
   from (select mst.id
   , mst.state
   , mst.source_table 
   , mst.source_table_column 
   , mst.source_id 
   , mst.wc_screening_request_id
   , mst.source_table||mst.source_table_column||mst.source_id source_key
   from xwrl_party_master mst ) xmst
   ,(select req.id,  req.source_table, req.source_id, req.wc_screening_request_id, req.source_table||req.source_id source_key
   from xwrl_requests req) xreq
   where xmst.source_key = xreq.source_key (+) 
   and xmst.state not like 'Delete%'
   and xreq.source_key is null
   --and rownum <= p_row_num
   order by xmst.wc_screening_request_id desc
   ;
   
   select  xmst.id
   , xmst.state
   , xmst.source_table
   , xmst.source_table_column
   , xmst.source_id   
   , xmst.wc_screening_request_id
   from (select mst.id
   , mst.state
   , mst.source_table 
   , mst.source_table_column 
   , mst.source_id 
   , mst.wc_screening_request_id
   , mst.source_table||mst.source_id source_key
   from xwrl_party_master mst ) xmst
   ,(select req.id,  req.source_table, req.source_id, req.wc_screening_request_id, req.source_table||req.source_id source_key
   from xwrl_requests req) xreq
   where xmst.source_key = xreq.source_key (+) 
   and xmst.state not like 'Delete%'
   and xreq.source_key is null
   --and rownum <= p_row_num
   order by xmst.wc_screening_request_id desc
   ;
   
select *
from xwrl_requests
where source_table = 'REG11_HEADER'
and source_id = 13676
;


 SELECT   *
             FROM xwrl_party_master r
            WHERE 1 = 1
              AND relationship_type = 'Primary'
              AND status = 'Enabled'
              AND state NOT LIKE '%Delete%'
and  source_table = 'REG11_HEADER'
and source_id = '13676'
;

select count(*)
from (select source_table, source_id, name_screened, count(*)
from xwrl_requests
where  source_table is not null
group by source_table, source_id,  name_screened
having count(*) > 1
order by 4 desc)
;



declare
cursor c1 is
select source_table, source_id, name_screened, count(*)
from xwrl_requests
where  source_table is not null
group by source_table, source_id,  name_screened
having count(*) > 1
order by 4 desc;

cursor c2
(p_source_table varchar2
,p_source_id integer
,p_name_screened varchar2)
is 
select *
from xwrl_requests
where source_table = p_source_table
and source_id = p_source_id 
and  name_screened = p_name_screened;

v_id integer;


v_count integer ;
v_max integer;

begin

v_max := 1000;

for c1rec in c1 loop

v_count := 0;

select max(id)
into v_id
from xwrl_requests 
where source_table = c1rec.source_table
and source_id = c1rec.source_id 
and name_screened = c1rec.name_screened;

for c2rec in c2 (c1rec.source_table, c1rec.source_id, c1rec.name_screened) loop

if c2rec.id <> v_id then

v_count := v_count + 1;

DELETE from xwrl_response_ind_columns where request_id = c2rec.id;
DELETE from xwrl_response_entity_columns where request_id = c2rec.id;
DELETE xwrl_response_rows where request_id = c2rec.id;
DELETE from xwrl_alert_documents where request_id = c2rec.id;
DELETE from xwrl_case_documents where request_id = c2rec.id;
DELETE from xwrl_request_ind_columns where request_id = c2rec.id;
DELETE from xwrl_request_entity_columns where request_id = c2rec.id;
DELETE from xwrl_request_rows where request_id = c2rec.id;
DELETE from xwrl_requests where id = c2rec.id;

end if;

if v_count >= 100 then 
   commit;
end if;

if v_count >= v_max then
   exit;
end if;

end loop;

end loop;

commit;

end;
/

select x_state
from xwrl_response_ind_columns
;

select substr(x_state,7,5)
from xwrl_response_ind_columns

;

select *
from xwrl_response_ind_columns
where substr(x_state,7,5) = 'Open'
;

select request_id, count(*) open_alerts
from xwrl_response_ind_columns
where substr(x_state,7,5) = 'Open'
group by request_id
;

with open_rows as 
(select request_id, count(*) open_alerts
from xwrl_response_ind_columns
where substr(x_state,7,5) = 'Open'
group by request_id)
,alert_count as 
(select request_id, count(*) alert_total
from xwrl_response_ind_columns
group by request_id)
select id, batch_id, name_screened, alert_total, open_alerts
from xwrl_requests req
,alert_count
,open_rows
where req.id = alert_count.request_id
and req.id = open_rows.request_id
and alert_total <> open_alerts
order by id desc
;


      select id, source_table, source_id, batch_id, name_screened
      from xwrl_requests
      where id in (1010, 1013, 1015)
      ;
     
            select id, request_id, x_state, listid, listfullname
      from xwrl_response_ind_columns
      where listid = 1173830
      order by 1;

select *
from mt_log
order by log_id desc
;


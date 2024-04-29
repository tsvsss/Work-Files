select *
from xwrl_requests r
where case_id is null;

declare

cursor c1 is
select r.ID, r.CASE_ID, r.RESPONSE, r.CASE_STATUS, r.CASE_STATE, r.CASE_WORKFLOW, (SELECT substr(x.id,instr(x.id,'|',1,2)+1,length(x.id)) case_id
FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "dn"), '//dn:response' PASSING t.response COLUMNS rec FOR ORDINALITY,id varchar2(2700) path '@id'
         ) x 
      WHERE
         t.id = r.id) x_case_id
from xwrl_requests r
--where status = 'ERROR'
--where source_table = 'SICD_SEAFARERS'
--and source_id = 599999
--where resubmit_id is not null
--and compressed_request is not null
--where id in (205929,205886)
WHERE CASE_ID IS NULL
--WHERE ID = 205988
order by id desc
;

begin
for c1rec in c1 loop
UPDATE XWRL_REQUESTS
SET CASE_STATUS = 'O'
,CASE_ID = c1rec.x_case_id
WHERE ID = c1rec.id
;
commit;
end loop;
end;
/

declare
cursor c1 is
select id, resubmit_id
from xwrl_requests
where resubmit_id is not null
and status = 'ERROR'
;

BEGIN
for c1rec in c1 loop
UPDATE xwrl_requests
SET STATUS = 'ERROR'
WHERE ID = C1REC.resubmit_id;
end loop
;
commit;
end;
/

select unique batch_id
from xwrl_requests
--where status = 'ERROR'
--where source_table = 'SICD_SEAFARERS'
--and source_id = 599999
--where resubmit_id is not null annd compressed_request is not null
where status IN ( 'ERROR', 'RESUBMIT')
--order by id desc
order by 1
;



SELECT
   req.id
, req.resubmit_id
 , req.batch_id
 --,req.assigned_to
 --,req.edq_url
 ,req.status
 ,req.error_code
 ,req.error_message
 , req.case_id
 --, req.soap_request
 /*
 , req.master_id
 , req.alias_id
 , req.xref_id
 ,req.source_table
 ,req.source_id
 , req.request
 , req.compressed_request
 ,req.response
-,req.edq_url
 , req.path
 */
 , req.compressed_request 
  ,req.response
  , req.name_screened
  , req.matches
 , req.date_of_birth
 , req.gender
 /*
 ,req.country_of_registration
 , req.country_of_address
 , req.country_of_residence
 , req.country_of_nationality
 , req.country_of_birth
 */
 , req.case_id
 , req.creation_date
 , req.last_update_date
 , status
 , case_status
 , case_state
 , case_workflow
 --, req.job_id
 --, req.error_message
 , req.created_by
 , fusr.user_name     created_user
 , req.last_updated_by
 , fusr2.user_name    update_user
FROM
   xwrl_requests  req
 , fnd_user       fusr
 , fnd_user       fusr2
WHERE
       req.created_by = fusr.user_id (+)
   AND req.last_updated_by = fusr2.user_id (+)
--and matches >= 500
--and trunc(req.creation_date) = to_date('05/06/2020','MM/DD/YYYY')
--and path = 'INDIVIDUAL'
--AND COUNTRY_OF_RESIDENCE IS NULL
   --AND batch_id = 100
   --and name_screened = 'MICHAEL JOHN SMITH'
   --and req.created_by = 1156
   --and path = 'ENTITY'
--AND req.country_of_registration IS NOT NULL
--and batch_id = 87675 
--and name_screened = 'ATHENS VOYAGER'
--and name_screened = 'VOYAGER I'
--and batch_id = 100
--and status in  ( 'ERROR', 'RESUBMIT')
--and matches > 100
--and case_status = 'O'
--and batch_id in (87764, 88294 )
--and batch_id = 50
--and name_screened LIKE 'BLACKLIGHT S A%'
--and id = 205705 
--and name_screened = 'SUBIN SOMAN'
ORDER BY
   req.id DESC
   ;

-- OWS-202006-171538-1E33CB-ENT

   
   SELECT *
   FROM xwrl_response_entity_columns
   WHERE request_id = 194171
--   WHERE LISTRECORDTYPE = 'SAN'
--   AND DNVESSELINFO LIKE '%[USA SANCTIONS - OFAC]%'
--   and dnvesselindicator = 'Y'   
   
   ORDER BY ID DESC;
   
   select *
   from xwrl_response_entity_columns
   where request_id = 183297;
   
   
   select *
   from xwrl_audit_log
   where table_name = 'XWRL_RESPONSE_ENTITY_COLUMNS'
   and table_id = 76916
   order by audit_log_id desc
   ;
   
   
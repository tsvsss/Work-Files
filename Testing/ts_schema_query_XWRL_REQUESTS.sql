SELECT
   req.id
, req.resubmit_id
 , req.batch_id
 ,req.master_id
 ,req.alias_id
 ,req.xref_id
 ,req.case_id
 ,REQ.NAME_SCREENED
 ,req.department
 ,req.document_type
  ,req.matches
    , status
 , case_status
 , case_state
 --, case_workflow
 ,WFLOW.VALUE_STRING CASE_WORKFLOW
 , req.expiration_date
   ,req.creation_date
,    fusr.user_name     created_user
,req.last_update_date
 , fusr2.user_name    update_user
/*
, ebs_start
, ebs_end
, ows_start
, ows_end
, auto_clear_start
, auto_clear_end
*/
,extract(second from( ebs_end - ebs_start) DAY TO SECOND) ebs_time
,extract(second from(ows_end - ows_start) DAY TO SECOND) ows_time
,extract(second from(auto_clear_end - auto_clear_start) DAY TO SECOND) auto_clear_time
      ,req.error_code
 ,req.error_message
 ,req.request
 ,req.response
    /*
     ,REQ.SOURCE_TABLE
 --,REQ.SOURCE_TABLE_COLUMN
 ,REQ.SOURCE_ID
 ,req.request
 ,req.response
 ,req.request
 ,req.compressed_request
  , req.created_by
 , req.last_updated_by
   --,req.assigned_to
 --,req.edq_url
  --,req.response
 --, req.soap_request
  ,req.error_code
 ,req.error_message
 , req.case_id
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
 , req.compressed_request 
  ,req.response
  , req.name_screened
  , req.matches
 , req.date_of_birth
 , req.gender
 ,req.country_of_registration
 , req.country_of_address
 , req.country_of_residence
 , req.country_of_nationality
 , req.country_of_birth
 , req.city_of_residence_id
 --, req.case_id
 , office
 , req.creation_date
 , req.last_update_date
 --, req.job_id
 --, req.error_message
 , req.created_by
 , fusr.user_name     created_user
 , req.last_updated_by
 , fusr2.user_name    update_user
 */
FROM
   xwrl_requests  req
 , fnd_user       fusr
 , fnd_user       fusr2
 ,(select KEY, VALUE_STRING
from xwrl_parameters
where id = 'CASE_WORK_FLOW') WFLOW
WHERE
       req.created_by = fusr.user_id (+)
   AND req.last_updated_by = fusr2.user_id (+)
   AND REQ.CASE_WORKFLOW = WFLOW.KEY (+)
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
--and status = 'RESUBMIT'
--and status = 'ERROR'
--and matches > 100
--and case_status = 'O'
--and batch_id in (87764, 88294 )
--and batch_id = 50
--and name_screened LIKE 'BLACKLIGHT S A%'
--and id = 205705 
--and name_screened = 'BO WANG'
--and batch_id = 96783
--and req.department = 'CORP'
--and document_type = 'ESR'
--and req.case_status = 'O'
--and req.case_workflow IN ( 'L','SL' )
--and req.city_of_residence_id is not null
--and matches <> 0
--and case_status = 'C'
--AND CASE_STATE <> 'D'
--AND REQ.CREATION_DATE > TO_DATE('06-JUL-20 03:00:00 PM','DD-MON-YY HH:MI:SS PM')
--and req.resubmit_id is not null
--and trunc(req.Last_update_date) = trunc(sysdate)
--and batch_id < 1000
--and id in (234204,234250,235495,235496)
--and batch_id = 108845
--and path = 'ENTITY'
--AND MATCHES > 10
--and batch_id = 188811
--and name_screened like '%CAPACIO%'
--and batch_id = 112882
--and path = 'ENTITY'
--and matches > 10
--and length(name_screened) - length(replace(name_screened, ' ', '')) + 1 = 1
--and batch_id in ( 68091, 68092, 68093 )
--and name_screened is null
--and batch_id = 117595
--and source_table like '%ESR%'
--and batch_id < 1000
--and matches > 10
--and id = 258288
--and status = 'FAILED'
--and batch_id = 125829
--and name_screened like 'CELESTIA HOLDINGS S A '
--and resubmit_id is not null
--and batch_id = 125819
ORDER BY   req.id desc
;


update xwrl_requests
set case_state = 'D'
,case_status = 'C'
WHERE ID = 268782;
select country_code, country_name, sanction_status
from sicd_countries
where sanction_status is not null AND sanction_status <> 'NONE'
;

DELETE FROM xwrl_case_notes a

      WHERE 1 = 1

        AND request_id IN (SELECT   request_id

                               FROM xwrl_case_notes

                           GROUP BY note, request_id, created_by

                             HAVING COUNT (1) > 1)

        AND ID NOT IN (SELECT   MAX (ID)

                           FROM xwrl_case_notes

                          WHERE request_id = a.request_id

                       GROUP BY note, request_id, created_by

                         HAVING COUNT (1) > 1);

 

CREATE UNIQUE INDEX XWRL.XWRL_CASE_NOTES_UNQ ON XWRL.XWRL_CASE_NOTES (REQUEST_ID, NOTE);

select *
from xwrl_requests
;

select *
from xwrl_response_ind_columns
;

select *
from xwrl_response_entity_columns
;

select *
from all_directories
where DIRECTORY_PATH like '%doc'
;

xwrl_alert_clearing_xref;

xwrl_utils;

xwrl_ows_utils;


select *
from xwrl_alert_clearing_xref
where status <> 'SUCCESS'
order by id desc
;

SELECT
   req.id
 , req.batch_id
 , req.master_id
 , req.alias_id
 , req.xref_id
 ,req.source_table
 ,req.source_id
 , req.request
 , req.compressed_request
 , req.path
  , req.matches
 , req.name_screened
 , req.date_of_birth
 , req.gender
 ,req.country_of_registration
 , req.country_of_address
 , req.country_of_residence
 , req.country_of_nationality
 , req.country_of_birth
 , req.case_id
 , req.creation_date
 , req.last_update_date
 , status
 , req.job_id
 , req.error_message
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
--and batch_id = 74403 
and id = :p_request_id
ORDER BY
   req.id DESC;
   
select *
from xwrl_response_ind_columns
where request_id = :p_request_id
;


select *   
from xwrl_case_notes
where request_id = :p_request_id
order by id desc
;

select *
from xwrl_alert_notes
where request_id = :p_request_id
order by id desc
;

select *
from xwrl_alert_clearing_xref
where request_id = :p_request_id
order by id desc
;

select *
from iri_edocs
order by creation_date
;




select year, count(*), sum(space_allocation)
from 
(select EXTRACT( YEAR FROM creation_date) year , file_api.length(disk_path)/1024 space_allocation
from iri_edocs
where creation_date is not null)
group by year;


select EXTRACT( YEAR FROM creation_date) year , file_api.length(disk_path) file_size
from iri_edocs
where creation_date is not null
and  id = 4370016;

select *
from iri_edocs
where id = 4370016
order by creation_date
;

select *
from all_directories
where directory_name = 'VSSL'
;
/*
/irip/oracle_files/PROD/vessel_doc
/irip/oracle_files/PROD/vessel_doc/2847/General/2847-0001-001.pdf
/irip/oracle_files/PROD/vessel_doc/NRMI/24543/Vetting/24543-APPL-001.pdf

/iridr/oracle_files/DR/vessel_doc/NRMI/24830/Vetting/24830-COR-001.pdf
*/

select *
from iri_edocs
where id = 4370016
order by creation_date
;

select file_api.length(disk_path) file_size
from iri_edocs
where id = 4370016
;

file_api;

select file_api.length('/iridr/oracle_files/DR/vessel_doc/NRMI/24830/Vetting/24830-COR-001.pdf')/1024/1024 mb
from dual;


select EXTRACT( YEAR FROM creation_date) year , file_api.length(disk_path) space_allocation
from iri_edocs
where creation_date is not null
and EXTRACT( YEAR FROM creation_date) = 2008;

select year, count(*) number_of_files, round(sum(space_allocation) / 1024 / 1024 / 1024,2) space_allocation_gb
from (select EXTRACT( YEAR FROM creation_date) year , file_api.length(disk_path) space_allocation
from iri_edocs
where creation_date is not null
--and EXTRACT( YEAR FROM creation_date) = 2008
)
group by year;

xwrl_ows_utils;

rmi_ows_common_util;

select * from xwrl_alerts_debug
WHERE p_alert_id = :p_alert_id
order by id desc
;

select * from xwrl_alert_results_debug
WHERE p_request_id = :p_request_id
order by id desc;



select * from xwrl_alert_results_debug
WHERE p_request_id = :p_request_id
order by id desc;

select * from xwrl_alerts_debug
WHERE  p_alert_id in ('SEN-9988359')
order by  id desc
;

select * from xwrl_alert_results_debug
--WHERE  p_alert_id in ('SEN-9988359')
where p_request_id = 179054
order by  id desc
;

SELECT *
FROM mt_log
where upper(notes) like '%SEN-9988359%'
;

select *
from mt_log
order by log_id desc
;

SELECT *
FROM mt_log
where notes like 'Processing Alert ID: SEN-9988359%'
;

SELECT *
FROM mt_log
where notes like 'Changing Alert Id: SEN-9988359%'
;

select *
from mt_log
where log_id between 13756886 and 13756910
order by log_id desc
;

SELECT *
FROM xwrl_response_ind_columns
 where request_id  = 166774
 and  alertid = 'SEN-2190837'
order by id desc
;

--request id 41703
-- listid 3745898
-- alertid  SEN-9752127

select *
from xwrl_alert_notes
where  alert_id = 'SEN-2190837'
order by id desc;

--4593135

select * 
from xwrl_alert_clearing_xref
where request_id  = 166774
order by id desc
;

select * 
from xwrl_alert_clearing_xref
where alert_id = 'SEN-2190837'
order by id desc;

select *
from xwrl_requests
where id = 166774
;

select *
from xwrl_requests
where batch_id = 66838;

select * 
from xwrl_alert_clearing_xref
where master_id = 501830
order by id desc;

select *
from sicd_seafarers
where seafarer_id = 826655
;

delete from xwrl_alert_clearing_xref
where master_id = 501830;

select *
from xwrl_alert_notes
;

select *
from xwrl_alert_notes
;

select *
from mt_log
order by log_id desc
;

select count(*) from mt_log
;

select * from mt_log;


select *
from xwrl_alert_notes
;

select count(*)
from xwrl_alert_notes
;

select request_id, alert_id, line_number, note, count(*), max(id)
from xwrl_alert_notes
group by request_id, alert_id, line_number, note
having count(*) > 1
;

select count(*)
from (select request_id, alert_id, line_number, note, count(*), max(id)
from xwrl_alert_notes
group by request_id, alert_id, line_number, note
having count(*) > 1
)
;
-- 184010
select *
from xwrl_alert_notes
where request_id = 151481
and alert_id = 'SEN-9877902'
and line_number = 176090
;


declare
cursor c1 is select request_id, alert_id, line_number, note, count(*), max(id) max_id
from xwrl_alert_notes
--where request_id = 151481
--and alert_id = 'SEN-9877902'
--and line_number = 176090
group by request_id, alert_id, line_number, note
having count(*) > 1;

v_ctr integer;

begin

v_ctr := 0;

for c1rec in c1 loop

delete from xwrl_alert_notes
where request_id = c1rec.request_id
and alert_id = c1rec.alert_id
and line_number = c1rec.line_number
and id <> c1rec.max_id;

v_ctr := v_ctr + 1;

if v_ctr >= 10 then 
   commit;
   v_ctr := 0;
   dbms_output.put_line('v_ctr : '||v_ctr);
end if;

end loop;

commit;

dbms_output.put_line('v_ctr : '||v_ctr);

end;
/



select *
from xwrl_case_notes
;

select request_id
,case_id
,line_number
,note
,count(*)
,max(id)
from xwrl_case_notes
group by request_id
,case_id
,line_number
,note
having count(*) > 1;



declare
cursor c1 is 
select request_id
,case_id
,line_number
,note
,count(*)
,max(id) max_id
from xwrl_case_notes
group by request_id
,case_id
,line_number
,note
having count(*) > 1;

v_ctr integer;

begin

v_ctr := 0;

for c1rec in c1 loop

delete from xwrl_case_notes
where request_id = c1rec.request_id
and case_id = c1rec.case_id
and line_number = c1rec.line_number
and id <> c1rec.max_id;

v_ctr := v_ctr + 1;

if v_ctr >= 10 then 
   commit;
   v_ctr := 0;
   dbms_output.put_line('v_ctr : '||v_ctr);
end if;

end loop;

commit;

dbms_output.put_line('v_ctr : '||v_ctr);

end;
/

select *
from xwrl_requests
where id = 171815;

select *
from xwrl_case_documents
where request_id = 171815
order by id desc
;


select request_id
,case_id
,document_file
,document_type
,count(*)
,max(id) max_id
from xwrl_case_documents
group by request_id
,case_id
,document_file
,document_type
having count(*) > 1
;

select *
from xwrl_case_documents
where case_id = 'OWS-202001-150445-E4349E-IND'
and document_file = '/irip/oracle_files/PROD/seaf_doc/132/1329530/Application/1329530-0004-001.PDF'
order by 1
;

declare
cursor c1 is 
select request_id
,case_id
,document_file
,document_type
,count(*)
,max(id) max_id
from xwrl_case_documents
group by request_id
,case_id
,document_file
,document_type
having count(*) > 1;

v_ctr integer;

begin

v_ctr := 0;

for c1rec in c1 loop

delete from xwrl_case_documents
where request_id = c1rec.request_id
and case_id = c1rec.case_id
and document_file = c1rec.document_file
and document_type = c1rec.document_type
and id <> c1rec.max_id;

v_ctr := v_ctr + 1;

if v_ctr >= 10 then 
   commit;
   v_ctr := 0;
   dbms_output.put_line('v_ctr : '||v_ctr);
end if;

end loop;

commit;

dbms_output.put_line('v_ctr : '||v_ctr);

end;
/

select *
from corp_main
;

xwrl_utils;

select *
from xwrl_requests
--where id = 170537
where id between 170530 and 170540
;

select *
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
--and table_column = 'ID'
and table_id = 170537
--and table_id = 167803
--and new_value = 170537
order by 1 desc
;

select *
from xwrl_audit_log
where table_name = 'XWRL_CASE_NOTES'
--and table_column = 'ID'
--and table_id = 170537
--and table_id = 167803
--and new_value = '170537'
--order by 1 desc
and audit_log_id between 163932530 and 163932560
;

select *
from fnd_user
where user_id in (3290,6435)
;

select *
from xwrl_requests
where batch_id = 78279
;

select count(*)
from xwrl_alert_clearing_xref;

select count(*)
from wc_content;

select *
from xwrl_requests
order by id desc;

select *
from xwrl_party_master
;

select count(*)
from xwrl_party_master
;

select *
from xwrl_party_master
where source_table = 'SICD_SEAFARERS'
and source_id = 1322344
;

select source_table
,source_id
,full_name
,date_of_birth
,sex
,identifier
,count(*)
,max(id)
from xwrl_party_master
where entity_type = 'INDIVIDUAL'
group by source_table
,source_id
,full_name
,date_of_birth
,sex
,identifier
having count(*) > 1
;

xwrl_utils;


SELECT COUNT(*)
FROM (
select source_table
,source_id
,full_name
,date_of_birth
,sex
,count(*)
,max(id)
from xwrl_party_master
where entity_type = 'INDIVIDUAL'
group by source_table
,source_id
,full_name
,date_of_birth
,sex
having count(*) > 1)
;

select source_table
,source_id
,full_name
,date_of_birth
,sex
,identifier
,count(*)
,max(id)
from xwrl_party_master
where entity_type = 'INDIVIDUAL'
group by source_table
,source_id
,full_name
,date_of_birth
,sex
,identifier
having count(*) > 1
;



select count(*)
from (select source_table
,source_id
,full_name
,date_of_birth
,sex
,identifier
,count(*)
,max(id)
from xwrl_party_master
group by source_table
,source_id
,full_name
,date_of_birth
,sex
,identifier
having count(*) > 1)
;

select source_table
,source_id
,full_name
,date_of_birth
,sex
,count(*)
,max(id)
from xwrl_party_master
where entity_type = 'INDIVIDUAL'
group by source_table
,source_id
,full_name
,date_of_birth
,sex
having count(*) > 1
;


select id
,full_name
,family_name
,given_name
,date_of_birth
,sex
,imo_number
,passport_number
,passport_issuing_country_code
,citizenship_country_code
,country_of_residence
,city_of_residence_id
,source_table
,source_id
,identifier
,number_of_words
from xwrl_party_master
WHERE SOURCE_TABLE = 'CORP_MAIN'
AND SOURCE_ID = 1036344
AND FULL_NAME = 'EMANUELE A LAURO'
AND DATE_OF_BIRTH IS NULL
AND SEX = 'MALE'
;

SELECT *
From xwrl_party_master
WHERE SOURCE_TABLE = 'CORP_MAIN'
AND SOURCE_ID = 1036344
AND FULL_NAME = 'EMANUELE A LAURO'
AND DATE_OF_BIRTH IS NULL
AND SEX = 'MALE'
;

SELECT *
FROM XWRL_REQUESTS
WHERE MASTER_ID IN (527817
,3094)
;

select id
,full_name
||family_name
||given_name
||date_of_birth
||sex
||imo_number
||passport_number
||passport_issuing_country_code
||citizenship_country_code
||country_of_residence
||city_of_residence_id
||source_table
||source_id
||identifier
||number_of_words rec_key
from xwrl_party_master
;

select *
from xwrl_requests
--where name_screened = 'REGINA SAKHIPOVA';
where batch_id in (79843,79394,78336 )
;

select *
from xwrl_party_master
where full_name = 'REGINA SAKHIPOVA'
;



select *
from xwrl.xwrl_alert_clearing_xref
where alert_id = 'SEN-2193769'
order by id desc
;

delete from xwrl.xwrl_alert_clearing_xref
where alert_id = 'SEN-2193769';

select *
from xwrl_requests
where name_screened = 'JIE ZHANG'
order by id desc
;


delete from xwrl.xwrl_alert_clearing_xref
where alert_id = 'SEN-2193769';

 

 

delete from xwrl.xwrl_alert_clearing_xref
where 1=1
and master_id =531692
and list_id=2881958;

 
 xwrl_utils;
 xwrl_ows_utils;
 rmi_ows_common_util;
 
 
 select *
 from all_tables
 where table_name like '%SDN%'
 ;
 
 SELECT *
 FROM OFAC_SDN_VESSEL_LIST
 WHERE VESSEL_NAME = 'VOYAGER I'
 ;
 
 
 
 update xwrl_party_master

set country_of_residence = NULL

where country_of_residence = 'MR'

and ENTITY_TYPE = 'ORGANISATION'

and SOURCE_TABLE = 'CORP_MAIN'
;

DELETE from xwrl_party_xref a
where master_id =391497
and relationship_master_id not in (524312,524324,524325,528513,391497);

select *
from xwrl_response_ind_columns
where alertid = 'SEN-10041609'
;

update xwrl_response_ind_columns
set x_state = 'PEP - Open'
where alertid = 'SEN-10041609'
;

select unique entity_type from xwrl_party_master;

update xwrl.xwrl_party_master
set entity_type = 'ORGANISATION'
where id =605955;

select *
from sicd_countries
where country_name like '%TAI%'
or iso_description like '%Tai%'
;


select id, resubmit_id, status, creation_date, name_screened, master_id, case_state
from xwrl_requests
where status = 'ERROR'
order by id desc
;


select *
from xwrl_requests
where batch_id = 95004;


select *
from xwrl_party_master
where id = 607308
;



select *
from xwrl_party_master
where id = 542746
;

select *
from xwrl_response_ind_columns
where request_id = 208764
;

select *
from xwrl_requests
where batch_id = 95004;

select *
from xwrl_party_master
where id = 607308 -- Alphard Maritime Ltd.
;

select *
from xwrl_party_master
where id = 542746 -- TEJAS SHAH
;

select *
from xwrl_alert_clearing_xref
where master_id = 607308
and xref_id = 4863835
;

select *
from xwrl_party_xref
where id = 4863835
;

select *
from xwrl_alert_clearing_xref
where master_id = 542746
;


select *
from xwrl_alert_clearing_xref
where list_id = 358627;

select *
from xwrl.xwrl_alert_clearing_xref
where list_id = 358627
and master_id = 607308
and xref_id = 4863835
order by master_id desc
;

select *
from xwrl_party_master
where id in (607308,606985,568877,522416,216680,5675)
;

select *
from xwrl_alert_clearing_xref
where note = 'Client was an Account Executive with SuperMax in the UAE at the time listed'
order by master_id desc
;

select *
from xwrl_party_master
where full_name = 'TEJAS SHAH'
;

UPDATE  xwrl_party_master
SET END_DATE = SYSDATE
where full_name = 'TEJAS SHAH'
AND ID <> 542746;



WITH  ind_cat as ( select unique c.request_id request_id
 from xwrl_response_ind_columns c
 where c.category is null)
SELECT
   req.id
 , req.batch_id request_id
 , req.name_screened
 ,req.status
  ,req.matches
 , req.case_id
 , req.creation_date
 , req.last_update_date
 , status
 , case_status
 , case_state
 , case_workflow
 , req.created_by
 , fusr.user_name     created_user
 , req.last_updated_by
 , fusr2.user_name    update_user
FROM
   xwrl_requests  req
 , fnd_user       fusr
 , fnd_user       fusr2
 ,ind_cat
WHERE
       req.created_by = fusr.user_id (+)
   AND req.last_updated_by = fusr2.user_id (+)
   and req.matches <> 0
   and req.id = ind_cat.request_id
ORDER BY   req.batch_id desc, req.name_screened
;

WITH  ent_cat as ( select unique c.request_id request_id
 from xwrl_response_entity_columns c
 where c.category is null)
SELECT
   req.id
 , req.batch_id request_id
 , req.name_screened
 ,req.status
  ,req.matches
 , req.case_id
 , req.creation_date
 , req.last_update_date
 , status
 , case_status
 , case_state
 , case_workflow
 , req.created_by
 , fusr.user_name     created_user
 , req.last_updated_by
 , fusr2.user_name    update_user
FROM
   xwrl_requests  req
 , fnd_user       fusr
 , fnd_user       fusr2
 ,ent_cat
WHERE
       req.created_by = fusr.user_id (+)
   AND req.last_updated_by = fusr2.user_id (+)
   and req.matches <> 0
   and req.id = ent_cat.request_id
ORDER BY   req.batch_id desc, req.name_screened
;

select *
from xwrl_response_ind_columns
order by id desc
;


SELECT
   req.batch_id
   ,req.master_id
 ,REQ.NAME_SCREENED
 --,req.assigned_to
 --,req.edq_url
 --,req.status
  --,req.response
  --,req.matches
 --, req.soap_request
 /*
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
  , req.case_id
   , req.creation_date
 , req.last_update_date
  , status
 , case_status
 , case_state
 , case_workflow
 --, req.job_id
 --, req.error_message
*/
 --, req.created_by
 ,req.creation_date
 , fusr.user_name     created_user
 --, req.last_updated_by
 ,req.last_update_date
 , fusr2.user_name    update_user
FROM
   xwrl.xwrl_requests  req
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
and name_screened = 'BO WANG'
--and status = 'ERROR'
--and batch_id = 96783
ORDER BY   req.id desc
;

declare 
cursor c1 is
select c.id, c.case_status, c.case_state, c.case_workflow, c.category_restriction_indicator,  c.last_update_date
 ,r.case_status r_case_status, r.case_state r_case_state, r.case_workflow r_case_workflow,  r.category_restriction_indicator r_cat_restriction_indicator, r.last_update_date r_last_update_date
from xwrl_requests r
,xwrl.XWRL_REQUESTS_copy c
where r.id = c.id
and r.case_status != r.case_status
--and r.case_state !=  c.case_state
--and r.case_workflow != c.case_workflow
--and r.category_restriction_indicator != c.category_restriction_indicator
and r.last_update_date = c.last_update_date
--order by c.last_update_date desc

;

begin
xwrl_trg_ctx.disable_trg_ctx;

for c1rec in c1 loop

update xwrl_requests
set case_status = c1rec.case_status
,case_state = c1rec.case_state
,case_workflow = c1rec.case_workflow
where id = c1rec.id;

end loop;

--commit;

end;
/
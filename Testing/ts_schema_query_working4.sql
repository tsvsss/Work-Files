
select * from sicd_countries;

select iso_alpha2_code, iso_description, status , sanction_status
from sicd_countries
where sanction_status is not null
and sanction_status <> 'NONE'
;

select trunc(creation_date) creation_date, count(*) 
from xwrl_requests 
where trunc(creation_date) = trunc(sysdate)
group by trunc(creation_date)
order by 1 desc
;

SELECT *
FROM XWRL_PARAMETERS
WHERE ID = 'CASE_WORK_FLOW'
;

SELECT KEY, VALUE_STRING
FROM XWRL_PARAMETERS
WHERE ID = 'CASE_WORK_FLOW'
;



select TO_CHAR(creation_date,'MM/DD/YYYY') creation_date ,  count(*) 
from xwrl_requests 
where creation_date >= to_date('20191210 08:00 PM','YYYYMMDD HH:MI AM')
group by TO_CHAR(creation_date,'MM/DD/YYYY')
order by 1 desc
;

WITH workflow as
(SELECT KEY, VALUE_STRING, sort_order
FROM XWRL_PARAMETERS
WHERE ID = 'CASE_WORK_FLOW')
select TO_CHAR(xr.creation_date,'MM/DD/YYYY') creation_date ,  workflow.value_string case_workflow, count(*) 
from xwrl_requests  xr
,workflow
where case_workflow = workflow.key
and xr.creation_date >= to_date('20191210 08:00 PM','YYYYMMDD HH:MI AM')
group by TO_CHAR(xr.creation_date,'MM/DD/YYYY'), workflow.value_string, sort_order
order by 1 desc, workflow.sort_order
;

select *
from xwrl_requests
;

SELECT world_check_iface.get_city_tc_status (NULL) 
FROM DUAL;

select id, name_screened
from xwrl_requests
where source_table is null
;


select id, source_table, source_id, full_name
from xwrl_party_master 
where xwrl_utils.cleanse_name(full_name) = 'HIROMI SHIPPING CO  LTD'
;



declare
cursor c1 is
select id, name_screened
from xwrl_requests
where source_table is null;

v_source_table varchar2(100);
v_source_id varchar2(100);

begin



for c1rec in c1 loop

v_source_table := null;
v_source_id := null;

begin
select  source_table, source_id
into v_source_table, v_source_id
from xwrl_party_master 
where xwrl_utils.cleanse_name(full_name) = c1rec.name_screened;

if v_source_id is not null then

update xwrl_requests
set source_table = v_source_table
,source_id = v_source_id
where id = c1rec.id;

end if;

exception
when no_data_found then null;
end;

end loop;

end;
/


select *
from xwrl_requests
where source_table is null
;

select id, name_screened
from xwrl_requests
where source_table is null
;

select *
from WC_SCREENING_REQUEST
;


select *
from WC_SCREENING_REQUEST
where name_screened = 'SNF HARDWARE LIMITED'
;

select *
from WC_SCREENING_REQUEST
where name_screened = 'VISTAREACH MANAGEMENT LIMITED' -- 892389
;

select *
from WC_SCREENING_REQUEST
where xwrl_utils.cleanse_name(name_screened)  = 'VISTAREACH MANAGEMENT LIMITED' -- 892389
;

select *
from corp_main
where xwrl_utils.cleanse_name(corp_name1) = 'SNF HARDWARE LIMITED'
;

select *
from corp_main
--where xwrl_utils.cleanse_name(corp_name1) = 'VISTAREACH MANAGEMENT LIMITED'
where xwrl_utils.cleanse_name(corp_name1) like 'VISTAREACH%'
;

select *
from ar_customers
--where xwrl_utils.cleanse_name(customer_name) = 'VISTAREACH MANAGEMENT LIMITED'
where xwrl_utils.cleanse_name(customer_name) like 'VISTAREACH%'
;

select *
from WC_SCREENING_REQUEST
where name_screened = 'VISTAREACH MANAGEMENT LIMITED' -- 892389
;

select *
from WORLDCHECK_EXTERNAL_XREF
where wc_screening_request_id = 892389 --  'VISTAREACH MANAGEMENT LIMITED'
;


--CORP_MAIN	1109087	CORP_ID

update xwrl_requests
set source_table = 'CORP_MAIN'
,source_id = 1112654
where id = 6789;


select COUNT(*)
from xwrl_requests
where country_of_residence = 'RU'
and city_of_residence_id is not null
;

select *
from xwrl_requests
where country_of_residence = 'RU'
and city_of_residence_id is not null
;


select * from Wc_request_documents order by wc_request_documents_id desc;



SELECT * 
FROM WORLDCHECK_EXTERNAL_XREF
WHERE SOURCE_TABLE = 'SICD_SEAFARERS'
and source_table_id = 927051;


select * 
from WC_SCREENING_REQUEST
where wc_screening_request_id = 895102
;

select *
from xwrl_party_master
where SOURCE_TABLE = 'SICD_SEAFARERS'
and source_id = 927051;

select *
from xwrl_requests
where batch_id = 5172
;

select id, name_screened, city_of_residence, city_of_residence_id
from xwrl_requests
where batch_id = 5172
;

select *
from all_source
where lower(text) like '%x_state =%'
;

SELECT world_check_iface.get_city_tc_status (324) 
FROM DUAL;

select case_workflow, count(*)
from xwrl_requests
where city_of_residence_id is not null
group by case_workflow
;

select ID
from xwrl_requests
where city_of_residence_id is not null
and case_workflow = 'L'
;

select COUNT(*)
from xwrl_requests
where city_of_residence_id is not null
and case_workflow = 'SL' -- 490
;



declare
cursor c1 is
select ID
from xwrl_requests
where city_of_residence_id is not null
and case_workflow = 'L';

      V_return_code                     NUMBER;
      V_return_message                  VARCHAR2(4000);

begin

for c1rec in c1 loop

rmi_ows_common_util.approve_screening_request(c1rec.id, V_return_code, V_return_message);

end loop;

end;
/

SELECT *
FROM xwrl_requests
where case_state = 'E'
;


delete from xwrl_requests
where case_state = 'E'
;

SELECT *
FROM xwrl_party_alias
where end_date is not null
;

delete from xwrl_party_alias
where id in (316241,316242);

SELECT *
FROM xwrl_party_xref
where end_date is not null
;

delete from xwrl_party_xref
where id in (4366702,4366624);

select *
from xwrl_party_master
where id in (522834,260742)
;

select unique source_table, source_id, name_screened
from xwrl_requests
where case_state = 'E'
;


--      <ws:CustomString1>Seafarer ID</ws:CustomString1>
 --     <ws:CustomString2>1317841 - JULIO SAQUITON QUIBILAN, JR. -  PHILIPPINES</ws:CustomString2>

select *
from all_source
where text like '%CustomString1%'
;


select *
from xwrl_requests
where name_screened is null
and case_workflow <> 'H'
;

select count(*)
from xwrl_requests
where name_screened is null
and case_workflow = 'H'
--and source_id = 1317370
;

select *
from xwrl_requests
where name_screened is null
and case_workflow = 'H'
--and source_id = 1317370
;

WITH hold_rec as (
select UNIQUE SOURCE_TABLE, SOURCE_ID, SOURCE_TABLE||SOURCE_ID SOURCE_KEY
from xwrl_requests
where name_screened is null
and case_workflow = 'H')
SELECT UNIQUE xr.id, xr.SOURCE_TABLE, xr.SOURCE_ID, xr.SOURCE_TABLE||xr.SOURCE_ID SOURCE_KEY, CASE_WORKFLOW, NAME_SCREENED
FROM xwrl_requests xr
,hold_rec
where xr. SOURCE_TABLE||xr.SOURCE_ID = hold_rec.source_key
and xr.case_workflow <> 'H'
;

WITH hold as (
select UNIQUE SOURCE_TABLE, SOURCE_ID, SOURCE_TABLE||SOURCE_ID SOURCE_KEY
from xwrl_requests
where name_screened is null
and case_workflow = 'H')
,unhold as (
SELECT UNIQUE xr.id, xr.SOURCE_TABLE, xr.SOURCE_ID, xr.SOURCE_TABLE||xr.SOURCE_ID SOURCE_KEY, CASE_WORKFLOW, NAME_SCREENED
FROM xwrl_requests xr
where xr.case_workflow <> 'H')
select hold.SOURCE_KEY, unhold.source_key
from hold
,unhold
where hold.source_key = unhold.source_key (+)
and unhold.source_key is  null
;

select *
from xwrl_parameters
where id = 'CASE_STATE'
;

select *
from xwrl_parameters
where id = 'CASE_WORK_FLOW'
;

select *
from xwrl_requests
;

select id, source_table, 'SEAFARER_ID' source_table_column, source_id, request
from xwrl_requests
where name_screened is null
and case_workflow = 'H'
--and source_id = 1317370
;

select id, source_table, 'SEAFARER_ID' source_table_column, source_id, request
from xwrl_requests
where name_screened is null
and case_workflow = 'E'
--and source_id = 1317370
;

select *
from xwrl_requests
where name_screened is null
and case_workflow <> 'H'
;


declare

cursor c1 is
select id, source_table, source_id
from xwrl_requests
where name_screened is null
and case_workflow <> 'H'
;

begin

for c1rec in c1 loop

update xwrl_requests
set case_workflow = 'H'
,case_state = 'I'
,case_status = 'C'
,closed_date = null
where id = c1rec.id
;

end loop;

end;
/



select *
from sicd_seafarers
where seafarer_id = 1317370;


declare 
 cursor c1  is 
select id, source_table, 'SEAFARER_ID' source_table_column, source_id
from xwrl_requests
--where name_screened is null
--and case_workflow = 'H'
--and source_id = 1317370
where case_id = 'OWS-201912-110811-FCE1F7-IND'
   ;

   v_source_table varchar2(4000);
   v_source_table_column varchar2(4000);
   v_source_id varchar2(4000);

   x_batch_id integer;
   x_return_status varchar2(4000);
   x_return_msg varchar2(4000);

   v_max_jobs integer;

   v_result varchar2(20);

   begin


   for c1rec in c1  loop

      rmi_ows_common_util.create_batch_vetting (
                         p_source_table             => c1rec.source_table,
                          p_source_table_column      => c1rec.source_table_column,
                          p_source_id                => c1rec.source_id,
                          x_batch_id                 => x_batch_id,
                          x_return_status            => x_return_status,
                          x_return_msg               => x_return_msg
                          );

   end loop;                     

   end;
   /
   
   select count(*)
   from wc_content;
   
   select count(*)
   from xwrl_alert_clearing_xref
   ;
   
   select *
   from xwrl_alert_clearing_xref
   where source_table = 'SICD_SEAFARERS'
and source_id = 932769
and list_id = 3213935;

select *
from wc_content
where wc_content_id = 5628182
;

select *
from xwrl_requests
order by id desc
;

select *
from xwrl_requests
where batch_id = 6373
;


select *
from wc_city_list
where wc_city_list_id = 499
;

select *
from xwrl_requests
where case_state  = 'E'
;

RICARDO ABREA DOCTOR, JR.
RICARDO ABREA DOCTOR, JR.
RICARDO DOCTOR BARDE, JR.
RICARDO JR. ABREA DOCTOR
RICARDO JR. DOCTOR BARDE

SELECT *
FROM WC_SCREENING_REQUEST
WHERE NAME_SCREENED  like 'RIC%DOCTOR%'
;

select *
from xwrl_party_master
where full_name like 'GREAT LAKE%'
;

SELECT *
FROM XWRL_PARTY_MASTER
WHERE SOURCE_ID = 1321766
;

SELECT *
FROM XWRL_PARTY_ALIAS
WHERE MASTER_ID = 523743
ORDER BY CREATION_DATE DESC
;

delete from XWRL_PARTY_ALIAS
where id in (316546, 316450, 316449)
;

SELECT *
FROM XWRL_PARTY_XREF
WHERE MASTER_ID = 523743
;

SELECT *
FROM XWRL_AUDIT_LOG
--WHERE TABLE_NAME = 'XWRL_PARTY_ALIAS'
;


select *
from xwrl_requests
where case_state = 'E'
and id = 10393
;

-- Clean up YULGYE MOSCA

select * 
from xwrl.xwrl_party_master 
where source_id = 1215509
;

delete from xwrl_party_master
where id = 524167;

select * 
from xwrl.xwrl_party_alias
--where master_id = 524167
where master_id = 209377
;

select *
from xwrl_requests
;

select * 
from xwrl.xwrl_party_master 
where source_id =40390297
order by full_name
;

xwrl_ows_utils

select * 
from xwrl.xwrl_party_xref
--where master_id = 40390297
;



SELECT
   1
   , full_name
   , relationship_type
   , creation_date
FROM
   xwrl.xwrl_party_master
WHERE
   source_id = 40390297
--   AND xref_source_table is null
   AND relationship_type = 'Primary'
--order by full_name
UNION ALL
SELECT
   2
   , full_name
   , relationship_type
   , creation_date
FROM
   xwrl.xwrl_party_alias
WHERE
   master_id IN (
      SELECT
         id
      FROM
         xwrl.xwrl_party_master
      WHERE
         source_id = 40390297
   )
UNION ALL
SELECT
   3
   , full_name
   , b.relationship_type
   , b.creation_date
FROM
   xwrl.xwrl_party_xref     a
   , xwrl.xwrl_party_master   b
WHERE
   master_id IN (
      SELECT
         id
      FROM
         xwrl.xwrl_party_master
      WHERE
         source_id = 40390297
--                        AND XREF_SOURCE_TABLE IS NULL
         AND source_table = 'AR_CUSTOMERS'
   )
   AND master_id <> relationship_master_id
   AND a.relationship_master_id = b.id
ORDER BY
   full_name;


xwrl_ows_utils

select *
from xwrl_requests
--where id = 9508
where batch_id in (5484,5486,5487,6636,6641,6643)
order by batch_id desc, id desc
;

select *
from xwrl_requests
--where batch_id = 5600
where id = 9673
;



select source_table, source_id, list_id, note
from xwrl_alert_clearing_xref
;

select id, request_id, x_state, listid, casekey, alertid, creation_date, created_by, last_update_date, last_updated_by, last_update_login, 
from xwrl_response_ind_columns
where request_id = 9673
;

select xref.source_table, xref.source_id, xref.list_id, max(id)
from xwrl_alert_clearing_xref xref
where xref.source_table = 'SICD_SEAFARERS'
and xref.source_id = 1319508
group by xref.source_table, xref.source_id, xref.list_id
;

select ind.id, ind.request_id, ind.x_state, ind.listid, ind.casekey, ind.alertid, ind.creation_date, ind.created_by, ind.last_update_date, ind.last_updated_by, ind.last_update_login, xref.note
from xwrl_response_ind_columns ind
,xwrl_alert_clearing_xref xref
where ind.request_id = 9673
and ind.listid = xref.list_id
;


select xwrl_case_notes_seq.nextval into v_line_number from dual;

            insert into xwrl_alert_notes (
               request_id
               , alert_id
               , line_number
               , note
               , last_update_date
               , last_updated_by
               , creation_date
               , created_by
               , last_update_login
            ) VALUES (
               p_request_id
               , l_alert_out_tbl (i).alert_id
               , v_line_number
               , v_note
               , SYSDATE
               , p_user_id
               , SYSDATE
               , p_user_id
               , p_session_id
            );



select *
from xwrl_alert_notes
where request_id = 9673
;

select col.id, col.request_id, col.x_state, col.listid, col.casekey, col.alertid, col.creation_date, col.created_by, col.last_update_date, col.last_updated_by, col.last_update_login
from xwrl_response_ind_columns col
,xwrl_alert_notes n
where x_state not like '%Open'
and col.request_id = n.request_id (+)
and n.request_id is null
;

declare

cursor c1 is
select col.id, col.request_id, col.x_state, col.listid, col.casekey, col.alertid, col.creation_date, col.created_by, col.last_update_date, col.last_updated_by, col.last_update_login
from xwrl_response_ind_columns col
,xwrl_alert_notes n
where x_state not like '%Open'
and col.request_id = n.request_id (+)
and n.request_id is null
;

cursor c2 (p_list_id integer) is
select xref.source_table, xref.source_id, xref.list_id, max(id) max_id
from xwrl_alert_clearing_xref xref
where xref.source_table = 'SICD_SEAFARERS'
and xref.source_id = 1319508
and xref.list_id = p_list_id
group by xref.source_table, xref.source_id, xref.list_id
;            

v_line_number integer;
v_note varchar2(3000);

v_ctr integer;

begin

for c1rec in c1 loop

v_ctr := 0;

for c2rec in c2(c1rec.listid) loop

v_ctr := v_ctr + 1;

select note into v_note from xwrl_alert_clearing_xref where id = c2rec.max_id;

select xwrl_case_notes_seq.nextval into v_line_number from dual;

            insert into xwrl_alert_notes (
               request_id
               , alert_id
               , line_number
               , note
               , last_update_date
               , last_updated_by
               , creation_date
               , created_by
               , last_update_login
            ) VALUES (
               c1rec.request_id
               , c1rec.alertid
               , v_line_number
               , v_note
               , c1rec.last_update_date
               , c1rec.last_updated_by
               , c1rec.creation_date
               , c1rec.created_by
               , c1rec.last_update_login
            );
            
            if v_ctr >= 500 then
            commit;
            v_ctr := 0;
            end if;

end loop;

end loop;

commit;

end;
/

select *
from xwrl_alert_notes
;

select count(*)
from xwrl_response_ind_columns col
,xwrl_alert_notes n
where x_state not like '%Open'
and col.request_id = n.request_id (+)
and n.request_id is null
;

rmi_ows_common_util

iri_sicd_online

select *
from xwrl_alert_notes
where request_id = 1076;


select *
from xwrl_requests
where batch_id = 7023
;

select *
from xwrl_requests
where source_table = 'SICD_SEAFARERS'
and source_id = 1055837
order by batch_id desc
;

select *
from xwrl_requests
where batch_id = 3827
;

select *
from xwrl_response_entity_columns
where request_id = 5812
;



select *
from xwrl_parameters
where id = 'RESPONSE_ROWS'
ORDER BY sort_order
;


update  xwrl_parameters
set sort_order = 45
where id = 'RESPONSE_ROWS'
and key = 'Category'
;

select *
from xwrl_response_rows
where key = 'Category'
;


select *
from xwrl_requests
where batch_id = 6051
;

-- 5387319
-- 5387319	

select *
from xwrl_alert_clearing_xref
where source_table = 'SICD_SEAFARERS'
and source_id = 909792
--and list_id = 5387319
;

select *
from sicd_countries
where iso_alpha2_code = 'PK'
;



select *
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
;

select *
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
and table_id = 10418
order by audit_log_id desc
;


select *
from xwrl_response_ind_columns
;


select unique category
from xwrl_response_ind_columns
order by 1;


select *
from xwrl_response_ind_columns
where upper(additionalinformation) like '%HUMAN%'
;

SELECT *
from wc_content
;


SELECT *
from wc_content
--where upper(XML_RESPONSE) like '%HUMAN%'
where notes like '%human trafficker%'
;

SELECT wsr.wc_screening_request_id, wsr.status, wsr.name_screened, wsr.date_of_birth, wsr.passport_number, wc.note
from wc_content wc
,wc_screening_request wsr
where wc.wc_screening_request_id = wsr.wc_screening_request_id
--where upper(XML_RESPONSE) like '%HUMAN%'
and wc.notes like '%human trafficker%'
;


with old_xref as 
(SELECT wc_screening_request_id
from wc_content
where matchstatus in ( 'POSITIVE' , 'POSSIBLE')) 
select *
from xwrl_alert_clearing_xref xref
,old_xref
where xref.wc_screening_request_id = old_xref.wc_screening_request_id;


declare
cursor c1 is
SELECT wc_screening_request_id
from wc_content
where matchstatus in ( 'POSITIVE' , 'POSSIBLE');

v_ctr integer;

BEGIN

v_ctr := 0;

for c1rec in c1 loop

delete from xwrl_alert_clearing_xref
where wc_screening_request_id = c1rec.wc_screening_request_id;

v_ctr := v_ctr + 1;

if v_ctr >= 500 then
commit;
v_ctr := 0;
end if;

end loop;

commit;

end;
/

select *
from tmp_alert;




select *
from xwrl_requests
--where batch_id = 11091
--where batch_id = 11112
where batch_id  = 11745
and case_status = 'O'
order by id desc
;

select rmi_ows_common_util.get_department(22987)
from dual;

xwrl_utils

select *
from corp_main
where corp_id = 1080856
;

select *
from xwrl_request_ind_columns
where request_id = 21679
;



xwrl_utils

select *
from xwrl_party_master
where source_table = 'CORP_MAIN'
and source_id = 1112729
AND FULL_NAME = 'MUHAMMAD ALI LAKHANI'
;




-- 527194

DELETE FROM XWRL_PARTY_MASTER
WHERE ID IN (525679,527205,527204);

select *
from wc_screening_request
where wc_screening_request_id = 906235
;

select *
from worldcheck_external_xref
where source_table = 'SICD_SEAFARERS'
and source_table_id = 1306428
order by creation_date desc
;

select *
from wc_content
where wc_screening_request_id = 906235
order by notes
;


select *
from worldcheck_external_xref_seaf
order by creation_date desc
;

select *
from fnd_user
;

select *
from all_triggers
where owner NOT IN ( 'APPS' , 'SYSTEM' )
and table_owner not in ('CORP','SICD', 'VSSL' , 'CUS' ,'EXSICD', 'XLONO', 'XWRL', 'XLGL', 'XWRLC', 'YACHT')
ORDER BY owner
;

select *
from xwrl_requests
--where error_code is not null
where department_ext like '%1319222%'
order by id 
;

select *
from xwrl_requests
;

select *
from xwrl_party_master
where wc_screening_request_id is nullorder by 1
;

xwrl_utils

SELECT xr.name_screened, xp.full_name, XWRL_NAME_UTILS.same_name( xr.name_screened, xp.full_name) same_name, xr.source_table, xr.source_id, xr.batch_id,  xr.ID , xr.master_id, xref_id, alias_id, xp.ID master_id_upd
  FROM xwrl_requests xr, xwrl.xwrl_party_master xp
 WHERE xr.master_id IS NULL
   AND xr.source_table = 'SICD_SEAFARERS'
   AND xp.source_id = xr.source_id
   AND xp.source_table = xr.source_table
   ;
   
SELECT xr.name_screened, xp.full_name, XWRL_NAME_UTILS.same_name( xr.name_screened, xp.full_name) same_name, xr.source_table, xr.source_id, xr.batch_id,  xr.ID , xr.master_id, xref_id, alias_id, xp.ID master_id_upd
  FROM xwrl_requests xr, xwrl.xwrl_party_master xp
 WHERE xr.master_id IS NULL
   --AND xr.source_table = 'SICD_SEAFARERS'
   AND xp.source_id = xr.source_id
   AND xp.source_table = xr.source_table
   and  XWRL_NAME_UTILS.same_name( xr.name_screened, xp.full_name) = 'Y';
   
select count(*)
from xwrl_requests
;

-- 23435
-- 21838
   
SELECT count(*)
  FROM xwrl_requests xr, xwrl.xwrl_party_master xp
 WHERE xr.master_id IS NULL
   --AND xr.source_table = 'SICD_SEAFARERS'
   AND xp.source_id = xr.source_id
   AND xp.source_table = xr.source_table
   and  XWRL_NAME_UTILS.same_name( xr.name_screened, xp.full_name) = 'Y';

xwrl_ows_utils

drop table tmp_err_log;

create table tmp_err_log 
(request_id integer
, alert_id varchar2(100)
, err_message varchar2(4000));


select *
from tmp_err_log;


select *
from xwrl_requests
where status =  'ERROR'
order by id desc;


select count(*)
from xwrl_requests
;

select count(*)
from xwrl_requests
where master_id is  null
;

select *
from xwrl_requests
where master_id is  null
order by id desc;

select name_screened
from xwrl_requests
where master_id is  null;


select *
from xwrl_party_master
where full_name = 'MAJID ALI ANSARI'
;


select *
from xwrl_requests
where status = 'ERROR'
;

select *
from xwrl_requests
where batch_id = 1055
;


select *
from xwrl_requests
where name_screened = 'MOHD AKHLAQ KHAN'
/

select *
from xwrl_requests
where case_workflow = 'L'
and case_status = 'O'
--and batch_id = 19112
and source_table like 'NRMI%'
;



select UNIQUE BATCH_ID
from xwrl_requests
where case_workflow = 'L'
and case_status = 'O'
--and batch_id = 19112
and source_table like 'NRMI%'
ORDER BY BATCH_ID DESC
;

SELECT unique department
FROM XWRL_REQUESTS
;

--VESDOC


update xwrl_requests
set department = 'VESDOC'
where source_table like 'NRMI%'
and department is null;

select *
from xwrl_requests
where batch_id = 13731;

select *
from xwrl_requests
where id = 27413
;

SELECT *
FROM XWRL_RESPONSE_ENTITY_COLUMNS
WHERE REQUEST_ID = 27413
;


select *
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
and table_id = 27413
ORDER BY AUDIT_LOG_ID DESC
;


select *
from xwrl_audit_log
where table_name = 'XWRL_RESPONSE_ENTITY_COLUMNS'
and table_id = 13434
ORDER BY AUDIT_LOG_ID DESC
;

select *
from xwrl_requests
where name_screened = 'MANOJ TYAGI'
and source_id = 18228
;

select *
from nrmi_certificates
--where nrmi_certificates_id = 18228
;

select *
from xwrl_parameters
where id = 'PATH'
;

select *
from xwrl_requests
--where batch_id is null
--and case_status = 'O'
--where name_screened = upper('Oleg Rudenko')
order by id desc
;


select *
from xwrl_parameters
where id like 'CASE%'
AND VALUE_STRING = 'Approved'
;

select id, batch_id, case_id, name_screened, status, case_status, case_state, case_workflow
from xwrl_requests
where batch_id = 24072
;

/*update xwrl_requests
set case_state = 'A'
,case_workflow = 'A'
where batch_id = 24072;*/


WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.batch_id, req.case_state, req.case_status, req.case_workflow,  col. listfullname, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
,xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
,decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ebs_level
,decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ows_level
, ows_req.current_state ows_state, col.alertid, col.listrecordtype, col.creation_date, col.listid
from xwrl_response_ind_columns col
,xwrl_requests req
,ows_req
where col.request_id = req.id 
and col.alertid = ows_req.EXTERNAL_ID
and req.case_state not IN ('D')
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE)
order by ebs_status
;


select *
from xwrl_party_master
where id = 321162
;

select *
from xwrl_requests
where id = 20209
;

select *
from xwrl_response_ind_columns
where request_id = 20209
and alertid = 'SEN-9718656'
;

select *
from xwrl_alert_clearing_xref
where source_table = 'SICD_SEAFARERS'
and source_id = '1134856'
--and list_id = 5409703
and alert_id =  'SEN-9718656'
order by id desc
;



select count(*)
from xwrl_requests
where source_table is null
;

select *
from xwrl_requests
where source_table is null
order by id desc
;

select *
from xwrl_requests
where batch_id = 28277 ;

select *
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
and table_id = 58262
order by audit_log_id desc
;

select *
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
and table_id = 58263
order by audit_log_id desc
;





select *
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
and table_id = 58264
order by audit_log_id desc
;

select *
from xwrl_audit_log
where table_name = 'XWRL_RESPONSE_IND_COLUMNS'
and table_id = 86151
order by audit_log_id desc
;


select *
from xwrl_requests
where name_screened = 'VLADIMIR EVGENIEVICH VOLKOV'
order by batch_id desc, id desc
;


select * from xwrl_document_reference
order by sort_key desc;

select * from xwrl_document_reference
ORDER BY ID DESC;

SELECT xwrl_doc_reference_seq.nextval FROM DUAL;

ALTER sequence xwrl.xwrl_doc_reference_seq increment by 1000;

ALTER sequence xwrl.xwrl_doc_reference_seq increment by 1;

Insert into XWRL.XWRL_DOCUMENT_REFERENCE (DEPARTMENT,CODE,DESCRIPTION,REPORT_DESCRIPTION,PRIORITY_LEVEL,SORT_KEY,LAST_UPDATE_DATE,LAST_UPDATED_BY,CREATION_DATE,CREATED_BY,LAST_UPDATE_LOGIN) 
values ('VESDOC','NRMI','NRMI','NRMI','High',1420,SYSDATE,1156,SYSDATE,1156,null);

select *
from XWRL_DOCUMENT_REFERENCE
where department = 'VESDOC'
and CODE = 'NRMI'
;


SELECT apps.rmi_ows_common_util.get_sanction_status('US')
FROM dual;

select *
from xwrl_case_notes
order by id desc
;

insert into xwrl_case_notes
(id, request_id, case_id, line_number, note)
values
(90000,57545,'OWS-202001-200711-5B241C-IND',90000,'This is a test')
;

delete from xwrl_case_notes
where id = 90000;

select *
from xwrl_requests
where batch_id = 14882
--where case_id = 'OWS-201912-262044-78C511-IND'
;



select *
from xwrl_case_notes
order by id desc
;

29783
29783
54240
60373
63916
63916


SEN-2113980
SEN-2113970

select *
from xwrl_alert_notes
where request_id = 29783
order by id desc
;


select *
from xwrl_response_ind_columns
where request_id = 29783
--and rec = 20
and rec in (56,59)
;

select *
from xwrl_response_ind_columns
where listid in (2895074,393114)
order by id desc
;

select *
from xwrl_alert_clearing_xref
where request_id = 29783
order by id desc
;

select *
from (select * from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
union
select * from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com 
)
where external_id = 'SEN-2113928'
;

alter sequence xwrl.XWRL_ALERT_NOTES_LINE_SEQ increment by 70000;

select XWRL_ALERT_NOTES_SEQ.nextval XWRL_ALERT_NOTES_SEQ from dual;

select XWRL_ALERT_NOTES_LINE_SEQ.nextval XWRL_ALERT_NOTES_LINE_SEQ from dual;
 
select XWRL_CASE_NOTES_SEQ.nextval XWRL_CASE_NOTES_SEQ from dual;
 
select XWRL_CASE_NOTES_LINE_SEQ.nextval XWRL_CASE_NOTES_LINE_SEQ from dual;

alter sequence xwrl.XWRL_ALERT_NOTES_LINE_SEQ increment by 1;


XWRL_OWS_UTILS

select * 
from xwrl_alert_clearing_xref
order by id desc
;

alter table xwrl.xwrl_alert_clearing_xref modify
( SOURCE_TABLE null
,source_id null);

select *
from xwrl_response_ind_columns
where id  = 88754;


select *
from fnd_user
;

select *
from RMI_SEAFARER.RMI_USER
;

select *
from xwrl_case_notes note
;

select *
from xwrl_alert_notes
;

select col.*
from xwrl_response_ind_columns col
,fnd_user usr
where col.created_by = usr.user_id 
and col.request_id = 69013;            


select xref.*
from xwrl_alert_clearing_xref xref
,fnd_user usr
where xref.created_by = usr.user_id 
and xref.request_id = 69013
;

xwrl_ows_utils


select *
from xwrl_requests
where matches <> 0
and path = 'INDIVIDUAL'
;
/*
Request 14671     34282
List 4015345
*/
SELECT col.ID, col.request_id, r.source_table, r.source_id,
                col.listid, col.alertid, col.x_state
                                                    --, col.listrecordtype||' - False Positive' to_state\
                                                    --SAURABH 13-JAN-2020
                , CLEAR.to_state
                                --,clear.to_state
                , CLEAR.note
           FROM xwrl_response_ind_columns col,
                xwrl_requests r,
                (WITH max_tab AS
                      (SELECT   --x.source_table, x.source_id, x.list_id,
                                x.master_id, x.alias_id, x.xref_id, 
                                x.list_id,
                                MAX (ID) ID
                           FROM xwrl_alert_clearing_xref x
                       --GROUP BY x.source_table, x.source_id, x.list_id
                       GROUP BY x.master_id, x.alias_id, x.xref_id, x.list_id
                       )
                 SELECT x.source_table, x.source_id, x.list_id, x.to_state,
                        x.note,
                        x.master_id, x.alias_id, x.xref_id
                   FROM xwrl_alert_clearing_xref x, max_tab
                  WHERE 1=1
--                    AND x.source_table = max_tab.source_table
--                    AND x.source_id = max_tab.source_id
                    AND x.master_id = max_tab.master_id
                    AND NVL(x.alias_id,-99)  = NVL(max_tab.alias_id,-99)
                    AND NVL(x.xref_id,-99)   = NVL(max_tab.xref_id,-99)
                    AND x.ID = max_tab.ID) CLEAR
          WHERE col.request_id = r.ID
--            AND r.source_table = CLEAR.source_table
--            AND r.source_id = CLEAR.source_id
            AND r.master_id = CLEAR.master_id
            AND NVL(r.alias_id,-99)  = NVL(CLEAR.alias_id,-99)
            AND NVL(r.xref_id,-99)   = NVL(CLEAR.xref_id,-99)
            AND col.listid = CLEAR.list_id
            AND col.request_id = :request_id
            ;


/* Case Level Search  */

select req.id, req.batch_id, req.case_id,  req.master_id, req.alias_id, req.xref_id, req.name_screened, req.case_status, req.case_state, req.case_workflow, req.created_by, req.creation_date, usr.user_name
from xwrl_requests req
,fnd_user usr
where req.created_by = usr.user_id 
and req.id = :request_id
;

/* Case Level Search - Note */

select note.id, note.request_id, note.line_number, note.note, note.created_by, note.creation_date, usr.user_name
from xwrl_case_notes note
,fnd_user usr
where note.created_by = usr.user_id 
and note.request_id = :request_id
order by note.id desc
;

/* Alert Level Search - Individual */
          
select col.ID, col.request_id, col.listid, col.listrecordtype, col.listfullname, col.listnametype, col.matchrule, col.x_state, substr(col.x_state, 7)  x_type, col.created_by, col.creation_date, usr.user_name
from xwrl_response_ind_columns col
,fnd_user usr
where col.created_by = usr.user_id 
and col.request_id = :request_id
order by col.id desc
;

/* Alert Level Search - Note */

select note.id, note.request_id, note.alert_id, note.line_number, note.note, note.created_by, note.creation_date, usr.user_name
from xwrl_alert_notes note
,fnd_user usr
where note.created_by = usr.user_id 
and note.request_id = :request_id
order by note.id desc
;

/* Alert Level Search - Cross Reference */

select xref.id, xref.request_id, xref.alert_id, xref.list_id, xref.from_state, xref.to_state, xref.note, xref.master_id, xref.alias_id, xref.xref_id, xref.created_by, xref.creation_date, usr.user_name
from xwrl_alert_clearing_xref xref
,fnd_user usr
where xref.created_by = usr.user_id 
--and xref.request_id = :request_id
and xref.master_id = :master_id
and nvl(xref.alias_id,99) = nvl(:alias_id,99)
and nvl(xref.xref_id,99) = nvl(:xref_id,99)
and xref.list_id = :list_id
--order by xref.id desc
order by list_id desc, id desc
;


SELECT apps.rmi_ows_common_util.get_ows_alert_state ('SEN-9788210')
  FROM DUAL;

SELECT apps.rmi_ows_common_util.get_ows_alert_state ('SEN-9788209')
  FROM DUAL;  
  
  DECLARE

   l   xwrl_alert_tbl_in_type;

   i   NUMBER                 := 0;

BEGIN

   l := xwrl_alert_tbl_in_type();

   FOR rec IN (SELECT *

                 FROM xwrl_response_entity_columns

                WHERE request_id = 70521

                AND alertid = 'SEN-9788209')

   LOOP

      i := i + 1;

      l.EXTEND;

     

      l (i) :=

              xwrl_alert_in_rec (rec.alertid,

                                'EDD - Possible',

                                'test'

                               );

                              

--      l (i).p_alert_id := rec.alertid;

--      l (i).p_to_state := rec.x_state;

--      l (i).p_comment := 'test';

   END LOOP;

 

   xwrl_ows_utils.process_alerts (p_user_id         => 0,

                                  p_session_id      => 999,

                                  p_request_id      => 1906,

                                  p_alert_tab       => l

                                 );

END;
/


select *
from (select * from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
union
select * from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com 
)
--where external_id = 'SEN-2113928'
--where key_label like 'OWS-202001-281647-19C175-IND%'
where key_label like 'OWS-202001-291139-0D143A-IND%'
order by id desc
;

SELECT case_id
FROM XWRL_REQUESTS
--WHERE CASE_ID = 'OWS-202001-281647-19C175-IND'
where case_id is not null
order by case_id desc
;


select *
from (select * from IRIP1_EDQCONFIG.dn_casehistory@ebstoows2.coresys.com 
union
select * from IRIP2_EDQCONFIG.dn_casehistory@ebstoows2.coresys.com 
);

select *
from sicd_seafarers
--where seafarer_id = 1329356
--where seafarer_id = 1328700
where last_name = 'SUKHSAMPAT SINGH'
;

select *
from exsicd_seafarers_iface
--where seafarer_id = 1329356
where seafarer_id = 1328700
--where last_name = 'SUKHSAMPAT SINGH'
;



select *
from xwrl_party_master
where full_name like '%SUKHSAMPAT SINGH'
--where id = 1329356
;

select *
from fnd_user
where user_id =10100
;


WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.batch_id, req.case_state, req.case_status, req.case_workflow,  col. listfullname, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
,xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
,decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ebs_level
,decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ows_level
, ows_req.current_state ows_state, col.alertid, col.listrecordtype, col.creation_date, col.listid
from xwrl_response_ind_columns col
,xwrl_requests req
,ows_req
where col.request_id = req.id 
and col.alertid = ows_req.EXTERNAL_ID
and req.case_state not IN ('D')
and col.alertid 
in (
'SEN-9788211'
,'SEN-9788212'
,'SEN-9788206'
,'SEN-9788205'
,'SEN-9788207'
,'SEN-9788208')
;

WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.batch_id, req.case_state, req.case_status, req.case_workflow,  col. listentityname, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
, xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
,decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ebs_level
,decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ows_level
, ows_req.current_state ows_state, col.alertid, col.listrecordtype, col.creation_date, col.listid
from xwrl_response_entity_columns col
,xwrl_requests req
,ows_req
where col.request_id = req.id 
and col.alertid = ows_req.EXTERNAL_ID
and req.case_state not IN ('D')
and col.alertid 
in (
'SEN-9788211'
,'SEN-9788212'
,'SEN-9788206'
,'SEN-9788205'
,'SEN-9788207'
,'SEN-9788208')
;

xwrl_data_processing;

SELECT *
FROM xwrl_requests
where batch_id = 1425
--and city_of_residence_id is not null
--and city_of_residence is not null
;


SELECT count(*)
FROM xwrl_requests
;


SELECT count(*)
FROM xwrl_response_ind_columns
;




select *
from xwrl_party_master
where full_name like 'MAR%MOORE%'
;


select *
from xwrl_party_master
where full_name like 'NZ TRUST %'
;

select *
from xwrl_party_xref
--where master_id = 535542
where relationship_master_id = 535542
;

select mast.full_name
from xwrl_party_xref xref
,xwrl_party_master mast
where xref.relationship_master_id = 535542
and xref.master_id = mast.id
order by 1
;

select *
from xwrl_party_master
where full_name = 'MARGARET MOORE'
;

select *
from xwrl_requests
where batch_id = 24297
;

select *
from xwrl_requests
where batch_id = 30422
;

select *
from xwrl_requests
where name_screened = 'MARGARET MOORE'
order by master_id
;


select *
from xwrl_party_master
where id in (select master_id
from xwrl_requests
where name_screened = 'MARGARET MOORE')
order by id
;
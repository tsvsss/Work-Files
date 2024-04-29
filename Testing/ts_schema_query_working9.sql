xwrl_utils;
xwrl_ows_utils;
rmi_ows_common_util;

select *
from xwrl_requests
where id = 233121;

SELECT c.*
FROM xwrl_response_ind_columns c
where request_id = 233121
--where exists (select 1 from xwrl_requests r where r.id = c.request_id and batch_id =  107313)
--and alertid = 'SEN-10205455' 
--and listid = 4962534 
;

select *
from xwrl_alerts_debug;


select length('Address_Confirmation_Date') from dual;

alter table xwrl.xwrl_requests add (address_confirmation_date date);
alter table xwrl.xwrl_party_master add (address_confirmation_date date);


SELECT SYS_CONTEXT('xwrl_ctx', 'disable_trigger') FROM dual;
exec xwrl_trg_ctx.disable_trg_ctx;
exec xwrl_trg_ctx.enable_trg_ctx;


UPDATE xwrl_requests req

   SET created_by = last_updated_by,

       office =

          (SELECT code

             FROM vssl_offices

            WHERE salesrep_id =

                     fnd_profile.value_specific

                                             (NAME         => 'ONT_DEFAULT_PERSON_ID',

                                              user_id      => req.last_updated_by

                                             )

              AND ENABLE = 'Y')

WHERE created_by IS NULL AND last_updated_by IS NOT NULL;

rmi_ows_common_util

select *
from xwrl_requests
where status =  'ERROR'
;

select *
from mt_log
order by log_id desc
;

select *
from xwrl_requests
where master_id = 606812
;

select *
from xwrl_requests
where batch_id = 93756
;

select *
from xwrl_party_xref
where id =4866883;

update xwrl.xwrl_party_xref
set end_date = NULL
where id =4866883;

select *
from corp_main
where corp_number = '99757'
;

select *
from xwrl_party_master
where source_table = 'CORP_MAIN'
and source_id = 1106518
;


select *
from xwrl_party_master
where full_name = upper('Tomini Majesty Limited')
;

select *
from xwrl_party_master
where id = 362426
;

select *
from xwrl_party_master
where id = 362427
;

select *
from xwrl_party_master
where id = 610943
;


select *
from xwrl_party_xref
where master_id = 362426
;

select *
from xwrl_party_xref
where relationship_master_id = 362426
;

select *
from xwrl_requests
where master_id = 362426
;


select *
from xwrl_requests
where batch_id = 103265
--where id = 225296
;

select *
from xwrl_response_ind_columns
where request_id = 225296
;

select *
from xwrl_alert_clearing_xref
where master_id = 362427
;

select *
from wc_content
;

select *
from xwrl_requests
where case_status = 'O' 
and case_workflow in ( 'L', 'SL' )
and matches >= 50
;

select count(*)
from xwrl_requests
where case_status = 'O' 
and case_workflow in ( 'L', 'SL' )
and matches >= 50
;



WITH req as (select id
from xwrl_requests
where case_status = 'O' 
and case_workflow in ( 'L', 'SL' )
and matches >= 50)
select *
from xwrl_response_ind_columns ind
,req
where ind.request_id = req.id
and substr(x_state,7) = 'Open'
;

select xref.*, mst.full_name
from xwrl_alert_clearing_xref xref
,xwrl_party_master mst
where xref.master_id =  mst.id
and list_id = 4854933 -- LI JIANFENG
;

select *
from wc_screening_request;

select id, matches, name_screened, date_of_birth, master_id, alias_id, xref_id
from xwrl_requests
where case_status = 'O' 
and case_workflow in ( 'L', 'SL' )
and matches >= 50
and alias_id is null
and xref_id is null; -- JIAN YANG LI

select *
from xwrl_response_ind_columns;

select surname, given_name
from wc_content;

select *
from xwrl_requests;

select *
from wc_content;

select *
from WC_SCREENING_REQUEST;

WITH req as (select  id, matches, name_screened, date_of_birth, country_of_residence, passport_number, master_id, alias_id, xref_id
from xwrl_requests
where case_status = 'O' 
and case_workflow in ( 'L', 'SL' )
and matches >= 50
and alias_id is null
and xref_id is null)
select ind.request_id, ind.x_state, ind.rec, ind.listid, ind.listfamilyname,ind.listgivennames, ind.listfullname, ind.listnametype, ind.listprimaryname, req.name_screened,req.master_id, req.alias_id, req.xref_id
from xwrl_response_ind_columns ind
,req
where ind.request_id = req.id
and substr(x_state,7) = 'Open'
order by listid desc -- 985952 (Found this ID to search the old system)
;

-- KUMAR	Rakesh
select wc.matchscore, wc.matchstatus, wc.matchtype, wc.surname, wc.given_name,wc.notes, wr.status, wr.name_screened, wr.date_of_birth, wr.passport_issuing_country_code, wr.passport_number
from wc_content wc
,wc_screening_request wr
where wc.wc_screening_request_id = wr.wc_screening_request_id
and substr(wc.matchentityidentifier,10) = 985952
and wc.surname = 'KUMAR' -- Could use ind.listfamilyname
and upper(wc.given_name) = 'RAKESH'  -- Could use ind.listgivennames
and wr.name_screened = 'RAKESH KUMAR MEENA' -- Could use req.name_screened
;




update xwrl_party_master

set country_of_residence =RMI_OWS_COMMON_UTIL.get_country_iso_code(country_of_residence),

CITIZENSHIP_COUNTRY_CODE =RMI_OWS_COMMON_UTIL.get_country_iso_code(CITIZENSHIP_COUNTRY_CODE),

PASSPORT_ISSUING_COUNTRY_CODE = RMI_OWS_COMMON_UTIL.get_country_iso_code(CITIZENSHIP_COUNTRY_CODE)

where (length(country_of_residence) =4 OR length(CITIZENSHIP_COUNTRY_CODE) =4 OR length(CITIZENSHIP_COUNTRY_CODE) =4)
;
 

update xwrl_party_alias

set country_of_residence =RMI_OWS_COMMON_UTIL.get_country_iso_code(country_of_residence),

CITIZENSHIP_COUNTRY_CODE =RMI_OWS_COMMON_UTIL.get_country_iso_code(CITIZENSHIP_COUNTRY_CODE),

PASSPORT_ISSUING_COUNTRY_CODE = RMI_OWS_COMMON_UTIL.get_country_iso_code(CITIZENSHIP_COUNTRY_CODE)

where (length(country_of_residence) =4 OR length(CITIZENSHIP_COUNTRY_CODE) =4 OR length(CITIZENSHIP_COUNTRY_CODE) =4)
;

select *
from xwrl_requests 
where batch_id = 104942
;

select *
from xwrl_requests 
--where batch_id = 104942
--and id = 228601
where master_id = 611708
order by id desc
;
select *
from xwrl_response_entity_columns
where request_id = 228601
;

select *
from xwrl_alert_clearing_xref
--where  request_id = 228601
--and list_id = 1213261
where master_id = 611708
;


select *
from mt_log
where notes = 'Update xwrl_response_ind_columns '
--where notes like '%227804%'
;
select *
from mt_log
where notes like 'Insert xwrl_alert_notes - request_id:  '|| 227541 ||'%'
;

select *
from mt_log
where log_id between 18902237 and 18902255
order by log_id desc
;



select *
from xwrl_alert_clearing_xref
where alert_id = 'SEN-10193277'
order by id desc;

select *
from xwrl_alert_results_debug
where p_alert_id = 'SEN-10193277'
order by id desc
;

select *
from mt_log
where notes = 'Update ENTITY Update xwrl_response_entity_columns '
--where notes like '%227804%'
;

select *
from mt_log
--where notes like '%227804%'
where log_id between 18825680 and 18825750
order by log_id desc
;



select *
from xwrl_requests 
where id = 227804 --4340
;


select *
from tmp_xwrl_alerts
where p_alert_id = 'SEN-10194119'
;

select * 
from tmp_xwrl_alert_results
where p_alert_id = 'SEN-10194119'
;

select *
from xwrl_alert_notes
where alert_id =  'SEN-10194119'
;





select *
from xwrl_alert_clearing_xref
where master_id = 611708
--and xref_id = 4868485
order by id desc
;


WITH req as (select id
from xwrl_requests
where case_status = 'O' 
and case_workflow in ( 'L', 'SL' )
and matches >= 50)
select *
from xwrl_response_ind_columns ind
,req
where ind.request_id = req.id
and substr(x_state,7) = 'Open'
;

select *
from xwrl_requests
where case_status = 'O' 
and case_workflow in ( 'L', 'SL' )
order by id desc
;

select *
from xwrl_alert_notes
;

select  r.id, r.batch_id, r.matches, r.name_screened, r.date_of_birth, r.country_of_residence, r.passport_number, cols.rec, cols.x_state, cols.alertid, r.case_id, n.line_number, n.note, n.last_updated_by, u.user_name
from xwrl_response_ind_columns cols
,xwrl_requests r
,xwrl_alert_notes n
,fnd_user u
where cols.request_id = r.id
and cols.request_id = n.request_id
and cols.alertid = n.alert_id
and cols.last_updated_by = u.user_id
and cols.last_update_login = 999
order by batch_id, rec
;

select r.id
from xwrl_requests r
where r.case_status = 'O'
and r.case_workflow in ( 'L', 'SL' )
and r. matches >= 50
;

select *
from xwrl_alert_clearing_xref
order by id desc
;
select *
from xwrl_alert_clearing_xref
where master_id = 100638
and list_id = 2605886
;

select *
from xwrl_party_master
;

select *
from sicd_countries
;

select country_code, iso_alpha2_code
from sicd_countries
;

select *
from wc_screening_request
;

select *
from wc_content
;

select *
from xwrl_response_ind_columns
;

WITH req as (select  r.id, r.matches, r.name_screened, r.date_of_birth, r.country_of_residence, r.passport_number, r.master_id, r.alias_id, r.xref_id
,mst.passport_issuing_country_code, mst.passport_number mst_passport_number
from xwrl_requests r
,xwrl_party_master mst
where r.master_id = mst.id 
and r.case_status = 'O' 
and r.case_workflow in ( 'L', 'SL' )
--and r.matches >= 50
and r.alias_id is null
and r.xref_id is null)
select count(*) -- 1646    1330
from xwrl_response_ind_columns ind
,req
where ind.request_id = req.id
and substr(x_state,7) = 'Open'
;


--Haji Asad Khan Zarkari

WITH req as (select  r.id, r.matches, r.name_screened, r.date_of_birth, r.country_of_residence, r.passport_number, r.master_id, r.alias_id, r.xref_id
,mst.passport_issuing_country_code, mst.passport_number mst_passport_number
from xwrl_requests r
,xwrl_party_master mst
where r.master_id = mst.id 
and r.case_status = 'O' 
and r.case_workflow in ( 'L', 'SL' )
--and r.matches >= 50
and r.alias_id is null
and r.xref_id is null)
select ind.request_id, ind.alertid, ind.x_state, ind.rec, ind.listrecordtype, ind.listid,req.name_screened, ind.listfamilyname,ind.listgivennames, ind.listfullname, ind.listnametype, ind.listprimaryname, req.master_id, req.alias_id, req.xref_id
--,req.date_of_birth
,to_date(substr(req.date_of_birth,1,10),'YYYY-MM-DD') date_of_birth
,nvl(req.country_of_residence,req.passport_issuing_country_code) passport_issuing_country_code
,nvl(req.passport_number,req.mst_passport_number) passport_number
from xwrl_response_ind_columns ind
,req
where ind.request_id = req.id
and substr(x_state,7) = 'Open'
--and listid = 853898
--and ind.request_id = 224482
order by listid desc -- 985952 (Found this ID to search the old system)
;

--RAJESH KUMAR

-- KUMAR	Rakesh
select wc.matchscore, wc.matchstatus, wc.matchtype, wr.name_screened, wc.surname, wc.given_name,wc.notes, wr.status, wr.date_of_birth
--, wr.passport_issuing_country_code
,c.iso_alpha2_code passport_issuing_country_code
, wr.passport_number
,wc.last_updated_by
from wc_content wc
,wc_screening_request wr
,sicd_countries c
where wc.wc_screening_request_id = wr.wc_screening_request_id
and wr.passport_issuing_country_code = c.country_code (+)
and wr.status = 'Approved'
and wc.matchstatus = 'NEGATIVE'
and substr(wc.matchentityidentifier,10) = 910801
--and wc.surname = 'KHAN' -- Could use ind.listfamilyname
--and upper(wc.given_name) = 'MOHAMMED'  -- Could use ind.listgivennames
--and wr.name_screened = 'RAJESH KUMAR'
--and wr.date_of_birth = TO_DATE('05-FEB-79 12:00:00 AM','DD-MON-RR HH:MI:SS AM')
-- and c.iso_alpha2_code = 'IN'
-- and wr.passport_number = 'G7345301'
order by name_screened
--order by wc_content_id desc
;


WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.batch_id, req.matches, col.rec, req.case_state, req.case_status, req.case_workflow,  col. listfullname, req.gender, col.listrecordtype, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
,xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
,decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ebs_level
,decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ows_level
, ows_req.current_state ows_state,col.casekey, col.alertid, col.listid
,col.legal_review
 ,col.creation_date
 ,col.last_update_date
,fura.user_name case_created_by
,furb.user_name case_last_updated_by
,cura.user_name alert_created_by
,curb.user_name alert_last_updated_by
from xwrl_response_ind_columns col
,xwrl_requests req
,ows_req
,fnd_user fura
,fnd_user furb
,fnd_user cura
,fnd_user curb
where col.request_id = req.id 
and col.alertid = ows_req.EXTERNAL_ID
and req.created_by = fura.user_id
and req.last_updated_by = furb.user_id
and col.created_by = cura.user_id
and col.last_updated_by = curb.user_id
and req.case_state not IN ('D')
and (col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE) or col.x_state is null) -- Note: Not a match or null
--order by ebs_level
--order by listfullname
--order by alertid
--order by ebs_status
order by request_id, id
;



WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col.alertid
,xwrl_ows_utils.ChangeToOwsState(col.x_state) to_state
from xwrl_response_ind_columns col
,xwrl_requests req
,ows_req
where col.request_id = req.id 
and col.alertid = ows_req.EXTERNAL_ID
and req.case_state not IN ('D')
and  xwrl_ows_utils.changeowsstate(CURRENT_STATE) like '%Open'  -- Review OWS Open
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE)
and decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)  >  decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)
--and col.id = 534340
order by id desc;


select *
from xwrl_requests
where id = 231564
;

select *
from xwrl_alert_notes
where request_id = 231564
order by id desc
;

select alert_id, note
from xwrl_alert_notes
where request_id = 231564
group by alert_id, note
having count(*) > 1
;

select *
from xwrl_alert_notes
where request_id = 231564
and alert_id = 'SEN-10212066'
order by id desc
;

select request_id, alert_id,  note, created_by, creation_date, count(*), max(id) max_id
from xwrl_alert_notes
--where request_id = 151481
--and alert_id = 'SEN-9877902'
--and line_number = 176090
group by request_id, alert_id, note, created_by, creation_date;

select count(*)
from (
select request_id, alert_id,  note, created_by, creation_date, count(*), max(id) max_id
from xwrl_alert_notes
--where request_id = 151481
--and alert_id = 'SEN-9877902'
--and line_number = 176090
group by request_id, alert_id, note, created_by, creation_date
having count(*) > 1
);

select *
from xwrl_alert_notes
where request_id = 6295
and alert_id = 'SEN-9697028'
;

select request_id, alert_id,  note, created_by, creation_date, count(*), max(id) max_id
from xwrl_alert_notes
--where request_id = 6295
--and alert_id = 'SEN-9697028'
--and line_number = 176090
group by request_id, alert_id, note, created_by, creation_date
having count(*) > 1
order by request_id desc;

select count(*)
from (
select x.*
from xwrl_note_xref x
,xwrl_alert_notes a
where x.request_id = a.request_id (+)
and x.alert_id = a.alert_id (+)
and x.line_number = a.line_number (+)
and x.note_id = a.id (+)
and a.id is null);

select x.*
from xwrl_note_xref x
,xwrl_alert_notes a
where x.request_id = a.request_id (+)
and x.alert_id = a.alert_id (+)
and x.line_number = a.line_number (+)
and x.note_id = a.id (+)
and a.id is null
order by x.id desc
;

select *
from xwrl_note_xref
order by id desc
;

select count(*) from xwrl_note_xref; 396019

delete from xwrl_note_xref t
where exists (select 1
from xwrl_note_xref x
,xwrl_alert_notes a
where x.request_id = a.request_id (+)
and x.alert_id = a.alert_id (+)
and x.line_number = a.line_number (+)
and x.note_id = a.id (+)
and a.id is null
and x.id = t.id);

xwrl_utils;
xwrl_ows_utils;
rmi_ows_common_utils;
/*
TABLE: xwrl_requests;  
TRIGGER: XWRL_REQUESTS_POST_UPD
   IF     (:OLD.case_workflow <> :NEW.case_workflow)
      AND (apps.rmi_ows_common_util.case_wf_status (:OLD.case_workflow) IN
                                         ('Legal Review', 'Sr. Legal Review', 'Processor Review')
          )
      AND (apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow) IN
                                          ('Approved', 'Rejected', 'Pending')
          )
          
          
          
*/          

                     SELECT COUNT (1)
                       --INTO l_count
                       FROM xwrl_response_ind_columns
                      WHERE request_id = :p_request_id
                        AND UPPER (x_state) LIKE '%OPEN%';
                        
                        
                        update xwrl_requests
                        set case_status = 'O'
                        ,case_workflow = 'P'
                        ,case_state = 'N'
                        WHERE id = 233702;  -- PANAGIOTIS SOTOS
                        
                        update xwrl_requests
                        set case_status = 'C'
                        ,case_workflow = 'A'
                        ,case_state = 'A'
                        WHERE id = 233702; -- PANAGIOTIS SOTOS
                        
                        rollback;
                        
                        update xwrl_requests
                        set case_status = 'O'
                        ,case_workflow = 'P'
                        ,case_state = 'N'
                        WHERE id = 233780; -- FORTTRADE
                        
                        update xwrl_requests
                        set case_status = 'C'
                        ,case_workflow = 'A'
                        ,case_state = 'A'
                        WHERE id = 233780; -- FORTTRADE
                        
                        rollback;

select r.id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state
from xwrl_requests r
where r.case_status = 'C'
and r.case_state <> 'D'
and exists (select 1
from xwrl_response_ind_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;

select r.id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state
from xwrl_requests r
where r.case_status = 'C'
and r.case_state <> 'D'
and exists (select 1
from xwrl_response_entity_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;

select r.id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state
from xwrl_requests r
where r.case_status = 'O'
and r.case_state <> 'D'
and r.case_workflow = 'SL'
and exists (select 1
from xwrl_response_ind_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;

select r.id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state
from xwrl_requests r
where r.case_status = 'O'
and r.case_state <> 'D'
and r.case_workflow = 'SL'
and exists (select 1
from xwrl_response_entity_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;

declare
cursor c1 is
/*
select r.id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state
from xwrl_requests r
where r.case_status = 'C'
and r.case_state <> 'D'
and exists (select 1
from xwrl_response_entity_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;
*/
select r.id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state
from xwrl_requests r
where r.case_status = 'C'
and r.case_state <> 'D'
and exists (select 1
from xwrl_response_ind_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;

begin

xwrl_trg_ctx.disable_trg_ctx;

for c1rec in c1 loop

update xwrl_requests
set case_status = 'O'
,case_workflow = 'SL'
,case_state = 'N'
where id = c1rec.id;

end loop;
end;
/

select a.id, a.master_id, a.note
from xwrl_alert_clearing_xref a
,(select master_id, max(id) id
from xwrl_alert_clearing_xref
where substr(to_state,7) = 'False Positive'
group by master_id) x
where a.id = x.id
;


select *
from corp_main
where pin_number is null;

select *
from corp_main
where corp_number = '85156'
;

select corp_number, corp_name1, stat_status_code, pin_number
from corp_main
where corp_number in ('56140','85156')
;

select pin_number, count(*)
from corp_main
where pin_number is not null
group by pin_number
having count(*) > 1
;

select corp_name1, count(*)
from corp_main
where pin_number is not null
group by corp_name1
having count(*) > 1
;

select corp_number, count(*)
from corp_main
where pin_number is not null
group by corp_number
having count(*) > 1
;

/*
85156 galaxy  0CHYDUHXC9
56140 fujutec  CJCCM6ENBM

78539 OLGA INTERNATIONAL HOLDING LTD  41776GD02O
77502 NEW OCEAN CO., LTD.  ZKA19QEDFZ
*/

select *
from corp_main
where corp_number = '77502'
;

select corp_id, corp_number, corp_name1, pin_number
from corp_main
where pin_number in ('CJCCM6ENBM','0CHYDUHXC9')
;

select corp_id, corp_number, corp_name1, pin_number
from corp_main
where pin_number in ('41776GD02O','ZKA19QEDFZ')
;

select *
from rmi_corp_esr_info
where esr_certificate_status != 'Active'
--where corp_number in (56140,85156)
--where unique_pin in  ('CJCCM6ENBM','0CHYDUHXC9')
order by 1 desc
;

select *
from rmi_corp_esr_info
--where corp_number in (56140,85156)
where unique_pin in ('41776GD02O','ZKA19QEDFZ')
order by 1 desc
;

select *
from rmi_corp_esr_info
where ows_req_batch_id = 96076
and fnd_ows_request_id = 28199312
;

update rmi_corp_esr_info
set esr_certificate_status = 'Active'
where esr_id = 39
;

select *
from esr_request_user_details
;

select *
from xwrl_requests
where id in (211957,224856);

select *
from xwrl_requests
where batch_id = :p_batch_id
;


select *
from xwrl_case_documents
where request_id = :p_request_id
--where master_id = :p_master_id
;

----3211
--321131

select *
from xwrl_case_documents_sum_v
--where orig_master_id = 3211
--where request_id = :p_request_id
where master_id = :p_master_id
--where orig_master_id = :p_master_id
--where batch_id = :p_batch_id
--where case_id = :p_case_id
--where file_name = '1134768-0002-004.JPG'
--where file_name = 'LIU JUN ppt.pdf'
;


select *
from xwrl_requests
where batch_id = 109816
;

select *
from xwrl_requests
where id = 236319  -- batch 108942 master_id = 612745 uid = 814448
;

select id, master_id, alias_id, xref_id, case_id, batch_id, matches, name_screened, date_of_birth, department_ext, office, case_status, case_state, case_workflow, expiration_date, creation_date
from xwrl_requests
where batch_id in (107261,108942,109816)
order by id desc
;

--238024
--236319
--233010

select *
from xwrl_response_ind_columns
where listid = 814448
and request_id in (233010,236319,238024)
order by id desc
;

--SEN-10242159

select *
from xwrl_requests
where id = 233010
;

-- 612745 master_id 
-- 566287 (rec 4)
-- 556281 (rec 81)

select *
from xwrl_note_xref
where list_id = 814448
and master_id = 612745
--and request_id in (236319,238024)
;

select *
from xwrl_case_notes_sum_v
where batch_id = 109816
;

select count(*)
from mt_log
;

-- 18725318 records
-- mt_log_error

select *
from mt_log
order by log_id desc
;

select *
from fnd_user
where user_id = 3268

select *
from xwrl_requests
where batch_id = 100452
;

select *
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
and table_column = 'BATCH_ID'
and new_value = 100452
;

select *
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
and table_id = 219686
order by audit_log_id desc
;

select *
from xwrl_requests
where source_table = 'ESR_REQUEST_USER_DETAILS'
and source_id = 100
;

select *
from xwrl_case_notes
where request_id = 219686
--where master_id = 609814
--where source_table = 'ESR_REQUEST_USER_DETAILS'
--and source_id = 100
;

select *
from xwrl_case_documents
where request_id = 219686
--where master_id = 609814
;

select *
from xwrl_alert_notes
where request_id = 219686
;

select *
from xwrl_alert_clearing_xref
where master_id = 609814
;


select *
from xwrl_requests
where id = 212101
;


select *
from xwrl_requests
--where master_id = 609814
where master_id = 608151
;

select *
from xwrl_party_master
where id in (608151,609814)
;


select *
from xwrl_requests
order by id desc; -- 239267

select *
from xwrl_party_master
where id = 609814;


select *
from xwrl_party_master
where id = 608151
;

select *
from xwrl_party_master
where id in (608151,609814)
;

select *
from xwrl_requests
where batch_id in (107789
,96673);

select *
from xwrl_audit_log
where audit_log_id between 182637617 and 182637700
;


select *
from xwrl_requests
where case_id is null
order by id desc
;


select *
from xwrl_requests
where id between 207466 and 207468
order by id desc
;


select *
from xwrl_requests
where batch_id = 108896
;

select *
from xwrl_response_ind_columns
where request_id = 236253
;
update xwrl_response_ind_columns
set x_state = 'EDD - False Positive'
where id = 555191
;

WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
SELECT c.request_id, x_state, ows_req.CURRENT_STATE
FROM xwrl_response_ind_columns c
,xwrl_requests req
,ows_req
WHERE  c.request_id = req.id
and c.alertid = ows_req.EXTERNAL_ID
and req.BATCH_ID = 105896
and substr(c.x_state,7) = 'Open'
;

select lower(view_name)
from all_views
where view_name like 'XWRL\_%' escape '\'
order by 1
;



     cursor c1 (p_master_id integer, p_alias_id integer, p_xref_id integer, p_list_id integer)is
      with max_note as 
(select nn.note max_note,max(nn.id) max_id
from xwrl_response_ind_columns  ii
,xwrl_requests rr
,xwrl_note_xref xx
,XWRL_ALERT_NOTES nn
where ii.request_id = rr.id
and rr.master_id = p_master_id
and decode(rr.alias_id ,nvl(p_alias_id,rr.alias_id),1,0) = 1
and decode(rr.xref_id ,nvl(p_xref_id,rr.xref_id),1,0) = 1
and ii.listid = p_list_id
and ii.request_id = xx.request_id (+)
and ii.alertid = xx.alert_id (+)
and xx.note_id = nn.id (+)
group by nn.note)
select n.id, n.line_number, n.note, n.creation_date, n.created_by, n.last_update_date, n.last_updated_by, n.last_update_login
from xwrl_response_ind_columns  i
,xwrl_requests r
,xwrl_note_xref x
,XWRL_ALERT_NOTES n
,max_note
where i.request_id = r.id
and r.master_id = p_master_id
and decode(r.alias_id ,nvl(p_alias_id,r.alias_id),1,0) = 1
and decode(r.xref_id ,nvl(p_xref_id,r.xref_id),1,0) = 1
and i.listid = p_list_id
and i.request_id = x.request_id (+)
and i.alertid = x.alert_id (+)
and x.note_id = n.id (+)
and n.id = max_note.max_id;


      cursor c2 (p_master_id integer, p_alias_id integer, p_xref_id integer, p_list_id integer)is
      with max_note as 
(select nn.note max_note,max(nn.id) max_id
from xwrl_response_entity_columns  ii
,xwrl_requests rr
,xwrl_note_xref xx
,XWRL_ALERT_NOTES nn
where ii.request_id = rr.id
and rr.master_id = p_master_id
and decode(rr.alias_id ,nvl(p_alias_id,rr.alias_id),1,0) = 1
and decode(rr.xref_id ,nvl(p_xref_id,rr.xref_id),1,0) = 1
and ii.listid = p_list_id
and ii.request_id = xx.request_id (+)
and ii.alertid = xx.alert_id (+)
and xx.note_id = nn.id (+)
group by nn.note)
select n.id, n.line_number, n.note, n.creation_date, n.created_by, n.last_update_date, n.last_updated_by, n.last_update_login
from xwrl_response_entity_columns  i
,xwrl_requests r
,xwrl_note_xref x
,XWRL_ALERT_NOTES n
,max_note
where i.request_id = r.id
and r.master_id = p_master_id
and decode(r.alias_id ,nvl(p_alias_id,r.alias_id),1,0) = 1
and decode(r.xref_id ,nvl(p_xref_id,r.xref_id),1,0) = 1
and i.listid = p_list_id
and i.request_id = x.request_id (+)
and i.alertid = x.alert_id (+)
and x.note_id = n.id (+)
and n.id = max_note.max_id;



select count(unique r.id)
from xwrl_response_ind_columns c
,xwrl_requests r
where c. request_id = r.id
and r.case_status = 'O'
and r.case_state <> 'D'
and r.case_workflow IN ( 'L','SL')
and exists (select 1
from xwrl_response_ind_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
--and r.id = 238024
;

select count ( unique r.id )
from xwrl_response_entity_columns c
,xwrl_requests r
where c. request_id = r.id
and r.case_status = 'O'
and r.case_state <> 'D'
and r.case_workflow IN ( 'L','SL')
and exists (select 1
from xwrl_response_entity_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by request_id desc
;

SELECT *
FROM xwrl_requests 
WHERE master_id = 612745 
--and batch_id in ( 107261, 108942)
order by batch_id desc
;

select *
from xwrl_alert_clearing_xref
where request_id in  (233010,236319,238024)
order by id desc
;

select * 
from xwrl_alert_notes
where request_id in  (233010,236319,238024)

order by id desc
;

select *
from xwrl_note_xref
where request_id in  (233010,236319,238024)
--and list_id = 3930404
order by list_id, id desc
;

select count(*)
from xwrl_alert_notes n
,xwrl_note_xref x
where n.id = x.note_id (+)
and n.alert_id = x.alert_id (+)
and x.note_id is null
order by n.id desc
;

select n.*
from xwrl_alert_notes n
,xwrl_note_xref x
where n.id = x.note_id (+)
and n.alert_id = x.alert_id (+)
and x.note_id is null
order by n.id desc
;

select *
from xwrl_alert_notes
--where note_id = 4238559
where alert_id = :p_alert_id
order by id desc;

select count(*)
from xwrl_alert_notes;

select count(*)
from xwrl_note_xref;

select n.*
from xwrl_alert_notes  n
where not exists (select 1 from xwrl_note_xref x where x.note_id = n.id)
;

select count(*)
from xwrl_alert_notes  n
where not exists (select 1 from xwrl_note_xref x where x.note_id = n.id)
; -- 65232

select count(*)
from xwrl_alert_notes  n
where not exists (select 1 from xwrl_note_xref x where x.note_id = n.id)

select *
from xwrl_alert_notes
where id = 1481;

select *
from xwrl_note_xref
where note_id = 1481;


select *
from xwrl_note_xref
--where note_id = 4238559
where alert_id = :p_alert_id
order by id desc;

select count(*)
from (with dup_rec as 
(select x.request_id, x.alert_id, x.note, x.last_update_date, x.last_updated_by, x.creation_date, x.created_by, x.last_update_login, count(*)
from xwrl_alert_notes x
group by x.request_id, x.alert_id, x.note, x.last_update_date, x.last_updated_by, x.creation_date, x.created_by, x.last_update_login
having count(*) > 1)
select n.*, (select count(*) from xwrl_note_xref x where x.note_id = n.id) xref_count
from xwrl_alert_notes n
,dup_rec
where n.alert_id = dup_rec.alert_id) xx
where xx.xref_count = 0
order by xx.alert_id, xx.line_number
;

select xx.*
from (with dup_rec as 
(select x.request_id, x.alert_id, x.note, x.last_update_date, x.last_updated_by, x.creation_date, x.created_by, x.last_update_login, count(*)
from xwrl_alert_notes x
group by x.request_id, x.alert_id, x.note, x.last_update_date, x.last_updated_by, x.creation_date, x.created_by, x.last_update_login
having count(*) > 1)
select n.*, (select count(*) from xwrl_note_xref x where x.note_id = n.id) xref_count
from xwrl_alert_notes n
,dup_rec
where n.alert_id = dup_rec.alert_id) xx
--where xx.xref_count = 0
order by xx.alert_id, xx.line_number
;

select count(*)
from (select x.request_id, x.alert_id, x.note, x.last_update_date, x.last_updated_by, x.creation_date, x.created_by, x.last_update_login, count(*), max(x.id) max_id
from xwrl_alert_notes x
group by x.request_id, x.alert_id, x.note, x.last_update_date, x.last_updated_by, x.creation_date, x.created_by, x.last_update_login
having count(*) > 1)
;

select x.request_id, x.alert_id, x.note, x.last_update_date, x.last_updated_by, x.creation_date, x.created_by, x.last_update_login, count(*), max(x.id) max_id
from xwrl_alert_notes x
group by x.request_id, x.alert_id, x.note, x.last_update_date, x.last_updated_by, x.creation_date, x.created_by, x.last_update_login
having count(*) > 1
;

select xx.*
from (with dup_rec as 
(select x.request_id, x.alert_id, x.note, x.last_update_date, x.last_updated_by, x.creation_date, x.created_by, x.last_update_login, count(*), max(x.id) max_id
from xwrl_alert_notes x
group by x.request_id, x.alert_id, x.note, x.last_update_date, x.last_updated_by, x.creation_date, x.created_by, x.last_update_login
having count(*) > 1)
select n.*,dup_rec.max_id, (select count(*) from xwrl_note_xref x where x.alert_id = n.alert_id) xref_count
from xwrl_alert_notes n
,dup_rec
where n.alert_id = dup_rec.alert_id) xx
--where xx.xref_count = 0
order by xx.alert_id, xx.line_number
;


create table xwrl_alert_notes_20200727_bkup 
as select * from xwrl_alert_notes;


declare

cursor c1 is
select xx.*
from (with dup_rec as 
(select x.request_id, x.alert_id, x.note, x.last_update_date, x.last_updated_by, x.creation_date, x.created_by, x.last_update_login, count(*), max(x.id) max_id
from xwrl_alert_notes x
group by x.request_id, x.alert_id, x.note, x.last_update_date, x.last_updated_by, x.creation_date, x.created_by, x.last_update_login
having count(*) > 1)
select n.*,dup_rec.max_id, (select count(*) from xwrl_note_xref x where x.alert_id = n.alert_id) xref_count
from xwrl_alert_notes n
,dup_rec
where n.alert_id = dup_rec.alert_id) xx
--where xx.xref_count = 0
order by xx.alert_id, xx.line_number
;


begin

for c1rec in c1 loop

delete from xwrl_alert_notes
where id = c1rec.id
and id != c1rec.max_id;

delete from xwrl_note_xref
where note_id = c1rec.id
and note_id != c1rec.max_id;

end loop;
end;
/



select *
from xwrl_note_xref
--where note_id = 4238559
where alert_id = 'SEN-10256001'
order by id desc;


select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id,r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id
from xwrl_alert_notes n
,xwrl_response_ind_columns c
,xwrl_requests r
,xwrl_note_xref x
where n.request_id = r.id 
and n.request_id = c.request_id
and n.id = x.note_id (+)
and n.alert_id = x.alert_id (+)
and x.note_id is null
and n.id = 4238559
order by n.id desc
;

select count(*)
from xwrl_alert_notes n
,xwrl_response_ind_columns c
,xwrl_requests r
,xwrl_note_xref x
where n.request_id = r.id 
and n.request_id = c.request_id
and n.id = x.note_id (+)
and n.alert_id = x.alert_id (+)
and x.note_id is null;

delete from xwrl_note_xref
where id = 441696;


select count(*)
from xwrl_alert_notes  n
where not exists (select 1 from xwrl_note_xref x where x.note_id = n.id)
; -- 65232


select count(*)
from (select request_id, alert_id, line_number, note_id, count(*), max(id)
from xwrl_note_xref
group by request_id, alert_id, line_number, note_id
having count(*) > 1
);

select request_id, alert_id, line_number, note_id, count(*), max(id)
from xwrl_note_xref
group by request_id, alert_id, line_number, note_id
having count(*) > 1;

declare
cursor c1 is select request_id, alert_id, line_number, note_id, count(*), max(id) max_id
from xwrl_note_xref
group by request_id, alert_id, line_number, note_id
having count(*) > 1
;
v_ctr integer;

begin

v_ctr := 0;

for c1rec in c1 loop

delete from xwrl_note_xref
where request_id = c1rec.request_id
and alert_id = c1rec.alert_id
and line_number = c1rec.line_number
and note_id = c1rec.note_id
and id != c1rec.max_id;

v_ctr := v_ctr + 1;

if v_ctr >= 1000 then 
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
from xwrl_note_xref
where alert_id = 'SEN-10089309' --445440
;

select *
from xwrl_alert_notes
order by id desc
--where id = 4095633
;

select count(*)
from xwrl_alert_notes n
,xwrl_response_ind_columns c
,xwrl_requests r
where n.request_id = r.id 
and n.request_id = c.request_id
and n.alert_id = c.alertid
and not exists (select 1 from xwrl_note_xref x where x.note_id = n.id)
;

select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login, n.line_number, n.id note_id
from xwrl_alert_notes n
,xwrl_response_ind_columns c
,xwrl_requests r
where n.request_id = r.id 
and n.request_id = c.request_id
and n.alert_id = c.alertid
and not exists (select 1 from xwrl_note_xref x where x.note_id = n.id)
;

select r.batch_id, x.*
from xwrl_note_xref x
,xwrl_requests r
where x.request_id = r.id
order by r.id desc
;

select *
from xwrl_response_ind_columns;

select count(*)
from xwrl_requests;


select count(*)
from xwrl_requests r
where r.matches = 0
and exists (select 1
from xwrl_response_ind_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
and exists (select 1
from xwrl_requests x
where x.master_id = r.master_id
and x.matches > 0);

select count(*)
from xwrl_requests r
where r.matches = 0
and exists (select 1
from xwrl_response_entity_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
and exists (select 1
from xwrl_requests x
where x.master_id = r.master_id
and x.matches > 0);


select count(unique r.id) ind_req_count
--select r.id request_id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state, r.master_id, c.listid, c.alertid, c.listrecordtype, r.alias_id, r.xref_id
from xwrl_response_ind_columns c
,xwrl_requests r
where c. request_id = r.id
and r.case_status = 'O'
and r.case_state <> 'D'
--and r.case_workflow IN ( 'L','SL')
and exists (select 1
from xwrl_response_ind_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
;

select count(unique r.id) entity_req_id
--select r.id request_id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state, r.master_id, c.listid, c.alertid, c.listrecordtype, r.alias_id, r.xref_id
from xwrl_response_entity_columns c
,xwrl_requests r
where c. request_id = r.id
and r.case_status = 'O'
and r.case_state <> 'D'
--and r.case_workflow IN ( 'L','SL')
and exists (select 1
from xwrl_response_entity_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
;


select *
from xwrl_alert_clearing_xref
order by id desc
;

select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is null
and xref_id is null
group by master_id, list_id;

select *
from xwrl_response_ind_columns c
where substr(c.x_state,7) = 'Open';


select *
from xwrl_response_entity_columns c
where substr(c.x_state,7) = 'Open';

-- master
with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is null
and xref_id is null
group by master_id, list_id)
select x.*
from xwrl_alert_clearing_xref x
,mst_lst
where x.id = mst_lst.max_id
);

-- alias
with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is not null
and xref_id is null
group by master_id, list_id)
select x.*
from xwrl_alert_clearing_xref x
,mst_lst
where x.id = mst_lst.max_id
;

-- xref
with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is null
and xref_id is not null
group by master_id, list_id)
select x.*
from xwrl_alert_clearing_xref x
,mst_lst
where x.id = mst_lst.max_id;

select count(*)
from (
with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is null
and xref_id is null
group by master_id, list_id)
select x.*, r.batch_id
from xwrl_alert_clearing_xref x
,mst_lst
,xwrl_requests r
where x.id = mst_lst.max_id
and x.request_id = r.id) master
,(with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is not null
and xref_id is null
group by master_id, list_id)
select x.*,r.batch_id
from xwrl_alert_clearing_xref x
,mst_lst
,xwrl_requests r
where x.id = mst_lst.max_id
and x.request_id = r.id) alias
where master.batch_id = alias.batch_id
and master.master_id = alias.master_id
and master.list_id = alias.list_id
and master.to_state != alias.to_state
;

SELECT *
FROM WC_SCREENING_REQUEST;

SELECT *
FROM wc_matches;

select *
from wc_content
where matchstatus = 'POSITIVE'
;

select unique status
from wc_screening_request;

select *
from xwrl_requests;

select count(*)
from xwrl_requests xr
where exists (select 1
from wc_content c
,wc_matches m
,wc_screening_request r
where c.wc_matches_id = m.wc_matches_id
and m.wc_screening_request_id = r.wc_screening_request_id
and r.status = 'Rejected'
and c.matchstatus = 'POSITIVE'
and r.name_screened = xr.name_screened)
;


/* Query to find Legacy positive match in OWS 

Need to add exists for OWS Approved

*/



select xr.batch_id
,xr.name_screened
,xr.matches
,xr.case_status
,xr.case_state
,xr.case_workflow
from xwrl_requests xr
where exists (select 1
from wc_content c
,wc_matches m
,wc_screening_request r
where c.wc_matches_id = m.wc_matches_id
and m.wc_screening_request_id = r.wc_screening_request_id
and r.status = 'Rejected'
and c.matchstatus = 'POSITIVE'
and r.name_screened = xr.name_screened)
;


select xr.*
from xwrl_requests xr
where exists (select 1
from wc_content c
,wc_matches m
,wc_screening_request r
where c.wc_matches_id = m.wc_matches_id
and m.wc_screening_request_id = r.wc_screening_request_id
and r.status = 'Rejected'
and c.matchstatus = 'POSITIVE'
and r.name_screened = xr.name_screened)
;

select xr.batch_id
,xr.master_id
,xr.alias_id
,xr.xref_id
,xr.case_id
,xr.creation_date
,xr.name_screened
,xr.matches
,to_date(substr(xr.date_of_birth,1,10),'YYYY-MM-DD') date_of_birth
,xr.case_status
,xr.case_state
,xr.case_workflow
,x.*
from xwrl_requests xr
,(select c.notes legacy_notes, c.matchstatus, r.status, r.name_screened, r.date_of_birth, r.passport_number, r.passport_issuing_country_code, r.notes legacy_content_notes, r.creation_date, r.created_by, r.last_update_date, r.last_updated_by, r.last_update_login
from wc_content c
,wc_matches m
,wc_screening_request r
where c.wc_matches_id = m.wc_matches_id
and m.wc_screening_request_id = r.wc_screening_request_id
and r.status = 'Rejected'
and c.matchstatus = 'POSITIVE'
) x
--and upper(c.notes) like '%HIGH RISK%'
where xr.name_screened = x.name_screened
and to_date(substr(xr.date_of_birth,1,10),'YYYY-MM-DD')  = x.date_of_birth
order by batch_id desc
;


/* Add Master when Alias most recently updated */

select master.*, alias.*
from (
with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is null
and xref_id is null
group by master_id, list_id)
select x.*, r.batch_id
from xwrl_alert_clearing_xref x
,mst_lst
,xwrl_requests r
where x.id = mst_lst.max_id
and x.request_id = r.id) master
,(with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is null
and xref_id is not null
group by master_id, list_id)
select x.*,r.batch_id
from xwrl_alert_clearing_xref x
,mst_lst
,xwrl_requests r
where x.id = mst_lst.max_id
and x.request_id = r.id) alias
where master.master_id = alias.master_id
and master.list_id = alias.list_id
--and master.batch_id = alias.batch_id
and master.to_state != alias.to_state
--and master.note = '[Legal Review.]'
--and alias.note = '[Legal Review.]'
--and substr(alias.to_state,7) = 'False Positive'
--and substr(alias.note,1,1) != '['
--and master.note != alias.note
--and alias.note != '[Full vetting to be completed upon the next transaction.]'
--and alias.note != '[Name is not a match.]'
and master.creation_date < alias.creation_date
order by master.batch_id desc
;


/* Add Alias when  Master most recently updated */

select master.*, alias.*
from (
with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is null
and xref_id is null
group by master_id, list_id)
select x.*, r.batch_id
from xwrl_alert_clearing_xref x
,mst_lst
,xwrl_requests r
where x.id = mst_lst.max_id
and x.request_id = r.id) master
,(with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is null
and xref_id is not null
group by master_id, list_id)
select x.*,r.batch_id
from xwrl_alert_clearing_xref x
,mst_lst
,xwrl_requests r
where x.id = mst_lst.max_id
and x.request_id = r.id) alias
where master.master_id = alias.master_id
and master.list_id = alias.list_id
--and master.batch_id = alias.batch_id
and master.to_state != alias.to_state
and master.note != 'Test'
--and master.note = '[Legal Review.]'
--and alias.note = '[Legal Review.]'
--and master.note != '[Full vetting to be completed upon the next transaction.]'
--and master.note != alias.note
--and substr(alias.note,1,1) != '['
and master.creation_date > alias.creation_date
order by master.batch_id desc
;

select *
from xwrl_parameters
;

 insert  into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_DATE,LAST_UPDATE_DATE,LAST_UPDATED_BY,CREATION_DATE,CREATED_BY) VALUES ('OWS_MAINTENANCE_WINDOW', 'START_DATE', NULL,SYSDATE,1156,SYSDATE,1156);
 insert  into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_DATE,LAST_UPDATE_DATE,LAST_UPDATED_BY,CREATION_DATE,CREATED_BY) VALUES ('OWS_MAINTENANCE_WINDOW', 'END_DATE', NULL,SYSDATE,1156,SYSDATE,1156);
COMMIT;

xwrl_data_processing;

update XWRL_PARAMETERS
set VALUE_DATE = TO_DATE('07/29/2020 17:00:00','MM/DD/YYYY HH24:MI:SS')
where id = 'OWS_MAINTENANCE_WINDOW'
and key = 'START_DATE';
COMMIT;

update XWRL_PARAMETERS
set VALUE_DATE = TO_DATE('07/29/2020 19:00:00','MM/DD/YYYY HH24:MI:SS')
where id = 'OWS_MAINTENANCE_WINDOW'
and key = 'END_DATE';
COMMIT;

update XWRL_PARAMETERS
set VALUE_DATE = NULL
where id = 'OWS_MAINTENANCE_WINDOW'
and key = 'START_DATE';
COMMIT;

update XWRL_PARAMETERS
set VALUE_DATE = NULL
where id = 'OWS_MAINTENANCE_WINDOW'
and key = 'END_DATE';
COMMIT;

select *
from (SELECT VALUE_DATE start_date
FROM XWRL_PARAMETERS
where id = 'OWS_MAINTENANCE_WINDOW'
and key = 'START_DATE')
,(SELECT VALUE_DATE end_date
FROM XWRL_PARAMETERS
where id = 'OWS_MAINTENANCE_WINDOW'
and key = 'END_DATE');

declare
v_return boolean;
begin
v_return := xwrl_data_processing.is_maintenance_window (sysdate);
if v_return then
    dbms_output.put_line('TRUE');
else
   dbms_output.put_line('FALSE');
end if;
end;
/

SELECT   batch_id, c.description created_by_user,
            l.description updated_by_user, q.master_id, q.alias_id, q.xref_id,
            xc."ID", xc."REQUEST_ID", xc."CASE_ID", xc.document_type,
            xc.file_name, xc."LAST_UPDATE_DATE", xc."LAST_UPDATED_BY",
            xc."CREATION_DATE", xc."CREATED_BY", xc."LAST_UPDATE_LOGIN",
            
--            rmi_ows_common_util.get_master_id (q.master_id,
--                                               q.alias_id,
--                                               q.xref_id
--                                              ) orig_master_id
            xc.master_id orig_master_id
       FROM xwrl_case_documents xc, xwrl_requests q, fnd_user c, fnd_user l
      WHERE 1 = 1
        AND xc.request_id = q.ID
        AND c.user_id(+) = xc.created_by
        AND l.user_id(+) = xc.last_updated_by
   ORDER BY batch_id DESC, xc.request_id DESC, last_update_date DESC;
   
update xwrl_requests
set office = 'K'
where created_by = 11252
and office = 'HW'
;
   

select * from  xwrl_case_documents_sum_v
order by request_id desc
;
select * from  xwrl_case_notes_sum_v;

SELECT   batch_id, c.description created_by_user,
            l.description updated_by_user, q.master_id, alias_id, xref_id,
            xc."ID", xc."REQUEST_ID", xc."CASE_ID", xc."LINE_NUMBER",
            xc."NOTE", xc."LAST_UPDATE_DATE", xc."LAST_UPDATED_BY",
            xc."CREATION_DATE", xc."CREATED_BY", xc."LAST_UPDATE_LOGIN",
            rmi_ows_common_util.get_master_id (q.master_id,
                                               q.alias_id,
                                               q.xref_id
                                              ) orig_master_id
       FROM xwrl_case_notes xc, xwrl_requests q, fnd_user c, fnd_user l
      WHERE 1 = 1
        AND xc.request_id = q.ID
        AND c.user_id(+) = xc.created_by
        AND l.user_id(+) = xc.last_updated_by
   ORDER BY batch_id DESC, xc.request_id DESC, last_update_date DESC
   ;

select *
from xwrl_case_documents
;

select *
from xwrl_case_notes
;


select *
from xwrl_requests
where batch_id = 68092
;


select *
from xwrl_request_approval_hist_v
where batch_id =68093
;

select *
from xwrl_request_approval_hist_v
where master_id = 234860
order by 1 desc
;


rmi_ows_common_util.query_cross_reference;


select *
from xwrl_requests
where batch_id = 68092;

select *
from xwrl_party_master
where id = 234860
;

SELECT *
FROM xwrl_party_alias
where master_id = 234860
;

--SICD_SEAFARERS	SEAFARER_ID	1137666 234860

SELECT   *
             FROM xwrl_party_master r
            WHERE 1 = 1
              AND relationship_type = 'Primary'
              AND status = 'Enabled'
              AND state NOT LIKE '%Delete%'
              AND source_table = DECODE (:p_source_table,'***', 'XWRL_PARTY_MASTER',NVL (:p_source_table, 'XWRL_PARTY_MASTER'))
              AND source_table_column = DECODE (:p_source_column,'***', 'ID',NVL (:p_source_column, 'ID'))
              AND source_id = DECODE (:p_source_id,'***', source_id,NVL (:p_source_id, source_id))
         ORDER BY r.creation_date DESC;
         
         SELECT   b.*, xref.start_date, xref.end_date, xref.master_id,
                  xref.relationship_master_id, xref.ID xref_id,
                  xref.tc_excluded
             FROM xwrl_party_xref xref,
                  (SELECT ID, relationship_type, entity_type, state, status,
                          source_table, source_table_column, source_id,
                          full_name, batch_id, created_by, creation_date,
                          last_update_date, last_updated_by,
                          last_update_login, date_of_birth, family_name,
                          given_name, sex, passport_number,
                          citizenship_country_code,
                          passport_issuing_country_code, country_of_residence,
                          city_of_residence_id, imo_number,
                          wc_screening_request_id
                     FROM xwrl_party_master) b
            WHERE xref.master_id = :p_id
              AND xref.relationship_master_id = b.ID
              AND b.status = 'Enabled'
              AND b.state NOT LIKE '%Delete%'
              AND xref.status = 'Enabled'
              AND xref.relationship_master_id <> xref.master_id
              AND TRUNC (SYSDATE) BETWEEN TRUNC (NVL (xref.start_date,SYSDATE))
            AND TRUNC (NVL (xref.end_date, SYSDATE))
         ORDER BY xref.creation_date;         
         
                  SELECT *
           FROM xwrl_party_alias b
          WHERE b.master_id = :p_id
            AND b.status = 'Enabled'
            AND TRUNC (SYSDATE) BETWEEN TRUNC (NVL (b.start_date, SYSDATE))
            AND TRUNC (NVL (b.end_date, SYSDATE));
            
            xwrl_ows_utils;
            
            
select r.*
from xwrl_requests r
where r.batch_id = 115800
;

select c.*
from xwrl_response_ind_columns c
where exists (select 1 from xwrl_requests r where r.batch_id = 115800 and c.request_id = r.id);

select c.*
from xwrl_response_rows c
where exists (select 1 from xwrl_requests r where r.batch_id = 115800 and c.request_id = r.id);

select *
from xwrl_alert_notes
;

select c.*
from xwrl_alert_notes c
where exists (select 1 from xwrl_requests r where r.batch_id = 115800 and c.request_id = r.id);

select c.*
from xwrl_note_xref c
where exists (select 1 from xwrl_requests r where r.batch_id = 115800 and c.request_id = r.id);


select *
from xwrl_requests
--where batch_id is null
order by creation_date desc;

select batch_id, case_status, case_workflow, case_state, count(*)
from xwrl_requests
group by batch_id, case_status, case_workflow, case_state
;

rmi_ows_common_util;

select *
from xwrl_requests
--where name_screened = upper('ABS Nautical Systems')
;



select description
into description
from vssl_offices
where code = code;
;

select *
from xwrl_response_ind_columns
;

select path
,decode(matches,0,'N','Y') matches_found
, XWRL_DATA_PROCESSING.get_office(office) office
, XWRL_DATA_PROCESSING.get_case_status(case_status) case_status
, XWRL_DATA_PROCESSING.get_case_workflow(case_workflow) case_workflow
, XWRL_DATA_PROCESSING.get_case_state(case_state) case_state
, XWRL_DATA_PROCESSING.contains_legal_review(path,id) legal_review
, count(*)
from xwrl_requests
group by path,decode(matches,0,'N','Y') , office, case_status, case_workflow, case_state,XWRL_DATA_PROCESSING.contains_legal_review(path,id)
order by 1, 2, 3, 4, 5,6,7
;

select *
from mt_log
where notes like '%ORA%'
order by 1 desc
;

select *
from mt_log
where log_id between 25045177 and 25045500
;

SELECT COUNT(*)
FROM XWRL_AUDIT_LOG;


      SELECT
         id
         , source_table
         , source_id
         , wc_screening_request_id
      FROM
         xwrl_requests
      WHERE
         status = 'ERROR'
         AND id = nvl (:p_id, id)
         AND ROWNUM <= 50;
         
         
         -- ANDREAS MATTHAIOS
         
select *
from WC_SCREENING_REQUEST
where name_screened = 'ANDREAS MATTHAIOS' -- AI26074829
;

select *
from xwrl_party_master
where full_name = 'ANDREAS MATTHAIOS' --AI26074829
;
/* master id

554068
592245
58988

*/

select *
from xwrl_requests 
--where name_screened = 'ANDREAS MATTHAIOS' -- AI26074829
where name_screened = 'MAKSYM SHEVELENKO'
;


select *
from xwrl_party_xref
--where master_id in (377323,402913,402913)
where id in (4844053,4875550,4875550)
;

select req.id
,req.master_id
,req.alias_id
,req.xref_id
,req.name_screened
,req.matches
,req.date_of_birth
, mst.*
from xwrl_requests req
,xwrl_party_xref xref
,xwrl_party_master mst
where req.name_screened = 'ANDREAS MATTHAIOS' -- AI26074829
and req.xref_id = xref.id
and xref.relationship_master_id = mst.id
;

select wcr.status, wcr.name_screened, wcr.date_of_birth, wcr.passport_number
, wcr.passport_issuing_country_code --, wcc.matchentityidentifier
,substr(wcc.matchentityidentifier,10) matchentityidentifier,  wcc.matchstatus, wcc.surname, wcc.given_name, wcc.sex,  wcc.notes
from WC_SCREENING_REQUEST wcr
,wc_matches wcm
,wc_content wcc
where wcr.name_screened = 'ANDREAS MATTHAIOS' -- AI26074829
and wcr.wc_screening_request_id = wcm.wc_screening_request_id
and wcm.wc_matches_id = wcc.wc_matches_id
;

select c.*
from xwrl_response_ind_columns c
where c.request_id in (141075
,259698
,259692
);




select count(*)
from rmi_corp_esr_info
where esr_certificate_status != 'Active'
--where corp_number in (56140,85156)
--where unique_pin in  ('CJCCM6ENBM','0CHYDUHXC9')
order by 1 desc
;

select *
from esr_request_user_details
;

select request_id
,ows_req_batch_id
,e.ows_corp_esr_req_id
,e.ows_esr_req_id
,e.ows_corp_req_batch_id
,e.esr_certificate_status
,e.esr_action
,e.creation_date
,e.*
from rmi_corp_esr_info e
where esr_certificate_status != 'Active'
--where corp_number in (56140,85156)
--where unique_pin in  ('CJCCM6ENBM','0CHYDUHXC9')
and trunc(creation_date) = trunc(sysdate)
order by e.creation_date desc
;

select *
from xwrl_requests
where resubmit_id = 258814;

select *
from xwrl_requests
where batch_id = 120489 -- corp
;

select *
from xwrl_requests
where batch_id = 120490 -- ind
;

select e.esr_id
,e.corp_name
,e.ows_esr_req_id
,ows_req_batch_id
,ind.id ind_request_id
,ind.batch_id ind_batch_id
,e.ows_corp_esr_req_id
,e.ows_corp_req_batch_id
,corp.id corp_request_id
,corp.batch_id corp_batch_id
,resub.id resub_request_id
,resub.batch_id resub_batch_id
,e.esr_certificate_status
,e.esr_action
,e.creation_date
from rmi_corp_esr_info e
,xwrl_requests ind
,xwrl_requests corp
,xwrl_requests resub
where e.esr_certificate_status != 'Active'
--where corp_number in (56140,85156)
--where unique_pin in  ('CJCCM6ENBM','0CHYDUHXC9')
and trunc(e.creation_date) = trunc(sysdate-1)
and e.ows_esr_req_id = ind.id (+)
and e.ows_corp_esr_req_id = corp.id (+)
and e.ows_corp_esr_req_id = resub.resubmit_id (+)
--and e.ows_esr_req_id is null
--and resub.id is not null
order by e.corp_name
;

select *
from xwrl_requests
--where batch_id = 120582
where name_screened = 'CELESTIA HOLDINGS S.A.'
;

select *
from xwrl_requests
where id = 258281
;

select *
from xwrl_requests
where resubmit_id = 258281
;

select *
from rmi_corp_esr_info
where esr_id = 1065
;

select *
from xwrl_requests
;

RMI_CORP_ESR_OWS_TC_PKG;

select e.esr_id
,e.corp_name
,e.ows_corp_esr_req_id
,e.ows_corp_req_batch_id
,e.esr_certificate_status
,e.esr_action
,e.creation_date
from rmi_corp_esr_info e
where e.esr_certificate_status != 'Active'
--where corp_number in (56140,85156)
--where unique_pin in  ('CJCCM6ENBM','0CHYDUHXC9')
and trunc(e.creation_date) = trunc(sysdate-1)
and e.ows_esr_req_id is null
--and resub.id is not null
order by e.corp_name
/

select *
from all_objects
where object_name like '%ESR\_%' escape '\'
order by object_type, object_name
;

select *
from mt_log
order by 1 desc;


select *
from xwrl_audit_log
;

select unique table_name
from xwrl_audit_log
;

SELECT to_date('05/01/2020','MM/DD/YYYY') FROM DUAL;

SELECT COUNT(*) FROM  xwrl_audit_log;

delete from xwrl_audit_log
where creation_date < to_date('07/01/2020','MM/DD/YYYY')
;





update xwrl.xwrl_party_master
set request_id = 249235
where id = 505095;

update xwrl.xwrl_party_alias
set request_id = 249237
where id = 306364;

update xwrl.xwrl_party_alias
set request_id = 249239
where id = 306365;

update xwrl.xwrl_party_master
set request_id = 249240
where id = 607054;

SELECT
         t.id,
         --x.rec,
         DENSE_RANK () OVER (PARTITION BY ID ORDER BY LISTID) REC,
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
         t.id = :p_id  -- Individual
         ORDER BY REC, DECODE(LISTNAMETYPE,'Primary',1,'Alias',2,3)
         ;




      SELECT
         t.id
         --x.rec,
         DENSE_RANK () OVER (PARTITION BY ID ORDER BY LISTID) REC,         
,x.ListSubKey
,x.ListRecordType
,x.ListRecordOrigin
,x.CustId
,x.CustSubId
,x.RegistrationNumber
,x.EntityName
,x.NameType
,x.NameQuality
,x.PrimaryName
,x.OriginalScriptName
,x.AliasIsAcronym
,x.Address1
,x.Address2
,x.Address3
,x.Address4
,x.City
,x.State
,x.PostalCode
,x.AddressCountryCode
,x.RegistrationCountryCode
,x.OperatingCountryCodes
,x.ProfileHyperlink
,x.RiskScore
,x.DataConfidenceScore
,x.DataConfidenceComment
,x.CustomString1
,x.CustomString2
,x.CustomString3
,x.CustomString4
,x.CustomString5
,x.CustomString6
,x.CustomString7
,x.CustomString8
,x.CustomString9
,x.CustomString10
,x.CustomString11
,x.CustomString12
,x.CustomString13
,x.CustomString14
,x.CustomString15
,x.CustomString16
,x.CustomString17
,x.CustomString18
,x.CustomString19
,x.CustomString20
,x.CustomString21
,x.CustomString22
,x.CustomString23
,x.CustomString24
,x.CustomString25
,x.CustomString26
,x.CustomString27
,x.CustomString28
,x.CustomString29
,x.CustomString30
,x.CustomString31
,x.CustomString32
,x.CustomString33
,x.CustomString34
,x.CustomString35
,x.CustomString36
,x.CustomString37
,x.CustomString38
,x.CustomString39
,x.CustomString40
,x.CustomDate1
,x.CustomDate2
,x.CustomDate3
,x.CustomDate4
,x.CustomDate5
,x.CustomNumber1
,x.CustomNumber2
,x.CustomNumber3
,x.CustomNumber4
,x.CustomNumber5
      FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "ws"), '//ws:request' PASSING t.request COLUMNS rec FOR ORDINALITY, listsubkey VARCHAR2 (2700) PATH 'ws:ListSubKey', listrecordtype VARCHAR2 (2700) PATH 'ws:ListRecordType', listrecordorigin VARCHAR2 (2700) PATH 'ws:ListRecordOrigin', custid VARCHAR2 (2700) PATH 'ws:CustId', custsubid VARCHAR2 (2700) PATH 'ws:CustSubId', registrationnumber VARCHAR2 (2700) PATH 'ws:RegistrationNumber'
         , entityname VARCHAR2 (2700) PATH 'ws:EntityName', nametype VARCHAR2 (2700) PATH 'ws:NameType', namequality VARCHAR2 (2700) PATH 'ws:NameQuality', primaryname VARCHAR2 (2700) PATH 'ws:PrimaryName', originalscriptname VARCHAR2 (2700) PATH 'ws:OriginalScriptName', aliasisacronym VARCHAR2 (2700) PATH 'ws:AliasIsAcronym', address1 VARCHAR2 (2700) PATH 'ws:Address1', address2 VARCHAR2 (2700) PATH 'ws:Address2', address3 VARCHAR2 (2700) PATH 'ws:Address3', address4 VARCHAR2 (2700) PATH 'ws:Address4'
         , city VARCHAR2 (2700) PATH 'ws:City', state VARCHAR2 (2700) PATH 'ws:State', postalcode VARCHAR2 (2700) PATH 'ws:PostalCode', addresscountrycode VARCHAR2 (2700) PATH 'ws:AddressCountryCode', registrationcountrycode VARCHAR2 (2700) PATH 'ws:RegistrationCountryCode', OperatingCountryCodes VARCHAR2 (2700) PATH 'ws:OperatingCountryCodes', profilehyperlink VARCHAR2 (2700) PATH 'ws:ProfileHyperlink', riskscore VARCHAR2 (2700) PATH 'ws:RiskScore', dataconfidencescore VARCHAR2 (2700) PATH 'ws:DataConfidenceScore'
         , dataconfidencecomment VARCHAR2 (2700) PATH 'ws:DataConfidenceComment', customstring1 VARCHAR2 (2700) PATH 'ws:CustomString1', customstring2 VARCHAR2 (2700) PATH 'ws:CustomString2', customstring3 VARCHAR2 (2700) PATH 'ws:CustomString3', customstring4 VARCHAR2 (2700) PATH 'ws:CustomString4', customstring5 VARCHAR2 (2700) PATH 'ws:CustomString5', customstring6 VARCHAR2 (2700) PATH 'ws:CustomString6', customstring7 VARCHAR2 (2700) PATH 'ws:CustomString7', customstring8 VARCHAR2 (2700) PATH
         'ws:CustomString8', customstring9 VARCHAR2 (2700) PATH 'ws:CustomString9', customstring10 VARCHAR2 (2700) PATH 'ws:CustomString10', customstring11 VARCHAR2 (2700) PATH 'ws:CustomString11', customstring12 VARCHAR2 (2700) PATH 'ws:CustomString12', customstring13 VARCHAR2 (2700) PATH 'ws:CustomString13', customstring14 VARCHAR2 (2700) PATH 'ws:CustomString14', customstring15 VARCHAR2 (2700) PATH 'ws:CustomString15', customstring16 VARCHAR2 (2700) PATH 'ws:CustomString16', customstring17 VARCHAR2
         (2700) PATH 'ws:CustomString17', customstring18 VARCHAR2 (2700) PATH 'ws:CustomString18', customstring19 VARCHAR2 (2700) PATH 'ws:CustomString19', customstring20 VARCHAR2 (2700) PATH 'ws:CustomString20', customstring21 VARCHAR2 (2700) PATH 'ws:CustomString21', customstring22 VARCHAR2 (2700) PATH 'ws:CustomString22', customstring23 VARCHAR2 (2700) PATH 'ws:CustomString23', customstring24 VARCHAR2 (2700) PATH 'ws:CustomString24', customstring25 VARCHAR2 (2700) PATH 'ws:CustomString25', customstring26
         VARCHAR2 (2700) PATH 'ws:CustomString26', customstring27 VARCHAR2 (2700) PATH 'ws:CustomString27', customstring28 VARCHAR2 (2700) PATH 'ws:CustomString28', customstring29 VARCHAR2 (2700) PATH 'ws:CustomString29', customstring30 VARCHAR2 (2700) PATH 'ws:CustomString30', customstring31 VARCHAR2 (2700) PATH 'ws:CustomString31', customstring32 VARCHAR2 (2700) PATH 'ws:CustomString32', customstring33 VARCHAR2 (2700) PATH 'ws:CustomString33', customstring34 VARCHAR2 (2700) PATH 'ws:CustomString34'
         , customstring35 VARCHAR2 (2700) PATH 'ws:CustomString35', customstring36 VARCHAR2 (2700) PATH 'ws:CustomString36', customstring37 VARCHAR2 (2700) PATH 'ws:CustomString37', customstring38 VARCHAR2 (2700) PATH 'ws:CustomString38', customstring39 VARCHAR2 (2700) PATH 'ws:CustomString39', customstring40 VARCHAR2 (2700) PATH 'ws:CustomString40', customdate1 VARCHAR2 (2700) PATH 'ws:CustomDate1', customdate2 VARCHAR2 (2700) PATH 'ws:CustomDate2', customdate3 VARCHAR2 (2700) PATH 'ws:CustomDate3'
         , customdate4 VARCHAR2 (2700) PATH 'ws:CustomDate4', customdate5 VARCHAR2 (2700) PATH 'ws:CustomDate5', customnumber1 VARCHAR2 (2700) PATH 'ws:CustomNumber1', customnumber2 VARCHAR2 (2700) PATH 'ws:CustomNumber2', customnumber3 VARCHAR2 (2700) PATH 'ws:CustomNumber3', customnumber4 VARCHAR2 (2700) PATH 'ws:CustomNumber4', customnumber5 VARCHAR2 (2700) PATH 'ws:CustomNumber5') x
      WHERE
         t.id = p_id -- Entity
ORDER BY REC, DECODE(LISTNAMETYPE,'Primary',1,'Alias',2,3)         
         ;
         
         
         
         
      SELECT
         t.id,
         --x.rec,
         DENSE_RANK () OVER (PARTITION BY ID ORDER BY LISTID) REC,   
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
		x.RiskScorePEP,
		x.Category,
		x.dnRegistrationNumber,
		x.dnOriginalEntityName,
		x.dnEntityName,
		x.dnNameType,
		x.dnNameQuality,
		x.dnPrimaryName,
		x.dnVesselIndicator,
		x.dnVesselInfo,
		x.dnAddress,
		x.dnCity,
		x.dnState,
		x.dnPostalCode,
		x.dnAddressCountryCode,
		x.dnRegistrationCountryCode,
		x.dnOperatingCountryCodes,
		x.dnPEPClassification,
		x.dnAllCountryCodes,
		x.ExternalSources,
		x.CachedExtSources,
		x.dnInactiveFlag,
		x.dnInactiveSinceDate,
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
RiskScorePEP varchar2(2700) path 'dn:RiskScorePEP',
Category varchar2(2700) path 'dn:Category',
dnRegistrationNumber varchar2(2700) path 'dn:dnRegistrationNumber',
dnOriginalEntityName varchar2(2700) path 'dn:dnOriginalEntityName',
dnEntityName varchar2(2700) path 'dn:dnEntityName',
dnNameType varchar2(2700) path 'dn:dnNameType',
dnNameQuality varchar2(2700) path 'dn:dnNameQuality',
dnPrimaryName varchar2(2700) path 'dn:dnPrimaryName',
dnVesselIndicator varchar2(2700) path 'dn:dnVesselIndicator',
dnVesselInfo varchar2(2700) path 'dn:dnVesselInfo',
dnAddress varchar2(2700) path 'dn:dnAddress',
dnCity varchar2(2700) path 'dn:dnCity',
dnState varchar2(2700) path 'dn:dnState',
dnPostalCode varchar2(2700) path 'dn:dnPostalCode',
dnAddressCountryCode varchar2(2700) path 'dn:dnAddressCountryCode',
dnRegistrationCountryCode varchar2(2700) path 'dn:dnRegistrationCountryCode',
dnOperatingCountryCodes varchar2(2700) path 'dn:dnOperatingCountryCodes',
dnPEPClassification varchar2(2700) path 'dn:dnPEPClassification',
dnAllCountryCodes varchar2(2700) path 'dn:dnAllCountryCodes',
ExternalSources varchar2(2700) path 'dn:ExternalSources',
CachedExtSources varchar2(2700) path 'dn:CachedExtSources',
dnInactiveFlag varchar2(2700) path 'dn:dnInactiveFlag',
dnInactiveSinceDate varchar2(2700) path 'dn:dnInactiveSinceDate',
dnAddedDate varchar2(2700) path 'dn:dnAddedDate',
dnLastUpdatedDate varchar2(2700) path 'dn:dnLastUpdatedDate') x
      WHERE
         t.id = 249885 -- Entity
         ORDER BY REC, DECODE(LISTNAMETYPE,'Primary',1,'Alias',2,3)    
         ;         
         
         
         
select *
from xwrl_party_master
where source_table = 'SICD_SEAFARERS'
and source_table_column = 'SEAFARER_ID'
and source_id =  826655;  -- YOUNG SIK KIM

select *
from xwrl_party_master
where id = 501830;

select *
from xwrl_requests
where master_id = 501830;

select *
from xwrl_alert_clearing_xref
where master_id = 501830;

update xwrl_requests
set expiration_date = expiration_date - 1
where master_id = 501830
and batch_id = 67974
;

update xwrl_requests
set expiration_date = expiration_date - 1
where master_id = 397889
and batch_id = 67978
;

delete from xwrl_alert_clearing_xref
where master_id = 501830;

select i.request_id, r.name_screened,r.case_id,i.alertid,i.rec,listid, i.listrecordtype, i.listfullname, i.x_state, n.line_number, n.note, n.creation_date, n.created_by
from xwrl_response_ind_columns  i
,xwrl_requests r
,xwrl_note_xref x
,XWRL_ALERT_NOTES n
where i.request_id = r.id
and r.batch_id = 67956
and i.listid = 2866707
and i.request_id = x.request_id (+)
and i.alertid = x.alert_id (+)
and x.note_id = n.id (+)
order by request_id, rec
;

-- Closed Batch 67959
-- Open Batch 67943

/*

In statusboard,

1) Find YOUNGSIK KIM
2) Sort by UID
3) Clear Alert Record 8 with UID 1196604 with User Review and Possible record state
4) It should Auto Clear Record 66 with User Review and Possible record state
5) Clear Alert Record 66 with UID 1196604 with Full Vetting ... and False Positive record state
6) It should Auto Clear Record 8 with Full Vetting ... and False Positive record state
7) Record 8 and 66 should both have 2 Notes in tota l(User Review & Full Vetting ...)
8) Find YOUNG SIK KIM
9) Sort by UID
10) It should Auto Clear Record 13 with Full Vetting ... and False Positive record state
11) It should Auto Clear Record 96 with Full Vetting ... and False Positive record state
12) Record 13 and 96 should both have 2 Notes in total (User Review & Full Vetting ...)
13) Clear Record 41 with UID 	1279947	with User Review and Possible record state  (Note: accidental false positive will cause failure for Chinese name)
14) It should Auto Clear Record 48 with User Review and Possible record state
15) Clear Alert Record 48 with UID 1196604 with Chinese Name is not a match and False Positive record state
16) It should Auto Clear Record 41 with Chinese Name is not a match and False Positive record state
17) Record 41 and 48 should both have 2 Notes in tota l(User Review & Chinese Name is not a match)
18) Refresh YOUNGSIK KIM
19) It should Auto Clear Record 28 with User Review & Chinese Name and Possible record state
20) It should Auto Clear Record 33 with User Review & Chinese Name and Possible record state
21) Find YOUNGSIK KIM
22) Add a Case Note
23) Upload a Case Document
24) Upload a DPC
25) Clear All Open Alerts
26) Close All Cases
27) Re-Run TC

NOTE: The Case Notes and Case Documents were there.  The Alerts contains the last alert.  Do we need the history?

*/



declare

v_source_table varchar2(4000);
v_source_table_column varchar2(4000);
v_source_id varchar2(4000);

x_batch_id integer;
x_return_status varchar2(4000);
x_return_msg varchar2(4000);

begin

fnd_global.apps_initialize (1156, 52369, 20003);


v_source_table := 'SICD_SEAFARERS';
v_source_table_column := 'SEAFARER_ID';
v_source_id :=  826655;

/*
v_source_table := 'CORP_MAIN';
v_source_table_column := 'CORP_ID';
v_source_id :=  1111896;
*/

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


begin
fnd_global.apps_initialize (1156, 52369, 20003);
xwrl_ows_utils.auto_clear_individuals(1156,999,143916);
end;
/

select n.id, n.request_id, n.case_key, n.alert_id, n.list_id,  n.from_state, n.to_state, note, n.master_id, n.alias_id, n.xref_id, n.created_by
from xwrl_alert_clearing_xref n
where exists (select 1
from xwrl_requests r
where r.id = n.request_id
and r.batch_id = 67980)
order by alert_id desc, list_id desc
;

select i.request_id, r.name_screened,r.case_id,i.alertid,i.rec,listid, i.listrecordtype, i.listfullname, i.x_state, n.line_number, n.note, n.creation_date, n.created_by
from xwrl_response_ind_columns  i
,xwrl_requests r
,xwrl_note_xref x
,XWRL_ALERT_NOTES n
where i.request_id = r.id
and r.batch_id = 67980
--and i.listid = 2866707
and i.request_id = x.request_id (+)
and i.alertid = x.alert_id (+)
and x.note_id = n.id (+)
order by request_id desc, alertid desc, rec desc, line_number desc
;

select i.request_id, r.name_screened,r.case_id,i.alertid,i.rec,listid, i.listrecordtype, i.listfullname, i.x_state, n.line_number, n.note, n.creation_date, n.created_by
from xwrl_response_entity_columns  i
,xwrl_requests r
,xwrl_note_xref x
,XWRL_ALERT_NOTES n
where i.request_id = r.id
and r.batch_id = 67975
--and i.listid = 2866707
and i.request_id = x.request_id (+)
and i.alertid = x.alert_id (+)
and x.note_id = n.id (+)
order by request_id desc, alertid desc, rec desc, line_number desc
;
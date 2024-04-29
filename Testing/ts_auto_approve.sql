Select ID, NAME_SCREENED, CASE_STATE, CASE_WORKFLOW, CASE_STATUS, DEPARTMENT
from xwrl_requests
where department = 'VESDOC'
and case_status = 'O'
;

alter trigger XWRL.XWRL_REQUESTS_INS_UPD disable;

alter trigger XWRL.XWRL_REQUESTS_INS_UPD enable;

declare
cursor c1 is
select ID, NAME_SCREENED, CASE_STATE, CASE_WORKFLOW, CASE_STATUS, DEPARTMENT
from xwrl_requests
where department = 'VESDOC'
and case_status = 'O'
;

      V_return_code                     NUMBER;
      V_return_message                  VARCHAR2(4000);

begin

for c1rec in c1 loop

rmi_ows_common_util.approve_screening_request(c1rec.id, V_return_code, V_return_message);

end loop;

end;
/

select * from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
union
select * from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com;


select * from IRIP1_EDQCONFIG.dn_casecomment@ebstoows2.coresys.com
union
select * from IRIP2_EDQCONFIG.dn_casecomment@ebstoows2.coresys.com
;

select col.request_id, col.x_state, col.listid, col.casekey, col.alertid, col.creation_date, col.created_by, col.last_update_date, col.last_updated_by, col.last_update_login, req.source_table, req.source_id
from xwrl_response_ind_columns col
,xwrl_requests req
,xwrl_alert_notes n
where x_state not like '%Open'
and col.request_id = req.id
and col.request_id = n.request_id (+)
and n.request_id is null
group by col.request_id, col.x_state, col.listid, col.casekey, col.alertid, col.creation_date, col.created_by, col.last_update_date, col.last_updated_by, col.last_update_login, req.source_table, req.source_id
;

select *
from xwrl_alert_clearing_xref
where source_table = 'SICD_SEAFARERS'
and source_id = 1321790
;

select *
from xwrl_alert_notes
order by id desc;

declare

cursor c1 is
select col.request_id, col.x_state, col.listid, col.casekey, col.alertid, col.creation_date, col.created_by, col.last_update_date, col.last_updated_by, col.last_update_login, req.source_table, req.source_id
from xwrl_response_ind_columns col
,xwrl_requests req
,xwrl_alert_notes n
where x_state not like '%Open'
and col.request_id = req.id
and col.request_id = n.request_id (+)
and n.request_id is null
group by col.request_id, col.x_state, col.listid, col.casekey, col.alertid, col.creation_date, col.created_by, col.last_update_date, col.last_updated_by, col.last_update_login, req.source_table, req.source_id
;

cursor c2 (p_list_id integer, p_source_table varchar2, p_source_id integer) is
select xref.source_table, xref.source_id, xref.list_id, max(id) max_id
from xwrl_alert_clearing_xref xref
where xref.source_table = p_source_table
and xref.source_id = p_source_id
and xref.list_id = p_list_id
group by xref.source_table, xref.source_id, xref.list_id
;            

v_line_number integer;
v_note varchar2(3000);

v_ctr integer;

begin

for c1rec in c1 loop

v_ctr := 0;

for c2rec in c2(c1rec.listid, c1rec.source_table, c1rec.source_id) loop

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
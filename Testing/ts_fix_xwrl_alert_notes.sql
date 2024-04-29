with xref as
(select x.id, x.master_id, x.alias_id, x.xref_id, x.list_id, x.alert_id
from xwrl_note_xref x)
select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login
from xwrl_response_ind_columns c
,xwrl_requests r
,xref x
where c.request_id = r.id
and r.master_id = x.master_id (+)
and decode(r.alias_id ,nvl(x.alias_id (+),r.alias_id),1,0) = 1
and decode(r.xref_id ,nvl(x.xref_id (+),r.xref_id),1,0) = 1
and c.listid = x.list_id (+)
and c.alertid = x.alert_id (+)
and x.id is null
;

declare

cursor cMain is 
with xref as
(select x.id, x.master_id, x.alias_id, x.xref_id, x.list_id, x.alert_id
from xwrl_note_xref x)
select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login
from xwrl_response_ind_columns c
,xwrl_requests r
,xref x
where c.request_id = r.id
and r.master_id = x.master_id (+)
and decode(r.alias_id ,nvl(x.alias_id (+),r.alias_id),1,0) = 1
and decode(r.xref_id ,nvl(x.xref_id (+),r.xref_id),1,0) = 1
and c.listid = x.list_id (+)
and c.alertid = x.alert_id (+)
and x.id is null
order by r.id desc, c.listid desc, c.creation_date desc
;

cursor c1 (p_master_id number, p_listid number, p_batch_id number) is
select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login, n.line_number, n.id note_id, n.note
from xwrl_response_ind_columns c
,xwrl_requests r
,xwrl_note_xref x
,xwrl_alert_notes n
where c.request_id = r.id 
and c.request_id = x.request_id 
and c.alertid = x.alert_id
and x.note_id = n.id
and r.master_id = p_master_id
and decode(r.alias_id ,nvl(x.alias_id,r.alias_id),1,0) = 1
and decode(r.xref_id ,nvl(x.alias_id,r.xref_id),1,0) = 1
and c.listid = p_listid
;

   v_rec xwrl_note_xref%ROWTYPE;
   v_count integer;
   v_line_count integer;

begin

v_count := 0;

for cMainRec in cMain loop

v_line_count := 0;

for c1rec  in c1(cMainRec.master_id, cMainRec.listid, cMainRec.batch_id) loop


            v_rec.note_id := c1rec.note_id;
             v_rec.request_id := cMainRec.request_id;
             v_rec.alert_id := cMainRec.alert_id;
             v_rec.line_number := c1rec.line_number;
             v_rec.case_key := cMainRec.casekey;
             v_rec.master_id := cMainRec.master_id;
             v_rec.alias_id := cMainRec.alias_id;
             v_rec.xref_id := cMainRec.xref_id;
             v_rec.source_table := cMainRec.source_table;
             v_rec.source_table_column := cMainRec.source_table_column;
             v_rec.source_id := cMainRec.source_id;
             v_rec.list_id := cMainRec.listid;                        
             v_rec.to_state := null;
             v_rec.from_state := cMainRec.x_state;
             v_rec.enabled_flag := 'Y';
             v_rec.status := 'N';
             v_rec.record_comment := 'data fix script: '||c1rec.alert_id;
             v_rec.last_update_date := c1rec.last_update_date;
             v_rec.last_updated_by := c1rec.last_updated_by;
             v_rec.creation_date := c1rec.creation_date;
             v_rec.created_by := c1rec.created_by;
             v_rec.last_update_login := c1rec.last_update_login;
             
             insert into xwrl_note_xref values v_rec;
             
             v_count := v_count + 1;
             v_line_count := v_line_count + 1;
             
             if v_count = 100 then
             
             commit;
             v_count := 0;
             
             end if;
             
             --if v_line_count > 0 then
             --   exit;
            ---end if;

end loop;

end loop;

commit;

end;
/

with xref as
(select x.id, x.master_id, x.alias_id, x.xref_id, x.list_id, x.alert_id
from xwrl_note_xref x)
select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login
from xwrl_response_entity_columns c
,xwrl_requests r
,xref x
where c.request_id = r.id
and r.master_id = x.master_id (+)
and decode(r.alias_id ,nvl(x.alias_id (+),r.alias_id),1,0) = 1
and decode(r.xref_id ,nvl(x.xref_id (+),r.xref_id),1,0) = 1
and c.listid = x.list_id (+)
and c.alertid = x.alert_id (+)
and x.id is null
;

declare

cursor cMain is 
with xref as
(select x.id, x.master_id, x.alias_id, x.xref_id, x.list_id, x.alert_id
from xwrl_note_xref x)
select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login
from xwrl_response_entity_columns c
,xwrl_requests r
,xref x
where c.request_id = r.id
and r.master_id = x.master_id (+)
and decode(r.alias_id ,nvl(x.alias_id (+),r.alias_id),1,0) = 1
and decode(r.xref_id ,nvl(x.xref_id (+),r.xref_id),1,0) = 1
and c.listid = x.list_id (+)
and c.alertid = x.alert_id (+)
and x.id is null
order by r.id desc, c.listid desc, c.creation_date desc
;

cursor c1 (p_master_id number, p_listid number, p_batch_id number) is
select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login, n.line_number, n.id note_id, n.note
from xwrl_response_entity_columns c
,xwrl_requests r
,xwrl_note_xref x
,xwrl_alert_notes n
where c.request_id = r.id 
and c.request_id = x.request_id 
and c.alertid = x.alert_id
and x.note_id = n.id
and r.master_id = p_master_id
and decode(r.alias_id ,nvl(x.alias_id,r.alias_id),1,0) = 1
and decode(r.xref_id ,nvl(x.alias_id,r.xref_id),1,0) = 1
and c.listid = p_listid
;

   v_rec xwrl_note_xref%ROWTYPE;
   v_count integer;
   v_line_count integer;

begin

v_count := 0;

for cMainRec in cMain loop

v_line_count := 0;

for c1rec  in c1(cMainRec.master_id, cMainRec.listid, cMainRec.batch_id) loop

            v_rec.note_id := c1rec.note_id;
             v_rec.request_id := cMainRec.request_id;
             v_rec.alert_id := cMainRec.alert_id;
             v_rec.line_number := c1rec.line_number;
             v_rec.case_key := cMainRec.casekey;
             v_rec.master_id := cMainRec.master_id;
             v_rec.alias_id := cMainRec.alias_id;
             v_rec.xref_id := cMainRec.xref_id;
             v_rec.source_table := cMainRec.source_table;
             v_rec.source_table_column := cMainRec.source_table_column;
             v_rec.source_id := cMainRec.source_id;
             v_rec.list_id := cMainRec.listid;                        
             v_rec.to_state := null;
             v_rec.from_state := cMainRec.x_state;
             v_rec.enabled_flag := 'Y';
             v_rec.status := 'N';
             v_rec.record_comment := 'data fix script: '||c1rec.alert_id;
             v_rec.last_update_date := c1rec.last_update_date;
             v_rec.last_updated_by := c1rec.last_updated_by;
             v_rec.creation_date := c1rec.creation_date;
             v_rec.created_by := c1rec.created_by;
             v_rec.last_update_login := c1rec.last_update_login;
             
             insert into xwrl_note_xref values v_rec;
             
             v_count := v_count + 1;
             v_line_count := v_line_count + 1;
             
             if v_count = 100 then
             
             commit;
             v_count := 0;
             
             end if;
             
             --if v_line_count > 0 then
             --   exit;
            --end if;

end loop;

end loop;

commit;

end;
/
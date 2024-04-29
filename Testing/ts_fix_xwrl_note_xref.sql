select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login, n.line_number, n.id note_id
from xwrl_alert_notes n
,xwrl_response_ind_columns c
,xwrl_requests r
where n.request_id = r.id 
and n.request_id = c.request_id
and n.alert_id = c.alertid
and not exists (select 1 from xwrl_note_xref x where x.note_id = n.id);

declare

cursor c1 is 
select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login, n.line_number, n.id note_id
from xwrl_alert_notes n
,xwrl_response_ind_columns c
,xwrl_requests r
where n.request_id = r.id 
and n.request_id = c.request_id
and n.alert_id = c.alertid
and not exists (select 1 from xwrl_note_xref x where x.note_id = n.id);

   v_rec xwrl_note_xref%ROWTYPE;
   v_count integer;

begin

for c1rec in c1 loop

            v_rec.note_id := c1rec.note_id;
             v_rec.request_id := c1rec.request_id;
             v_rec.alert_id := c1rec.alert_id;
             v_rec.line_number := c1rec.line_number;
             v_rec.case_key := c1rec.casekey;
             v_rec.master_id := c1rec.master_id;
             v_rec.alias_id := c1rec.alias_id;
             v_rec.xref_id := c1rec.xref_id;
             v_rec.source_table := c1rec.source_table;
             v_rec.source_table_column := c1rec.source_table_column;
             v_rec.source_id := c1rec.source_id;
             v_rec.list_id := c1rec.listid;                        
             v_rec.to_state := null;
             v_rec.from_state := c1rec.x_state;
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
             
             if v_count = 1000 then
             
             commit;
             v_count := 0;
             
             end if;

end loop;

commit;

end;
/

select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login, n.line_number, n.id note_id
from xwrl_alert_notes n
,xwrl_response_entity_columns c
,xwrl_requests r
where n.request_id = r.id 
and n.request_id = c.request_id
and n.alert_id = c.alertid
and not exists (select 1 from xwrl_note_xref x where x.note_id = n.id);

declare

cursor c1 is 
select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login, n.line_number, n.id note_id
from xwrl_alert_notes n
,xwrl_response_entity_columns c
,xwrl_requests r
where n.request_id = r.id 
and n.request_id = c.request_id
and n.alert_id = c.alertid
and not exists (select 1 from xwrl_note_xref x where x.note_id = n.id);

   v_rec xwrl_note_xref%ROWTYPE;
   v_count integer;

begin

for c1rec in c1 loop

            v_rec.note_id := c1rec.note_id;
             v_rec.request_id := c1rec.request_id;
             v_rec.alert_id := c1rec.alert_id;
             v_rec.line_number := c1rec.line_number;
             v_rec.case_key := c1rec.casekey;
             v_rec.master_id := c1rec.master_id;
             v_rec.alias_id := c1rec.alias_id;
             v_rec.xref_id := c1rec.xref_id;
             v_rec.source_table := c1rec.source_table;
             v_rec.source_table_column := c1rec.source_table_column;
             v_rec.source_id := c1rec.source_id;
             v_rec.list_id := c1rec.listid;                        
             v_rec.to_state := null;
             v_rec.from_state := c1rec.x_state;
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
             
             if v_count = 1000 then
             
             commit;
             v_count := 0;
             
             end if;

end loop;

commit;

end;
/
/* FIX INDIVIDUALS */

declare

p_request_id integer := :request_id;
p_column_id integer := :column_id;
v_count integer;
p_update boolean := false;
p_user            VARCHAR2 (200);
p_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
x_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;
x_status          VARCHAR2 (200);
   
 v_msg varchar2(4000);

cursor c1 is
select req.id, req.batch_id, req.case_id,  req.master_id, req.alias_id, req.xref_id, req.name_screened, req.case_status, req.case_state, req.case_workflow, req.created_by, req.creation_date, usr.user_name
from xwrl_requests req
,fnd_user usr
where req.created_by = usr.user_id 
and req.id = p_request_id
;

cursor c2 is
select col.ID, col.request_id, col.listid, col.listrecordtype, col.listfullname, col.listnametype, col.alertid, col.matchrule, col.x_state, substr(col.x_state, 7)  x_type, xwrl_ows_utils.ChangeToOwsState(col.x_state) to_state, col.created_by, col.creation_date, usr.user_name
from xwrl_response_ind_columns col
,fnd_user usr
where col.created_by = usr.user_id 
and col.request_id = p_request_id
and col.id = p_column_id
order by listid
;

cursor c3 (p_master_id integer, p_alias_id integer, p_xref_id integer, p_list_id integer) is
select xref.id, xref.request_id, xref.alert_id, xref.list_id, xref.from_state, xref.to_state, xref.note, xref.master_id, xref.alias_id, xref.xref_id, xref.created_by, xref.creation_date, usr.user_name
from xwrl_alert_clearing_xref xref
,fnd_user usr
where xref.created_by = usr.user_id 
--and xref.request_id = :request_id
and xref.master_id = p_master_id
and xref.list_id = p_list_id
and nvl(xref.alias_id,-1) = nvl(p_alias_id,-1)
and nvl(xref.xref_id,-1) = nvl(p_xref_id,-1)
and rownum = 1
order by list_id desc, id desc
;

cursor c4 (p_alert_id varchar2) is
select note.id, note.request_id, note.alert_id, note.line_number, note.note, note.created_by, note.creation_date, usr.user_name
from xwrl_alert_notes note
,fnd_user usr
where note.created_by = usr.user_id 
and note.request_id = p_request_id
and note.alert_id = p_alert_id
and rownum = 1
order by note.id desc
;

begin

v_count := 0;

for c1rec in c1 loop

for c2rec in c2 loop

for c3rec in c3 (c1rec.master_id, c1rec.alias_id, c1rec.xref_id, c2rec.listid) loop

v_count := v_count + 1;

dbms_output.put_line('Index ID: '||v_count);
dbms_output.put_line('Master ID: '||c1rec.master_id);
dbms_output.put_line('Alias ID: '||c1rec.alias_id);
dbms_output.put_line('Xref ID: '||c1rec.xref_id);
dbms_output.put_line('List ID: '||c2rec.alertid);
dbms_output.put_line('List ID: '||c2rec.listid);
dbms_output.put_line('To  State: '||c2rec.to_state);
dbms_output.put_line('Clearing Note: '||c3rec.note);
dbms_output.put_line('Clearing User: '||c3rec.user_name);

for c4rec in c4 (c2rec.alertid) loop

dbms_output.put_line('Alert Note: '||c4rec.note);
dbms_output.put_line('Alert User: '||c4rec.user_name);

end loop; -- end c4

dbms_output.put_line(chr(13));

if p_update then

dbms_output.put_line('Performing Update');

p_user := c3rec.user_name;
 p_alert_in_tbl (1).alert_id := c2rec.alertid;
p_alert_in_tbl (1).to_state := c2rec.to_state;
p_alert_in_tbl (1).comment := c3rec.note;

xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com (p_user => p_user, p_alert_in_tbl => p_alert_in_tbl, x_alert_out_tbl => x_alert_out_tbl, x_status => x_status);

commit;

FOR j IN x_alert_out_tbl.first..x_alert_out_tbl.last LOOP 

begin
dbms_output.put_line ('ALert ID: ' || x_alert_out_tbl (j).alert_id || ' New State: ' || x_alert_out_tbl (j).new_state || ' status: ' || x_alert_out_tbl (j).status || ' err_msg: ' || x_alert_out_tbl (j).err_msg || ' Overall status: ' || x_status);
exception
when others then 
v_msg := sqlerrm;
dbms_output.put_line(sqlerrm);
end;

END LOOP;


end if;

end loop; -- end c3

end loop; -- end c2

end loop;  -- end c1

end;
/



/* FIX ENTITIES */

declare

p_request_id integer := :request_id;
p_column_id integer := :column_id;
v_count integer;
p_update boolean := false;

p_user            VARCHAR2 (200);
p_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
x_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;
x_status          VARCHAR2 (200);
   
 v_msg varchar2(4000);

cursor c1 is
select req.id, req.batch_id, req.case_id,  req.master_id, req.alias_id, req.xref_id, req.name_screened, req.case_status, req.case_state, req.case_workflow, req.created_by, req.creation_date, usr.user_name
from xwrl_requests req
,fnd_user usr
where req.created_by = usr.user_id 
and req.id = p_request_id
;

cursor c2 is
select col.ID, col.request_id, col.listid, col.listrecordtype, col.listentityname, col.listnametype, col.alertid, col.matchrule, col.x_state, substr(col.x_state, 7)  x_type, xwrl_ows_utils.ChangeToOwsState(col.x_state) to_state, col.created_by, col.creation_date, usr.user_name
from xwrl_response_entity_columns col
,fnd_user usr
where col.created_by = usr.user_id 
and col.request_id = p_request_id
and col.id = p_column_id
order by listid
;

cursor c3 (p_master_id integer, p_alias_id integer, p_xref_id integer, p_list_id integer) is
select xref.id, xref.request_id, xref.alert_id, xref.list_id, xref.from_state, xref.to_state, xref.note, xref.master_id, xref.alias_id, xref.xref_id, xref.created_by, xref.creation_date, usr.user_name
from xwrl_alert_clearing_xref xref
,fnd_user usr
where xref.created_by = usr.user_id 
--and xref.request_id = :request_id
and xref.master_id = p_master_id
and xref.list_id = p_list_id
and nvl(xref.alias_id,-1) = nvl(p_alias_id,-1)
and nvl(xref.xref_id,-1) = nvl(p_xref_id,-1)
and rownum = 1
order by list_id desc, id desc
;

cursor c4 (p_alert_id varchar2) is
select note.id, note.request_id, note.alert_id, note.line_number, note.note, note.created_by, note.creation_date, usr.user_name
from xwrl_alert_notes note
,fnd_user usr
where note.created_by = usr.user_id 
and note.request_id = p_request_id
and note.alert_id = p_alert_id
and rownum = 1
order by note.id desc
;

begin

v_count := 0;

for c1rec in c1 loop

for c2rec in c2 loop

for c3rec in c3 (c1rec.master_id, c1rec.alias_id, c1rec.xref_id, c2rec.listid) loop

v_count := v_count + 1;

dbms_output.put_line('Index ID: '||v_count);
dbms_output.put_line('Master ID: '||c1rec.master_id);
dbms_output.put_line('Alias ID: '||c1rec.alias_id);
dbms_output.put_line('Xref ID: '||c1rec.xref_id);
dbms_output.put_line('List ID: '||c2rec.alertid);
dbms_output.put_line('List ID: '||c2rec.listid);
dbms_output.put_line('To  State: '||c2rec.to_state);
dbms_output.put_line('Clearing Note: '||c3rec.note);
dbms_output.put_line('Clearing User: '||c3rec.user_name);

for c4rec in c4 (c2rec.alertid) loop

dbms_output.put_line('Alert Note: '||c4rec.note);
dbms_output.put_line('Alert User: '||c4rec.user_name);

end loop; -- end c4

dbms_output.put_line(chr(13));

if p_update then

dbms_output.put_line('Performing Update');

p_user := c3rec.user_name;
 p_alert_in_tbl (1).alert_id := c2rec.alertid;
p_alert_in_tbl (1).to_state := c2rec.to_state;
p_alert_in_tbl (1).comment := c3rec.note;

xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com (p_user => p_user, p_alert_in_tbl => p_alert_in_tbl, x_alert_out_tbl => x_alert_out_tbl, x_status => x_status);

commit;

FOR j IN x_alert_out_tbl.first..x_alert_out_tbl.last LOOP 

begin
dbms_output.put_line ('ALert ID: ' || x_alert_out_tbl (j).alert_id || ' New State: ' || x_alert_out_tbl (j).new_state || ' status: ' || x_alert_out_tbl (j).status || ' err_msg: ' || x_alert_out_tbl (j).err_msg || ' Overall status: ' || x_status);
exception
when others then 
v_msg := sqlerrm;
dbms_output.put_line(sqlerrm);
end;

END LOOP;


end if;

end loop; -- end c3

end loop; -- end c2

end loop;  -- end c1

end;
/
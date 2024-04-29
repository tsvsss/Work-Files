xwrl_ows_utils

/*
Request 14671     34282

Master ID 523879
Alias ID 316779
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


select *
from xwrl_response_ind_columns
where request_id = :request_id
order by id desc
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

/*
Master ID 523879
Alias ID 316779
List 4015345

Master ID 531811
Xref ID 4372848
List 2235350

*/

select count(*)
from xwrl_alert_clearing_xref
where list_id is null;

select *
from xwrl_alert_clearing_xref
where xref_id is not null
order by id desc
;

/* Case Level Search  */

select req.id, req.batch_id, req.case_id,  req.master_id, req.alias_id, req.xref_id, req.name_screened, req.case_status, req.case_state, req.case_workflow, req.created_by, req.creation_date, usr.user_name
from xwrl_requests req
,fnd_user usr
where req.created_by = usr.user_id 
and req.id = :request_id
;

/*
Master ID 523879	
Alias 316779
*/

select col.ID, col.request_id, col.listid, col.listrecordtype, col.listfullname, col.listnametype, col.matchrule, col.x_state, substr(col.x_state, 7)  x_type, col.created_by, col.creation_date, usr.user_name
from xwrl_response_ind_columns col
,fnd_user usr
where col.created_by = usr.user_id 
and col.request_id = :request_id
order by col.id desc
;

/*
List IDs

4094553
3773785
4015345
4093628

*/

select xref.id, xref.request_id, xref.alert_id, xref.list_id, xref.from_state, xref.to_state, xref.note, xref.master_id, xref.alias_id, xref.xref_id, xref.created_by, xref.creation_date, usr.user_name
from xwrl_alert_clearing_xref xref
,fnd_user usr
where xref.created_by = usr.user_id 
--and xref.request_id = :request_id
and xref.master_id = :master_id
and xref.list_id = :list_id
--and nvl(xref.alias_id,-1) = nvl(:alias_id,-1)
--and nvl(xref.xref_id,-1) = nvl(:xref_id,-1)
--and rownum = 1
order by list_id desc, id desc
;

select *
from xwrl_requests
where id in (14670,14671);

SELECT col.ID, col.request_id, r.source_table, r.source_id, r.master_id, r.alias_id, r.xref_id,
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
            order by listid
            ;

select *
from xwrl_alert_notes
;

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
select count(*)
from (select request_id, alert_id, line_number, note, count(*), max(id)
from xwrl_alert_notes
group by request_id, alert_id, line_number, note
having count(*) > 1
);

select count(*)
from (select request_id, alert_id, line_number, note_id, count(*), max(id)
from xwrl_note_xref
group by request_id, alert_id, line_number, note_id
having count(*) > 1
);

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


declare
cursor c1 is 
select request_id, alert_id,  note, created_by, creation_date, count(*), max(id) max_id
from xwrl_alert_notes
group by request_id, alert_id, note, created_by, creation_date
having count(*) > 1
order by request_id desc;

v_ctr integer;

begin

v_ctr := 0;

for c1rec in c1 loop

delete from xwrl_alert_notes
where request_id = c1rec.request_id
and alert_id = c1rec.alert_id
and note = c1rec.note
and created_by = c1rec.created_by
and creation_date = c1rec.creation
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

select count(*)
from (select request_id, alert_id, line_number, note, count(*), max(id)
from xwrl_alert_notes
group by request_id, alert_id, line_number, note
having count(*) > 1
);

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
having count(*) > 1
;

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
where request_id = 225801
and document_file = '/irip/oracle_files/PROD/seaf_doc/89/896410/Application/896410-0002-001.jpg'
order by id desc
;

select *
from xwrl_requests
where id = 225801
;

exec xwrl_trg_ctx.disable_trg_ctx;

SELECT SYS_CONTEXT('xwrl_ctx', 'disable_trigger') FROM dual;

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


declare
cursor c1 is 
select request_id
,master_id
,edoc_id
,document_type
,document_file
,count(*)
,max(id) max_id
from xwrl_case_documents
group by request_id
,master_id
,edoc_id
,document_type
,document_file
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


declare

cursor c1 is
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
where xx.xref_count = 0
order by xx.alert_id, xx.line_number
;


begin

for c1rec in c1 loop

delete from xwrl_alert_notes
where id = c1rec.id;

end loop;
end;
/


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

select count(*)
from (select request_id, alert_id, line_number, note_id, count(*), max(id)
from xwrl_note_xref
group by request_id, alert_id, line_number, note_id
having count(*) > 1
);

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

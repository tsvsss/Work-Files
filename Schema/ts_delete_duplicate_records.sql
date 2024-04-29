select count(*)
from (select source_table, source_id, name_screened, count(*)
from xwrl_requests
where  source_table is not null
group by source_table, source_id,  name_screened
having count(*) > 1
order by 4 desc)
;

BEGIN
  FOR c IN
   (SELECT t.owner, t.table_name
   FROM all_tables t
   where lower(t.table_name) in ( 'xwrl_response_ind_columns','xwrl_response_entity_columns','xwrl_response_rows','xwrl_alert_documents','xwrl_case_documents','xwrl_request_ind_columns','xwrl_request_entity_columns' ))
   LOOP
    dbms_utility.exec_ddl_statement('alter table "' || c.owner || '"."' || c.table_name || '" disable all triggers');
  END LOOP;
END;
/

BEGIN
  FOR c IN
   (SELECT c.owner, c.table_name, c.constraint_name, c.constraint_type
   FROM all_constraints c, all_tables t
   WHERE c.table_name = t.table_name
   and lower(t.table_name) in ( 'xwrl_response_ind_columns','xwrl_response_entity_columns','xwrl_response_rows','xwrl_alert_documents','xwrl_case_documents','xwrl_request_ind_columns','xwrl_request_entity_columns' )
   AND c.status = 'ENABLED'
   AND NOT (t.iot_type IS NOT NULL AND c.constraint_type = 'P')
   ORDER BY decode(c.constraint_type,'P',1,'R',2,3) DESC)
  LOOP
    dbms_utility.exec_ddl_statement('alter table "' || c.owner || '"."' || c.table_name || '" disable constraint ' || c.constraint_name);
  END LOOP;
END;
/

declare
cursor c1 is
select req.id, maxreq.max_id
from xwrl_requests req
,(select source_table, source_id, name_screened, count(*)
from xwrl_requests
where  source_table is not null
group by source_table, source_id,  name_screened
having count(*) > 1) dups
,(select max(id) max_id, source_table, source_id,  name_screened
from xwrl_requests 
group by source_table, source_id,  name_screened) maxreq
where req.source_table = dups.source_table
and req.source_id = dups.source_id
and req.name_screened = dups.name_screened
and req.source_table = maxreq.source_table
and req.source_id = maxreq.source_id
and req.name_screened = maxreq.name_screened
and req.id <> max_id;

v_id integer;

v_count integer ;
v_max integer;

begin

v_count := 0;
v_max := 10;

for c1rec in c1 loop

         v_count := v_count + 1;

         DELETE from xwrl_response_ind_columns where request_id = c2rec.id;
         DELETE from xwrl_response_entity_columns where request_id = c2rec.id;
         DELETE xwrl_response_rows where request_id = c2rec.id;
         DELETE from xwrl_alert_documents where request_id = c2rec.id;
         DELETE from xwrl_case_documents where request_id = c2rec.id;
         DELETE from xwrl_request_ind_columns where request_id = c2rec.id;
         DELETE from xwrl_request_entity_columns where request_id = c2rec.id;
         DELETE from xwrl_request_rows where request_id = c2rec.id;
         DELETE from xwrl_requests where id = c2rec.id;

         commit;

         if v_count >= v_max then
            exit;
         end if;

end loop;

end;
/



BEGIN
  FOR c IN
  (SELECT c.owner, c.table_name, c.constraint_name
   FROM all_constraints c, all_tables t
   WHERE c.table_name = t.table_name
   and lower(t.table_name) in ( 'xwrl_response_ind_columns','xwrl_response_entity_columns','xwrl_response_rows','xwrl_alert_documents','xwrl_case_documents','xwrl_request_ind_columns','xwrl_request_entity_columns' )
   AND c.status = 'DISABLED'
   ORDER BY decode(c.constraint_type,'P',1,'R',2,3) 
   )
  LOOP
    dbms_utility.exec_ddl_statement('alter table "' || c.owner || '"."' || c.table_name || '" enable constraint ' || c.constraint_name);
  END LOOP;
END;
/

BEGIN
  FOR c IN
   (SELECT t.owner, t.table_name
   FROM all_tables t
   where lower(t.table_name) in ( 'xwrl_response_ind_columns','xwrl_response_entity_columns','xwrl_response_rows','xwrl_alert_documents','xwrl_case_documents','xwrl_request_ind_columns','xwrl_request_entity_columns' ))
   LOOP
    dbms_utility.exec_ddl_statement('alter table "' || c.owner || '"."' || c.table_name || '" enable all triggers');
  END LOOP;
END;
/


declare
cursor c1 is
select id
from xwrl_party_master
where state like 'Delete%'
;

v_ctr integer := 0;

begin


for  c1rec in c1 loop

v_ctr := v_ctr + 1;

begin

delete from xwrl_party_alias where master_id = c1rec.id;
delete from xwrl_party_master where id = c1rec.id;

if v_ctr >= 500 then
   commit;
   v_ctr := 0;
end if;   

end;

end loop;

dbms_output.put_line('Records processed: '||v_ctr);

commit;

end;
/
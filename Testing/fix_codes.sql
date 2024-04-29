select count(*)
from xwrl_requests
where case_id is null
;


select id, resubmit_id, source_table, source_id, master_id, alias_id, xref_id, batch_id, case_id, path, matches, name_screened, department, department_ext, office, status, case_status, case_state, case_workflow, creation_date
from xwrl_requests
where case_id is null
;

select *
from xwrl_requests
where case_id is null
;

select count(*)
from xwrl_requests
--where department is null
where batch_id is null
--and case_status = 'O'
order by id desc
;

select count(*)
from xwrl_requests
where department is null
--and case_status = 'O'
order by id desc
;

select source_table, count(*)
from xwrl_requests
where department is null
group by source_table
--and case_status = 'O'
;

select count(*)
from xwrl_requests
where department is null
;

select id, case_id, department, department_ext, office
from xwrl_requests
where department is null
order by 1 desc;

  SELECT rmi_ows_common_util.get_department (ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (ID) dept,
       rmi_ows_common_util.get_doc_type (ID) doc_type,
       rmi_ows_common_util.get_office (ID,'CODE') office, id
  FROM xwrl_requests
  where department is null
  ORDER BY ID DESC;

declare
  cursor c1 is
  SELECT rmi_ows_common_util.get_department (ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (ID) dept,
       rmi_ows_common_util.get_doc_type (ID) doc_type,
       rmi_ows_common_util.get_office (ID,'CODE') office, id
  FROM xwrl_requests
  --where  office is null
  ORDER BY ID DESC
;

v_ctr integer := 0;
  
  begin
  
  for c1rec in c1 loop
  
  v_ctr := v_ctr + 1;
  
  begin
  
        update xwrl_requests
        set department = c1rec.deptcode
        ,department_ext  = c1rec.dept
        ,document_type = c1rec.doc_type
        ,office = c1rec.office
        where id = c1rec.id;
  
  exception
  when others then null;
  end;
  
  
  if v_ctr >= 1000 then
     commit;
     v_ctr := 0;
     DBMS_OUTPUT.PUT('Updating 1000 Records');
  end if;
  
  end loop;
  
  commit;
  
  end;
  /
  

--DEPARTMENTS

SELECT KEY AS OptionKey,VALUE_STRING AS OptionValue        
FROM XWRL_PARAMETERS        
WHERE ID = 'CASE_DEPARTMENTS'  
AND DISPLAY_FLAG = 'Y'
ORDER BY OptionValue;

--OFFICES

select salesrep_id, code AS OptionKey, description AS OptionValue
from vssl_offices  
where salesrep_id is not null  
and enable = 'Y'  
order by description;

--DOCUMENTS

SELECT CODE AS OptionKey,DESCRIPTION AS OptionValue        
FROM XWRL_DOCUMENT_REFERENCE        
ORDER BY SORT_KEY ASC;







declare
  cursor c1 is
  SELECT rmi_ows_common_util.get_department (req.ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (req.ID) dept,
       rmi_ows_common_util.get_doc_type (req.ID) doc_type,
       rmi_ows_common_util.get_office (req.ID) office,
       office.optionkey,
       req.source_id,
       req.id
  FROM xwrl_requests req
  ,(select salesrep_id, code AS OptionKey, description AS OptionValue
      from vssl_offices  
      where salesrep_id is not null  
      and enable = 'Y'  )  office
      where rmi_ows_common_util.get_office (req.ID)  = office.optionvalue (+);
  
  v_count integer := 0;
  
  begin
  
  for c1rec in c1 loop
  
         v_count := v_count + 1;
  
        update xwrl_requests
        set department = c1rec.deptcode
        ,department_ext  = c1rec.doc_type
        ,office = c1rec.optionkey
        where id = c1rec.id;
        
        if v_count >= 1000 then
            commit;
            v_count := 0;
        end if;
  
  end loop;
  
  commit;
  
  end;
  /
  
  
declare
cursor c1 is 
select req.id, req.source_table, req.source_id, req.name_screened, mst.full_name, mst.created_by, nvl(mst.last_updated_by,mst.created_by) last_updated_by, mst.creation_date, mst.last_update_date
from xwrl_requests req
,xwrl_party_master mst
where req.source_table = mst.source_table
and req.source_id = mst.source_id
and req.name_screened = mst.full_name
and mst.state not like 'Delete%'
--and req.created_by is null
order by mst.created_by nulls first, id
;

  v_count integer := 0;

begin

for c1rec in c1 loop

         v_count := v_count + 1;
  
        update xwrl_requests
        set created_by = c1rec.created_by
        ,last_updated_by = c1rec.last_updated_by
        ,creation_date = c1rec.creation_date
        ,last_update_date = c1rec.last_update_date
        where id = c1rec.id;
        
        if v_count >= 1000 then
            commit;
            v_count := 0;
        end if;
  
  end loop;
  
  commit;
  
  end;
/



declare
cursor c1 is 
select req.id, req.source_table, req.source_id, req.name_screened, mst.full_name, mst.created_by, nvl(mst.last_updated_by,mst.created_by) last_updated_by, mst.creation_date, mst.last_update_date
from xwrl_requests req
,xwrl_party_master mst
where req.source_table = mst.source_table
and req.source_id = mst.source_id
--and req.name_screened = mst.full_name
and mst.state not like 'Delete%'
--and req.created_by is null
order by mst.created_by nulls first, id
;

  v_count integer := 0;

begin

for c1rec in c1 loop

         v_count := v_count + 1;
  
        update xwrl_requests
        set created_by = c1rec.created_by
        ,last_updated_by = c1rec.last_updated_by
        ,creation_date = c1rec.creation_date
        ,last_update_date = c1rec.last_update_date
        where id = c1rec.id;
        
        if v_count >= 1000 then
            commit;
            v_count := 0;
        end if;
  
  end loop;
  
  commit;
  
  end;
/

declare
cursor c1 is 
select req.id, req.source_table, req.source_id, req.name_screened, mst.full_name, mst.created_by, nvl(mst.last_updated_by,mst.created_by) last_updated_by, mst.creation_date, mst.last_update_date
from xwrl_requests req
,xwrl_party_master mst
where req.source_table = mst.source_table
and req.source_id = mst.source_id
--and req.name_screened = mst.full_name
--and mst.state not like 'Delete%'
--and req.created_by is null
order by mst.created_by nulls first, id
;

  v_count integer := 0;

begin

for c1rec in c1 loop

         v_count := v_count + 1;
  
        update xwrl_requests
        set created_by = c1rec.created_by
        ,last_updated_by = c1rec.last_updated_by
        ,creation_date = c1rec.creation_date
        ,last_update_date = c1rec.last_update_date
        where id = c1rec.id;
        
        if v_count >= 1000 then
            commit;
            v_count := 0;
        end if;
  
  end loop;
  
  commit;
  
  end;
/
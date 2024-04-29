alter trigger XWRL.XWRL_REQUESTS_INS_UPD disable;

alter trigger XWRL.XWRL_REQUESTS_INS_UPD enable;

alter table XWRL.XWRL_REQUESTS enable all triggers ;

SELECT xr.name_screened, xp.full_name, XWRL_NAME_UTILS.same_name( xr.name_screened, xp.full_name) same_name, xr.source_table, xr.source_id, xr.batch_id,  xr.ID , xr.master_id, xref_id, alias_id, xp.ID master_id_upd
  FROM xwrl_requests xr, xwrl.xwrl_party_master xp
 WHERE xr.master_id IS NULL
   --AND xr.source_table = 'SICD_SEAFARERS'
   AND xp.source_id = xr.source_id
   AND xp.source_table = xr.source_table
   and  XWRL_NAME_UTILS.same_name( xr.name_screened, xp.full_name) = 'Y';
 

   
   
declare
cursor c1 is
SELECT
   req.id
   ,mst.id main_id
   ,mst.master_id
   , mst.resubmit_id
   , mst.batch_id
   , mst.source_table
   , mst.source_id
   , mst.name_screened
   ,mst.office
   , mst.department
   , mst.department_ext
   , mst.creation_date
   , mst.case_status
   , mst.case_state
   , mst.case_workflow
   ,mst.status
   ,mst.created_by   
   ,mst.last_updated_by
FROM
   xwrl_requests req
   ,xwrl_requests mst
WHERE
   req.master_id IS NULL
   AND req.case_status = 'O'
   AND req.case_state <> 'E'
   AND req.resubmit_id IS NOT NULL
   and req.resubmit_id = mst.id
ORDER BY
   req.id DESC;    

begin

for c1rec in c1 loop

update xwrl_requests
set master_id = c1rec.master_id
,source_table = c1rec.source_table
,source_id = c1rec.source_id
,office = c1rec.office
,department = c1rec.department
,department_ext = c1rec.department_ext
,created_by = c1rec.created_by
,last_updated_by = c1rec.last_updated_by
where id = c1rec.id
;

end loop;
end;
/
   




  select *
 from xwrl_requests
 where master_id is null
 ;

   select count(*)
   from xwrl_requests
   where master_id is null
   ;

select *
from xwrl_requests
   where master_id is null
   ;

select id, resubmit_id, batch_id, source_table, source_id, name_screened, department, department_ext, creation_date, case_status, case_state, case_workflow
from xwrl_requests
   where master_id is null
   and case_status = 'O'
   and case_state <> 'E'
   order by id desc
   ;
   
   
   
select id, resubmit_id, batch_id, source_table, source_id, name_screened, department, department_ext, creation_date, case_status, case_state, case_workflow
from xwrl_requests
   where master_id is null
   and case_status = 'O'
   and case_state <> 'E'
   and resubmit_id is not null
   order by id desc
   ;


SELECT
   req.id
   ,req.master_id
   , req.resubmit_id
   , req.batch_id
   , req.source_table
   , req.source_id
   , req.name_screened
   ,req.office
   , req.department
   , req.department_ext
   , req.creation_date
   , req.case_status
   , req.case_state
   , req.case_workflow
   ,req.status
   ,req.creation_date
   ,req.created_by
      ,req.last_updated_by
   ,mst.id
   ,mst.master_id
   , mst.resubmit_id
   , mst.batch_id
   , mst.source_table
   , mst.source_id
   , mst.name_screened
   ,mst.office
   , mst.department
   , mst.department_ext
   , mst.creation_date
   , mst.case_status
   , mst.case_state
   , mst.case_workflow
   ,mst.status
   ,mst.creation_date
   ,mst.created_by   
   ,mst.last_updated_by
FROM
   xwrl_requests req
   ,xwrl_requests mst
WHERE
   req.master_id IS NULL
   AND req.case_status = 'O'
   AND req.case_state <> 'E'
   AND req.resubmit_id IS NOT NULL
   and req.resubmit_id = mst.id
ORDER BY
   req.id DESC; 
   
select id, resubmit_id, batch_id, source_table, source_id, name_screened, department, department_ext, creation_date, case_status, case_state, case_workflow
from xwrl_requests
   where master_id is null
   and case_status = 'O'
   and case_state <> 'E'
   and resubmit_id is null
   order by id desc
   ;   
   
select id, resubmit_id, batch_id, source_table, source_id, name_screened, department, department_ext, creation_date, case_status, case_state, case_workflow
from xwrl_requests
   where master_id is null
   and case_status = 'O'
   --and case_state <> 'E'
   and resubmit_id is null
   order by id desc
   ;   


select source_table, count(*)
from xwrl_requests
   where master_id is null
   group by source_table;
   
select source_table, status, count(*)
from xwrl_requests
   where master_id is null
    and case_status = 'O'
   group by source_table, status;   
   
SELECT xr.name_screened, xp.full_name, xpa.full_name alias_full_name, XWRL_NAME_UTILS.same_name( xr.name_screened, xpa.full_name) same_name, xr.source_table, xr.source_id, xr.batch_id,  xr.ID , xr.master_id, xref_id, alias_id, xpa.master_ID master_id_upd, xpa.id alias_id_upd
  FROM xwrl_requests xr, xwrl.xwrl_party_master xp, xwrl_party_alias xpa
 WHERE xr.master_id IS NULL
   --AND xr.source_table = 'SICD_SEAFARERS'
   AND xp.source_id = xr.source_id
   AND xp.source_table = xr.source_table
   and xpa.master_id = xp.id
   and  XWRL_NAME_UTILS.same_name( xr.name_screened, xpa.full_name) = 'Y';


/* MASTER */

declare

cursor c1 is
SELECT xr.name_screened, xp.full_name, XWRL_NAME_UTILS.same_name( xr.name_screened, xp.full_name) same_name, xr.source_table, xr.source_id, xr.batch_id,  xr.ID , xr.master_id, xref_id, alias_id, xp.ID master_id_upd
  FROM xwrl_requests xr, xwrl.xwrl_party_master xp
 WHERE xr.master_id IS NULL
   --AND xr.source_table = 'SICD_SEAFARERS'
   AND xp.source_id = xr.source_id
   AND xp.source_table = xr.source_table
   and  XWRL_NAME_UTILS.same_name( xr.name_screened, xp.full_name) = 'Y';

v_ctr integer;

begin

v_ctr := 0;

for c1rec in c1 loop

update xwrl_requests
set master_id = c1rec.master_id_upd
where id = c1rec.id;

v_ctr := v_ctr + 1;

if v_ctr >= 500 then
    commit;
    v_ctr := 0;
end if;

end loop;

commit;

end;
/

/* ALIAS */

declare

cursor c1 is
SELECT xr.name_screened, xp.full_name, xpa.full_name alias_full_name, XWRL_NAME_UTILS.same_name( xr.name_screened, xpa.full_name) same_name, xr.source_table, xr.source_id, xr.batch_id,  xr.ID , xr.master_id, xref_id, alias_id, xpa.master_ID master_id_upd, xpa.id alias_id_upd
  FROM xwrl_requests xr, xwrl.xwrl_party_master xp, xwrl_party_alias xpa
 WHERE xr.master_id IS NULL
   --AND xr.source_table = 'SICD_SEAFARERS'
   AND xp.source_id = xr.source_id
   AND xp.source_table = xr.source_table
   and xpa.master_id = xp.id
   and  XWRL_NAME_UTILS.same_name( xr.name_screened, xpa.full_name) = 'Y';

v_ctr integer;

begin

v_ctr := 0;

for c1rec in c1 loop

update xwrl_requests
set master_id = c1rec.master_id_upd
,alias_id = c1rec.alias_id_upd
where id = c1rec.id;

v_ctr := v_ctr + 1;

if v_ctr >= 500 then
    commit;
    v_ctr := 0;
end if;

end loop;

commit;

end;
/

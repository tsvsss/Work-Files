select *
from FND_RESPONSIBILITY_VL 
where responsibility_name like 'RMI%'
;
exec mo_global.set_policy_context ('S', 122);
exec DBMS_APPLICATION_INFO.set_client_info (122);


select userenv('LANG') 
from dual;

select * from V$NLS_PARAMETERS;

begin
fnd_global.apps_initialize (1156, 52369, 20003);
end;
/

declare

cursor c1 is
select unique r.id request_id
--select r.id request_id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state, r.master_id, c.listid, c.alertid, c.listrecordtype, r.alias_id, r.xref_id
from xwrl_response_ind_columns c
,xwrl_requests r
where c. request_id = r.id
and r.case_status = 'O'
and r.case_state <> 'D'
--and r.case_workflow IN ( 'L','SL')
and exists (select 1
from xwrl_response_ind_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
--and r.id = 236319
order by request_id desc
;

begin

--fnd_global.apps_initialize (1156, 52369, 20003);

for c1rec in c1 loop

xwrl_ows_utils.auto_clear_individuals(1156,999,c1rec.request_id);

end loop;
end;
/

declare

cursor c1 is
select unique r.id request_id
--select r.id request_id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state, r.master_id, c.listid, c.alertid, c.listrecordtype, r.alias_id, r.xref_id
from xwrl_response_entity_columns c
,xwrl_requests r
where c. request_id = r.id
and r.case_status = 'O'
and r.case_state <> 'D'
--and r.case_workflow IN ( 'L','SL')
and exists (select 1
from xwrl_response_entity_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by request_id desc
;

begin

--fnd_global.apps_initialize (1156, 52369, 20003);

for c1rec in c1 loop

xwrl_ows_utils.auto_clear_entities(1156,999,c1rec.request_id);

end loop;
end;
/

                     SELECT COUNT (1)
                       --INTO l_count
                       FROM xwrl_response_ind_columns
                      WHERE request_id = :p_request_id
                        AND UPPER (x_state) LIKE '%OPEN%';
                        
                        
                        update xwrl_requests
                        set case_status = 'O'
                        ,case_workflow = 'P'
                        ,case_state = 'N'
                        WHERE id = 233702;  -- PANAGIOTIS SOTOS
                        
                        update xwrl_requests
                        set case_status = 'C'
                        ,case_workflow = 'A'
                        ,case_state = 'A'
                        WHERE id = 233702; -- PANAGIOTIS SOTOS
                        
                        rollback;
                        
                        update xwrl_requests
                        set case_status = 'O'
                        ,case_workflow = 'P'
                        ,case_state = 'N'
                        WHERE id = 233780; -- FORTTRADE
                        
                        update xwrl_requests
                        set case_status = 'C'
                        ,case_workflow = 'A'
                        ,case_state = 'A'
                        WHERE id = 233780; -- FORTTRADE
                        
                        rollback;

select r.id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state
from xwrl_requests r
where r.case_status = 'C'
and r.case_state <> 'D'
and exists (select 1
from xwrl_response_ind_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;

select r.id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state
from xwrl_requests r
where r.case_status = 'C'
and r.case_state <> 'D'
and exists (select 1
from xwrl_response_entity_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;
-- XIANZHONG WU
select *
from xwrl_alert_clearing_xref
;

select count(*)
from xwrl_requests r
where r.case_status = 'O'
and r.case_state <> 'D'
and r.case_workflow = 'SL'
and exists (select 1
from xwrl_response_ind_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;

select count(*)
from xwrl_requests r
where r.case_status = 'O'
and r.case_state <> 'D'
and r.case_workflow = 'SL'
and exists (select 1
from xwrl_response_entity_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;

select r.id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state, r.master_id, r.alias_id, r.xref_id
from xwrl_requests r
where r.case_status = 'O'
and r.case_state <> 'D'
and r.case_workflow = 'SL'
and exists (select 1
from xwrl_response_ind_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;

select r.id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state, r.master_id, r.alias_id, r.xref_id
from xwrl_requests r
where r.case_status = 'O'
and r.case_state <> 'D'
and r.case_workflow = 'SL'
and exists (select 1
from xwrl_response_entity_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;

declare
cursor c1 is
/*
select r.id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state
from xwrl_requests r
where r.case_status = 'C'
and r.case_state <> 'D'
and exists (select 1
from xwrl_response_entity_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;
*/
select r.id, r.batch_id, r.name_screened, r.case_id,  r.creation_date, r.last_update_date, r.case_status, r.case_workflow, r.case_state
from xwrl_requests r
where r.case_status = 'C'
and r.case_state <> 'D'
and exists (select 1
from xwrl_response_ind_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
order by batch_id desc
;

begin

xwrl_trg_ctx.disable_trg_ctx;

for c1rec in c1 loop

update xwrl_requests
set case_status = 'O'
,case_workflow = 'SL'
,case_state = 'N'
where id = c1rec.id;

end loop;
end;
/

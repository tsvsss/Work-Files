declare

cursor c1 is
select unique r.id request_id
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
order by request_id desc
;

begin

fnd_global.apps_initialize (1156, 52369, 20003);

for c1rec in c1 loop

xwrl_ows_utils.auto_clear_individuals(1156,999,c1rec.request_id);

end loop;
end;
/


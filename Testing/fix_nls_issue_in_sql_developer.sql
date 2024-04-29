/*
procedure APPS_INITIALIZE(
    user_id in number,
    resp_id in number,
    resp_appl_id in number,
    security_group_id in number default 0,
    server_id in number default -1);

select *
from fnd_responsibility_vl
where responsibility_id = 52369;

select *
from FND_RESPONSIBILITY_VL 
where responsibility_name like 'RMI%'
;
exec mo_global.set_policy_context ('S', 122);
exec DBMS_APPLICATION_INFO.set_client_info (122);

select userenv('LANG')  from dual

NLS_DATE_FORMAT DD-MON-RR  -- Note: this works

*/


;
select * from V$NLS_PARAMETERS;

begin
fnd_global.apps_initialize (user_id=>1156, resp_id=> 52369, resp_appl_id=>20003);
--xwrl_ows_utils.auto_clear_individuals(1156,999,143916);
end;
/
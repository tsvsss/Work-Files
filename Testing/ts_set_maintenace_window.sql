
update XWRL_PARAMETERS
set VALUE_DATE = TO_DATE('07/29/2020 17:00:00','MM/DD/YYYY HH24:MI:SS')
where id = 'OWS_MAINTENANCE_WINDOW'
and key = 'START_DATE';
COMMIT;

update XWRL_PARAMETERS
set VALUE_DATE = TO_DATE('07/29/2020 19:00:00','MM/DD/YYYY HH24:MI:SS')
where id = 'OWS_MAINTENANCE_WINDOW'
and key = 'END_DATE';
COMMIT;

update XWRL_PARAMETERS
set VALUE_DATE = NULL
where id = 'OWS_MAINTENANCE_WINDOW'
and key = 'START_DATE';
COMMIT;

update XWRL_PARAMETERS
set VALUE_DATE = NULL
where id = 'OWS_MAINTENANCE_WINDOW'
and key = 'END_DATE';
COMMIT;

select *
from (SELECT VALUE_DATE start_date
FROM XWRL_PARAMETERS
where id = 'OWS_MAINTENANCE_WINDOW'
and key = 'START_DATE')
,(SELECT VALUE_DATE end_date
FROM XWRL_PARAMETERS
where id = 'OWS_MAINTENANCE_WINDOW'
and key = 'END_DATE');

declare
v_return boolean;
begin
v_return := xwrl_data_processing.is_maintenance_window (sysdate);
if v_return then
    dbms_output.put_line('TRUE');
else
   dbms_output.put_line('FALSE');
end if;
end;
/

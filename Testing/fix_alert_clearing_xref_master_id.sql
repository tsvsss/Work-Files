select *
from  xwrl_alert_clearing_xref
where master_id is null;

declare

cursor c1 is 
select id
from xwrl_alert_clearing_xref
where master_id is null
;

v_ctr integer := 0;

begin

for c1rec in c1 loop

v_ctr := v_ctr + 1;

delete from xwrl_alert_clearing_xref
where id = c1rec.id;

if v_ctr >= 1000 then
commit;
end if;

end loop;

commit;

end;
/

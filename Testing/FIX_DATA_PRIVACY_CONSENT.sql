declare

cursor c1 is
select a.consent_id, a.entity_type, a.first_name, a.middle_name, a.last_name, b.id master_id, b.full_name
from rmi_data_privacy_consent a
,xwrl_party_master b
WHERE xwrl_utils.cleanse_name(b.full_name) = xwrl_utils.cleanse_name(UPPER(a.first_name||' '||a.middle_name||' '||a.last_name))
and a.master_id IS NULL
order by b.id
;

v_ctr integer := 0;
begin

for c1rec in c1 loop
v_ctr := v_ctr + 1;

update rmi_data_privacy_consent
set master_id = c1rec.master_id
where consent_id = c1rec.consent_id;

if v_ctr >= 1000 then
   commit;
end if;

end loop;

commit;
end;
/

declare

cursor c1 is
select a.consent_id, a.entity_type, a.first_name, a.middle_name, a.last_name, b.master_id, b.full_name
from rmi_data_privacy_consent a
,xwrl_party_alias b
WHERE xwrl_utils.cleanse_name(b.full_name) = xwrl_utils.cleanse_name(UPPER(a.first_name||' '||a.middle_name||' '||a.last_name))
and a.master_id IS NULL
order by b.master_id
;

v_ctr integer := 0;
begin

for c1rec in c1 loop
v_ctr := v_ctr + 1;

update rmi_data_privacy_consent
set master_id = c1rec.master_id
where consent_id = c1rec.consent_id;

if v_ctr >= 1000 then
   commit;
end if;

end loop;

commit;
end;
/
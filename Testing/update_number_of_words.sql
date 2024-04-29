select id, full_name, length(full_name) - length(replace(full_name, ' ', '')) + 1 NumberofWords
from xwrl_party_master
order by id
;

select id, full_name, number_of_words
from xwrl_party_master
where full_name is null
order by id;

select count(*)
from xwrl_party_master
where identifier is null
;

alter table xwrl.xwrl_party_master
add (number_of_words integer)
;

declare
cursor c1 is
select id, full_name, length(full_name) - length(replace(full_name, ' ', '')) + 1 NumberofWords
from xwrl_party_master
;

v_ctr integer;

begin

v_ctr := 0;

for c1rec in c1 loop

v_ctr := v_ctr + 1;

update xwrl_party_master
set number_of_words = c1rec.numberofwords
where id = c1rec.id
;

if v_ctr >= 1000 then
   commit;
   v_ctr := 0;
end if;
   
end loop;

commit;

end;
/

XWRL_PARTY_MASTER;

DROP TRIGGER XWRL.XWRL_PARTY_MASTER_TRG;

select *
from all_objects
where object_name = 'XWRL_PARTY_MASTER_TRG';



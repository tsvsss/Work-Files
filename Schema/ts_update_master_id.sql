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

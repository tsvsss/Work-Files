/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_data_fix_scripts2.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                         $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : apps_data_fix_scripts2.sql                                                                  *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                      *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    :                                                                                             *
* Last Reviewed Date  :                                                                                             *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO          15-NOV-2019  I      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/

/************ 'Delete - Duplicate  ***********/

declare

cursor c1 is
with vmax as (select entity_type, source_table, source_table_column, source_id, max(id) id
from xwrl_party_master 
where state = 'Verified'
group by entity_type, source_table, source_table_column, source_id
having count(*) > 1)
select mst.id, mst.source_table, mst.source_table_column, mst.source_id
from xwrl_party_master mst
,vmax
where state = 'Verified'
      and mst.entity_type = vmax.entity_type
      and mst.source_table = vmax.source_table
      and mst.source_table_column  = vmax.source_table_column
      and mst.source_id  = vmax.source_id
      and mst.id <> vmax.id
      order by 2,4
      ;


v_max_wc_screening_request_id integer;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
      
      update xwrl_party_master
      set state = 'Delete - Duplicate'
      ,note = 'Data Fix - Duplicate'
      where id = c1rec.id;

      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/************ Delete - Alias  ***********/

declare

cursor c1 is
with vmax as (select entity_type, source_table, source_table_column, source_id, full_name, max(id) id
from xwrl_party_master 
where state = 'Migrated'
group by entity_type, source_table, source_table_column, source_id, full_name
having count(*) > 1)
select mst.id, mst.source_table, mst.source_table_column, mst.source_id, mst.full_name
from xwrl_party_master mst
,vmax
where state = 'Migrated'
      and mst.entity_type = vmax.entity_type
      and mst.source_table = vmax.source_table
      and mst.source_table_column  = vmax.source_table_column
      and mst.source_id  = vmax.source_id
      and mst.full_name = vmax.full_name
      and mst.id <> vmax.id
      order by 2,4
      ;


v_max_wc_screening_request_id integer;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
      
      update xwrl_party_master
      set state = 'Delete - Alias'
      ,note = 'Data Fix - Alias'
      where id = c1rec.id;

      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/





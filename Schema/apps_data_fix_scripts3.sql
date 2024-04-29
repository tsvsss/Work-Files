/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_data_fix_scripts3.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                         $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : apps_data_fix_scripts3.sql                                                                  *
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

/* Delete xref record where endpoints are identical */

declare

cursor c1 is
select *
from xwrl_party_xref
where master_id = relationship_master_id
      ;


v_max_wc_screening_request_id integer;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
      
      delete from xwrl_party_xref
      where id = c1rec.id;

      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

declare
cursor c1 is
select id
from xwrl_party_master
where state like 'Delete%'
;

v_ctr integer := 0;

begin


for  c1rec in c1 loop

v_ctr := v_ctr + 1;

begin

delete from xwrl_party_alias where master_id = c1rec.id;
delete from xwrl_party_master where id = c1rec.id;

if v_ctr >= 500 then
   commit;
   v_ctr := 0;
end if;   

end;

end loop;

dbms_output.put_line('Records processed: '||v_ctr);

commit;

end;
/


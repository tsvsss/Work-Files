/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: xwrl_table_nologging.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                           $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : xwrl_table_nologging.sql                                                                    *
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

declare
cursor c1 is
select 'alter table xwrl.'||table_name||' nologging' v_sql
from all_tables
where owner = 'XWRL'
;

begin

for c1rec in c1 loop
   execute immediate c1rec.v_sql;
end loop;

end;
/
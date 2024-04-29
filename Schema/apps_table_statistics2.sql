/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_table_statistcs2.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                          $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : apps_table_statistcs2.sql                                                                   *
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

/* Note: attempt to supercede apps_table_statistcs.sql.  Need to complete, if possible */

declare
cursor c1 is
--select 'fnd_stats.gather_table_stats('||chr(39)||owner||chr(39)||','||chr(39)||table_name||chr(39)||',100,NULL,NULL,'||chr(39)||'NOBACKUP'||chr(39)||',TRUE,'||chr(39)||'DEFAULT'||chr(39)||');' v_sql, table_name
select 'exec  fnd_stats.gather_table_stats('||chr(39)||owner||chr(39)||','||chr(39)||table_name||chr(39)||',100,NULL,NULL,'||chr(39)||'NOBACKUP'||chr(39)||',TRUE,'||chr(39)||'DEFAULT'||chr(39)||');' v_sql, table_name
from all_tables
where owner = 'XWRL'
order by table_name
;

begin

for c1rec in c1 loop
   dbms_output.put_line(c1rec.v_sql);
   --execute immediate c1rec.v_sql;
   --dbms_output.put_line('Gather statistics: '||c1rec.table_name);
end loop;

end;
/

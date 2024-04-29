create or replace PACKAGE apps.xwrl_data_utils AS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_xwrl_utils.pks 1.1 2019/11/15 12:00:00ET   IRI Exp                                         $*/
/********************************************************************************************************************
* Object Type         : Package Specification                                                                       *
* Name                : xwrl_data_utils                                                                                  *
* Script Name         : apps_create_xwrl_data_utils.pks                                                                  *
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
* 16-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I      Add    create_audit_record          *
*                                                                                                                   *
********************************************************************************************************************/

      procedure create_trigger_logic (p_table_name in varchar2, p_column_id in varchar2, p_action in varchar2 default null);

      procedure create_audit_record (p_table_name IN varchar2, p_table_column IN varchar2, p_column in varchar2, p_action in varchar2  default null,  p_result OUT varchar2) ;
   
   END xwrl_data_utils;
/

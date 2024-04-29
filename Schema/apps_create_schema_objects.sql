/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_schema_objects.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                     $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : apps_create_schema_objects.sql                                                              *
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

DROP TABLE tmp_xwrl_alerts;

CREATE TABLE tmp_xwrl_alerts (
   p_user       VARCHAR2 (30)
   , p_alert_id   VARCHAR2 (100)
   , p_to_state   VARCHAR2 (100)
   , p_comment    VARCHAR2 (1000)
);

DROP TABLE tmp_xwrl_alert_results;

CREATE TABLE tmp_xwrl_alert_results (
   p_request_id   INTEGER
   , p_case_key     VARCHAR2 (100)
   , p_alert_id     VARCHAR2 (100)
   , p_list_id      INTEGER
   , p_key_label    VARCHAR2 (500)
   , p_old_state    VARCHAR (100)
   , p_new_state    VARCHAR (100)
   , p_status       VARCHAR2 (100)
   , p_err_msg      VARCHAR2 (4000)
);

DROP TABLE tmp_sql;

CREATE TABLE tmp_sql (
v_sql varchar2(4000)
);

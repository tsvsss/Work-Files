
  CREATE OR REPLACE EDITIONABLE PACKAGE "APPS"."XWRL_OWS_UTILS" AS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_xwrl_ows_utils.pks 1.1 2019/11/15 12:00:00ET   IRI Exp                                     $*/
/********************************************************************************************************************
* Object Type         : Package Specification                                                                       *
* Name                : xwrl_ows_utils					                                                            *
* Script Name         : apps_create_xwrl_ows_utils.pks                                                              *
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


   TYPE alert_in_rec IS RECORD (
      p_alert_id VARCHAR2 (100)
      , p_to_state VARCHAR2 (100)
      , p_comment VARCHAR2 (1000)
   );
   TYPE alert_tbl_in_type IS
      TABLE OF alert_in_rec INDEX BY BINARY_INTEGER;

      no_db_link EXCEPTION;
      PRAGMA exception_init (no_db_link, -12541);  --ORA-12541: TNS:no listener


   PROCEDURE test_db_link (
      x_response OUT integer
   );

   /* Note: This procedure is called from the ADF application*/
   PROCEDURE process_alerts (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
      , p_alert_tab    IN             xwrl_alert_tbl_in_type
   );

   /* Note: This procedure is called from PL/SQL (auto_clear_individuals)
                  Needed to overload the procedure and keep synchronized
                   Unable to initialize the xwrl_alert_tbl_in_type
                   Substitution is alert_tbl_in_type
   */
   PROCEDURE process_alerts (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
      , p_alert_tab    IN             alert_tbl_in_type
   );

   PROCEDURE auto_clear_individuals (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
   );

   PROCEDURE auto_clear_entities (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
   );

FUNCTION ChangeToOwsState(p_statename in varchar2) RETURN VARCHAR2;  -- Added by Ravi T on Nov-06-2019

   FUNCTION ChangeOwsState(p_statename in varchar2) RETURN VARCHAR2; --  Added by Ravi T on Nov-06-2019

END xwrl_ows_utils;

/

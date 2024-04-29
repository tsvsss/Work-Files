"V_SQL"
"
  CREATE OR REPLACE EDITIONABLE PACKAGE ""APPS"".""RMI_OWS_COMMON_UTIL"" 
AS
/*******************************************************************************************************************************************
* Legend : Type                                                                                                                            *
* I --> Initial                                                                                                                            *
* E --> Enhancement                                                                                                                        *
* R --> Requirement                                                                                                                        *
* B --> Bug                                                                                                                                *
********************************************************************************************************************************************/
/*$Header: rmi_ows_common_util.pkb 1.1 2019/11/15 12:00:00ET   IRI Exp                                            $                        */
/*******************************************************************************************************************************************
* Object Type         : Package Body                                                                                                       *
* Name                : rmi_ows_common_util                                                                                                *
* Script Name         : rmi_ows_common_util.pkb                                                                                            *
* Purpose             :                                                                                                                    *
*                                                                                                                                          *
* Company             : International Registries, Inc.                                                                                     *
* Module              : Trade Compliance                                                                                                   *
* Created By          : SAGARWAL                                                                                                           *
* Created Date        : 11-NOV-2019                                                                                                        *
* Last Reviewed By    :                                                                                                                    *
* Last Reviewed Date  :                                                                                                                    *
********************************************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification -------          >             *
* Date        By               Script               By            Date         Type  Details                                               *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------                       *
* 15-NOV-2019 IRI              1.1                TSUAZO          15-NOV-2019  I      Trade Compliance                                     *
* 15-NOV-2019 IRI              1.2                GVELLA          15-NOV-2019  R     Modified approve_screening_request                    *
*                                                                                   to autoclose case if autoapproved                      *
* 17-NOV-2019 IRI              1.3                GVELLA          17-NOV-2019  R    Added function is_authorized_to_a"
"
  CREATE OR REPLACE EDITIONABLE PACKAGE ""APPS"".""XWRL_DATA_PROCESSING"" AS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_xwrl_data_processing.pks 1.1 2019/11/15 12:00:00ET   IRI Exp                               $*/
/********************************************************************************************************************
* Object Type         : Package Specification                                                                       *
* Name                : xwrl_data_processing                                                                        *
* Script Name         : apps_create_xwrl_data_processing.pks                                                        *
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
* 19-NOV-2019 IRI              1.2                TSUAZO          19-NOV-2019  I     Diable WC processing; Add Master record processing              *
*                                                                                                                   *
********************************************************************************************************************/

   v_rownum INTEGER := 10;

   /*
   PROCEDURE process_wc_data_individual (
      p_max_jobs INTEGER DEFAULT NULL
   );

   PROCEDURE process_wc_data_entity (
      p_max_jobs INTEGER DEFAULT NULL
   );

   PROCEDURE process_wc_xml_parser;

   */
   PROCEDURE process_ows_error_resubmit (
      p_max_jobs   INTEGER DEFAULT NULL
      , p_id         INTEGER DEFAULT NULL
   );

   PROCEDURE stop_schedule_processing;

   PROCEDURE stop_schedule_processing (
      p_end_date VARCHAR2
   );

   PROCEDURE stop_job_processing;

   PROCEDURE start_schedule_processing;

   PROCEDURE start_"
"
  CREATE OR REPLACE EDITIONABLE PACKAGE ""APPS"".""XWRL_DATA_UTILS"" AS

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

CREATE OR REPLACE EDITIONABLE PACKAGE BODY ""APPS"".""XWRL_DATA_UTILS"" AS

/********************************************************************************************************************
* Legend : Type                                                                            "
"
  CREATE OR REPLACE EDITIONABLE PACKAGE ""APPS"".""XWRL_OWS_UTILS"" AS

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

   /* Note: This procedure is called from PL/SQL (auto_clear_in"
"
  CREATE OR REPLACE EDITIONABLE PACKAGE ""APPS"".""XWRL_UTILS"" AS

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
* Name                : xwrl_utils                                                                                  *
* Script Name         : apps_create_xwrl_utils.pks                                                                  *
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
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I      Add    create_audit_record          *
* 16-NOV-2019 IRI              1.3                TSUAZO          16-NOV-2019  I      Remove    create_audit_record          *
* 17-NOV-2019 IRI              1.4                TSUAZO          17-NOV-2019  I     Update cleanse_name          *
* 17-NOV-2019 IRI              1.5                TSUAZO          17-NOV-2019  I     Add RMI_OWS_COMMON_UTIL functions          *                                                                                                               
********************************************************************************************************************/

   TYPE p_rec IS RECORD (
      key VARCHAR2 (300)
      , value VARCHAR2 (32767)
   );

   TYPE p_tab IS
      TABLE OF p_rec INDEX BY BINARY_INTEGER;

   invalid_request EXCEPTION;
   server_unavailable EXCEPTION;
   invalid_xml EXCEPTION;

   server_not_"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_ALERT_CLEARING_XREF_TRG"" BEFORE
   INSERT ON xwrl_alert_clearing_xref
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_alert_clearing_xref_seq.nextval;
   END IF;

   :NEW.source_key := :NEW.source_table||:NEW.source_table_column||:NEW.source_id;

END;

ALTER TRIGGER ""XWRL"".""XWRL_ALERT_CLEARING_XREF_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_ALERT_NOTES_AFTER_IUD_TRG"" 

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XWRL_ALERT_NOTES_AFTER_IUD.trg 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : XWRL_ALERT_NOTES_AFTER_IUD_TRG                                                                      *
* Script Name         : XWRL_ALERT_NOTES_AFTER_IUD.trg                                                                   *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                    *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    : TSUAZO                                                                                      *
* Last Reviewed Date  : 11-NOV-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO        15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  R      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/

  AFTER INSERT OR UPDATE OR DELETE ON XWRL_ALERT_NOTES
  FOR EACH ROW 

DECLARE

--PRAGMA AUTONOMOUS_TRANSACTION;    

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_ALERT_NOTES'
and data_type not in ('XMLTYPE')
;

v_rec XWRL_AUDIT_LOG%rowtype;

p_row_action varchar2(20);

BEGIN

IF INSERTING THEN 
      p_row_action := 'INSERT';
ELSIF UPDATING THEN 
      p_row_action := 'UPDATE';      
ELSIF DELETING THEN 
      p_row_action := 'DELETE';      
END IF;

BEGIN
IF NVL(TO_CHAR(:OLD.ID),'X') <> NVL(TO_CHAR(:NEW.ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.I"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_ALERT_NOTES_TRG"" BEFORE
   INSERT ON xwrl_alert_notes
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_alert_notes_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_ALERT_NOTES_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_AUDIT_LOG_TRG"" BEFORE
   INSERT ON XWRL_AUDIT_LOG
   FOR EACH ROW
BEGIN
   IF (:new.AUDIT_LOG_ID IS NULL) THEN
      :new.AUDIT_LOG_ID := XWRL_AUDIT_LOG_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_AUDIT_LOG_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_CASE_DOC_AFTER_IUD_TRG"" 

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XWRL_CASE_DOCUMENTS_AFTER_IUD_TRG.trg 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : XWRL_CASE_DOC_AFTER_IUD_TRG                                                                      *
* Script Name         : XWRL_CASE_DOCUMENTS_AFTER_IUD_TRG.trg                                                                   *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                    *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    : TSUAZO                                                                                      *
* Last Reviewed Date  : 11-NOV-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO        15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  R      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/

  AFTER INSERT OR UPDATE OR DELETE ON XWRL_CASE_DOCUMENTS
  FOR EACH ROW 

DECLARE

--PRAGMA AUTONOMOUS_TRANSACTION;    

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_CASE_DOCUMENTS'
and data_type not in ('XMLTYPE')
;

v_rec XWRL_AUDIT_LOG%rowtype;

p_row_action varchar2(20);

BEGIN

IF INSERTING THEN 
      p_row_action := 'INSERT';
ELSIF UPDATING THEN 
      p_row_action := 'UPDATE';      
ELSIF DELETING THEN 
      p_row_action := 'DELETE';      
END IF;

BEGIN
IF NVL(TO_CHAR(:OLD.ID),'X') <> NVL(TO_CHAR(:NEW.ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABL"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_CASE_NOTES_AFTER_IUD_TRG"" 

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XWRL_CASE_NOTES_AFTER_IUD_TRG.trg 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : XWRL_CASE_NOTES_AFTER_IUD_TRG                                                                      *
* Script Name         : XWRL_CASE_NOTES_AFTER_IUD_TRG.trg                                                                   *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                    *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    : TSUAZO                                                                                      *
* Last Reviewed Date  : 11-NOV-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO        15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  R      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/

  AFTER INSERT OR UPDATE OR DELETE ON XWRL_CASE_NOTES
  FOR EACH ROW 

DECLARE

--PRAGMA AUTONOMOUS_TRANSACTION;    

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_CASE_NOTES'
and data_type not in ('XMLTYPE')
;

v_rec XWRL_AUDIT_LOG%rowtype;

p_row_action varchar2(20);

BEGIN

IF INSERTING THEN 
      p_row_action := 'INSERT';
ELSIF UPDATING THEN 
      p_row_action := 'UPDATE';      
ELSIF DELETING THEN 
      p_row_action := 'DELETE';      
END IF;

BEGIN
IF NVL(TO_CHAR(:OLD.ID),'X') <> NVL(TO_CHAR(:NEW.ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_CASE_NOTES_TRG"" BEFORE
   INSERT ON xwrl_case_notes
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_case_notes_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_CASE_NOTES_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_CATEGORY_RESTRICTION"" 

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: xwrl_category_restriction.trg 1.1 2019/11/15 12:00:00ET   IRI Exp 								      $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : xwrl_category_restriction                                                                   *
* Script Name         : xwrl_category_restriction.trg                                                               *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : SAGARWAL                                                                                    *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    : GVELLA                                                                                      *
* Last Reviewed Date  : 11-NOV-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                SAGARWAL        15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                GVELLA          15-NOV-2019  R      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/


   AFTER INSERT OR UPDATE ON xwrl.xwrl_response_rows FOR EACH ROW

DECLARE

    l_category_restricted VARCHAR2(10);

BEGIN    
   --- Check to see if the CATEGORY is in the Restricted Category
   --- If so set the vetting status to LEGAL REVIEW

   IF UPPER(:NEW.key) = 'CATEGORY'
   THEN                 

      BEGIN

         SELECT 'Y'
           INTO l_category_restricted
           FROM xwrl.xwrl_parameters
          WHERE id                  = 'CASE_RESTRICTIONS'
            AND UPPER(value_string) = UPPER(:NEW.value);

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            l_category_restricted := 'N';
         WHEN TO"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_DOC_REFERENCE_TRG"" BEFORE
   INSERT ON xwrl_document_reference
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_doc_reference_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_DOC_REFERENCE_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_ENT_IND_AFTER_IUD_TRG"" 

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XWRL_RESPONSE_ENTITY_COLUMNS_AFTER_IUD_TRG.trg 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : XWRL_RES_ENT_AFTER_IUD_TRG                                                                      *
* Script Name         : XWRL_RESPONSE_ENTITY_COLUMNS_AFTER_IUD_TRG.trg                                                                   *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                    *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    : TSUAZO                                                                                      *
* Last Reviewed Date  : 11-NOV-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO        15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  R      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/

  AFTER INSERT OR UPDATE OR DELETE ON XWRL_RESPONSE_ENTITY_COLUMNS
  FOR EACH ROW 

DECLARE

--PRAGMA AUTONOMOUS_TRANSACTION;    

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_RESPONSE_ENTITY_COLUMNS'
and data_type not in ('XMLTYPE')
;

v_rec XWRL_AUDIT_LOG%rowtype;

p_row_action varchar2(20);

BEGIN

IF INSERTING THEN 
      p_row_action := 'INSERT';
ELSIF UPDATING THEN 
      p_row_action := 'UPDATE';      
ELSIF DELETING THEN 
      p_row_action := 'DELETE';      
END IF;

BEGIN
IF NVL(TO_CHAR(:OLD.DNADDRESSCOUNTRY),'X') <> NVL(TO_CHAR(:NEW.DNADDRESSCO"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_ENT_RESPONSE_LEGAL_REVIEW"" 

/*************************************************************************************************************************
* Legend : Type                                                                                                          *   
* I --> Initial                                                                                                          *
* E --> Enhancement                                                                                                      *
* R --> Requirement                                                                                                      *
* B --> Bug                                                                                                              *
**************************************************************************************************************************/
/*$Header: XOWS_GRANTS.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                                          $*/
/*************************************************************************************************************************
* Object Type         : Trigger                                                                                          *
* Name                : xwrl_ind_response_legal_review                                                                   *
* Script Name         :                                                                                                  *
* Purpose             :                                                                                                  *
*                                                                                                                        *
* Company             : International Registries, Inc.                                                                   *
* Module              : Trade Compliance                                                                                 *
* Created By          : SAGARWAL                                                                                         *
* Created Date        : 11-NOV-2019                                                                                      *
* Last Reviewed By    : GVELLA                                                                                           *
* Last Reviewed Date  : 11-NOV-2019                                                                                      *
**************************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->     *
* Date        By               Script               By            Date         Type  Details                             *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ---------------------------------- *
* 15-NOV-2019 IRI              1.1                SAGARWAL        15-NOV-2019  I      Trade Compliance                   *
* 15-NOV-2019 IRI              1.2                GVELLA          15-NOV-2019  R      Trade Compliance                   *
* 15-NOV-2019 IRI              1.3                GVELLA          15-NOV-2019  R      Added logic to put the LEGAL_REVIEW*
*                                                                                     flag to Y based on conditions.     *
* 19-NOV-2019 IRI              1.4                GVELLA          19-NOV-2019  R      Added the Inserting condition      *
**************************************************************************************************************************/



   BEFORE INSERT OR UPDATE ON xwrl.xwrl_response_entity_columns FOR EACH ROW
DECLARE

l_request_id          NUMBER;
l_category_restricted VARCHAR2(10);
l_sanctioned_country  VARCHAR2(10) := 'N';

BEGIN    

   IF INSER"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_IND_RESPONSE_LEGAL_REVIEW"" 
/*************************************************************************************************************************
* Legend : Type                                                                                                          *
* I --> Initial                                                                                                          *
* E --> Enhancement                                                                                                      *
* R --> Requirement                                                                                                      *
* B --> Bug                                                                                                              *
**************************************************************************************************************************/
/*$Header: XOWS_GRANTS.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                                          $*/
/*************************************************************************************************************************
* Object Type         : Trigger                                                                                          *
* Name                : xwrl_ind_response_legal_review                                                                   *
* Script Name         :                                                                                                  *
* Purpose             :                                                                                                  *
*                                                                                                                        *
* Company             : International Registries, Inc.                                                                   *
* Module              : Trade Compliance                                                                                 *
* Created By          : SAGARWAL                                                                                         *
* Created Date        : 11-NOV-2019                                                                                      *
* Last Reviewed By    : GVELLA                                                                                           *
* Last Reviewed Date  : 11-NOV-2019                                                                                      *
**************************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->     *
* Date        By               Script               By            Date         Type  Details                             *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ---------------------------------- *
* 15-NOV-2019 IRI              1.1                SAGARWAL        15-NOV-2019  I      Trade Compliance                   *
* 15-NOV-2019 IRI              1.2                GVELLA          15-NOV-2019  R      Trade Compliance                   *
* 15-NOV-2019 IRI              1.3                GVELLA          15-NOV-2019  R      Added logic to put the LEGAL_REVIEW*
*                                                                                     flag to Y based on conditions.     *
* 19-NOV-2019 IRI              1.4                GVELLA          19-NOV-2019  R      Added the Inserting condition      *
**************************************************************************************************************************/
BEFORE INSERT OR UPDATE
   ON xwrl.xwrl_response_ind_columns
   FOR EACH ROW
DECLARE
   l_request_id            NUMBER;
   l_category_restricted   VARCHAR2 (10);
   l_sanctioned_country    VARCHAR2 (10) := 'N';
BEGIN
   IF IN"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_NOTE_TEMPLATES_TRG"" BEFORE
   INSERT ON xwrl_note_templates
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_note_templates_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_NOTE_TEMPLATES_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_PARTY_ALIAS"" BEFORE
   INSERT ON xwrl_party_alias
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_party_alias_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_PARTY_ALIAS"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_PARTY_MASTER_TRG"" BEFORE
   INSERT ON xwrl_party_master
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_party_master_seq.nextval;
   END IF;

   :NEW.source_key := :NEW.source_table||:NEW.source_table_column||:NEW.source_id;
   :NEW.xref_source_key := :NEW.xref_source_table||:NEW.xref_source_table_column||:NEW.xref_source_id;

END;

ALTER TRIGGER ""XWRL"".""XWRL_PARTY_MASTER_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_PARTY_XREF_TRG"" BEFORE
   INSERT ON xwrl_party_xref
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_party_xref_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_PARTY_XREF_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_REQUESTS"" BEFORE
   INSERT ON xwrl_requests
   FOR EACH ROW
BEGIN

   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests_seq.nextval;
   END IF;

END;

ALTER TRIGGER ""XWRL"".""XWRL_REQUESTS"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_REQUESTS_AFTER_IUD_TRG"" 

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: xwrl_requests_after_iud.trg 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : xwrl_requests_post_upd                                                                      *
* Script Name         : xwrl_requests_after_iud.trg                                                                   *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                    *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    : TSUAZO                                                                                      *
* Last Reviewed Date  : 11-NOV-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO        15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  R      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/

  AFTER INSERT OR UPDATE OR DELETE ON XWRL_REQUESTS
  FOR EACH ROW 

DECLARE

--PRAGMA AUTONOMOUS_TRANSACTION;    

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_REQUESTS'
and data_type not in ('XMLTYPE')
and column_name not in ('SOAP_QUERY')
;

v_rec XWRL_AUDIT_LOG%rowtype;

p_row_action varchar2(20);

BEGIN

IF INSERTING THEN 
      p_row_action := 'INSERT';
ELSIF UPDATING THEN 
      p_row_action := 'UPDATE';      
ELSIF DELETING THEN 
      p_row_action := 'DELETE';      
END IF;

BEGIN
IF NVL(TO_CHAR(:OLD.MASTER_ID),'X') <> NVL(TO_CHAR(:NEW.MASTER_ID),'X')  THEN 
IF p_row_action = 'DELETE' T"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_REQUESTS_INS_UPD"" 
/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XOWS_GRANTS.sql 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : XWRL_REQUESTS_INS_UPD                                                                       *
* Script Name         :                                                                                             *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : SAGARWAL                                                                                    *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    : GVELLA                                                                                      *
* Last Reviewed Date  : 11-NOV-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                SAGARWAL        15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.3                SAGARWAL        15-NOV-2019  R      Merged Legal Review conditions*
* 17-NOV-2019 IRI              1.4                GVELLA         15-NOV-2019  R       Added validation to close all *
*                                                                                     alerts before closing the case*
*                                                                                     also added validation to make *
*                                                                                     prevent general user from     *
*                                                                                     approving the vetting under   *
*                                                                                     Legal Review                  *
********************************************************************************************************************/

   BEFORE INSERT OR UPDATE ON XWRL.xwrl_requests REFERENCING OLD AS OLD NE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_REQUESTS_POST_UPD"" 

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: xwrl_requests_post_upd.trg 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : xwrl_requests_post_upd                                                                      *
* Script Name         : xwrl_requests_post_upd.trg                                                                  *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : SAGARWAL                                                                                    *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    : GVELLA                                                                                      *
* Last Reviewed Date  : 11-NOV-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                SAGARWAL        15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                GVELLA          15-NOV-2019  R      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/


   AFTER UPDATE
   ON xwrl.xwrl_requests
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   return_code      NUMBER;
   return_message   VARCHAR2 (100);
   l_user_id        NUMBER;
BEGIN
   IF     (:OLD.case_workflow <> :NEW.case_workflow)
      AND (apps.rmi_ows_common_util.case_wf_status (:OLD.case_workflow) IN
                                         ('Legal Review', 'Sr. Legal Review')
          )
      AND           
          (apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow) IN
                                          ('Approved', 'Rejected', 'Pending')
          )
   THEN
      BEGIN
         apps.rmi_ows_comm"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""APPS"".""XWRL_REQUESTS_UPD"" 
/********************************************************************************************************************
* Legend : Type                                                                                                     *
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: xwrl_requests_upd.trg 1.1 2019/11/15 12:00:00ET   IRI Exp                                                $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : xwrl_requests                                                                               *
* Script Name         : xwrl_requests_upd.trg                                                                       *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : SAGARWAL                                                                                    *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    : GVELLA                                                                                      *
* Last Reviewed Date  : 11-NOV-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                SAGARWAL        15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                GVELLA          15-NOV-2019  R      Trade Compliance              *
* 18-NOV-2019 IRI              1.3                SAGARWAL        18-NOV-2019  R      Handled NVL                   *
*                                                                                                                   *
********************************************************************************************************************/
BEFORE INSERT OR UPDATE OF case_workflow
   ON xwrl.xwrl_requests
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_user_id   NUMBER := NVL(apps.fnd_profile.VALUE ('USER_ID'),-1);
BEGIN
   IF NVL (:OLD.case_workflow, 'Xx') != NVL (:NEW.case_workflow, 'Xx')
   THEN
      INSERT INTO xwrl.xwrl_request_approval_history
                  (xwrl_req_approval_history_id,
                   ID,
                   status,
                   created_by,
                   creation_date,
         "
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_REQUEST_APPVL_HIST_INS"" 
   BEFORE INSERT
   ON XWRL.XWRL_REQUEST_APPROVAL_HISTORY    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   tmpvar   NUMBER;
BEGIN
   tmpvar := 0;

   IF :NEW.xwrl_req_approval_history_id IS NULL
   THEN
      SELECT xwrl.xwrl_req_appv_history_id_seq.NEXTVAL
        INTO tmpvar
        FROM DUAL;

      :NEW.xwrl_req_approval_history_id := tmpvar;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE;
END;

ALTER TRIGGER ""XWRL"".""XWRL_REQUEST_APPVL_HIST_INS"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_REQUEST_ENTITY_COL_TRG"" BEFORE
   INSERT ON xwrl_request_entity_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests2_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_REQUEST_ENTITY_COL_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_REQUEST_IND_COL_TRG"" BEFORE
   INSERT ON xwrl_request_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests1_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_REQUEST_IND_COL_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_REQUEST_ROWS_TRG"" BEFORE
   INSERT ON xwrl_request_rows
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests3_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_REQUEST_ROWS_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_RESPONSE_ROWS_TRG"" BEFORE
   INSERT ON xwrl_response_rows
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests6_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_RESPONSE_ROWS_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_RESP_ENTITY_COL_TRG"" BEFORE
   INSERT ON xwrl_response_entity_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests5_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_RESP_ENTITY_COL_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_RESP_IND_COL_TRG"" BEFORE
   INSERT ON xwrl_response_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests4_seq.nextval;
   END IF;
END;

ALTER TRIGGER ""XWRL"".""XWRL_RESP_IND_COL_TRG"" ENABLE"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_RES_IND_AFTER_IUD_TRG"" 

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XWRL_RESPONSE_IND_COLUMNS_AFTER_IUD_TRG.trg 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : XWRL_RES_IND_AFTER_IUD_TRG                                                                      *
* Script Name         : XWRL_RESPONSE_IND_COLUMNS_AFTER_IUD_TRG.trg                                                                   *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                    *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    : TSUAZO                                                                                      *
* Last Reviewed Date  : 11-NOV-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO        15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  R      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/

  AFTER INSERT OR UPDATE OR DELETE ON XWRL_RESPONSE_IND_COLUMNS
  FOR EACH ROW 

DECLARE

--PRAGMA AUTONOMOUS_TRANSACTION;    

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_RESPONSE_IND_COLUMNS'
and data_type not in ('XMLTYPE')
;

v_rec XWRL_AUDIT_LOG%rowtype;

p_row_action varchar2(20);

BEGIN

IF INSERTING THEN 
      p_row_action := 'INSERT';
ELSIF UPDATING THEN 
      p_row_action := 'UPDATE';      
ELSIF DELETING THEN 
      p_row_action := 'DELETE';      
END IF;

BEGIN
IF NVL(TO_CHAR(:OLD.ADDITIONALINFORMATION),'X') <> NVL(TO_CHAR(:NEW.ADDITIONALINFORMAT"
"
  CREATE OR REPLACE EDITIONABLE TRIGGER ""XWRL"".""XWRL_VESSEL_INDICATOR"" 
/*********************************************************************************************************************
* Legend : Type                                                                                                      * 
* I --> Initial                                                                                                      *
* E --> Enhancement                                                                                                  *
* R --> Requirement                                                                                                  *
* B --> Bug                                                                                                          *
*********************************************************************************************************************/
/*$Header: xwrl_vessel_indicator.trg 1.1 2019/11/15 12:00:00ET   IRI Exp                                           $*/
/*********************************************************************************************************************
* Object Type         : Trigger                                                                                      *
* Name                : xwrl_vessel_indicator                                                                        *
* Script Name         : xwrl_vessel_indicator.trg                                                                    *
* Purpose             :                                                                                              *
*                                                                                                                    *
* Company             : International Registries, Inc.                                                               *
* Module              : Trade Compliance                                                                             *
* Created By          : SAGARWAL                                                                                     *
* Created Date        : 11-NOV-2019                                                                                  *
* Last Reviewed By    : GVELLA                                                                                       *
* Last Reviewed Date  : 11-NOV-2019                                                                                  *
**********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification -------> *
* Date        By               Script               By            Date         Type  Details                         *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------ *
* 15-NOV-2019 IRI              1.1                SAGARWAL        15-NOV-2019  I      Trade Compliance               *
* 15-NOV-2019 IRI              1.2                GVELLA          15-NOV-2019  R      Trade Compliance               *
* 19-NOV-2019 IRI              1.3                GVELLA          19-NOV-2019  R      Revised the logic to check for *
*                                                                                     Vssl Indicator flag and set the*
*                                                                                     alert status accordingly       *
**********************************************************************************************************************/

   AFTER INSERT OR UPDATE ON xwrl.xwrl_response_rows FOR EACH ROW
DECLARE

    l_alert_id         VARCHAR2(25);
    l_user             VARCHAR2(200);
    l_record_type      VARCHAR2(10);
    l_vessel_indicator VARCHAR2(10);
    l_path             VARCHAR2(10);

BEGIN

   --- For an ENTITY if vetting for a Vessel then all the matches that have a flag of"
"
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY ""APPS"".""RMI_OWS_COMMON_UTIL"" 
AS
/*******************************************************************************************************************************************
* Legend : Type                                                                                                                            *
* I --> Initial                                                                                                                            *
* E --> Enhancement                                                                                                                        *
* R --> Requirement                                                                                                                        *
* B --> Bug                                                                                                                                *
********************************************************************************************************************************************/
/*$Header: rmi_ows_common_util.pkb 1.1 2019/11/15 12:00:00ET   IRI Exp                                            $                        */
/*******************************************************************************************************************************************
* Object Type         : Package Body                                                                                                       *
* Name                : rmi_ows_common_util                                                                                                *
* Script Name         : rmi_ows_common_util.pkb                                                                                            *
* Purpose             :                                                                                                                    *
*                                                                                                                                          *
* Company             : International Registries, Inc.                                                                                     *
* Module              : Trade Compliance                                                                                                   *
* Created By          : SAGARWAL                                                                                                           *
* Created Date        : 11-NOV-2019                                                                                                        *
* Last Reviewed By    :                                                                                                                    *
* Last Reviewed Date  :                                                                                                                    *
********************************************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification -------          >             *
* Date        By               Script               By            Date         Type  Details                                               *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------                       *
* 15-NOV-2019 IRI              1.1                TSUAZO          15-NOV-2019  I      Trade Compliance                                     *
* 15-NOV-2019 IRI              1.2                GVELLA          15-NOV-2019  R     Modified approve_screening_request                    *
*                                                                                   to autoclose case if autoapproved                      *
* 17-NOV-2019 IRI              1.3                GVELLA          17-NOV-2019  R    Added function is_authorized"
"
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY ""APPS"".""XWRL_DATA_PROCESSING"" AS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_xwrl_data_processing.pkb 1.1 2019/11/15 12:00:00ET   IRI Exp                               $*/
/********************************************************************************************************************
* Object Type         : Package Body                                                                                *
* Name                : xwrl_data_processing                                                            *
* Script Name         : apps_create_xwrl_data_processing.pkb                                                        *
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
* 19-NOV-2019 IRI              1.2                TSUAZO          19-NOV-2019  I     Diable WC processing; Add Master record processing              *
*                                                                                                                   *
********************************************************************************************************************/

   FUNCTION verify_master_fullname (
      p_source_table          VARCHAR2
      , p_source_table_column   VARCHAR2
      , p_source_id             INTEGER
      , p_entity_type           VARCHAR2 DEFAULT NULL
      , p_target_column           VARCHAR2 DEFAULT NULL
   ) RETURN VARCHAR2 IS

      v_sql             VARCHAR2 (1000);

      v_append          VARCHAR2 (500);

      v_target_column   VARCHAR2 (4000);
      v_name            VARCHAR2 (4000);
      v_source_table            VARCHAR2 (4000);

   BEGIN

      v_sql := NULL;
      v_append := NULL;
      v_name := NULL;

      v_"
"
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY ""APPS"".""XWRL_DATA_UTILS"" AS

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
* Script Name         : apps_create_xwrl_data_utils.pkb                                                                  *
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


      procedure create_trigger_logic (p_table_name in varchar2, p_column_id in varchar2, p_action in varchar2 default null) IS

      cursor c1 is
      select column_name
      from all_tab_columns
      where table_name = p_table_name
      and data_type not in ('XMLTYPE')
      and column_name not in ('SOAP_QUERY');

      x_result varchar2(4000);

      begin

      for c1rec in c1 loop

      xwrl_data_utils.create_audit_record(p_table_name,  c1rec.column_name , p_column_id,  p_action,  x_result);

      --dbms_output.put_line('x_result: '||x_result);

      insert into tmp_sql (v_sql) valu"
"
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY ""APPS"".""XWRL_OWS_UTILS"" AS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_xwrl_ows_utils.pkb 1.1 2019/11/15 12:00:00ET   IRI Exp                                     $*/
/********************************************************************************************************************
* Object Type         : Package Body                                                                                *
* Name                : xwrl_ows_utils					                                                            *
* Script Name         : apps_create_xwrl_ows_utils.pkb                                                              *
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
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I     Return immediate Commit to DML  instead of end of loop         *
*                                                                                                                   *
********************************************************************************************************************/

   PROCEDURE test_db_link (
      x_response OUT integer )
      IS

      BEGIN

      x_response := 0;

      select 1 into x_response from dual@ebstoows2.coresys.com;    

      exception
      when others then null;

      END test_db_link;


   PROCEDURE process_alerts (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
      , p_alert_tab    IN             xwrl_alert_tbl_in_type
   ) IS

      l_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
      l_alert_out_tbl   xows."
"
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY ""APPS"".""XWRL_UTILS"" AS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_xwrl_utils.pkb 1.1 2019/11/15 12:00:00ET   IRI Exp                                         $*/
/********************************************************************************************************************
* Object Type         : Package Body                                                                                *
* Name                : xwrl_utils                                                                                  *
* Script Name         : apps_create_xwrl_utils.pkb                                                                  *
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
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I      Add    create_audit_record          *
* 16-NOV-2019 IRI              1.3                TSUAZO          16-NOV-2019  I      Remove    create_audit_record          *
* 17-NOV-2019 IRI              1.4                TSUAZO          17-NOV-2019  I     Update cleanse_name          *
* 17-NOV-2019 IRI              1.5                TSUAZO          17-NOV-2019  I     Add RMI_OWS_COMMON_UTIL functions          *                                                                                                               
********************************************************************************************************************/


   FUNCTION cleanse_name (
   p_name varchar2
   ) return varchar2 as 

   v_name varchar2(1000);

   begin

   --v_name := p_name;
   --v_name := replace (v_name, '&', chr (38) || 'amp;'); -- replace ampersand for XML processing
   --v_name := replac"

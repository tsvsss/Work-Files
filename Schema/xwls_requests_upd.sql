/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XOWS_GRANTS.sql 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         :                                                                                             *
* Name                :                                                                                             *
* Script Name         :                                                                                             *
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

CREATE OR REPLACE TRIGGER xwrl.xwls_requests_upd
   BEFORE UPDATE OF CASE_WORKFLOW
   ON xwrl.xwrl_requests
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
BEGIN
   IF :OLD.CASE_WORKFLOW != :NEW.CASE_WORKFLOW
   THEN
      INSERT INTO xwrl.xwrl_request_approval_history
                  (xwrl_req_approval_history_id,
                   ID,
                   status, created_by,
                   creation_date,
                   last_updated_by,
                   last_update_date,
                   last_update_login,
                   source_table, source_id
                  )
           VALUES (NULL /* WC_REQUEST_APPROVAL_HISTORY_ID */,
                   :NEW.ID /* WC_SCREENING_REQUEST_ID */,
                   :NEW.CASE_WORKFLOW /* STATUS */, :NEW.created_by /* CREATED_BY */,
                   :NEW.creation_date /* CREATION_DATE */,
                   :NEW.last_updated_by /* LAST_UPDATED_BY */,
                   :NEW.last_update_date /* LAST_UPDATE_DATE */,
                   :NEW.last_update_login /* LAST_UPDATE_LOGIN */,
                   :NEW.source_table, :NEW.source_id
                  );
   END IF;

   IF :NEW.CASE_WORKFLOW IS NULL
   THEN
      :NEW.CASE_WORKFLOW := 'P';
   END IF;
/*if :old.status !=:new.status and :new.status='Legal Review' then
if apps.iri_security.authorize('WORLD_CHECK_APPROVERS')='N'  then
:new.sent_to_legal_by := :NEW.LAST_UPDATED_BY;
end if;*/
EXCEPTION
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE;
END;
/


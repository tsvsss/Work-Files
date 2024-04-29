ALTER TRIGGER "APPS"."XWRL_REQUESTS_UPD" 
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
* 08-JAN-2020 IRI              1.4                SAGARWAL        08-JAN-2020  R      Added Master ID               *
* 05-FEB-2020 IRI              1.5                SAGARWAL        05-FEB-2020  R      Restrict blank Status Cases   *
* 06-JUL-2020 IRI              1.6                TSUAZO          06-JUL-2020  E      Bypass Trigger Logic          *
*                                                                                                                   *
********************************************************************************************************************/
BEFORE INSERT OR UPDATE OF case_workflow
   ON xwrl.xwrl_requests
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_user_id   NUMBER := NVL(apps.fnd_profile.VALUE ('USER_ID'),-1);
   
   bypass_trigger EXCEPTION;
   v_bypass_trigger varchar2(10);
   
BEGIN

   SELECT SYS_CONTEXT('xwrl_ctx', 'disable_trigger') into v_bypass_trigger FROM dual;
   if v_bypass_trigger is null then
      raise bypass_trigger;
   end if;

   IF NVL (:OLD.case_workflow, 'Xx') != NVL (:NEW.case_workflow, 'Xx')
   AND :NEW.case_workflow IS NOT NULL
   THEN
      INSERT INTO xwrl.xwrl_request_approval_history
                  (xwrl_req_approval_history_id,
                   ID,
                   status,
                   created_by,
                   creation_date,
                   last_updated_by,
                   last_update_date,
                   last_update_login,
                   source_table, source_id,
                   master_id, alias_id, xref_id
                  )
           VALUES (NULL /* WC_REQUEST_APPROVAL_HISTORY_ID */,
                   :NEW.ID /* WC_SCREENING_REQUEST_ID */,
                   :NEW.case_workflow /* STATUS */,
                   :NEW.created_by /* CREATED_BY */,
                   :NEW.creation_date /* CREATION_DATE */,
                   NVL (:NEW.last_updated_by, l_user_id) /* LAST_UPDATED_BY */,
                   :NEW.last_update_date /* LAST_UPDATE_DATE */,
                   :NEW.last_update_login /* LAST_UPDATE_LOGIN */,
                   :NEW.source_table, :NEW.source_id,
                   :NEW.master_id, :NEW.alias_id, :NEW.xref_id
                  );
   END IF;

   IF :NEW.case_workflow IS NULL
   THEN
      :NEW.case_workflow := 'P';
   END IF;
/*if :old.status !=:new.status and :new.status='Legal Review' then
if apps.iri_security.authorize('WORLD_CHECK_APPROVERS')='N'  then
:new.sent_to_legal_by := :NEW.LAST_UPDATED_BY;
end if;*/
EXCEPTION

   when bypass_trigger then null;
   
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE;
	     
END;
/
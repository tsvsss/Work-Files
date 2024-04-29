
  CREATE OR REPLACE EDITIONABLE TRIGGER "XWRL"."XWRL_REQUESTS_POST_UPD" 

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
         apps.rmi_ows_common_util.send_notice_from_trigger
                 (:NEW.ID,
                  :NEW.created_by,
                  :NEW.name_screened,
                  apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow),
                  :NEW.source_table,
                  :NEW.source_id,
                  return_code,
                  return_message
                 );
--                                                          
      EXCEPTION
         WHEN OTHERS
         THEN
            apps.mt_log_error (:NEW.ID || ' ' || 'exception ' || SQLERRM);

      END;

   ELSIF     (:OLD.case_workflow <> :NEW.case_workflow)
         AND (apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow) =
                                                                 'Provisional'
             )
         AND :NEW.source_table = 'SICD_SEAFARERS'

   THEN
      apps.mt_log_error (:NEW.ID || ' ' || 'attempting to send notice - 3');

      BEGIN
         --
         BEGIN
            SELECT last_updated_by
              INTO l_user_id
              FROM xwrl.xwrl_request_approval_history
             WHERE source_table = :OLD.source_table
               AND source_id = :OLD.source_id
               AND xwrl_req_approval_history_id =
                      (SELECT MAX (xwrl_req_approval_history_id)
                         FROM xwrl.xwrl_request_approval_history h,
                              apps.fnd_user fu
                        WHERE 1 = 1
                          AND fu.user_id = h.last_updated_by
                          AND apps.rmi_ows_common_util.case_wf_status (status) IN
                                                  ('Pending', 'Legal Review')
                          AND source_table = :OLD.source_table
                          AND source_id = :OLD.source_id
                          AND NOT EXISTS (
                                 SELECT 1
                                   FROM apps.fnd_lookup_values_vl flv
                                  WHERE lookup_type = 'RMI_TRADE_LEGAL_USERS'
                                    AND lookup_code = fu.user_name
                                    AND flv.enabled_flag = 'Y'
                                    AND TRUNC (SYSDATE)
                                           BETWEEN TRUNC
                                                      (NVL (start_date_active,
                                                            SYSDATE
                                                           )
                                                      )
                                               AND TRUNC
                                                        (NVL (end_date_active,
                                                              SYSDATE
                                                             )
                                                        )));
         EXCEPTION
            WHEN OTHERS
            THEN
               l_user_id := NULL;
         END;

         apps.rmi_ows_common_util.send_notice_from_trigger
                  (:OLD.ID,
                   --:OLD.created_by,
                   l_user_id,
                   :NEW.name_screened,
                   apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow),
--                                                 :NEW.notes,
                   :NEW.source_table,
                   :NEW.source_id,
                   return_code,
                   return_message
                  );
      EXCEPTION
         WHEN OTHERS
         THEN
            apps.mt_log_error (:NEW.ID || ' ' || 'exception ' || SQLERRM);
      END;

   ELSIF     (:OLD.case_workflow <> :NEW.case_workflow)
         AND (apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow) IN
                                                      ('Approved', 'Pending')
             )
         AND :NEW.source_table = 'SICD_SEAFARERS'
--         AND apps.world_check_iface.is_trade_legal_user (:NEW.last_updated_by) =
--                                                                           'Y'
   THEN
      apps.mt_log_error (:NEW.ID || ' ' || 'attempting to send notice - 4');

      BEGIN
         --
         BEGIN
            SELECT last_updated_by
              INTO l_user_id
              FROM xwrl.xwrl_request_approval_history
             WHERE 1 = 1
               AND source_table = :OLD.source_table
               AND source_id = :OLD.source_id
               AND xwrl_req_approval_history_id =
                      (SELECT MAX (xwrl_req_approval_history_id)
                         FROM xwrl.xwrl_request_approval_history h,
                              apps.fnd_user fu
                        WHERE 1 = 1
                          AND fu.user_id = h.last_updated_by
                          AND apps.rmi_ows_common_util.case_wf_status (status) IN
                                 ('Pending', 'Legal Review',
                                  'Sr. Legal Review')
                          AND source_table = :OLD.source_table
                          AND source_id = :OLD.source_id
                          AND apps.world_check_iface.is_trade_legal_user
                                                                   (fu.user_id) =
                                                                           'N');
         EXCEPTION
            WHEN OTHERS
            THEN
               l_user_id := NULL;
         END;

         apps.rmi_ows_common_util.send_notice_from_trigger
                  (:OLD.ID,
                   l_user_id,
                   :NEW.name_screened,
                   apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow),
--                                                 :NEW.notes,
                   :NEW.source_table,
                   :NEW.source_id,
                   return_code,
                   return_message
                  );
      EXCEPTION
         WHEN OTHERS
         THEN
            apps.mt_log_error (:NEW.ID || ' ' || 'exception ' || SQLERRM);
      END;
   END IF;
END;
/
ALTER TRIGGER "XWRL"."XWRL_REQUESTS_POST_UPD" ENABLE
;

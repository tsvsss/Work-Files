CREATE OR REPLACE TRIGGER XWRL.xwrl_requests_ins_upd
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
 
   BEFORE INSERT OR UPDATE ON XWRL.xwrl_requests REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
   
DECLARE

   l_username     VARCHAR2 (100);
   l_message      VARCHAR2 (200);
   l_subdivision  VARCHAR2 (25);
   l_count        NUMBER   := 0;
      
BEGIN
     --  19-NOV-2019 GVELLA 1.6 Removed the expiration date logic from Trigger and moved the code to 
     --                         RMI_OWS_COMMON_UTIL.set_expiration_date
     --  20-NOV-2019 GVELLA 1.7 Modified the logic for case approval so that whenever a case is being
     --                         approved by WORLD_CHECK_APPROVER the validations are bypassed.
     --                         Added case id condition to make sure tha the case id is generated before the trigger is fired.

   IF :NEW.case_id IS NOT NULL
   THEN
   
      IF (apps.rmi_ows_common_util.is_blocklisted (:NEW.name_screened) = 'Y')
         -- Once Vetting is Rejected do not send further emails
         -- Send Email only when Vetting status is changed to Legal Review
         -- Any other update on vetting will not trigger email
         --
         AND apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow) NOT IN ('Legal Review', 'Rejected')
      THEN

         :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review'); 

         BEGIN

            apps.rmi_ows_common_util.send_notice_to_legal (:NEW.name_screened,l_message);

         EXCEPTION
            WHEN OTHERS THEN

            apps.mt_log_error (:NEW.ID || ' SQL ERROR ' || SQLERRM);

         END;

      END IF;

      IF INSERTING
      THEN

         IF apps.rmi_ows_common_util.is_city_crimean (:NEW.city_of_residence) = 'Y'
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         --- Added by Gopi Vella
         ELSIF apps.rmi_ows_common_util.is_city_crimean (:NEW.city_of_residence_id) = 'Y'
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');
         --- End Code Change

         --- Added By Gopi To Check for additional validations
         ELSIF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_residence,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         ELSIF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_address,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         ELSIF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_nationality,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         ELSIF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_birth,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         ELSIF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_registration,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         ELSIF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_operation,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         END IF;

         IF (:NEW.city_of_residence IS NOT NULL OR :NEW.city_of_residence_id IS NOT NULL)
         THEN
   
            BEGIN

               SELECT w.subdivision
                 INTO l_subdivision
                 FROM apps.wc_city_list w,
                      (SELECT iso_alpha2_code, country_code,
                              country_name AS restricted_country
                         FROM apps.sicd_countries) rs
                WHERE w.country_code = rs.country_code
                  AND w.status <> 'TC_OK'
                  AND wc_city_list_id = NVL (:NEW.city_of_residence,:NEW.city_of_residence_id);

            EXCEPTION
               WHEN OTHERS THEN

               l_subdivision := NULL;

            END;

           :NEW.subdivision_city_of_residence := l_subdivision;

         END IF;
        --- End Code Change

      ELSIF UPDATING
      THEN

         IF :NEW.last_update_date IS NULL
         THEN
      
            :NEW.last_update_date := SYSDATE; 
      
         END IF;

         IF NVL (:NEW.case_workflow, 'XX') != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')
            AND apps.rmi_ows_common_util.is_authorized_to_approve (:NEW.last_updated_by) = 'N'
         THEN

            IF NVL (:NEW.city_of_residence, -99) <> NVL (:OLD.city_of_residence,-99)
               AND apps.rmi_ows_common_util.is_city_crimean (:NEW.city_of_residence) = 'Y'
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            --- Added by Gopi Vella
            ELSIF NVL (:NEW.city_of_residence, -99) <> NVL (:OLD.city_of_residence,-99)
               AND apps.rmi_ows_common_util.is_city_crimean (:NEW.city_of_residence_id) = 'Y'
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');
            --- End Code Change

            --- Added By Gopi To Check for additional validations
            ELSIF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_residence,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            ELSIF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_address,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            ELSIF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_nationality,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            ELSIF apps.rmi_ows_common_util.get_sanction_status(NVL(:NEW.country_of_birth,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            ELSIF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_registration,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            ELSIF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_operation,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

           END IF;

         END IF;

         IF (:NEW.city_of_residence IS NOT NULL OR :NEW.city_of_residence_id IS NOT NULL)
         THEN

            BEGIN

               SELECT w.subdivision
                 INTO l_subdivision
                 FROM apps.wc_city_list w,
                      (SELECT iso_alpha2_code, 
                              country_code,
                              country_name AS restricted_country
                         FROM apps.sicd_countries) rs
                WHERE w.country_code   = rs.country_code
                  AND w.status        <> 'TC_OK'
                  AND wc_city_list_id = NVL(:NEW.city_of_residence,:NEW.city_of_residence_id);

            EXCEPTION
               WHEN OTHERS THEN

               l_subdivision := NULL;

            END;

           :NEW.subdivision_city_of_residence := l_subdivision;
   
         END IF;

         IF NVL (:NEW.case_workflow, 'X') IN ('L', 'SL') AND NVL (:NEW.case_state, 'X') IN ('A','C')
         THEN
      
            IF apps.rmi_ows_common_util.is_authorized_to_approve (:NEW.last_updated_by) = 'N'
            THEN
            
               raise_application_error (-20100,'Not authorized approve/close the vetting while under Legal Review');

            END IF;         

         END IF;

         IF NVL (:NEW.case_status, 'X') = 'C' AND NVL (:NEW.case_state, 'X') != 'D'
         THEN

            --- Check to see all the alerts are closed before closing the case

            BEGIN
   
               IF UPPER(:NEW.path) = 'INDIVIDUAL'
               THEN

                  BEGIN
   
                     SELECT COUNT(1)
                       INTO l_count
                       FROM xwrl_response_ind_columns
                      WHERE request_id     = :NEW.id
                        AND UPPER(x_state) LIKE '%OPEN%';

                  EXCEPTION
                     WHEN OTHERS THEN
   
                        l_count := 1;
                  END;     

                  IF l_count > 0
                  THEN

                     raise_application_error(-20100,'Please close all the alerts before closing the case');

                  END IF;

               ELSIF UPPER(:NEW.path) = 'ENTITY'
               THEN

                  BEGIN

                     SELECT COUNT(1)
                       INTO l_count
                       FROM xwrl_response_entity_columns
                      WHERE request_id     = :NEW.id
                        AND UPPER(x_state) LIKE '%OPEN%';

                  EXCEPTION
                     WHEN OTHERS THEN

                        l_count := 1;

                  END;     

                  IF l_count > 0
                  THEN

                     raise_application_error(-20100,'Please close all the alerts before closing the case');
  
                  END IF;

               END IF;

            END;

            IF :OLD.closed_date IS NULL
            THEN
               
               :NEW.closed_date := SYSDATE;
            
            END IF;

            BEGIN

               SELECT user_name
                 INTO l_username
                 FROM apps.fnd_user
                WHERE user_id = :NEW.last_updated_by;

            EXCEPTION
               WHEN OTHERS THEN

               l_username := 'SYSADMIN';

            END;

            --- Close the case on the OWS side
            apps.rmi_ows_common_util.close_ows_case (l_username,:NEW.case_id,:NEW.ID);

         END IF;
      
         IF NVL (:NEW.case_status, 'X') = 'A'
         THEN

            --- Check to see all the alerts are closed before Approving the case

            BEGIN
   
               IF UPPER(:NEW.path) = 'INDIVIDUAL'
               THEN

                  BEGIN
   
                     SELECT COUNT(1)
                       INTO l_count
                       FROM xwrl_response_ind_columns
                      WHERE request_id     = :NEW.id
                        AND UPPER(x_state) LIKE '%OPEN%';

                  EXCEPTION
                     WHEN OTHERS THEN
   
                        l_count := 1;
   
                  END;     

                  IF l_count > 0
                  THEN

                     raise_application_error(-20100,'Please close all the alerts before closing the case');

                  END IF;

               ELSIF UPPER(:NEW.path) = 'ENTITY'
               THEN

                  BEGIN

                     SELECT COUNT(1)
                       INTO l_count
                       FROM xwrl_response_entity_columns
                      WHERE request_id     = :NEW.id
                        AND UPPER(x_state) LIKE '%OPEN%';

                  EXCEPTION
                     WHEN OTHERS THEN
 
                        l_count := 1;
                  END;     

                  IF l_count > 0
                  THEN

                     raise_application_error(-20100,'Please close all the alerts before closing the case');

                  END IF;

               END IF;

            END;

         END IF;
      --- End Code Change

      END IF;

      IF apps.iri_security.authorize ('WORLD_CHECK_APPROVERS') = 'N'
      THEN
      
         IF (apps.world_check_iface.get_sanction_status (:NEW.country_of_residence) = 'PROHIBITED'
              AND NVL (:NEW.country_of_residence, 'XX') <> NVL(:OLD.country_of_residence, 'XX')
              AND apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow) != 'Legal Review'
             )
          THEN

             :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         END IF;

      END IF;
      
   END IF;      
--
END;
/
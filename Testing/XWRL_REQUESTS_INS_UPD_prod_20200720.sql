CREATE OR REPLACE TRIGGER XWRL.XWRL_REQUESTS_INS_UPD
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
* 17-NOV-2019 IRI              1.4                GVELLA          15-NOV-2019  R      Added validation to close all *
*                                                                                     alerts before closing the case*
*                                                                                     also added validation to make *
*                                                                                     prevent general user from     *
*                                                                                     approving the vetting under   *
*                                                                                     Legal Review                  *
********************************************************************************************************************/
BEFORE INSERT OR UPDATE
   ON XWRL.XWRL_REQUESTS    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE

   l_username      VARCHAR2 (100);
   l_message       VARCHAR2 (200);
   l_subdivision   VARCHAR2 (25);
   l_count         NUMBER   := 0;

   bypass_trigger EXCEPTION;
   v_bypass_trigger varchar2(10);

BEGIN
   --  19-NOV-2019 GVELLA 1.6          Removed the expiration date logic from Trigger and moved the code to
   --                                  RMI_OWS_COMMON_UTIL.set_expiration_date
   --  20-NOV-2019 GVELLA 1.7          Modified the logic for case approval so that whenever a case is being
   --                                  approved by WORLD_CHECK_APPROVER the validations are bypassed.
   --                                  Added case id condition to make sure tha the case id is generated before the trigger is fired.
   --  28-JAN-2020 SAGARWAL 1.8 E      Added check for Provisionals  
   --
   -- 28-FEB-2020 GVELLA 1.9          Added Validation for the Crimean Vetting.
   -- 30-JUN-2020 SAGARWAL 2.0        Check City for Conditional Country
   --  06-JUL-2020 TSUAZO              2.1       Bypass Trigger Logic          

   SELECT SYS_CONTEXT('xwrl_ctx', 'disable_trigger') into v_bypass_trigger FROM dual;
   if v_bypass_trigger = 'TRUE' then
      raise bypass_trigger;
   end if;   

   IF :NEW.case_id IS NOT NULL
   THEN

      IF(apps.rmi_ows_common_util.is_blocklisted (:NEW.name_screened) = 'Y')
         -- Once Vetting is Rejected do not send further emails
         -- Send Email only when Vetting status is changed to Legal Review
         -- Any other update on vetting will not trigger email
         --
         AND apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow) NOT IN ('Legal Review', 'Rejected')
      THEN

         :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         BEGIN

            apps.rmi_ows_common_util.send_notice_to_legal(:NEW.name_screened,l_message);

         EXCEPTION
            WHEN OTHERS THEN

               apps.mt_log_error (:NEW.ID || ' SQL ERROR ' || SQLERRM);

         END;

      END IF;

      IF INSERTING
      THEN

         apps.mt_log_error('Inside Inserting');

         -- Added By Gopi Vella for Ticket T20191217.0029

         IF apps.rmi_ows_common_util.is_valid_country_combination(:NEW.country_of_address,:NEW.country_of_residence,:NEW.country_of_nationality,:NEW.country_of_birth,:NEW.country_of_registration) = 'N'
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');
            :NEW.case_status   := 'O';
            :NEW.case_state    := 'N';

         END IF;

         -- End of Code Change
         --IF apps.rmi_ows_common_util.is_city_crimean (:NEW.city_of_residence) = 'Y'
         --THEN

         --   :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         --- Added by Gopi Vella
         apps.mt_log_error('Checking for Crimean Vetting: '||:NEW.city_of_residence_id);

         IF apps.rmi_ows_common_util.is_city_crimean (:NEW.city_of_residence_id) = 'Y'
         THEN                     

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');         
         --- End Code Change

         --- Added By Gopi To Check for additional validations
         ELSIF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_residence,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
            AND :NEW.city_of_residence IS NULL AND :NEW.city_of_residence_id IS NULL
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         ELSIF apps.rmi_ows_common_util.get_sanction_status(NVL(:NEW.country_of_address,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
            AND :NEW.city_of_residence IS NULL AND :NEW.city_of_residence_id IS NULL
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         ELSIF apps.rmi_ows_common_util.get_sanction_status(NVL(:NEW.country_of_nationality,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
            AND :NEW.city_of_residence IS NULL AND :NEW.city_of_residence_id IS NULL
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         ELSIF apps.rmi_ows_common_util.get_sanction_status(NVL(:NEW.country_of_birth,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
            AND :NEW.city_of_residence IS NULL AND :NEW.city_of_residence_id IS NULL
         THEN

           :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         ELSIF apps.rmi_ows_common_util.get_sanction_status(NVL(:NEW.country_of_registration,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
            AND :NEW.city_of_residence IS NULL AND :NEW.city_of_residence_id IS NULL
         THEN

            :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

         ELSIF apps.rmi_ows_common_util.get_sanction_status(NVL(:NEW.country_of_operation,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
            AND :NEW.city_of_residence IS NULL AND :NEW.city_of_residence_id IS NULL
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
                  AND w.status        <> 'TC_OK'
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

         apps.mt_log_error('Inside Updating');

         IF :NEW.last_update_date IS NULL
         THEN

            :NEW.last_update_date := SYSDATE;

         END IF;

         --- Modified the Code by Gopi Vella For HDT T20200107.0008

         -- Added By Gopi Vella for Ticket T20191217.0029
         --IF apps.rmi_ows_common_util.is_valid_country_combination(:NEW.country_of_address,:NEW.country_of_residence,:NEW.country_of_nationality,:NEW.country_of_birth,:NEW.country_of_registration) = 'N'
         --THEN

         --   :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');
         --   :NEW.case_status   := 'O';
         --   :NEW.case_state    := 'N';

         --END IF;
         -- End of Code Change

         /*IF NVL(:NEW.case_workflow,'XX') != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')
            AND apps.rmi_ows_common_util.is_authorized_to_approve(:NEW.last_updated_by) = 'N'
         THEN

            --IF NVL (:NEW.city_of_residence, -99) <> NVL (:OLD.city_of_residence,-99) 
            --   AND apps.rmi_ows_common_util.is_city_crimean(:NEW.city_of_residence) = 'Y'               
            --THEN

            --   :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            --- Added by Gopi Vella
            --ELSIF NVL (:NEW.city_of_residence, -99) <> NVL (:OLD.city_of_residence,-99)
            --   AND apps.rmi_ows_common_util.is_city_crimean (:NEW.city_of_residence_id) = 'Y'
            --THEN

            --   :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');
            --- End Code Change

            --- Added By Gopi To Check for additional validations
            IF apps.rmi_ows_common_util.get_sanction_status(NVL(:NEW.country_of_residence,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
               AND :NEW.city_of_residence IS NULL AND :NEW.city_of_residence_id IS NULL
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            ELSIF apps.rmi_ows_common_util.get_sanction_status(NVL(:NEW.country_of_address,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
               AND :NEW.city_of_residence IS NULL AND :NEW.city_of_residence_id IS NULL
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            ELSIF apps.rmi_ows_common_util.get_sanction_status(NVL(:NEW.country_of_nationality,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
               AND :NEW.city_of_residence IS NULL AND :NEW.city_of_residence_id IS NULL
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp('Legal Review');

            ELSIF apps.rmi_ows_common_util.get_sanction_status(NVL(:NEW.country_of_birth,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
               AND :NEW.city_of_residence IS NULL AND :NEW.city_of_residence_id IS NULL
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            ELSIF apps.rmi_ows_common_util.get_sanction_status(NVL(:NEW.country_of_registration,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
               AND :NEW.city_of_residence IS NULL AND :NEW.city_of_residence_id IS NULL
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            ELSIF apps.rmi_ows_common_util.get_sanction_status(NVL(:NEW.country_of_operation,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
               AND :NEW.city_of_residence IS NULL AND :NEW.city_of_residence_id IS NULL
            THEN

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            END IF;

         ELSIF NVL (:NEW.case_workflow,'XX')  != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')
            AND NVL (:OLD.case_workflow,'XX') != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')
            AND apps.rmi_ows_common_util.is_authorized_to_approve(:NEW.last_updated_by) != 'N'
         THEN

            apps.mt_log_error('Checking for Crimean Vetting: '||:NEW.city_of_residence_id);

            IF apps.rmi_ows_common_util.is_city_crimean (:NEW.city_of_residence_id) = 'Y'
            THEN                     

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

               apps.mt_log_error('Vetting is Crimean Vetting');

            END IF;

         END IF;*/

         IF NVL (:NEW.case_workflow,'XX') != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')
            AND NVL (:OLD.case_workflow,'XX') != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')                  
         THEN

            apps.mt_log_error('Checking Country of Residence: '||:NEW.country_of_residence);

            IF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_residence,'NA')) IN ('PROHIBITED') 
            THEN

               IF apps.rmi_ows_common_util.is_authorized_to_approve(:NEW.last_updated_by) = 'N'
                  AND :NEW.expiration_date IS NULL
               THEN

                  :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

                  apps.mt_log_error('Prohibited Country of Residence.');

               END IF;

            END IF;

            --SAURABH 18-JUN-2020 T20200525.0023
            IF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_residence,'NA')) IN ('CONDITIONAL')
            -- ESR Change SAURABH
            AND NVL(:NEW.department,'XX') = 'SICD'
            AND apps.world_check_iface.get_city_tc_status (:NEW.city_of_residence_id) IN
                                              ('TC_VERIFY', 'TC_PROVISIONAL')
            THEN

               IF apps.rmi_ows_common_util.is_authorized_to_approve(:NEW.last_updated_by) = 'N'
                  AND :NEW.expiration_date IS NULL
               THEN

                  :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

                  apps.mt_log_error('Prohibited Country of Residence.');

               END IF;

            END IF;

            -- ESR Change SAURABH
            IF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_residence,'NA')) IN ('CONDITIONAL')
            AND NVL(:NEW.department,'XX') != 'SICD'
            THEN

               IF apps.rmi_ows_common_util.is_authorized_to_approve(:NEW.last_updated_by) = 'N'
                  AND :NEW.expiration_date IS NULL
               THEN

                  :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

                  apps.mt_log_error('Prohibited Country of Residence.');

               END IF;

            END IF;





         END IF;

         IF NVL (:NEW.case_workflow,'XX') != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')
            AND NVL (:OLD.case_workflow,'XX') != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')                  
         THEN

            apps.mt_log_error('Checking Country of Address: '||:NEW.country_of_address);

            IF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_address,'NA')) = ('PROHIBITED') 
            -- ESR Change SAURABH
            OR
            ((NVL(:NEW.department,'XX') != 'SICD') AND (apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_address,'NA')) = 'CONDITIONAL' ))
            THEN

               IF apps.rmi_ows_common_util.is_authorized_to_approve(:NEW.last_updated_by) = 'N'
                  AND :NEW.expiration_date IS NULL
               THEN

                  :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

                  apps.mt_log_error('Prohibited Country of Address.');

               END IF;

            END IF;



         END IF;

         IF NVL (:NEW.case_workflow,'XX') != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')
            AND NVL (:OLD.case_workflow,'XX') != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')                  
         THEN

            apps.mt_log_error('Checking Country of Nationality: '||:NEW.country_of_nationality);

            IF apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_nationality,'NA')) = ('PROHIBITED') 
            -- ESR Change SAURABH
            OR
            ((NVL(:NEW.department,'XX') != 'SICD') AND (apps.rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_nationality,'NA')) = 'CONDITIONAL' ))
            THEN

               IF apps.rmi_ows_common_util.is_authorized_to_approve(:NEW.last_updated_by) = 'N'
                  AND :NEW.expiration_date IS NULL
               THEN

                  :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

                  apps.mt_log_error('Prohibited Country of Nationality.');

               END IF;

            END IF;

         END IF;


         IF NVL (:NEW.case_workflow,'XX') != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')
            AND NVL (:OLD.case_workflow,'XX') != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')                  
         THEN

            apps.mt_log_error('Checking for Crimean Vetting: '||:NEW.city_of_residence_id);

            IF apps.rmi_ows_common_util.is_city_crimean (:NEW.city_of_residence_id) = 'Y'
            THEN

               IF apps.rmi_ows_common_util.is_authorized_to_approve(:NEW.last_updated_by) = 'N'
                  AND :NEW.expiration_date IS NULL
               THEN

                  :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

                  apps.mt_log_error('Vetting is Crimean Vetting');

               END IF;

            END IF;

         END IF;

         IF (:NEW.city_of_residence IS NOT NULL OR :NEW.city_of_residence_id IS NOT NULL)
            AND NVL(:OLD.case_workflow,'XX') != apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review')
            AND :NEW.subdivision_city_of_residence IS NULL
         THEN

            apps.mt_log_error('Inside Subdivision Legal Review');

            BEGIN

               SELECT w.subdivision
                 INTO l_subdivision
                 FROM apps.wc_city_list w,
                      (SELECT iso_alpha2_code, country_code,
                              country_name AS restricted_country
                         FROM apps.sicd_countries) rs
                WHERE w.country_code  = rs.country_code
                  AND w.status        <> 'TC_OK'
                  AND wc_city_list_id = NVL (:NEW.city_of_residence,:NEW.city_of_residence_id);

            EXCEPTION 
               WHEN OTHERS THEN

                  l_subdivision := NULL;

            END;

            :NEW.subdivision_city_of_residence := l_subdivision;

            IF l_subdivision IS NOT NULL
            THEN

               apps.mt_log_error('Subdivision is Crimean...setting to Legal Review');

               :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

            END IF;

         END IF;


         IF NVL (:NEW.case_workflow, 'X') IN ('L', 'SL') AND NVL (:NEW.case_state, 'X') IN ('A', 'C')
         THEN

            apps.mt_log_error('Inside Case State Approval Condition');
            apps.mt_log_error('New Worlflow Status: '||:NEW.case_workflow);
            apps.mt_log_error('Old Worlflow Status: '||:OLD.case_workflow);

            IF apps.rmi_ows_common_util.is_authorized_to_approve(:NEW.last_updated_by) = 'N'
            THEN

               raise_application_error(-20100,'Not authorized approve/close the vetting while under Legal Review');

            END IF;

         END IF;

         IF NVL (:NEW.case_workflow, 'X') = 'A' AND NVL (:OLD.case_workflow,'X') IN ('L', 'SL')
         THEN

            apps.mt_log_error('Inside Case Workflow Approval Condition');
            apps.mt_log_error('New Worlflow Status: '||:NEW.case_workflow);
            apps.mt_log_error('Old Worlflow Status: '||:OLD.case_workflow);

            IF apps.rmi_ows_common_util.is_authorized_to_approve(:NEW.last_updated_by) = 'N'
            THEN

               raise_application_error(-20100,'Not authorized approve/close the vetting while under Legal Review');

            END IF;

         END IF;

         --- End Code Change

         IF NVL (:NEW.case_status, 'X') = 'C' AND NVL (:NEW.case_state, 'X') != 'D'
         THEN

            --- Check to see all the alerts are closed before closing the case

            BEGIN

               IF UPPER (:NEW.PATH) = 'INDIVIDUAL'
               THEN

                  BEGIN

                     SELECT COUNT (1)
                       INTO l_count
                       FROM xwrl_response_ind_columns
                      WHERE request_id = :NEW.ID
                        AND UPPER (x_state) LIKE '%OPEN%';

                  EXCEPTION
                     WHEN OTHERS THEN

                        l_count := 1;

                  END;

                  IF l_count > 0
                  THEN

                     raise_application_error(-20100,'Please close all the alerts before closing the case');

                  END IF;

               ELSIF UPPER (:NEW.PATH) = 'ENTITY'
               THEN

                  BEGIN

                     SELECT COUNT (1)
                       INTO l_count
                       FROM xwrl_response_entity_columns
                      WHERE request_id = :NEW.ID
                        AND UPPER (x_state) LIKE '%OPEN%';

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
         --apps.rmi_ows_common_util.close_ows_case (l_username,:NEW.case_id,:NEW.ID);

         END IF;

         IF NVL (:NEW.case_status, 'X') = 'A'
         THEN

            --- Check to see all the alerts are closed before Approving the case

            BEGIN

               IF UPPER (:NEW.PATH) = 'INDIVIDUAL'
               THEN

                  BEGIN

                     SELECT COUNT (1)
                       INTO l_count
                       FROM xwrl_response_ind_columns
                      WHERE request_id = :NEW.ID
                        AND UPPER (x_state) LIKE '%OPEN%';

                  EXCEPTION
                     WHEN OTHERS THEN

                        l_count := 1;

                  END;

                  IF l_count > 0
                  THEN

                     raise_application_error(-20100,'Please close all the alerts before closing the case');

                  END IF;

               ELSIF UPPER (:NEW.PATH) = 'ENTITY'
               THEN

                  BEGIN

                     SELECT COUNT (1)
                       INTO l_count
                       FROM xwrl_response_entity_columns
                      WHERE request_id = :NEW.ID
                        AND UPPER (x_state) LIKE '%OPEN%';

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

         --SAURABH 28-JAN-2020 T20200123.0022
         IF :NEW.case_workflow = 'PR' AND :NEW.case_workflow <> :OLD.case_workflow
         THEN

            --- Check to see all the alerts are closed before Approving the case

            BEGIN

               IF UPPER (:NEW.PATH) = 'INDIVIDUAL'
               THEN

                  BEGIN

                     SELECT COUNT (1)
                       INTO l_count
                       FROM xwrl_response_ind_columns
                      WHERE request_id = :NEW.ID
                        AND UPPER (x_state) LIKE '%OPEN%'
                        AND legal_review = 'Y';

                  EXCEPTION
                     WHEN OTHERS THEN

                        l_count := 1;

                  END;

                  IF l_count > 0
                  THEN

                     raise_application_error(-20100,'One or more alerts requires Legal Review. Please review all alerts before providing Provisional Approval.');

                  END IF;

               ELSIF UPPER (:NEW.PATH) = 'ENTITY'
               THEN

                  BEGIN

                     SELECT COUNT (1)
                       INTO l_count
                       FROM xwrl_response_entity_columns
                      WHERE request_id = :NEW.ID
                        AND UPPER (x_state) LIKE '%OPEN%'
                        AND legal_review = 'Y';

                  EXCEPTION
                     WHEN OTHERS THEN

                        l_count := 1;

                  END;

                  IF l_count > 0
                  THEN

                     raise_application_error(-20100,'One or more alerts requires Legal Review. Please review all alerts before providing Provisional Approval.');

                  END IF;

               END IF;

            END;

         END IF;

         IF :NEW.case_workflow = 'A'
         THEN

            :NEW.case_status   := 'C';
            :NEW.case_state    := 'A';

         END IF;

         apps.mt_log_error('Case Workflow Status Finally Is: '||:NEW.case_workflow);

      END IF;

   END IF;
--
   exception
   when bypass_trigger then null;

END;

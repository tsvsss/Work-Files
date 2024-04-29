CREATE OR REPLACE TRIGGER XWRL_REQUESTS_INS_UPD
   BEFORE INSERT OR UPDATE
   ON xwrl.xwrl_requests
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   return_code      NUMBER;
   return_message   VARCHAR2 (100);
   v_username       VARCHAR2 (100);
   user_id          NUMBER;
   l_message        VARCHAR2 (200);
BEGIN
   IF     (apps.rmi_ows_common_util.name_in_blocklist (:NEW.ID, l_message) =
                                                                           'Y'
          )
      --
      -- Once Vetting is Rejected do not send further emails
      -- Send Email only when Vetting status is changed to Legal Review
      -- Any other update on vetting will not trigger email
      --
      AND apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow) NOT IN
                                                 ('Legal Review', 'Rejected')
   THEN
      :NEW.case_workflow :=
                 apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');

      BEGIN
         apps.rmi_ows_common_util.send_notice_to_legal (:NEW.ID, l_message);
      EXCEPTION
         WHEN OTHERS
         THEN
            apps.mt_log_error (:NEW.ID || ' SQL ERROR ' || SQLERRM);
      END;
   END IF;

   IF INSERTING
   THEN
      IF     apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow) !=
                                                               'Legal Review'
         AND apps.rmi_ows_common_util.is_city_crimean
                                                    (:NEW.city_of_residence) =
                                                                           'Y'
      THEN
         :NEW.case_workflow :=
                 apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');      
      END IF;
      
      --- Added By Gopi To Check for Sanctioned Countries
      IF rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_residence,'NA')) = 'PROHIBITED'
      THEN
         :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');
      END IF;
      --- End Code Change
   ELSIF UPDATING
   THEN
      --IF     NVL (:NEW.city_of_residence_id, -99) <>  NVL (:OLD.city_of_residence_id,-99)    -- tsuazo 11/06/2019  This column is obsolete
      IF     NVL (:NEW.city_of_residence, -99) <>  NVL (:OLD.city_of_residence,-99)
         AND apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow) != 'Legal Review'
         AND apps.rmi_ows_common_util.is_city_crimean (:NEW.city_of_residence) = 'Y'
      THEN
         :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');
      END IF;
   
     --- Added By Gopi To Check for Sanctioned Countries   
      IF rmi_ows_common_util.case_wf_status (:NEW.case_workflow) != 'Legal Review'
         AND rmi_ows_common_util.get_sanction_status (NVL(:NEW.country_of_residence,'NA')) = 'PROHIBITED'
      THEN
         :NEW.case_workflow := apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');
      END IF;
     --- End Code Change
   END IF;

   IF apps.iri_security.authorize ('WORLD_CHECK_APPROVERS') = 'N'
   THEN

      IF (   apps.world_check_iface.get_sanction_status(:NEW.COUNTRY_OF_RESIDENCE) = 'PROHIBITED'
             AND NVL(:NEW.COUNTRY_OF_RESIDENCE,'Xx') <> NVL(:OLD.COUNTRY_OF_RESIDENCE,'Xx')
             AND apps.rmi_ows_common_util.case_wf_status (:NEW.case_workflow) != 'Legal Review'
         )
      THEN
         :NEW.case_workflow :=
                 apps.rmi_ows_common_util.case_wf_status_dsp ('Legal Review');
      END IF;

   END IF;
--
END;
/

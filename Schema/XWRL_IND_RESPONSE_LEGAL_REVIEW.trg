CREATE OR REPLACE TRIGGER XWRL.xwrl_ind_response_legal_review
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



   BEFORE INSERT OR UPDATE ON xwrl.xwrl_response_ind_columns FOR EACH ROW
DECLARE

l_request_id          NUMBER;
l_category_restricted VARCHAR2(10);
l_sanctioned_country  VARCHAR2(10) := 'N';

BEGIN    
   
   IF INSERTING
   THEN
   
      --- If X_STATE is in PEP - Possible EDD - Possible
      --- update the case to Legal Review

      IF UPPER(:NEW.x_state) IN ('PEP - POSSIBLE', 'EDD - POSSIBLE')
      THEN

         :NEW.legal_review := 'Y';

         apps.rmi_ows_common_util.update_case_workflow(:NEW.request_id);

      END IF;  

      BEGIN

         SELECT 'Y'
           INTO l_category_restricted
           FROM xwrl.xwrl_parameters
          WHERE id                  = 'CASE_RESTRICTIONS'
            AND UPPER(value_string) = UPPER(:NEW.category);

         IF l_category_restricted = 'Y'
         THEN

            :NEW.legal_review := 'Y';

         END IF;

         --- Legal Review Based on Country

         FOR r_country_rec IN (SELECT REGEXP_SUBSTR (REPLACE(:NEW.listcountry,' ',','),'[^,]+',1,ROWNUM) country
                                 FROM dual
                              CONNECT BY LEVEL <= LENGTH (REGEXP_REPLACE (REPLACE(:NEW.listcountry,' ',','), '[^,]+')) + 1)
         LOOP

            IF l_sanctioned_country != 'Y'
            THEN

               IF apps.rmi_ows_common_util.get_sanction_status (NVL(r_country_rec.country,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
               THEN

                  :NEW.legal_review := 'Y';

                  l_sanctioned_country := 'Y';

               END IF;

            END IF;

         END LOOP;

         --- Legal Review Based on Country of Birth

         FOR r_birth_rec IN (SELECT REGEXP_SUBSTR (REPLACE(:NEW.listcountryofbirth,' ',','),'[^,]+',1,ROWNUM) country
                               FROM dual
                            CONNECT BY LEVEL <= LENGTH (REGEXP_REPLACE (REPLACE(:NEW.listcountry,' ',','), '[^,]+')) + 1)
         LOOP

            IF l_sanctioned_country != 'Y'
            THEN

               IF apps.rmi_ows_common_util.get_sanction_status (NVL(r_birth_rec.country,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
               THEN

                  :NEW.legal_review := 'Y';

                  l_sanctioned_country := 'Y';

               END IF;

            END IF;

         END LOOP;

         --- Legal Review Based on Nationality

         FOR r_nationality_rec IN (SELECT REGEXP_SUBSTR (REPLACE(:NEW.listnationality,' ',','),'[^,]+',1,ROWNUM) country
                                     FROM dual
                                  CONNECT BY LEVEL <= LENGTH (REGEXP_REPLACE (REPLACE(:NEW.listnationality,' ',','), '[^,]+')) + 1)
         LOOP

            IF l_sanctioned_country != 'Y'
            THEN

               IF apps.rmi_ows_common_util.get_sanction_status (NVL(r_nationality_rec.country,'NA')) IN ('PROHIBITED', 'CONDITIONAL')
               THEN

                  :NEW.legal_review := 'Y';

                  l_sanctioned_country := 'Y';

               END IF;

            END IF;

         END LOOP;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            l_category_restricted := 'N';
         WHEN TOO_MANY_ROWS THEN
            l_category_restricted := 'Y';

      END;
      
   ELSIF UPDATING
   THEN
    
      IF :NEW.legal_review = 'Y'
      THEN
      
         apps.rmi_ows_common_util.update_case_workflow(:NEW.request_id);
      
      END IF;
            
   END IF;      

EXCEPTION
   WHEN OTHERS THEN    
      raise_application_error(-20100,'Exception occurred while updating alert status to Legal Review: '||SQLERRM);
END;
/

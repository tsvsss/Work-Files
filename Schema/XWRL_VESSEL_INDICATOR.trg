CREATE OR REPLACE TRIGGER XWRL.xwrl_vessel_indicator
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
   
   --- For an ENTITY if vetting for a Vessel then all the matches that have a flag of Vessel Indicator as N should be marked as False Positive
   --- Similarly when vetting for a Non-Vessel if the Vessel Indicator is coming in as Y for matches auto-clear them.

   BEGIN
   
      SELECT vessel_indicator,path
        INTO l_vessel_indicator,l_path
        FROM xwrl.xwrl_requests
       WHERE id = :NEW.request_id;
       
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         
         l_vessel_indicator := NULL;
         l_path             := NULL;

      WHEN TOO_MANY_ROWS THEN
   
         l_vessel_indicator := NULL;
         l_path             := NULL;   
   END;
   
   IF NVL(l_vessel_indicator,'N') = 'N' AND UPPER(l_path) = 'ENTITY'
   THEN
   
      IF UPPER(:NEW.key) = 'DNVESSELINDICATOR' AND UPPER(:NEW.value) = 'Y'
      THEN

         apps.mt_log_error ( :NEW.request_id ||' '||:NEW.rec_row
                             || ' '
                             || UPPER(:NEW.key)
                             || ' '
                             || UPPER(:NEW.value)
                             ||' '
                            );

         apps.rmi_ows_common_util.close_ows_alert(:NEW.last_updated_by, :NEW.request_id, :NEW.rec_row);
          
      END IF;

   ELSIF NVL(l_vessel_indicator,'N') = 'Y' AND UPPER(l_path) = 'ENTITY'
   THEN
   
      IF UPPER(:NEW.key) = 'DNVESSELINDICATOR' AND UPPER(:NEW.value) = 'N'
      THEN

         apps.mt_log_error ( :NEW.request_id ||' '||:NEW.rec_row
                             || ' '
                             || UPPER(:NEW.key)
                             || ' '
                             || UPPER(:NEW.value)
                             ||' '
                            );

         apps.rmi_ows_common_util.close_ows_alert(:NEW.last_updated_by, :NEW.request_id, :NEW.rec_row);
          
      END IF;
   
   END IF;

EXCEPTION
   WHEN OTHERS THEN    
      raise_application_error(-20100,'Exception occurred while clearing vessels: '||SQLERRM);
END;
/
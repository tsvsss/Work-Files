CREATE OR REPLACE TRIGGER XWRL.xwrl_ind_sync_primary_alias
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
* Name                : XWRL_IND_SYNC_PRIMARY_ALIAS                                                                      *
* Script Name         :                                                                                                  *
* Purpose             :                                                                                                  *
*                                                                                                                        *
* Company             : International Registries, Inc.                                                                   *
* Module              : Trade Compliance                                                                                 *
* Created By          : GVELLA                                                                                           *
* Created Date        : 18-NOV-2019                                                                                      *
* Last Reviewed By    : GVELLA                                                                                           *
* Last Reviewed Date  : 18-NOV-2019                                                                                      *
**************************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->     *
* Date        By               Script               By            Date         Type  Details                             *
* ----------- ---------------- -------- --------- --------------- -----------  ----- ----------------------------------  *
* 18-NOV-2019 IRI              1.1                GVELLA          18-NOV-2019  I      Initial                            *
**************************************************************************************************************************/


   AFTER UPDATE ON xwrl.xwrl_response_ind_columns FOR EACH ROW
DECLARE

BEGIN    
   apps.mt_log_error (:NEW.request_id
                          || ' '
                          || :NEW.listid
                          || ' '
                          || 'Inside the trigger'
                         );     

  --- Sync The Primary and Alias when the matches are updated
   apps.rmi_ows_common_util.sync_matches(:NEW.request_id, :NEW.listid, :NEW.x_state, :NEW.last_updated_by);
   
EXCEPTION
   WHEN OTHERS THEN
   
      apps.mt_log_error (:NEW.request_id
                          || ' '
                          || :NEW.listid
                          || ' '
                          || 'API Exception'
                          || ' '
                          || SQLERRM
                         );    
      
      raise_application_error(-20100,'Exception occurred while match synchronization: '||SQLERRM);
END;
/
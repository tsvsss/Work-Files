CREATE OR REPLACE TRIGGER  "XWRL"."XWRL_CATEGORY_RESTRICTION" 

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
* 13-JUL-2020 IRI              1.3                TSUAZO        13-JUL-2020  E      Bypass Trigger Logic          *
********************************************************************************************************************/
AFTER INSERT OR UPDATE ON xwrl.xwrl_response_rows FOR EACH ROW

DECLARE

    l_category_restricted VARCHAR2(10);
	
	bypass_trigger EXCEPTION;
	v_bypass_trigger varchar2(10); 

BEGIN    

	SELECT SYS_CONTEXT('xwrl_ctx', 'disable_trigger') into v_bypass_trigger FROM dual;
	if v_bypass_trigger = 'TRUE' then
	  raise bypass_trigger;
	end if;  

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
         WHEN TOO_MANY_ROWS THEN
            l_category_restricted := 'Y';

      END;

      IF l_category_restricted = 'Y'
      THEN

         UPDATE xwrl.xwrl_requests
            SET case_workflow = 'L',
                category_restriction_indicator = 'Y'
          WHERE id            = :NEW.request_id;

      END IF;

   END IF;

EXCEPTION
	when bypass_trigger then null;
   WHEN OTHERS THEN    
      raise_application_error(-20100,'Exception occurred while setting the vetting status to Legal Review: '||SQLERRM);
END;
/
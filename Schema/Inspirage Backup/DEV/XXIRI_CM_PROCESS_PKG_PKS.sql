CREATE OR REPLACE PACKAGE XXIRI_CM_PROCESS_PKG
    /********************************************************************************************************************
    * Oracle EDQ Watchlist                                                                                              *
    * I --> Initial                                                                                                     *
    * E --> Enhancement                                                                                                 *
    * R --> Requirement                                                                                                 *
    * B --> Bug                                                                                                         *
    ********************************************************************************************************************/
    /*$Header: XXIRI_CM_PROCESS_PKG_PKS.sql 1.1 2019/07/26 12:00:00CST   rrathod (Inspirage) Exp           		      $*/
    /********************************************************************************************************************
    * Type                : PACKAGE                                                                                	    *
    * Name                : XXIRI_CM_PROCESS_PKG                                                                        *
    * Script Name         : XXIRI_CM_PROCESS_PKG_PKS.sql                                                                *
    * Purpose             : This script change state of alert in EDQ watchlist                             			    *
    *                                                                                                                   *
    * Company             : Inspirage LLC                                                                               *
    * Client              : IRI                                                                                         *
    * Created By          : Rajiv Rathod                                                                                *
    * Created Date        : 26-JUL-2019                                                                                 *
    * Last Reviewed By    : Rajiv Rathod                                                                                *
    * Last Reviewed Date  : 26-JUL-2019                                                                                 *
    *********************************************************************************************************************
    * <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
    * Date        By               Script               By            Date     Type  Details                            *
    * ----------- ---------------- -------- --------- --------------- ----------- -----  ------------------------------ *
    * 26-JUL-2019  Inspirage         1.1            Rajiv Rathod    26-JUL-2019   I  Initial version       			*
    * 29-AUG-2019  IRI                     1.3            Tony Suazo       29-AUG-2019 I  Add to ALERT_OUT_REC - Key Label, Old State       			*
    *                                                                                                                   *
    ********************************************************************************************************************/
AS
    /********************************************************************************************************************
    * Type                : Record Type                                                                                 *
    * Name                : ALERT_TBL_IN_TYPE                                                                           *
    * Purpose             : This is record type for input parameter                                    					*
    /*******************************************************************************************************************/
TYPE ALERT_IN_REC
IS
    RECORD
    (
        alert_id   VARCHAR2(100)
        , to_state VARCHAR2(100)
        , comment  VARCHAR2(1000) );
TYPE ALERT_TBL_IN_TYPE
IS
    TABLE OF ALERT_IN_REC INDEX BY BINARY_INTEGER;
    /********************************************************************************************************************
    * Type                : Record Type                                                                                 *
    * Name                : ALERT_TBL_OUT_TYPE                                                                          *
    * Purpose             : This is record type for input parameter                                    					*
    /*******************************************************************************************************************/
TYPE ALERT_OUT_REC
IS
    RECORD
    (
        alert_id  	VARCHAR2(100)
        ,key_label 	VARCHAR(500) -- tsuazo 20190829
        ,old_state 	VARCHAR(100) -- tsuazo 20190829
	, new_state 	VARCHAR(100)
        , status  	VARCHAR2(100)
        , err_msg 	VARCHAR2(1000) );
TYPE ALERT_TBL_OUT_TYPE
IS
    TABLE OF ALERT_OUT_REC INDEX BY BINARY_INTEGER;
	
   /********************************************************************************************************************
    * Type                : Procedure                                                                                   *
    * Name                : update_alerts                                                                               *
    * Purpose             : This is procedure to update the alert status                                    		    *
	*  INBOUND VARIABLES  :  																						    *
		p_user     		  - This should be EDQ user which will update the alert status  							    *
		p_alert_in_tbl    - This should be input table type with alert ID, to state and comment  					    *
    *  OUTBOUND VARIABLES :   																							*
		x_alert_out_tbl   - Output table type with alert new state,status and err message								*
		x_status          - Output variable with overall status with 3 possible values (SUCCESS, WARNING, ERROR)		*
    *********************************************************************************************************************
    * <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
    * Date        By               Script               By            Date     Type  Details                            *
    * ----------- ---------------- -------- --------- --------------- ----------- -----  ------------------------------ *
    * 26-JUL-2019  Inspirage         1.1            Rajiv Rathod    26-JUL-2019   I  Intetial version       			*
    *                                                                                                                   *		
    /*******************************************************************************************************************/
PROCEDURE update_alerts
                       (
                           p_user VARCHAR2
                         , p_alert_in_tbl IN xxiri_cm_process_pkg.alert_tbl_in_type
                         , x_alert_out_tbl OUT xxiri_cm_process_pkg.alert_tbl_out_type
                         , x_status OUT VARCHAR2
                       );
END xxiri_cm_process_pkg;
/
/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: xwrl_req_appv_history_id_seq.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                   $*/
/********************************************************************************************************************
* Object Type         : Scripts                                                                                     *
* Name                :                                                                                             *
* Script Name         : xwrl_req_appv_history_id_seq                                                                *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                      *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    :                                                                                             *
* Last Reviewed Date  :                                                                                             *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO          15-NOV-2019  I      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/

DROP SEQUENCE XWRL.XWRL_REQ_APPV_HISTORY_ID_SEQ;

CREATE SEQUENCE XWRL.XWRL_REQ_APPV_HISTORY_ID_SEQ  START WITH 1000 NOCACHE;
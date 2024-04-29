/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: xwrl_request_approval_history.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                  $*/
/********************************************************************************************************************
* Object Type         : Scripts                                                                                     *
* Name                :                                                                                             *
* Script Name         : xwrl_request_approval_history.sql                                                           *
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

DROP TABLE XWRL.XWRL_REQUEST_APPROVAL_HISTORY CASCADE CONSTRAINTS;

CREATE TABLE XWRL.XWRL_REQUEST_APPROVAL_HISTORY
(
  XWRL_REQ_APPROVAL_HISTORY_ID  NUMBER          NOT NULL,
  ID                            NUMBER,
  STATUS                        VARCHAR2(30 BYTE),
  CREATED_BY                    NUMBER,
  CREATION_DATE                 DATE,
  LAST_UPDATED_BY               NUMBER,
  LAST_UPDATE_DATE              DATE,
  LAST_UPDATE_LOGIN             NUMBER,
  SOURCE_TABLE                  VARCHAR2(50 BYTE),
  SOURCE_ID                     NUMBER
);


CREATE OR REPLACE TRIGGER XWRL.xwrl_request_appvl_hist_ins
   BEFORE INSERT
   ON XWRL.XWRL_REQUEST_APPROVAL_HISTORY    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   tmpvar   NUMBER;
BEGIN
   tmpvar := 0;

   IF :NEW.xwrl_req_approval_history_id IS NULL
   THEN
      SELECT xwrl.xwrl_req_appv_history_id_seq.NEXTVAL
        INTO tmpvar
        FROM DUAL;

      :NEW.xwrl_req_approval_history_id := tmpvar;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE;
END;
/


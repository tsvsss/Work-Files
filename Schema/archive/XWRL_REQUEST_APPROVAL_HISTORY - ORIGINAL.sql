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


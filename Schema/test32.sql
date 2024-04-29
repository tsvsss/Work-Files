
  CREATE OR REPLACE EDITIONABLE TRIGGER "XWRL"."XWRL_REQUEST_APPVL_HIST_INS" 
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
ALTER TRIGGER "XWRL"."XWRL_REQUEST_APPVL_HIST_INS" ENABLE
;

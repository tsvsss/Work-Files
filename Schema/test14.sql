
  CREATE OR REPLACE EDITIONABLE TRIGGER "XWRL"."XWRL_AUDIT_LOG_TRG" BEFORE
   INSERT ON XWRL_AUDIT_LOG
   FOR EACH ROW
BEGIN
   IF (:new.AUDIT_LOG_ID IS NULL) THEN
      :new.AUDIT_LOG_ID := XWRL_AUDIT_LOG_seq.nextval;
   END IF;
END;
/
ALTER TRIGGER "XWRL"."XWRL_AUDIT_LOG_TRG" ENABLE
;
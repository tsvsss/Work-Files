
  CREATE OR REPLACE EDITIONABLE TRIGGER "XWRL"."XWRL_ALERT_CLEARING_XREF_TRG" BEFORE
   INSERT ON xwrl_alert_clearing_xref
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_alert_clearing_xref_seq.nextval;
   END IF;

   :NEW.source_key := :NEW.source_table||:NEW.source_table_column||:NEW.source_id;

END;
/
ALTER TRIGGER "XWRL"."XWRL_ALERT_CLEARING_XREF_TRG" ENABLE
;

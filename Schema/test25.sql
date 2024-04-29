
  CREATE OR REPLACE EDITIONABLE TRIGGER "XWRL"."XWRL_PARTY_MASTER_TRG" BEFORE
   INSERT ON xwrl_party_master
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_party_master_seq.nextval;
   END IF;

   :NEW.source_key := :NEW.source_table||:NEW.source_table_column||:NEW.source_id;
   :NEW.xref_source_key := :NEW.xref_source_table||:NEW.xref_source_table_column||:NEW.xref_source_id;

END;
/
ALTER TRIGGER "XWRL"."XWRL_PARTY_MASTER_TRG" ENABLE
;

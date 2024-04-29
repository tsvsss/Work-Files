
  CREATE OR REPLACE EDITIONABLE TRIGGER "XWRL"."XWRL_RESP_ENTITY_COL_TRG" BEFORE
   INSERT ON xwrl_response_entity_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests5_seq.nextval;
   END IF;
END;
/
ALTER TRIGGER "XWRL"."XWRL_RESP_ENTITY_COL_TRG" ENABLE
;


  CREATE OR REPLACE EDITIONABLE TRIGGER "XWRL"."XWRL_RESP_IND_COL_TRG" BEFORE
   INSERT ON xwrl_response_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests4_seq.nextval;
   END IF;
END;
/
ALTER TRIGGER "XWRL"."XWRL_RESP_IND_COL_TRG" ENABLE
;


  CREATE OR REPLACE EDITIONABLE TRIGGER "XWRL"."XWRL_CASE_NOTES_TRG" BEFORE
   INSERT ON xwrl_case_notes
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_case_notes_seq.nextval;
   END IF;
END;
/
ALTER TRIGGER "XWRL"."XWRL_CASE_NOTES_TRG" ENABLE
;

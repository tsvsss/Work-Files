
  CREATE OR REPLACE EDITIONABLE TRIGGER "XWRL"."XWRL_PARTY_XREF_TRG" BEFORE
   INSERT ON xwrl_party_xref
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_party_xref_seq.nextval;
   END IF;
END;
/
ALTER TRIGGER "XWRL"."XWRL_PARTY_XREF_TRG" ENABLE
;
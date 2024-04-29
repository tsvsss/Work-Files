CREATE OR REPLACE TRIGGER XWRRL.xwrl_requests BEFORE
   INSERT ON xwrl.xwrl_requests
   FOR EACH ROW
BEGIN

   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests_seq.nextval;
   END IF;

END;
/


DECLARE

   CURSOR c1 IS
   SELECT
      c.wc_screening_request_id
      , c.wc_matches_id
      , c.wc_content_id
   --, c.matchentityidentifier
   --, c.matchstatus
   --, x.worldcheck_external_xref_id
      , x.source_table
      , x.source_table_column
      , x.source_table_id
      , substr (c.matchentityidentifier, instr (c.matchentityidentifier, '_', - 1) + 1, length (c.matchentityidentifier)) listid
      , c.notes
   FROM
      wc_content                 c
      , worldcheck_external_xref   x
   WHERE
      c.wc_screening_request_id = x.wc_screening_request_id
   --AND c.wc_screening_request_id = nvl (:wc_screening_request_id, c.wc_screening_request_id)
      AND c.matchstatus = 'NEGATIVE'
      and not exists (  select    ref.wc_screening_request_id
               ,ref. wc_matches_id
               , ref.wc_content_id
               , ref.source_table
               , ref.source_id
         from xwrl_alert_clearing_xref ref
         where ref.wc_screening_request_id =  c.wc_screening_request_id 
         and ref. wc_matches_id =c.wc_matches_id 
          and ref.wc_content_id = c.wc_content_id
          and ref.source_table = x.source_table
      and ref.source_id = x.source_table_id
         group by wc_screening_request_id
               , wc_matches_id
               , wc_content_id
               , source_table
               , source_id)
   ORDER BY
      c.wc_content_id DESC;

BEGIN

   FOR c1rec IN c1 LOOP

      IF c1rec.source_table_id IS NOT NULL THEN

         BEGIN
            INSERT INTO xwrl_alert_clearing_xref (
               wc_screening_request_id
               , wc_matches_id
               , wc_content_id
               , source_table
               , source_id
               , list_id
               , note
               , last_update_date
               , last_updated_by
               , creation_date
               , created_by
               , last_update_login
            ) VALUES (
               c1rec.wc_screening_request_id
               , c1rec.wc_matches_id
               , c1rec.wc_content_id
               , c1rec.source_table
               , c1rec.source_table_id
               , c1rec.listid
               , c1rec.notes
               , SYSDATE
               , - 1
               , SYSDATE
               , - 1
               , 1
            );
         EXCEPTION
            WHEN dup_val_on_index THEN
               NULL;
         END;

         COMMIT;

      END IF;

   END LOOP;

END;
/

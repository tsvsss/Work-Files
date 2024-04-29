DECLARE

   cursor cMaster is
   select xref.source_table,xref. source_table_column,xref. source_table_id, max(xref.wc_screening_request_id) wc_screening_request_id
from WORLDCHECK_EXTERNAL_XREF xref
--where rownum < 10
group by xref.source_table,xref. source_table_column,xref. source_table_id;

   CURSOR cprimary (p_request_id integer) IS
   WITH xref AS (
      SELECT UNIQUE
         wc_screening_request_id
      FROM
         xwrl_party_master
   )
   SELECT   wsr.wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
      , wsr.sex
      , wsr.passport_number
      , wsr.passport_issuing_country_code
      , wsr.citizenship_country_code
      , wsr.residence_country_code
      , wsr.city_name
      , wsr.wc_city_list_id
      , wsr.alias_wc_screening_request_id
      , wsr.created_by
      , wsr.creation_date
      , wsr.last_updated_by
      , wsr.last_update_date
   FROM
      wc_screening_request wsr
      , xref
   WHERE wsr.wc_screening_request_id = p_request_id
      AND wsr.entity_type = 'INDIVIDUAL'
      and wsr.alias_wc_screening_request_id IS NULL
      AND wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      AND xref.wc_screening_request_id IS NULL;

   CURSOR calias (
      p_request_id INTEGER
      ) is
   SELECT  wsr.wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
      , wsr.sex
      , wsr.passport_number
      , wsr.passport_issuing_country_code
      , wsr.citizenship_country_code
      , wsr.residence_country_code
      , wsr.city_name
      , wsr.wc_city_list_id
      , wsr.alias_wc_screening_request_id
      , wsr.created_by
      , wsr.creation_date
      , wsr.last_updated_by
      , wsr.last_update_date
   FROM
      wc_screening_request wsr
   WHERE
      wsr.alias_wc_screening_request_id IS NOT NULL
      AND wsr.entity_type = 'INDIVIDUAL'
      AND wsr.alias_wc_screening_request_id = p_request_id
      --and rownum = 1 
      order by wc_screening_request_id desc
      ;

   CURSOR cxref (
      p_request_id INTEGER
   ) IS
   SELECT
      xref.wc_screening_request_id
      , xref.source_table
      , xref.source_table_column
      , xref.source_table_id
      , xref.created_by
      , xref.creation_date
      , xref.last_updated_by
      , xref.last_update_date
   FROM
      worldcheck_external_xref xref
   WHERE
      xref.wc_screening_request_id = p_request_id
      AND xref.source_table_id IS NOT NULL
   ORDER BY
      xref.worldcheck_external_xref_id DESC;

   v_pass_issuing_country_code    VARCHAR2 (10);
   v_citizenship_country_code     VARCHAR2 (10);
   v_residence_country_code       VARCHAR2 (10);
   v_pass_issuing_country_code1   VARCHAR2 (10);
   v_citizenship_country_code1    VARCHAR2 (10);
   v_residence_country_code1      VARCHAR2 (10);

         v_source_table  VARCHAR2 (100);
         v_source_table_column   VARCHAR2 (100);
         v_source_table_id     integer;

   x_parent_id                    INTEGER;
   
   v_rec_count integer;

   v_count                      INTEGER;

BEGIN

v_rec_count := 0;
v_count := 0 ;

for cMasterRec in cMaster loop

v_rec_count := v_rec_count + 1;

   FOR cprimaryrec IN cprimary(cmasterrec.wc_screening_request_id) LOOP

      x_parent_id := NULL;
      v_pass_issuing_country_code := NULL;
      v_citizenship_country_code := NULL;
      v_residence_country_code := NULL;

      IF cprimaryrec.passport_issuing_country_code IS NOT NULL THEN
         BEGIN
            SELECT
               iso_alpha2_code
            INTO v_pass_issuing_country_code
            FROM
               sicd_countries
            WHERE
               country_code = cprimaryrec.passport_issuing_country_code
               AND iso_alpha2_code IS NOT NULL
               AND status = 'Active';
         EXCEPTION
            WHEN no_data_found THEN
               NULL;
         END;
      END IF;

      IF cprimaryrec.citizenship_country_code IS NOT NULL THEN
         BEGIN
            SELECT
               iso_alpha2_code
            INTO v_citizenship_country_code
            FROM
               sicd_countries
            WHERE
               country_code = cprimaryrec.citizenship_country_code
               AND iso_alpha2_code IS NOT NULL
               AND status = 'Active';
         EXCEPTION
            WHEN no_data_found THEN
               NULL;
         END;
      END IF;

      IF cprimaryrec.residence_country_code IS NOT NULL THEN
         BEGIN
            SELECT
               iso_alpha2_code
            INTO v_residence_country_code
            FROM
               sicd_countries
            WHERE
               country_code = cprimaryrec.residence_country_code
               AND iso_alpha2_code IS NOT NULL
               AND status = 'Active';
         EXCEPTION
            WHEN no_data_found THEN
               NULL;
         END;
      END IF;

      v_count := 0;
      SELECT
         COUNT (*)
      INTO v_count
      FROM
         xwrl_party_master
      WHERE
         full_name = cprimaryrec.name_screened;

      IF v_count = 0 THEN

      v_count := 0;
      SELECT
         COUNT (*)
      INTO v_count
      FROM
         WORLDCHECK_EXTERNAL_XREF
      WHERE
         wc_screening_request_id  =  cprimaryrec.wc_screening_request_id;
         
         
         v_source_table := null;
         v_source_table_column := null;
         v_source_table_id    := null;
         
         if v_count = 1 then
         
         select source_table
         ,source_table_column
         ,source_table_id
         into
                 v_source_table
            ,v_source_table_column
            ,v_source_table_id         
         FROM
         WORLDCHECK_EXTERNAL_XREF
      WHERE
         wc_screening_request_id  =  cprimaryrec.wc_screening_request_id;
         end if;

         INSERT /*+ append */ INTO xwrl_party_master (
            wc_screening_request_id
            , relationship_type
            , entity_type
            , status
            , state
            , source_table
            , source_table_column
            , source_id
            , full_name
            , date_of_birth
            , sex
            , passport_number
            , passport_issuing_country_code
            , citizenship_country_code
            , country_of_residence
            , city_of_residence_id
            , created_by
            , creation_date
            , last_updated_by
            , last_update_date
         ) VALUES (
            cprimaryrec.wc_screening_request_id
            , 'Primary'
            , cprimaryrec.entity_type
            , 'Enabled'
            ,'Migrated'
            , cmasterrec.source_table
            , cmasterrec.source_table_column
            ,  cmasterrec.source_table_id
            , cprimaryrec.name_screened
            , cprimaryrec.date_of_birth
            , cprimaryrec.sex
            , cprimaryrec.passport_number
            , v_pass_issuing_country_code
            , v_citizenship_country_code
            , v_residence_country_code
            , cprimaryrec.wc_city_list_id
            , cprimaryrec.created_by
            , cprimaryrec.creation_date
            , cprimaryrec.last_updated_by
            , cprimaryrec.last_update_date
         ) RETURNING id INTO x_parent_id;

         FOR caliasrec IN calias (cmasterrec.wc_screening_request_id) LOOP

            v_pass_issuing_country_code1 := NULL;
            v_citizenship_country_code1 := NULL;
            v_residence_country_code1 := NULL;

            IF caliasrec.passport_issuing_country_code IS NOT NULL THEN
               BEGIN
                  SELECT
                     iso_alpha2_code
                  INTO v_pass_issuing_country_code1
                  FROM
                     sicd_countries
                  WHERE
                     country_code = caliasrec.passport_issuing_country_code
                     AND iso_alpha2_code IS NOT NULL
                     AND status = 'Active';
               EXCEPTION
                  WHEN no_data_found THEN
                     NULL;
               END;
            END IF;

            IF caliasrec.citizenship_country_code IS NOT NULL THEN
               BEGIN
                  SELECT
                     iso_alpha2_code
                  INTO v_citizenship_country_code1
                  FROM
                     sicd_countries
                  WHERE
                     country_code = caliasrec.citizenship_country_code
                     AND iso_alpha2_code IS NOT NULL
                     AND status = 'Active';
               EXCEPTION
                  WHEN no_data_found THEN
                     NULL;
               END;
            END IF;

            IF caliasrec.residence_country_code IS NOT NULL THEN
               BEGIN
                  SELECT
                     iso_alpha2_code
                  INTO v_residence_country_code1
                  FROM
                     sicd_countries
                  WHERE
                     country_code = caliasrec.residence_country_code
                     AND iso_alpha2_code IS NOT NULL
                     AND status = 'Active';
               EXCEPTION
                  WHEN no_data_found THEN
                     NULL;
               END;
            END IF;

            v_count := 0;
            SELECT
               COUNT (*)
            INTO v_count
            FROM
               xwrl_party_master
            WHERE
               full_name = caliasrec.name_screened;

            IF v_count = 0 THEN

               INSERT /*+ append */ INTO xwrl_party_alias (
                  wc_screening_request_id
                  , relationship_type
                  , entity_type
                  , status
                  ,state
                  --, source_table
                  --, source_table_column
                  --, source_id
                  , full_name
                  , date_of_birth
                  , sex
                  , passport_number
                  , passport_issuing_country_code
                  , citizenship_country_code
                  , country_of_residence
                  , city_of_residence_id
                  , created_by
                  , creation_date
                  , last_updated_by
                  , last_update_date
                  , master_id
               ) VALUES (
                  caliasrec.wc_screening_request_id
                  , 'Alias'
                  , caliasrec.entity_type
                  , 'Enabled'
                  ,'Migrated'
            --, cmasterrec.source_table
            --, cmasterrec.source_table_column
            --,  cmasterrec.source_table_id                  
                  --, 'WC_SCREENING_REQUEST'
                  --, 'WC_SCREENING_REQUEST_ID'
                  --, caliasrec.wc_screening_request_id
                  , caliasrec.name_screened
                  , caliasrec.date_of_birth
                  , caliasrec.sex
                  , caliasrec.passport_number
                  , v_pass_issuing_country_code1
                  , v_citizenship_country_code1
                  , v_residence_country_code1
                  , caliasrec.wc_city_list_id
                  , caliasrec.created_by
                  , caliasrec.creation_date
                  , caliasrec.last_updated_by
                  , caliasrec.last_update_date
                  , x_parent_id
               );

            END IF;

         END LOOP;

      END IF;

   END LOOP;

   if v_rec_count = 1000 then
      commit;
      v_rec_count := 0;
      end if;

end loop;

commit;

END;
/
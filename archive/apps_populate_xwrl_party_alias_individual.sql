DECLARE

   CURSOR cprimary IS
   WITH xref AS (
      SELECT UNIQUE
         wc_screening_request_id
      FROM
         xwrl_party_master
   )
   SELECT UNIQUE
      wsr.wc_screening_request_id
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
   WHERE
      wsr.alias_wc_screening_request_id IS NULL
      AND wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      AND xref.wc_screening_request_id IS NULL
      AND wsr.entity_type = 'INDIVIDUAL'
      AND wsr.alias_wc_screening_request_id IS NULL
   ORDER BY
      wc_screening_request_id DESC;

   CURSOR calias (
      p_request_id INTEGER
   ) IS
   SELECT UNIQUE
      wsr.wc_screening_request_id
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
      AND wsr.alias_wc_screening_request_id = p_request_id;

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
      xref.worldcheck_external_xref_id;

   v_pass_issuing_country_code    VARCHAR2 (10);
   v_citizenship_country_code     VARCHAR2 (10);
   v_residence_country_code       VARCHAR2 (10);
   v_pass_issuing_country_code1   VARCHAR2 (10);
   v_citizenship_country_code1    VARCHAR2 (10);
   v_residence_country_code1      VARCHAR2 (10);

   x_parent_id                    INTEGER;

   v_count                        INTEGER;

BEGIN
   dbms_output.put_line ('Start');
   FOR cprimaryrec IN cprimary LOOP

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

      FOR cxrefrec IN cxref (cprimaryrec.wc_screening_request_id) LOOP

         INSERT /*+ append */ INTO xwrl_party_alias (
            wc_screening_request_id
            , relationship_type
            , entity_type
            , status
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
            , cxrefrec.source_table
            , cxrefrec.source_table_column
            , cxrefrec.source_table_id
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

         COMMIT;

      END LOOP;

      FOR caliasrec IN calias (cprimaryrec.wc_screening_request_id) LOOP

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

         BEGIN

            INSERT /*+ append */ INTO xwrl_party_alias (
               wc_screening_request_id
               , relationship_type
               , entity_type
               , status
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
               , master_id
            ) VALUES (
               caliasrec.wc_screening_request_id
               , 'Alias'
               , caliasrec.entity_type
               , 'Enabled'
         --, 'WC_SCREENING_REQUEST'
         --, 'WC_SCREENING_REQUEST_ID'
               , 'XWRL_PARTY_ALIAS'
               , 'ID'
               , caliasrec.wc_screening_request_id
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
         EXCEPTION
            WHEN dup_val_on_index THEN
               NULL;
         END;
         COMMIT;

      END LOOP;

   END LOOP;

   dbms_output.put_line ('End');

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;

END;
/
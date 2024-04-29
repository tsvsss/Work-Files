DECLARE
   CURSOR cprimary IS
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
      wsr.entity_type = 'INDIVIDUAL'
      and wsr.alias_wc_screening_request_id is null
      ;

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
      wsr.entity_type = 'INDIVIDUAL'
      AND wsr.alias_wc_screening_request_id = p_request_id;

   v_pass_issuing_country_code    VARCHAR2 (10);
   v_citizenship_country_code     VARCHAR2 (10);
   v_residence_country_code       VARCHAR2 (10);
   v_pass_issuing_country_code1   VARCHAR2 (10);
   v_citizenship_country_code1    VARCHAR2 (10);
   v_residence_country_code1      VARCHAR2 (10);

   x_parent_id                    INTEGER;

BEGIN
   dbms_output.put_line ('Start');
   FOR cprimaryrec IN cprimary LOOP
   
      x_parent_id := null;
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
               and iso_alpha2_code is not null
               and STATUS = 'Active';
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
               and iso_alpha2_code is not null
               and STATUS = 'Active';
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
               and iso_alpha2_code is not null
               and STATUS = 'Active';
         EXCEPTION
            WHEN no_data_found THEN
               NULL;
         END;
      END IF;

      INSERT INTO xwrl_party_alias (
         relationship_type
         , entity_type
         , status
         , source_table
         , source_table_column
         , source_id
         , full_name
         , date_of_birth
         ,sex
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
         'Primary'
         , cprimaryrec.entity_type
         , 'Enabled'
         , 'WC_SCREENING_REQUEST'
         , 'WC_SCREENING_REQUEST_ID'
         , cprimaryrec.wc_screening_request_id
         , cprimaryrec.name_screened
         , cprimaryrec.date_of_birth
         , cprimaryrec.sex
         , cprimaryrec.passport_number
         ,v_pass_issuing_country_code
         ,v_citizenship_country_code
         ,v_residence_country_code
         , cprimaryrec.wc_city_list_id
         , cprimaryrec.created_by
         , cprimaryrec.creation_date
         , cprimaryrec.last_updated_by
         , cprimaryrec.last_update_date
      ) RETURNING id INTO x_parent_id;
      
      commit;

      FOR caliasrec IN calias ( cprimaryrec.wc_screening_request_id) LOOP

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
                  and iso_alpha2_code is not null
                  and STATUS = 'Active';
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
                  and iso_alpha2_code is not null
                  and STATUS = 'Active';
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
                  and iso_alpha2_code is not null
                  and STATUS = 'Active';
            EXCEPTION
               WHEN no_data_found THEN
                  NULL;
            END;
         END IF;

 INSERT INTO xwrl_party_alias (
         relationship_type
         , entity_type
         , status
         , source_table
         , source_table_column
         , source_id
         , full_name
         , date_of_birth
         ,sex
         , passport_number
         , passport_issuing_country_code
         , citizenship_country_code
         , country_of_residence
         , city_of_residence_id
         , created_by
         , creation_date
         , last_updated_by
         , last_update_date
         , parent_id
      ) VALUES (
         'Alias'
         , caliasrec.entity_type
         , 'Enabled'
         , 'WC_SCREENING_REQUEST'
         , 'WC_SCREENING_REQUEST_ID'
         , caliasrec.wc_screening_request_id
         , caliasrec.name_screened
         , caliasrec.date_of_birth
         , caliasrec.sex
         , caliasrec.passport_number
         ,v_pass_issuing_country_code1
         ,v_citizenship_country_code1
         ,v_residence_country_code1
         , caliasrec.wc_city_list_id
         , caliasrec.created_by
         , caliasrec.creation_date
         , caliasrec.last_updated_by
         , caliasrec.last_update_date
            , x_parent_id
         );
         
         commit;

      END LOOP ;

   END LOOP;

   dbms_output.put_line ('End');

exception
when others then rollback;

END;
/
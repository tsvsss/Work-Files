/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_populate_xwrl_party_master_entity.sql 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Scripts                                                                                     *
* Name                :                                                                                             *
* Script Name         : apps_populate_xwrl_party_master_entity.sql                                                  *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                      *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    :                                                                                             *
* Last Reviewed Date  :                                                                                             *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO          15-NOV-2019  I      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/

DECLARE

   CURSOR cmaster IS
   select a.unique_key,  a.source_table, a.source_table_column, a.source_table_id
   from 
   (
        SELECT   extxref.source_table||extxref.source_table_column||extxref.source_table_id unique_key, extxref.source_table, extxref.source_table_column,extxref.source_table_id
         FROM   worldcheck_external_xref extxref
         WHERE trunc(creation_date) >= sysdate - 60
         GROUP BY extxref.source_table||extxref.source_table_column||extxref.source_table_id,  extxref.source_table, extxref.source_table_column,extxref.source_table_id
         ) a
         ,(
         SELECT    mst.source_key unique_key
         FROM xwrl_party_master mst
         GROUP BY mst.source_key
         )   b
   where a.unique_key = b.unique_key (+)
   and b.unique_key is null;

   CURSOR cprimary (
      p_source_table          VARCHAR2
      , p_source_table_column   VARCHAR2
      , p_source_table_id       INTEGER
   ) IS
   WITH xref AS (
      SELECT source_key
      FROM
         xwrl_party_master
   )
   SELECT
      wsr.wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , DECODE (wsr.entity_type, 'VESSEL', 'Y', NULL) vessel_indicator
      , wsr.corp_residence_country_code
      , wsr.city_name
      , wsr.wc_city_list_id
      , wsr.imo_number
      , wsr.alias_wc_screening_request_id
      , wsr.created_by
      , wsr.creation_date
      , wsr.last_updated_by
      , wsr.last_update_date
   FROM
      wc_screening_request       wsr
      , worldcheck_external_xref   extxref
      , xref
   WHERE
      wsr.wc_screening_request_id = extxref.wc_screening_request_id
      AND wsr.entity_type <> 'INDIVIDUAL'
      AND extxref.source_table = p_source_table
      AND extxref.source_table_column = p_source_table_column
      AND extxref.source_table_id = p_source_table_id
      AND wsr.alias_wc_screening_request_id IS NULL  -- Get Master 
       AND extxref.source_table||extxref.source_table_column||extxref.source_table_id = xref.source_key (+)
      AND xref.source_key IS NULL;

   CURSOR calias (
      p_request_id            INTEGER
      , p_source_table          VARCHAR2
      , p_source_table_column   VARCHAR2
      , p_source_table_id       INTEGER
   ) IS
   WITH xref AS (
      SELECT UNIQUE
         wc_screening_request_id
      FROM
         xwrl_party_alias
   )
   SELECT
      wsr.wc_screening_request_id
      , wsr.name_screened
      , wsr.entity_type
      , DECODE (wsr.entity_type, 'VESSEL', 'Y', NULL) vessel_indicator
      , wsr.corp_residence_country_code
      , wsr.city_name
      , wsr.wc_city_list_id
      , wsr.imo_number
      , wsr.alias_wc_screening_request_id
      , wsr.created_by
      , wsr.creation_date
      , wsr.last_updated_by
      , wsr.last_update_date
   FROM
      wc_screening_request       wsr
      , worldcheck_external_xref   extxref
      , xref
   WHERE
      wsr.wc_screening_request_id = extxref.wc_screening_request_id
      AND wsr.entity_type <> 'INDIVIDUAL'
      AND extxref.source_table = p_source_table
      AND extxref.source_table_column = p_source_table_column
      AND extxref.source_table_id = p_source_table_id
      AND wsr.alias_wc_screening_request_id  =  p_request_id -- Get Alias
      AND wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      AND xref.wc_screening_request_id IS NULL;
      --AND extxref.source_table||extxref.source_table_column||extxref.source_table_id = xref.source_key (+)
      --AND xref.source_key IS NULL;

   x_parent_id   INTEGER;
   v_count       INTEGER;

BEGIN

   v_count := 0;

   FOR cmasterrec IN cmaster LOOP  --  Unique Source

      v_count := v_count + 1;

      FOR cprimaryrec IN cprimary (cmasterrec.source_table, cmasterrec.source_table_column, cmasterrec.source_table_id) LOOP -- Master

         x_parent_id := NULL;

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
            , imo_number
            , vessel_indicator
            , country_of_residence
            , city_of_residence_id
            , start_date
            , created_by
            , creation_date
            , last_updated_by
            , last_update_date
         ) VALUES (
            cprimaryrec.wc_screening_request_id
            , 'Primary'
            , cprimaryrec.entity_type
            , 'Enabled'
            , 'Migrated'
            , cmasterrec.source_table
            , cmasterrec.source_table_column
            , cmasterrec.source_table_id
            , cprimaryrec.name_screened
            , cprimaryrec.imo_number
            , cprimaryrec.vessel_indicator
            , cprimaryrec.corp_residence_country_code
            , cprimaryrec.wc_city_list_id
            , cprimaryrec.creation_date
            , cprimaryrec.created_by
            , cprimaryrec.creation_date
            , cprimaryrec.last_updated_by
            , cprimaryrec.last_update_date
         ) RETURNING id INTO x_parent_id;

         FOR caliasrec IN calias (cprimaryrec.wc_screening_request_id, cmasterrec.source_table, cmasterrec.source_table_column, cmasterrec.source_table_id) LOOP -- Alias

          INSERT /*+ append */ INTO xwrl_party_alias (
            wc_screening_request_id
            , relationship_type
            , entity_type
            , status
            , state
               --, source_table
               --, source_table_column
               --, source_id
            , full_name
            , imo_number
            , vessel_indicator
            , country_of_residence
            , city_of_residence_id
            , start_date
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
            , 'Migrated'
               --, cmasterrec.source_table
               --, cmasterrec.source_table_column
               --, cmasterrec.source_table_id                  
                  --, 'WC_SCREENING_REQUEST'
                  --, 'WC_SCREENING_REQUEST_ID'
                  --, caliasrec.wc_screening_request_id
            , caliasrec.name_screened
            , caliasrec.imo_number
            , caliasrec.vessel_indicator
            , caliasrec.corp_residence_country_code
            , caliasrec.wc_city_list_id
            , caliasrec.creation_date
            , caliasrec.created_by
            , caliasrec.creation_date
            , caliasrec.last_updated_by
            , caliasrec.last_update_date
            , x_parent_id
         );

         END LOOP; -- end alias

      END LOOP; -- end master

      IF v_count = 1000 THEN
         COMMIT;
         v_count := 0;
      END IF;

   END LOOP;  -- end unique source

   COMMIT;
END;
/
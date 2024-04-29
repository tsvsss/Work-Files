/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_populate_xwrl_clearing_xref.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                               $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : apps_populate_xwrl_clearing_xref.sql                                                        *
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

   CURSOR crequest IS
with xref as (select unique wc_screening_request_id from xwrl_alert_clearing_xref)
   SELECT  UNIQUE
      wsr.wc_screening_request_id
   FROM
      wc_screening_request wsr
      ,xref
      where wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
      and trunc(creation_date) >= sysdate - 7
      and xref.wc_screening_request_id is null;

   CURSOR cxref (
      p_request_id INTEGER
   ) IS
   SELECT
      extref.wc_screening_request_id
      , extref.source_table
      , extref.source_table_column
      , extref.source_table_id
      , extref.created_by
      , extref.creation_date
      , extref.last_updated_by
      , extref.last_update_date
   FROM
      worldcheck_external_xref extref
   WHERE
      extref.wc_screening_request_id = p_request_id
      AND extref.source_table_id IS NOT NULL
      and trunc(creation_date) >= sysdate - 60
   ORDER BY
      extref.worldcheck_external_xref_id;

   CURSOR ccontent (
      p_request_id INTEGER
   ) IS
   SELECT
      c.wc_screening_request_id
      , c.wc_matches_id
      , c.wc_content_id
      , substr (c.matchentityidentifier, instr (c.matchentityidentifier, '_', - 1) + 1, length (c.matchentityidentifier)) listid
      , c.notes
      , c.created_by
      , c.creation_date
      , c.last_updated_by
      , c.last_update_date
      ,c.last_update_login
   FROM
      wc_content c
   WHERE
      c.notes IS NOT NULL
      AND c.wc_screening_request_id = p_request_id
   ORDER BY
      wc_content_id;

v_count  integer;

BEGIN

   FOR crequestrec IN crequest LOOP
   
   v_count := 0;

      FOR cxrefrec IN cxref (crequestrec.wc_screening_request_id) LOOP

         FOR ccontentrec IN ccontent (crequestrec.wc_screening_request_id) LOOP

            BEGIN
               insert /*+ append */ into xwrl_alert_clearing_xref (
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
                  ccontentrec.wc_screening_request_id
                  , ccontentrec.wc_matches_id
                  , ccontentrec.wc_content_id
                  , cxrefrec.source_table
                  , cxrefrec.source_table_id
                  , ccontentrec.listid
                  , ccontentrec.notes
                  , ccontentrec.last_update_date
                  ,ccontentrec.last_updated_by
                  , ccontentrec.creation_date
                  ,ccontentrec.created_by
                  ,ccontentrec.last_update_login
               );
            EXCEPTION
               WHEN dup_val_on_index THEN
                  NULL;
            END;
            
            v_count := v_count + 1;

            IF v_count = 1000 THEN
               COMMIT;
            END IF;

         END LOOP;

      END LOOP;

   END LOOP;

commit;

END;
/
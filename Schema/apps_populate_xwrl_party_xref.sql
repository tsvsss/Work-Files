/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_populate_xwrl_party_xref.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                  $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : apps_populate_xwrl_party_xref.sql                                                           *
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

   cursor cMain is
   select 'ORGANISATION' relationship1,'INDIVIDUAL' relationship2 from dual
   union
   select 'ORGANISATION','VESSEL' from dual
   union
   select 'ORGANISATION','ORGANISATION' from dual
   union
   select 'INDIVIDUAL','INDIVIDUAL' from dual
   union
   select 'INDIVIDUAL','VESSEL' from dual
   union
   select 'INDIVIDUAL','ORGANISATION' from dual
   union
   select 'VESSEL','INDIVIDUAL' from dual
   union
   select 'VESSEL','VESSEL' from dual
   union
   select 'VESSEL','ORGANISATION' from dual
   ;
   
   CURSOR c1 (
      p_relationship1 VARCHAR2      
   ) IS
   SELECT mst.source_key
   ,mst.id
      FROM
      xwrl_party_master mst
   WHERE
      mst.relationship_type = 'Primary'
      AND mst.entity_type = p_relationship1
      AND state = 'Verified';

   CURSOR c2 (
      p_source_key          VARCHAR2
      , p_relationship2 VARCHAR2
   ) IS
   SELECT mst.id
                     , mst.created_by
                  , mst.creation_date
                  , mst.last_updated_by
                  , mst.last_update_date
   FROM
      xwrl_party_master mst
   WHERE
      mst.entity_type = p_relationship2
      AND mst.state IN (
         'Verified'
         , 'Migrated'
      )
      AND mst.source_key = p_source_key;
   
   v_count               INTEGER;
   v_rec_count               INTEGER;

      
--  'ORGANISATION'
-- 'INDIVIDUAL'
-- 'VESSEL'

   v_relationship1       VARCHAR2 (100);
   v_relationship2       VARCHAR2 (100);
   v_relationship_type   VARCHAR2 (100);

BEGIN

for cMainRec in cMain loop

   v_count := 0;

   v_relationship1 := cMainRec.relationship1;
   v_relationship2 := cMainRec.relationship2;
   v_relationship_type := v_relationship1 || ' to ' || v_relationship2;

   FOR c1rec IN c1 (v_relationship1) LOOP 
   
         FOR c2rec IN c2 (c1rec.source_key, v_relationship2) LOOP

            v_rec_count := 0;
      
            SELECT
               COUNT (*)
            INTO v_rec_count
            FROM
               xwrl_party_xref mst
            WHERE
               mst.master_id = c1rec.id
               AND mst.relationship_master_id = c2rec.id;
      
            IF v_rec_count = 0 THEN
            
               v_count := v_count + 1;
      
               INSERT INTO xwrl_party_xref (
                  master_id
                  , relationship_master_id
                  , state
                  , status
                  , relationship_type
                  , start_date
                  , created_by
                  , creation_date
                  , last_updated_by
                  , last_update_date
               ) VALUES (
                  c1rec.id
                  , c2rec.id
                  , 'Migrated'
                  , 'Enabled'
                  , v_relationship_type
                  , c2rec.creation_date
                  , c2rec.created_by
                  , c2rec.creation_date
                  , c2rec.last_updated_by
                  , c2rec.last_update_date
               );
      
            END IF;
      
            IF v_count = 1000 THEN
               COMMIT;
            END IF;
      
         END LOOP; -- end c2

   END LOOP; -- end c1

END LOOP; -- 

   COMMIT;  

END;
/
-- XWRL

DROP TYPE xwrl.xwrl_alert_tbl_in_type;

DROP TYPE xwrl.xwrl_alert_in_rec;

DROP TYPE xwrl.xwrl_alert_tbl_out_type;

DROP TYPE xwrl.xwrl_alert_out_rec;

CREATE OR REPLACE TYPE xwrl.xwrl_alert_in_rec AS OBJECT (
   p_alert_id   VARCHAR2 (100)
   , p_to_state   VARCHAR2 (100)
   , p_comment    VARCHAR2 (1000)
);
/

CREATE OR REPLACE TYPE xwrl.xwrl_alert_tbl_in_type AS
   TABLE OF xwrl.xwrl_alert_in_rec;
/

CREATE OR REPLACE TYPE xwrl.xwrl_alert_out_rec IS OBJECT (
   alert_id    VARCHAR2 (100)
   , key_label   VARCHAR2 (500)
   , old_state   VARCHAR (100)
   , new_state   VARCHAR (100)
   , status      VARCHAR2 (100)
   , err_msg     VARCHAR2 (1000)
);
/

CREATE OR REPLACE TYPE xwrl.xwrl_alert_tbl_out_type IS
   TABLE OF xwrl.xwrl_alert_out_rec;
/


DROP SEQUENCE xwrl.xwrl_alert_clearing_xref_seq;
DROP TABLE xwrl.xwrl_alert_clearing_xref;

CREATE TABLE xwrl_alert_clearing_xref (
   id                        INTEGER NOT NULL
   , request_id                INTEGER
   , case_key                  VARCHAR2 (50)
   , alert_id                  VARCHAR2 (50)
   , wc_screening_request_id   NUMBER
   , wc_matches_id             NUMBER
   , wc_content_id             NUMBER
   , source_table              VARCHAR2 (50) NOT NULL
   ,source_table_column       VARCHAR2(50)   
   , source_id                 NUMBER NOT NULL
   , list_id                   INTEGER NOT NULL
   , from_state                VARCHAR2 (100)
   , to_state                  VARCHAR2 (100)
   , status                    VARCHAR2 (100)
   , error_message             VARCHAR2 (1000)
   , note                      VARCHAR2 (4000)
   , last_update_date          DATE
   , last_updated_by           NUMBER (15)
   , creation_date             DATE
   , created_by                NUMBER (15)
   , last_update_login         NUMBER (15)
);


ALTER TABLE xwrl.xwrl_alert_clearing_xref ADD CONSTRAINT xwrl_alert_clearing_xref_pk PRIMARY KEY (id);

ALTER TABLE xwrl.xwrl_alert_clearing_xref
    ADD CONSTRAINT xwrl_alert_clearing_xref_idx1 UNIQUE ( source_table,
    source_id,
    list_id );



CREATE SEQUENCE xwrl.xwrl_alert_clearing_xref_seq START WITH 1000 NOCACHE;


/* TRIGGER */

CREATE OR REPLACE TRIGGER xwrl.xwrl_alert_clearing_xref_trg BEFORE
   INSERT ON xwrl.xwrl_alert_clearing_xref
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl.xwrl_alert_clearing_xref_seq.nextval;
   END IF;
END;
/

GRANT ALL ON xwrl.xwrl_alert_in_rec TO apps;

GRANT ALL ON xwrl.xwrl_alert_tbl_in_type TO apps;

GRANT ALL ON xwrl.xwrl_alert_out_rec TO apps;

GRANT ALL ON xwrl.xwrl_alert_tbl_out_type TO apps;

GRANT ALL ON xwrl.xwrl_alert_clearing_xref TO apps;

GRANT ALL ON xwrl.xwrl_alert_clearing_xref_seq TO apps;


-- APPS

DROP SYNONYM apps.xwrl_alert_in_rec;

DROP SYNONYM apps.xwrl_alert_tbl_in_type;

DROP SYNONYM apps.xwrl_alert_out_rec;

DROP SYNONYM apps.xwrl_alert_tbl_out_type;

DROP SYNONYM apps.xwrl_alert_clearing_xref_seq;

DROP SYNONYM apps.xwrl_alert_clearing_xref;

CREATE SYNONYM apps.xwrl_alert_in_rec FOR xwrl.xwrl_alert_in_rec;

CREATE SYNONYM apps.xwrl_alert_tbl_in_type FOR xwrl.xwrl_alert_tbl_in_type;

CREATE SYNONYM apps.xwrl_alert_out_rec FOR xwrl.xwrl_alert_out_rec;

CREATE SYNONYM apps.xwrl_alert_tbl_out_type FOR xwrl.xwrl_alert_tbl_out_type;

CREATE SYNONYM apps.xwrl_alert_clearing_xref_seq FOR xwrl.xwrl_alert_clearing_xref_seq;

CREATE SYNONYM apps.xwrl_alert_clearing_xref FOR xwrl.xwrl_alert_clearing_xref;


-- TEMPORARY

DROP TABLE tmp_xwrl_alerts;

CREATE TABLE tmp_xwrl_alerts (
   p_user       VARCHAR2 (30)
   , p_alert_id   VARCHAR2 (100)
   , p_to_state   VARCHAR2 (100)
   , p_comment    VARCHAR2 (1000)
);

DROP TABLE tmp_xwrl_alert_results;

CREATE TABLE tmp_xwrl_alert_results (
   p_request_id   INTEGER
   , p_case_key     VARCHAR2 (100)
   , p_alert_id     VARCHAR2 (100)
   , p_list_id      INTEGER
   , p_key_label    VARCHAR2 (500)
   , p_old_state    VARCHAR (100)
   , p_new_state    VARCHAR (100)
   , p_status       VARCHAR2 (100)
   , p_err_msg      VARCHAR2 (4000)
);

-- APPS

CREATE OR REPLACE PACKAGE apps.xwrl_ows_utils AS

   TYPE alert_in_rec IS RECORD (
      p_alert_id VARCHAR2 (100)
      , p_to_state VARCHAR2 (100)
      , p_comment VARCHAR2 (1000)
   );
   TYPE alert_tbl_in_type IS
      TABLE OF alert_in_rec INDEX BY BINARY_INTEGER;


   /* Note: This procedure is called from the ADF application*/
   PROCEDURE process_alerts (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
      , p_alert_tab    IN             xwrl_alert_tbl_in_type
   );


   /* Note: This procedure is called from PL/SQL (auto_clear_individuals)
                  Needed to overload the procedure and keep synchronized
                   Unable to initialize the xwrl_alert_tbl_in_type
                   Substitution is alert_tbl_in_type
   */
   PROCEDURE process_alerts (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
      , p_alert_tab    IN             alert_tbl_in_type
   );

   PROCEDURE auto_clear_individuals (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
   );

   PROCEDURE auto_clear_entities (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
   );

END xwrl_ows_utils;
/

CREATE OR REPLACE PACKAGE BODY apps.xwrl_ows_utils AS

   PROCEDURE process_alerts (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
      , p_alert_tab    IN             xwrl_alert_tbl_in_type
   ) IS

      l_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
      l_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;
      x_status          VARCHAR2 (1000);
      v_key_label       VARCHAR2 (500);
      v_case_key        VARCHAR2 (500);
      v_list_id         INTEGER;
      v_source_table    VARCHAR2 (50);
      v_source_id       INTEGER;
      v_path            VARCHAR2 (50);
      v_note            VARCHAR2 (4000);
      v_line_number     NUMBER;
      v_user varchar2(100);

   BEGIN
   
      IF p_user_id IS NOT NULL THEN
         SELECT user_name into v_user from fnd_user where user_id = p_user_id;
      END IF;

     -- Process inbound table from ADF
      FOR i IN p_alert_tab.first..p_alert_tab.last LOOP
         l_alert_in_tbl (i).alert_id := p_alert_tab (i).p_alert_id;
         l_alert_in_tbl (i).to_state := p_alert_tab (i).p_to_state;
         l_alert_in_tbl (i).comment := p_alert_tab (i).p_comment;
         v_note := p_alert_tab (i).p_comment; -- Note: they will all have the same comment
      END LOOP;

      /* For debugging purposes

      FOR i IN l_alert_in_tbl.first..l_alert_in_tbl.last LOOP

         dbms_output.put_line ('Alert - alert_id: ' || l_alert_in_tbl (i).alert_id);
         dbms_output.put_line ('Alert - to_state: ' || l_alert_in_tbl (i).to_state);
         dbms_output.put_line ('Alert - comment: ' || l_alert_in_tbl (i).comment);

         INSERT INTO tmp_xwrl_alerts (
            p_user
            , p_alert_id
            , p_to_state
            , p_comment
         ) VALUES (
            p_user
            , l_alert_in_tbl (i).alert_id
            , l_alert_in_tbl (i).to_state
            , l_alert_in_tbl (i).comment
         );

      END LOOP;

      */

      -- Execute OWS procedure
      xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com (p_user => v_user, p_alert_in_tbl => l_alert_in_tbl, x_alert_out_tbl => l_alert_out_tbl, x_status => x_status);

         dbms_output.put_line ('Alert - X_STATUS: ' || x_status);

     -- Process outbound table from OWS
      FOR i IN l_alert_out_tbl.first..l_alert_out_tbl.last LOOP

         dbms_output.put_line ('Alert - alert_id: ' || l_alert_out_tbl (i).alert_id);
         dbms_output.put_line ('Alert - key_label: ' || l_alert_out_tbl (i).key_label);
         dbms_output.put_line ('Alert - old_state: ' || l_alert_out_tbl (i).old_state);
         dbms_output.put_line ('Alert - new_state: ' || l_alert_out_tbl (i).new_state);
         dbms_output.put_line ('Alert - status: ' || l_alert_out_tbl (i).status);
         dbms_output.put_line ('Alert - err_msg: ' || l_alert_out_tbl (i).err_msg);

         v_key_label := l_alert_out_tbl (i).key_label;

         SELECT
            substr (v_key_label, 1, instr (v_key_label, ':', 1) - 1)
         INTO v_case_key
         FROM
            dual;

         SELECT
            to_number (substr (v_key_label, instr (v_key_label, ':', - 1) + 1, length (v_key_label)))
         INTO v_list_id
         FROM
            dual;

         SELECT
            source_table
            , source_id
            , path
         INTO
            v_source_table
         , v_source_id
         , v_path
         FROM
            xwrl.xwrl_requests
         WHERE
            id = p_request_id;

         /* For debugging purposes  */

         INSERT INTO tmp_xwrl_alert_results (
            p_request_id
            , p_case_key
            , p_alert_id
            , p_list_id
            , p_key_label
            , p_old_state
            , p_new_state
            , p_status
            , p_err_msg
         ) VALUES (
            p_request_id
            , v_case_key
            , l_alert_out_tbl (i).alert_id
            , v_list_id
            , l_alert_out_tbl (i).key_label
            , l_alert_out_tbl (i).old_state
            , l_alert_out_tbl (i).new_state
            , l_alert_out_tbl (i).status
            , l_alert_out_tbl (i).err_msg
         );
         
        

         IF (l_alert_out_tbl (i).status = 'SUCCESS') THEN

            BEGIN
               SELECT
                  nvl (MAX (line_number), 0) + 10 line_number
               INTO v_line_number
               FROM
                  xwrl_alert_notes
               WHERE
                  alert_id = l_alert_out_tbl (i).alert_id;
            EXCEPTION
               WHEN no_data_found THEN
                  v_line_number := 10;
            END;

            INSERT INTO xwrl_alert_notes (
               request_id
               , alert_id
               , line_number
               , note
               , last_update_date
               , last_updated_by
               , creation_date
               , created_by
               , last_update_login
            ) VALUES (
               p_request_id
               , l_alert_out_tbl (i).alert_id
               , v_line_number
               , v_note
               , SYSDATE
               , p_user_id
               , SYSDATE
               , p_user_id
               , p_session_id
            );

            /* Note:  Once a record is cleared for an EBS source, there is no need to maintain multiple entries for the same thing.
                              The unique contraint will limit the records in this table to what is applicable.  */
            BEGIN
            INSERT INTO xwrl_alert_clearing_xref (
               request_id
               , source_table
               , source_id
               , case_key
               , alert_id
               , list_id
               , from_state
               , to_state
               , status
               , error_message
               , note
               , last_update_date
               , last_updated_by
               , creation_date
               , created_by
               , last_update_login               
            ) VALUES (
               p_request_id
               , v_source_table
               , v_source_id
               , v_case_key
               , l_alert_out_tbl (i).alert_id
               , v_list_id
               , l_alert_out_tbl (i).old_state
               , l_alert_out_tbl (i).new_state
               , l_alert_out_tbl (i).status
               , l_alert_out_tbl (i).err_msg
               , v_note
               , SYSDATE
               , p_user_id
               , SYSDATE
               , p_user_id
               , p_session_id               
            );
            
            EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;

            IF v_path = 'INDIVIDUAL' THEN

               UPDATE xwrl_response_ind_columns
               SET
                  x_state = l_alert_out_tbl (i).new_state
                        ,last_updated_by = p_user_id
      ,last_update_date = SYSDATE
      ,last_update_login = p_session_id    
               WHERE
                  request_id = p_request_id
                  AND listid = v_list_id;

            ELSIF v_path = 'ENTITY' THEN

               UPDATE xwrl_response_entity_columns
               SET
                  x_state = l_alert_out_tbl (i).new_state
                        ,last_updated_by = p_user_id
      ,last_update_date = SYSDATE
      ,last_update_login = p_session_id    
               WHERE
                  request_id = p_request_id
                  AND listid = v_list_id;

            END IF;

         END IF;

      END LOOP;

      COMMIT;

   EXCEPTION
      WHEN OTHERS THEN
         raise_application_error (-20100, sqlerrm);

   END process_alerts;

   PROCEDURE process_alerts (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
      , p_alert_tab    IN             alert_tbl_in_type
   ) IS

      l_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
      l_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;
      x_status          VARCHAR2 (1000);
      v_key_label       VARCHAR2 (500);
      v_case_key        VARCHAR2 (500);
      v_list_id         INTEGER;
      v_source_table    VARCHAR2 (50);
      v_source_id       INTEGER;
      v_path            VARCHAR2 (50);
      v_note            VARCHAR2 (4000);
      v_line_number     NUMBER;
      v_user varchar2(100);

   BEGIN

      IF p_user_id IS NOT NULL THEN
         SELECT user_name into v_user from fnd_user where user_id = p_user_id;
      END IF;
      
     -- Process inbound table from ADF
      FOR i IN p_alert_tab.first..p_alert_tab.last LOOP
         l_alert_in_tbl (i).alert_id := p_alert_tab (i).p_alert_id;
         l_alert_in_tbl (i).to_state := p_alert_tab (i).p_to_state;
         l_alert_in_tbl (i).comment := p_alert_tab (i).p_comment;
         v_note := p_alert_tab (i).p_comment; -- Note: they will all have the same comment
      END LOOP;


      /* For debugging purposes

      FOR i IN l_alert_in_tbl.first..l_alert_in_tbl.last LOOP       

         dbms_output.put_line ('Alert - alert_id: ' || l_alert_in_tbl (i).alert_id);
         dbms_output.put_line ('Alert - to_state: ' || l_alert_in_tbl (i).to_state);
         dbms_output.put_line ('Alert - comment: ' || l_alert_in_tbl (i).comment);
         
         
         INSERT INTO tmp_xwrl_alerts (
         p_user
         , p_alert_id
         , p_to_state
         , p_comment
      ) VALUES (
         p_user
         , l_alert_in_tbl (i).alert_id
         , l_alert_in_tbl (i).to_state
         , l_alert_in_tbl (i).comment
      );

      END LOOP;
      
      */

      -- Execute OWS procedure
      xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com (p_user => v_user, p_alert_in_tbl => l_alert_in_tbl, x_alert_out_tbl => l_alert_out_tbl, x_status => x_status);
      
      -- dbms_output.put_line ('Alert - X_STATUS: ' || x_status);

     -- Process outbound table from OWS
      FOR i IN l_alert_out_tbl.first..l_alert_out_tbl.last LOOP

         /*
         dbms_output.put_line ('Alert - alert_id: ' || l_alert_out_tbl (i).alert_id);
         dbms_output.put_line ('Alert - key_label: ' || l_alert_out_tbl (i).key_label);
         dbms_output.put_line ('Alert - old_state: ' || l_alert_out_tbl (i).old_state);
         dbms_output.put_line ('Alert - new_state: ' || l_alert_out_tbl (i).new_state);
         dbms_output.put_line ('Alert - status: ' || l_alert_out_tbl (i).status);
         dbms_output.put_line ('Alert - err_msg: ' || l_alert_out_tbl (i).err_msg);
         */

         v_key_label := l_alert_out_tbl (i).key_label;

         SELECT
            substr (v_key_label, 1, instr (v_key_label, ':', 1) - 1)
         INTO v_case_key
         FROM
            dual;

         SELECT
            to_number (substr (v_key_label, instr (v_key_label, ':', - 1) + 1, length (v_key_label)))
         INTO v_list_id
         FROM
            dual;

         SELECT
            source_table
            , source_id
            , path
         INTO
            v_source_table
         , v_source_id
         , v_path
         FROM
            xwrl.xwrl_requests
         WHERE
            id = p_request_id;

         /* For debugging purposes*/

         INSERT INTO tmp_xwrl_alert_results (
            p_request_id
            , p_case_key
            , p_alert_id
            , p_list_id
            , p_key_label
            , p_old_state
            , p_new_state
            , p_status
            , p_err_msg
         ) VALUES (
            p_request_id
            , v_case_key
            , l_alert_out_tbl (i).alert_id
            , v_list_id
            , l_alert_out_tbl (i).key_label
            , l_alert_out_tbl (i).old_state
            , l_alert_out_tbl (i).new_state
            , l_alert_out_tbl (i).status
            , l_alert_out_tbl (i).err_msg
         );
         
         

         IF (l_alert_out_tbl (i).status = 'SUCCESS') THEN

            BEGIN
               SELECT
                  nvl (MAX (line_number), 0) + 10 line_number
               INTO v_line_number
               FROM
                  xwrl_alert_notes
               WHERE
                  alert_id = l_alert_out_tbl (i).alert_id;
            EXCEPTION
               WHEN no_data_found THEN
                  v_line_number := 10;
            END;

            INSERT INTO xwrl_alert_notes (
               request_id
               , alert_id
               , line_number
               , note
               , last_update_date
               , last_updated_by
               , creation_date
               , created_by
               , last_update_login
            ) VALUES (
               p_request_id
               , l_alert_out_tbl (i).alert_id
               , v_line_number
               , v_note
               , SYSDATE
               , p_user_id
               , SYSDATE
               , p_user_id
               , p_session_id
            );

            /* Note:  Once a record is cleared for an EBS source, there is no need to maintain multiple entries for the same thing.
                              The unique contraint will limit the records in this table to what is applicable.  */
            BEGIN
            INSERT INTO xwrl_alert_clearing_xref (
               request_id
               , source_table
               , source_id
               , case_key
               , alert_id
               , list_id
               , from_state
               , to_state
               , status
               , error_message
               , note
               , last_update_date
               , last_updated_by
               , creation_date
               , created_by
               , last_update_login               
            ) VALUES (
               p_request_id
               , v_source_table
               , v_source_id
               , v_case_key
               , l_alert_out_tbl (i).alert_id
               , v_list_id
               , l_alert_out_tbl (i).old_state
               , l_alert_out_tbl (i).new_state
               , l_alert_out_tbl (i).status
               , l_alert_out_tbl (i).err_msg
               , v_note
               , SYSDATE
               , p_user_id
               , SYSDATE
               , p_user_id
               , p_session_id
            );
            EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;

            IF v_path = 'INDIVIDUAL' THEN

               UPDATE xwrl_response_ind_columns
               SET
                  x_state = l_alert_out_tbl (i).new_state
                        ,last_updated_by = p_user_id
      ,last_update_date = SYSDATE
      ,last_update_login = p_session_id    
               WHERE
                  request_id = p_request_id
                  AND listid = v_list_id;

            ELSIF v_path = 'ENTITY' THEN

               UPDATE xwrl_response_entity_columns
               SET
                  x_state = l_alert_out_tbl (i).new_state
                        ,last_updated_by = p_user_id
      ,last_update_date = SYSDATE
      ,last_update_login = p_session_id    
               WHERE
                  request_id = p_request_id
                  AND listid = v_list_id;

            END IF;

         END IF;

      END LOOP;

      COMMIT;

   EXCEPTION
      WHEN OTHERS THEN
         raise_application_error (-20100, sqlerrm);

   END process_alerts;

   PROCEDURE auto_clear_individuals (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
   ) IS
   
       /* Note: The legacy data does not contain consistent information for EDD or PEP
                       Instead, this is derived from OWS for both.
      */

      CURSOR c1 IS
      SELECT
         col.id
         , col.request_id
         , r.source_table
         , r.source_id
         , col.listid
         , col.alertid
         , col.x_state
         , col.listrecordtype||' - False Positive' to_state
         --,clear.to_state
         , clear.note
      FROM
         xwrl_response_ind_columns   col
         , xwrl_requests               r
         , (
            WITH max_tab AS (
               SELECT
                  x.source_table
                  , x.source_id
                  , x.list_id
                  , MAX (id) id
               FROM
                  xwrl_alert_clearing_xref x
               GROUP BY
                  x.source_table
                  , x.source_id
                  , x.list_id
            )
            SELECT
               x.source_table
               , x.source_id
               , x.list_id
               , x.to_state
               , x.note
            FROM
               xwrl_alert_clearing_xref x
               , max_tab
            WHERE
               x.source_table = max_tab.source_table
               AND x.source_id = max_tab.source_id
               AND x.id = max_tab.id
         ) clear
      WHERE
         col.request_id = r.id
         AND r.source_table = clear.source_table
         AND r.source_id = clear.source_id
         AND col.listid = clear.list_id
         AND col.request_id = p_request_id;

      p_alert_tab   alert_tbl_in_type;
      v_count       INTEGER;

   BEGIN

      v_count := 0;


      FOR c1rec IN c1 LOOP

         v_count := v_count + 1;

         p_alert_tab (v_count).p_alert_id := c1rec.alertid;
         p_alert_tab (v_count).p_to_state := c1rec.to_state;
         p_alert_tab (v_count).p_comment := c1rec.note;

      END LOOP;

      IF v_count > 0 THEN

        process_alerts (p_user_id,p_session_id, p_request_id, p_alert_tab);

      END IF;

   EXCEPTION
      WHEN OTHERS THEN
         raise_application_error (-20100, sqlerrm);

   END auto_clear_individuals;

   PROCEDURE auto_clear_entities (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
   ) IS

      /* Note: The legacy data does not contain consistent information for EDD or PEP
                       Instead, this is derived from OWS for both.
      */
      CURSOR c1 IS
      SELECT
         col.id
         , col.request_id
         , r.source_table
         , r.source_id
         , col.listid
         , col.alertid
         ,col.listrecordtype
         , col.x_state
         , col.listrecordtype||' - False Positive' to_state
         --,clear.to_state
         , clear.note
      FROM
         xwrl_response_entity_columns   col
         , xwrl_requests                  r
         , (
            WITH max_tab AS (
               SELECT
                  x.source_table
                  , x.source_id
                  , x.list_id
                  , MAX (id) id
               FROM
                  xwrl_alert_clearing_xref x
               GROUP BY
                  x.source_table
                  , x.source_id
                  , x.list_id
            )
            SELECT
               x.source_table
               , x.source_id
               , x.list_id
               , x.to_state
               , x.note
            FROM
               xwrl_alert_clearing_xref x
               , max_tab
            WHERE
               x.source_table = max_tab.source_table
               AND x.source_id = max_tab.source_id
               AND x.id = max_tab.id
         ) clear
      WHERE
         col.request_id = r.id
         AND r.source_table = clear.source_table
         AND r.source_id = clear.source_id
         AND col.listid = clear.list_id
         AND col.request_id = p_request_id;

      p_alert_tab   alert_tbl_in_type;
      v_count       INTEGER;

   BEGIN

      v_count := 0;

      FOR c1rec IN c1 LOOP

         v_count := v_count + 1;

         p_alert_tab (v_count).p_alert_id := c1rec.alertid;
         p_alert_tab (v_count).p_to_state := c1rec.to_state;
         p_alert_tab (v_count).p_comment := c1rec.note;

      END LOOP;

      IF v_count > 0 THEN

         process_alerts (p_user_id,p_session_id, p_request_id, p_alert_tab);

      END IF;

   EXCEPTION
      WHEN OTHERS THEN
         raise_application_error (-20100, sqlerrm);

   END auto_clear_entities;

END xwrl_ows_utils;
/

-- XWRL

DROP TYPE xwrl.xwrl_alert_in_rec;

DROP TYPE xwrl.xwrl_alert_tbl_out_type;

DROP TYPE xwrl.xwrl_alert_out_rec;

DROP TYPE xwrl.xwrl_alert_tbl_out_type;

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
   , new_state   VARCHAR (100)
   , status      VARCHAR2 (100)
   , err_msg     VARCHAR2 (1000)
);
/

CREATE OR REPLACE TYPE xwrl.xwrl_alert_tbl_out_type IS
   TABLE OF xwrl.xwrl_alert_out_rec;
/

GRANT ALL ON xwrl.xwrl_alert_in_rec TO apps;

GRANT ALL ON xwrl.xwrl_alert_tbl_in_type TO apps;

GRANT ALL ON xwrl.xwrl_alert_out_rec TO apps;

GRANT ALL ON xwrl.xwrl_alert_tbl_out_type TO apps;


-- APPS

DROP SYNONYM apps.xwrl_alert_in_rec;

DROP SYNONYM apps.xwrl_alert_tbl_in_type;

DROP SYNONYM apps.xwrl_alert_out_rec;

DROP SYNONYM apps.xwrl_alert_tbl_out_type;

CREATE SYNONYM apps.xwrl_alert_in_rec FOR xwrl.xwrl_alert_in_rec;

CREATE SYNONYM apps.xwrl_alert_tbl_in_type FOR xwrl.xwrl_alert_tbl_in_type;

CREATE SYNONYM apps.xwrl_alert_out_rec FOR xwrl.xwrl_alert_out_rec;

CREATE SYNONYM apps.xwrl_alert_tbl_out_type FOR xwrl.xwrl_alert_tbl_out_type;


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
   p_alert_id    VARCHAR2 (100)
   , p_new_state   VARCHAR (100)
   , p_status      VARCHAR2 (100)
   , p_err_msg     VARCHAR2 (1000)
);

-- APPS

CREATE OR REPLACE PACKAGE apps.xwrl_ows_utils AS

   PROCEDURE process_alerts (
      p_user        IN            VARCHAR2
      , p_alert_tab   IN            xwrl_alert_tbl_in_type
   );

END xwrl_ows_utils;
/

CREATE OR REPLACE PACKAGE BODY apps.xwrl_ows_utils AS

   PROCEDURE process_alerts (
      p_user        IN            VARCHAR2
      , p_alert_tab   IN            xwrl_alert_tbl_in_type
   ) IS

      l_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
      l_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;
      x_status          VARCHAR2 (200);
   BEGIN

     -- Process inbound table from ADF
      FOR i IN p_alert_tab.first..p_alert_tab.last LOOP
         l_alert_in_tbl (i).alert_id := p_alert_tab (i).p_alert_id;
         l_alert_in_tbl (i).to_state := p_alert_tab (i).p_to_state;
         l_alert_in_tbl (i).comment := p_alert_tab (i).p_comment;
      END LOOP;

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

      -- Execute OWS procedure
      xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com (p_user => p_user, p_alert_in_tbl => l_alert_in_tbl, x_alert_out_tbl => l_alert_out_tbl, x_status => x_status);

      dbms_output.put_line ('Alert - X_STATUS: ' || x_status);

     -- Process outbound table from OWS
      FOR i IN l_alert_out_tbl.first..l_alert_out_tbl.last LOOP

         dbms_output.put_line ('Alert - alert_id: ' || l_alert_out_tbl (i).alert_id);
         dbms_output.put_line ('Alert - new_state: ' || l_alert_out_tbl (i).new_state);
         dbms_output.put_line ('Alert - status: ' || l_alert_out_tbl (i).status);
         dbms_output.put_line ('Alert - err_msg: ' || l_alert_out_tbl (i).err_msg);

         INSERT INTO tmp_xwrl_alert_results (
            p_alert_id
            , p_new_state
            , p_status
            , p_err_msg
         ) VALUES (
            l_alert_out_tbl (i).alert_id
            , l_alert_out_tbl (i).new_state
            , l_alert_out_tbl (i).status
            , l_alert_out_tbl (i).err_msg
         );

      END LOOP;

      COMMIT;

   EXCEPTION
      WHEN OTHERS THEN
         raise_application_error (-20100, sqlerrm);

   END process_alerts;

END xwrl_ows_utils;
/


SELECT
   *
FROM
   tmp_xwrl_alerts;

SELECT
   *
FROM
   tmp_xwrl_alert_results;

SELECT
   *
FROM
   xwrl_alert_notes
WHERE
   trunc (creation_date) = trunc (SYSDATE);

DELETE FROM xwrl_alert_notes
WHERE
   trunc (creation_date) = trunc (SYSDATE);

- - sen - 1750737
-- SEN-1750738




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

DROP SYNONYM apps.xwrl_alert_in_rec;

DROP SYNONYM apps.xwrl_alert_tbl_in_type;

DROP SYNONYM apps.xwrl_alert_out_rec;

DROP SYNONYM apps.xwrl_alert_tbl_out_type;

CREATE SYNONYM apps.xwrl_alert_in_rec FOR xwrl.xwrl_alert_in_rec;

CREATE SYNONYM apps.xwrl_alert_tbl_in_type FOR xwrl.xwrl_alert_tbl_in_type;

CREATE SYNONYM apps.xwrl_alert_out_rec FOR xwrl.xwrl_alert_out_rec;

CREATE SYNONYM apps.xwrl_alert_tbl_out_type FOR xwrl.xwrl_alert_tbl_out_type;

DROP TABLE tmp_xwrl_alerts;

CREATE TABLE tmp_xwrl_alerts (
   p_user       VARCHAR2 (30)
   , p_alert_id   VARCHAR2 (100)
   , p_to_state   VARCHAR2 (100)
   , p_comment    VARCHAR2 (1000)
);

DROP TABLE tmp_xwrl_alert_results;

CREATE TABLE tmp_xwrl_alert_results (
   alert_id    VARCHAR2 (100)
   , new_state   VARCHAR (100)
   , status      VARCHAR2 (100)
   , err_msg     VARCHAR2 (1000)
);


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


      --x_alert_out_tbl   xwrl_alert_tbl_out_type;
      x_status          VARCHAR2 (200);

      p_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
      x_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;


   BEGIN

      xxiri_cm_process_pkg.update_alerts (p_user => p_user, p_alert_in_tbl => p_alert_in_tbl, x_alert_out_tbl => x_alert_out_tbl, x_status => x_status);

      FOR i IN p_alert_tab.first..p_alert_tab.last LOOP

         dbms_output.put_line ('Alert - p_alert_id' || p_alert_tab (i).p_alert_id);
         dbms_output.put_line ('Alert - p_to_state' || p_alert_tab (i).p_to_state);
         dbms_output.put_line ('Alert - p_comment' || p_alert_tab (i).p_comment);

         INSERT INTO tmp_xwrl_alerts (
            p_user
            , p_alert_id
            , p_to_state
            , p_comment
         ) VALUES (
            p_user
            , p_alert_tab (i).p_alert_id
            , p_alert_tab (i).p_to_state
            , p_alert_tab (i).p_comment
         );
         COMMIT;

      END LOOP;

      FOR i IN x_alert_out_tbl.first..x_alert_out_tbl.last LOOP

         dbms_output.put_line ('Alert - alert_id' || x_alert_out_tbl (i).alert_id);
         dbms_output.put_line ('Alert - new_state' || x_alert_out_tbl (i).new_state);
         dbms_output.put_line ('Alert - status' || x_alert_out_tbl (i).status);
         dbms_output.put_line ('Alert - err_msg' || x_alert_out_tbl (i).err_msg);

         INSERT INTO tmp_xwrl_alert_results (
            alert_id
            , new_state
            , status
            , err_msg
         ) VALUES (
            x_alert_out_tbl (i).alert_id
            , x_alert_out_tbl (i).new_state
            , x_alert_out_tbl (i).status
            , x_alert_out_tbl (i).err_msg
         );
         COMMIT;

      END LOOP;

   EXCEPTION
      WHEN OTHERS THEN
         raise_application_error (-20100, 'Error: xwrl_ows_utils.process_alerts');

   END process_alerts;

END xwrl_ows_utils;
/


SELECT
   *
FROM
   xwrl_response_ind_columns
WHERE
   alertid = 'SEN-1736407';

SELECT
   *
FROM
   tmp_xwrl_alerts;

SELECT
   *
FROM
   tmp_xwrl_alert_results
   order by 1 ;

SELECT
   *
FROM
   xwrl_alert_notes
WHERE
   trunc (creation_date) = trunc (SYSDATE);

DELETE FROM xwrl_alert_notes
WHERE
   trunc (creation_date) = trunc (SYSDATE);


SELECT
   *
FROM
   all_types
WHERE
   type_name = 'XWRL_ALERT_IN_REC'
--and typecode = 'OBJECT'
   ;

SELECT
   *
FROM
   all_types
WHERE
   type_name = 'XWRL_ALERT_TBL_IN_TYPE'
--and typecode = 'OBJECT'
   ;
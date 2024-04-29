/* Run as XWRL 

DROP SEQUENCE xwrl.xwrl_alerts_debug_seq;

DROP SEQUENCE xwrl.xwrl_alert_results_debug_seq;

CREATE SEQUENCE xwrl.xwrl_alerts_debug_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl.xwrl_alert_results_debug_seq START WITH 1000 NOCACHE;

DROP TABLE xwrl.xwrl_alerts_debug;

CREATE TABLE xwrl.xwrl_alerts_debug (
id integer not null
,procedure_name varchar2(100)
,debug_note varchar2(500)
   , p_user       VARCHAR2 (30)
   , p_alert_id   VARCHAR2 (100)
   , p_to_state   VARCHAR2 (100)
   , p_comment    VARCHAR2 (1000)
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)   
);

DROP TABLE xwrl.xwrl_alert_results_debug;

CREATE TABLE xwrl.xwrl_alert_results_debug (
id integer not null
,procedure_name varchar2(100)
,debug_note varchar2(500)
,  p_request_id   INTEGER
   , p_case_key     VARCHAR2 (100)
   , p_alert_id     VARCHAR2 (100)
   , p_list_id      INTEGER
   , p_key_label    VARCHAR2 (500)
   , p_old_state    VARCHAR (100)
   , p_new_state    VARCHAR (100)
   , p_status       VARCHAR2 (100)
   , p_err_msg      VARCHAR2 (4000)
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)   
);


ALTER TABLE xwrl.xwrl_alerts_debug ADD CONSTRAINT xwrl_alerts_debug_pk PRIMARY KEY ( id );
ALTER TABLE xwrl_alert_results_debug ADD CONSTRAINT xwrl_alert_results_debug_pk PRIMARY KEY ( id );

CREATE OR REPLACE TRIGGER xwrl_alerts_debug_trg BEFORE
   INSERT ON xwrl_alerts_debug
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_alerts_debug_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_alert_results_debug_trg BEFORE
   INSERT ON xwrl_alert_results_debug
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_alert_results_debug_seq.nextval;
   END IF;
END;
/

grant all on xwrl_alerts_debug to apps;
grant all on xwrl_alert_results_debug to apps;
grant all on xwrl_alerts_debug_seq to apps;
grant all on xwrl_alert_results_debug_seq to apps;

grant all on xwrl_alerts_debug to appsro;
grant all on xwrl_alert_results_debug to appsro;
grant all on xwrl_alerts_debug_seq to appsro;
grant all on xwrl_alert_results_debug_seq to appsro;

*/
/* Run as APPS */
create synonym xwrl_alerts_debug for xwrl.xwrl_alerts_debug;
create synonym xwrl_alert_results_debug for xwrl.xwrl_alert_results_debug;
create synonym xwrl_alerts_debug_seq for xwrl.xwrl_alerts_debug_seq;
create synonym xwrl_alert_results_debug_seq for xwrl.xwrl_alert_results_debug_seq;

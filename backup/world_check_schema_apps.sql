/* APPS */

SELECT
   *
FROM
   v$tablespace;

SELECT
   *
FROM
   database_properties
WHERE
   property_name LIKE 'DEFAULT%TABLESPACE';


CREATE USER xwrl IDENTIFIED BY xwrl;

ALTER USER xwrl
   DEFAULT TABLESPACE apps_ts_tx_data
   TEMPORARY TABLESPACE temp;

GRANT connect, resource TO xwrl;

GRANT
   CREATE SESSION
TO xwrl;

GRANT
   UNLIMITED TABLESPACE
TO xwrl;

grant MANAGE SCHEDULER to apps;
grant create job to apps;
grant  create any job to apps;
grant scheduler_admin to apps;


GRANT EXECUTE ON utl_http TO xwrl;
GRANT EXECUTE ON dbms_lock TO xwrl;

CREATE SYNONYM xwrl_keywords FOR xwrl.xwrl_keywords;

CREATE SYNONYM xwrl_location_types FOR xwrl.xwrl_location_types;

CREATE SYNONYM xwrl_parameters FOR xwrl.xwrl_parameters;

CREATE SYNONYM xwrl_requests FOR xwrl.xwrl_requests;

CREATE SYNONYM xwrl_request_ind_columns FOR xwrl.xwrl_request_ind_columns;
CREATE SYNONYM xwrl_request_entity_columns FOR xwrl.xwrl_request_entity_columns;
CREATE SYNONYM xwrl_request_rows FOR xwrl.xwrl_request_rows;
CREATE SYNONYM xwrl_response_ind_columns FOR xwrl.xwrl_response_ind_columns;
CREATE SYNONYM xwrl_response_entity_columns FOR xwrl.xwrl_response_entity_columns;
CREATE SYNONYM xwrl_response_rows FOR xwrl.xwrl_response_rows;

CREATE SYNONYM xwrl_requests_seq FOR xwrl.xwrl_requests_seq;

CREATE SYNONYM xwrl_requests1_seq FOR xwrl.xwrl_requests1_seq;

CREATE SYNONYM xwrl_requests2_seq FOR xwrl.xwrl_requests2_seq;

CREATE SYNONYM xwrl_requests3_seq FOR xwrl.xwrl_requests3_seq;

CREATE SYNONYM xwrl_requests4_seq FOR xwrl.xwrl_requests4_seq;

CREATE SYNONYM xwrl_requests5_seq FOR xwrl.xwrl_requests5_seq;

CREATE SYNONYM xwrl_requests6_seq FOR xwrl.xwrl_requests6_seq;

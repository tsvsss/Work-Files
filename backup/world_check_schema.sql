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

/* XWRL /* APPS */

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

/* XWRL */

DROP SEQUENCE xwrl_requests_seq;

DROP SEQUENCE xwrl_requests1_seq;
DROP SEQUENCE xwrl_requests2_seq;
DROP SEQUENCE xwrl_requests3_seq;
DROP SEQUENCE xwrl_requests4_seq;
DROP SEQUENCE xwrl_requests5_seq;
DROP SEQUENCE xwrl_requests6_seq;

DROP TABLE xwrl_keywords CASCADE CONSTRAINTS;

DROP TABLE xwrl_location_types CASCADE CONSTRAINTS;

DROP TABLE xwrl_parameters CASCADE CONSTRAINTS;

DROP TABLE xwrl_requests CASCADE CONSTRAINTS;

DROP TABLE xwrl_request_ind_columns CASCADE CONSTRAINTS;

DROP TABLE xwrl_request_entity_columns CASCADE CONSTRAINTS;

DROP TABLE xwrl_request_rows CASCADE CONSTRAINTS;

DROP TABLE xwrl_response_ind_columns CASCADE CONSTRAINTS;

DROP TABLE xwrl_response_entity_columns CASCADE CONSTRAINTS;

DROP TABLE xwrl_response_rows CASCADE CONSTRAINTS;

CREATE SEQUENCE xwrl_requests_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests1_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests2_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests3_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests4_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests5_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests6_seq START WITH 1000 NOCACHE;

CREATE TABLE xwrl_keywords (
   keyword_abbreviation   VARCHAR2 (30) NOT NULL
   , full_name_of_source    VARCHAR2 (500) NOT NULL
   , country_of_authority   VARCHAR2 (100)
   , type                   VARCHAR2 (50)
   , explanation            VARCHAR2 (3000) NOT NULL
   , last_update_date       DATE
   , last_updated_by        NUMBER (15)
   , creation_date          DATE
   , created_by             NUMBER (15)
   , last_update_login      NUMBER (15)
)
logging;

ALTER TABLE xwrl_keywords ADD CONSTRAINT xwrl_keywords_pk PRIMARY KEY (keyword_abbreviation);

CREATE TABLE xwrl_location_types (
   loc_type            VARCHAR2 (30) NOT NULL
   , country             VARCHAR2 (100) NOT NULL
   , full_name           VARCHAR2 (500) NOT NULL
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
logging;

ALTER TABLE xwrl_location_types ADD CONSTRAINT xwrl_location_types_pk PRIMARY KEY (loc_type);

CREATE TABLE xwrl_parameters (
   id                  VARCHAR2 (100) NOT NULL
   , key                 VARCHAR2 (500) NOT NULL
   , value_string        VARCHAR2 (500)
   , value_date          DATE
   , value_xml           XMLTYPE
   , value_clob          CLOB
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
LOGGING XMLTYPE COLUMN value_xml STORE AS BINARY XML (
   STORAGE (PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 BUFFER_POOL DEFAULT)
   RETENTION
   ENABLE STORAGE IN ROW
   NOCACHE
);

ALTER TABLE xwrl_parameters ADD CONSTRAINT xwrl_parameters_pk PRIMARY KEY (id
, key);

CREATE TABLE xwrl_requests (
    id                        INTEGER NOT NULL,
    resubmit_id               INTEGER,
    source_table              VARCHAR2(50),
    source_id                 NUMBER,
    wc_screening_request_id   NUMBER,
    server                    VARCHAR2(100),
    path                      VARCHAR2(100),
    soap_query varchar2(3000),
    request                   XMLTYPE,
    response                  XMLTYPE,
    job_id VARCHAR2(100),
    matches    INTEGER,
    status                    VARCHAR2(30),
    error_code                VARCHAR2(100),
    error_message             VARCHAR2(1000),
    last_update_date          DATE,
    last_updated_by           NUMBER(15),
    creation_date             DATE,
    created_by                NUMBER(15),
    last_update_login         NUMBER(15)
) XMLTYPE COLUMN request STORE AS BINARY XML (
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 BUFFER_POOL DEFAULT )
    RETENTION
    ENABLE STORAGE IN ROW
    NOCACHE
) XMLTYPE COLUMN response STORE AS BINARY XML (
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 BUFFER_POOL DEFAULT )
    RETENTION
    ENABLE STORAGE IN ROW
    NOCACHE
);

ALTER TABLE xwrl_requests ADD CONSTRAINT xwrl_requests_pk PRIMARY KEY (id);

CREATE OR REPLACE TRIGGER xwrl_requests BEFORE
   INSERT ON xwrl_requests
   FOR EACH ROW
BEGIN

   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests_seq.nextval;
   END IF;

END;
/


CREATE TABLE xwrl_request_ind_columns (
   id                        INTEGER NOT NULL
   , request_id                INTEGER NOT NULL
   , listsubkey                VARCHAR2 (2700)
   , listrecordtype            VARCHAR2 (2700)
   , listrecordorigin          VARCHAR2 (2700)
   , custid                    VARCHAR2 (2700)
   , custsubid                 VARCHAR2 (2700)
   , passportnumber            VARCHAR2 (2700)
   , nationalid                VARCHAR2 (2700)
   , title                     VARCHAR2 (2700)
   , fullname                  VARCHAR2 (2700)
   , givennames                VARCHAR2 (2700)
   , familyname                VARCHAR2 (2700)
   , nametype                  VARCHAR2 (2700)
   , namequality               VARCHAR2 (2700)
   , primaryname               VARCHAR2 (2700)
   , originalscriptname        VARCHAR2 (2700)
   , gender                    VARCHAR2 (2700)
   , dateofbirth               VARCHAR2 (2700)
   , yearofbirth               VARCHAR2 (2700)
   , occupation                VARCHAR2 (2700)
   , address1                  VARCHAR2 (2700)
   , address2                  VARCHAR2 (2700)
   , address3                  VARCHAR2 (2700)
   , address4                  VARCHAR2 (2700)
   , city                      VARCHAR2 (2700)
   , state                     VARCHAR2 (2700)
   , postalcode                VARCHAR2 (2700)
   , addresscountrycode        VARCHAR2 (2700)
   , residencycountrycode      VARCHAR2 (2700)
   , countryofbirthcode        VARCHAR2 (2700)
   , nationalitycountrycodes   VARCHAR2 (2700)
   , profilehyperlink          VARCHAR2 (2700)
   , riskscore                 VARCHAR2 (2700)
   , dataconfidencescore       VARCHAR2 (2700)
   , dataconfidencecomment     VARCHAR2 (2700)
   , customstring1             VARCHAR2 (2700)
   , customstring2             VARCHAR2 (2700)
   , customstring3             VARCHAR2 (2700)
   , customstring4             VARCHAR2 (2700)
   , customstring5             VARCHAR2 (2700)
   , customstring6             VARCHAR2 (2700)
   , customstring7             VARCHAR2 (2700)
   , customstring8             VARCHAR2 (2700)
   , customstring9             VARCHAR2 (2700)
   , customstring10            VARCHAR2 (2700)
   , customstring11            VARCHAR2 (2700)
   , customstring12            VARCHAR2 (2700)
   , customstring13            VARCHAR2 (2700)
   , customstring14            VARCHAR2 (2700)
   , customstring15            VARCHAR2 (2700)
   , customstring16            VARCHAR2 (2700)
   , customstring17            VARCHAR2 (2700)
   , customstring18            VARCHAR2 (2700)
   , customstring19            VARCHAR2 (2700)
   , customstring20            VARCHAR2 (2700)
   , customstring21            VARCHAR2 (2700)
   , customstring22            VARCHAR2 (2700)
   , customstring23            VARCHAR2 (2700)
   , customstring24            VARCHAR2 (2700)
   , customstring25            VARCHAR2 (2700)
   , customstring26            VARCHAR2 (2700)
   , customstring27            VARCHAR2 (2700)
   , customstring28            VARCHAR2 (2700)
   , customstring29            VARCHAR2 (2700)
   , customstring30            VARCHAR2 (2700)
   , customstring31            VARCHAR2 (2700)
   , customstring32            VARCHAR2 (2700)
   , customstring33            VARCHAR2 (2700)
   , customstring34            VARCHAR2 (2700)
   , customstring35            VARCHAR2 (2700)
   , customstring36            VARCHAR2 (2700)
   , customstring37            VARCHAR2 (2700)
   , customstring38            VARCHAR2 (2700)
   , customstring39            VARCHAR2 (2700)
   , customstring40            VARCHAR2 (2700)
   , customdate1               VARCHAR2 (2700)
   , customdate2               VARCHAR2 (2700)
   , customdate3               VARCHAR2 (2700)
   , customdate4               VARCHAR2 (2700)
   , customdate5               VARCHAR2 (2700)
   , customnumber1             VARCHAR2 (2700)
   , customnumber2             VARCHAR2 (2700)
   , customnumber3             VARCHAR2 (2700)
   , customnumber4             VARCHAR2 (2700)
   , customnumber5             VARCHAR2 (2700)
   , last_update_date          DATE
   , last_updated_by           NUMBER (15)
   , creation_date             DATE
   , created_by                NUMBER (15)
   , last_update_login         NUMBER (15)
)
logging;

CREATE TABLE xwrl_request_entity_columns (
   id                        INTEGER NOT NULL
   , request_id                INTEGER NOT NULL
   , listsubkey                VARCHAR2 (2700)
   , listrecordtype            VARCHAR2 (2700)
   , listrecordorigin          VARCHAR2 (2700)
   , custid                    VARCHAR2 (2700)
   , custsubid                 VARCHAR2 (2700)
   , registrationnumber        VARCHAR2 (2700)
   , entityname                VARCHAR2 (2700)
   , nametype                  VARCHAR2 (2700)
   , namequality               VARCHAR2 (2700)
   , primaryname               VARCHAR2 (2700)
   , originalscriptname        VARCHAR2 (2700)
   , aliasisacronym            VARCHAR2 (2700)
   , address1                  VARCHAR2 (2700)
   , address2                  VARCHAR2 (2700)
   , address3                  VARCHAR2 (2700)
   , address4                  VARCHAR2 (2700)
   , city                      VARCHAR2 (2700)
   , state                     VARCHAR2 (2700)
   , postalcode                VARCHAR2 (2700)
   , addresscountrycode        VARCHAR2 (2700)
   , registrationcountrycode   VARCHAR2 (2700)
   , operatingcountrycodes     VARCHAR2 (2700)
   , profilehyperlink          VARCHAR2 (2700)
   , riskscore                 VARCHAR2 (2700)
   , dataconfidencescore       VARCHAR2 (2700)
   , dataconfidencecomment     VARCHAR2 (2700)
   , customstring1             VARCHAR2 (2700)
   , customstring2             VARCHAR2 (2700)
   , customstring3             VARCHAR2 (2700)
   , customstring4             VARCHAR2 (2700)
   , customstring5             VARCHAR2 (2700)
   , customstring6             VARCHAR2 (2700)
   , customstring7             VARCHAR2 (2700)
   , customstring8             VARCHAR2 (2700)
   , customstring9             VARCHAR2 (2700)
   , customstring10            VARCHAR2 (2700)
   , customstring11            VARCHAR2 (2700)
   , customstring12            VARCHAR2 (2700)
   , customstring13            VARCHAR2 (2700)
   , customstring14            VARCHAR2 (2700)
   , customstring15            VARCHAR2 (2700)
   , customstring16            VARCHAR2 (2700)
   , customstring17            VARCHAR2 (2700)
   , customstring18            VARCHAR2 (2700)
   , customstring19            VARCHAR2 (2700)
   , customstring20            VARCHAR2 (2700)
   , customstring21            VARCHAR2 (2700)
   , customstring22            VARCHAR2 (2700)
   , customstring23            VARCHAR2 (2700)
   , customstring24            VARCHAR2 (2700)
   , customstring25            VARCHAR2 (2700)
   , customstring26            VARCHAR2 (2700)
   , customstring27            VARCHAR2 (2700)
   , customstring28            VARCHAR2 (2700)
   , customstring29            VARCHAR2 (2700)
   , customstring30            VARCHAR2 (2700)
   , customstring31            VARCHAR2 (2700)
   , customstring32            VARCHAR2 (2700)
   , customstring33            VARCHAR2 (2700)
   , customstring34            VARCHAR2 (2700)
   , customstring35            VARCHAR2 (2700)
   , customstring36            VARCHAR2 (2700)
   , customstring37            VARCHAR2 (2700)
   , customstring38            VARCHAR2 (2700)
   , customstring39            VARCHAR2 (2700)
   , customstring40            VARCHAR2 (2700)
   , customdate1               VARCHAR2 (2700)
   , customdate2               VARCHAR2 (2700)
   , customdate3               VARCHAR2 (2700)
   , customdate4               VARCHAR2 (2700)
   , customdate5               VARCHAR2 (2700)
   , customnumber1             VARCHAR2 (2700)
   , customnumber2             VARCHAR2 (2700)
   , customnumber3             VARCHAR2 (2700)
   , customnumber4             VARCHAR2 (2700)
   , customnumber5             VARCHAR2 (2700)
   , last_update_date          DATE
   , last_updated_by           NUMBER (15)
   , creation_date             DATE
   , created_by                NUMBER (15)
   , last_update_login         NUMBER (15)
)
logging;


CREATE TABLE xwrl_request_rows (
   id                  INTEGER NOT NULL
   , request_id          INTEGER NOT NULL
   , path                VARCHAR2 (50)
   , rw                  INTEGER
   , key                 VARCHAR2 (100)
   , value               VARCHAR2 (2700)
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
logging;

CREATE TABLE xwrl_response_ind_columns (
   id                       INTEGER NOT NULL
   , request_id               INTEGER NOT NULL
   , rec                      INTEGER NOT NULL
   , listkey                  VARCHAR2 (2700)
   , listsubkey               VARCHAR2 (2700)
   , listrecordtype           VARCHAR2 (2700)
   , listrecordorigin         VARCHAR2 (2700)
   , listid                   VARCHAR2 (2700)
   , listgivennames           VARCHAR2 (2700)
   , listfamilyname           VARCHAR2 (2700)
   , listfullname             VARCHAR2 (2700)
   , listnametype             VARCHAR2 (2700)
   , listprimaryname          VARCHAR2 (2700)
   , listoriginalscriptname   VARCHAR2 (2700)
   , listdob                  VARCHAR2 (2700)
   , listcity                 VARCHAR2 (2700)
   , listcountry              VARCHAR2 (2700)
   , listcountryofbirth       VARCHAR2 (2700)
   , listnationality          VARCHAR2 (2700)
   , matchrule                VARCHAR2 (2700)
   , matchscore               VARCHAR2 (2700)
   , casekey                  VARCHAR2 (2700)
   , alertid                  VARCHAR2 (2700)
   , riskscore                VARCHAR2 (2700)
   , riskscorepep             VARCHAR2 (2700)
   , last_update_date         DATE
   , last_updated_by          NUMBER (15)
   , creation_date            DATE
   , created_by               NUMBER (15)
   , last_update_login        NUMBER (15)
)
logging;

CREATE TABLE xwrl_response_entity_columns (
   id                          INTEGER NOT NULL
   , request_id                  INTEGER NOT NULL
   , rec                         INTEGER NOT NULL
   , listkey                     VARCHAR2 (2700)
   , listsubkey                  VARCHAR2 (2700)
   , listrecordtype              VARCHAR2 (2700)
   , listrecordorigin            VARCHAR2 (2700)
   , listid                      VARCHAR2 (2700)
   , listentityname              VARCHAR2 (2700)
   , listprimaryname             VARCHAR2 (2700)
   , listoriginalscriptname      VARCHAR2 (2700)
   , listnametype                VARCHAR2 (2700)
   , listcity                    VARCHAR2 (2700)
   , listcountry                 VARCHAR2 (2700)
   , listoperatingcountries      VARCHAR2 (2700)
   , listregistrationcountries   VARCHAR2 (2700)
   , matchrule                   VARCHAR2 (2700)
   , matchscore                  VARCHAR2 (2700)
   , casekey                     VARCHAR2 (2700)
   , alertid                     VARCHAR2 (2700)
   , riskscore                   VARCHAR2 (2700)
   , riskscorepep                VARCHAR2 (2700)
   , last_update_date            DATE
   , last_updated_by             NUMBER (15)
   , creation_date               DATE
   , created_by                  NUMBER (15)
   , last_update_login           NUMBER (15)
)
logging;

CREATE TABLE xwrl_response_rows (
   id                  INTEGER NOT NULL
   , request_id          INTEGER NOT NULL
   , path                VARCHAR2 (50)
   , ows_id              VARCHAR2 (500)
   , rec_row             INTEGER
   , det_row             INTEGER
   , key                 VARCHAR2 (100)
   , value               VARCHAR2 (2700)
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
logging;


ALTER TABLE xwrl_request_ind_columns ADD CONSTRAINT xwrl_request_ind_columns_pk PRIMARY KEY (id);
ALTER TABLE xwrl_request_entity_columns ADD CONSTRAINT xwrl_request_entity_columns_pk PRIMARY KEY (id);
ALTER TABLE xwrl_request_rows ADD CONSTRAINT xwrl_request_rows_pk PRIMARY KEY (id);
ALTER TABLE xwrl_response_ind_columns ADD CONSTRAINT xwrl_response_ind_columns_pk PRIMARY KEY (id);
ALTER TABLE xwrl_response_entity_columns ADD CONSTRAINT xwrl_response_entity_col_pk PRIMARY KEY (id);
ALTER TABLE xwrl_response_rows ADD CONSTRAINT xwrl_response_rows_pk PRIMARY KEY (id);


CREATE OR REPLACE TRIGGER xwrl_request_ind_columns BEFORE
   INSERT ON xwrl_request_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests1_seq.nextval;
   END IF;
END;
/
CREATE OR REPLACE TRIGGER xwrl_request_entity_columns BEFORE
   INSERT ON xwrl_request_entity_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests2_seq.nextval;
   END IF;
END;
/
CREATE OR REPLACE TRIGGER xwrl_request_rows BEFORE
   INSERT ON xwrl_request_rows
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests3_seq.nextval;
   END IF;
END;
/
CREATE OR REPLACE TRIGGER xwrl_response_ind_columns BEFORE
   INSERT ON xwrl_response_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests4_seq.nextval;
   END IF;
END;
/
CREATE OR REPLACE TRIGGER xwrl_response_entity_columns BEFORE
   INSERT ON xwrl_response_entity_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests5_seq.nextval;
   END IF;
END;
/
CREATE OR REPLACE TRIGGER xwrl_response_rows BEFORE
   INSERT ON xwrl_response_rows
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests6_seq.nextval;
   END IF;
END;
/

GRANT ALL ON xwrl_keywords TO apps;

GRANT ALL ON xwrl_location_types TO apps;

GRANT ALL ON xwrl_parameters TO apps;

GRANT ALL ON xwrl_requests TO apps;

GRANT ALL ON xwrl_request_ind_columns TO apps;
GRANT ALL ON xwrl_request_entity_columns TO apps;
GRANT ALL ON xwrl_request_rows TO apps;
GRANT ALL ON xwrl_response_ind_columns TO apps;
GRANT ALL ON xwrl_response_entity_columns TO apps;
GRANT ALL ON xwrl_response_rows TO apps;

GRANT ALL ON xwrl_requests_seq TO apps;

GRANT ALL ON xwrl_requests1_seq TO apps;
GRANT ALL ON xwrl_requests2_seq TO apps;
GRANT ALL ON xwrl_requests3_seq TO apps;
GRANT ALL ON xwrl_requests4_seq TO apps;
GRANT ALL ON xwrl_requests5_seq TO apps;
GRANT ALL ON xwrl_requests6_seq TO apps;

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'POC'
   , 'http://129.150.84.227:8001'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIPRODOWS-PRI'
   , 'http://10.134.147.153:8001'
);
INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIPRODOWS-SEC'
   , 'http://10.134.147.154:8001'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIDROWS-PRI'
   , 'http://10.161.147.149:8001'
);
INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIDROWS-SEC'
   , 'http://10.161.147.150:8001'
);


INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'CONSOLE'
   , 'IRIPRODOWS-PRI'
   , 'http://10.134.147.153:7001'
);
INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'CONSOLE'
   , 'IRIPRODOWS-SEC'
   , 'http://10.134.147.154:7001'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'CONSOLE'
   , 'IRIDROWS-PRI'
   , 'http://10.161.147.149:7001'
);
INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'CONSOLE'
   , 'IRIDROWS-SEC'
   , 'http://10.161.147.150:7001'
);


INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIPRODOWS'
   , 'http://iriprodows.register-iri.com'
);
INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIDROWS'
   , 'http://iridrows.register-iri.com'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PATH'
   , 'INDIVIDUAL'
   , '/edq/webservices/Watchlist%20Screening:IndividualScreen'
);
INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PATH'
   , 'ENTITY'
   , '/edq/webservices/Watchlist%20Screening:EntityScreen'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PATH'
   , 'EDQ'
   , '/edq'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PATH'
   , 'CONSOLE'
   , '/console'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCER'
   , 'MAX_JOBS'
   , '100'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCER'
   , 'RATIO'
   , '2'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCE_SERVER'
   , 'IRIPROD'
   , 'IRIPRODOWS'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCE_SERVER'
   , 'IRITEST'
   , 'IRIDROWS'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCE_SERVER'
   , 'IRIDEV'
   , 'IRIDROWS'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PRIMARY_SERVER'
   , 'IRIPROD'
   , 'IRIPRODOWS-PRI'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PRIMARY_SERVER'
   , 'IRITEST'
   , 'IRIDROWS-PRI'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PRIMARY_SERVER'
   , 'IRIDEV'
   , 'IRIDROWS-PRI'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SECONDARY_SERVER'
   , 'IRIPROD'
   , 'IRIPRODOWS-SEC'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SECONDARY_SERVER'
   , 'IRITEST'
   , 'IRIDROWS-SEC'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'INSTANCE'
   , 'IRIDEV'
   , 'IRIDROWS'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'FREQUENCY'
   , 'IRIPROD'
   , 5
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'FREQUENCY'
   , 'IRITEST'
   , 10
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'FREQUENCY'
   , 'IRIDEV'
   , 10
);

DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://www.datanomic.com/ws">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:request>
         <!--Optional:-->
         <ws:ListSubKey>?</ws:ListSubKey>
         <!--Optional:-->
         <ws:ListRecordType>?</ws:ListRecordType>
         <!--Optional:-->
         <ws:ListRecordOrigin>?</ws:ListRecordOrigin>
         <!--Optional:-->
         <ws:CustId>?</ws:CustId>
         <!--Optional:-->
         <ws:CustSubId>?</ws:CustSubId>
         <!--Optional:-->
         <ws:PassportNumber>?</ws:PassportNumber>
         <!--Optional:-->
         <ws:NationalId>?</ws:NationalId>
         <!--Optional:-->
         <ws:Title>?</ws:Title>
         <!--Optional:-->
         <ws:FullName>?</ws:FullName>
         <!--Optional:-->
         <ws:GivenNames>?</ws:GivenNames>
         <!--Optional:-->
         <ws:FamilyName>?</ws:FamilyName>
         <!--Optional:-->
         <ws:NameType>?</ws:NameType>
         <!--Optional:-->
         <ws:NameQuality>?</ws:NameQuality>
         <!--Optional:-->
         <ws:PrimaryName>?</ws:PrimaryName>
         <!--Optional:-->
         <ws:OriginalScriptName>?</ws:OriginalScriptName>
         <!--Optional:-->
         <ws:Gender>?</ws:Gender>
         <!--Optional:-->
         <ws:DateOfBirth>?</ws:DateOfBirth>
         <!--Optional:-->
         <ws:YearOfBirth>?</ws:YearOfBirth>
         <!--Optional:-->
         <ws:Occupation>?</ws:Occupation>
         <!--Optional:-->
         <ws:Address1>?</ws:Address1>
         <!--Optional:-->
         <ws:Address2>?</ws:Address2>
         <!--Optional:-->
         <ws:Address3>?</ws:Address3>
         <!--Optional:-->
         <ws:Address4>?</ws:Address4>
         <!--Optional:-->
         <ws:City>?</ws:City>
         <!--Optional:-->
         <ws:State>?</ws:State>
         <!--Optional:-->
         <ws:PostalCode>?</ws:PostalCode>
         <!--Optional:-->
         <ws:AddressCountryCode>?</ws:AddressCountryCode>
         <!--Optional:-->
         <ws:ResidencyCountryCode>?</ws:ResidencyCountryCode>
         <!--Optional:-->
         <ws:CountryOfBirthCode>?</ws:CountryOfBirthCode>
         <!--Optional:-->
         <ws:NationalityCountryCodes>?</ws:NationalityCountryCodes>
         <!--Optional:-->
         <ws:ProfileHyperlink>?</ws:ProfileHyperlink>
         <!--Optional:-->
         <ws:RiskScore>?</ws:RiskScore>
         <!--Optional:-->
         <ws:DataConfidenceScore>?</ws:DataConfidenceScore>
         <!--Optional:-->
         <ws:DataConfidenceComment>?</ws:DataConfidenceComment>
         <!--Optional:-->
         <ws:CustomString1>?</ws:CustomString1>
         <!--Optional:-->
         <ws:CustomString2>?</ws:CustomString2>
         <!--Optional:-->
         <ws:CustomString3>?</ws:CustomString3>
         <!--Optional:-->
         <ws:CustomString4>?</ws:CustomString4>
         <!--Optional:-->
         <ws:CustomString5>?</ws:CustomString5>
         <!--Optional:-->
         <ws:CustomString6>?</ws:CustomString6>
         <!--Optional:-->
         <ws:CustomString7>?</ws:CustomString7>
         <!--Optional:-->
         <ws:CustomString8>?</ws:CustomString8>
         <!--Optional:-->
         <ws:CustomString9>?</ws:CustomString9>
         <!--Optional:-->
         <ws:CustomString10>?</ws:CustomString10>
         <!--Optional:-->
         <ws:CustomString11>?</ws:CustomString11>
         <!--Optional:-->
         <ws:CustomString12>?</ws:CustomString12>
         <!--Optional:-->
         <ws:CustomString13>?</ws:CustomString13>
         <!--Optional:-->
         <ws:CustomString14>?</ws:CustomString14>
         <!--Optional:-->
         <ws:CustomString15>?</ws:CustomString15>
         <!--Optional:-->
         <ws:CustomString16>?</ws:CustomString16>
         <!--Optional:-->
         <ws:CustomString17>?</ws:CustomString17>
         <!--Optional:-->
         <ws:CustomString18>?</ws:CustomString18>
         <!--Optional:-->
         <ws:CustomString19>?</ws:CustomString19>
         <!--Optional:-->
         <ws:CustomString20>?</ws:CustomString20>
         <!--Optional:-->
         <ws:CustomString21>?</ws:CustomString21>
         <!--Optional:-->
         <ws:CustomString22>?</ws:CustomString22>
         <!--Optional:-->
         <ws:CustomString23>?</ws:CustomString23>
         <!--Optional:-->
         <ws:CustomString24>?</ws:CustomString24>
         <!--Optional:-->
         <ws:CustomString25>?</ws:CustomString25>
         <!--Optional:-->
         <ws:CustomString26>?</ws:CustomString26>
         <!--Optional:-->
         <ws:CustomString27>?</ws:CustomString27>
         <!--Optional:-->
         <ws:CustomString28>?</ws:CustomString28>
         <!--Optional:-->
         <ws:CustomString29>?</ws:CustomString29>
         <!--Optional:-->
         <ws:CustomString30>?</ws:CustomString30>
         <!--Optional:-->
         <ws:CustomString31>?</ws:CustomString31>
         <!--Optional:-->
         <ws:CustomString32>?</ws:CustomString32>
         <!--Optional:-->
         <ws:CustomString33>?</ws:CustomString33>
         <!--Optional:-->
         <ws:CustomString34>?</ws:CustomString34>
         <!--Optional:-->
         <ws:CustomString35>?</ws:CustomString35>
         <!--Optional:-->
         <ws:CustomString36>?</ws:CustomString36>
         <!--Optional:-->
         <ws:CustomString37>?</ws:CustomString37>
         <!--Optional:-->
         <ws:CustomString38>?</ws:CustomString38>
         <!--Optional:-->
         <ws:CustomString39>?</ws:CustomString39>
         <!--Optional:-->
         <ws:CustomString40>?</ws:CustomString40>
         <!--Optional:-->
         <ws:CustomDate1>?</ws:CustomDate1>
         <!--Optional:-->
         <ws:CustomDate2>?</ws:CustomDate2>
         <!--Optional:-->
         <ws:CustomDate3>?</ws:CustomDate3>
         <!--Optional:-->
         <ws:CustomDate4>?</ws:CustomDate4>
         <!--Optional:-->
         <ws:CustomDate5>?</ws:CustomDate5>
         <!--Optional:-->
         <ws:CustomNumber1>?</ws:CustomNumber1>
         <!--Optional:-->
         <ws:CustomNumber2>?</ws:CustomNumber2>
         <!--Optional:-->
         <ws:CustomNumber3>?</ws:CustomNumber3>
         <!--Optional:-->
         <ws:CustomNumber4>?</ws:CustomNumber4>
         <!--Optional:-->
         <ws:CustomNumber5>?</ws:CustomNumber5>
      </ws:request>
   </soapenv:Body>
</soapenv:Envelope>'
   );

   INSERT INTO xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'REQUEST_INDIVIDUAL'
      , v_xml
   );

END;
/

DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://www.datanomic.com/ws">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:request>
         <!--Optional:-->
         <ws:ListSubKey>?</ws:ListSubKey>
         <!--Optional:-->
         <ws:ListRecordType>?</ws:ListRecordType>
         <!--Optional:-->
         <ws:ListRecordOrigin>?</ws:ListRecordOrigin>
         <!--Optional:-->
         <ws:CustId>?</ws:CustId>
         <!--Optional:-->
         <ws:CustSubId>?</ws:CustSubId>
         <!--Optional:-->
         <ws:RegistrationNumber>?</ws:RegistrationNumber>
         <!--Optional:-->
         <ws:EntityName>?</ws:EntityName>
         <!--Optional:-->
         <ws:NameType>?</ws:NameType>
         <!--Optional:-->
         <ws:NameQuality>?</ws:NameQuality>
         <!--Optional:-->
         <ws:PrimaryName>?</ws:PrimaryName>
         <!--Optional:-->
         <ws:OriginalScriptName>?</ws:OriginalScriptName>
         <!--Optional:-->
         <ws:AliasIsAcronym>?</ws:AliasIsAcronym>
         <!--Optional:-->
         <ws:Address1>?</ws:Address1>
         <!--Optional:-->
         <ws:Address2>?</ws:Address2>
         <!--Optional:-->
         <ws:Address3>?</ws:Address3>
         <!--Optional:-->
         <ws:Address4>?</ws:Address4>
         <!--Optional:-->
         <ws:City>?</ws:City>
         <!--Optional:-->
         <ws:State>?</ws:State>
         <!--Optional:-->
         <ws:PostalCode>?</ws:PostalCode>
         <!--Optional:-->
         <ws:AddressCountryCode>?</ws:AddressCountryCode>
         <!--Optional:-->
         <ws:RegistrationCountryCode>?</ws:RegistrationCountryCode>
         <!--Optional:-->
         <ws:OperatingCountryCodes>?</ws:OperatingCountryCodes>
         <!--Optional:-->
         <ws:ProfileHyperlink>?</ws:ProfileHyperlink>
         <!--Optional:-->
         <ws:RiskScore>?</ws:RiskScore>
         <!--Optional:-->
         <ws:DataConfidenceScore>?</ws:DataConfidenceScore>
         <!--Optional:-->
         <ws:DataConfidenceComment>?</ws:DataConfidenceComment>
         <!--Optional:-->
         <ws:CustomString1>?</ws:CustomString1>
         <!--Optional:-->
         <ws:CustomString2>?</ws:CustomString2>
         <!--Optional:-->
         <ws:CustomString3>?</ws:CustomString3>
         <!--Optional:-->
         <ws:CustomString4>?</ws:CustomString4>
         <!--Optional:-->
         <ws:CustomString5>?</ws:CustomString5>
         <!--Optional:-->
         <ws:CustomString6>?</ws:CustomString6>
         <!--Optional:-->
         <ws:CustomString7>?</ws:CustomString7>
         <!--Optional:-->
         <ws:CustomString8>?</ws:CustomString8>
         <!--Optional:-->
         <ws:CustomString9>?</ws:CustomString9>
         <!--Optional:-->
         <ws:CustomString10>?</ws:CustomString10>
         <!--Optional:-->
         <ws:CustomString11>?</ws:CustomString11>
         <!--Optional:-->
         <ws:CustomString12>?</ws:CustomString12>
         <!--Optional:-->
         <ws:CustomString13>?</ws:CustomString13>
         <!--Optional:-->
         <ws:CustomString14>?</ws:CustomString14>
         <!--Optional:-->
         <ws:CustomString15>?</ws:CustomString15>
         <!--Optional:-->
         <ws:CustomString16>?</ws:CustomString16>
         <!--Optional:-->
         <ws:CustomString17>?</ws:CustomString17>
         <!--Optional:-->
         <ws:CustomString18>?</ws:CustomString18>
         <!--Optional:-->
         <ws:CustomString19>?</ws:CustomString19>
         <!--Optional:-->
         <ws:CustomString20>?</ws:CustomString20>
         <!--Optional:-->
         <ws:CustomString21>?</ws:CustomString21>
         <!--Optional:-->
         <ws:CustomString22>?</ws:CustomString22>
         <!--Optional:-->
         <ws:CustomString23>?</ws:CustomString23>
         <!--Optional:-->
         <ws:CustomString24>?</ws:CustomString24>
         <!--Optional:-->
         <ws:CustomString25>?</ws:CustomString25>
         <!--Optional:-->
         <ws:CustomString26>?</ws:CustomString26>
         <!--Optional:-->
         <ws:CustomString27>?</ws:CustomString27>
         <!--Optional:-->
         <ws:CustomString28>?</ws:CustomString28>
         <!--Optional:-->
         <ws:CustomString29>?</ws:CustomString29>
         <!--Optional:-->
         <ws:CustomString30>?</ws:CustomString30>
         <!--Optional:-->
         <ws:CustomString31>?</ws:CustomString31>
         <!--Optional:-->
         <ws:CustomString32>?</ws:CustomString32>
         <!--Optional:-->
         <ws:CustomString33>?</ws:CustomString33>
         <!--Optional:-->
         <ws:CustomString34>?</ws:CustomString34>
         <!--Optional:-->
         <ws:CustomString35>?</ws:CustomString35>
         <!--Optional:-->
         <ws:CustomString36>?</ws:CustomString36>
         <!--Optional:-->
         <ws:CustomString37>?</ws:CustomString37>
         <!--Optional:-->
         <ws:CustomString38>?</ws:CustomString38>
         <!--Optional:-->
         <ws:CustomString39>?</ws:CustomString39>
         <!--Optional:-->
         <ws:CustomString40>?</ws:CustomString40>
         <!--Optional:-->
         <ws:CustomDate1>?</ws:CustomDate1>
         <!--Optional:-->
         <ws:CustomDate2>?</ws:CustomDate2>
         <!--Optional:-->
         <ws:CustomDate3>?</ws:CustomDate3>
         <!--Optional:-->
         <ws:CustomDate4>?</ws:CustomDate4>
         <!--Optional:-->
         <ws:CustomDate5>?</ws:CustomDate5>
         <!--Optional:-->
         <ws:CustomNumber1>?</ws:CustomNumber1>
         <!--Optional:-->
         <ws:CustomNumber2>?</ws:CustomNumber2>
         <!--Optional:-->
         <ws:CustomNumber3>?</ws:CustomNumber3>
         <!--Optional:-->
         <ws:CustomNumber4>?</ws:CustomNumber4>
         <!--Optional:-->
         <ws:CustomNumber5>?</ws:CustomNumber5>
      </ws:request>
   </soapenv:Body>
</soapenv:Envelope>	
'
   );

   INSERT INTO xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'REQUEST_ENTITY'
      , v_xml
   );

END;
/

DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:dn="http://www.datanomic.com/ws">
  <env:Header/>
  <env:Body>
    <dn:response>
      <dn:record>
        <dn:ListKey>?</dn:ListKey>
         <dn:ListSubKey>?</dn:ListSubKey>
         <dn:ListRecordType>?</dn:ListRecordType>
         <dn:ListRecordOrigin>?</dn:ListRecordOrigin>
         <dn:ListId>?</dn:ListId>
         <dn:ListGivenNames>?</dn:ListGivenNames>
         <dn:ListFamilyName>?</dn:ListFamilyName>
         <dn:ListFullName>?</dn:ListFullName>
         <dn:ListNameType>?</dn:ListNameType>
        <dn:ListPrimaryName>?</dn:ListPrimaryName>
        <dn:ListOriginalScriptName>?</dn:ListOriginalScriptName>
        <dn:ListDOB>?</dn:ListDOB>
        <dn:ListCity>?</dn:ListCity>
        <dn:ListCountry>?</dn:ListCountry>
        <dn:ListCountryOfBirth>?</dn:ListCountryOfBirth>
        <dn:ListNationality>?</dn:ListNationality>
        <dn:MatchRule>?</dn:MatchRule>
        <dn:MatchScore>?</dn:MatchScore>
        <dn:CaseKey>?</dn:CaseKey>
        <dn:AlertId>?</dn:AlertId>
        <dn:RiskScore>?</dn:RiskScore>
        <dn:RiskScorePEP>?</dn:RiskScorePEP>
      </dn:record>	
    </dn:response>
  </env:Body>
</env:Envelope>      
'
   );

   INSERT INTO xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'RESPONSE_INDIVIDUAL'
      , v_xml
   );

END;
/

DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:dn="http://www.datanomic.com/ws">
  <env:Header/>
  <env:Body>
    <dn:response>
      <dn:record>
        <dn:ListKey>?</dn:ListKey>
        <dn:ListSubKey>?</dn:ListSubKey>
        <dn:ListRecordType>?</dn:ListRecordType>
        <dn:ListRecordOrigin>?</dn:ListRecordOrigin>
        <dn:ListId>?</dn:ListId>
        <dn:ListEntityName>?</dn:ListEntityName>
        <dn:ListPrimaryName>?</dn:ListPrimaryName>
        <dn:ListOriginalScriptName>?</dn:ListOriginalScriptName>
        <dn:ListNameType>?</dn:ListNameType>
        <dn:ListCity>?</dn:ListCity>
        <dn:ListCountry>?</dn:ListCountry>
        <dn:ListOperatingCountries>?</dn:ListOperatingCountries>f
        <dn:ListRegistrationCountries>?</dn:ListRegistrationCountries>
        <dn:MatchRule>?</dn:MatchRule>
        <dn:MatchScore>?</dn:MatchScore>
        <dn:CaseKey>?</dn:CaseKey>
        <dn:AlertId>?</dn:AlertId>
        <dn:RiskScore>?</dn:RiskScore>
        <dn:RiskScorePEP>?</dn:RiskScorePEP>  
      </dn:record>	
    </dn:response>
  </env:Body>
</env:Envelope>      
'
   );

   INSERT INTO xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'RESPONSE_ENTITY'
      , v_xml
   );

END;
/

COMMIT;

DROP SEQUENCE xwrl_requests_seq;

DROP SEQUENCE xwrl_requests1_seq;
DROP SEQUENCE xwrl_requests2_seq;
DROP SEQUENCE xwrl_requests3_seq;
DROP SEQUENCE xwrl_requests4_seq;
DROP SEQUENCE xwrl_requests5_seq;
DROP SEQUENCE xwrl_requests6_seq;

DROP TABLE xwrl_keywords CASCADE CONSTRAINTS;

DROP TABLE xwrl_location_types CASCADE CONSTRAINTS;

DROP TABLE xwrl_parameters CASCADE CONSTRAINTS;

DROP TABLE xwrl_requests CASCADE CONSTRAINTS;

DROP TABLE xwrl_request_ind_columns CASCADE CONSTRAINTS;

DROP TABLE xwrl_request_entity_columns CASCADE CONSTRAINTS;

DROP TABLE xwrl_request_rows CASCADE CONSTRAINTS;

DROP TABLE xwrl_response_ind_columns CASCADE CONSTRAINTS;

DROP TABLE xwrl_response_entity_columns CASCADE CONSTRAINTS;

DROP TABLE xwrl_response_rows CASCADE CONSTRAINTS;

CREATE SEQUENCE xwrl_requests_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests1_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests2_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests3_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests4_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests5_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests6_seq START WITH 1000 NOCACHE;

CREATE TABLE xwrl_keywords (
   keyword_abbreviation   VARCHAR2 (30) NOT NULL
   , full_name_of_source    VARCHAR2 (500) NOT NULL
   , country_of_authority   VARCHAR2 (100)
   , type                   VARCHAR2 (50)
   , explanation            VARCHAR2 (3000) NOT NULL
   , last_update_date       DATE
   , last_updated_by        NUMBER (15)
   , creation_date          DATE
   , created_by             NUMBER (15)
   , last_update_login      NUMBER (15)
)
logging;

ALTER TABLE xwrl_keywords ADD CONSTRAINT xwrl_keywords_pk PRIMARY KEY (keyword_abbreviation);

CREATE TABLE xwrl_location_types (
   loc_type            VARCHAR2 (30) NOT NULL
   , country             VARCHAR2 (100) NOT NULL
   , full_name           VARCHAR2 (500) NOT NULL
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
logging;

ALTER TABLE xwrl_location_types ADD CONSTRAINT xwrl_location_types_pk PRIMARY KEY (loc_type);

CREATE TABLE xwrl_parameters (
   id                  VARCHAR2 (100) NOT NULL
   , key                 VARCHAR2 (500) NOT NULL
   , value_string        VARCHAR2 (500)
   , value_date          DATE
   , value_xml           XMLTYPE
   , value_clob          CLOB
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
LOGGING XMLTYPE COLUMN value_xml STORE AS BINARY XML (
   STORAGE (PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 BUFFER_POOL DEFAULT)
   RETENTION
   ENABLE STORAGE IN ROW
   NOCACHE
);

ALTER TABLE xwrl_parameters ADD CONSTRAINT xwrl_parameters_pk PRIMARY KEY (id
, key);

CREATE TABLE xwrl_requests (
    id                        INTEGER NOT NULL,
    resubmit_id               INTEGER,
    source_table              VARCHAR2(50),
    source_id                 NUMBER,
    wc_screening_request_id   NUMBER,
    server                    VARCHAR2(100),
    path                      VARCHAR2(100),
    soap_query varchar2(3000),
    request                   XMLTYPE,
    response                  XMLTYPE,
    job_id VARCHAR2(100),
    matches    INTEGER,
    status                    VARCHAR2(30),
    error_code                VARCHAR2(100),
    error_message             VARCHAR2(1000),
    last_update_date          DATE,
    last_updated_by           NUMBER(15),
    creation_date             DATE,
    created_by                NUMBER(15),
    last_update_login         NUMBER(15)
) XMLTYPE COLUMN request STORE AS BINARY XML (
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 BUFFER_POOL DEFAULT )
    RETENTION
    ENABLE STORAGE IN ROW
    NOCACHE
) XMLTYPE COLUMN response STORE AS BINARY XML (
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 BUFFER_POOL DEFAULT )
    RETENTION
    ENABLE STORAGE IN ROW
    NOCACHE
);

ALTER TABLE xwrl_requests ADD CONSTRAINT xwrl_requests_pk PRIMARY KEY (id);

CREATE OR REPLACE TRIGGER xwrl_requests BEFORE
   INSERT ON xwrl_requests
   FOR EACH ROW
BEGIN

   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests_seq.nextval;
   END IF;

END;
/


CREATE TABLE xwrl_request_ind_columns (
   id                        INTEGER NOT NULL
   , request_id                INTEGER NOT NULL
   , listsubkey                VARCHAR2 (2700)
   , listrecordtype            VARCHAR2 (2700)
   , listrecordorigin          VARCHAR2 (2700)
   , custid                    VARCHAR2 (2700)
   , custsubid                 VARCHAR2 (2700)
   , passportnumber            VARCHAR2 (2700)
   , nationalid                VARCHAR2 (2700)
   , title                     VARCHAR2 (2700)
   , fullname                  VARCHAR2 (2700)
   , givennames                VARCHAR2 (2700)
   , familyname                VARCHAR2 (2700)
   , nametype                  VARCHAR2 (2700)
   , namequality               VARCHAR2 (2700)
   , primaryname               VARCHAR2 (2700)
   , originalscriptname        VARCHAR2 (2700)
   , gender                    VARCHAR2 (2700)
   , dateofbirth               VARCHAR2 (2700)
   , yearofbirth               VARCHAR2 (2700)
   , occupation                VARCHAR2 (2700)
   , address1                  VARCHAR2 (2700)
   , address2                  VARCHAR2 (2700)
   , address3                  VARCHAR2 (2700)
   , address4                  VARCHAR2 (2700)
   , city                      VARCHAR2 (2700)
   , state                     VARCHAR2 (2700)
   , postalcode                VARCHAR2 (2700)
   , addresscountrycode        VARCHAR2 (2700)
   , residencycountrycode      VARCHAR2 (2700)
   , countryofbirthcode        VARCHAR2 (2700)
   , nationalitycountrycodes   VARCHAR2 (2700)
   , profilehyperlink          VARCHAR2 (2700)
   , riskscore                 VARCHAR2 (2700)
   , dataconfidencescore       VARCHAR2 (2700)
   , dataconfidencecomment     VARCHAR2 (2700)
   , customstring1             VARCHAR2 (2700)
   , customstring2             VARCHAR2 (2700)
   , customstring3             VARCHAR2 (2700)
   , customstring4             VARCHAR2 (2700)
   , customstring5             VARCHAR2 (2700)
   , customstring6             VARCHAR2 (2700)
   , customstring7             VARCHAR2 (2700)
   , customstring8             VARCHAR2 (2700)
   , customstring9             VARCHAR2 (2700)
   , customstring10            VARCHAR2 (2700)
   , customstring11            VARCHAR2 (2700)
   , customstring12            VARCHAR2 (2700)
   , customstring13            VARCHAR2 (2700)
   , customstring14            VARCHAR2 (2700)
   , customstring15            VARCHAR2 (2700)
   , customstring16            VARCHAR2 (2700)
   , customstring17            VARCHAR2 (2700)
   , customstring18            VARCHAR2 (2700)
   , customstring19            VARCHAR2 (2700)
   , customstring20            VARCHAR2 (2700)
   , customstring21            VARCHAR2 (2700)
   , customstring22            VARCHAR2 (2700)
   , customstring23            VARCHAR2 (2700)
   , customstring24            VARCHAR2 (2700)
   , customstring25            VARCHAR2 (2700)
   , customstring26            VARCHAR2 (2700)
   , customstring27            VARCHAR2 (2700)
   , customstring28            VARCHAR2 (2700)
   , customstring29            VARCHAR2 (2700)
   , customstring30            VARCHAR2 (2700)
   , customstring31            VARCHAR2 (2700)
   , customstring32            VARCHAR2 (2700)
   , customstring33            VARCHAR2 (2700)
   , customstring34            VARCHAR2 (2700)
   , customstring35            VARCHAR2 (2700)
   , customstring36            VARCHAR2 (2700)
   , customstring37            VARCHAR2 (2700)
   , customstring38            VARCHAR2 (2700)
   , customstring39            VARCHAR2 (2700)
   , customstring40            VARCHAR2 (2700)
   , customdate1               VARCHAR2 (2700)
   , customdate2               VARCHAR2 (2700)
   , customdate3               VARCHAR2 (2700)
   , customdate4               VARCHAR2 (2700)
   , customdate5               VARCHAR2 (2700)
   , customnumber1             VARCHAR2 (2700)
   , customnumber2             VARCHAR2 (2700)
   , customnumber3             VARCHAR2 (2700)
   , customnumber4             VARCHAR2 (2700)
   , customnumber5             VARCHAR2 (2700)
   , last_update_date          DATE
   , last_updated_by           NUMBER (15)
   , creation_date             DATE
   , created_by                NUMBER (15)
   , last_update_login         NUMBER (15)
)
logging;

CREATE TABLE xwrl_request_entity_columns (
   id                        INTEGER NOT NULL
   , request_id                INTEGER NOT NULL
   , listsubkey                VARCHAR2 (2700)
   , listrecordtype            VARCHAR2 (2700)
   , listrecordorigin          VARCHAR2 (2700)
   , custid                    VARCHAR2 (2700)
   , custsubid                 VARCHAR2 (2700)
   , registrationnumber        VARCHAR2 (2700)
   , entityname                VARCHAR2 (2700)
   , nametype                  VARCHAR2 (2700)
   , namequality               VARCHAR2 (2700)
   , primaryname               VARCHAR2 (2700)
   , originalscriptname        VARCHAR2 (2700)
   , aliasisacronym            VARCHAR2 (2700)
   , address1                  VARCHAR2 (2700)
   , address2                  VARCHAR2 (2700)
   , address3                  VARCHAR2 (2700)
   , address4                  VARCHAR2 (2700)
   , city                      VARCHAR2 (2700)
   , state                     VARCHAR2 (2700)
   , postalcode                VARCHAR2 (2700)
   , addresscountrycode        VARCHAR2 (2700)
   , registrationcountrycode   VARCHAR2 (2700)
   , operatingcountrycodes     VARCHAR2 (2700)
   , profilehyperlink          VARCHAR2 (2700)
   , riskscore                 VARCHAR2 (2700)
   , dataconfidencescore       VARCHAR2 (2700)
   , dataconfidencecomment     VARCHAR2 (2700)
   , customstring1             VARCHAR2 (2700)
   , customstring2             VARCHAR2 (2700)
   , customstring3             VARCHAR2 (2700)
   , customstring4             VARCHAR2 (2700)
   , customstring5             VARCHAR2 (2700)
   , customstring6             VARCHAR2 (2700)
   , customstring7             VARCHAR2 (2700)
   , customstring8             VARCHAR2 (2700)
   , customstring9             VARCHAR2 (2700)
   , customstring10            VARCHAR2 (2700)
   , customstring11            VARCHAR2 (2700)
   , customstring12            VARCHAR2 (2700)
   , customstring13            VARCHAR2 (2700)
   , customstring14            VARCHAR2 (2700)
   , customstring15            VARCHAR2 (2700)
   , customstring16            VARCHAR2 (2700)
   , customstring17            VARCHAR2 (2700)
   , customstring18            VARCHAR2 (2700)
   , customstring19            VARCHAR2 (2700)
   , customstring20            VARCHAR2 (2700)
   , customstring21            VARCHAR2 (2700)
   , customstring22            VARCHAR2 (2700)
   , customstring23            VARCHAR2 (2700)
   , customstring24            VARCHAR2 (2700)
   , customstring25            VARCHAR2 (2700)
   , customstring26            VARCHAR2 (2700)
   , customstring27            VARCHAR2 (2700)
   , customstring28            VARCHAR2 (2700)
   , customstring29            VARCHAR2 (2700)
   , customstring30            VARCHAR2 (2700)
   , customstring31            VARCHAR2 (2700)
   , customstring32            VARCHAR2 (2700)
   , customstring33            VARCHAR2 (2700)
   , customstring34            VARCHAR2 (2700)
   , customstring35            VARCHAR2 (2700)
   , customstring36            VARCHAR2 (2700)
   , customstring37            VARCHAR2 (2700)
   , customstring38            VARCHAR2 (2700)
   , customstring39            VARCHAR2 (2700)
   , customstring40            VARCHAR2 (2700)
   , customdate1               VARCHAR2 (2700)
   , customdate2               VARCHAR2 (2700)
   , customdate3               VARCHAR2 (2700)
   , customdate4               VARCHAR2 (2700)
   , customdate5               VARCHAR2 (2700)
   , customnumber1             VARCHAR2 (2700)
   , customnumber2             VARCHAR2 (2700)
   , customnumber3             VARCHAR2 (2700)
   , customnumber4             VARCHAR2 (2700)
   , customnumber5             VARCHAR2 (2700)
   , last_update_date          DATE
   , last_updated_by           NUMBER (15)
   , creation_date             DATE
   , created_by                NUMBER (15)
   , last_update_login         NUMBER (15)
)
logging;


CREATE TABLE xwrl_request_rows (
   id                  INTEGER NOT NULL
   , request_id          INTEGER NOT NULL
   , path                VARCHAR2 (50)
   , rw                  INTEGER
   , key                 VARCHAR2 (100)
   , value               VARCHAR2 (2700)
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
logging;

CREATE TABLE xwrl_response_ind_columns (
   id                       INTEGER NOT NULL
   , request_id               INTEGER NOT NULL
   , rec                      INTEGER NOT NULL
   , listkey                  VARCHAR2 (2700)
   , listsubkey               VARCHAR2 (2700)
   , listrecordtype           VARCHAR2 (2700)
   , listrecordorigin         VARCHAR2 (2700)
   , listid                   VARCHAR2 (2700)
   , listgivennames           VARCHAR2 (2700)
   , listfamilyname           VARCHAR2 (2700)
   , listfullname             VARCHAR2 (2700)
   , listnametype             VARCHAR2 (2700)
   , listprimaryname          VARCHAR2 (2700)
   , listoriginalscriptname   VARCHAR2 (2700)
   , listdob                  VARCHAR2 (2700)
   , listcity                 VARCHAR2 (2700)
   , listcountry              VARCHAR2 (2700)
   , listcountryofbirth       VARCHAR2 (2700)
   , listnationality          VARCHAR2 (2700)
   , matchrule                VARCHAR2 (2700)
   , matchscore               VARCHAR2 (2700)
   , casekey                  VARCHAR2 (2700)
   , alertid                  VARCHAR2 (2700)
   , riskscore                VARCHAR2 (2700)
   , riskscorepep             VARCHAR2 (2700)
   , last_update_date         DATE
   , last_updated_by          NUMBER (15)
   , creation_date            DATE
   , created_by               NUMBER (15)
   , last_update_login        NUMBER (15)
)
logging;

CREATE TABLE xwrl_response_entity_columns (
   id                          INTEGER NOT NULL
   , request_id                  INTEGER NOT NULL
   , rec                         INTEGER NOT NULL
   , listkey                     VARCHAR2 (2700)
   , listsubkey                  VARCHAR2 (2700)
   , listrecordtype              VARCHAR2 (2700)
   , listrecordorigin            VARCHAR2 (2700)
   , listid                      VARCHAR2 (2700)
   , listentityname              VARCHAR2 (2700)
   , listprimaryname             VARCHAR2 (2700)
   , listoriginalscriptname      VARCHAR2 (2700)
   , listnametype                VARCHAR2 (2700)
   , listcity                    VARCHAR2 (2700)
   , listcountry                 VARCHAR2 (2700)
   , listoperatingcountries      VARCHAR2 (2700)
   , listregistrationcountries   VARCHAR2 (2700)
   , matchrule                   VARCHAR2 (2700)
   , matchscore                  VARCHAR2 (2700)
   , casekey                     VARCHAR2 (2700)
   , alertid                     VARCHAR2 (2700)
   , riskscore                   VARCHAR2 (2700)
   , riskscorepep                VARCHAR2 (2700)
   , last_update_date            DATE
   , last_updated_by             NUMBER (15)
   , creation_date               DATE
   , created_by                  NUMBER (15)
   , last_update_login           NUMBER (15)
)
logging;

CREATE TABLE xwrl_response_rows (
   id                  INTEGER NOT NULL
   , request_id          INTEGER NOT NULL
   , path                VARCHAR2 (50)
   , ows_id              VARCHAR2 (500)
   , rec_row             INTEGER
   , det_row             INTEGER
   , key                 VARCHAR2 (100)
   , value               VARCHAR2 (2700)
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
logging;


ALTER TABLE xwrl_request_ind_columns ADD CONSTRAINT xwrl_request_ind_columns_pk PRIMARY KEY (id);
ALTER TABLE xwrl_request_entity_columns ADD CONSTRAINT xwrl_request_entity_columns_pk PRIMARY KEY (id);
ALTER TABLE xwrl_request_rows ADD CONSTRAINT xwrl_request_rows_pk PRIMARY KEY (id);
ALTER TABLE xwrl_response_ind_columns ADD CONSTRAINT xwrl_response_ind_columns_pk PRIMARY KEY (id);
ALTER TABLE xwrl_response_entity_columns ADD CONSTRAINT xwrl_response_entity_col_pk PRIMARY KEY (id);
ALTER TABLE xwrl_response_rows ADD CONSTRAINT xwrl_response_rows_pk PRIMARY KEY (id);


CREATE OR REPLACE TRIGGER xwrl_request_ind_columns BEFORE
   INSERT ON xwrl_request_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests1_seq.nextval;
   END IF;
END;
/
CREATE OR REPLACE TRIGGER xwrl_request_entity_columns BEFORE
   INSERT ON xwrl_request_entity_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests2_seq.nextval;
   END IF;
END;
/
CREATE OR REPLACE TRIGGER xwrl_request_rows BEFORE
   INSERT ON xwrl_request_rows
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests3_seq.nextval;
   END IF;
END;
/
CREATE OR REPLACE TRIGGER xwrl_response_ind_columns BEFORE
   INSERT ON xwrl_response_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests4_seq.nextval;
   END IF;
END;
/
CREATE OR REPLACE TRIGGER xwrl_response_entity_columns BEFORE
   INSERT ON xwrl_response_entity_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests5_seq.nextval;
   END IF;
END;
/
CREATE OR REPLACE TRIGGER xwrl_response_rows BEFORE
   INSERT ON xwrl_response_rows
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests6_seq.nextval;
   END IF;
END;
/

GRANT ALL ON xwrl_keywords TO apps;

GRANT ALL ON xwrl_location_types TO apps;

GRANT ALL ON xwrl_parameters TO apps;

GRANT ALL ON xwrl_requests TO apps;

GRANT ALL ON xwrl_request_ind_columns TO apps;
GRANT ALL ON xwrl_request_entity_columns TO apps;
GRANT ALL ON xwrl_request_rows TO apps;
GRANT ALL ON xwrl_response_ind_columns TO apps;
GRANT ALL ON xwrl_response_entity_columns TO apps;
GRANT ALL ON xwrl_response_rows TO apps;

GRANT ALL ON xwrl_requests_seq TO apps;

GRANT ALL ON xwrl_requests1_seq TO apps;
GRANT ALL ON xwrl_requests2_seq TO apps;
GRANT ALL ON xwrl_requests3_seq TO apps;
GRANT ALL ON xwrl_requests4_seq TO apps;
GRANT ALL ON xwrl_requests5_seq TO apps;
GRANT ALL ON xwrl_requests6_seq TO apps;

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'POC'
   , 'http://129.150.84.227:8001'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIPRODOWS-PRI'
   , 'http://10.134.147.153:8001'
);
INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIPRODOWS-SEC'
   , 'http://10.134.147.154:8001'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIDROWS-PRI'
   , 'http://10.161.147.149:8001'
);
INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIDROWS-SEC'
   , 'http://10.161.147.150:8001'
);


INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'CONSOLE'
   , 'IRIPRODOWS-PRI'
   , 'http://10.134.147.153:7001'
);
INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'CONSOLE'
   , 'IRIPRODOWS-SEC'
   , 'http://10.134.147.154:7001'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'CONSOLE'
   , 'IRIDROWS-PRI'
   , 'http://10.161.147.149:7001'
);
INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'CONSOLE'
   , 'IRIDROWS-SEC'
   , 'http://10.161.147.150:7001'
);


INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIPRODOWS'
   , 'http://iriprodows.register-iri.com'
);
INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIDROWS'
   , 'http://iridrows.register-iri.com'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PATH'
   , 'INDIVIDUAL'
   , '/edq/webservices/Watchlist%20Screening:IndividualScreen'
);
INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PATH'
   , 'ENTITY'
   , '/edq/webservices/Watchlist%20Screening:EntityScreen'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PATH'
   , 'EDQ'
   , '/edq'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PATH'
   , 'CONSOLE'
   , '/console'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCER'
   , 'MAX_JOBS'
   , '100'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCER'
   , 'RATIO'
   , '2'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCE_SERVER'
   , 'IRIPROD'
   , 'IRIPRODOWS'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCE_SERVER'
   , 'IRITEST'
   , 'IRIDROWS'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCE_SERVER'
   , 'IRIDEV'
   , 'IRIDROWS'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PRIMARY_SERVER'
   , 'IRIPROD'
   , 'IRIPRODOWS-PRI'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PRIMARY_SERVER'
   , 'IRITEST'
   , 'IRIDROWS-PRI'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PRIMARY_SERVER'
   , 'IRIDEV'
   , 'IRIDROWS-PRI'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SECONDARY_SERVER'
   , 'IRIPROD'
   , 'IRIPRODOWS-SEC'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SECONDARY_SERVER'
   , 'IRITEST'
   , 'IRIDROWS-SEC'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'INSTANCE'
   , 'IRIDEV'
   , 'IRIDROWS'
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'FREQUENCY'
   , 'IRIPROD'
   , 5
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'FREQUENCY'
   , 'IRITEST'
   , 10
);

INSERT INTO xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'FREQUENCY'
   , 'IRIDEV'
   , 10
);

DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://www.datanomic.com/ws">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:request>
         <!--Optional:-->
         <ws:ListSubKey>?</ws:ListSubKey>
         <!--Optional:-->
         <ws:ListRecordType>?</ws:ListRecordType>
         <!--Optional:-->
         <ws:ListRecordOrigin>?</ws:ListRecordOrigin>
         <!--Optional:-->
         <ws:CustId>?</ws:CustId>
         <!--Optional:-->
         <ws:CustSubId>?</ws:CustSubId>
         <!--Optional:-->
         <ws:PassportNumber>?</ws:PassportNumber>
         <!--Optional:-->
         <ws:NationalId>?</ws:NationalId>
         <!--Optional:-->
         <ws:Title>?</ws:Title>
         <!--Optional:-->
         <ws:FullName>?</ws:FullName>
         <!--Optional:-->
         <ws:GivenNames>?</ws:GivenNames>
         <!--Optional:-->
         <ws:FamilyName>?</ws:FamilyName>
         <!--Optional:-->
         <ws:NameType>?</ws:NameType>
         <!--Optional:-->
         <ws:NameQuality>?</ws:NameQuality>
         <!--Optional:-->
         <ws:PrimaryName>?</ws:PrimaryName>
         <!--Optional:-->
         <ws:OriginalScriptName>?</ws:OriginalScriptName>
         <!--Optional:-->
         <ws:Gender>?</ws:Gender>
         <!--Optional:-->
         <ws:DateOfBirth>?</ws:DateOfBirth>
         <!--Optional:-->
         <ws:YearOfBirth>?</ws:YearOfBirth>
         <!--Optional:-->
         <ws:Occupation>?</ws:Occupation>
         <!--Optional:-->
         <ws:Address1>?</ws:Address1>
         <!--Optional:-->
         <ws:Address2>?</ws:Address2>
         <!--Optional:-->
         <ws:Address3>?</ws:Address3>
         <!--Optional:-->
         <ws:Address4>?</ws:Address4>
         <!--Optional:-->
         <ws:City>?</ws:City>
         <!--Optional:-->
         <ws:State>?</ws:State>
         <!--Optional:-->
         <ws:PostalCode>?</ws:PostalCode>
         <!--Optional:-->
         <ws:AddressCountryCode>?</ws:AddressCountryCode>
         <!--Optional:-->
         <ws:ResidencyCountryCode>?</ws:ResidencyCountryCode>
         <!--Optional:-->
         <ws:CountryOfBirthCode>?</ws:CountryOfBirthCode>
         <!--Optional:-->
         <ws:NationalityCountryCodes>?</ws:NationalityCountryCodes>
         <!--Optional:-->
         <ws:ProfileHyperlink>?</ws:ProfileHyperlink>
         <!--Optional:-->
         <ws:RiskScore>?</ws:RiskScore>
         <!--Optional:-->
         <ws:DataConfidenceScore>?</ws:DataConfidenceScore>
         <!--Optional:-->
         <ws:DataConfidenceComment>?</ws:DataConfidenceComment>
         <!--Optional:-->
         <ws:CustomString1>?</ws:CustomString1>
         <!--Optional:-->
         <ws:CustomString2>?</ws:CustomString2>
         <!--Optional:-->
         <ws:CustomString3>?</ws:CustomString3>
         <!--Optional:-->
         <ws:CustomString4>?</ws:CustomString4>
         <!--Optional:-->
         <ws:CustomString5>?</ws:CustomString5>
         <!--Optional:-->
         <ws:CustomString6>?</ws:CustomString6>
         <!--Optional:-->
         <ws:CustomString7>?</ws:CustomString7>
         <!--Optional:-->
         <ws:CustomString8>?</ws:CustomString8>
         <!--Optional:-->
         <ws:CustomString9>?</ws:CustomString9>
         <!--Optional:-->
         <ws:CustomString10>?</ws:CustomString10>
         <!--Optional:-->
         <ws:CustomString11>?</ws:CustomString11>
         <!--Optional:-->
         <ws:CustomString12>?</ws:CustomString12>
         <!--Optional:-->
         <ws:CustomString13>?</ws:CustomString13>
         <!--Optional:-->
         <ws:CustomString14>?</ws:CustomString14>
         <!--Optional:-->
         <ws:CustomString15>?</ws:CustomString15>
         <!--Optional:-->
         <ws:CustomString16>?</ws:CustomString16>
         <!--Optional:-->
         <ws:CustomString17>?</ws:CustomString17>
         <!--Optional:-->
         <ws:CustomString18>?</ws:CustomString18>
         <!--Optional:-->
         <ws:CustomString19>?</ws:CustomString19>
         <!--Optional:-->
         <ws:CustomString20>?</ws:CustomString20>
         <!--Optional:-->
         <ws:CustomString21>?</ws:CustomString21>
         <!--Optional:-->
         <ws:CustomString22>?</ws:CustomString22>
         <!--Optional:-->
         <ws:CustomString23>?</ws:CustomString23>
         <!--Optional:-->
         <ws:CustomString24>?</ws:CustomString24>
         <!--Optional:-->
         <ws:CustomString25>?</ws:CustomString25>
         <!--Optional:-->
         <ws:CustomString26>?</ws:CustomString26>
         <!--Optional:-->
         <ws:CustomString27>?</ws:CustomString27>
         <!--Optional:-->
         <ws:CustomString28>?</ws:CustomString28>
         <!--Optional:-->
         <ws:CustomString29>?</ws:CustomString29>
         <!--Optional:-->
         <ws:CustomString30>?</ws:CustomString30>
         <!--Optional:-->
         <ws:CustomString31>?</ws:CustomString31>
         <!--Optional:-->
         <ws:CustomString32>?</ws:CustomString32>
         <!--Optional:-->
         <ws:CustomString33>?</ws:CustomString33>
         <!--Optional:-->
         <ws:CustomString34>?</ws:CustomString34>
         <!--Optional:-->
         <ws:CustomString35>?</ws:CustomString35>
         <!--Optional:-->
         <ws:CustomString36>?</ws:CustomString36>
         <!--Optional:-->
         <ws:CustomString37>?</ws:CustomString37>
         <!--Optional:-->
         <ws:CustomString38>?</ws:CustomString38>
         <!--Optional:-->
         <ws:CustomString39>?</ws:CustomString39>
         <!--Optional:-->
         <ws:CustomString40>?</ws:CustomString40>
         <!--Optional:-->
         <ws:CustomDate1>?</ws:CustomDate1>
         <!--Optional:-->
         <ws:CustomDate2>?</ws:CustomDate2>
         <!--Optional:-->
         <ws:CustomDate3>?</ws:CustomDate3>
         <!--Optional:-->
         <ws:CustomDate4>?</ws:CustomDate4>
         <!--Optional:-->
         <ws:CustomDate5>?</ws:CustomDate5>
         <!--Optional:-->
         <ws:CustomNumber1>?</ws:CustomNumber1>
         <!--Optional:-->
         <ws:CustomNumber2>?</ws:CustomNumber2>
         <!--Optional:-->
         <ws:CustomNumber3>?</ws:CustomNumber3>
         <!--Optional:-->
         <ws:CustomNumber4>?</ws:CustomNumber4>
         <!--Optional:-->
         <ws:CustomNumber5>?</ws:CustomNumber5>
      </ws:request>
   </soapenv:Body>
</soapenv:Envelope>'
   );

   INSERT INTO xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'REQUEST_INDIVIDUAL'
      , v_xml
   );

END;
/

DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://www.datanomic.com/ws">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:request>
         <!--Optional:-->
         <ws:ListSubKey>?</ws:ListSubKey>
         <!--Optional:-->
         <ws:ListRecordType>?</ws:ListRecordType>
         <!--Optional:-->
         <ws:ListRecordOrigin>?</ws:ListRecordOrigin>
         <!--Optional:-->
         <ws:CustId>?</ws:CustId>
         <!--Optional:-->
         <ws:CustSubId>?</ws:CustSubId>
         <!--Optional:-->
         <ws:RegistrationNumber>?</ws:RegistrationNumber>
         <!--Optional:-->
         <ws:EntityName>?</ws:EntityName>
         <!--Optional:-->
         <ws:NameType>?</ws:NameType>
         <!--Optional:-->
         <ws:NameQuality>?</ws:NameQuality>
         <!--Optional:-->
         <ws:PrimaryName>?</ws:PrimaryName>
         <!--Optional:-->
         <ws:OriginalScriptName>?</ws:OriginalScriptName>
         <!--Optional:-->
         <ws:AliasIsAcronym>?</ws:AliasIsAcronym>
         <!--Optional:-->
         <ws:Address1>?</ws:Address1>
         <!--Optional:-->
         <ws:Address2>?</ws:Address2>
         <!--Optional:-->
         <ws:Address3>?</ws:Address3>
         <!--Optional:-->
         <ws:Address4>?</ws:Address4>
         <!--Optional:-->
         <ws:City>?</ws:City>
         <!--Optional:-->
         <ws:State>?</ws:State>
         <!--Optional:-->
         <ws:PostalCode>?</ws:PostalCode>
         <!--Optional:-->
         <ws:AddressCountryCode>?</ws:AddressCountryCode>
         <!--Optional:-->
         <ws:RegistrationCountryCode>?</ws:RegistrationCountryCode>
         <!--Optional:-->
         <ws:OperatingCountryCodes>?</ws:OperatingCountryCodes>
         <!--Optional:-->
         <ws:ProfileHyperlink>?</ws:ProfileHyperlink>
         <!--Optional:-->
         <ws:RiskScore>?</ws:RiskScore>
         <!--Optional:-->
         <ws:DataConfidenceScore>?</ws:DataConfidenceScore>
         <!--Optional:-->
         <ws:DataConfidenceComment>?</ws:DataConfidenceComment>
         <!--Optional:-->
         <ws:CustomString1>?</ws:CustomString1>
         <!--Optional:-->
         <ws:CustomString2>?</ws:CustomString2>
         <!--Optional:-->
         <ws:CustomString3>?</ws:CustomString3>
         <!--Optional:-->
         <ws:CustomString4>?</ws:CustomString4>
         <!--Optional:-->
         <ws:CustomString5>?</ws:CustomString5>
         <!--Optional:-->
         <ws:CustomString6>?</ws:CustomString6>
         <!--Optional:-->
         <ws:CustomString7>?</ws:CustomString7>
         <!--Optional:-->
         <ws:CustomString8>?</ws:CustomString8>
         <!--Optional:-->
         <ws:CustomString9>?</ws:CustomString9>
         <!--Optional:-->
         <ws:CustomString10>?</ws:CustomString10>
         <!--Optional:-->
         <ws:CustomString11>?</ws:CustomString11>
         <!--Optional:-->
         <ws:CustomString12>?</ws:CustomString12>
         <!--Optional:-->
         <ws:CustomString13>?</ws:CustomString13>
         <!--Optional:-->
         <ws:CustomString14>?</ws:CustomString14>
         <!--Optional:-->
         <ws:CustomString15>?</ws:CustomString15>
         <!--Optional:-->
         <ws:CustomString16>?</ws:CustomString16>
         <!--Optional:-->
         <ws:CustomString17>?</ws:CustomString17>
         <!--Optional:-->
         <ws:CustomString18>?</ws:CustomString18>
         <!--Optional:-->
         <ws:CustomString19>?</ws:CustomString19>
         <!--Optional:-->
         <ws:CustomString20>?</ws:CustomString20>
         <!--Optional:-->
         <ws:CustomString21>?</ws:CustomString21>
         <!--Optional:-->
         <ws:CustomString22>?</ws:CustomString22>
         <!--Optional:-->
         <ws:CustomString23>?</ws:CustomString23>
         <!--Optional:-->
         <ws:CustomString24>?</ws:CustomString24>
         <!--Optional:-->
         <ws:CustomString25>?</ws:CustomString25>
         <!--Optional:-->
         <ws:CustomString26>?</ws:CustomString26>
         <!--Optional:-->
         <ws:CustomString27>?</ws:CustomString27>
         <!--Optional:-->
         <ws:CustomString28>?</ws:CustomString28>
         <!--Optional:-->
         <ws:CustomString29>?</ws:CustomString29>
         <!--Optional:-->
         <ws:CustomString30>?</ws:CustomString30>
         <!--Optional:-->
         <ws:CustomString31>?</ws:CustomString31>
         <!--Optional:-->
         <ws:CustomString32>?</ws:CustomString32>
         <!--Optional:-->
         <ws:CustomString33>?</ws:CustomString33>
         <!--Optional:-->
         <ws:CustomString34>?</ws:CustomString34>
         <!--Optional:-->
         <ws:CustomString35>?</ws:CustomString35>
         <!--Optional:-->
         <ws:CustomString36>?</ws:CustomString36>
         <!--Optional:-->
         <ws:CustomString37>?</ws:CustomString37>
         <!--Optional:-->
         <ws:CustomString38>?</ws:CustomString38>
         <!--Optional:-->
         <ws:CustomString39>?</ws:CustomString39>
         <!--Optional:-->
         <ws:CustomString40>?</ws:CustomString40>
         <!--Optional:-->
         <ws:CustomDate1>?</ws:CustomDate1>
         <!--Optional:-->
         <ws:CustomDate2>?</ws:CustomDate2>
         <!--Optional:-->
         <ws:CustomDate3>?</ws:CustomDate3>
         <!--Optional:-->
         <ws:CustomDate4>?</ws:CustomDate4>
         <!--Optional:-->
         <ws:CustomDate5>?</ws:CustomDate5>
         <!--Optional:-->
         <ws:CustomNumber1>?</ws:CustomNumber1>
         <!--Optional:-->
         <ws:CustomNumber2>?</ws:CustomNumber2>
         <!--Optional:-->
         <ws:CustomNumber3>?</ws:CustomNumber3>
         <!--Optional:-->
         <ws:CustomNumber4>?</ws:CustomNumber4>
         <!--Optional:-->
         <ws:CustomNumber5>?</ws:CustomNumber5>
      </ws:request>
   </soapenv:Body>
</soapenv:Envelope>	
'
   );

   INSERT INTO xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'REQUEST_ENTITY'
      , v_xml
   );

END;
/

DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:dn="http://www.datanomic.com/ws">
  <env:Header/>
  <env:Body>
    <dn:response>
      <dn:record>
        <dn:ListKey>?</dn:ListKey>
         <dn:ListSubKey>?</dn:ListSubKey>
         <dn:ListRecordType>?</dn:ListRecordType>
         <dn:ListRecordOrigin>?</dn:ListRecordOrigin>
         <dn:ListId>?</dn:ListId>
         <dn:ListGivenNames>?</dn:ListGivenNames>
         <dn:ListFamilyName>?</dn:ListFamilyName>
         <dn:ListFullName>?</dn:ListFullName>
         <dn:ListNameType>?</dn:ListNameType>
        <dn:ListPrimaryName>?</dn:ListPrimaryName>
        <dn:ListOriginalScriptName>?</dn:ListOriginalScriptName>
        <dn:ListDOB>?</dn:ListDOB>
        <dn:ListCity>?</dn:ListCity>
        <dn:ListCountry>?</dn:ListCountry>
        <dn:ListCountryOfBirth>?</dn:ListCountryOfBirth>
        <dn:ListNationality>?</dn:ListNationality>
        <dn:MatchRule>?</dn:MatchRule>
        <dn:MatchScore>?</dn:MatchScore>
        <dn:CaseKey>?</dn:CaseKey>
        <dn:AlertId>?</dn:AlertId>
        <dn:RiskScore>?</dn:RiskScore>
        <dn:RiskScorePEP>?</dn:RiskScorePEP>
      </dn:record>	
    </dn:response>
  </env:Body>
</env:Envelope>      
'
   );

   INSERT INTO xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'RESPONSE_INDIVIDUAL'
      , v_xml
   );

END;
/

DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:dn="http://www.datanomic.com/ws">
  <env:Header/>
  <env:Body>
    <dn:response>
      <dn:record>
        <dn:ListKey>?</dn:ListKey>
        <dn:ListSubKey>?</dn:ListSubKey>
        <dn:ListRecordType>?</dn:ListRecordType>
        <dn:ListRecordOrigin>?</dn:ListRecordOrigin>
        <dn:ListId>?</dn:ListId>
        <dn:ListEntityName>?</dn:ListEntityName>
        <dn:ListPrimaryName>?</dn:ListPrimaryName>
        <dn:ListOriginalScriptName>?</dn:ListOriginalScriptName>
        <dn:ListNameType>?</dn:ListNameType>
        <dn:ListCity>?</dn:ListCity>
        <dn:ListCountry>?</dn:ListCountry>
        <dn:ListOperatingCountries>?</dn:ListOperatingCountries>f
        <dn:ListRegistrationCountries>?</dn:ListRegistrationCountries>
        <dn:MatchRule>?</dn:MatchRule>
        <dn:MatchScore>?</dn:MatchScore>
        <dn:CaseKey>?</dn:CaseKey>
        <dn:AlertId>?</dn:AlertId>
        <dn:RiskScore>?</dn:RiskScore>
        <dn:RiskScorePEP>?</dn:RiskScorePEP>  
      </dn:record>	
    </dn:response>
  </env:Body>
</env:Envelope>      
'
   );

   INSERT INTO xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'RESPONSE_ENTITY'
      , v_xml
   );

END;
/

COMMIT;
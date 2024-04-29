DROP SEQUENCE xwrl_alert_documents_seq;
DROP SEQUENCE xwrl_case_documents_seq;

CREATE SEQUENCE xwrl.xwrl_alert_documents_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl.xwrl_case_documents_seq START WITH 1000 NOCACHE;

DROP TABLE xwrl_alert_documents;

DROP TABLE xwrl_case_documents;

CREATE TABLE xwrl_alert_documents (
    id                  INTEGER NOT NULL,
    request_id          INTEGER NOT NULL,
    alert_id            VARCHAR2(50) NOT NULL,
    edoc_id             INTEGER,
    document_file  VARCHAR2(500),
    document_name       VARCHAR2(500),
    document_category   VARCHAR2(100),
    document_type       VARCHAR2(100),
    file_name           VARCHAR2(500) NOT NULL,
    file_path           VARCHAR2(500),
    content_type        VARCHAR2(500),
    image_file  VARCHAR2(500),
    image_name  VARCHAR2(500),
    image_path  VARCHAR2(500),
    url_path            VARCHAR2(500),
    "COMMENT"           VARCHAR2(500),
    last_update_date    DATE,
    last_updated_by     NUMBER(15),
    creation_date       DATE,
    created_by          NUMBER(15),
    last_update_login   NUMBER(15)
)
logging;

CREATE TABLE xwrl_case_documents (
    id                  INTEGER NOT NULL,
    request_id          INTEGER NOT NULL,
    case_id             VARCHAR2(50) NOT NULL,
    edoc_id             INTEGER,
    document_file  VARCHAR2(500),
    document_name       VARCHAR2(500),
    document_category   VARCHAR2(100),
    document_type       VARCHAR2(100),
    file_name           VARCHAR2(500) NOT NULL,
    file_path           VARCHAR2(500),
    content_type        VARCHAR2(500),
    image_file  VARCHAR2(500),
    image_name  VARCHAR2(500),
    image_path  VARCHAR2(500),
    url_path            VARCHAR2(500),
    "COMMENT"           VARCHAR2(500),
    last_update_date    DATE,
    last_updated_by     NUMBER(15),
    creation_date       DATE,
    created_by          NUMBER(15),
    last_update_login   NUMBER(15)
)
logging;

CREATE OR REPLACE TRIGGER xwrl.xwrl_resp_ind_col_trg BEFORE
   INSERT ON xwrl.xwrl_response_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl.xwrl_requests4_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl.xwrl_resp_ind_col_trg BEFORE
   INSERT ON xwrl.xwrl_response_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl.xwrl_requests4_seq.nextval;
   END IF;
END;
/


ALTER TABLE xwrl_alert_documents ADD CONSTRAINT xwrl_alert_documents_pk PRIMARY KEY ( id );
ALTER TABLE xwrl_case_documents ADD CONSTRAINT xwrl_case_documents_pk PRIMARY KEY ( id );

CREATE INDEX xwrl.xwrl_alert_documents_idx ON    xwrl.xwrl_alert_documents ( request_id desc   , id   DESC);
CREATE INDEX xwrl.xwrl_case_documents_idx ON    xwrl.xwrl_case_documents ( request_id desc   , id   DESC);

GRANT ALL ON xwrl.xwrl_alert_documents TO apps;
GRANT ALL ON xwrl.xwrl_alert_documents_seq TO apps;
GRANT ALL ON xwrl.xwrl_case_documents TO apps;
GRANT ALL ON xwrl.xwrl_case_documents_seq TO apps;

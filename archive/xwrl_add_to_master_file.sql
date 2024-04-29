DROP SEQUENCE xwrl_party_alias_seq;
DROP SEQUENCE xwrl_party_xref_seq;

DROP TABLE xwrl_party_alias;
DROP TABLE xwrl_party_xref;


CREATE SEQUENCE xwrl_party_alias_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_party_xref_seq START WITH 1000 NOCACHE;

CREATE TABLE xwrl_party_alias (
   id                     INTEGER NOT NULL
   , parent_id integer
   , relationship_type      VARCHAR2 (10) NOT NULL
   , entity_type           VARCHAR2 (100) NOT NULL   
   , status                 VARCHAR2 (100) NOT NULL
   , source_table           VARCHAR2 (50)
   , source_table_column    VARCHAR2 (50)
   , source_id              NUMBER
   , full_name              VARCHAR2 (2700)
   , family_name            VARCHAR2 (2700)
   , given_name             VARCHAR2 (2700)
   , date_of_birth          VARCHAR2 (2700)
   , sex varchar2(100)
   , imo_number             INTEGER
   , department             VARCHAR2 (100)
   , office                 VARCHAR2 (100)
   , priority               VARCHAR2 (10)
   , risk_level             VARCHAR2 (10)
   , document_type          VARCHAR2 (100)
   , closed_date            DATE
   , assigned_to            NUMBER (15)
   , vessel_indicator       VARCHAR2 (10)
   , passport_number VARCHAR2 (2700)
    ,passport_issuing_country_code VARCHAR2 (10)
    ,citizenship_country_code   VARCHAR2 (10)   
   , country_of_residence   VARCHAR2 (10)
   , city_of_residence_id   NUMBER
   , sort_order             INTEGER
   , last_update_date       DATE
   , last_updated_by        NUMBER (15)
   , creation_date          DATE
   , created_by             NUMBER (15)
   , last_update_login      NUMBER (15)
)
logging;



CREATE TABLE xwrl_party_xref (
   id                         INTEGER NOT NULL
   , relationship_type          VARCHAR2 (50) NOT NULL
   , status                     VARCHAR2 (100) NOT NULL
   , entity_type           VARCHAR2 (100) NOT NULL
   , source_table               VARCHAR2 (50)
   , source_table_column        VARCHAR2 (50)
   , source_id                  NUMBER
   , xref_source_table          VARCHAR2 (50)
   , xref_source_table_column   VARCHAR2 (50)
   , xref_source_id             NUMBER
   , date_of_birth              VARCHAR2 (2700)
   , sex varchar2(100)   
   , imo_number                 INTEGER
   , department                 VARCHAR2 (100)
   , office                     VARCHAR2 (100)
   , priority                   VARCHAR2 (10)
   , risk_level                 VARCHAR2 (10)
   , document_type              VARCHAR2 (100)
   , closed_date                DATE
   , assigned_to                NUMBER (15)
   , vessel_indicator           VARCHAR2 (10)
   , passport_number VARCHAR2 (2700)
    ,passport_issuing_country_code VARCHAR2 (10)
    ,citizenship_country_code   VARCHAR2 (10)   
   , country_of_residence       VARCHAR2 (10)
   , city_of_residence_id       NUMBER
   , note                       VARCHAR2 (4000)
   , last_update_date           DATE
   , last_updated_by            NUMBER (15)
   , creation_date              DATE
   , created_by                 NUMBER (15)
   , last_update_login          NUMBER (15)
)
logging;


CREATE OR REPLACE TRIGGER xwrl_party_alias BEFORE
   INSERT ON xwrl_party_alias
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_party_alias_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_party_xref_trg BEFORE
   INSERT ON xwrl_party_xref
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_party_xref_seq.nextval;
   END IF;
END;
/

ALTER TABLE xwrl_party_alias ADD CONSTRAINT xwrl_party_alias_pk PRIMARY KEY (id);
ALTER TABLE xwrl_party_xref ADD CONSTRAINT xwrl_party_xref_pk PRIMARY KEY (id);

CREATE INDEX xwrl_party_alias_idx1 ON
   xwrl_party_alias (
      source_table
   , source_id
   );
CREATE INDEX xwrl_party_xref_idx1 ON
   xwrl_party_xref (
      source_table
   , source_id
   );
CREATE INDEX xwrl_party_xref_idx2 ON
   xwrl_party_xref (
      xref_source_table
   , xref_source_id
   );



GRANT ALL ON xwrl_party_alias TO apps;
GRANT ALL ON xwrl_party_xref TO apps;
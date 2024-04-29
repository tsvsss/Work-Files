drop index xwrl.xwrl_note_xref_idx1;
drop index xwrl.xwrl_note_xref_idx2;
drop index xwrl.xwrl_note_xref_idx3;

DROP SEQUENCE xwrl.xwrl_note_xref_seq;

DROP TABLE xwrl.xwrl_note_xref CASCADE CONSTRAINTS;

CREATE SEQUENCE xwrl.xwrl_note_xref_seq START WITH 1000 NOCACHE;

CREATE TABLE xwrl.xwrl_note_xref (
   id                        INTEGER NOT NULL
   , note_id             		NUMBER NOT NULL
   , request_id                INTEGER
   , alert_id                  VARCHAR2 (50)     
   , line_number				NUMBER
   , case_key                  VARCHAR2 (50)
   , master_id   				NUMBER
   , alias_id             		NUMBER
   , xref_id             		NUMBER
   , source_table              VARCHAR2 (50) 
   , source_table_column       VARCHAR2 (50)
   , source_id                 NUMBER 
   , list_id                   INTEGER NOT NULL   
   , from_state                VARCHAR2 (100)
   , to_state                  VARCHAR2 (100)
   , enabled_flag				VARCHAR2(1)
   , status                    VARCHAR2 (50)
   , record_comment                   VARCHAR2 (500)
   , last_update_date          DATE
   , last_updated_by           NUMBER (15)
   , creation_date             DATE
   , created_by                NUMBER (15)
   , last_update_login         NUMBER (15)
);

CREATE OR REPLACE TRIGGER xwrl.xwrl_note_xref_trg BEFORE
   INSERT ON xwrl.xwrl_note_xref
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl.xwrl_note_xref_seq.nextval;
   END IF;
   
END;
/

ALTER TABLE xwrl.xwrl_note_xref ADD CONSTRAINT xwrl_note_xref_pk PRIMARY KEY (id);

CREATE INDEX xwrl.xwrl_note_xref_idx1 ON
   xwrl.xwrl_note_xref (
      note_id, master_id
   )
      TABLESPACE apps_ts_tx_idx;
	  
CREATE INDEX xwrl.xwrl_note_xref_idx2 ON
   xwrl.xwrl_note_xref (
      note_id, master_id, alias_id
   )
      TABLESPACE apps_ts_tx_idx;	  
	  
CREATE INDEX xwrl.xwrl_note_xref_idx3 ON
   xwrl.xwrl_note_xref (
      note_id, master_id, xref_id
   )
      TABLESPACE apps_ts_tx_idx;		  
	  
grant all on xwrl.xwrl_note_xref_seq to apps;
grant all on xwrl.xwrl_note_xref to apps;

grant select on xwrl.xwrl_note_xref_seq to appsro;
grant select on xwrl.xwrl_note_xref to appsro;
CREATE OR REPLACE TRIGGER XWRL_ALRT_CLR_XRF_AFT_IUD_TRG
AFTER INSERT OR UPDATE OR DELETE ON XWRL_ALERT_CLEARING_XREF
FOR EACH ROW
DECLARE

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_ALERT_CLEARING_XREF'
and data_type not in  ('XMLTYPE')
and column_name not in  ('SOAP_QUERY');

v_rec XWRL_AUDIT_LOG%rowtype;
p_row_action varchar2(20);
v_user_id  NUMBER  := apps.fnd_profile.value('USER_ID');
v_login_id NUMBER  := apps.fnd_profile.value('LOGIN_ID');
v_rec XWRL_AUDIT_LOG%rowtype;
v_rec.creation_date     := SYSDATE;
v_rec.last_update_date  := SYSDATE;
v_rec.last_updated_by   := v_user_id;
v_rec.created_by        := v_user_id;
v_rec.last_update_login := v_login_id;

BEGIN
IF INSERTING THEN 
p_row_action := 'INSERT';
ELSIF UPDATING THEN 
p_row_action := 'UPDATE';
ELSIF DELETING THEN 
p_row_action := 'DELETE';
END IF;

BEGIN
IF NVL(TO_CHAR(:OLD.ID),'X') <> NVL(TO_CHAR(:NEW.ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ID;
v_rec.NEW_VALUE := :NEW.ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.REQUEST_ID),'X') <> NVL(TO_CHAR(:NEW.REQUEST_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'REQUEST_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.REQUEST_ID;
v_rec.NEW_VALUE := :NEW.REQUEST_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CASE_KEY),'X') <> NVL(TO_CHAR(:NEW.CASE_KEY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'CASE_KEY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CASE_KEY;
v_rec.NEW_VALUE := :NEW.CASE_KEY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.ALERT_ID),'X') <> NVL(TO_CHAR(:NEW.ALERT_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'ALERT_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ALERT_ID;
v_rec.NEW_VALUE := :NEW.ALERT_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.WC_SCREENING_REQUEST_ID),'X') <> NVL(TO_CHAR(:NEW.WC_SCREENING_REQUEST_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'WC_SCREENING_REQUEST_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.WC_SCREENING_REQUEST_ID;
v_rec.NEW_VALUE := :NEW.WC_SCREENING_REQUEST_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.WC_MATCHES_ID),'X') <> NVL(TO_CHAR(:NEW.WC_MATCHES_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'WC_MATCHES_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.WC_MATCHES_ID;
v_rec.NEW_VALUE := :NEW.WC_MATCHES_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.WC_CONTENT_ID),'X') <> NVL(TO_CHAR(:NEW.WC_CONTENT_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'WC_CONTENT_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.WC_CONTENT_ID;
v_rec.NEW_VALUE := :NEW.WC_CONTENT_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.SOURCE_TABLE),'X') <> NVL(TO_CHAR(:NEW.SOURCE_TABLE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'SOURCE_TABLE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.SOURCE_TABLE;
v_rec.NEW_VALUE := :NEW.SOURCE_TABLE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.SOURCE_TABLE_COLUMN),'X') <> NVL(TO_CHAR(:NEW.SOURCE_TABLE_COLUMN),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'SOURCE_TABLE_COLUMN';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.SOURCE_TABLE_COLUMN;
v_rec.NEW_VALUE := :NEW.SOURCE_TABLE_COLUMN;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.SOURCE_ID),'X') <> NVL(TO_CHAR(:NEW.SOURCE_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'SOURCE_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.SOURCE_ID;
v_rec.NEW_VALUE := :NEW.SOURCE_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LIST_ID),'X') <> NVL(TO_CHAR(:NEW.LIST_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'LIST_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LIST_ID;
v_rec.NEW_VALUE := :NEW.LIST_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.FROM_STATE),'X') <> NVL(TO_CHAR(:NEW.FROM_STATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'FROM_STATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.FROM_STATE;
v_rec.NEW_VALUE := :NEW.FROM_STATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.TO_STATE),'X') <> NVL(TO_CHAR(:NEW.TO_STATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'TO_STATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.TO_STATE;
v_rec.NEW_VALUE := :NEW.TO_STATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.STATUS),'X') <> NVL(TO_CHAR(:NEW.STATUS),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'STATUS';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.STATUS;
v_rec.NEW_VALUE := :NEW.STATUS;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.PARENT_REQUEST_ID),'X') <> NVL(TO_CHAR(:NEW.PARENT_REQUEST_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'PARENT_REQUEST_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.PARENT_REQUEST_ID;
v_rec.NEW_VALUE := :NEW.PARENT_REQUEST_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.RELATIONSHIP_TYPE),'X') <> NVL(TO_CHAR(:NEW.RELATIONSHIP_TYPE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'RELATIONSHIP_TYPE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.RELATIONSHIP_TYPE;
v_rec.NEW_VALUE := :NEW.RELATIONSHIP_TYPE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.ERROR_MESSAGE),'X') <> NVL(TO_CHAR(:NEW.ERROR_MESSAGE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'ERROR_MESSAGE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ERROR_MESSAGE;
v_rec.NEW_VALUE := :NEW.ERROR_MESSAGE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.NOTE),'X') <> NVL(TO_CHAR(:NEW.NOTE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'NOTE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.NOTE;
v_rec.NEW_VALUE := :NEW.NOTE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LAST_UPDATE_DATE),'X') <> NVL(TO_CHAR(:NEW.LAST_UPDATE_DATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'LAST_UPDATE_DATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LAST_UPDATE_DATE;
v_rec.NEW_VALUE := :NEW.LAST_UPDATE_DATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LAST_UPDATED_BY),'X') <> NVL(TO_CHAR(:NEW.LAST_UPDATED_BY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'LAST_UPDATED_BY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LAST_UPDATED_BY;
v_rec.NEW_VALUE := :NEW.LAST_UPDATED_BY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CREATION_DATE),'X') <> NVL(TO_CHAR(:NEW.CREATION_DATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'CREATION_DATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CREATION_DATE;
v_rec.NEW_VALUE := :NEW.CREATION_DATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CREATED_BY),'X') <> NVL(TO_CHAR(:NEW.CREATED_BY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'CREATED_BY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CREATED_BY;
v_rec.NEW_VALUE := :NEW.CREATED_BY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LAST_UPDATE_LOGIN),'X') <> NVL(TO_CHAR(:NEW.LAST_UPDATE_LOGIN),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'LAST_UPDATE_LOGIN';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LAST_UPDATE_LOGIN;
v_rec.NEW_VALUE := :NEW.LAST_UPDATE_LOGIN;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.MASTER_ID),'X') <> NVL(TO_CHAR(:NEW.MASTER_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'MASTER_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.MASTER_ID;
v_rec.NEW_VALUE := :NEW.MASTER_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.ALIAS_ID),'X') <> NVL(TO_CHAR(:NEW.ALIAS_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'ALIAS_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ALIAS_ID;
v_rec.NEW_VALUE := :NEW.ALIAS_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.XREF_ID),'X') <> NVL(TO_CHAR(:NEW.XREF_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'XREF_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.XREF_ID;
v_rec.NEW_VALUE := :NEW.XREF_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.SOURCE_KEY),'X') <> NVL(TO_CHAR(:NEW.SOURCE_KEY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_CLEARING_XREF';
v_rec.TABLE_COLUMN := 'SOURCE_KEY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.SOURCE_KEY;
v_rec.NEW_VALUE := :NEW.SOURCE_KEY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

EXCEPTION
when others then
apps.mt_log_error ( 'Audit Error - Table:  '||p_table_name||'ID: '|| :NEW.ID || ' exception ' || SQLERRM);
END;
/


CREATE OR REPLACE TRIGGER XWRL_PARTY_XREF_AFTER_IUD_TRG
AFTER INSERT OR UPDATE OR DELETE ON XWRL_PARTY_XREF
FOR EACH ROW
DECLARE

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_PARTY_XREF'
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
IF NVL(TO_CHAR(:OLD.TC_EXCLUDED),'X') <> NVL(TO_CHAR(:NEW.TC_EXCLUDED),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
v_rec.TABLE_COLUMN := 'TC_EXCLUDED';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.TC_EXCLUDED;
v_rec.NEW_VALUE := :NEW.TC_EXCLUDED;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.ID),'X') <> NVL(TO_CHAR(:NEW.ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
v_rec.TABLE_COLUMN := 'ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ID;
v_rec.NEW_VALUE := :NEW.ID;
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
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
v_rec.TABLE_COLUMN := 'MASTER_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.MASTER_ID;
v_rec.NEW_VALUE := :NEW.MASTER_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.RELATIONSHIP_MASTER_ID),'X') <> NVL(TO_CHAR(:NEW.RELATIONSHIP_MASTER_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
v_rec.TABLE_COLUMN := 'RELATIONSHIP_MASTER_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.RELATIONSHIP_MASTER_ID;
v_rec.NEW_VALUE := :NEW.RELATIONSHIP_MASTER_ID;
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
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
v_rec.TABLE_COLUMN := 'RELATIONSHIP_TYPE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.RELATIONSHIP_TYPE;
v_rec.NEW_VALUE := :NEW.RELATIONSHIP_TYPE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.STATE),'X') <> NVL(TO_CHAR(:NEW.STATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
v_rec.TABLE_COLUMN := 'STATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.STATE;
v_rec.NEW_VALUE := :NEW.STATE;
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
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
v_rec.TABLE_COLUMN := 'STATUS';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.STATUS;
v_rec.NEW_VALUE := :NEW.STATUS;
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
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
v_rec.TABLE_COLUMN := 'NOTE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.NOTE;
v_rec.NEW_VALUE := :NEW.NOTE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.SORT_ORDER),'X') <> NVL(TO_CHAR(:NEW.SORT_ORDER),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
v_rec.TABLE_COLUMN := 'SORT_ORDER';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.SORT_ORDER;
v_rec.NEW_VALUE := :NEW.SORT_ORDER;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.START_DATE),'X') <> NVL(TO_CHAR(:NEW.START_DATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
v_rec.TABLE_COLUMN := 'START_DATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.START_DATE;
v_rec.NEW_VALUE := :NEW.START_DATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.END_DATE),'X') <> NVL(TO_CHAR(:NEW.END_DATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
v_rec.TABLE_COLUMN := 'END_DATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.END_DATE;
v_rec.NEW_VALUE := :NEW.END_DATE;
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
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
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
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
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
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
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
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
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
v_rec.TABLE_NAME := 'XWRL_PARTY_XREF';
v_rec.TABLE_COLUMN := 'LAST_UPDATE_LOGIN';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LAST_UPDATE_LOGIN;
v_rec.NEW_VALUE := :NEW.LAST_UPDATE_LOGIN;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

EXCEPTION
when others then
apps.mt_log_error ( 'Audit Error - Table:  '||p_table_name||'ID: '|| :NEW.ID || ' exception ' || SQLERRM);
END;
/


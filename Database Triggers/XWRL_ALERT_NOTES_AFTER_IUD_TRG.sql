CREATE OR REPLACE TRIGGER XWRL_ALERT_NOTES_AFTER_IUD_TRG
AFTER INSERT OR UPDATE OR DELETE ON XWRL_ALERT_NOTES
FOR EACH ROW
DECLARE

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_ALERT_NOTES'
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
v_rec.TABLE_NAME := 'XWRL_ALERT_NOTES';
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
v_rec.TABLE_NAME := 'XWRL_ALERT_NOTES';
v_rec.TABLE_COLUMN := 'REQUEST_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.REQUEST_ID;
v_rec.NEW_VALUE := :NEW.REQUEST_ID;
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
v_rec.TABLE_NAME := 'XWRL_ALERT_NOTES';
v_rec.TABLE_COLUMN := 'ALERT_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ALERT_ID;
v_rec.NEW_VALUE := :NEW.ALERT_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LINE_NUMBER),'X') <> NVL(TO_CHAR(:NEW.LINE_NUMBER),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_ALERT_NOTES';
v_rec.TABLE_COLUMN := 'LINE_NUMBER';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LINE_NUMBER;
v_rec.NEW_VALUE := :NEW.LINE_NUMBER;
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
v_rec.TABLE_NAME := 'XWRL_ALERT_NOTES';
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
v_rec.TABLE_NAME := 'XWRL_ALERT_NOTES';
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
v_rec.TABLE_NAME := 'XWRL_ALERT_NOTES';
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
v_rec.TABLE_NAME := 'XWRL_ALERT_NOTES';
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
v_rec.TABLE_NAME := 'XWRL_ALERT_NOTES';
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
v_rec.TABLE_NAME := 'XWRL_ALERT_NOTES';
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


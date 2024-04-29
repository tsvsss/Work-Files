
  CREATE OR REPLACE EDITIONABLE TRIGGER "XWRL"."XWRL_CASE_DOC_AFTER_IUD_TRG" 

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XWRL_CASE_DOCUMENTS_AFTER_IUD_TRG.trg 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : XWRL_CASE_DOC_AFTER_IUD_TRG                                                                      *
* Script Name         : XWRL_CASE_DOCUMENTS_AFTER_IUD_TRG.trg                                                                   *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                    *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    : TSUAZO                                                                                      *
* Last Reviewed Date  : 11-NOV-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO        15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  R      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/

  AFTER INSERT OR UPDATE OR DELETE ON XWRL_CASE_DOCUMENTS
  FOR EACH ROW 

DECLARE

--PRAGMA AUTONOMOUS_TRANSACTION;    

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_CASE_DOCUMENTS'
and data_type not in ('XMLTYPE')
;

v_rec XWRL_AUDIT_LOG%rowtype;

p_row_action varchar2(20);

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
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
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
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'REQUEST_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.REQUEST_ID;
v_rec.NEW_VALUE := :NEW.REQUEST_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CASE_ID),'X') <> NVL(TO_CHAR(:NEW.CASE_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'CASE_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CASE_ID;
v_rec.NEW_VALUE := :NEW.CASE_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.EDOC_ID),'X') <> NVL(TO_CHAR(:NEW.EDOC_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'EDOC_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.EDOC_ID;
v_rec.NEW_VALUE := :NEW.EDOC_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DOCUMENT_FILE),'X') <> NVL(TO_CHAR(:NEW.DOCUMENT_FILE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'DOCUMENT_FILE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DOCUMENT_FILE;
v_rec.NEW_VALUE := :NEW.DOCUMENT_FILE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DOCUMENT_NAME),'X') <> NVL(TO_CHAR(:NEW.DOCUMENT_NAME),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'DOCUMENT_NAME';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DOCUMENT_NAME;
v_rec.NEW_VALUE := :NEW.DOCUMENT_NAME;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DOCUMENT_CATEGORY),'X') <> NVL(TO_CHAR(:NEW.DOCUMENT_CATEGORY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'DOCUMENT_CATEGORY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DOCUMENT_CATEGORY;
v_rec.NEW_VALUE := :NEW.DOCUMENT_CATEGORY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DOCUMENT_TYPE),'X') <> NVL(TO_CHAR(:NEW.DOCUMENT_TYPE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'DOCUMENT_TYPE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DOCUMENT_TYPE;
v_rec.NEW_VALUE := :NEW.DOCUMENT_TYPE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.FILE_NAME),'X') <> NVL(TO_CHAR(:NEW.FILE_NAME),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'FILE_NAME';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.FILE_NAME;
v_rec.NEW_VALUE := :NEW.FILE_NAME;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.FILE_PATH),'X') <> NVL(TO_CHAR(:NEW.FILE_PATH),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'FILE_PATH';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.FILE_PATH;
v_rec.NEW_VALUE := :NEW.FILE_PATH;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CONTENT_TYPE),'X') <> NVL(TO_CHAR(:NEW.CONTENT_TYPE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'CONTENT_TYPE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CONTENT_TYPE;
v_rec.NEW_VALUE := :NEW.CONTENT_TYPE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.IMAGE_FILE),'X') <> NVL(TO_CHAR(:NEW.IMAGE_FILE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'IMAGE_FILE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.IMAGE_FILE;
v_rec.NEW_VALUE := :NEW.IMAGE_FILE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.IMAGE_NAME),'X') <> NVL(TO_CHAR(:NEW.IMAGE_NAME),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'IMAGE_NAME';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.IMAGE_NAME;
v_rec.NEW_VALUE := :NEW.IMAGE_NAME;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.IMAGE_PATH),'X') <> NVL(TO_CHAR(:NEW.IMAGE_PATH),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'IMAGE_PATH';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.IMAGE_PATH;
v_rec.NEW_VALUE := :NEW.IMAGE_PATH;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.URL_PATH),'X') <> NVL(TO_CHAR(:NEW.URL_PATH),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'URL_PATH';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.URL_PATH;
v_rec.NEW_VALUE := :NEW.URL_PATH;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.COMMENT),'X') <> NVL(TO_CHAR(:NEW.COMMENT),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'COMMENT';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.COMMENT;
v_rec.NEW_VALUE := :NEW.COMMENT;
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
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
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
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
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
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
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
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
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
v_rec.TABLE_NAME := 'XWRL_CASE_DOCUMENTS';
v_rec.TABLE_COLUMN := 'LAST_UPDATE_LOGIN';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LAST_UPDATE_LOGIN;
v_rec.NEW_VALUE := :NEW.LAST_UPDATE_LOGIN;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;


--COMMIT;

EXCEPTION
when others then
    apps.mt_log_error (:NEW.ID || ' ' || 'exception ' || SQLERRM);

END;
/
ALTER TRIGGER "XWRL"."XWRL_CASE_DOC_AFTER_IUD_TRG" ENABLE
;


  CREATE OR REPLACE EDITIONABLE TRIGGER "XWRL"."XWRL_REQUESTS_AFTER_IUD_TRG" 

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: xwrl_requests_after_iud.trg 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : xwrl_requests_post_upd                                                                      *
* Script Name         : xwrl_requests_after_iud.trg                                                                   *
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

  AFTER INSERT OR UPDATE OR DELETE ON XWRL_REQUESTS
  FOR EACH ROW 

DECLARE

--PRAGMA AUTONOMOUS_TRANSACTION;    

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_REQUESTS'
and data_type not in ('XMLTYPE')
and column_name not in ('SOAP_QUERY')
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
IF NVL(TO_CHAR(:OLD.MASTER_ID),'X') <> NVL(TO_CHAR(:NEW.MASTER_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'XREF_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.XREF_ID;
v_rec.NEW_VALUE := :NEW.XREF_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.COUNTRY_OF_ADDRESS),'X') <> NVL(TO_CHAR(:NEW.COUNTRY_OF_ADDRESS),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'COUNTRY_OF_ADDRESS';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.COUNTRY_OF_ADDRESS;
v_rec.NEW_VALUE := :NEW.COUNTRY_OF_ADDRESS;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.COUNTRY_OF_NATIONALITY),'X') <> NVL(TO_CHAR(:NEW.COUNTRY_OF_NATIONALITY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'COUNTRY_OF_NATIONALITY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.COUNTRY_OF_NATIONALITY;
v_rec.NEW_VALUE := :NEW.COUNTRY_OF_NATIONALITY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.COUNTRY_OF_BIRTH),'X') <> NVL(TO_CHAR(:NEW.COUNTRY_OF_BIRTH),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'COUNTRY_OF_BIRTH';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.COUNTRY_OF_BIRTH;
v_rec.NEW_VALUE := :NEW.COUNTRY_OF_BIRTH;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.COUNTRY_OF_REGISTRATION),'X') <> NVL(TO_CHAR(:NEW.COUNTRY_OF_REGISTRATION),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'COUNTRY_OF_REGISTRATION';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.COUNTRY_OF_REGISTRATION;
v_rec.NEW_VALUE := :NEW.COUNTRY_OF_REGISTRATION;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.COUNTRY_OF_OPERATION),'X') <> NVL(TO_CHAR(:NEW.COUNTRY_OF_OPERATION),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'COUNTRY_OF_OPERATION';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.COUNTRY_OF_OPERATION;
v_rec.NEW_VALUE := :NEW.COUNTRY_OF_OPERATION;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.EXPIRATION_DATE),'X') <> NVL(TO_CHAR(:NEW.EXPIRATION_DATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'EXPIRATION_DATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.EXPIRATION_DATE;
v_rec.NEW_VALUE := :NEW.EXPIRATION_DATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.REJECTION_REASON_OTHR),'X') <> NVL(TO_CHAR(:NEW.REJECTION_REASON_OTHR),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'REJECTION_REASON_OTHR';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.REJECTION_REASON_OTHR;
v_rec.NEW_VALUE := :NEW.REJECTION_REASON_OTHR;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.VERSION_ID),'X') <> NVL(TO_CHAR(:NEW.VERSION_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'VERSION_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.VERSION_ID;
v_rec.NEW_VALUE := :NEW.VERSION_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CATEGORY_RESTRICTION_INDICATOR),'X') <> NVL(TO_CHAR(:NEW.CATEGORY_RESTRICTION_INDICATOR),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'CATEGORY_RESTRICTION_INDICATOR';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CATEGORY_RESTRICTION_INDICATOR;
v_rec.NEW_VALUE := :NEW.CATEGORY_RESTRICTION_INDICATOR;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.BATCH_ID),'X') <> NVL(TO_CHAR(:NEW.BATCH_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'BATCH_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.BATCH_ID;
v_rec.NEW_VALUE := :NEW.BATCH_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.PARENT_ID),'X') <> NVL(TO_CHAR(:NEW.PARENT_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'PARENT_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.PARENT_ID;
v_rec.NEW_VALUE := :NEW.PARENT_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.VESSEL_INDICATOR),'X') <> NVL(TO_CHAR(:NEW.VESSEL_INDICATOR),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'VESSEL_INDICATOR';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.VESSEL_INDICATOR;
v_rec.NEW_VALUE := :NEW.VESSEL_INDICATOR;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.NAME_SCREENED),'X') <> NVL(TO_CHAR(:NEW.NAME_SCREENED),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'NAME_SCREENED';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.NAME_SCREENED;
v_rec.NEW_VALUE := :NEW.NAME_SCREENED;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.IMO_NUMBER),'X') <> NVL(TO_CHAR(:NEW.IMO_NUMBER),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'IMO_NUMBER';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.IMO_NUMBER;
v_rec.NEW_VALUE := :NEW.IMO_NUMBER;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DEPARTMENT),'X') <> NVL(TO_CHAR(:NEW.DEPARTMENT),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'DEPARTMENT';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DEPARTMENT;
v_rec.NEW_VALUE := :NEW.DEPARTMENT;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.OFFICE),'X') <> NVL(TO_CHAR(:NEW.OFFICE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'OFFICE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.OFFICE;
v_rec.NEW_VALUE := :NEW.OFFICE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.PRIORITY),'X') <> NVL(TO_CHAR(:NEW.PRIORITY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'PRIORITY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.PRIORITY;
v_rec.NEW_VALUE := :NEW.PRIORITY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.RISK_LEVEL),'X') <> NVL(TO_CHAR(:NEW.RISK_LEVEL),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'RISK_LEVEL';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.RISK_LEVEL;
v_rec.NEW_VALUE := :NEW.RISK_LEVEL;
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'DOCUMENT_TYPE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DOCUMENT_TYPE;
v_rec.NEW_VALUE := :NEW.DOCUMENT_TYPE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CLOSED_DATE),'X') <> NVL(TO_CHAR(:NEW.CLOSED_DATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'CLOSED_DATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CLOSED_DATE;
v_rec.NEW_VALUE := :NEW.CLOSED_DATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.ASSIGNED_TO),'X') <> NVL(TO_CHAR(:NEW.ASSIGNED_TO),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'ASSIGNED_TO';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ASSIGNED_TO;
v_rec.NEW_VALUE := :NEW.ASSIGNED_TO;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.COUNTRY_OF_RESIDENCE),'X') <> NVL(TO_CHAR(:NEW.COUNTRY_OF_RESIDENCE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'COUNTRY_OF_RESIDENCE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.COUNTRY_OF_RESIDENCE;
v_rec.NEW_VALUE := :NEW.COUNTRY_OF_RESIDENCE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CITY_OF_RESIDENCE),'X') <> NVL(TO_CHAR(:NEW.CITY_OF_RESIDENCE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'CITY_OF_RESIDENCE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CITY_OF_RESIDENCE;
v_rec.NEW_VALUE := :NEW.CITY_OF_RESIDENCE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DATE_OF_BIRTH),'X') <> NVL(TO_CHAR(:NEW.DATE_OF_BIRTH),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'DATE_OF_BIRTH';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DATE_OF_BIRTH;
v_rec.NEW_VALUE := :NEW.DATE_OF_BIRTH;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.SUBDIVISION_CITY_OF_RESIDENCE),'X') <> NVL(TO_CHAR(:NEW.SUBDIVISION_CITY_OF_RESIDENCE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'SUBDIVISION_CITY_OF_RESIDENCE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.SUBDIVISION_CITY_OF_RESIDENCE;
v_rec.NEW_VALUE := :NEW.SUBDIVISION_CITY_OF_RESIDENCE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.REJECTION_REASON),'X') <> NVL(TO_CHAR(:NEW.REJECTION_REASON),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'REJECTION_REASON';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.REJECTION_REASON;
v_rec.NEW_VALUE := :NEW.REJECTION_REASON;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CITY_OF_RESIDENCE_ID),'X') <> NVL(TO_CHAR(:NEW.CITY_OF_RESIDENCE_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'CITY_OF_RESIDENCE_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CITY_OF_RESIDENCE_ID;
v_rec.NEW_VALUE := :NEW.CITY_OF_RESIDENCE_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.VESSEL_PK),'X') <> NVL(TO_CHAR(:NEW.VESSEL_PK),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'VESSEL_PK';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.VESSEL_PK;
v_rec.NEW_VALUE := :NEW.VESSEL_PK;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.VESSEL_UK),'X') <> NVL(TO_CHAR(:NEW.VESSEL_UK),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'VESSEL_UK';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.VESSEL_UK;
v_rec.NEW_VALUE := :NEW.VESSEL_UK;
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ID;
v_rec.NEW_VALUE := :NEW.ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.RESUBMIT_ID),'X') <> NVL(TO_CHAR(:NEW.RESUBMIT_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'RESUBMIT_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.RESUBMIT_ID;
v_rec.NEW_VALUE := :NEW.RESUBMIT_ID;
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'SOURCE_TABLE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.SOURCE_TABLE;
v_rec.NEW_VALUE := :NEW.SOURCE_TABLE;
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'SOURCE_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.SOURCE_ID;
v_rec.NEW_VALUE := :NEW.SOURCE_ID;
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'WC_SCREENING_REQUEST_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.WC_SCREENING_REQUEST_ID;
v_rec.NEW_VALUE := :NEW.WC_SCREENING_REQUEST_ID;
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'CASE_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CASE_ID;
v_rec.NEW_VALUE := :NEW.CASE_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.SERVER),'X') <> NVL(TO_CHAR(:NEW.SERVER),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'SERVER';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.SERVER;
v_rec.NEW_VALUE := :NEW.SERVER;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.PATH),'X') <> NVL(TO_CHAR(:NEW.PATH),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'PATH';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.PATH;
v_rec.NEW_VALUE := :NEW.PATH;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.JOB_ID),'X') <> NVL(TO_CHAR(:NEW.JOB_ID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'JOB_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.JOB_ID;
v_rec.NEW_VALUE := :NEW.JOB_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.MATCHES),'X') <> NVL(TO_CHAR(:NEW.MATCHES),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'MATCHES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.MATCHES;
v_rec.NEW_VALUE := :NEW.MATCHES;
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'STATUS';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.STATUS;
v_rec.NEW_VALUE := :NEW.STATUS;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CASE_STATUS),'X') <> NVL(TO_CHAR(:NEW.CASE_STATUS),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'CASE_STATUS';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CASE_STATUS;
v_rec.NEW_VALUE := :NEW.CASE_STATUS;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CASE_STATE),'X') <> NVL(TO_CHAR(:NEW.CASE_STATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'CASE_STATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CASE_STATE;
v_rec.NEW_VALUE := :NEW.CASE_STATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CASE_WORKFLOW),'X') <> NVL(TO_CHAR(:NEW.CASE_WORKFLOW),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'CASE_WORKFLOW';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CASE_WORKFLOW;
v_rec.NEW_VALUE := :NEW.CASE_WORKFLOW;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.ERROR_CODE),'X') <> NVL(TO_CHAR(:NEW.ERROR_CODE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'ERROR_CODE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ERROR_CODE;
v_rec.NEW_VALUE := :NEW.ERROR_CODE;
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
v_rec.TABLE_COLUMN := 'ERROR_MESSAGE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ERROR_MESSAGE;
v_rec.NEW_VALUE := :NEW.ERROR_MESSAGE;
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
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
v_rec.TABLE_NAME := 'XWRL_REQUESTS';
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
ALTER TRIGGER "XWRL"."XWRL_REQUESTS_AFTER_IUD_TRG" ENABLE
;

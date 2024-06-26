CREATE OR REPLACE TRIGGER XWRL."XWRL_ENT_IND_AFTER_IUD_TRG" 

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XWRL_RESPONSE_ENTITY_COLUMNS_AFTER_IUD_TRG.trg 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : XWRL_RES_ENT_AFTER_IUD_TRG                                                                      *
* Script Name         : XWRL_RESPONSE_ENTITY_COLUMNS_AFTER_IUD_TRG.trg                                                                   *
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
* 22-MAY-2020 IRI              1.3                SAGARWAL      22-MAY-2020  R      WHO Columns                   *
* 13-JUL-2020 IRI              1.4                TSUAZO        13-JUL-2020  E      Bypass Trigger Logic          *
********************************************************************************************************************/

  AFTER INSERT OR UPDATE OR DELETE ON "XWRL"."XWRL_RESPONSE_ENTITY_COLUMNS"
  FOR EACH ROW
DECLARE

--PRAGMA AUTONOMOUS_TRANSACTION;    

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_RESPONSE_ENTITY_COLUMNS'
and data_type not in ('XMLTYPE')
;

v_rec XWRL_AUDIT_LOG%rowtype;

p_row_action varchar2(20);

v_user_id  NUMBER  := apps.fnd_profile.value('USER_ID');
v_login_id NUMBER  := apps.fnd_profile.value('LOGIN_ID');

	bypass_trigger EXCEPTION;
	v_bypass_trigger varchar2(10); 

BEGIN

	SELECT SYS_CONTEXT('xwrl_ctx', 'disable_trigger') into v_bypass_trigger FROM dual;
	if v_bypass_trigger = 'TRUE' then
	  raise bypass_trigger;
	end if;  

IF INSERTING THEN 
      p_row_action := 'INSERT';
ELSIF UPDATING THEN 
      p_row_action := 'UPDATE';      
ELSIF DELETING THEN 
      p_row_action := 'DELETE';      
END IF;

v_rec.creation_date     := SYSDATE;
v_rec.last_update_date  := SYSDATE;
v_rec.last_updated_by   := v_user_id;
v_rec.created_by        := v_user_id;
v_rec.last_update_login := v_login_id;

BEGIN
IF NVL(TO_CHAR(:OLD.DNADDRESSCOUNTRY),'X') <> NVL(TO_CHAR(:NEW.DNADDRESSCOUNTRY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNADDRESSCOUNTRY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNADDRESSCOUNTRY;
v_rec.NEW_VALUE := :NEW.DNADDRESSCOUNTRY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNREGISTRATIONCOUNTRY),'X') <> NVL(TO_CHAR(:NEW.DNREGISTRATIONCOUNTRY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNREGISTRATIONCOUNTRY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNREGISTRATIONCOUNTRY;
v_rec.NEW_VALUE := :NEW.DNREGISTRATIONCOUNTRY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNOPERATINGCOUNTRIES),'X') <> NVL(TO_CHAR(:NEW.DNOPERATINGCOUNTRIES),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNOPERATINGCOUNTRIES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNOPERATINGCOUNTRIES;
v_rec.NEW_VALUE := :NEW.DNOPERATINGCOUNTRIES;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNALLCOUNTRIES),'X') <> NVL(TO_CHAR(:NEW.DNALLCOUNTRIES),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNALLCOUNTRIES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNALLCOUNTRIES;
v_rec.NEW_VALUE := :NEW.DNALLCOUNTRIES;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LEGAL_REVIEW),'X') <> NVL(TO_CHAR(:NEW.LEGAL_REVIEW),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LEGAL_REVIEW';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LEGAL_REVIEW;
v_rec.NEW_VALUE := :NEW.LEGAL_REVIEW;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.ADDITIONALINFORMATION),'X') <> NVL(TO_CHAR(:NEW.ADDITIONALINFORMATION),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'ADDITIONALINFORMATION';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ADDITIONALINFORMATION;
v_rec.NEW_VALUE := :NEW.ADDITIONALINFORMATION;
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'REQUEST_ID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.REQUEST_ID;
v_rec.NEW_VALUE := :NEW.REQUEST_ID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.X_STATE),'X') <> NVL(TO_CHAR(:NEW.X_STATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'X_STATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.X_STATE;
v_rec.NEW_VALUE := :NEW.X_STATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.REC),'X') <> NVL(TO_CHAR(:NEW.REC),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'REC';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.REC;
v_rec.NEW_VALUE := :NEW.REC;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTKEY),'X') <> NVL(TO_CHAR(:NEW.LISTKEY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTKEY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTKEY;
v_rec.NEW_VALUE := :NEW.LISTKEY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTSUBKEY),'X') <> NVL(TO_CHAR(:NEW.LISTSUBKEY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTSUBKEY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTSUBKEY;
v_rec.NEW_VALUE := :NEW.LISTSUBKEY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTRECORDTYPE),'X') <> NVL(TO_CHAR(:NEW.LISTRECORDTYPE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTRECORDTYPE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTRECORDTYPE;
v_rec.NEW_VALUE := :NEW.LISTRECORDTYPE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTRECORDORIGIN),'X') <> NVL(TO_CHAR(:NEW.LISTRECORDORIGIN),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTRECORDORIGIN';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTRECORDORIGIN;
v_rec.NEW_VALUE := :NEW.LISTRECORDORIGIN;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTID),'X') <> NVL(TO_CHAR(:NEW.LISTID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTID;
v_rec.NEW_VALUE := :NEW.LISTID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTENTITYNAME),'X') <> NVL(TO_CHAR(:NEW.LISTENTITYNAME),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTENTITYNAME';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTENTITYNAME;
v_rec.NEW_VALUE := :NEW.LISTENTITYNAME;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTPRIMARYNAME),'X') <> NVL(TO_CHAR(:NEW.LISTPRIMARYNAME),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTPRIMARYNAME';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTPRIMARYNAME;
v_rec.NEW_VALUE := :NEW.LISTPRIMARYNAME;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTORIGINALSCRIPTNAME),'X') <> NVL(TO_CHAR(:NEW.LISTORIGINALSCRIPTNAME),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTORIGINALSCRIPTNAME';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTORIGINALSCRIPTNAME;
v_rec.NEW_VALUE := :NEW.LISTORIGINALSCRIPTNAME;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTNAMETYPE),'X') <> NVL(TO_CHAR(:NEW.LISTNAMETYPE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTNAMETYPE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTNAMETYPE;
v_rec.NEW_VALUE := :NEW.LISTNAMETYPE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTCITY),'X') <> NVL(TO_CHAR(:NEW.LISTCITY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTCITY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTCITY;
v_rec.NEW_VALUE := :NEW.LISTCITY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTCOUNTRY),'X') <> NVL(TO_CHAR(:NEW.LISTCOUNTRY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTCOUNTRY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTCOUNTRY;
v_rec.NEW_VALUE := :NEW.LISTCOUNTRY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTOPERATINGCOUNTRIES),'X') <> NVL(TO_CHAR(:NEW.LISTOPERATINGCOUNTRIES),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTOPERATINGCOUNTRIES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTOPERATINGCOUNTRIES;
v_rec.NEW_VALUE := :NEW.LISTOPERATINGCOUNTRIES;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTREGISTRATIONCOUNTRIES),'X') <> NVL(TO_CHAR(:NEW.LISTREGISTRATIONCOUNTRIES),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTREGISTRATIONCOUNTRIES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTREGISTRATIONCOUNTRIES;
v_rec.NEW_VALUE := :NEW.LISTREGISTRATIONCOUNTRIES;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.MATCHRULE),'X') <> NVL(TO_CHAR(:NEW.MATCHRULE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'MATCHRULE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.MATCHRULE;
v_rec.NEW_VALUE := :NEW.MATCHRULE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.MATCHSCORE),'X') <> NVL(TO_CHAR(:NEW.MATCHSCORE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'MATCHSCORE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.MATCHSCORE;
v_rec.NEW_VALUE := :NEW.MATCHSCORE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CASEKEY),'X') <> NVL(TO_CHAR(:NEW.CASEKEY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'CASEKEY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CASEKEY;
v_rec.NEW_VALUE := :NEW.CASEKEY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.ALERTID),'X') <> NVL(TO_CHAR(:NEW.ALERTID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'ALERTID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ALERTID;
v_rec.NEW_VALUE := :NEW.ALERTID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.RISKSCORE),'X') <> NVL(TO_CHAR(:NEW.RISKSCORE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'RISKSCORE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.RISKSCORE;
v_rec.NEW_VALUE := :NEW.RISKSCORE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.RISKSCOREPEP),'X') <> NVL(TO_CHAR(:NEW.RISKSCOREPEP),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'RISKSCOREPEP';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.RISKSCOREPEP;
v_rec.NEW_VALUE := :NEW.RISKSCOREPEP;
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'LAST_UPDATE_LOGIN';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LAST_UPDATE_LOGIN;
v_rec.NEW_VALUE := :NEW.LAST_UPDATE_LOGIN;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CATEGORY),'X') <> NVL(TO_CHAR(:NEW.CATEGORY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'CATEGORY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CATEGORY;
v_rec.NEW_VALUE := :NEW.CATEGORY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNREGISTRATIONNUMBER),'X') <> NVL(TO_CHAR(:NEW.DNREGISTRATIONNUMBER),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNREGISTRATIONNUMBER';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNREGISTRATIONNUMBER;
v_rec.NEW_VALUE := :NEW.DNREGISTRATIONNUMBER;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNORIGINALENTITYNAME),'X') <> NVL(TO_CHAR(:NEW.DNORIGINALENTITYNAME),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNORIGINALENTITYNAME';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNORIGINALENTITYNAME;
v_rec.NEW_VALUE := :NEW.DNORIGINALENTITYNAME;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNENTITYNAME),'X') <> NVL(TO_CHAR(:NEW.DNENTITYNAME),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNENTITYNAME';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNENTITYNAME;
v_rec.NEW_VALUE := :NEW.DNENTITYNAME;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNNAMETYPE),'X') <> NVL(TO_CHAR(:NEW.DNNAMETYPE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNNAMETYPE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNNAMETYPE;
v_rec.NEW_VALUE := :NEW.DNNAMETYPE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNNAMEQUALITY),'X') <> NVL(TO_CHAR(:NEW.DNNAMEQUALITY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNNAMEQUALITY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNNAMEQUALITY;
v_rec.NEW_VALUE := :NEW.DNNAMEQUALITY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNPRIMARYNAME),'X') <> NVL(TO_CHAR(:NEW.DNPRIMARYNAME),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNPRIMARYNAME';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNPRIMARYNAME;
v_rec.NEW_VALUE := :NEW.DNPRIMARYNAME;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNVESSELINDICATOR),'X') <> NVL(TO_CHAR(:NEW.DNVESSELINDICATOR),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNVESSELINDICATOR';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNVESSELINDICATOR;
v_rec.NEW_VALUE := :NEW.DNVESSELINDICATOR;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNVESSELINFO),'X') <> NVL(TO_CHAR(:NEW.DNVESSELINFO),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNVESSELINFO';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNVESSELINFO;
v_rec.NEW_VALUE := :NEW.DNVESSELINFO;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNADDRESS),'X') <> NVL(TO_CHAR(:NEW.DNADDRESS),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNADDRESS';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNADDRESS;
v_rec.NEW_VALUE := :NEW.DNADDRESS;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNCITY),'X') <> NVL(TO_CHAR(:NEW.DNCITY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNCITY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNCITY;
v_rec.NEW_VALUE := :NEW.DNCITY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNSTATE),'X') <> NVL(TO_CHAR(:NEW.DNSTATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNSTATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNSTATE;
v_rec.NEW_VALUE := :NEW.DNSTATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNPOSTALCODE),'X') <> NVL(TO_CHAR(:NEW.DNPOSTALCODE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNPOSTALCODE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNPOSTALCODE;
v_rec.NEW_VALUE := :NEW.DNPOSTALCODE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNADDRESSCOUNTRYCODE),'X') <> NVL(TO_CHAR(:NEW.DNADDRESSCOUNTRYCODE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNADDRESSCOUNTRYCODE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNADDRESSCOUNTRYCODE;
v_rec.NEW_VALUE := :NEW.DNADDRESSCOUNTRYCODE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNREGISTRATIONCOUNTRYCODE),'X') <> NVL(TO_CHAR(:NEW.DNREGISTRATIONCOUNTRYCODE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNREGISTRATIONCOUNTRYCODE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNREGISTRATIONCOUNTRYCODE;
v_rec.NEW_VALUE := :NEW.DNREGISTRATIONCOUNTRYCODE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNOPERATINGCOUNTRYCODES),'X') <> NVL(TO_CHAR(:NEW.DNOPERATINGCOUNTRYCODES),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNOPERATINGCOUNTRYCODES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNOPERATINGCOUNTRYCODES;
v_rec.NEW_VALUE := :NEW.DNOPERATINGCOUNTRYCODES;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNPEPCLASSIFICATION),'X') <> NVL(TO_CHAR(:NEW.DNPEPCLASSIFICATION),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNPEPCLASSIFICATION';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNPEPCLASSIFICATION;
v_rec.NEW_VALUE := :NEW.DNPEPCLASSIFICATION;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNALLCOUNTRYCODES),'X') <> NVL(TO_CHAR(:NEW.DNALLCOUNTRYCODES),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNALLCOUNTRYCODES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNALLCOUNTRYCODES;
v_rec.NEW_VALUE := :NEW.DNALLCOUNTRYCODES;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.EXTERNALSOURCES),'X') <> NVL(TO_CHAR(:NEW.EXTERNALSOURCES),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'EXTERNALSOURCES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.EXTERNALSOURCES;
v_rec.NEW_VALUE := :NEW.EXTERNALSOURCES;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.CACHEDEXTSOURCES),'X') <> NVL(TO_CHAR(:NEW.CACHEDEXTSOURCES),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'CACHEDEXTSOURCES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CACHEDEXTSOURCES;
v_rec.NEW_VALUE := :NEW.CACHEDEXTSOURCES;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNINACTIVEFLAG),'X') <> NVL(TO_CHAR(:NEW.DNINACTIVEFLAG),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNINACTIVEFLAG';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNINACTIVEFLAG;
v_rec.NEW_VALUE := :NEW.DNINACTIVEFLAG;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNINACTIVESINCEDATE),'X') <> NVL(TO_CHAR(:NEW.DNINACTIVESINCEDATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNINACTIVESINCEDATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNINACTIVESINCEDATE;
v_rec.NEW_VALUE := :NEW.DNINACTIVESINCEDATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNADDEDDATE),'X') <> NVL(TO_CHAR(:NEW.DNADDEDDATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNADDEDDATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNADDEDDATE;
v_rec.NEW_VALUE := :NEW.DNADDEDDATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNLASTUPDATEDDATE),'X') <> NVL(TO_CHAR(:NEW.DNLASTUPDATEDDATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_ENTITY_COLUMNS';
v_rec.TABLE_COLUMN := 'DNLASTUPDATEDDATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNLASTUPDATEDDATE;
v_rec.NEW_VALUE := :NEW.DNLASTUPDATEDDATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;


--COMMIT;

EXCEPTION
when bypass_trigger then null;
when others then
    apps.mt_log_error (:NEW.ID || ' ' || 'exception ' || SQLERRM);

END;
/
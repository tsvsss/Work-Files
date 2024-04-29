
  CREATE OR REPLACE EDITIONABLE TRIGGER "XWRL"."XWRL_RES_IND_AFTER_IUD_TRG" 

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XWRL_RESPONSE_IND_COLUMNS_AFTER_IUD_TRG.trg 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Trigger                                                                                     *
* Name                : XWRL_RES_IND_AFTER_IUD_TRG                                                                      *
* Script Name         : XWRL_RESPONSE_IND_COLUMNS_AFTER_IUD_TRG.trg                                                                   *
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

  AFTER INSERT OR UPDATE OR DELETE ON XWRL_RESPONSE_IND_COLUMNS
  FOR EACH ROW 

DECLARE

--PRAGMA AUTONOMOUS_TRANSACTION;    

cursor c1 is
select table_name, column_name
from all_tab_columns
where table_name = 'XWRL_RESPONSE_IND_COLUMNS'
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
IF NVL(TO_CHAR(:OLD.ADDITIONALINFORMATION),'X') <> NVL(TO_CHAR(:NEW.ADDITIONALINFORMATION),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'ADDITIONALINFORMATION';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.ADDITIONALINFORMATION;
v_rec.NEW_VALUE := :NEW.ADDITIONALINFORMATION;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNADDRESSCOUNTRY),'X') <> NVL(TO_CHAR(:NEW.DNADDRESSCOUNTRY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNADDRESSCOUNTRY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNADDRESSCOUNTRY;
v_rec.NEW_VALUE := :NEW.DNADDRESSCOUNTRY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNRESIDENCYCOUNTRY),'X') <> NVL(TO_CHAR(:NEW.DNRESIDENCYCOUNTRY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNRESIDENCYCOUNTRY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNRESIDENCYCOUNTRY;
v_rec.NEW_VALUE := :NEW.DNRESIDENCYCOUNTRY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNCOUNTRYOFBIRTH),'X') <> NVL(TO_CHAR(:NEW.DNCOUNTRYOFBIRTH),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNCOUNTRYOFBIRTH';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNCOUNTRYOFBIRTH;
v_rec.NEW_VALUE := :NEW.DNCOUNTRYOFBIRTH;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNNATIONALITIESCOUNTRIES),'X') <> NVL(TO_CHAR(:NEW.DNNATIONALITIESCOUNTRIES),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNNATIONALITIESCOUNTRIES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNNATIONALITIESCOUNTRIES;
v_rec.NEW_VALUE := :NEW.DNNATIONALITIESCOUNTRIES;
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'LEGAL_REVIEW';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LEGAL_REVIEW;
v_rec.NEW_VALUE := :NEW.LEGAL_REVIEW;
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTID;
v_rec.NEW_VALUE := :NEW.LISTID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTGIVENNAMES),'X') <> NVL(TO_CHAR(:NEW.LISTGIVENNAMES),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTGIVENNAMES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTGIVENNAMES;
v_rec.NEW_VALUE := :NEW.LISTGIVENNAMES;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTFAMILYNAME),'X') <> NVL(TO_CHAR(:NEW.LISTFAMILYNAME),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTFAMILYNAME';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTFAMILYNAME;
v_rec.NEW_VALUE := :NEW.LISTFAMILYNAME;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTFULLNAME),'X') <> NVL(TO_CHAR(:NEW.LISTFULLNAME),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTFULLNAME';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTFULLNAME;
v_rec.NEW_VALUE := :NEW.LISTFULLNAME;
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTNAMETYPE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTNAMETYPE;
v_rec.NEW_VALUE := :NEW.LISTNAMETYPE;
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTORIGINALSCRIPTNAME';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTORIGINALSCRIPTNAME;
v_rec.NEW_VALUE := :NEW.LISTORIGINALSCRIPTNAME;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTDOB),'X') <> NVL(TO_CHAR(:NEW.LISTDOB),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTDOB';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTDOB;
v_rec.NEW_VALUE := :NEW.LISTDOB;
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTCOUNTRY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTCOUNTRY;
v_rec.NEW_VALUE := :NEW.LISTCOUNTRY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTCOUNTRYOFBIRTH),'X') <> NVL(TO_CHAR(:NEW.LISTCOUNTRYOFBIRTH),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTCOUNTRYOFBIRTH';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTCOUNTRYOFBIRTH;
v_rec.NEW_VALUE := :NEW.LISTCOUNTRYOFBIRTH;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.LISTNATIONALITY),'X') <> NVL(TO_CHAR(:NEW.LISTNATIONALITY),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'LISTNATIONALITY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.LISTNATIONALITY;
v_rec.NEW_VALUE := :NEW.LISTNATIONALITY;
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'CATEGORY';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CATEGORY;
v_rec.NEW_VALUE := :NEW.CATEGORY;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNPASSPORTNUMBER),'X') <> NVL(TO_CHAR(:NEW.DNPASSPORTNUMBER),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNPASSPORTNUMBER';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNPASSPORTNUMBER;
v_rec.NEW_VALUE := :NEW.DNPASSPORTNUMBER;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNNATIONALID),'X') <> NVL(TO_CHAR(:NEW.DNNATIONALID),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNNATIONALID';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNNATIONALID;
v_rec.NEW_VALUE := :NEW.DNNATIONALID;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNTITLE),'X') <> NVL(TO_CHAR(:NEW.DNTITLE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNTITLE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNTITLE;
v_rec.NEW_VALUE := :NEW.DNTITLE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNYOB),'X') <> NVL(TO_CHAR(:NEW.DNYOB),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNYOB';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNYOB;
v_rec.NEW_VALUE := :NEW.DNYOB;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNGENDER),'X') <> NVL(TO_CHAR(:NEW.DNGENDER),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNGENDER';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNGENDER;
v_rec.NEW_VALUE := :NEW.DNGENDER;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DECEASEDFLAG),'X') <> NVL(TO_CHAR(:NEW.DECEASEDFLAG),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DECEASEDFLAG';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DECEASEDFLAG;
v_rec.NEW_VALUE := :NEW.DECEASEDFLAG;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DECEASEDDATE),'X') <> NVL(TO_CHAR(:NEW.DECEASEDDATE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DECEASEDDATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DECEASEDDATE;
v_rec.NEW_VALUE := :NEW.DECEASEDDATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNOCCUPATION),'X') <> NVL(TO_CHAR(:NEW.DNOCCUPATION),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNOCCUPATION';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNOCCUPATION;
v_rec.NEW_VALUE := :NEW.DNOCCUPATION;
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNADDRESSCOUNTRYCODE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNADDRESSCOUNTRYCODE;
v_rec.NEW_VALUE := :NEW.DNADDRESSCOUNTRYCODE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNRESIDENCYCOUNTRYCODE),'X') <> NVL(TO_CHAR(:NEW.DNRESIDENCYCOUNTRYCODE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNRESIDENCYCOUNTRYCODE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNRESIDENCYCOUNTRYCODE;
v_rec.NEW_VALUE := :NEW.DNRESIDENCYCOUNTRYCODE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNCOUNTRYOFBIRTHCODE),'X') <> NVL(TO_CHAR(:NEW.DNCOUNTRYOFBIRTHCODE),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNCOUNTRYOFBIRTHCODE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNCOUNTRYOFBIRTHCODE;
v_rec.NEW_VALUE := :NEW.DNCOUNTRYOFBIRTHCODE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;

BEGIN
IF NVL(TO_CHAR(:OLD.DNNATIONALITYCOUNTRYCODES),'X') <> NVL(TO_CHAR(:NEW.DNNATIONALITYCOUNTRYCODES),'X')  THEN 
IF p_row_action = 'DELETE' THEN 
v_rec.TABLE_ID := :OLD.ID;
ELSE
v_rec.TABLE_ID := :NEW.ID;
END IF;
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNNATIONALITYCOUNTRYCODES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNNATIONALITYCOUNTRYCODES;
v_rec.NEW_VALUE := :NEW.DNNATIONALITYCOUNTRYCODES;
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'CACHEDEXTSOURCES';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.CACHEDEXTSOURCES;
v_rec.NEW_VALUE := :NEW.CACHEDEXTSOURCES;
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'DNLASTUPDATEDDATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.DNLASTUPDATEDDATE;
v_rec.NEW_VALUE := :NEW.DNLASTUPDATEDDATE;
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
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
v_rec.TABLE_NAME := 'XWRL_RESPONSE_IND_COLUMNS';
v_rec.TABLE_COLUMN := 'X_STATE';
v_rec.ROW_ACTION :=  p_row_action;
v_rec.OLD_VALUE := :OLD.X_STATE;
v_rec.NEW_VALUE := :NEW.X_STATE;
INSERT INTO XWRL_AUDIT_LOG values v_rec;
END IF;
END;



--COMMIT;

EXCEPTION
when others then
    apps.mt_log_error (:NEW.ID || ' ' || 'exception ' || SQLERRM);

END;
/
ALTER TRIGGER "XWRL"."XWRL_RES_IND_AFTER_IUD_TRG" ENABLE
;

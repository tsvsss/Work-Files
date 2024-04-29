update XWRL_PARAMETERS
set display_flag = 'N'
WHERE ID = 'RESPONSE_ROWS'
and VALUE_STRING like '%Count%';





insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','AdditionalInformation','Summary','Y',92);
--insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnAddressCountry','Country of Address','Y',93);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnResidencyCountry','Country of Residency','Y',96);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnNationalitiesCountries','Countries of Nationality','Y',98);
--insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnCountryOfBirthCountry','Country of Birth','Y',100);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnRegistrationCounty','Country of Domiciliation','Y',102);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnOperatingCountries','Countries of Operation','Y',104);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnAllCountries','All Countries','Y',105);

alter trigger xwrl.XWRL_REQUESTS_INS_UPD disable;

alter trigger xwrl.XWRL_REQUESTS_INS_UPD enable;

  declare
  cursor c1 is
  SELECT rmi_ows_common_util.get_department (ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (ID) dept,
       rmi_ows_common_util.get_doc_type (ID) doc_type,
       rmi_ows_common_util.get_office (ID) office, id
  FROM xwrl_requests
  where id between 23537 and 23555;
  
  begin
  
  for c1rec in c1 loop
  
        update xwrl_requests
        set department = c1rec.deptcode
        ,department_ext  = c1rec.dept
        where id = c1rec.id;
  
  end loop;
  
  end;
  /
  
  UPDATE xwrl_note_templates
  SET LAST_UPDATE_DATE = SYSDATE
  ,CREATION_DATE = SYSDATE
  ,CREATED_BY = 1156
  ,LAST_UPDATED_BY = 1156
  WHERE ID = 1039;
  
  select *
  from xwrl_note_templates
  where note_type = 'CLEAR'
  AND NOTE_CATEGORY = 'INDIVIDUAL'
  --ORDER BY SORT_KEY
  ;

select *
from all_indexes
;

select *
FROM XWRL_REQUESTS WHERE ID = 17458
;

SELECT *
FROM XWRL_CASE_DOCUMENTS
WHERE REQUEST_ID = 17458
;

  
  CREATE INDEX xwrl.xwrl_note_templates_IDX1 ON
   xwrl_note_templates (
      note_category
      ,sort_key
   )

      TABLESPACE apps_ts_tx_idx;
  
  
  
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (80,'CLEAR','INDIVIDUAL','Full vetting to be completed upon the next transaction.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (50,'CLEAR','ENTITY','Full vetting to be completed upon the next transaction.');
commit;
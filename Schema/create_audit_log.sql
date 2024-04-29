/*

XWRL_DATA_UTILS;

alter table tmp_sql add  (id integer);

create sequence tmp_sql_seq;

CREATE OR REPLACE TRIGGER tmp_sql_trg
before insert on tmp_sql
for each row
begin
if :new.id is null then
   :new.id := tmp_sql_seq.nextval;
end  if;
end;
/

*/

SELECT LENGTH('XWRL_ALRT_CLR_XRF_AFT_IUD_TRG') FROM DUAL;
SELECT LENGTH('XWRL_CASE_DOCS_AFTER_IUD_TRG') FROM DUAL;
SELECT LENGTH('XWRL_PARTY_MST_AFTER_IUD_TRG') FROM DUAL;

SELECT LENGTH('XWRL_REQ_ENT_COLS_AFT_IUD_TRG') FROM DUAL;
SELECT LENGTH('XWRL_REQ_IND_COLS_AFT_IUD_TRG') FROM DUAL;

SELECT LENGTH('XWRL_RES_ENT_COLS_AFT_IUD_TRG') FROM DUAL;
SELECT LENGTH('XWRL_RES_IND_COLS_AFT_IUD_TRG') FROM DUAL;

select table_name, table_name||'_AFTER_IUD_TRG', length(table_name||'_AFTER_IUD_TRG') trigger_name_length
from all_tables
where table_name like 'XWRL\_%' escape '\'
and table_name in (
'XWRL_ALERT_CLEARING_XREF'
,'XWRL_ALERT_NOTES'
,'XWRL_CASE_DOCUMENTS'
,'XWRL_CASE_NOTES'
,'XWRL_PARTY_ALIAS'
,'XWRL_PARTY_MASTER'
,'XWRL_PARTY_XREF'
,'XWRL_REQUESTS'
,'XWRL_REQUEST_ENTITY_COLUMNS'
,'XWRL_REQUEST_IND_COLUMNS'
,'XWRL_RESPONSE_ENTITY_COLUMNS'
,'XWRL_RESPONSE_IND_COLUMNS'
)
order by table_name
;


truncate table tmp_sql;
      
begin

xwrl_data_utils.create_trigger_logic(upper('xwrl_alert_clearing_xref'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_alert_notes'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_case_documents'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_case_notes'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_party_alias'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_party_master'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_party_xref'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_request_entity_columns'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_request_ind_columns'),  'ID',  null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_requests'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_response_entity_columns'),  'ID', null);
--xwrl_data_utils.create_trigger_logic(upper('xwrl_response_ind_columns'),  'ID',  null);

end;
/

select v_sql from tmp_sql order by id;

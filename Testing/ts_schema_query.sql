/* World Check Online Screening Application - LEGACY */

select * from WC_SCREENING_REQUEST;
select * from wc_matches;
select * from wc_content;
select * from WORLDCHECK_EXTERNAL_XREF ORDER BY 1 DESC;
select * from wc_city_list ORDER BY 2;
select * from sicd_countries where sanction_status is not null and sanction_status <> 'NONE';   
select * from wc_request_documents order by wc_request_documents_id desc;

/* LEGACY ANALYSIS */
select * from xwrl_wc_contents;

/* REFERENCE */
select * from xwrl_keywords; -- Not used
select * from xwrl_location_types; -- Not used
select * from xwrl_parameters;
select * from xwrl_document_reference;
select * from sicd_countries;

/* MASTER */
select count(*) from xwrl_requests;

select * from xwrl_requests order by id ;

/* DETAIL - REQUEST */
select count(*) from xwrl_request_ind_columns;
select count(*) from xwrl_request_entity_columns;
select count(*) from xwrl_request_rows;

select * from xwrl_request_ind_columns order by id ;
select * from xwrl_request_entity_columns order by id ;
select * from xwrl_request_rows order by id ;

/* DETAIL - RESPONSE */
select count(*) from xwrl_response_ind_columns;
select count(*) from xwrl_response_entity_columns;
select count(*) from xwrl_response_rows;

select * from xwrl_response_ind_columns order by id;
select * from xwrl_response_entity_columns order by id ;
select * from xwrl_response_rows order by id ;

/* DETAIL - NOTES */
select count(*) from xwrl_case_notes;
select count(*) from xwrl_alert_notes;
select count(*) from xwrl_note_xref;

select * from xwrl_note_templates order by id desc;
select * from xwrl_case_notes order by id desc;
select * from xwrl_alert_notes order by id desc;
select * from xwrl_note_xref order by id desc;

/* DETAIL - DOCUMENTS */
select count(*) from xwrl_case_documents;

select * from xwrl_alert_documents order by id desc;
select * from xwrl_case_documents order by id desc;

/* DETAIL - EBS / OWS Cross Reference Table */
select count(*) from xwrl_alert_clearing_xref;

select * from xwrl_alert_clearing_xref order by id desc;

/* XREF tables */
select count(*)  from xwrl_party_master;
select count(*)  from xwrl_party_alias;
select count(*)  from xwrl_party_xref;
select count(*) from xwrl_alert_clearing_xref;

select * from xwrl_party_master order by id desc;
select * from xwrl_party_alias order by id desc;
select * from xwrl_party_xref order by id desc;

/* Approval History */
select count(*) from xwrl_request_approval_history;

select * from xwrl.xwrl_request_approval_history order by id desc;

/* Audit */
select count(*) from xwrl_audit_log;

select * from xwrl.xwrl_audit_log order by 1 desc;

/* VIEWS */
select * from  xwrl_case_documents_sum_v;
select * from  xwrl_case_notes_sum_v;
select * from  xwrl_ows_alias_identifier;
select * from  xwrl_ows_identifier;
select * from  xwrl_ows_party_identifier;
select * from  xwrl_party_cross_ref_v;
select * from  xwrl_request_approval_hist_v;

/* OWS PROD from IRIPROD */
select * from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com order by id desc;
select * from IRIP1_EDQCONFIG.dn_casecomment@ebstoows2.coresys.com;
select * from IRIP1_EDQCONFIG.dn_usergraveyard@ebstoows2.coresys.com;
select * from IRIP1_EDQCONFIG.DN_IDENTITY@ebstoows2.coresys.com;
select * from IRIP1_EDQCONFIG.dn_casehistory@ebstoows2.coresys.com;
select * from IRIP1_EDQCONFIG.DN_CASETRANSITIONS@ebstoows2.coresys.com;

select * from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com;
select * from IRIP2_EDQCONFIG.dn_casecomment@ebstoows2.coresys.com;
select * from IRIP2_EDQCONFIG.dn_usergraveyard@ebstoows2.coresys.com;
select * from IRIP2_EDQCONFIG.DN_IDENTITY@ebstoows2.coresys.com;
select * from IRIP2_EDQCONFIG.dn_casehistory@ebstoows2.coresys.com;
select * from IRIP2_EDQCONFIG.DN_CASETRANSITIONS@ebstoows2.coresys.com;

/* OWS TEST from IRIDEV */
select 1 from dual@ebstoows2.coresys.com;
select * from iridr_edqconfig.dn_case@ebstoows2.coresys.com order by id desc;
select * from iridr_edqconfig.dn_casecomment@ebstoows2.coresys.com;
select * from iridr_edqconfig.dn_usergraveyard@ebstoows2.coresys.com;
select * from iridr_edqconfig.DN_IDENTITY@ebstoows2.coresys.com;
select * from iridr_edqconfig.dn_casehistory@ebstoows2.coresys.com;
select * from iridr_edqconfig.DN_CASETRANSITIONS@ebstoows2.coresys.com;

select * from iridr2_edqconfig.dn_case@ebstoows2.coresys.com;
select * from iridr2_edqconfig.dn_casecomment@ebstoows2.coresys.com;
select * from iridr2_edqconfig.dn_usergraveyard@ebstoows2.coresys.com;
select * from iridr2_edqconfig.DN_IDENTITY@ebstoows2.coresys.com;
select * from iridr2_edqconfig.dn_casehistory@ebstoows2.coresys.com;
select * from iridr2_edqconfig.DN_CASETRANSITIONS@ebstoows2.coresys.com;

/* OWS Custom Tables IN OWS DATABASE */
select * from XXIRI_ALERT_VALIDATION;
select * from XXIRI_ALERT_LOG;

/* Permanent Debug */
select count(*) from xwrl_alerts_debug;
select count(*) from xwrl_alert_results_debug;

select * from xwrl_alerts_debug;
select * from xwrl_alert_results_debug;

--truncate table xwrl.xwrl_alerts_debug;
--truncate table xwrl.xwrl_alert_results_debug;

/* Temporary OWS logging tables saved in APPS */
select count(*) from tmp_xwrl_alerts;
select count(*) from tmp_xwrl_alert_results;

select * from tmp_xwrl_alerts;
select * from tmp_xwrl_alert_results order by p_alert_id desc;
select * from tmp_log;
select * from tmp_err_log;

--truncate table tmp_xwrl_alerts;
--truncate table tmp_xwrl_alert_results;
--truncate table tmp_log;
--truncate table tmp_err_log;

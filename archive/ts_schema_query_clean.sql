/* REFERENCE */
select * from xwrl_keywords; -- Not used
select * from xwrl_location_types; -- Not used
select * from xwrl_parameters;

/* MASTER */
select * from xwrl_requests where id = 1013;

/* DETAIL - REQUEST  XML*/
select * from xwrl_request_ind_columns ;
select * from xwrl_request_entity_columns WHERE request_id = 1013;
select * from xwrl_request_rows WHERE request_id = 1013;

/* DETAIL - RESPONSE XML*/
select * from xwrl_response_ind_columns;
select * from xwrl_response_entity_columns WHERE request_id = 1013;
select * from xwrl_response_rows WHERE request_id = 1013;

/* NOTES */
select * from xwrl_note_templates;
select * from xwrl_case_notes;
select * from xwrl_alert_notes;

/* DOCUMENTS */
select * from xwrl_alert_documents;
select * from xwrl_case_documents;

/* LEGACY ANALYSIS */
select * from xwrl_wc_contents


/* OWS */

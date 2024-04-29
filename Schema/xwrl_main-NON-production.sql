/* Pre-requisites
Users and Privileges created
apps_create_user_and_privileges.sql

Core Schema Object created by XWRL user

 */
 
 /* Obsolete */
 --@ XWRL_REQUESTS_IDXX1.sql  -- Created an Index on XWRL_REQUESTS   --- -- moved to apps_create_synonyms

/* Execute BEFORE data population */
@ xwrl_create_schema_objects.sql
@ xwrl_table_nologging.sql
@ XWRL_REQ_APPV_HISTORY_ID_SEQ.sql
@ XWRL_REQUEST_APPROVAL_HISTORY.sql
@ xwrl_requests_ins_upd.trg
@ xwrl_requests_post_upd.trg
@ xwrl_requests_upd.trg
@XWRL_IND_RESPONSE_LEGAL_REVIEW.trg
@XWRL_ENT_RESPONSE_LEGAL_REVIEW.trg
@ xwrl_category_restriction.trg  ---  xwrl_response_rows
@xwrl_vessel_indicator.trg  -- xwrl_response_rows
--@XWRL_IND_SYNC_PRIMARY_ALIAS.trg  -- Obsolete


/* Add CHANGE_LOG  triggers */
@ xwrl_requests_after_iud.trg
@ xwrl_response_ind_columns_after_iud.trg
@ xwrl_response_entity_columns_after_iud.trg
@ xwrl_case_notes_after_iud.trg
@ xwrl_alert_notes_after_iud.trg
@ xwrl_case_documents_after_iud.trg

/* Execute AFTER data population */
--@ xwrl_create_indexes.sql
--@ xwrl_create_indexes2.sql
--@ xwrl_table_logging.sql

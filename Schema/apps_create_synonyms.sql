/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: app_create_synonyms.sql.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                        $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : app_create_synonyms                                                                         *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                      *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    :                                                                                             *
* Last Reviewed Date  :                                                                                             *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO          15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I      Add XWRL_AUDIT_LOG              *
*                                                                                                                   *
********************************************************************************************************************/

/* APPS */

DROP SYNONYM xwrl_alert_documents;
DROP SYNONYM xwrl_alert_documents_seq;
DROP SYNONYM xwrl_alert_notes;
DROP SYNONYM xwrl_alert_notes_seq;
DROP SYNONYM xwrl_case_documents;
DROP SYNONYM xwrl_case_documents_seq;
DROP SYNONYM xwrl_case_notes;
DROP SYNONYM xwrl_case_notes_seq;
DROP SYNONYM xwrl_keywords;
DROP SYNONYM xwrl_location_types;
DROP SYNONYM xwrl_note_templates;
DROP SYNONYM xwrl_note_templates_seq;
DROP SYNONYM xwrl_parameters;
DROP SYNONYM xwrl_party_alias;
DROP SYNONYM xwrl_party_alias_seq;
DROP SYNONYM xwrl_party_master;
DROP SYNONYM xwrl_party_master_seq;
DROP SYNONYM xwrl_party_xref;
DROP SYNONYM xwrl_party_xref_seq;
DROP SYNONYM xwrl_requests;
DROP SYNONYM xwrl_requests1_seq;
DROP SYNONYM xwrl_requests2_seq;
DROP SYNONYM xwrl_requests3_seq;
DROP SYNONYM xwrl_requests4_seq;
DROP SYNONYM xwrl_requests5_seq;
DROP SYNONYM xwrl_requests6_seq;
DROP SYNONYM xwrl_requests_seq;
DROP SYNONYM xwrl_request_entity_columns;
DROP SYNONYM xwrl_request_ind_columns;
DROP SYNONYM xwrl_request_rows;
DROP SYNONYM xwrl_response_entity_columns;
DROP SYNONYM xwrl_response_ind_columns;
DROP SYNONYM xwrl_response_rows;
DROP SYNONYM xwrl_wc_contents;
DROP SYNONYM apps.xwrl_alert_in_rec;
DROP SYNONYM apps.xwrl_alert_tbl_in_type;
DROP SYNONYM apps.xwrl_alert_out_rec;
DROP SYNONYM apps.xwrl_alert_tbl_out_type;
DROP SYNONYM apps.xwrl_alert_clearing_xref_seq;
DROP SYNONYM apps.xwrl_alert_clearing_xref;
DROP SYNONYM apps.xwrl_batch_seq;
DROP SYNONYM apps.XWRL_CASE_NOTES_LINE_SEQ;
DROP SYNONYM apps.XWRL_ALERT_NOTES_LINE_SEQ;

DROP SYNONYM xwrl_doc_reference_seq;
DROP SYNONYM  xwrl_document_reference;

CREATE SYNONYM xwrl_alert_documents FOR xwrl.xwrl_alert_documents;
CREATE SYNONYM xwrl_alert_documents_seq FOR xwrl.xwrl_alert_documents_seq;
CREATE SYNONYM xwrl_alert_notes FOR xwrl.xwrl_alert_notes;
CREATE SYNONYM xwrl_alert_notes_seq FOR xwrl.xwrl_alert_notes_seq;
CREATE SYNONYM xwrl_case_documents FOR xwrl.xwrl_case_documents;
CREATE SYNONYM xwrl_case_documents_seq FOR xwrl.xwrl_case_documents_seq;
CREATE SYNONYM xwrl_case_notes FOR xwrl.xwrl_case_notes;
CREATE SYNONYM xwrl_case_notes_seq FOR xwrl.xwrl_case_notes_seq;
CREATE SYNONYM xwrl_keywords FOR xwrl.xwrl_keywords;
CREATE SYNONYM xwrl_location_types FOR xwrl.xwrl_location_types;
CREATE SYNONYM xwrl_note_templates FOR xwrl.xwrl_note_templates;
CREATE SYNONYM xwrl_note_templates_seq FOR xwrl.xwrl_note_templates_seq;
CREATE SYNONYM xwrl_parameters FOR xwrl.xwrl_parameters;
CREATE SYNONYM xwrl_party_alias FOR xwrl. xwrl_party_alias;
CREATE SYNONYM xwrl_party_alias_seq FOR xwrl. xwrl_party_alias_seq;
CREATE SYNONYM xwrl_party_master FOR xwrl.xwrl_party_master;
CREATE SYNONYM xwrl_party_master_seq  FOR xwrl.xwrl_master_xref_seq;
CREATE SYNONYM xwrl_party_xref FOR xwrl.xwrl_party_xref;
CREATE SYNONYM xwrl_party_xref_seq  FOR xwrl.xwrl_party_xref_seq;
CREATE SYNONYM xwrl_requests FOR xwrl.xwrl_requests;
CREATE SYNONYM xwrl_requests1_seq FOR xwrl.xwrl_requests1_seq;
CREATE SYNONYM xwrl_requests2_seq FOR xwrl.xwrl_requests2_seq;
CREATE SYNONYM xwrl_requests3_seq FOR xwrl.xwrl_requests3_seq;
CREATE SYNONYM xwrl_requests4_seq FOR xwrl.xwrl_requests4_seq;
CREATE SYNONYM xwrl_requests5_seq FOR xwrl.xwrl_requests5_seq;
CREATE SYNONYM xwrl_requests6_seq FOR xwrl.xwrl_requests6_seq;
CREATE SYNONYM xwrl_requests_seq FOR xwrl.xwrl_requests_seq;
CREATE SYNONYM xwrl_request_entity_columns FOR xwrl.xwrl_request_entity_columns;
CREATE SYNONYM xwrl_request_ind_columns FOR xwrl.xwrl_request_ind_columns;
CREATE SYNONYM xwrl_request_rows FOR xwrl.xwrl_request_rows;
CREATE SYNONYM xwrl_response_entity_columns FOR xwrl.xwrl_response_entity_columns;
CREATE SYNONYM xwrl_response_ind_columns FOR xwrl.xwrl_response_ind_columns;
CREATE SYNONYM xwrl_response_rows FOR xwrl.xwrl_response_rows;
CREATE SYNONYM xwrl_wc_contents FOR xwrl.xwrl_wc_contents;
CREATE SYNONYM apps.xwrl_alert_in_rec FOR xwrl.xwrl_alert_in_rec;
CREATE SYNONYM apps.xwrl_alert_tbl_in_type FOR xwrl.xwrl_alert_tbl_in_type;
CREATE SYNONYM apps.xwrl_alert_out_rec FOR xwrl.xwrl_alert_out_rec;
CREATE SYNONYM apps.xwrl_alert_tbl_out_type FOR xwrl.xwrl_alert_tbl_out_type;
CREATE SYNONYM apps.xwrl_alert_clearing_xref_seq FOR xwrl.xwrl_alert_clearing_xref_seq;
CREATE SYNONYM apps.xwrl_alert_clearing_xref FOR xwrl.xwrl_alert_clearing_xref;

CREATE SYNONYM apps.xwrl_batch_seq FOR xwrl.xwrl_batch_seq;

CREATE SYNONYM APPS.xwrl_doc_reference_seq FOR XWRL.xwrl_doc_reference_seq;
CREATE SYNONYM  APPS.xwrl_document_reference FOR XWRL.xwrl_document_reference;

DROP SYNONYM XXIRI_ALERT_VALIDATION;
DROP SYNONYM XXIRI_ALERT_LOG;
DROP SYNONYM XXIRI_CM_PROCESS_PKG;

CREATE SYNONYM  XXIRI_ALERT_VALIDATION FOR XOWS.XXIRI_ALERT_VALIDATION@EBSTOOWS2.CORESYS.COM;
CREATE SYNONYM  XXIRI_ALERT_LOG FOR XOWS.XXIRI_ALERT_LOG@EBSTOOWS2.CORESYS.COM;
CREATE SYNONYM XXIRI_CM_PROCESS_PKG FOR XOWS.XXIRI_CM_PROCESS_PKG@EBSTOOWS2.CORESYS.COM;

DROP SYNONYM XWRL.SICD_COUNTRIES;
DROP SYNONYM  XWRL.WC_CITY_LIST;

CREATE SYNONYM XWRL.SICD_COUNTRIES for SICD.SICD_COUNTRIES;
CREATE SYNONYM  XWRL.WC_CITY_LIST for VSSL.WC_CITY_LIST;

CREATE SYNONYM XWRL_CASE_NOTES_LINE_SEQ FOR XWRL.XWRL_CASE_NOTES_LINE_SEQ;
CREATE SYNONYM XWRL_ALERT_NOTES_LINE_SEQ FOR XWRL.XWRL_ALERT_NOTES_LINE_SEQ;

DROP SYNONYM XWRL_AUDIT_LOG_seq;
DROP SYNONYM XWRL_AUDIT_LOG;

CREATE SYNONYM XWRL_AUDIT_LOG_seq  FOR XWRL.XWRL_AUDIT_LOG_seq;
CREATE SYNONYM XWRL_AUDIT_LOG  FOR XWRL.XWRL_AUDIT_LOG;

 

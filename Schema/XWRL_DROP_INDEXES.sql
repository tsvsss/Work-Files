/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: xwrl_drop_indexes.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                            $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : xwrl_drop_indexes.sql                                                                     *
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
*                                                                                                                   *
********************************************************************************************************************/

/* DROP INDEXES */

DROP INDEX XWRL_ALERT_CLEARING_XREF_IDX1;
DROP INDEX XWRL_ALERT_CLEARING_XREF_IDX2;
DROP INDEX XWRL_ALERT_CLEARING_XREF_IDX3;
DROP INDEX XWRL_ALERT_CLEARING_XREF_IDX4;
DROP INDEX XWRL_ALERT_CLEARING_XREF_PK;
DROP INDEX XWRL_ALERT_CLEARING_XREF_UK;
DROP INDEX XWRL_ALERT_DOCUMENTS_IDX;
DROP INDEX XWRL_ALERT_DOCUMENTS_PK;
DROP INDEX XWRL_ALERT_NOTES_IDX;
DROP INDEX XWRL_ALERT_NOTES_PK;
DROP INDEX XWRL_ALERT_NOTES_UK;
DROP INDEX XWRL_AUDIT_LOG_PK;
DROP INDEX XWRL_CASE_DOCUMENTS_IDX;
DROP INDEX XWRL_CASE_DOCUMENTS_PK;
DROP INDEX XWRL_CASE_NOTES_IDX;
DROP INDEX XWRL_CASE_NOTES_PK;
DROP INDEX XWRL_CASE_NOTES_UK;
DROP INDEX XWRL_DOCUMENT_REFERENCE_PK;
DROP INDEX XWRL_DOC_REFERENCE_IDX;
DROP INDEX XWRL_DOC_REFERENCE_UK;
DROP INDEX XWRL_KEYWORDS_PK;
DROP INDEX XWRL_LOCATION_TYPES_PK;
DROP INDEX XWRL_NOTE_TEMPLATES_IDX1;
DROP INDEX XWRL_NOTE_TEMPLATES_PK;
DROP INDEX XWRL_PARAMETERS_PK;
DROP INDEX XWRL_PARTY_ALIAS_PK;
DROP INDEX XWRL_PARTY_MASTER_IDX1;
DROP INDEX XWRL_PARTY_MASTER_IDX2;
DROP INDEX XWRL_PARTY_MASTER_IDX3;
DROP INDEX XWRL_PARTY_MASTER_IDX4;
DROP INDEX XWRL_PARTY_MASTER_PK;
DROP INDEX XWRL_PARTY_XREF_IDX1;
DROP INDEX XWRL_PARTY_XREF_PK;
DROP INDEX XWRL_REQUESTS_IDX1;
DROP INDEX XWRL_REQUESTS_IDX10;
DROP INDEX XWRL_REQUESTS_IDX11;
DROP INDEX XWRL_REQUESTS_IDX12;
DROP INDEX XWRL_REQUESTS_IDX13;
DROP INDEX XWRL_REQUESTS_IDX14;
DROP INDEX XWRL_REQUESTS_IDX15;
DROP INDEX XWRL_REQUESTS_IDX16;
DROP INDEX XWRL_REQUESTS_IDX17;
DROP INDEX XWRL_REQUESTS_IDX18;
DROP INDEX XWRL_REQUESTS_IDX2;
DROP INDEX XWRL_REQUESTS_IDX3;
DROP INDEX XWRL_REQUESTS_IDX4;
DROP INDEX XWRL_REQUESTS_IDX5;
DROP INDEX XWRL_REQUESTS_IDX6;
DROP INDEX XWRL_REQUESTS_IDX7;
DROP INDEX XWRL_REQUESTS_IDX8;
DROP INDEX XWRL_REQUESTS_IDX9;
DROP INDEX XWRL_REQUESTS_IDXX1;
DROP INDEX XWRL_REQUESTS_PK;
DROP INDEX XWRL_REQUEST_ENTITY_COLS_IDX1;
DROP INDEX XWRL_REQUEST_ENTITY_COLUMNS_PK;
DROP INDEX XWRL_REQUEST_IND_COLUMNS_IDX1;
DROP INDEX XWRL_REQUEST_IND_COLUMNS_PK;
DROP INDEX XWRL_REQUEST_ROWS_IDX1;
DROP INDEX XWRL_REQUEST_ROWS_IDX2;
DROP INDEX XWRL_REQUEST_ROWS_PK;
DROP INDEX XWRL_RESPONSE_ENTITY_COLS_IDX1;
DROP INDEX XWRL_RESPONSE_ENTITY_COLS_IDX2;
DROP INDEX XWRL_RESPONSE_ENTITY_COLS_IDX3;
DROP INDEX XWRL_RESPONSE_ENTITY_COLS_IDX4;
DROP INDEX XWRL_RESPONSE_ENTITY_COLS_IDX5;
DROP INDEX XWRL_RESPONSE_ENTITY_COLS_IDX6;
DROP INDEX XWRL_RESPONSE_ENTITY_COLS_IDX7;
DROP INDEX XWRL_RESPONSE_ENTITY_COL_PK;
DROP INDEX XWRL_RESPONSE_IND_COLS_IDX1;
DROP INDEX XWRL_RESPONSE_IND_COLS_IDX2;
DROP INDEX XWRL_RESPONSE_IND_COLS_IDX3;
DROP INDEX XWRL_RESPONSE_IND_COLS_IDX4;
DROP INDEX XWRL_RESPONSE_IND_COLS_IDX5;
DROP INDEX XWRL_RESPONSE_IND_COLS_IDX6;
DROP INDEX XWRL_RESPONSE_IND_COLUMNS_IDX7;
DROP INDEX XWRL_RESPONSE_IND_COLUMNS_PK;
DROP INDEX XWRL_RESPONSE_ROWS_IDX1;
DROP INDEX XWRL_RESPONSE_ROWS_IDX2;
DROP INDEX XWRL_RESPONSE_ROWS_IDX3;
DROP INDEX XWRL_RESPONSE_ROWS_IDX4;
DROP INDEX XWRL_RESPONSE_ROWS_PK;
DROP INDEX XWRL_WC_CONTENTS_IDX1;
/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_table_statistcs.sql 1.1 2019/11/15 12:00:00ET   IRI Exp         $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : apps_table_statistcs.sql                                                                    *
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

exec  fnd_stats.gather_table_stats('XWRL','XWRL_ALERT_CLEARING_XREF',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_ALERT_DOCUMENTS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_ALERT_NOTES',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_AUDIT_LOG',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_CASE_DOCS_DEC112019',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_CASE_DOCUMENTS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_CASE_NOTES',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_DOCUMENT_REFERENCE',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_KEYWORDS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_LOCATION_TYPES',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_NOTE_TEMPLATES',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_PARAMETERS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_PARTY_ALIAS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_PARTY_MASTER',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_PARTY_XREF',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_REQUESTS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_REQUEST_APPROVAL_HISTORY',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_REQUEST_ENTITY_COLUMNS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_REQUEST_IND_COLUMNS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_REQUEST_ROWS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_RESPONSE_ENTITY_COLUMNS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_RESPONSE_IND_COLUMNS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_RESPONSE_ROWS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
exec  fnd_stats.gather_table_stats('XWRL','XWRL_WC_CONTENTS',100,NULL,NULL,'NOBACKUP',TRUE,'DEFAULT');
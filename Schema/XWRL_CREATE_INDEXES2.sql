/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: xwrl_create_indexes2.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                            $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : xwrl_create_indexes2.sql                                                                    *
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

/* Indexes for post-data population before XREF */
drop index xwrl_alert_clearing_xref_idx1;
drop index xwrl_alert_clearing_xref_idx2;
drop index xwrl_alert_clearing_xref_idx3;
drop index xwrl_alert_clearing_xref_idx4;
drop index xwrl_alert_clearing_xref_idx5;


CREATE INDEX xwrl_alert_clearing_xref_idx1 ON
   xwrl_alert_clearing_xref (
      wc_screening_request_id
   )
      TABLESPACE apps_ts_tx_idx;
      
      
CREATE INDEX xwrl_alert_clearing_xref_idx2 ON
   xwrl_alert_clearing_xref (
      case_key
   )
      TABLESPACE apps_ts_tx_idx;
      
CREATE INDEX xwrl_alert_clearing_xref_idx3 ON
   xwrl_alert_clearing_xref (
      alert_id
   )
      TABLESPACE apps_ts_tx_idx;
      
CREATE INDEX xwrl_alert_clearing_xref_idx4 ON
   xwrl_alert_clearing_xref (
      source_table, source_table_column, source_id,  list_id
   )
      TABLESPACE apps_ts_tx_idx;      
      
CREATE INDEX xwrl_alert_clearing_xref_idx5 ON
   xwrl_alert_clearing_xref (
      source_table,  source_id,  list_id
   )
      TABLESPACE apps_ts_tx_idx;            

      
CREATE INDEX xwrl_alert_clearing_xref_idx6 ON
   xwrl_alert_clearing_xref (
      request_id
   )
      TABLESPACE apps_ts_tx_idx;         
      
CREATE INDEX xwrl_alert_clearing_xref_idx7 ON
   xwrl_alert_clearing_xref (
      master_id, list_id
   )
      TABLESPACE apps_ts_tx_idx;            
      
      
      CREATE INDEX wc_content_idx5 ON
   wc_content (
      substr(matchentityidentifier,10)
   )
      TABLESPACE apps_ts_tx_idx; 
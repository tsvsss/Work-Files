
  CREATE OR REPLACE EDITIONABLE PACKAGE "APPS"."XWRL_DATA_PROCESSING" AS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_xwrl_data_processing.pks 1.1 2019/11/15 12:00:00ET   IRI Exp                               $*/
/********************************************************************************************************************
* Object Type         : Package Specification                                                                       *
* Name                : xwrl_data_processing                                                                        *
* Script Name         : apps_create_xwrl_data_processing.pks                                                        *
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
* 19-NOV-2019 IRI              1.2                TSUAZO          19-NOV-2019  I     Diable WC processing; Add Master record processing              *
*                                                                                                                   *
********************************************************************************************************************/

   v_rownum INTEGER := 10;

   /*
   PROCEDURE process_wc_data_individual (
      p_max_jobs INTEGER DEFAULT NULL
   );

   PROCEDURE process_wc_data_entity (
      p_max_jobs INTEGER DEFAULT NULL
   );

   PROCEDURE process_wc_xml_parser;

   */
   PROCEDURE process_ows_error_resubmit (
      p_max_jobs   INTEGER DEFAULT NULL
      , p_id         INTEGER DEFAULT NULL
   );

   PROCEDURE stop_schedule_processing;

   PROCEDURE stop_schedule_processing (
      p_end_date VARCHAR2
   );

   PROCEDURE stop_job_processing;

   PROCEDURE start_schedule_processing;

   PROCEDURE start_schedule_processing (
      p_start_date VARCHAR2
   );

   PROCEDURE create_job_processing (
      p_start_date VARCHAR2
   );

   FUNCTION verify_master_fullname (
      p_source_table          VARCHAR2
      , p_source_table_column   VARCHAR2
      , p_source_id             INTEGER
      , p_entity_type           VARCHAR2 DEFAULT NULL
      , p_target_column           VARCHAR2 DEFAULT NULL      
   ) RETURN VARCHAR2;


   PROCEDURE process_master_records(p_max_jobs INTEGER DEFAULT NULL);

   PROCEDURE ebs_master_records(p_max_jobs INTEGER DEFAULT NULL);

END xwrl_data_processing;
/

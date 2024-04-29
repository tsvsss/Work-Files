/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_jobs.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                               $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : apps_create_jobs.sql                                                                        *
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
/*
DECLARE
   v_job_name       VARCHAR2 (1000);
BEGIN
      v_job_name := 'PROCESS_WC_DATA_INDIVIDUAL';
      dbms_scheduler.drop_job(job_name => v_job_name);
 END;
  /
DECLARE
   v_job_name       VARCHAR2 (1000);  
 BEGIN
      v_job_name := 'PROCESS_WC_DATA_ENTITY';
     dbms_scheduler.drop_job(job_name => v_job_name);
 END;
 /

 DECLARE
   v_job_name       VARCHAR2 (1000);
 BEGIN
     v_job_name := 'PROCESS_WC_XML_PARSER';
     dbms_scheduler.drop_job(job_name => v_job_name);
 END;
/

 DECLARE
   v_job_name       VARCHAR2 (1000);
 BEGIN
     v_job_name := 'PROCESS_OWS_ERRORS';
     dbms_scheduler.drop_job(job_name => v_job_name, force => true);
 END;
/
*/

 DECLARE
   v_job_name       VARCHAR2 (1000);
 BEGIN
     v_job_name := 'PROCESS_MASTER_RECORDS';
     dbms_scheduler.drop_job(job_name => v_job_name, force => true);
 END;
/

BEGIN
DBMS_SCHEDULER.DROP_JOB_CLASS (
   job_class_name              => 'OWS_JOB_CLASS');
END;
/

BEGIN
DBMS_SCHEDULER.CREATE_JOB_CLASS (
   job_class_name              => 'OWS_JOB_CLASS',
   comments                    => 'This is an OWS job class');
END;
/


/* Process WC Individuals */
/*
DECLARE

   v_job_name       VARCHAR2 (1000);
   v_frequency integer;

BEGIN

      v_job_name := 'PROCESS_WC_DATA_INDIVIDUAL';
      v_frequency := xwrl_utils.get_frequency;
      
      dbms_scheduler.create_job (job_name => v_job_name
      , job_type => 'STORED_PROCEDURE'
      ,job_class => 'OWS_JOB_CLASS'
      ,job_action => 'XWRL_DATA_PROCESSING.PROCESS_WC_DATA_INDIVIDUAL'      
      , start_date => timestamp '2019-05-02 12:15:00'
      ,repeat_interval => 'FREQ=MINUTELY; INTERVAL='||v_frequency
      , end_date => NULL
      ,enabled => FALSE
      , comments => 'Process WC Individual data');

END;
/
*/
/* Process WC Entities */
/*
DECLARE

   v_job_name       VARCHAR2 (1000);
v_frequency integer;

BEGIN

      v_job_name := 'PROCESS_WC_DATA_ENTITY';
      v_frequency := xwrl_utils.get_frequency;

      dbms_scheduler.create_job (job_name => v_job_name
      , job_type => 'STORED_PROCEDURE'
      ,job_class => 'OWS_JOB_CLASS'
      ,job_action => 'XWRL_DATA_PROCESSING.PROCESS_WC_DATA_ENTITY'
      , start_date => timestamp '2019-05-02 12:15:00'
      ,repeat_interval => 'FREQ=MINUTELY; INTERVAL='||to_char(v_frequency)
      , end_date => NULL
      ,enabled => FALSE
      , comments => 'Process WC Entity data');

END;
/
*/

/* Process OWS Errors */


 DECLARE
   v_job_name       VARCHAR2 (1000);
 BEGIN
     v_job_name := 'PROCESS_OWS_ERRORS';
     dbms_scheduler.drop_job(job_name => v_job_name, force => true);
 END;
/

DECLARE

   v_job_name       VARCHAR2 (1000);
   v_frequency integer;

BEGIN

      v_job_name := 'PROCESS_OWS_ERRORS';
      v_frequency := xwrl_utils.get_frequency;
 
      dbms_scheduler.create_job (job_name => v_job_name
      , job_type => 'STORED_PROCEDURE'
      ,job_class => 'OWS_JOB_CLASS'
      ,job_action => 'XWRL_DATA_PROCESSING.PROCESS_OWS_ERROR_RESUBMIT'
      , start_date => timestamp '2019-05-02 12:15:00'
      ,repeat_interval => 'FREQ=MINUTELY; INTERVAL='||v_frequency
      , end_date => NULL
      ,enabled => FALSE
      , comments => 'Process OWS Errors for Resubmit');

END;
/


 DECLARE
   v_job_name       VARCHAR2 (1000);
 BEGIN
     v_job_name := 'PROCESS_MASTER_RECORDS';
     dbms_scheduler.drop_job(job_name => v_job_name, force => true);
 END;
/

DECLARE

   v_job_name       VARCHAR2 (1000);
   v_frequency integer;

BEGIN

      v_job_name := 'PROCESS_MASTER_RECORDS';
      v_frequency := xwrl_utils.get_frequency;
 
      dbms_scheduler.create_job (job_name => v_job_name
      , job_type => 'STORED_PROCEDURE'
      ,job_action => 'XWRL_DATA_PROCESSING.PROCESS_MASTER_RECORDS'
      , start_date => timestamp '2019-11-24 09:10:00'
      ,repeat_interval => 'FREQ=MINUTELY; INTERVAL='||v_frequency
      , end_date => NULL
      ,enabled => FALSE
      , comments => 'Process Master Records');

END;
/
/* Pre-requisites
Core Schema Objects created by XWRL user
 */
 -- Run as APPS

-- TSUAZO
--@ apps_create_synonyms.sql
--@ apps_create_schema_objects.sql
--@ apps_insert_parameters.sql
--@ apps_insert_note_templates.sql
--@ apps_insert_document_reference.sql



-- SAGARWAL

 --@RMI_OWS_COMMON_UTIL.pks
 --@RMI_OWS_COMMON_UTIL.pkb

-- @ IRI_SICD_ONLINE.pks  /*** NEED TO RUN ***/
-- @ IRI_SICD_ONLINE.pkb  /*** NEED TO RUN ***/
-- @ NRMI_CERTS.pks  /*** NEED TO RUN ***/
-- @ NRMI_CERTS.pkb  /*** NEED TO RUN ***/

--  Ran 11/09 @ GRANT_SCRIPT.sql

-- TSUAZO

-- @ apps_create_xwrl_ows_utils.pks
-- @ apps_create_xwrl_ows_utils.pkb
 @ apps_create_xwrl_utils.pks
 @ apps_create_xwrl_utils.pkb
-- @ apps_create_xwrl_data_processing.pks
 --@ apps_create_xwrl_data_processing.pkb
-- @ apps_create_xwrl_data_utils.pks
-- @ apps_create_xwrl_data_utils.pkb

-- Populate Requests from Party Tables using DBMS_SCHEDULER 

-- @ apps_create_jobs.sql
-- @ apps_create_programs.sql

-- TSUAZO (Populate reference tables from legacy system)

/* Need to continuously run until go-live */

--@ apps_populate_xwrl_party_master_individual.sql
--@ apps_populate_xwrl_party_master_entity.sql
--@ apps_data_fix_scripts.sql 
--@ apps_data_fix_scripts2.sql 
--@ apps_populate_xwrl_party_xref.sql 
--@ apps_data_fix_scripts3.sql 
--@ apps_data_fix_scripts4.sql   -- Backfill takes really long time
--@ apps_populate_xwrl_alert_clearing_xref.sql    
 
 -- TSUAZO (Trigger needs to be owned by APPS)
--  @ xwrl_requests_upd.trg

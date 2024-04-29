CREATE OR REPLACE PACKAGE APPS.world_check_iface AS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: world_check_iface.pks 1.1 2019/11/15 12:00:00ET   IRI Exp       										  $*/
/********************************************************************************************************************
* Object Type         : Package Specification                                                                       *
* Name                : world_check_iface                                                                           *
* Script Name         : world_check_iface.pks                                                                       *
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


/*world check statuses */

   --c_unspecified constant varchar2(20) :='UNSPECIFIED';
   c_initial_screen           CONSTANT VARCHAR2 (20) := 'INITIAL_SCREEN';
   c_false_match              CONSTANT VARCHAR2 (20) := 'NEGATIVE';
   c_possible_match           CONSTANT VARCHAR2 (20) := 'POSSIBLE';
   c_positive_match           CONSTANT VARCHAR2 (20) := 'POSITIVE';
   c_unspecified_match        CONSTANT VARCHAR2 (20) := 'UNSPECIFIED';
   c_new                      CONSTANT VARCHAR2 (20) := 'NEW';
   c_automatic_approval_uid   CONSTANT NUMBER        := 6126;
                                             /* aitomatic approval user_id */
   c_vessel                   CONSTANT VARCHAR2 (30) := 'VESSEL';
   c_individual               CONSTANT VARCHAR2 (30) := 'INDIVIDUAL';
   c_corporation              CONSTANT VARCHAR2 (30) := 'ORGANISATION';
   c_unspecified              CONSTANT VARCHAR2 (30) := 'UNSPECIFIED';
   delimiter                  CONSTANT VARCHAR2 (30) := ', ';
   comp_name_not_match        CONSTANT VARCHAR2 (30) := '*Name not a match';
   user_name_not_match        CONSTANT VARCHAR2 (30) := 'Name not a match';
   comp_dob_age_match         CONSTANT VARCHAR2 (30)
                                                    := '*DOB/Age not a match';
   user_dob_age_match         CONSTANT VARCHAR2 (30) := 'DOB/Age not a match';
   comp_sex_match             CONSTANT VARCHAR2 (30) := '*Sex not a match';
   user_sex_match             CONSTANT VARCHAR2 (30) := 'Sex not a match';
   comp_deceased_match        CONSTANT VARCHAR2 (30)
                                                    := '*Individual Deceased';
   user_deceased_match        CONSTANT VARCHAR2 (30) := 'Individual Deceased';
   user_visual_match          CONSTANT VARCHAR2 (40)
                                         := 'Individual visually not a match';
   comp_father_name_match     CONSTANT VARCHAR2 (40)
                                             := '*Father''s Name not a match';
   user_father_name_match     CONSTANT VARCHAR2 (30)
                                              := 'Father''s Name not a match';
   comp_imo_match             CONSTANT VARCHAR2 (40)
                                                 := '*IMO number not a match';
   user_imo_match             CONSTANT VARCHAR2 (30)
                                                  := 'IMO number not a match';
   comp_address               CONSTANT VARCHAR2 (40)
                                                    := '*Address not a match';
   comp_country               CONSTANT VARCHAR2 (40)
                                                   := '*Country  not a match';
   user_nm_cnnm               CONSTANT VARCHAR2 (40)
                                                := 'Chinese name not a match';
   mt_match_counter                    NUMBER        := 0;
   starting_pos                        NUMBER;
   prev_starting_pos                   NUMBER;
   c_maximum_number_of_hits   CONSTANT NUMBER        := 1000;

   TYPE display_details_rec IS RECORD (
      wc_content_id   NUMBER,
      heading         VARCHAR2 (100),
      data_type       VARCHAR2 (100),
      display_data    VARCHAR2 (4000)
   );

   TYPE display_details_tab IS TABLE OF display_details_rec
      INDEX BY BINARY_INTEGER;

   TYPE wc_external_xref_rec IS RECORD (
      source_table                  vssl.worldcheck_external_xref.source_table%TYPE,
      source_table_column           vssl.worldcheck_external_xref.source_table_column%TYPE,
      source_table_id               vssl.worldcheck_external_xref.source_table_id%TYPE,
      source_table_status_column    vssl.worldcheck_external_xref.source_table_status_column%TYPE,
      worldcheck_external_xref_id   vssl.worldcheck_external_xref.worldcheck_external_xref_id%TYPE,
      wc_screening_request_id       vssl.worldcheck_external_xref.wc_screening_request_id%TYPE,
      created_by                    vssl.worldcheck_external_xref.created_by%TYPE,
      creation_date                 vssl.worldcheck_external_xref.creation_date%TYPE,
      last_updated_by               vssl.worldcheck_external_xref.last_updated_by%TYPE,
      last_update_date              vssl.worldcheck_external_xref.last_update_date%TYPE,
      last_update_login             vssl.worldcheck_external_xref.last_update_login%TYPE
   );

   TYPE xref_tab IS TABLE OF wc_external_xref_rec
      INDEX BY BINARY_INTEGER;

   TYPE wc_screening_request_rec IS RECORD (
      wc_screening_request_id         vssl.wc_screening_request.wc_screening_request_id%TYPE,
      status                          vssl.wc_screening_request.status%TYPE,
      name_screened                   vssl.wc_screening_request.name_screened%TYPE,
      date_of_birth                   vssl.wc_screening_request.date_of_birth%TYPE,
      sex                             vssl.wc_screening_request.sex%TYPE,
      name_identifier                 vssl.wc_screening_request.name_identifier%TYPE,
      passport_number                 vssl.wc_screening_request.passport_number%TYPE,
      entity_type                     vssl.wc_screening_request.entity_type%TYPE,
      passport_issuing_country_code   vssl.wc_screening_request.passport_issuing_country_code%TYPE,
      corp_residence_country_code     vssl.wc_screening_request.corp_residence_country_code%TYPE,
      citizenship_country_code        vssl.wc_screening_request.citizenship_country_code%TYPE,
      status_updated_by               vssl.wc_screening_request.status_updated_by%TYPE,
      status_date                     vssl.wc_screening_request.status_date%TYPE,
      notes                           vssl.wc_screening_request.notes%TYPE,
      ofac_list_edoc_id               vssl.wc_screening_request.ofac_list_edoc_id%TYPE,
      ofac_list_is_enty_on_list       vssl.wc_screening_request.ofac_list_is_enty_on_list%TYPE,
      created_by                      vssl.wc_screening_request.created_by%TYPE,
      creation_date                   vssl.wc_screening_request.creation_date%TYPE,
      last_updated_by                 vssl.wc_screening_request.last_updated_by%TYPE,
      last_updated_date               vssl.wc_screening_request.last_update_date%TYPE,
      last_update_login               vssl.wc_screening_request.last_update_login%TYPE,
      sent_to_legal_date              vssl.wc_screening_request.sent_to_legal_date%TYPE,
      notify_user_upon_approval       vssl.wc_screening_request.notify_user_upon_approval%TYPE,
      residence_country_code          vssl.wc_screening_request.residence_country_code%TYPE,
      type_id                         vssl.wc_screening_request.type_id%TYPE,
      city_name                       vssl.wc_screening_request.city_name%TYPE,
      wc_city_list_id                 vssl.wc_screening_request.wc_city_list_id%TYPE,
      imo_number                      vssl.wc_screening_request.imo_number%TYPE,
      sent_to_legal_by                vssl.wc_screening_request.sent_to_legal_by%TYPE,
      requires_legal_approval         vssl.wc_screening_request.requires_legal_approval%TYPE
   );

   TYPE screening_tab IS TABLE OF wc_screening_request_rec
      INDEX BY BINARY_INTEGER;

   TYPE xref_tree_rec IS RECORD (
      wc_screening_request_id       vssl.wc_screening_request.wc_screening_request_id%TYPE,
--NAME_SCREENED VSSL.WC_SCREENING_REQUEST.NAME_SCREENED%type,
      name_screened                 VARCHAR2 (500),
      match_score                   NUMBER,
      node_id                       NUMBER,
      parent_node_id                NUMBER,
      reference_description         VARCHAR2 (500),
      worldcheck_external_xref_id   vssl.worldcheck_external_xref.worldcheck_external_xref_id%TYPE
   );

   TYPE xref_tree_tab IS TABLE OF xref_tree_rec
      INDEX BY BINARY_INTEGER;

   FUNCTION soap_envelope_start
      RETURN VARCHAR2;

   FUNCTION soap_envelope_end
      RETURN VARCHAR2;

   FUNCTION soap_header
      RETURN VARCHAR2;

   FUNCTION world_check_request (
      asignee_identifier   IN   VARCHAR2,
      custom_id1           IN   VARCHAR2,
      custom_id2           IN   VARCHAR2,
      group_identifier     IN   VARCHAR2,
      search_name          IN   VARCHAR2,
      name_type            IN   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION get_name_details (
      p_name_identifier   IN   VARCHAR2,
      p_match_type        IN   VARCHAR2,
      p_start             IN   VARCHAR2,
      p_limit             IN   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION get_name_matches (
      p_match_identifier   IN   VARCHAR2,
      p_match_risk         IN   VARCHAR2 DEFAULT 'UNKNOWN',
      p_match_status       IN   VARCHAR2 DEFAULT 'UNSPECIFIED',
      p_note               IN   VARCHAR2 DEFAULT NULL
   )
      RETURN VARCHAR2;

   FUNCTION get_new_updated_names
      RETURN VARCHAR2;

   FUNCTION get_content_details (p_match_identifier IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_content_summary (p_match_identifier IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION saveforongoingscreening (p_name_identifier IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION delete_screening (p_name_identifier IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION change_status (p_name_identifier IN VARCHAR2, p_status IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION add_name_note (p_name_identifier IN VARCHAR2, p_note IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION add_match_note (p_match_identifier IN VARCHAR2, p_note IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION add_match_status (
      p_match_identifier   IN   VARCHAR2,
      p_status             IN   VARCHAR2,
      p_note               IN   VARCHAR2,
      p_matchrisk          IN   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION archive_rec (p_name_identifier IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_content_titles (p_match_identifier IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_world_check_request_url
      RETURN VARCHAR2;

   FUNCTION get_world_check_name_url
      RETURN VARCHAR2;

   FUNCTION get_world_check_matches_url
      RETURN VARCHAR2;

   FUNCTION get_world_check_content_url
      RETURN VARCHAR2;

   FUNCTION get_stored_name_url
      RETURN VARCHAR2;

   PROCEDURE send_request (
      p_url            IN       VARCHAR2,
      p_request        IN       VARCHAR2,
      p_http_request   OUT      UTL_HTTP.req
   );

   PROCEDURE read_response (
      p_http_request   IN OUT   UTL_HTTP.req,
      p_response       OUT      XMLTYPE,
      return_code      OUT      NUMBER,
      return_message   OUT      VARCHAR2
   );

   PROCEDURE printelements (doc xmldom.domdocument, p_tag_name IN VARCHAR2);

   PROCEDURE printelementattributes (
      doc               xmldom.domdocument,
      p_tag_name   IN   VARCHAR2
   );

   PROCEDURE write_xml_file (
      v_domdoc   IN   DBMS_XMLDOM.domdocument,
      v_dir      IN   VARCHAR2,
      v_file     IN   VARCHAR2
   );

   PROCEDURE create_screening (
      search_name        IN       VARCHAR2,
      p_request_id       OUT      NUMBER,
      p_return_code      OUT      NUMBER,
      p_return_message   OUT      VARCHAR2
   );

   PROCEDURE process_name_matches (
      p_name_identifier           IN       VARCHAR2,
      p_wc_screening_request_id   IN       NUMBER,
      p_return_code               OUT      NUMBER,
      p_return_message            OUT      VARCHAR2
   );

   PROCEDURE get_contents_summary (
      p_match_identifier   IN       VARCHAR2,
      p_result_xml         OUT      XMLTYPE,
      p_return_code        OUT      NUMBER,
      p_return_message     OUT      VARCHAR2
   );

   PROCEDURE get_contents_details (
      p_match_identifier   IN       VARCHAR2,
      p_result_xml         OUT      XMLTYPE,
      p_return_code        OUT      NUMBER,
      p_return_message     OUT      VARCHAR2
   );

   PROCEDURE populate_match_details (
      p_match_id         IN       NUMBER,
      primary_match_id   IN       NUMBER,
      p_return_code      OUT      NUMBER,
      p_return_message   OUT      VARCHAR2
   );

   PROCEDURE approve_screening_request (
      p_wc_screening_request_id   IN       NUMBER,
      p_return_code               OUT      NUMBER,
      p_return_message            OUT      VARCHAR2
   );

   FUNCTION approve_screening_request (
      p_wc_screening_request_id   IN       NUMBER,
      p_return_code               OUT      NUMBER,
      p_return_message            OUT      VARCHAR2
   )
      RETURN BOOLEAN;

   PROCEDURE display_details (
      p_wc_content_id   IN       NUMBER,
      p_ddata           IN OUT   display_details_tab
   );

   PROCEDURE process_delete_screening (
      p_name_identifier   IN       VARCHAR2,
      return_code         OUT      NUMBER,
      return_message      OUT      VARCHAR2
   );

   PROCEDURE process_new_info (
      l_response_xml   OUT   XMLTYPE,
      return_code      OUT   NUMBER,
      return_message   OUT   VARCHAR2
   );

   PROCEDURE initiate_wc_screening (
      xref             IN OUT   world_check_iface.wc_external_xref_rec,
      req              IN OUT   world_check_iface.wc_screening_request_rec,
      p_custom_id1     IN       VARCHAR2,
      p_custom_id2     IN       VARCHAR2,
      return_code      OUT      NUMBER,
      return_message   OUT      VARCHAR2
   );

   PROCEDURE create_new_xref (
      xref             IN OUT   world_check_iface.wc_external_xref_rec,
      return_code      OUT      NUMBER,
      return_message   OUT      VARCHAR2
   );

   PROCEDURE push_status_to_creator (
      p_wc_screening_request_id   IN       NUMBER,
      return_code                 OUT      NUMBER,
      return_message              OUT      VARCHAR2
   );

   FUNCTION wc_locked (p_wc_screening_request_id IN NUMBER)
      RETURN VARCHAR2;

   PROCEDURE create_wc_seafarer_id (
      p_seafarer_id   IN       NUMBER,
      p_return_code   OUT      VARCHAR,
      p_ret_msg       OUT      VARCHAR2
   );

   PROCEDURE create_wc_generic (
      xref            IN OUT   world_check_iface.wc_external_xref_rec,
      req             IN OUT   world_check_iface.wc_screening_request_rec,
      p_custom_id1    IN       VARCHAR2,
      p_custom_id2    IN       VARCHAR2,
      p_return_code   OUT      VARCHAR,
      p_ret_msg       OUT      VARCHAR2
   );

   FUNCTION can_vetting_be_autoapproved (p_wc_screening_request_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_wc_status (
      p_xref   IN OUT   world_check_iface.wc_external_xref_rec,
      p_req    IN OUT   world_check_iface.wc_screening_request_rec
   )
      RETURN VARCHAR2;

   FUNCTION get_seafarer_wc_status (p_seafarer_id IN NUMBER)
      RETURN VARCHAR2;

   PROCEDURE query_cross_reference (
      p_source_table    IN       VARCHAR2,
      p_source_column   IN       VARCHAR2,
      p_source_id       IN       NUMBER,
      t_data            IN OUT   screening_tab
   );

   PROCEDURE get_custom_tag_info (
      p_xref         IN       world_check_iface.wc_external_xref_rec,
      p_custom_id1   IN OUT   VARCHAR2,
      p_custom_id2   IN OUT   VARCHAR2
   );

   PROCEDURE post_match_note (
      p_match_identifier   IN       VARCHAR2,
      p_note               IN       VARCHAR2,
      p_return_code        OUT      NUMBER,
      p_return_message     OUT      VARCHAR2
   );

   PROCEDURE post_match_status (
      p_match_identifier   IN       VARCHAR2,
      p_status             IN       VARCHAR2,
      p_note               IN       VARCHAR2,
      p_matchrisk          IN       VARCHAR2,
      p_return_code        OUT      NUMBER,
      p_return_message     OUT      VARCHAR2
   );

   PROCEDURE post_saveforongoingscreening (
      p_name_identifier   IN       VARCHAR2,
      p_return_code       OUT      NUMBER,
      p_return_message    OUT      VARCHAR2
   );

   FUNCTION has_name_been_checked_before (
      p_name_identifier   IN       VARCHAR2,
      t_data              IN OUT   world_check_iface.screening_tab
   )
      RETURN VARCHAR2;

   PROCEDURE get_context (
      p_wc_screening_request_id   IN       NUMBER,
      xrefs                       IN OUT   world_check_iface.xref_tab
   );

   PROCEDURE create_tree_table (
      p_name_screened   IN       VARCHAR2,
      tree_rec          IN OUT   xref_tree_tab
   );

   PROCEDURE create_xref_tree_table (
      p_wc_screening_request_id   IN       NUMBER,
      tree_rec                    IN OUT   xref_tree_tab
   );

   FUNCTION get_requesting_department (p_wc_screening_request_id IN NUMBER)
      RETURN VARCHAR2;

   PROCEDURE TEST;

   PROCEDURE refresh_wc_matches (
      p_wc_screening_request_id   IN       NUMBER,
      p_return_code               OUT      VARCHAR,
      p_ret_msg                   OUT      VARCHAR2
   );

   PROCEDURE refresh_all_related_tc (
      xref            IN       world_check_iface.wc_external_xref_rec,
      p_return_code   OUT      VARCHAR,
      p_ret_msg       OUT      VARCHAR2
   );

   PROCEDURE rerun_populate_match_details (
      p_wc_screening_request_id   IN       NUMBER,
      p_return_code               OUT      VARCHAR,
      p_ret_msg                   OUT      VARCHAR2
   );

   PROCEDURE delete_screening_request (
      p_screening_request_id   IN       NUMBER,
      return_code              OUT      NUMBER,
      return_message           OUT      VARCHAR2
   );

   PROCEDURE synchronize_alias_matches (
      p_screening_request_id   IN       NUMBER,
      return_code              OUT      NUMBER,
      return_message           OUT      VARCHAR2
   );

   PROCEDURE synchronize_documents (
      from_screening_request_id   IN       NUMBER,
      to_screening_request_id     IN       NUMBER,
      p_return_code               OUT      NUMBER,
      p_return_message            OUT      VARCHAR2
   );

   PROCEDURE send_notice (
      p_screening_request_id   IN       NUMBER,
      p_return_code            OUT      NUMBER,
      p_return_message         OUT      VARCHAR2
   );

   PROCEDURE send_notice_from_trigger (
      p_screening_request_id   IN       NUMBER,
      p_created_by             IN       NUMBER,
      p_name_screened          IN       VARCHAR2,
      p_status                 IN       VARCHAR2,
      p_notes                  IN       VARCHAR2,
      p_return_code            OUT      NUMBER,
      p_return_message         OUT      VARCHAR2
   );

   PROCEDURE tc_violation_from_trigger (
      p_screening_request_id          IN       NUMBER,
      p_created_by                    IN       NUMBER,
      p_name_screened                 IN       VARCHAR2,
      p_status                        IN       VARCHAR2,
      p_psp_issuing_country_code      IN       VARCHAR2,
      p_citizenship_country_code      IN       VARCHAR2,
      p_residence_country_code        IN       VARCHAR2,
      p_corp_residence_country_code   IN       VARCHAR2,
      p_message                       IN       VARCHAR2,
      p_return_code                   OUT      NUMBER,
      p_return_message                OUT      VARCHAR2
   );

   FUNCTION get_sanction_status (p_country_code IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION is_city_required (p_country_code IN VARCHAR2)
      RETURN BOOLEAN;

   FUNCTION get_city_tc_status (p_wc_city_list_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION auto_approve_country (p_country_code IN VARCHAR2)
      RETURN BOOLEAN;

   PROCEDURE update_wc_match_status (
      p_screening_request_id   IN       NUMBER,
      p_return_code            OUT      NUMBER,
      p_return_message         OUT      VARCHAR2
   );

   PROCEDURE create_screening_wrapper_org (
      search_name             IN   VARCHAR2,
      p_source_table          IN   VARCHAR2,
      p_source_table_column   IN   VARCHAR2,
      p_source_table_id       IN   NUMBER
   );

   PROCEDURE create_org_tc_request_dbms_job (
      search_name             IN   VARCHAR2,
      p_source_table          IN   VARCHAR2,
      p_source_table_column   IN   VARCHAR2,
      p_source_table_id       IN   NUMBER
   );

   FUNCTION does_wc_exist (
      p_xref   IN   world_check_iface.wc_external_xref_rec,
      p_req    IN   world_check_iface.wc_screening_request_rec
   )
      RETURN BOOLEAN;

   FUNCTION is_match_sanctioned (p_wc_content_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION is_request_sanctioned (p_wc_screening_request_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION update_comment (
      p_name           IN   VARCHAR2,
      p_dob            IN   VARCHAR2,
      p_sex            IN   VARCHAR2,
      p_dead           IN   VARCHAR2,
      p_visual         IN   VARCHAR2,
      p_fathers_name   IN   VARCHAR2,
      p_imo_number     IN   VARCHAR2,
      p_nm_cnnm        IN   VARCHAR2,
      p_notes          IN   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION build_comment (
      p_name      IN   VARCHAR2,
      p_dob       IN   VARCHAR2,
      p_sex       IN   VARCHAR2,
      p_dead      IN   VARCHAR2,
      p_visual    IN   VARCHAR2,
      p_address   IN   VARCHAR2,
      p_country   IN   VARCHAR,
      p_nm_cnnm   IN   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION can_revetting_be_autoapproved (p_wc_screening_request_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_pick_implementation_date
      RETURN DATE;

   FUNCTION is_entity_crimean (
      xref            IN       world_check_iface.wc_external_xref_rec,
      p_return_code   OUT      VARCHAR,
      p_ret_msg       OUT      VARCHAR2
   )
      RETURN VARCHAR2;

   PROCEDURE provisional_approval_process (
      p_screening_request_id   IN       NUMBER,
      p_return_code            OUT      NUMBER,
      p_return_message         OUT      VARCHAR2
   );

--SAURABH T20190307.0013 19-MAR-2019
   FUNCTION is_trade_legal_user (p_user_id IN NUMBER)
      RETURN VARCHAR2;

-- T20190801.0023 - SAURABH 02-AUG-2019
   FUNCTION name_in_blocklist (
      p_name_screened   IN       VARCHAR2,
      x_message         OUT      VARCHAR2
   )
      RETURN VARCHAR2;

-- T20190801.0023 - SAURABH 02-AUG-2019
   PROCEDURE send_notice_to_legal (
      p_name_screened   IN   VARCHAR2,
      x_message         IN   VARCHAR2
   );

   FUNCTION is_user_internal (p_user_id IN NUMBER)
      RETURN BOOLEAN;
END;
/

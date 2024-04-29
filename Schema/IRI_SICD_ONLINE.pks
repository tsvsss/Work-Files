CREATE OR REPLACE PACKAGE APPS.iri_sicd_online IS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: iri_sicd_online.pks 1.1 2019/11/15 12:00:00ET   IRI Exp                                                $*/
/********************************************************************************************************************
* Object Type         : Package Specification                                                                       *
* Name                : iri_sicd_online                                                                             *
* Script Name         : iri_sicd_online.pks                                                                         *
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


   c_oc                    CONSTANT VARCHAR2 (30)                     := 'OC';
   c_book                  CONSTANT VARCHAR2 (30)                   := 'BOOK';
   c_sqc                   CONSTANT VARCHAR2 (30)                    := 'SQC';
   c_cra                   CONSTANT VARCHAR2 (30)                    := 'CRA';
   c_ua                    CONSTANT VARCHAR2 (30)                     := 'UA';
   c_new                   CONSTANT VARCHAR2 (30)                    := 'New';
   c_renewal               CONSTANT VARCHAR2 (30)                := 'Renewal';
   c_replacement           CONSTANT VARCHAR2 (30)            := 'Replacement';
   c_pending               CONSTANT VARCHAR2 (30)                := 'Pending';
   c_active                CONSTANT VARCHAR2 (30)                 := 'Active';
   c_canceled              CONSTANT VARCHAR2 (30)               := 'Canceled';
   c_expired               CONSTANT VARCHAR2 (30)                := 'Expired';
   c_rejected              CONSTANT VARCHAR2 (30)               := 'Rejected';
   c_renewed               CONSTANT VARCHAR2 (30)                := 'Renewed';
   c_replaced              CONSTANT VARCHAR2 (30)               := 'Replaced';
   c_revoked               CONSTANT VARCHAR2 (30)                := 'Revoked';
   c_suspended             CONSTANT VARCHAR2 (30)              := 'Suspended';
   c_void                  CONSTANT VARCHAR2 (30)                   := 'Void';
   c_warning               CONSTANT VARCHAR2 (30)                := 'Warning';
   s_pending               CONSTANT VARCHAR2 (30)                := 'Pending';
   s_active                CONSTANT VARCHAR2 (30)                 := 'Active';
   s_inactive              CONSTANT VARCHAR2 (30)               := 'Inactive';
   s_warning               CONSTANT VARCHAR2 (30)                := 'Warning';
   s_suspended             CONSTANT VARCHAR2 (30)              := 'Suspended';
   s_rejected              CONSTANT VARCHAR2 (30)               := 'Rejected';
   s_deceased              CONSTANT VARCHAR2 (30)               := 'Deceased';
   c_book5                 CONSTANT VARCHAR2 (30)                    := '5YR';
   c_book10                CONSTANT VARCHAR2 (30)                    := '5YR';
      --we dont do 10 year books anymore but renewal logic should be the same
   c_book_yacht            CONSTANT VARCHAR2 (30)                  := 'YACHT';
   c_book_hotel            CONSTANT VARCHAR2 (30)                  := 'HOTEL';
   c_unlimited             CONSTANT VARCHAR2 (30)              := 'Unlimited';
   c_limited               CONSTANT VARCHAR2 (30)                := 'Limited';
   c_yes                   CONSTANT VARCHAR2 (30)                    := 'Yes';
   c_no                    CONSTANT VARCHAR2 (30)                     := 'No';
   c_org_name              CONSTANT VARCHAR2 (30)                    := 'IRI';
--c_org_name          CONSTANT VARCHAR2(30) := 'IRI ITEM MASTER';
   c_uom_rejected          CONSTANT VARCHAR2 (30)                    := 'REJ';
   c_endorsement_number    CONSTANT VARCHAR2 (30)                 := '000000';
   c_endorsement_country   CONSTANT VARCHAR2 (30)                   := 'CNCA';
   v_certificate_number             sicd_documents.certificate_type%TYPE;
   v_certificate_type               sicd_documents.certificate_type%TYPE;
   v_book_id                        sicd_documents.document_book_id%TYPE;
   v_book_number                    sicd_documents.book_number%TYPE;
   v_book_type                      sicd_documents.book_type%TYPE;
   v_date                           DATE;
   v_document_id                    sicd_documents.document_id%TYPE;
   v_document_book_id               sicd_documents.document_book_id%TYPE;
   v_document_previous_id           sicd_documents.document_previous_id%TYPE;
   v_expiration_date                sicd_documents.expiration_date%TYPE;
   v_grade_id                       sicd_grades.grade_id%TYPE;
   v_grade_code                     sicd_grades.grade_code%TYPE;
   v_id                             PLS_INTEGER;
   v_issue_type                     sicd_documents.issue_type%TYPE;
   v_limitation_name                sicd_limitations.limitation_name%TYPE;
   v_limited_text                   sicd_roles.limitations%TYPE;
   v_process_details                BOOLEAN;
   v_process_master                 BOOLEAN;
   v_renewal_period                 sicd_grades.renewal_period%TYPE;
   v_seafarer_id                    sicd_documents.seafarer_id%TYPE;
   v_segment3                       gl_code_combinations.segment3%TYPE;
   v_signer_id                      sicd_signers.signature_id%TYPE;
   v_signer_name                    sicd_signers.last_name%TYPE;
   v_sql                            VARCHAR2 (2000);
   v_status                         sicd_documents.status%TYPE;
   v_unlimited_text                 sicd_roles.limitations%TYPE;
   v_header_id                      NUMBER                            := NULL;
   v_line_id                        NUMBER                            := NULL;
   v_endorsement_number             sicd_documents.endorsement_number%TYPE;
   v_endorsement_country            sicd_documents.endorsement_country%TYPE;
   v_endorsement_issue_date         sicd_documents.endorsement_issue_date%TYPE;
   v_endorsement_expiration_date    sicd_documents.endorsement_expiration_date%TYPE;

   PROCEDURE create_order (
      p_esi_batch_id    IN       NUMBER,
      return_code       OUT      NUMBER,
      ret_msg           OUT      VARCHAR2,
      order_header_id   OUT      NUMBER
   );

   FUNCTION validate_seafarer (p_seafarer_id IN NUMBER)
      RETURN BOOLEAN;

   FUNCTION get_active_cra (p_seafarer_id IN NUMBER, p_grade_id IN NUMBER)
      RETURN NUMBER;

   PROCEDURE create_cra (
      p_esdi_id       IN       NUMBER,
      return_code     OUT      NUMBER,
      ret_msg         OUT      VARCHAR2,
      p_document_id   OUT      NUMBER
   );

   PROCEDURE send_book_cra (
      errbuf           OUT      VARCHAR2,
      retcode          OUT      NUMBER,
      c_esi_batch_id   IN       VARCHAR2
   );

   PROCEDURE send_invoice (
      errbuf         OUT      VARCHAR2,
      retcode        OUT      NUMBER,
      p_trx_number   IN       VARCHAR2
   );

   PROCEDURE update_status_after_printing (p_header_id IN VARCHAR2);

   FUNCTION is_courier_fee_required (
      p_created_by     IN   NUMBER,
      p_esi_batch_id   IN   NUMBER
   )
      RETURN VARCHAR2;

   PROCEDURE create_provisional_tc (
      p_esi_batch_id   IN       NUMBER,
      return_code      OUT      NUMBER,
      ret_msg          OUT      VARCHAR2
   );

   PROCEDURE resend_book_cra (
      errbuf           OUT      VARCHAR2,
      retcode          OUT      NUMBER,
      c_esi_batch_id   IN       VARCHAR2
   );

   FUNCTION get_seaf_order_type (p_esi_id IN NUMBER)
      RETURN VARCHAR2;
END iri_sicd_online;
/

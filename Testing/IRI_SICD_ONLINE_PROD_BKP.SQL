CREATE OR REPLACE PACKAGE APPS.iri_sicd_online
IS
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

   FUNCTION has_cra (p_esi_id IN NUMBER)
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

CREATE OR REPLACE PACKAGE BODY APPS.iri_sicd_online
IS
/*
DECLARE
  P_ESI_BATCH_ID NUMBER;
  RETURN_CODE NUMBER;
  RET_MSG VARCHAR2(200);
  ORDER_HEADER_ID NUMBER;

BEGIN
  P_ESI_BATCH_ID := 103;
  RETURN_CODE := NULL;
  RET_MSG := NULL;
  ORDER_HEADER_ID := NULL;

  APPS.IRI_SICD_ONLINE.CREATE_ORDER ( P_ESI_BATCH_ID, RETURN_CODE, RET_MSG, ORDER_HEADER_ID );
  dbms_output.put_line('RET_MSG '||RET_MSG);
  COMMIT;
END;

*/
   PROCEDURE create_order (
      p_esi_batch_id    IN       NUMBER,
      return_code       OUT      NUMBER,
      ret_msg           OUT      VARCHAR2,
      order_header_id   OUT      NUMBER
   )
   IS
/*return_code = 0 = success, 1=Warning 2=Error */
      DEBUG_MODE                      BOOLEAN                        := FALSE;
      p_return_code                   VARCHAR2 (300);
      p_return_message                VARCHAR2 (300);
      default_order_type              NUMBER                          := 1003;
      default_order_context           VARCHAR2 (30)                 := 'SICD';
      /* CORP, MARITIME, SICD, VREG, YACHT */
      default_payment_term_id         NUMBER                             := 5;
      /* Immediate */
      default_price_list_id           NUMBER                          := 9131;
      errormsg                        VARCHAR2 (240);
      error_num                       NUMBER;
      success_counter                 NUMBER;
      counter                         NUMBER;
      price_list_id                   NUMBER                          := NULL;
      p_api_version_number            NUMBER                           := 1.0;
      p_init_msg_list                 VARCHAR2 (300)  := apps.fnd_api.g_false;
      p_return_values                 VARCHAR2 (300)   := apps.fnd_api.g_true;
      p_action_commit                 VARCHAR2 (300);
      x_return_status                 VARCHAR2 (300);
      x_msg_count                     NUMBER;
      x_msg_data                      VARCHAR2 (2000);
      p_header_rec                    oe_order_pub.header_rec_type;
      p_old_header_rec                oe_order_pub.header_rec_type;
      p_header_val_rec                oe_order_pub.header_val_rec_type;
      p_old_header_val_rec            oe_order_pub.header_val_rec_type;
      p_header_adj_tbl                oe_order_pub.header_adj_tbl_type;
      p_old_header_adj_tbl            oe_order_pub.header_adj_tbl_type;
      p_header_adj_val_tbl            oe_order_pub.header_adj_val_tbl_type;
      p_old_header_adj_val_tbl        oe_order_pub.header_adj_val_tbl_type;
      p_header_price_att_tbl          oe_order_pub.header_price_att_tbl_type;
      p_old_header_price_att_tbl      oe_order_pub.header_price_att_tbl_type;
      p_header_adj_att_tbl            oe_order_pub.header_adj_att_tbl_type;
      p_old_header_adj_att_tbl        oe_order_pub.header_adj_att_tbl_type;
      p_header_adj_assoc_tbl          oe_order_pub.header_adj_assoc_tbl_type;
      p_old_header_adj_assoc_tbl      oe_order_pub.header_adj_assoc_tbl_type;
      p_header_scredit_tbl            oe_order_pub.header_scredit_tbl_type;
      p_old_header_scredit_tbl        oe_order_pub.header_scredit_tbl_type;
      p_header_scredit_val_tbl        oe_order_pub.header_scredit_val_tbl_type;
      p_old_header_scredit_val_tbl    oe_order_pub.header_scredit_val_tbl_type;
      p_line_tbl                      oe_order_pub.line_tbl_type;
      p_old_line_tbl                  oe_order_pub.line_tbl_type;
      p_line_val_tbl                  oe_order_pub.line_val_tbl_type;
      p_old_line_val_tbl              oe_order_pub.line_val_tbl_type;
      p_line_adj_tbl                  oe_order_pub.line_adj_tbl_type;
      p_old_line_adj_tbl              oe_order_pub.line_adj_tbl_type;
      p_line_adj_val_tbl              oe_order_pub.line_adj_val_tbl_type;
      p_old_line_adj_val_tbl          oe_order_pub.line_adj_val_tbl_type;
      p_line_price_att_tbl            oe_order_pub.line_price_att_tbl_type;
      p_old_line_price_att_tbl        oe_order_pub.line_price_att_tbl_type;
      p_line_adj_att_tbl              oe_order_pub.line_adj_att_tbl_type;
      p_old_line_adj_att_tbl          oe_order_pub.line_adj_att_tbl_type;
      p_line_adj_assoc_tbl            oe_order_pub.line_adj_assoc_tbl_type;
      p_old_line_adj_assoc_tbl        oe_order_pub.line_adj_assoc_tbl_type;
      p_line_scredit_tbl              oe_order_pub.line_scredit_tbl_type;
      p_old_line_scredit_tbl          oe_order_pub.line_scredit_tbl_type;
      p_line_scredit_val_tbl          oe_order_pub.line_scredit_val_tbl_type;
      p_old_line_scredit_val_tbl      oe_order_pub.line_scredit_val_tbl_type;
      p_lot_serial_tbl                oe_order_pub.lot_serial_tbl_type;
      p_old_lot_serial_tbl            oe_order_pub.lot_serial_tbl_type;
      p_lot_serial_val_tbl            oe_order_pub.lot_serial_val_tbl_type;
      p_old_lot_serial_val_tbl        oe_order_pub.lot_serial_val_tbl_type;
      p_action_request_tbl            oe_order_pub.request_tbl_type;
      x_header_rec                    oe_order_pub.header_rec_type;
      x_header_val_rec                oe_order_pub.header_val_rec_type;
      x_header_adj_tbl                oe_order_pub.header_adj_tbl_type;
      x_header_adj_val_tbl            oe_order_pub.header_adj_val_tbl_type;
      x_header_price_att_tbl          oe_order_pub.header_price_att_tbl_type;
      x_header_adj_att_tbl            oe_order_pub.header_adj_att_tbl_type;
      x_header_adj_assoc_tbl          oe_order_pub.header_adj_assoc_tbl_type;
      x_header_scredit_tbl            oe_order_pub.header_scredit_tbl_type;
      x_header_scredit_val_tbl        oe_order_pub.header_scredit_val_tbl_type;
      x_line_tbl                      oe_order_pub.line_tbl_type;
      x_line_val_tbl                  oe_order_pub.line_val_tbl_type;
      x_line_adj_tbl                  oe_order_pub.line_adj_tbl_type;
      x_line_adj_val_tbl              oe_order_pub.line_adj_val_tbl_type;
      x_line_price_att_tbl            oe_order_pub.line_price_att_tbl_type;
      x_line_adj_att_tbl              oe_order_pub.line_adj_att_tbl_type;
      x_line_adj_assoc_tbl            oe_order_pub.line_adj_assoc_tbl_type;
      x_line_scredit_tbl              oe_order_pub.line_scredit_tbl_type;
      x_line_scredit_val_tbl          oe_order_pub.line_scredit_val_tbl_type;
      x_lot_serial_tbl                oe_order_pub.lot_serial_tbl_type;
      x_lot_serial_val_tbl            oe_order_pub.lot_serial_val_tbl_type;
      x_action_request_tbl            oe_order_pub.request_tbl_type;
      sirb_number                     NUMBER;
      last_sirb_number                NUMBER;
      p_expiration_date               DATE;
      last_sirb_id                    NUMBER;
      

      CURSOR get_latest_book_number (p_document_id IN NUMBER)
      IS
         SELECT document_id, expiration_date, book_number
           FROM sicd_documents
          WHERE document_id = p_document_id;
          

      CURSOR get_seafarers_latest_book (p_seafarer_id IN NUMBER)
      IS
         SELECT   document_id, expiration_date, book_number
             FROM sicd_documents
            WHERE seafarer_id = p_seafarer_id
              AND document_type = c_book
              AND book_type IN (c_book5, c_book10)
              AND status = c_active
         ORDER BY expiration_date DESC;
         

      sqc_expiration_date             DATE;
      oc_expiration_date              DATE;
      old_oc_document_id              NUMBER;
      cra_expiration_date             DATE;
      old_cra_document_id             NUMBER;
      sirb_expiration_date            DATE;


      CURSOR get_previous_cra_id (p_seafarer_id IN NUMBER, p_grade_id IN NUMBER)
      IS
         SELECT   document_id, expiration_date
             FROM sicd_documents
            WHERE seafarer_id = p_seafarer_id
              AND grade_id = p_grade_id
              AND document_type = 'OC'
              AND certificate_type IN ('CRA', 'UA')
              AND status IN ('Active', 'Expired')
              AND expiration_date > SYSDATE - 120
         ORDER BY expiration_date DESC;
         

      CURSOR get_previous_oc_id (p_document_id IN NUMBER)
      IS
         SELECT   document_id, expiration_date
             FROM sicd_documents sd, sicd_grades sg
            WHERE document_id = p_document_id
         ORDER BY expiration_date DESC, sd.status;
         

      -- ZK Added status 04132015 --Modiffed MT 11/17/15
      CURSOR get_previous_sqc_id (p_document_id IN NUMBER)
      IS
         SELECT   document_id, expiration_date
             FROM sicd_documents
            WHERE document_id = p_document_id
         ORDER BY expiration_date DESC, status;
         

      -- ZK Added status 04132015 --Modiffed MT 11/17/15
      old_sqc_document_id             NUMBER;
      l_message                       VARCHAR2 (2000);
      l_msg_index_out                 NUMBER;
      l_index                         NUMBER;
      error_msg                       VARCHAR2 (2000);
      e_index                         NUMBER;
      e_count                         NUMBER;
      l_order_id_n                    NUMBER;
      l_msg_count_n                   NUMBER;
      l_line_idx_bi                   BINARY_INTEGER;
      l_status_c                      VARCHAR2 (1);
      l_message_s                     VARCHAR2 (2000);
      l_orig_header_rec               oe_order_pub.header_rec_type;
      l_orig_header_val_rec           oe_order_pub.header_val_rec_type;
      l_orig_header_adj_tbl           oe_order_pub.header_adj_tbl_type;
      l_orig_header_adj_val_tbl       oe_order_pub.header_adj_val_tbl_type;
      l_orig_header_price_att_tbl     oe_order_pub.header_price_att_tbl_type;
      l_orig_header_adj_att_tbl       oe_order_pub.header_adj_att_tbl_type;
      l_orig_header_adj_assoc_tbl     oe_order_pub.header_adj_assoc_tbl_type;
      l_orig_header_scredit_tbl       oe_order_pub.header_scredit_tbl_type;
      l_orig_header_scredit_val_tbl   oe_order_pub.header_scredit_val_tbl_type;
      l_orig_line_tbl                 oe_order_pub.line_tbl_type;
      l_orig_line_val_tbl             oe_order_pub.line_val_tbl_type;
      l_orig_line_adj_tbl             oe_order_pub.line_adj_tbl_type;
      l_orig_line_adj_val_tbl         oe_order_pub.line_adj_val_tbl_type;
      l_orig_line_price_att_tbl       oe_order_pub.line_price_att_tbl_type;
      l_orig_line_adj_att_tbl         oe_order_pub.line_adj_att_tbl_type;
      l_orig_line_adj_assoc_tbl       oe_order_pub.line_adj_assoc_tbl_type;
      l_orig_line_scredit_tbl         oe_order_pub.line_scredit_tbl_type;
      l_orig_line_scredit_val_tbl     oe_order_pub.line_scredit_val_tbl_type;
      l_orig_lot_serial_tbl           oe_order_pub.lot_serial_tbl_type;
      l_orig_lot_serial_val_tbl       oe_order_pub.lot_serial_val_tbl_type;
      

      CURSOR get_verify_docs (p_header_id IN NUMBER)
      IS
         SELECT COUNT (*)
           FROM sicd_documents sd, sicd_grades sg
          WHERE header_id = p_header_id
            AND sg.grade_id = sd.grade_id
            AND (NVL (verified, 'P') = 'P' OR verified IS NULL)
            AND document_type = 'OC'
            AND certificate_type = 'OC'
            AND (sg.verification_reqd = 'Y' OR grading_status = 'V');
            

      nof_docs_to_grade  NUMBER := 0;
      

      CURSOR get_default_sales_rep_id (cust_id IN NUMBER)
      IS
         SELECT primary_salesrep_id
           FROM ar_customers
          WHERE customer_id = cust_id;
          

      sales_rep_id    NUMBER;
      

      CURSOR get_batch_info
      IS
         SELECT *
           FROM exsicd_batch_iface
          WHERE esi_batch_id = p_esi_batch_id;
          

      batch_rec     get_batch_info%ROWTYPE;
      

      CURSOR get_seafarer_info
      IS
         SELECT   *
             FROM exsicd_seafarers_iface
            WHERE esi_batch_id = p_esi_batch_id
         ORDER BY esi_id;
         

      seafarer_rec      get_seafarer_info%ROWTYPE;
      

      CURSOR get_oc (p_esi_id IN NUMBER)
      IS
         SELECT   *
             FROM exsicd_seafarer_docs_iface
            WHERE esi_id = p_esi_id AND grade_type = 'OC'
         ORDER BY esdi_id;
         

      oc_rec                          get_oc%ROWTYPE;
      

      CURSOR get_sqc (p_esi_id IN NUMBER)
      IS
         SELECT   *
             FROM exsicd_seafarer_docs_iface
            WHERE esi_id = p_esi_id AND grade_type = 'SQC'
         ORDER BY esdi_id;
         

      sqc_rec                         get_sqc%ROWTYPE;
      

      CURSOR get_grade_detail (p_grade_id IN INTEGER)
      IS
         SELECT *
           FROM sicd_grades
          WHERE grade_id = p_grade_id;
          

      grade_rec                       get_grade_detail%ROWTYPE;
      

      CURSOR get_uom (p_inventory_item_id IN NUMBER, p_price_list_id IN NUMBER)
      IS
         SELECT l.product_uom_code
           FROM qp_list_lines_v l
          WHERE l.primary_uom_flag = 'Y'
            AND l.product_id = p_inventory_item_id
            AND list_header_id = p_price_list_id;
            

      CURSOR get_order (p_header_id IN NUMBER)
      IS
         SELECT *
           FROM oe_order_headers_all
          WHERE header_id = p_header_id;
          

      order_rec                       get_order%ROWTYPE;
      uom_code                        VARCHAR2 (30);
      resp_appl_id                    NUMBER;
      responsibility_id               NUMBER;
      user_id                         NUMBER;
      login_id                        NUMBER;
      c                               NUMBER;
      quantity                        NUMBER;
      std_price                       NUMBER;
      cursor_variable                 INTEGER;
      varchar_result                  VARCHAR2 (2);
      string_result                   VARCHAR2 (500);
      ignore                          INTEGER;
      sql_string                      VARCHAR2 (500);
      interface_line                  NUMBER;
      document_file_name              VARCHAR2 (300)                   := NULL;
      source_dir                      VARCHAR2 (300)                   := NULL;
      source_file_name                VARCHAR2 (300)                   := NULL;
      dest_dir                        VARCHAR2 (300)                   := NULL;
      dest_file_name                  VARCHAR2 (300)                   := NULL;
      cret_msg                        VARCHAR2 (50)                    := NULL;
      nof_seafarers                   NUMBER                              := 0;
      xyz                             NUMBER                              := 0;
      x_debug_file                    VARCHAR2 (100);
      p_xref                          rmi_ows_common_util.wc_external_xref_rec;
      is_crimean                      VARCHAR2 (1)                      := 'N';
      
      
      
   BEGIN
   
   
      DBMS_OUTPUT.ENABLE (70000);
      success_counter := 0;
      return_code := 0;
      errormsg := 'Everything is OK.';
      oe_debug_pub.initialize;
      oe_debug_pub.debug_on;
      oe_msg_pub.initialize;
      oe_debug_pub.setdebuglevel (5);
      resp_appl_id := TO_NUMBER (fnd_profile.VALUE ('RESP_APPL_ID'));
      responsibility_id := TO_NUMBER (fnd_profile.VALUE ('RESP_ID'));
      user_id := fnd_profile.VALUE ('USER_ID');
      login_id := TO_NUMBER (fnd_profile.VALUE ('LOGIN_ID'));
      

      IF user_id IS NULL
      THEN
         user_id := 2805;
      END IF;
      

      IF responsibility_id IS NULL
      THEN
         responsibility_id := 50611;
      END IF;
      

      IF resp_appl_id IS NULL
      THEN
         resp_appl_id := 20029;
      END IF;
      

      mo_global.init ('ONT');
      mo_global.set_policy_context ('S', 122);
      fnd_global.apps_initialize (user_id, responsibility_id, resp_appl_id);
      DBMS_APPLICATION_INFO.set_client_info (122);
      

      IF DEBUG_MODE
      THEN
         oe_debug_pub.initialize;
         oe_debug_pub.debug_on;
         oe_msg_pub.initialize;
         oe_debug_pub.setdebuglevel (25);
         x_debug_file := oe_debug_pub.set_debug_mode ('FILE');
      END IF;
      

      OPEN get_batch_info;

      FETCH get_batch_info
       INTO batch_rec;

      CLOSE get_batch_info;
      

      ret_msg := 'Setting Up Order Header';

      -- SETTING UP THE HEADER RECORD
      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line
                ('****************************Setting up header*************');
      END IF;
      

      p_header_rec := oe_order_pub.g_miss_header_rec;
      p_header_rec.order_type_id := default_order_type;
      p_header_rec.pricing_date := SYSDATE;
      p_header_rec.transactional_curr_code := 'USD';
      p_header_rec.cust_po_number :=
                               SUBSTR (batch_rec.purchase_order_number, 1, 50);
      p_header_rec.salesrep_id :=
         TO_NUMBER
            (exsicd_profiles_pkg.get_user_profile (batch_rec.created_by,
                                                   'Default Processing Office'
                                                  )
            );
            
            

      IF p_header_rec.salesrep_id IS NULL
      THEN
         BEGIN
            OPEN get_default_sales_rep_id (batch_rec.bill_to_cust_account_id);

            FETCH get_default_sales_rep_id
             INTO sales_rep_id;

            CLOSE get_default_sales_rep_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               ret_msg := 'Problem getting default sales rep.';
               return_code := 2;
               order_header_id := NULL;
               RETURN;
         END;

         /* get the default salesrep_id for the customer    */
         /* if the customer does not have a default then    */
         /* get the person running the procedure's default  */
         /* salesrep_id                                     */
         IF sales_rep_id IS NULL
         THEN
            p_header_rec.salesrep_id :=
                                  fnd_profile.VALUE ('ONT_DEFAULT_PERSON_ID');
         /* get default sales rep id for user*/
         ELSE
            p_header_rec.salesrep_id := sales_rep_id;
         /* get default sales rep id for customer*/
         END IF;
      END IF;
      

/* header validation */
/* process order header context information */

      /* populate order header additonal infomation */

      /*  save this code we will have to populate some header information later
         if upper(template.header_column_name) = 'ATTRIBUTE1' then
         P_header_rec.attribute1:=string_result;
         elsif upper(template.header_column_name) = 'ATTRIBUTE2' then
         P_header_rec.attribute2:=string_result;
         elsif upper(template.header_column_name) = 'ATTRIBUTE3' then
         P_header_rec.attribute3:=string_result;
         elsif upper(template.header_column_name) = 'ATTRIBUTE4' then
         P_header_rec.attribute4:=string_result;
         elsif upper(template.header_column_name) = 'ATTRIBUTE5' then
         P_header_rec.attribute5:=string_result;
         elsif upper(template.header_column_name) = 'ATTRIBUTE6' then
         P_header_rec.attribute6:=string_result;
         elsif upper(template.header_column_name) = 'ATTRIBUTE7' then
         P_header_rec.attribute7:=string_result;
         elsif upper(template.header_column_name) = 'ATTRIBUTE8' then
         P_header_rec.attribute8:=string_result;
         elsif upper(template.header_column_name) = 'ATTRIBUTE9' then
         P_header_rec.attribute9:='Pending Data Verification';
         elsif upper(template.header_column_name) = 'ATTRIBUTE10' then
         P_header_rec.attribute10:=string_result;
         end if;

      */
      p_header_rec.CONTEXT := NULL;
      /* get the default price list for this user */
      price_list_id :=
         TO_NUMBER (exsicd_profiles_pkg.get_user_profile (user_id,
                                                          'LIST_HEADER_ID'
                                                         )
                   );

      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line ('price_list_id ' || TO_CHAR (price_list_id));
      END IF;

      p_header_rec.price_list_id := price_list_id;
      p_header_rec.operation := oe_globals.g_opr_create;

      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line (   'created by '
                               || get_username_propername
                                                         (batch_rec.created_by)
                              );
      END IF;

      p_header_rec.sold_to_org_id :=
         NVL (exsicd_profiles_pkg.get_user_profile (batch_rec.created_by,
                                                    'Ordered By Customer ID'
                                                   ),
              batch_rec.bill_to_cust_account_id
             );
      p_header_rec.invoice_to_org_id := batch_rec.bill_to_site_use_id;
      p_header_rec.ship_to_org_id := batch_rec.ship_to_site_use_id;
      p_header_rec.deliver_to_org_id :=
                    get_deliver_to_site_use_id (batch_rec.ship_to_site_use_id);

      -- MT 8/22/16
      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line (   'sold_to_org_id '
                               || TO_CHAR (p_header_rec.sold_to_org_id)
                              );
         DBMS_OUTPUT.put_line (   'invoice_to_org_id '
                               || TO_CHAR (p_header_rec.invoice_to_org_id)
                              );
         DBMS_OUTPUT.put_line (   'bill_to_site_use_id '
                               || TO_CHAR (batch_rec.bill_to_site_use_id)
                              );
         DBMS_OUTPUT.put_line (   'ship_to_site_use_id '
                               || TO_CHAR (batch_rec.ship_to_site_use_id)
                              );
         DBMS_OUTPUT.put_line
                 (   'get_ship_site_use_id'
                  || TO_CHAR
                          (get_ship_site_use_id (batch_rec.bill_to_site_use_id)
                          )
                 );
      END IF;

      p_header_rec.payment_term_id := default_payment_term_id;
      p_header_rec.shipping_instructions := batch_rec.vessel_names;
      counter := 1;

      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line ('--Seafarers --');
      END IF;

      FOR seafarer IN get_seafarer_info
      LOOP
         ret_msg := 'Processing Seafarer ' || TO_CHAR (seafarer.seafarer_id);
         nof_seafarers := nof_seafarers + 1;
         last_sirb_number := NULL;
         last_sirb_id := NULL;                           -- Added 05152015 ZK
         sirb_number := NULL;
/***********************************************/

         /*We have to determine if a seafarer is from Crimea if so then they have to be invoiced seperately so by setting attribute12 for each line items they will seperate out based on the Autoinvoice grouping rules */
/*    4/18/16 MT   */
         p_xref.source_table := 'SICD_SEAFARERS';
         p_xref.source_table_column := 'SEAFARER_ID';
         p_xref.source_table_id := seafarer.seafarer_id;
         is_crimean := 'N';

         /*is_crimean :=world_check_iface.is_entity_crimean (p_xref,
                                                 p_return_code,
                                                 p_return_message
                                                );*/ --Commented by Abhishek 20-Feb-2020 T20191120.0012
         is_crimean := rmi_ows_common_util.is_entity_crimean (p_xref,
                                                 p_return_code,
                                                 p_return_message
                                                );--Added by Abhishek 20-Feb-2020 T20191120.0012

/**********************************************/
         IF validate_seafarer (seafarer.seafarer_id) = FALSE
         THEN
/* seafarer does not exist, so create the record*/
            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line
                                 (   'Seafarer_id does not exist.  Creating '
                                  || TO_CHAR (seafarer.seafarer_id)
                                 );
            END IF;

            ret_msg :=
                  'Processing Seafarer '
               || TO_CHAR (seafarer.seafarer_id)
               || ' creating seafarer record';

            INSERT INTO sicd.sicd_seafarers
                        (seafarer_id, last_name,
                         first_name, middle_initial,
                         birth_date, birth_place,
                         nationality, status, gender,
                         distinguishing_marks, notes,
                         created_by, creation_date, last_updated_by,
                         last_update_date, last_update_login
                        )
                 VALUES (seafarer.seafarer_id, seafarer.last_name,
                         seafarer.first_name, seafarer.middle_initial,
                         seafarer.birth_date, seafarer.birth_place,
                         seafarer.nationality, 'Active', seafarer.gender,
                         seafarer.distinguishing_marks, seafarer.notes,
                         user_id, SYSDATE, user_id,
                         SYSDATE, login_id
                        );
         ELSE
/* seafarer exists so update information if applicable*/
            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line (   'Seafarer_id exists.  Updating '
                                     || TO_CHAR (seafarer.seafarer_id)
                                    );
            END IF;

            ret_msg :=
                  'Processing Seafarer '
               || TO_CHAR (seafarer.seafarer_id)
               || ' updating seafarer record';

            UPDATE sicd.sicd_seafarers
               SET status = 'Active',
                   last_name = seafarer.last_name,
                   first_name = seafarer.first_name,
                   middle_initial = seafarer.middle_initial,
                   birth_date = seafarer.birth_date,
                   birth_place = seafarer.birth_place,
                   nationality = seafarer.nationality,
                   gender = seafarer.gender,
                   distinguishing_marks = seafarer.distinguishing_marks,
                   notes = notes || CHR (10) || seafarer.notes,
                   last_updated_by = user_id,
                   last_update_date = SYSDATE,
                   last_update_login = login_id
             WHERE seafarer_id = seafarer.seafarer_id;
         END IF;

/* copy over photo  and  attach to seafarer */
         IF seafarer.photo_edoc_id IS NOT NULL
         THEN
            document_file_name :=
                    iri_edocs_pkg.get_edoc_file_name (seafarer.photo_edoc_id);
            ret_msg :=
                  'Processing Seafarer '
               || TO_CHAR (seafarer.seafarer_id)
               || ' adding photo';

            IF document_file_name IS NOT NULL
            THEN
               source_dir := get_file_path (document_file_name);
               source_file_name := GET_FILE_NAME (document_file_name);
               dest_dir := iri_html.get_base_path ('SICD_PHOTOS');
               dest_file_name := TO_CHAR (seafarer.seafarer_id) || '.jpeg';
               cret_msg :=
                  SUBSTR (java_util_file.COPY (source_dir,
                                               dest_dir,
                                               source_file_name,
                                               dest_file_name
                                              ),
                          1,
                          50
                         );

               /*IF cret_msg != 'Y'
               THEN
                 ret_msg:='Processing Seafarer '||to_char(seafarer.seafarer_id)||' Error moving photo';
                  raise_application_error
                         (-20002,
                          'create_order - Error moving photo Seafarer '||to_char(seafarer.seafarer_id)||' '||seafarer.last_name||' '||cret_msg
                         );
                 END IF;*/
               IF     cret_msg != 'Y'
                  AND java_util_file.file_exists (dest_dir || dest_file_name) =
                                                                           'N'
               THEN                  /* lets make sure it actually got there*/
               
                  raise_application_error
                     (-20002,
                         'iri_sicd_online.create_order - Error moving photo Seafarer '
                      || TO_CHAR (seafarer.seafarer_id)
                     );
                     
                  ret_msg :=
                        'Processing Seafarer '
                     || TO_CHAR (seafarer.seafarer_id)
                     || ' Error moving photo';
                     
               ELSE
               
                  sicd_img.insert_photo (dest_file_name, FALSE);
                  
               /* if it did then make the attachement */
               END IF;
               
            END IF;
            
         END IF;

         /* process officers licenses */
         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line
               ('******************************************OC**********************'
               );
         END IF;

         FOR oc IN get_oc (seafarer.esi_id)
         LOOP
            ret_msg :=
                  'Processing Seafarer '
               || TO_CHAR (seafarer.seafarer_id)
               || ' Officers Certificates';

            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line ('Counter ' || TO_CHAR (counter));
            END IF;

            IF     oc.inventory_item_id IS NOT NULL
               AND oc.grading_status = 'Approved'
            THEN
               --dbms_output.put_line('OC.Inventory_item_id '||to_char(oc.inventory_item_id));
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line (   'OC.Inventory_item_id '
                                        || TO_CHAR (oc.inventory_item_id)
                                       );
               END IF;

               p_line_tbl (counter) := oe_order_pub.g_miss_line_rec;
               p_line_tbl (counter).inventory_item_id := oc.inventory_item_id;
/* populate order line additonal infomation */

               --P_line_tbl(counter) := OE_ORDER_PUB.G_MISS_LINE_REC;
               p_line_tbl (counter).CONTEXT := 'OC';
               p_line_tbl (counter).attribute1 :=
                                                TO_CHAR (seafarer.seafarer_id);
               p_line_tbl (counter).attribute10 := TO_CHAR (sirb_number);
               p_line_tbl (counter).attribute12 := TO_CHAR (sirb_number);
               p_line_tbl (counter).attribute13 := is_crimean;

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line (   'Context '
                                        || p_line_tbl (counter).CONTEXT
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute1 '
                                        || p_line_tbl (counter).attribute1
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute10 '
                                        || p_line_tbl (counter).attribute10
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute12 '
                                        || p_line_tbl (counter).attribute12
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute13 '
                                        || p_line_tbl (counter).attribute13
                                       );
               END IF;

               old_oc_document_id := NULL;
               p_expiration_date := NULL;

               OPEN get_previous_cra_id (seafarer.seafarer_id, oc.grade_id);

               FETCH get_previous_cra_id
                INTO old_cra_document_id, cra_expiration_date;

               CLOSE get_previous_cra_id;

               old_oc_document_id := NULL;
               oc_expiration_date := NULL;

               OPEN get_previous_oc_id (oc.previous_document_id);

               FETCH get_previous_oc_id
                INTO old_oc_document_id, oc_expiration_date;

               CLOSE get_previous_oc_id;

               IF old_oc_document_id IS NULL AND oc_expiration_date IS NULL
               THEN
                  oc.issue_type := 'New';
               END IF;

               IF oc.issue_type = 'New'
               THEN
                  p_line_tbl (counter).attribute2 := 'New';

                  IF DEBUG_MODE
                  THEN
                     DBMS_OUTPUT.put_line (   'Attribute2 '
                                           || p_line_tbl (counter).attribute2
                                          );
                  END IF;

                  p_line_tbl (counter).order_quantity_uom := 'NEW';
               ELSIF oc.issue_type = 'Renewal'
               THEN
                  p_line_tbl (counter).attribute6 := old_oc_document_id;

                  IF DEBUG_MODE
                  THEN
                     DBMS_OUTPUT.put_line (   'Attribute6 '
                                           || p_line_tbl (counter).attribute6
                                          );
                  END IF;

                  IF DEBUG_MODE
                  THEN
                     DBMS_OUTPUT.put_line (   'oc_expiration_date '
                                           || TO_CHAR (oc_expiration_date)
                                          );
                  END IF;

                  IF (SYSDATE - oc_expiration_date) < 1
                  THEN                     /* has the licenese expired  - no*/
                     p_line_tbl (counter).attribute2 := 'Renewal';

                     IF DEBUG_MODE
                     THEN
                        DBMS_OUTPUT.put_line (   'Attribute2 '
                                              || p_line_tbl (counter).attribute2
                                             );
                     END IF;

                     p_line_tbl (counter).order_quantity_uom := 'RN';
                  ELSIF (SYSDATE - oc_expiration_date) BETWEEN 1 AND 366
                  THEN
                     /* has the licenese expired  - yes but less than 1 year ago*/
                     IF DEBUG_MODE
                     THEN
                        DBMS_OUTPUT.put_line (   'Attribute2 '
                                              || p_line_tbl (counter).attribute2
                                             );
                     END IF;

                     p_line_tbl (counter).attribute2 := 'Renewal';
                     p_line_tbl (counter).order_quantity_uom := 'RN1';
                  ELSE
                     /* has the licenese expired  - yes but more than 1 year ago*/
                     p_line_tbl (counter).attribute2 := 'New';

                     IF DEBUG_MODE
                     THEN
                        DBMS_OUTPUT.put_line (   'Attribute2 '
                                              || p_line_tbl (counter).attribute2
                                             );
                     END IF;

                     p_line_tbl (counter).order_quantity_uom := 'NEW';
                  END IF;
               ELSIF oc.issue_type = 'Replacement'
               THEN
                  p_line_tbl (counter).attribute2 := 'Replacement';

                  IF DEBUG_MODE
                  THEN
                     DBMS_OUTPUT.put_line (   'Attribute2 '
                                           || p_line_tbl (counter).attribute2
                                          );
                  END IF;

                  p_line_tbl (counter).order_quantity_uom := 'RP';
               END IF;

               IF oc.limitation IS NULL
               THEN
                  p_line_tbl (counter).attribute3 := 'Unlimited';
               ELSE
                  p_line_tbl (counter).attribute3 := 'Limited';
               END IF;

               p_line_tbl (counter).attribute4 := TO_CHAR (oc.limitation);
               p_line_tbl (counter).attribute5 := TO_CHAR (oc.restriction);
               p_line_tbl (counter).attribute12 := TO_CHAR (oc.esdi_id);
               p_line_tbl (counter).attribute13 := is_crimean;

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line (   'Attribute3 '
                                        || p_line_tbl (counter).attribute3
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute4 '
                                        || p_line_tbl (counter).attribute4
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute5 '
                                        || p_line_tbl (counter).attribute5
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute12 '
                                        || p_line_tbl (counter).attribute12
                                       );
               END IF;

               iri_qp.get_price (oc.inventory_item_id,
                                 price_list_id,
                                 1,
                                 std_price,
                                 error_num,
                                 error_msg
                                );

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Error_msg ' || error_msg);
                  DBMS_OUTPUT.put_line ('Price: ' || TO_CHAR (std_price));
               END IF;

               p_line_tbl (counter).ordered_quantity := 1;
               p_line_tbl (counter).unit_list_price := std_price / quantity;
               p_line_tbl (counter).unit_selling_price := std_price / quantity;
               p_line_tbl (counter).calculate_price_flag := 'Y';
               p_line_tbl (counter).operation := oe_globals.g_opr_create;
               counter := counter + 1;
            END IF;
         END LOOP;                                         -- for oc in get_oc

/* book processing */
         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line
               ('******************************************BOOK**********************'
               );
         END IF;

         IF     seafarer.issue_type != 'Current'
            AND seafarer.book_grd_status = 'Approved'
         THEN                    /* if they are not asking for and sqc only */
            ret_msg :=
                  'Processing Seafarer '
               || TO_CHAR (seafarer.seafarer_id)
               || ' SIRB';

            IF seafarer.issue_type IN ('New')
            THEN
/* if its a new book then get a new number */
               SELECT sicd_book_id_seq.NEXTVAL
                 INTO sirb_number
                 FROM DUAL;
            ELSIF seafarer.issue_type IN ('Renewal', 'Replacement')
            THEN
/* if its a renewal or replacement assign new book number and get old book number */
               OPEN get_latest_book_number
                                          (seafarer.previous_book_document_id);

               FETCH get_latest_book_number
                INTO last_sirb_id, sirb_expiration_date, sirb_number;

               CLOSE get_latest_book_number;

               SELECT sicd_book_id_seq.NEXTVAL
                 INTO sirb_number
                 FROM DUAL;
            ELSE
/*otherwise get his current book number */
               OPEN get_seafarers_latest_book (seafarer.seafarer_id);

               FETCH get_seafarers_latest_book
                INTO last_sirb_id, sirb_expiration_date, sirb_number;

               CLOSE get_seafarers_latest_book;
            END IF;

            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line ('last_sirb_id ' || TO_CHAR (last_sirb_id)
                                    );
               DBMS_OUTPUT.put_line (   'sirb_expiration_date '
                                     || TO_CHAR (sirb_expiration_date,
                                                 'dd-Mon-RR'
                                                )
                                    );
               DBMS_OUTPUT.put_line ('sirb_number ' || TO_CHAR (sirb_number));
            END IF;

            p_line_tbl (counter) := oe_order_pub.g_miss_line_rec;
            p_line_tbl (counter).inventory_item_id := 2;
            iri_qp.get_price (2,
                              price_list_id,
                              1,
                              std_price,
                              error_num,
                              error_msg
                             );

            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line ('Error_msg ' || error_msg);
               DBMS_OUTPUT.put_line ('Price: ' || TO_CHAR (std_price));
            END IF;

            p_line_tbl (counter).ordered_quantity := 1;
            p_line_tbl (counter).unit_list_price := std_price / quantity;
            p_line_tbl (counter).unit_selling_price := std_price / quantity;
            p_line_tbl (counter).calculate_price_flag := 'Y';

            IF seafarer.issue_type = 'New'
            THEN
               p_line_tbl (counter).attribute2 := 'New';

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line (   'Attribute2 '
                                        || p_line_tbl (counter).attribute2
                                       );
               END IF;

               p_line_tbl (counter).order_quantity_uom := 'NEW';
            ELSIF seafarer.issue_type = 'Renewal'
            THEN                                                     /* Yes */
               p_line_tbl (counter).attribute6 := TO_CHAR (last_sirb_id);

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line (   'Attribute6 '
                                        || p_line_tbl (counter).attribute6
                                       );
               END IF;

               IF (SYSDATE - sirb_expiration_date) < 1
               THEN                        /* has the licenese expired  - no*/
                  p_line_tbl (counter).attribute2 := 'Renewal';

                  IF DEBUG_MODE
                  THEN
                     DBMS_OUTPUT.put_line (   'Attribute2 '
                                           || p_line_tbl (counter).attribute2
                                          );
                  END IF;

                  p_line_tbl (counter).order_quantity_uom := 'RN';
               ELSIF (SYSDATE - sirb_expiration_date) BETWEEN 1 AND 366
               THEN
                  /* has the book expired  - yes but less than 1 year ago*/
                  IF DEBUG_MODE
                  THEN
                     DBMS_OUTPUT.put_line (   'Attribute2 '
                                           || p_line_tbl (counter).attribute2
                                          );
                  END IF;

                  p_line_tbl (counter).attribute2 := 'Renewal';
                  p_line_tbl (counter).order_quantity_uom := 'RN1';
               ELSE
                  /* has the book expired  - yes but more than 1 year ago*/
                  p_line_tbl (counter).attribute2 := 'New';

                  IF DEBUG_MODE
                  THEN
                     DBMS_OUTPUT.put_line (   'Attribute2 '
                                           || p_line_tbl (counter).attribute2
                                          );
                  END IF;

                  p_line_tbl (counter).order_quantity_uom := 'NEW';
               END IF;
            ELSIF seafarer.issue_type = 'Replacement'
            THEN
               p_line_tbl (counter).attribute2 := 'Replacement';
               p_line_tbl (counter).attribute6 := TO_CHAR (last_sirb_id);

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line (   'Attribute2 '
                                        || p_line_tbl (counter).attribute2
                                       );
               END IF;

               p_line_tbl (counter).order_quantity_uom := 'RP';
            END IF;

/* populate order line additonal infomation */

            --P_line_tbl(counter) := OE_ORDER_PUB.G_MISS_LINE_REC;
            p_line_tbl (counter).CONTEXT := 'BOOK';

            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line ('Context '
                                     || p_line_tbl (counter).CONTEXT
                                    );
            END IF;

            p_line_tbl (counter).attribute1 := TO_CHAR (seafarer.seafarer_id);
            p_line_tbl (counter).attribute10 := TO_CHAR (sirb_number);
            p_line_tbl (counter).attribute13 := is_crimean;

            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line (   'Attribute1 '
                                     || p_line_tbl (counter).attribute1
                                    );
               DBMS_OUTPUT.put_line (   'Attribute10 '
                                     || p_line_tbl (counter).attribute1
                                    );
            END IF;

            p_line_tbl (counter).operation := oe_globals.g_opr_create;
            counter := counter + 1;
         ELSE                                             /* sqc only order */
            OPEN get_seafarers_latest_book (seafarer.seafarer_id);

-- Replaced get_latest_book_number call with get_seafarers_latest_book Tciket T20170406.0006 ZK 04262017
            FETCH get_seafarers_latest_book                    -- ZK 04262017
             INTO last_sirb_id, sirb_expiration_date, sirb_number;

            CLOSE get_seafarers_latest_book;                   -- ZK 04262017

            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line ('last_sirb_id ' || TO_CHAR (last_sirb_id)
                                    );
               DBMS_OUTPUT.put_line (   'sirb_expiration_date '
                                     || TO_CHAR (sirb_expiration_date,
                                                 'dd-Mon-RR'
                                                )
                                    );
               DBMS_OUTPUT.put_line ('sirb_number ' || TO_CHAR (sirb_number));
            END IF;
         END IF;

/* process sqc's */
         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line
               ('******************************************SQC**********************'
               );
         END IF;

         FOR sqc IN get_sqc (seafarer.esi_id)
         LOOP
            ret_msg :=
                  'Processing Seafarer '
               || TO_CHAR (seafarer.seafarer_id)
               || ' SQC';

            IF     sqc.inventory_item_id IS NOT NULL
               AND sqc.grading_status = 'Approved'
            THEN
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line (   'Processing Seafarer '
                                        || TO_CHAR (seafarer.seafarer_id)
                                        || ' SQC'
                                       );
                  DBMS_OUTPUT.put_line ('Counter ' || TO_CHAR (counter));
                  DBMS_OUTPUT.put_line (   'last_sirb_id '
                                        || TO_CHAR (last_sirb_id)
                                       );
                  DBMS_OUTPUT.put_line (   'sirb_expiration_date '
                                        || TO_CHAR (sirb_expiration_date,
                                                    'dd-Mon-RR'
                                                   )
                                       );
                  DBMS_OUTPUT.put_line ('sirb_number '
                                        || TO_CHAR (sirb_number)
                                       );
                  DBMS_OUTPUT.put_line (   'sqc.Inventory_item_id '
                                        || TO_CHAR (sqc.inventory_item_id)
                                       );
               END IF;

               p_line_tbl (counter) := oe_order_pub.g_miss_line_rec;
               p_line_tbl (counter).inventory_item_id := sqc.inventory_item_id;
               iri_qp.get_price (sqc.inventory_item_id,
                                 price_list_id,
                                 1,
                                 std_price,
                                 error_num,
                                 error_msg
                                );

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Error_msg ' || error_msg);
                  DBMS_OUTPUT.put_line ('Price: ' || TO_CHAR (std_price));
               END IF;

               p_line_tbl (counter).ordered_quantity := 1;
               p_line_tbl (counter).unit_list_price := std_price / quantity;
               p_line_tbl (counter).unit_selling_price := std_price / quantity;
               p_line_tbl (counter).calculate_price_flag := 'Y';
               uom_code := NULL;

               OPEN get_uom (sqc.inventory_item_id, price_list_id);

               FETCH get_uom
                INTO uom_code;

               CLOSE get_uom;

               IF uom_code IS NULL
               THEN
                  p_line_tbl (counter).order_quantity_uom := 'NEW';
               ELSE
                  p_line_tbl (counter).order_quantity_uom := uom_code;
               END IF;

/* populate order line additonal infomation */
               p_line_tbl (counter).CONTEXT := 'SQC';
               p_line_tbl (counter).attribute1 :=
                                                TO_CHAR (seafarer.seafarer_id);
               p_line_tbl (counter).attribute10 := TO_CHAR (sirb_number);
               p_line_tbl (counter).attribute2 := seafarer.issue_type;

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line (   'Context '
                                        || p_line_tbl (counter).CONTEXT
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute1 '
                                        || p_line_tbl (counter).attribute1
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute10 '
                                        || p_line_tbl (counter).attribute10
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute2 '
                                        || p_line_tbl (counter).attribute2
                                       );
               END IF;

               old_sqc_document_id := NULL;
               p_expiration_date := NULL;

               /* does the person have an existing sqc*/
               OPEN get_previous_sqc_id (sqc.document_id);

               FETCH get_previous_sqc_id
                INTO old_sqc_document_id, sqc_expiration_date;

               -- ZK 03132014 replaced p_expiration_date with SQC_expiration_date
               CLOSE get_previous_sqc_id;

               /* does the person have an existing SQC*/
               IF sqc.issue_type = 'New'
               THEN
                  p_line_tbl (counter).attribute2 := 'New';

                  IF DEBUG_MODE
                  THEN
                     DBMS_OUTPUT.put_line (   'Attribute2 '
                                           || p_line_tbl (counter).attribute2
                                          );
                  END IF;

                  p_line_tbl (counter).order_quantity_uom := 'NEW';
               ELSIF sqc.issue_type = 'Renewal'
               THEN                                                  /* Yes */
                  p_line_tbl (counter).attribute2 := 'Renewal';
                  p_line_tbl (counter).attribute6 := old_sqc_document_id;

                  -- ZK 03132014 replaced old_oc_document_id with old_sqc_document_id
                  IF DEBUG_MODE
                  THEN
                     DBMS_OUTPUT.put_line (   'Attribute6 '
                                           || p_line_tbl (counter).attribute6
                                          );
                  END IF;

                  IF (SYSDATE - NVL (sqc_expiration_date, SYSDATE)) < 1
                  THEN                     /* has the licenese expired  - no*/
                     p_line_tbl (counter).attribute2 := 'Renewal';

                     IF DEBUG_MODE
                     THEN
                        DBMS_OUTPUT.put_line (   'Attribute2 '
                                              || p_line_tbl (counter).attribute2
                                             );
                     END IF;

                     p_line_tbl (counter).order_quantity_uom := 'RN';
                  ELSIF (SYSDATE - NVL (sqc_expiration_date, SYSDATE)) BETWEEN 1
                                                                           AND 366
                  THEN
                     /* has the licenese expired  - yes but less than 1 year ago*/
                     IF DEBUG_MODE
                     THEN
                        DBMS_OUTPUT.put_line (   'Attribute2 '
                                              || p_line_tbl (counter).attribute2
                                             );
                     END IF;

                     p_line_tbl (counter).attribute2 := 'Renewal';
                     p_line_tbl (counter).order_quantity_uom := 'RN1';
                  ELSE
                     /* has the licenese expired  - yes but more than 1 year ago*/
                     p_line_tbl (counter).attribute2 := 'New';

                     IF DEBUG_MODE
                     THEN
                        DBMS_OUTPUT.put_line (   'Attribute2 '
                                              || p_line_tbl (counter).attribute2
                                             );
                     END IF;

                     p_line_tbl (counter).order_quantity_uom := 'NEW';
                  END IF;
               ELSIF sqc.issue_type = 'Replacement'
               THEN
                  p_line_tbl (counter).attribute2 := 'Replacement';
                  p_line_tbl (counter).attribute6 := old_sqc_document_id;

                  -- ZK Added 03142014
                  IF DEBUG_MODE
                  THEN
                     DBMS_OUTPUT.put_line (   'Attribute2 '
                                           || p_line_tbl (counter).attribute2
                                          );
                  END IF;

                  p_line_tbl (counter).order_quantity_uom := 'RP';
               END IF;

               IF sqc.limitation IS NULL
               THEN
                  p_line_tbl (counter).attribute3 := 'Unlimited';
               ELSE
                  p_line_tbl (counter).attribute3 := 'Limited';
               END IF;

               p_line_tbl (counter).attribute4 := TO_CHAR (sqc.limitation);
               p_line_tbl (counter).attribute5 := TO_CHAR (sqc.restriction);
               p_line_tbl (counter).attribute12 := TO_CHAR (sqc.esdi_id);
               p_line_tbl (counter).attribute13 := is_crimean;

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line (   'Attribute3 '
                                        || p_line_tbl (counter).attribute3
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute4 '
                                        || p_line_tbl (counter).attribute4
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute5 '
                                        || p_line_tbl (counter).attribute5
                                       );
                  DBMS_OUTPUT.put_line (   'Attribute12 '
                                        || p_line_tbl (counter).attribute12
                                       );
               END IF;

               p_line_tbl (counter).operation := oe_globals.g_opr_create;
               counter := counter + 1;
            END IF;
         END LOOP;                                       -- for sqc in get_sqc
      END LOOP;                            --for seafarer in get_seafarer_info

      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line ('Process Courier Fee');
      END IF;

      IF counter = 1
      THEN                   /* if there are no lines on the order the exit */
         order_header_id := NULL;
         return_code := 2;
         ret_msg := 'There are no documents to be ordered.';
         RETURN;
      END IF;

      IF is_courier_fee_required (batch_rec.created_by, p_esi_batch_id) =
                                                                         'Yes'
      THEN
         ret_msg := 'Processing: Adding Courier Fee';

--
--S.CV.SHIP.COUR = 81
         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line ('courier.Inventory_item_id ' || TO_CHAR (81)
                                 );
            DBMS_OUTPUT.put_line ('counter ' || TO_CHAR (counter));
         END IF;

         p_line_tbl (counter) := oe_order_pub.g_miss_line_rec;
         p_line_tbl (counter).inventory_item_id := 81;
         iri_qp.get_price (p_line_tbl (counter).inventory_item_id,
                           price_list_id,
                           nof_seafarers,
                           std_price,
                           error_num,
                           error_msg
                          );
         p_line_tbl (counter).ordered_quantity := nof_seafarers;
         p_line_tbl (counter).unit_list_price := std_price / nof_seafarers;
         p_line_tbl (counter).unit_selling_price := std_price / nof_seafarers;

         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line ('Error_msg ' || error_msg);
            DBMS_OUTPUT.put_line ('Price: ' || TO_CHAR (std_price));
            DBMS_OUTPUT.put_line ('nof_seafarers: ' || TO_CHAR (nof_seafarers)
                                 );
            DBMS_OUTPUT.put_line
                                (   'ordered_quantity: '
                                 || TO_CHAR
                                         (p_line_tbl (counter).ordered_quantity
                                         )
                                );
            DBMS_OUTPUT.put_line (   'p_line_tbl (counter).unit_list_price: '
                                  || TO_CHAR
                                          (p_line_tbl (counter).unit_list_price
                                          )
                                 );
            DBMS_OUTPUT.put_line
                              (   'p_line_tbl (counter).unit_selling_price: '
                               || TO_CHAR
                                       (p_line_tbl (counter).unit_selling_price
                                       )
                              );
         END IF;

         p_line_tbl (counter).calculate_price_flag := 'Y';
         uom_code := NULL;

         OPEN get_uom (p_line_tbl (counter).inventory_item_id, price_list_id);

         FETCH get_uom
          INTO uom_code;

         CLOSE get_uom;

         IF uom_code IS NULL
         THEN
            p_line_tbl (counter).order_quantity_uom := 'NEW';
         ELSE
            p_line_tbl (counter).order_quantity_uom := uom_code;
         END IF;

/* populate order line additonal infomation */
         p_line_tbl (counter).CONTEXT := 'SHIP';
         p_line_tbl (counter).attribute13 := 'N';
         p_line_tbl (counter).operation := oe_globals.g_opr_create;
         counter := counter + 1;
      END IF;

      IF NVL (batch_rec.expedited_processing, 'N') = 'Y'
      THEN
         ret_msg := 'Processing: Adding Expedited Processing Fee';

--
--S.CV.SHIP.SPEC_SVC = 7156
         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line (   'courier.Inventory_item_id '
                                  || TO_CHAR (7156)
                                 );
            DBMS_OUTPUT.put_line ('counter ' || TO_CHAR (counter));
         END IF;

         p_line_tbl (counter) := oe_order_pub.g_miss_line_rec;
         p_line_tbl (counter).inventory_item_id := 7156;
         iri_qp.get_price (p_line_tbl (counter).inventory_item_id,
                           price_list_id,
                           nof_seafarers,
                           std_price,
                           error_num,
                           error_msg
                          );
         p_line_tbl (counter).ordered_quantity := nof_seafarers;
         p_line_tbl (counter).unit_list_price := std_price / nof_seafarers;
         p_line_tbl (counter).unit_selling_price := std_price / nof_seafarers;

         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line ('Error_msg ' || error_msg);
            DBMS_OUTPUT.put_line ('Price: ' || TO_CHAR (std_price));
            DBMS_OUTPUT.put_line ('nof_seafarers: ' || TO_CHAR (nof_seafarers)
                                 );
            DBMS_OUTPUT.put_line
                                (   'ordered_quantity: '
                                 || TO_CHAR
                                         (p_line_tbl (counter).ordered_quantity
                                         )
                                );
            DBMS_OUTPUT.put_line (   'p_line_tbl (counter).unit_list_price: '
                                  || TO_CHAR
                                          (p_line_tbl (counter).unit_list_price
                                          )
                                 );
            DBMS_OUTPUT.put_line
                              (   'p_line_tbl (counter).unit_selling_price: '
                               || TO_CHAR
                                       (p_line_tbl (counter).unit_selling_price
                                       )
                              );
         END IF;

         p_line_tbl (counter).calculate_price_flag := 'Y';
         uom_code := NULL;

         OPEN get_uom (p_line_tbl (counter).inventory_item_id, price_list_id);

         FETCH get_uom
          INTO uom_code;

         CLOSE get_uom;

         IF uom_code IS NULL
         THEN
            p_line_tbl (counter).order_quantity_uom := 'NEW';
         ELSE
            p_line_tbl (counter).order_quantity_uom := uom_code;
         END IF;

/* populate order line additonal infomation */
         p_line_tbl (counter).CONTEXT := 'SHIP';
         p_line_tbl (counter).attribute13 := is_crimean;
         p_line_tbl (counter).operation := oe_globals.g_opr_create;
         counter := counter + 1;
      END IF;

      DBMS_OUTPUT.put_line ('CALL TO PROCESS ORDER');
      -- CALL TO PROCESS ORDER
      ret_msg := 'Processing: OE_Order_PUB.Process_Order';
      oe_order_pub.process_order (apps.iri_oe_interface.c_organization_id,
                                  apps.iri_oe_interface.c_operating_unit,
                                  p_api_version_number,
                                  fnd_api.g_true,
                                  p_return_values,
                                  p_action_commit,
                                  x_return_status,
                                  x_msg_count,
                                  x_msg_data,
                                  p_header_rec,
                                  p_old_header_rec,
                                  p_header_val_rec,
                                  p_old_header_val_rec,
                                  p_header_adj_tbl,
                                  p_old_header_adj_tbl,
                                  p_header_adj_val_tbl,
                                  p_old_header_adj_val_tbl,
                                  p_header_price_att_tbl,
                                  p_old_header_price_att_tbl,
                                  p_header_adj_att_tbl,
                                  p_old_header_adj_att_tbl,
                                  p_header_adj_assoc_tbl,
                                  p_old_header_adj_assoc_tbl,
                                  p_header_scredit_tbl,
                                  p_old_header_scredit_tbl,
                                  p_header_scredit_val_tbl,
                                  p_old_header_scredit_val_tbl,
                                  p_line_tbl,
                                  p_old_line_tbl,
                                  p_line_val_tbl,
                                  p_old_line_val_tbl,
                                  p_line_adj_tbl,
                                  p_old_line_adj_tbl,
                                  p_line_adj_val_tbl,
                                  p_old_line_adj_val_tbl,
                                  p_line_price_att_tbl,
                                  p_old_line_price_att_tbl,
                                  p_line_adj_att_tbl,
                                  p_old_line_adj_att_tbl,
                                  p_line_adj_assoc_tbl,
                                  p_old_line_adj_assoc_tbl,
                                  p_line_scredit_tbl,
                                  p_old_line_scredit_tbl,
                                  p_line_scredit_val_tbl,
                                  p_old_line_scredit_val_tbl,
                                  p_lot_serial_tbl,
                                  p_old_lot_serial_tbl,
                                  p_lot_serial_val_tbl,
                                  p_old_lot_serial_val_tbl,
                                  p_action_request_tbl,
                                  x_header_rec,
                                  x_header_val_rec,
                                  x_header_adj_tbl,
                                  x_header_adj_val_tbl,
                                  x_header_price_att_tbl,
                                  x_header_adj_att_tbl,
                                  x_header_adj_assoc_tbl,
                                  x_header_scredit_tbl,
                                  x_header_scredit_val_tbl,
                                  x_line_tbl,
                                  x_line_val_tbl,
                                  x_line_adj_tbl,
                                  x_line_adj_val_tbl,
                                  x_line_price_att_tbl,
                                  x_line_adj_att_tbl,
                                  x_line_adj_assoc_tbl,
                                  x_line_scredit_tbl,
                                  x_line_scredit_val_tbl,
                                  x_lot_serial_tbl,
                                  x_lot_serial_val_tbl,
                                  x_action_request_tbl
                                 );
      COMMIT;

      IF x_return_status = fnd_api.g_ret_sts_success
      THEN
         --success
         success_counter := success_counter + 1;

         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line ('SUCCESS');
         END IF;

         IF x_msg_count > 0
         THEN
            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line ('Warning Messages **********');
            END IF;

            FOR l_index IN 1 .. x_msg_count
            LOOP
               l_message :=
                    oe_msg_pub.get (p_msg_index      => l_index,
                                    p_encoded        => 'F');

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line (l_message);
               END IF;
            END LOOP;

            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line ('End Warning Messages **********');
            END IF;
         END IF;

         l_order_id_n := x_header_rec.header_id;
         DBMS_LOCK.sleep (3);       /* give everything a second to catch up */
                /* if it worked then write it to the output log */

         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line ('get_order');
         END IF;

         ret_msg := 'Processing: OE_Order_PUB.Get_Order';
         oe_order_pub.get_order
                   (p_api_version_number          => 1.0,
                    p_init_msg_list               => fnd_api.g_false,
                    p_return_values               => fnd_api.g_false,
                    x_return_status               => l_status_c,
                    x_msg_count                   => l_msg_count_n,
                    x_msg_data                    => l_message_s,
                    p_header_id                   => l_order_id_n,
                    p_header                      => fnd_api.g_miss_char,
                    x_header_rec                  => l_orig_header_rec,
                    x_header_val_rec              => l_orig_header_val_rec,
                    x_header_adj_tbl              => l_orig_header_adj_tbl,
                    x_header_adj_val_tbl          => l_orig_header_adj_val_tbl,
                    x_header_price_att_tbl        => l_orig_header_price_att_tbl,
                    x_header_adj_att_tbl          => l_orig_header_adj_att_tbl,
                    x_header_adj_assoc_tbl        => l_orig_header_adj_assoc_tbl,
                    x_header_scredit_tbl          => l_orig_header_scredit_tbl,
                    x_header_scredit_val_tbl      => l_orig_header_scredit_val_tbl,
                    x_line_tbl                    => l_orig_line_tbl,
                    x_line_val_tbl                => l_orig_line_val_tbl,
                    x_line_adj_tbl                => l_orig_line_adj_tbl,
                    x_line_adj_val_tbl            => l_orig_line_adj_val_tbl,
                    x_line_price_att_tbl          => l_orig_line_price_att_tbl,
                    x_line_adj_att_tbl            => l_orig_line_adj_att_tbl,
                    x_line_adj_assoc_tbl          => l_orig_line_adj_assoc_tbl,
                    x_line_scredit_tbl            => l_orig_line_scredit_tbl,
                    x_line_scredit_val_tbl        => l_orig_line_scredit_val_tbl,
                    x_lot_serial_tbl              => l_orig_lot_serial_tbl,
                    x_lot_serial_val_tbl          => l_orig_lot_serial_val_tbl
                   );

         IF x_return_status != fnd_api.g_ret_sts_success
         THEN
            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line
                             ('Order Created but did not return order number');
            END IF;

            order_header_id := NULL;
            return_code := 2;
            ret_msg :=
                    'Order Created but did not return order number, call I.T.';
         ELSE
            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line (   ' Order Number:'
                                     || x_header_rec.order_number
                                     || ' order header_id ='
                                     || TO_CHAR (l_orig_header_rec.header_id)
                                    );
            END IF;

            order_header_id := l_orig_header_rec.header_id;
            xyz := 1;

--while xyz < counter loop
--dbms_output.put_line('Line: '||to_char(xyz)||' '||get_item_code(x_line_tbl (xyz).inventory_item_id));
---xyz:=xyz+1;
--end loop;
            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line (   'l_orig_line_tbl(1).attribute1'
                                     || l_orig_line_tbl (1).attribute1
                                    );
               DBMS_OUTPUT.put_line (   'l_orig_line_tbl(1).global_attribute1'
                                     || l_orig_line_tbl (1).global_attribute1
                                    );
               DBMS_OUTPUT.put_line
                                (   'l_orig_line_tbl(1).industry_attribute1  '
                                 || l_orig_line_tbl (1).industry_attribute1
                                );
               DBMS_OUTPUT.put_line (   'l_orig_line_tbl(1).TP_ATTRIBUTE1'
                                     || l_orig_line_tbl (1).tp_attribute1
                                    );
               DBMS_OUTPUT.put_line
                                   (   'l_orig_line_tbl(1).pricing_attribute1'
                                    || l_orig_line_tbl (1).pricing_attribute1
                                   );
               DBMS_OUTPUT.put_line (   'l_orig_line_tbl(1).return_attribute1'
                                     || l_orig_line_tbl (1).return_attribute1
                                    );
               /* processing documents in seafarers system to synchronize everything */
               DBMS_OUTPUT.put_line ('Call sicd_utl.process_order');
            END IF;

            sicd_utl.process_order (order_header_id, NULL);
            ua_cra_process (order_header_id);

                                              /* add CRA's and UA's to order */
            /* update status to progress order to next processing station */
            OPEN get_verify_docs (order_header_id);

            FETCH get_verify_docs
             INTO nof_docs_to_grade;

            CLOSE get_verify_docs;

            IF NVL (nof_docs_to_grade, 0) > 0
            THEN
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Pending C.O.C. Verification');
               END IF;

               UPDATE oe_order_headers_all
                  SET attribute9 = 'Pending C.O.C. Verification'
                WHERE header_id = order_header_id;
            ELSE
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Pending Data Verification');
               END IF;

               UPDATE oe_order_headers_all
                  SET attribute9 = 'Pending Data Verification'
                WHERE header_id = order_header_id;
            END IF;

            COMMIT;
         END IF;
      ELSE
         order_header_id := NULL;
         return_code := 2;
         ret_msg := 'Check Error Log';

         IF x_msg_count > 0
         THEN
            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line ('Error');
               DBMS_OUTPUT.put_line (   'OM Debug file: '
                                     || oe_debug_pub.g_dir
                                     || '/'
                                     || oe_debug_pub.g_file
                                    );
               DBMS_OUTPUT.put_line ('Error Messages **********');
            END IF;

            FOR l_index IN 1 .. x_msg_count
            LOOP
               l_message :=
                  oe_msg_pub.get (p_msg_index      => l_index,
                                  p_encoded        => fnd_api.g_false
                                 );

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line (l_message);
               END IF;

               oe_msg_pub.get (p_msg_index          => l_index,
                               p_encoded            => fnd_api.g_false,
                               p_data               => l_message,
                               p_msg_index_out      => l_msg_index_out
                              );

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('message is: ' || l_message);
                  DBMS_OUTPUT.put_line ('message index is: '
                                        || l_msg_index_out
                                       );
               END IF;
            END LOOP;

            ret_msg := l_message || ' ' || p_header_rec.deliver_to_org_id;

            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line ('End Error Messages **********');
            END IF;
         END IF;
      END IF;

      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line (   'order_header_id '
                               || TO_CHAR (order_header_id, '9999999999999')
                              );
         DBMS_OUTPUT.put_line (   'l_orig_header_rec.header_id '
                               || TO_CHAR (l_orig_header_rec.header_id,
                                           '9999999999'
                                          )
                              );
         DBMS_OUTPUT.put_line (   'x_header_rec.header_id '
                               || TO_CHAR (x_header_rec.header_id, '99999999')
                              );
      END IF;

      /* double check to be sure attribute9 is set */
      IF order_header_id IS NOT NULL
      THEN
         OPEN get_order (x_header_rec.header_id);

         FETCH get_order
          INTO order_rec;

         CLOSE get_order;

         IF order_rec.attribute9 IS NULL
         THEN
            /* update status to progress order to next processing station */
            OPEN get_verify_docs (x_header_rec.header_id);

            FETCH get_verify_docs
             INTO nof_docs_to_grade;

            CLOSE get_verify_docs;

            IF NVL (nof_docs_to_grade, 0) > 0
            THEN
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Pending C.O.C. Verification');
               END IF;

               UPDATE oe_order_headers_all
                  SET attribute9 = 'Pending C.O.C. Verification'
                WHERE header_id = order_header_id;

               UPDATE exsicd_batch_iface
                  SET batch_status = 'Grading Approved',
                      oe_header_id = order_header_id
                WHERE esi_batch_id = p_esi_batch_id;
            ELSE
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Pending Data Verification');
               END IF;

               UPDATE oe_order_headers_all
                  SET attribute9 = 'Pending Data Verification'
                WHERE header_id = order_header_id;

               UPDATE exsicd_batch_iface
                  SET batch_status = 'Grading Approved',
                      oe_header_id = order_header_id
                WHERE esi_batch_id = p_esi_batch_id;
            END IF;

            COMMIT;
         END IF;
      END IF;
   END create_order;

/* this function validates the existence of a seafarer_id in the in the sicd_seafarers table */
   FUNCTION validate_seafarer (p_seafarer_id IN NUMBER)
      RETURN BOOLEAN
   IS
      CURSOR get_seafarer
      IS
         SELECT COUNT (*)
           FROM sicd_seafarers
          WHERE seafarer_id = p_seafarer_id;

      seaf_count   NUMBER := 0;
   BEGIN
      OPEN get_seafarer;

      FETCH get_seafarer
       INTO seaf_count;

      CLOSE get_seafarer;

      IF NVL (seaf_count, 0) = 0
      THEN
         RETURN FALSE;
      ELSE
         RETURN TRUE;
      END IF;

      RETURN FALSE;
   END validate_seafarer;

   FUNCTION get_active_cra (p_seafarer_id IN NUMBER, p_grade_id IN NUMBER)
      RETURN NUMBER
   IS
      p_doc_id   NUMBER := NULL;

      CURSOR get_certificate_information
      IS
         SELECT document_id
           FROM sicd_documents
          WHERE seafarer_id = p_seafarer_id
            AND grade_id = p_grade_id
            AND certificate_type = 'CRA'
            AND status = 'Active';
   BEGIN
      OPEN get_certificate_information;

      FETCH get_certificate_information
       INTO p_doc_id;

      CLOSE get_certificate_information;

      RETURN p_doc_id;
   END;

/*
DECLARE
  P_ESDI_ID NUMBER;
  RETURN_CODE NUMBER;
  RET_MSG VARCHAR2(200);
  P_DOCUMENT_ID NUMBER;

BEGIN
  P_ESDI_ID := 1;
  RETURN_CODE := NULL;
  RET_MSG := NULL;
  P_DOCUMENT_ID := NULL;

  APPS.IRI_SICD_ONLINE.CREATE_CRA ( P_ESDI_ID, RETURN_CODE, RET_MSG, P_DOCUMENT_ID );
  COMMIT;
END;
*/
   PROCEDURE create_cra (
      p_esdi_id       IN       NUMBER,
      return_code     OUT      NUMBER,
      ret_msg         OUT      VARCHAR2,
      p_document_id   OUT      NUMBER
   )
   IS
/*return_code = 0 = success, 1=Warning 2=Error */
      CURSOR get_seafarer_info (p_esi_id IN NUMBER)
      IS
         SELECT *
           FROM exsicd_seafarers_iface
          WHERE esi_id = p_esi_id;

      seafarer            get_seafarer_info%ROWTYPE;

      CURSOR get_doc_info (p_esdi_id IN NUMBER)
      IS
         SELECT *
           FROM exsicd_seafarer_docs_iface
          WHERE esdi_id = p_esdi_id;

      doc_rec             get_doc_info%ROWTYPE;

      CURSOR c_capacities (p_grade_id IN INTEGER)
      IS
         SELECT   p.position_id, l.limitation_name
             FROM sicd_positions p, sicd_capacities c, sicd_limitations l
            WHERE p.capacity_id = c.capacity_id
              AND p.limitation_id = l.limitation_id
              AND p.grade_id = p_grade_id
         ORDER BY c.capacity_sequence;

      CURSOR c_functions (p_grade_id IN INTEGER)
      IS
         SELECT   q.qualification_id, l.limitation_name
             FROM sicd_qualifications q, sicd_functions f, sicd_limitations l
            WHERE q.function_id = f.function_id
              AND q.limitation_id = l.limitation_id
              AND q.grade_id = p_grade_id
         ORDER BY f.function_sequence;

      resp_appl_id        NUMBER;
      responsibility_id   NUMBER;
      user_id             NUMBER;
      login_id            NUMBER;
   BEGIN
      DBMS_OUTPUT.ENABLE (50000);
      return_code := 0;
      ret_msg := NULL;
      resp_appl_id := TO_NUMBER (fnd_profile.VALUE ('RESP_APPL_ID'));
      responsibility_id := TO_NUMBER (fnd_profile.VALUE ('RESP_ID'));
      user_id := fnd_profile.VALUE ('USER_ID');
      login_id := TO_NUMBER (fnd_profile.VALUE ('LOGIN_ID'));

      IF user_id IS NULL
      THEN
         user_id := 2805;
      END IF;

      IF responsibility_id IS NULL
      THEN
         responsibility_id := 50611;
      END IF;

      IF resp_appl_id IS NULL
      THEN
         resp_appl_id := 20029;
      END IF;

      OPEN get_doc_info (p_esdi_id);

      FETCH get_doc_info
       INTO doc_rec;

      CLOSE get_doc_info;

      OPEN get_seafarer_info (doc_rec.esi_id);

      FETCH get_seafarer_info
       INTO seafarer;

      CLOSE get_seafarer_info;

      IF validate_seafarer (seafarer.seafarer_id) = FALSE
      THEN
/* seafarer does not exist, so create the record*/
         DBMS_OUTPUT.put_line (   'Seafarer_id does not exist.  Creating '
                               || TO_CHAR (seafarer.seafarer_id)
                              );

         BEGIN
            INSERT INTO sicd.sicd_seafarers
                        (seafarer_id, last_name,
                         first_name, middle_initial,
                         birth_date, birth_place,
                         nationality, status, gender,
                         distinguishing_marks, notes,
                         created_by, creation_date, last_updated_by,
                         last_update_date, last_update_login
                        )
                 VALUES (seafarer.seafarer_id, seafarer.last_name,
                         seafarer.first_name, seafarer.middle_initial,
                         seafarer.birth_date, seafarer.birth_place,
                         seafarer.nationality, 'Active', seafarer.gender,
                         seafarer.distinguishing_marks, seafarer.notes,
                         user_id, SYSDATE, user_id,
                         SYSDATE, login_id
                        );
         EXCEPTION
            WHEN OTHERS
            THEN
               return_code := 2;
               ret_msg :=
                     'Error Creating: '
                  || seafarer.last_name
                  || ' ,'
                  || seafarer.first_name
                  || ' '
                  || SQLERRM;
               ROLLBACK;
               RETURN;
         END;
      ELSE
/* seafarer exists so update information if applicable*/
         DBMS_OUTPUT.put_line (   'Seafarer_id exists.  Updating '
                               || TO_CHAR (seafarer.seafarer_id)
                              );

         BEGIN
            UPDATE sicd.sicd_seafarers
               SET status = 'Active',
                   distinguishing_marks = seafarer.distinguishing_marks,
                   notes = notes || CHR (10) || seafarer.notes,
                   last_updated_by = user_id,
                   last_update_date = SYSDATE,
                   last_update_login = login_id
             WHERE seafarer_id = seafarer.seafarer_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               return_code := 2;
               ret_msg :=
                     'Error Updating FIN: '
                  || TO_CHAR (seafarer.seafarer_id)
                  || ' '
                  || SQLERRM;
               ROLLBACK;
               RETURN;
         END;
      END IF;

      v_document_id := NULL;
      v_document_id := get_active_cra (seafarer.seafarer_id, doc_rec.grade_id);

      IF v_document_id IS NOT NULL
      THEN
         return_code := 1;
         ret_msg := 'A CRA for this seafarer and grade already exists.';
         p_document_id := v_document_id;
      ELSE
         v_document_id := NULL;
         v_certificate_number := NULL;

         SELECT sicd_ocrt_id_seq.NEXTVAL
           INTO v_certificate_number
           FROM DUAL;

         v_expiration_date :=
            sicd_utl.set_expiration_date (c_cra,
                                          c_new,
                                          SYSDATE,
                                          NULL,
                                          doc_rec.grade_id
                                         );
         v_header_id := NULL;
         v_line_id := NULL;
         v_document_book_id := NULL;
         v_document_previous_id := NULL;
         v_signer_id := 2;
         v_book_type := NULL;
         v_book_number := NULL;

         IF doc_rec.limitation IS NULL
         THEN
            IF doc_rec.restriction = NULL
            THEN
               v_limitation_name := NULL;
            ELSE
               v_limitation_name :=
                  sicd_utl.get_restriction_text (doc_rec.restriction,
                                                 sicd_utl.c_unlimited,
                                                 NULL
                                                );
            END IF;
         ELSE
            IF doc_rec.restriction = NULL
            THEN
               v_limitation_name := NULL;
            ELSE
               v_limitation_name :=
                  sicd_utl.get_restriction_text (doc_rec.restriction,
                                                 sicd_utl.c_limited,
                                                 doc_rec.limitation
                                                );
            END IF;
         END IF;

         BEGIN
            v_sql :=
               'INSERT INTO sicd_documents (document_id,header_id,line_id,document_book_id,document_previous_id,seafarer_id,signature_id,grade_id,document_type,book_type,book_number,issue_type,issue_date,expiration_date,status,endorsement_number,endorsement_country,endorsement_issue_date,endorsement_expiration_date,created_by,creation_date,last_updated_by,last_update_date,certificate_type,certificate_number) VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14,:15,:16,:17,:18,:19,:20,:21,:22,:23,:24,:25) RETURNING document_id INTO :26';

            EXECUTE IMMEDIATE v_sql
                        USING 1,
                              v_header_id,
                              v_line_id,
                              v_document_book_id,
                              v_document_previous_id,
                              seafarer.seafarer_id,
                              v_signer_id,
                              doc_rec.grade_id,
                              c_oc,
                              v_book_type,
                              v_book_number,
                              c_new,
                              SYSDATE,
                              v_expiration_date,
                              c_active,
                              doc_rec.coc_identifier,
                              doc_rec.coc_country,
                              doc_rec.coc_issue_date,
                              doc_rec.coc_expiration_date,
                              doc_rec.created_by,
                              SYSDATE,
                              doc_rec.created_by,
                              SYSDATE,
                              c_cra,
                              v_certificate_number
               RETURNING INTO v_document_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line ('Error inserting OC ' || SQLERRM);
               raise_application_error (-20001, SQLERRM);
         END;

-- Process Capacities --
         FOR c_capacities_rec IN c_capacities (doc_rec.grade_id)
         LOOP
            IF v_limitation_name IS NULL
            THEN
               v_limitation_name := c_capacities_rec.limitation_name;
            END IF;

            v_sql :=
               'INSERT INTO sicd_roles (role_id,limitations,document_id,position_id,created_by,creation_date,last_updated_by,last_update_date) VALUES (:1,:2,:3,:4,:5,:6,:7,:8)';

            EXECUTE IMMEDIATE v_sql
                        USING 1,
                              v_limitation_name,
                              v_document_id,
                              c_capacities_rec.position_id,
                              fnd_global.user_id,
                              SYSDATE,
                              fnd_global.user_id,
                              SYSDATE;
         END LOOP;

-- Process Functions --
         FOR c_functions_rec IN c_functions (doc_rec.grade_id)
         LOOP
            IF v_limitation_name IS NULL
            THEN
               v_limitation_name := c_functions_rec.limitation_name;
            END IF;

            v_sql :=
               'INSERT INTO sicd_responsibilities (responsibility_id,limitations,document_id,qualification_id,created_by,creation_date,last_updated_by,last_update_date) VALUES (:1,:2,:3,:4,:5,:6,:7,:8)';

            EXECUTE IMMEDIATE v_sql
                        USING 1,
                              v_limitation_name,
                              v_document_id,
                              c_functions_rec.qualification_id,
                              fnd_global.user_id,
                              SYSDATE,
                              fnd_global.user_id,
                              SYSDATE;
         END LOOP;

         p_document_id := v_document_id;
         COMMIT;
      END IF;
   END;

   PROCEDURE send_book_cra (
      errbuf           OUT      VARCHAR2,
      retcode          OUT      NUMBER,
      c_esi_batch_id   IN       VARCHAR2
   )
   IS
      return_code                 NUMBER                             := 0;
      ret_msg                     VARCHAR2 (500)                     := NULL;
      p_document_id               NUMBER                             := NULL;
      v_button                    NUMBER;
      no_parameters               EXCEPTION;
      x_res                       BOOLEAN;
      v_request_id                NUMBER;
      v_request_name              VARCHAR2 (100);
      v_document_id               VARCHAR2 (100);
      loop_counter                NUMBER;
      file_name                   VARCHAR2 (255);
      file_type                   VARCHAR2 (30);
      phase_code                  VARCHAR2 (1);
      status_code                 VARCHAR2 (1);
      counter                     NUMBER                             := 0;
      total_count                 NUMBER                             := 0;
      pct_comp                    NUMBER                             := 0;
      x_result                    VARCHAR2 (500);
      return_message              VARCHAR2 (5000);
      p_output_filename           VARCHAR2 (200);
      v_comm_id                   NUMBER;
      v_ie_header_id              NUMBER;
      user_id                     NUMBER;
      sender_email_address        VARCHAR2 (200);
      destination_email_address   VARCHAR2 (200);
      dest_cc                     VARCHAR2 (200)                     := NULL;
      --'mtimmons@register-iri.com';
      email_message               VARCHAR2 (4000);
      email_re                    VARCHAR2 (200);
      letter_template_id          NUMBER                             := NULL;
      letter_id                   NUMBER;
      x_res                       BOOLEAN;
      resp_appl_id                NUMBER;
      responsibility_id           NUMBER;
      attachments                 sendmailjpkg.attachments_list
                                          := sendmailjpkg.attachments_list
                                                                          ();
      dest_file_name              VARCHAR2 (400)                     := NULL;
      doc_list                    pdf_meld_utils_pkg.cc_request_list;
      seafarers_list              VARCHAR2 (4000)                    := NULL;

      CURSOR get_batch_count (x_esi_batch_id IN NUMBER)
      IS
         SELECT SUM (cnt)
           FROM (SELECT COUNT (*) cnt
                   FROM exsicd_batch_iface b,
                        exsicd_seafarers_iface s,
                        exsicd_seafarer_docs_iface doc
                  WHERE b.esi_batch_id = x_esi_batch_id
                    AND s.esi_batch_id = b.esi_batch_id
                    AND doc.esi_id = s.esi_id
                    AND doc.grade_type = 'SQC'
                    -- SAURABH 27-MAY-2019 T20170323.0014
                    AND s.status = 'Acknowledgement Pending'
                 UNION
                 SELECT COUNT (*)
                   FROM exsicd_batch_iface b, exsicd_seafarers_iface s
                  WHERE b.esi_batch_id = x_esi_batch_id
                    AND s.esi_batch_id = b.esi_batch_id
                    AND s.issue_type != 'Current'
                    -- SAURABH 27-MAY-2019 T20170323.0014
                    AND s.status = 'Acknowledgement Pending');

      batch_count                 NUMBER                             := 0;

      CURSOR get_batch (x_esi_batch_id IN NUMBER)
      IS
         SELECT DISTINCT x.*
                    FROM (SELECT b.*
                            FROM exsicd_batch_iface b,
                                 exsicd_seafarers_iface s,
                                 exsicd_seafarer_docs_iface doc
                           WHERE b.esi_batch_id = x_esi_batch_id
                             AND s.esi_batch_id = b.esi_batch_id
                             AND doc.esi_id = s.esi_id
                             AND doc.grade_type = 'SQC'
                             -- SAURABH 27-MAY-2019 T20170323.0014
                             AND s.status = 'Acknowledgement Pending'
                          UNION
                          SELECT b.*
                            FROM exsicd_batch_iface b,
                                 exsicd_seafarers_iface s
                           WHERE b.esi_batch_id = x_esi_batch_id
                             AND s.esi_batch_id = b.esi_batch_id
                             AND s.issue_type != 'Current'
                             -- SAURABH 27-MAY-2019 T20170323.0014
                             AND s.status = 'Acknowledgement Pending') x;

      exsicd_batch                get_batch%ROWTYPE;

      CURSOR get_pending_acknowledgements (p_esi_batch_id IN NUMBER)
      IS
         SELECT *
           FROM exsicd_seafarers_iface
          WHERE esi_batch_id = p_esi_batch_id
            AND status = 'Acknowledgement Pending'
--            AND world_check_iface.get_seafarer_wc_status (seafarer_id) NOT IN
            AND rmi_ows_common_util.get_wc_status ('SICD_SEAFARERS',
                                                   'SEAFARER_ID',
                                                   seafarer_id,
                                                      first_name
                                                   || ' '
                                                   || last_name
                                                  ) NOT IN
                                                  ('Provisional', 'Approved');

      CURSOR get_approved_ack_list (p_esi_batch_id IN NUMBER)
      IS
         SELECT *
           FROM exsicd_seafarers_iface
          WHERE esi_batch_id = p_esi_batch_id
            AND status = 'Acknowledgement Pending'
            --AND world_check_iface.get_seafarer_wc_status (seafarer_id) IN
            AND rmi_ows_common_util.get_wc_status ('SICD_SEAFARERS',
                                                   'SEAFARER_ID',
                                                   seafarer_id,
                                                      first_name
                                                   || ' '
                                                   || last_name
                                                  ) IN
                                                  ('Provisional', 'Approved');

      CURSOR get_approved_acknowledgements (p_esi_batch_id IN NUMBER)
      IS
         SELECT COUNT (*)
           FROM exsicd_seafarers_iface
          WHERE esi_batch_id = p_esi_batch_id
            AND status = 'Acknowledgement Pending'
--            AND world_check_iface.get_seafarer_wc_status (seafarer_id) IN
            AND rmi_ows_common_util.get_wc_status ('SICD_SEAFARERS',
                                                   'SEAFARER_ID',
                                                   seafarer_id,
                                                      first_name
                                                   || ' '
                                                   || last_name
                                                  ) IN
                                                  ('Provisional', 'Approved');

      nof_approved                NUMBER                             := 0;

      CURSOR get_conc_request_info (rqst_id IN NUMBER)
      IS
         SELECT phase_code, status_code, file_name, file_type
           FROM fnd_conc_req_outputs_v
          WHERE request_id = rqst_id;

      CURSOR get_print_style
      IS
         SELECT output_print_style
           FROM fnd_concurrent_programs_vl
          WHERE concurrent_program_name = 'SICD151B_PDF';

      def_print_style             VARCHAR2 (100);
      p_esi_batch_id              NUMBER;
      first_loop                  VARCHAR2 (1)                       := 'Y';

      CURSOR get_seaf_oc_only
      IS
         SELECT     *
               FROM exsicd_seafarers_iface
              WHERE esi_batch_id = c_esi_batch_id
                AND get_seaf_order_type (esi_id) = 'OC'
         FOR UPDATE;
   BEGIN
      p_esi_batch_id := TO_NUMBER (c_esi_batch_id);
      retcode := 0;
      errbuf := 'Everything is OK.';
      resp_appl_id := TO_NUMBER (fnd_profile.VALUE ('RESP_APPL_ID'));
      responsibility_id := TO_NUMBER (fnd_profile.VALUE ('RESP_ID'));
      user_id := fnd_profile.VALUE ('USER_ID');

      IF user_id IS NULL
      THEN
         user_id := 2805;
      END IF;

      IF responsibility_id IS NULL
      THEN
         responsibility_id := 50779;
      END IF;

      IF resp_appl_id IS NULL
      THEN
         resp_appl_id := 20030;
      END IF;

      mo_global.init ('ONT');
      mo_global.set_policy_context ('S', 122);
      fnd_global.apps_initialize (user_id, responsibility_id, resp_appl_id);
      DBMS_APPLICATION_INFO.set_client_info (122);

      /* clear out the OC only seafarers */
      FOR x IN get_seaf_oc_only
      LOOP
         BEGIN
            UPDATE exsicd_seafarers_iface
               SET status = 'OC Only'
             WHERE CURRENT OF get_seaf_oc_only;
         EXCEPTION
            WHEN OTHERS
            THEN
               ROLLBACK;
         END;
      END LOOP COMMIT;

      OPEN get_batch_count (p_esi_batch_id);

      FETCH get_batch_count
       INTO batch_count;

      CLOSE get_batch_count;

      /* find out if they are ordering other documents besides a officers certificate if they are then send acknowledgement otherwise do not*/
      fnd_file.put_line (fnd_file.LOG,
                            'Number of non-OC documents requested '
                         || TO_CHAR (batch_count)
                        );
      fnd_file.put_line (fnd_file.LOG, 'Creating Provisional TC .');
      iri_sicd_online.create_provisional_tc (p_esi_batch_id,
                                             return_code,
                                             ret_msg
                                            );

      IF return_code != 0
      THEN
         fnd_file.put_line (fnd_file.LOG,
                            'Error Creating Provisional TC  ' || ret_msg
                           );
         retcode := 1;
         errbuf := 'Check Error Log';
         RETURN;
      END IF;

      OPEN get_approved_acknowledgements (p_esi_batch_id);

      FETCH get_approved_acknowledgements
       INTO nof_approved;

      CLOSE get_approved_acknowledgements;

      fnd_file.put_line (fnd_file.LOG,
                            'Number of Approved Acknowledgements: '
                         || TO_CHAR (nof_approved)
                        );

      OPEN get_batch (p_esi_batch_id);

      FETCH get_batch
       INTO exsicd_batch;

      CLOSE get_batch;

      fnd_file.put_line (fnd_file.LOG,
                         'Batch Name: ' || exsicd_batch.batch_name
                        );

      IF batch_count > 0 AND nof_approved > 0
      THEN
         OPEN get_print_style;

         FETCH get_print_style
          INTO def_print_style;

         CLOSE get_print_style;

         fnd_file.put_line (fnd_file.LOG, 'Acknowldegements to sent!');
         /*  x_res :=
              fnd_request.set_print_options (fnd_profile.VALUE ('PRINTER'),
                                             def_print_style,
                                             0);*/
         fnd_file.put_line (fnd_file.LOG, 'Submitting MI-273OR Report');
         v_request_id :=
            fnd_request.submit_request
                          ('EXSICD'                           --app short name
                                   ,
                           'EXSICD_BOOK_CRA'              --program short name
                                            ,
                           'MI-273OR Book Application Acknowledgement (PDF)'
                                                                            --description
            ,
                           NULL                                   --start time
                               ,
                           FALSE                                 --sub request
                                ,
                           p_esi_batch_id,
                           'N',          -- SAURABH 11-JUN-2019 T20190710.0040
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           ''
                          );
         COMMIT;
         fnd_file.put_line (fnd_file.LOG,
                            'request_id = ' || TO_CHAR (v_request_id)
                           );

         OPEN get_conc_request_info (v_request_id);

         FETCH get_conc_request_info
          INTO phase_code, status_code, file_name, file_type;

         CLOSE get_conc_request_info;

         WHILE phase_code <> 'C'
         LOOP
            /* loop while the report is running it will time out after 45 seconds */
            OPEN get_conc_request_info (v_request_id);

            FETCH get_conc_request_info
             INTO phase_code, status_code, file_name, file_type;

            CLOSE get_conc_request_info;

            IF loop_counter > 15
            THEN
               retcode := 1;
               errbuf := 'Check Error Log';
               fnd_file.put_line (fnd_file.LOG, 'The request timed out');
               fnd_file.put_line (fnd_file.LOG, 'End of process');
               RETURN;
            END IF;

            DBMS_LOCK.sleep (3);
         END LOOP;

         fnd_file.put_line (fnd_file.LOG,
                               ' phase_code = '
                            || phase_code
                            || ' status_code = '
                            || status_code
                           );

         IF phase_code = 'C' AND status_code = 'C'
         THEN
            /* it ran now lock the pdf and email it. */
            doc_list (1).request_id := v_request_id;
            dest_file_name :=
                        'ACK' || TO_CHAR (SYSDATE, 'RRMMDDhh24miss')
                        || '.pdf';
            fnd_file.put_line (fnd_file.LOG, 'Running PDFMELD');
            pdf_meld_utils_pkg.meld_concurrent_request (doc_list,
                                                        dest_file_name,
                                                        return_code,
                                                        return_message,
                                                        p_output_filename
                                                       );

            IF return_code <> 0
            THEN
               fnd_file.put_line
                             (fnd_file.LOG,
                                 'PDFMELD returned an error.  Return Code = '
                              || TO_CHAR (return_code)
                              || ' '
                              || return_message
                             );
               retcode := 1;
               errbuf := 'Check Error Log';
               fnd_file.put_line (fnd_file.LOG, 'End of process');
               RETURN;
            ELSE
               fnd_file.put_line (fnd_file.LOG, 'PDFMELD ran successfully');
               email_re := 'Acknowledgement of Application';
               email_message :=
                     'Please see attached acknowledgement of application.  Acknowledgement should be kept in the applicant'
                  || CHR (39)
                  || 's possession aboard the'
                  || CHR (10)
                  || 'vessel until full term documents are received.';
               first_loop := 'Y';

               FOR x IN get_approved_ack_list (p_esi_batch_id)
               LOOP
                  IF first_loop = 'Y'
                  THEN
                     email_message :=
                            email_message || CHR (10) || CHR (10)
                            || 'Name(s):';
                     first_loop := 'N';
                  END IF;

                  email_message :=
                        email_message
                     || CHR (10)
                     || x.first_name
                     || ' '
                     || x.last_name;
               END LOOP;

               first_loop := 'Y';

               FOR x IN get_pending_acknowledgements (p_esi_batch_id)
               LOOP
                  IF first_loop = 'Y'
                  THEN
                     email_message :=
                           email_message
                        || CHR (10)
                        || CHR (10)
                        || 'The Republic of the Marshall Islands Maritime Administrator ("Administrator") is unable to acknowledge receipt of application for the following seafarers at this time.  The Administrator will revert directly.';
                     email_message := email_message || 'Name(s):';
                     first_loop := 'N';
                  END IF;

                  email_message :=
                        email_message
                     || CHR (10)
                     || x.first_name
                     || ' '
                     || x.last_name;
               END LOOP;

               email_message :=
                     email_message
                  || CHR (10)
                  || CHR (10)
                  || CHR (10)
                  || CHR (10)
                  || 'Batch Name: '
                  || exsicd_batch.batch_name;
               fnd_file.put_line (fnd_file.LOG,
                                  'Preparing to email document.');
               sender_email_address :=
                  exsicd_profiles_pkg.get_user_profile
                                                   (exsicd_batch.created_by,
                                                    'CRA Sender Email Address'
                                                   );
               destination_email_address :=
                  NVL
                     (exsicd_profiles_pkg.get_user_profile
                                                (exsicd_batch.created_by,
                                                 'CRA Recipient Email Address'
                                                ),
                      'seafarers@register-iri.com'
                     );
               /*     dest_cc := NULL;
                    dest_cc :=
                       EXSICD_PROFILES_PKG.get_user_profile (exsicd_batch.created_by,
                       'CC on Correspondence');*/
               attachments.EXTEND;
               attachments.EXTEND (2);
               fnd_file.put_line (fnd_file.LOG, 'Sending email parameters:');
               fnd_file.put_line (fnd_file.LOG,
                                     'SMTP Mailer '
                                  || iri_html.get_url ('SMTP_MAILER')
                                 );
               fnd_file.put_line (fnd_file.LOG,
                                  'Sender ' || sender_email_address
                                 );
               fnd_file.put_line (fnd_file.LOG,
                                  'Recipient ' || destination_email_address
                                 );
               fnd_file.put_line (fnd_file.LOG, 'Message: ' || email_message);
               x_result :=
                  sendmailjpkg.sendmail
                     (smtpservername      => iri_html.get_url ('SMTP_MAILER'),
                      sender              => sender_email_address,
                      recipient           => destination_email_address,
                      ccrecipient         => dest_cc,
                      subject             => email_re,
                      errormessage        => return_message,
                      BODY                => email_message,
                      attachments         => sendmailjpkg.attachments_list
                                                            (p_output_filename)
                     );
               fnd_file.put_line (fnd_file.LOG,
                                     'Sending Email  Return Code:'
                                  || TO_CHAR (x_result)
                                 );

               IF return_message IS NULL
               THEN
                  return_message := 'None';
               END IF;

               fnd_file.put_line (fnd_file.LOG,
                                  'Error Message ' || return_message
                                 );

               BEGIN
                  UPDATE exsicd_seafarers_iface
                     SET status = 'Acknowledgement Sent'
                   WHERE esi_batch_id = p_esi_batch_id
                     AND status = 'Acknowledgement Pending'
--                     AND world_check_iface.get_seafarer_wc_status (seafarer_id) IN
                     AND rmi_ows_common_util.get_wc_status ('SICD_SEAFARERS',
                                                            'SEAFARER_ID',
                                                            seafarer_id,
                                                               first_name
                                                            || ' '
                                                            || last_name
                                                           ) IN
                                                  ('Approved', 'Provisional');
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     fnd_file.put_line
                        (fnd_file.LOG,
                         'Error Setting status on seafarer for acknowledgement.'
                        );
               END;

               COMMIT;
            END IF;
         ELSIF phase_code = 'C' AND status_code = 'E'
         THEN                         /* it ran but the request errored out */
            retcode := 1;
            errbuf := 'Check Error Log';
            fnd_file.put_line (fnd_file.LOG, 'The request timed out');
            /* do some error logging */
            fnd_file.put_line (fnd_file.LOG, 'End of process');
            RETURN;
         END IF;
      -- SAURABH  T20170825.0016 13-SEP-2018
      -- ELSE
      ELSIF batch_count > 0
      THEN
         -- Cannot send acknowledge receipt of application but a Book or SQC is there
                /* no acknowledgements to send */
         OPEN get_batch (p_esi_batch_id);

         FETCH get_batch
          INTO exsicd_batch;

         CLOSE get_batch;

         fnd_file.put_line (fnd_file.LOG,
                            'No acknowledgments to send for this order.'
                           );
         first_loop := 'Y';
         email_message :=
               email_message
            || CHR (10)
            || CHR (10)
            || 'The Republic of the Marshall Islands Maritime Administrator ("Administrator") is unable to acknowledge receipt of application for the following seafarers at this time.   The Administrator will revert directly.';

         FOR x IN get_pending_acknowledgements (p_esi_batch_id)
         LOOP
            IF first_loop = 'Y'
            THEN
               email_message :=
                            email_message || CHR (10) || CHR (10)
                            || 'Name(s):';
               first_loop := 'N';
            END IF;

            fnd_file.put_line (fnd_file.LOG,
                               'Seafarer: ' || x.first_name || ' '
                               || x.last_name
                              );
            email_message :=
                email_message || CHR (10) || x.first_name || ' '
                || x.last_name;
         END LOOP;

         email_message :=
               email_message
            || CHR (10)
            || CHR (10)
            || CHR (10)
            || CHR (10)
            || 'Batch Name: '
            || exsicd_batch.batch_name;
         fnd_file.put_line (fnd_file.LOG, 'Preparing to email document.');
         fnd_file.put_line (fnd_file.LOG,
                            'Created By ' || TO_CHAR (exsicd_batch.created_by)
                           );
         email_re := 'Acknowledgement of Application';
         sender_email_address :=
            exsicd_profiles_pkg.get_user_profile (exsicd_batch.created_by,
                                                  'CRA Sender Email Address'
                                                 );
         destination_email_address :=
            NVL
               (exsicd_profiles_pkg.get_user_profile
                                                (exsicd_batch.created_by,
                                                 'CRA Recipient Email Address'
                                                ),
                'seafarers@register-iri.com'
               );
         /*     dest_cc := NULL;
              dest_cc :=
                 EXSICD_PROFILES_PKG.get_user_profile (exsicd_batch.created_by,
                 'CC on Correspondence');*/
         attachments.EXTEND;
         attachments.EXTEND (2);
         fnd_file.put_line (fnd_file.LOG, 'Sending email parameters:');
         fnd_file.put_line (fnd_file.LOG,
                            'SMTP Mailer ' || iri_html.get_url ('SMTP_MAILER')
                           );
         fnd_file.put_line (fnd_file.LOG, 'Sender ' || sender_email_address);
         fnd_file.put_line (fnd_file.LOG,
                            'Recipient ' || destination_email_address
                           );
         fnd_file.put_line (fnd_file.LOG, 'Subject: ' || email_re);
         fnd_file.put_line (fnd_file.LOG, 'Message: ' || email_message);

         IF email_message IS NULL
         THEN
            fnd_file.put_line (fnd_file.LOG, 'There is no message to send ');
         ELSE
            x_result :=
               sendmailjpkg.sendmail
                          (smtpservername      => iri_html.get_url
                                                                ('SMTP_MAILER'),
                           sender              => sender_email_address,
                           recipient           => destination_email_address,
                           ccrecipient         => dest_cc,
                           subject             => email_re,
                           errormessage        => return_message,
                           BODY                => email_message
                          );
            fnd_file.put_line (fnd_file.LOG, 'Sending Email');
         END IF;
      END IF;

      fnd_file.put_line (fnd_file.LOG, 'End of process');
   END;

   PROCEDURE send_invoice (
      errbuf         OUT      VARCHAR2,
      retcode        OUT      NUMBER,
      p_trx_number   IN       VARCHAR2
   )
   IS
      return_code                 NUMBER                             := 0;
      ret_msg                     VARCHAR2 (500)                     := NULL;
      p_document_id               NUMBER                             := NULL;
      v_button                    NUMBER;
      no_parameters               EXCEPTION;
      x_res                       BOOLEAN;
      v_request_id                NUMBER;
      v_request_name              VARCHAR2 (100);
      v_document_id               VARCHAR2 (100);
      loop_counter                NUMBER;
      file_name                   VARCHAR2 (255);
      file_type                   VARCHAR2 (30);
      phase_code                  VARCHAR2 (1);
      status_code                 VARCHAR2 (1);
      counter                     NUMBER                             := 0;
      total_count                 NUMBER                             := 0;
      pct_comp                    NUMBER                             := 0;
      x_result                    VARCHAR2 (500);
      return_message              VARCHAR2 (5000);
      p_output_filename           VARCHAR2 (200);
      v_comm_id                   NUMBER;
      v_ie_header_id              NUMBER;
      user_id                     NUMBER;
      sender_email_address        VARCHAR2 (200);
      destination_email_address   VARCHAR2 (200);
      dest_cc                     VARCHAR2 (200);
      email_message               VARCHAR2 (4000);
      email_re                    VARCHAR2 (200);
      letter_template_id          NUMBER                             := NULL;
      letter_id                   NUMBER;
      x_res                       BOOLEAN;
      resp_appl_id                NUMBER;
      responsibility_id           NUMBER;
      attachments                 sendmailjpkg.attachments_list
                                          := sendmailjpkg.attachments_list
                                                                          ();
      dest_file_name              VARCHAR2 (400)                     := NULL;
      doc_list                    pdf_meld_utils_pkg.cc_request_list;
      seafarers_list              VARCHAR2 (4000)                    := NULL;

      CURSOR get_batch (x_esi_batch_id IN NUMBER)
      IS
         SELECT *
           FROM exsicd_batch_iface
          WHERE esi_batch_id = x_esi_batch_id;

      exsicd_batch                get_batch%ROWTYPE;

      CURSOR get_conc_request_info (rqst_id IN NUMBER)
      IS
         SELECT phase_code, status_code, file_name, file_type
           FROM fnd_conc_req_outputs_v
          WHERE request_id = rqst_id;

      CURSOR get_print_style
      IS
         SELECT output_print_style
           FROM fnd_concurrent_programs_vl
          WHERE concurrent_program_name = 'SICD151B_PDF';

      def_print_style             VARCHAR2 (100);
      p_esi_batch_id              NUMBER;
   BEGIN
      retcode := 0;
      errbuf := 'Everything is OK.';
      resp_appl_id := TO_NUMBER (fnd_profile.VALUE ('RESP_APPL_ID'));
      responsibility_id := TO_NUMBER (fnd_profile.VALUE ('RESP_ID'));
      user_id := fnd_profile.VALUE ('USER_ID');

      IF user_id IS NULL
      THEN
         user_id := 2805;
      END IF;

      IF responsibility_id IS NULL
      THEN
         responsibility_id := 50779;
      END IF;

      IF resp_appl_id IS NULL
      THEN
         resp_appl_id := 20030;
      END IF;

      mo_global.init ('ONT');
      mo_global.set_policy_context ('S', 122);
      fnd_global.apps_initialize (user_id, responsibility_id, resp_appl_id);
      DBMS_APPLICATION_INFO.set_client_info (122);

      OPEN get_batch (p_esi_batch_id);

      FETCH get_batch
       INTO exsicd_batch;

      CLOSE get_batch;

      OPEN get_print_style;

      FETCH get_print_style
       INTO def_print_style;

      CLOSE get_print_style;

      fnd_file.put_line (fnd_file.LOG, 'Running');
      /*  x_res :=
           fnd_request.set_print_options (fnd_profile.VALUE ('PRINTER'),
                                          def_print_style,
                                          0);*/
      fnd_file.put_line (fnd_file.LOG, 'Submitting IRI_INVOICE Report');
      v_request_id :=
         fnd_request.submit_request ('CUSTOM'                 --app short name
                                             ,
                                     'IRI_INV_PDF'        --program short name
                                                  ,
                                     'IRI Invoice (PDF)'         --description
                                                        ,
                                     NULL                         --start time
                                         ,
                                     FALSE                       --sub request
                                          ,
                                     p_trx_number,
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     '',
                                     ''
                                    );
      COMMIT;
      fnd_file.put_line (fnd_file.LOG,
                         'request_id = ' || TO_CHAR (v_request_id)
                        );

      OPEN get_conc_request_info (v_request_id);

      FETCH get_conc_request_info
       INTO phase_code, status_code, file_name, file_type;

      CLOSE get_conc_request_info;

      WHILE phase_code <> 'C'
      LOOP
         /* loop while the report is running it will time out after 45 seconds */
         OPEN get_conc_request_info (v_request_id);

         FETCH get_conc_request_info
          INTO phase_code, status_code, file_name, file_type;

         CLOSE get_conc_request_info;

         IF loop_counter > 15
         THEN
            retcode := 1;
            errbuf := 'Check Error Log';
            fnd_file.put_line (fnd_file.LOG, 'The request timed out');
            fnd_file.put_line (fnd_file.LOG, 'End of process');
            RETURN;
         END IF;

         DBMS_LOCK.sleep (3);
      END LOOP;

      fnd_file.put_line (fnd_file.LOG,
                            ' phase_code = '
                         || phase_code
                         || ' status_code = '
                         || status_code
                        );

      IF phase_code = 'C' AND status_code = 'C'
      THEN
         /* it ran now lock the pdf and email it. */
         doc_list (1).request_id := v_request_id;
         dest_file_name := 'Invoice_' || p_trx_number || '.pdf';
         fnd_file.put_line (fnd_file.LOG, 'Running PDFMELD');
         pdf_meld_utils_pkg.meld_concurrent_request (doc_list,
                                                     dest_file_name,
                                                     return_code,
                                                     return_message,
                                                     p_output_filename
                                                    );

         IF return_code <> 0
         THEN
            fnd_file.put_line
                             (fnd_file.LOG,
                                 'PDFMELD returned an error.  Return Code = '
                              || TO_CHAR (return_code)
                             );
            retcode := 1;
            errbuf := 'Check Error Log';
            fnd_file.put_line (fnd_file.LOG, 'End of process');
            RETURN;
         ELSE
            fnd_file.put_line (fnd_file.LOG, 'PDFMELD ran successfully');
            email_re := 'Invoice ' || p_trx_number;
            email_message :=
                  'Attached is a copy of Invoice Number: '
               || p_trx_number
               || ' for your use.';
            fnd_file.put_line (fnd_file.LOG, 'Preparing to email document.');
            sender_email_address :=
               exsicd_profiles_pkg.get_user_profile
                                                   (user_id,
                                                    'CRA Sender Email Address'
                                                   );
            destination_email_address :=
               NVL
                  (exsicd_profiles_pkg.get_user_profile
                                                (user_id,
                                                 'CRA Recipient Email Address'
                                                ),
                   'seafarers@register-iri.com'
                  );
            dest_cc := NULL;
            dest_cc :=
               exsicd_profiles_pkg.get_user_profile (user_id,
                                                     'CC on Correspondence'
                                                    );
            attachments.EXTEND;
            attachments.EXTEND (2);
            fnd_file.put_line (fnd_file.LOG, 'Sending email parameters:');
            fnd_file.put_line (fnd_file.LOG,
                                  'SMTP Mailer '
                               || iri_html.get_url ('SMTP_MAILER')
                              );
            fnd_file.put_line (fnd_file.LOG,
                               'Sender ' || sender_email_address);
            fnd_file.put_line (fnd_file.LOG,
                               'Recipient ' || destination_email_address
                              );
            x_result :=
               sendmailjpkg.sendmail
                  (smtpservername      => iri_html.get_url ('SMTP_MAILER'),
                   sender              => sender_email_address,
                   recipient           => destination_email_address,
                   ccrecipient         => dest_cc,
                   subject             => email_re,
                   errormessage        => return_message,
                   BODY                => email_message,
                   attachments         => sendmailjpkg.attachments_list
                                                            (p_output_filename)
                  );
            fnd_file.put_line (fnd_file.LOG, 'Sending Email');
            fnd_file.put_line (fnd_file.LOG,
                               'Error Message ' || return_message
                              );
         END IF;
      ELSIF phase_code = 'C' AND status_code = 'E'
      THEN                            /* it ran but the request errored out */
         retcode := 1;
         errbuf := 'Check Error Log';
         fnd_file.put_line (fnd_file.LOG, 'The request timed out');
         /* do some error logging */
         fnd_file.put_line (fnd_file.LOG, 'End of process');
         RETURN;
      END IF;

      fnd_file.put_line (fnd_file.LOG, 'End of process');
   END;

   PROCEDURE update_status_after_printing (p_header_id IN VARCHAR2)
   IS
      v_header_id   NUMBER;
      v_sql         VARCHAR2 (5000);
      v_count       NUMBER          := 0;
   BEGIN
      BEGIN
--fnd_file.put_line (FND_FILE.LOG, 'Start of process');
--fnd_file.put_line (FND_FILE.LOG, 'Processing header_id: '||to_char(p_header_id));
         v_header_id := TO_NUMBER (p_header_id);
         v_sql :=
               'select count(*) from sicd_documents where header_id=:1 and nvl(attribute1,'
            || CHR (39)
            || 'N'
            || CHR (39)
            || ')='
            || CHR (39)
            || 'N'
            || CHR (39);

         EXECUTE IMMEDIATE v_sql
                      INTO v_count
                     USING v_header_id;

--fnd_file.put_line (FND_FILE.LOG, v_sql);
--fnd_file.put_line (FND_FILE.LOG, 'Number of Unprinted Documents on order: '||to_char(v_count));
         IF v_count = 0
         THEN
            fnd_file.put_line (fnd_file.LOG, 'Updating Order Status');
            v_sql :=
                  'update oe_order_headers_all set attribute9 ='
               || CHR (39)
               || 'Pending Shipping'
               || CHR (39)
               || '  where header_id=:1';
         ELSE
            v_sql :=
                  'update oe_order_headers_all set attribute9 ='
               || CHR (39)
               || 'Pending Book Numbers'
               || CHR (39)
               || '  where header_id=:1';
         END IF;

--fnd_file.put_line (FND_FILE.LOG, v_sql);
         EXECUTE IMMEDIATE v_sql
                     USING v_header_id;

         COMMIT;
--fnd_file.put_line (FND_FILE.LOG, 'End of process');
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20220, SQLERRM);
      END;
   END update_status_after_printing;

   FUNCTION is_courier_fee_required (
      p_created_by     IN   NUMBER,
      p_esi_batch_id   IN   NUMBER
   )
      RETURN VARCHAR2
   IS
      def_processing_office   VARCHAR2 (20)  := NULL;

      CURSOR get_ship_to
      IS
         SELECT address_utils.get_customer_country (ship_to_site_use_id)
           FROM exsicd_batch_iface
          WHERE esi_batch_id = p_esi_batch_id;

      ship_to_country         VARCHAR2 (100) := NULL;
   BEGIN
/* for now everyone gets the fee */
      RETURN 'Yes';
      def_processing_office :=
         exsicd_profiles_pkg.get_user_profile (p_created_by,
                                               'Default Processing Office'
                                              );

-- MT 9/29/15
      OPEN get_ship_to;

      FETCH get_ship_to
       INTO ship_to_country;

      CLOSE get_ship_to;

      IF def_processing_office = '1001'
      THEN                                                        /* Reston */
         IF ship_to_country = 'United States'
         THEN
            RETURN 'No';
         ELSE
            RETURN 'Yes';
         END IF;
      ELSIF def_processing_office = '1002'
      THEN                                                         /* London*/
         IF ship_to_country = 'United Kingdom'
         THEN
            RETURN 'No';
         ELSE
            RETURN 'Yes';
         END IF;
      ELSIF def_processing_office = '1003'
      THEN                                                     /* hong kong */
         IF ship_to_country = 'Hong Kong'
         THEN
            RETURN 'No';
         ELSE
            RETURN 'Yes';
         END IF;
      ELSIF def_processing_office = '1004'
      THEN                                                        /*piraeus */
         IF    ship_to_country = 'Greece'
            OR ship_to_country = 'Cyprus'
            OR ship_to_country = 'Turkey'
         THEN
            RETURN 'No';
         ELSE
            RETURN 'Yes';
         END IF;
      ELSIF def_processing_office = '1045'
      THEN                                                /* Ft. Lauderdale */
         IF ship_to_country = 'United States'
         THEN
            RETURN 'No';
         ELSE
            RETURN 'Yes';
         END IF;
      ELSIF def_processing_office = '100004045'
      THEN                                                         /* Manila*/
         IF ship_to_country = 'Philippines'
         THEN
            RETURN 'No';
         ELSE
            RETURN 'Yes';
         END IF;
      END IF;

      RETURN ('Yes');
   END;

   PROCEDURE write_log (p_msg IN VARCHAR2)
   IS
   BEGIN
      fnd_file.put_line (fnd_file.LOG, p_msg);
      DBMS_OUTPUT.put_line (p_msg);
   END;

   PROCEDURE refresh_all_related_tc (
      xref            IN       world_check_iface.wc_external_xref_rec,
      p_return_code   OUT      VARCHAR,
      p_ret_msg       OUT      VARCHAR2
   )
   IS
      CURSOR get_related_recs
      IS
         SELECT *
           FROM worldcheck_external_xref
          WHERE source_table = xref.source_table
            AND source_table_column = xref.source_table_column
            AND source_table_id = xref.source_table_id;

      l_refresh_req   xwrl_requests%ROWTYPE;
      l_refresh_rec   rmi_ows_common_util.ows_request_rec;
      x_id_refresh    NUMBER;
   BEGIN
----dbms_output.put_line(xref.SOURCE_TABLE||' '|| xref.SOURCE_TABLE||' '||to_char(xref.SOURCE_TABLE_ID));
      FOR x IN get_related_recs
      LOOP
         l_refresh_req :=
             rmi_ows_common_util.get_case_details (x.wc_screening_request_id);
         l_refresh_rec.entity_type :=
                       rmi_ows_common_util.get_entity_type (l_refresh_req.ID);
         l_refresh_rec.source_table := l_refresh_req.source_table;
         l_refresh_rec.source_id := l_refresh_req.source_id;
--         l_refresh_rec.source_table_column := l_refresh_req.source_table_column;
         l_refresh_rec.full_name :=
            rmi_ows_common_util.get_id_request_values (l_refresh_req.ID,
                                                       'FullName'
                                                      );
         l_refresh_rec.first_name :=
            rmi_ows_common_util.get_id_request_values (l_refresh_req.ID,
                                                       'GivenNames'
                                                      );
         l_refresh_rec.last_name :=
            rmi_ows_common_util.get_id_request_values (l_refresh_req.ID,
                                                       'FamilyName'
                                                      );
         l_refresh_rec.title :=
            rmi_ows_common_util.get_id_request_values (l_refresh_req.ID,
                                                       'Title'
                                                      );
         l_refresh_rec.date_of_birth :=
            TO_DATE
               (SUBSTR
                   (rmi_ows_common_util.get_id_request_values
                                                            (l_refresh_req.ID,
                                                             'DateOfBirth'
                                                            ),
                    1,
                    10
                   ),
                'YYYY-MM-DD'
               );
         l_refresh_rec.gender :=
            rmi_ows_common_util.get_id_request_values (l_refresh_req.ID,
                                                       'Gender'
                                                      );
         l_refresh_rec.passport_number :=
            rmi_ows_common_util.get_id_request_values (l_refresh_req.ID,
                                                       'PassportNumber'
                                                      );
         l_refresh_rec.registrationnumber :=
            rmi_ows_common_util.get_id_request_values (l_refresh_req.ID,
                                                       'NationalId'
                                                      );
         l_refresh_rec.city :=
            rmi_ows_common_util.get_id_request_values (l_refresh_req.ID,
                                                       'City'
                                                      );
         l_refresh_rec.nationality :=
            rmi_ows_common_util.get_country_name_iso
               (rmi_ows_common_util.get_id_request_values
                                                         (l_refresh_req.ID,
                                                          'CountryOfBirthCode'
                                                         )
               );
         l_refresh_rec.passport_issuing_country_code :=
            rmi_ows_common_util.get_country_name_iso
               (rmi_ows_common_util.get_id_request_values
                                                    (l_refresh_req.ID,
                                                     'NationalityCountryCodes'
                                                    )
               );
         l_refresh_rec.residence_country_code :=
            rmi_ows_common_util.get_country_name_iso
               (rmi_ows_common_util.get_id_request_values
                                                       (l_refresh_req.ID,
                                                        'ResidencyCountryCode'
                                                       )
               );
         l_refresh_rec.vessel_indicator := l_refresh_req.vessel_indicator;
         l_refresh_rec.name_screened := l_refresh_req.name_screened;
         --
         rmi_ows_common_util.create_ows_generic
                                              (p_req              => l_refresh_rec,
                                               p_custom_id1       => NULL,
                                               p_custom_id2       => NULL,
                                               p_return_code      => p_return_code,
                                               p_ret_msg          => p_ret_msg,
                                               x_id               => x_id_refresh
                                              );

         IF p_return_code != 'SUCCESS'
         THEN
            p_return_code := 'ERROR';
            p_ret_msg := 'Error Refreshing Match contents';
            EXIT;
         END IF;
      END LOOP;
   END;

   FUNCTION has_cra (p_esi_id IN NUMBER)
      RETURN VARCHAR2
   IS
      CURSOR cur_doc
      IS
         SELECT 'Y'
           FROM exsicd_seafarer_docs_iface
          WHERE esi_id = p_esi_id AND cra_required = 'Y';

      l_found   VARCHAR2 (1) := 'N';
   BEGIN
      OPEN cur_doc;

      FETCH cur_doc
       INTO l_found;

      CLOSE cur_doc;

      RETURN NVL (l_found, 'N');
   END has_cra;

   PROCEDURE create_provisional_tc (
      p_esi_batch_id   IN       NUMBER,
      return_code      OUT      NUMBER,
      ret_msg          OUT      VARCHAR2
   )
   IS
      CURSOR get_seafarers
      IS
         SELECT *
           FROM exsicd_seafarers_iface
          WHERE esi_batch_id = p_esi_batch_id
            -- SAURABH 27-MAY-2019 T20170323.0014
            AND status IN ('Acknowledgement Pending', 'OC Only');

      CURSOR get_related_tc (p_seafarer_id IN NUMBER)
      IS
         SELECT *
           FROM worldcheck_external_xref
          WHERE source_table = 'SICD_SEAFARERS'
            AND source_table_column = 'SEAFARER_ID'
            AND source_table_id = p_seafarer_id;

      CURSOR get_tc_request (p_wc_screening_request_id IN NUMBER)
      IS
         SELECT *
           FROM wc_screening_request
          WHERE wc_screening_request_id = p_wc_screening_request_id;

      tc_req_rec              get_tc_request%ROWTYPE;

/*
cursor get_seafarer(p_seafarer_id in number)  is select 'Y' from sicd_seafarers where seafarer_id=p_seafarer_id;
*/
      CURSOR get_seafarer (p_seafarer_id IN NUMBER)
      IS
         SELECT 'Y'
           FROM xwrl_party_master
          WHERE source_table = 'SICD_SEAFARERS'
            AND source_table_column = 'SEAFARER_ID'
            AND source_id = p_seafarer_id;

      CURSOR get_related_tc_ows (p_seafarer_id IN NUMBER)
      IS
         SELECT   *
             FROM (SELECT full_name, creation_date, source_id, source_table,
                          given_name, date_of_birth, family_name, sex,
                          passport_number, city_of_residence_id,
                          citizenship_country_code,
                          passport_issuing_country_code, country_of_residence
                     FROM xwrl_party_master r
                    WHERE 1 = 1
                      AND relationship_type = 'Primary'
                      AND status = 'Enabled'
                      AND state NOT LIKE '%Delete%'
                      AND source_table = 'SICD_SEAFARERS'
                      AND source_table_column = 'SEAFARER_ID'
                      AND source_id = p_seafarer_id
                   UNION ALL
                   SELECT a.full_name, a.creation_date, source_id,
                          source_table, a.given_name, a.date_of_birth,
                          a.family_name, a.sex, a.passport_number,
                          a.city_of_residence_id, a.citizenship_country_code,
                          a.passport_issuing_country_code,
                          a.country_of_residence
                     FROM xwrl_party_alias a, xwrl_party_master r
                    WHERE a.master_id = r.ID
                      AND r.relationship_type = 'Primary'
                      AND r.status = 'Enabled'
                      AND r.state NOT LIKE '%Delete%'
                      AND r.source_table = 'SICD_SEAFARERS'
                      AND r.source_table_column = 'SEAFARER_ID'
                      AND r.source_id = p_seafarer_id
                   UNION ALL
                   SELECT b.full_name, b.creation_date, b.source_id,
                          b.source_table, b.given_name, b.date_of_birth,
                          b.family_name, b.sex, b.passport_number,
                          b.city_of_residence_id, b.citizenship_country_code,
                          b.passport_issuing_country_code,
                          b.country_of_residence
                     FROM xwrl_party_master b,
                          xwrl_party_xref xref,
                          xwrl_party_master a
                    WHERE 1 = 1
                      AND xref.master_id = a.ID
                      AND xref.relationship_master_id = b.ID
                      AND a.status = 'Enabled'
                      AND a.state NOT LIKE '%Delete%'
                      AND b.status = 'Enabled'
                      AND b.state NOT LIKE '%Delete%'
                      AND a.source_table = 'SICD_SEAFARERS'
                      AND a.source_table_column = 'SEAFARER_ID'
                      AND a.source_id = p_seafarer_id
                      AND xref.status = 'Enabled'
                      AND xref.relationship_master_id <> xref.master_id
                      AND TRUNC (SYSDATE) BETWEEN TRUNC (NVL (xref.start_date,
                                                              SYSDATE
                                                             )
                                                        )
                                              AND TRUNC (NVL (xref.end_date,
                                                              SYSDATE
                                                             )
                                                        ))
         ORDER BY creation_date DESC;

      FOUND                   VARCHAR2 (1)                              := 'N';
      p_xref                  world_check_iface.wc_external_xref_rec;
      p_req                   world_check_iface.wc_screening_request_rec;
      p_return_code           VARCHAR2 (30);
      p_ret_msg               VARCHAR2 (500);
      p_custom_id1            VARCHAR2 (100);
      p_custom_id2            VARCHAR2 (100);
      tc_status               VARCHAR2 (30);
      pending_status          VARCHAR2 (30);
      provisional_approval    BOOLEAN;

      CURSOR get_contents (p_wc_screening_request_id IN NUMBER)
      IS
         SELECT wc.*
           FROM wc_content_v wc, wc_matches_v wm
          WHERE wc.wc_matches_id = wm.wc_matches_id
            AND wm.wc_screening_request_id = p_wc_screening_request_id;

      cc_request_id           NUMBER                                   := NULL;
      --SAURABH 09-SEP-2018 T20180620.0018
      l_last_revetting_date   DATE;
      -- SAURABH 27-MAY-2019 T20170323.0014
      l_new_vetting           VARCHAR2 (10);
      l_user_id               NUMBER          := fnd_profile.VALUE ('USER_ID');
      l_ows_req               xwrl_requests%ROWTYPE;
      l_ows_req_in            rmi_ows_common_util.ows_request_rec;
      l_ows_id                NUMBER;
      l_create_new_req        VARCHAR2 (1);
      l_session_id            NUMBER;
      l_party_rec             xwrl_party_master%ROWTYPE;
      l_batch_id              NUMBER;
      l_login_id              NUMBER         := fnd_profile.VALUE ('LOGIN_ID');
      x_return_status         VARCHAR2 (100);
      x_return_msg            VARCHAR2 (300);
      l_username              VARCHAR2 (100) := fnd_profile.VALUE ('USERNAME');
      l_prev_batch_id         NUMBER;
      l_expiration_date       DATE;
      x_batch_id              NUMBER;
      entity_data             rmi_ows_common_util.screening_tab;
   BEGIN
      cc_request_id := fnd_global.conc_request_id;

--dbms_output.put_line('cc_request_id '||to_char(cc_request_id));
      IF cc_request_id != -1
      THEN
         fnd_file.put_line (fnd_file.LOG,
                            'iri_sicd_online.create_provisional_tc - running'
                           );
      END IF;

      return_code := 0;
      ret_msg := 'Normal';
      p_xref.source_table := 'SICD_SEAFARERS';
      p_xref.source_table_column := 'SEAFARER_ID';

--      fnd_global.apps_initialize(10378,51664,20030);

      -- SAURABH OWS  09-OCT-2019
      IF rmi_ows_common_util.is_ows_user = 'N'
      THEN
         FOR x IN get_seafarers
         LOOP
            tc_status := 'NO_RECORD';
            -- SAURABH 27-MAY-2019 T20170323.0014
            l_new_vetting := 'N';
            p_xref.source_table_id := x.seafarer_id;
            -- SAURABH 27-MAY-2019 T20170323.0014
            l_last_revetting_date := NULL;

--dbms_output.put_line('Seafarer '||to_char(x.seafarer_id));
            OPEN get_seafarer (x.seafarer_id);

            FETCH get_seafarer
             INTO FOUND;

            CLOSE get_seafarer;

            IF FOUND = 'Y'
            THEN    /* does the seafarer exist in the sicd_seafarer tables */
--dbms_output.put_line('Seafarer Exists');
               tc_status := world_check_iface.get_wc_status (p_xref, p_req);

               IF cc_request_id != -1
               THEN
                  fnd_file.put_line (fnd_file.LOG,
                                        'Seafarer Exists: '
                                     || TO_CHAR (x.seafarer_id)
                                     || ' '
                                     || tc_status
                                    );
               END IF;

--dbms_output.put_line('Status '||tc_status );
               IF tc_status = 'NO_RECORD'
               THEN              /* if no  tc record exists then create one */
--dbms_output.put_line('Create' );
                  -- SAURABH 27-MAY-2019 T20170323.0014
                  l_new_vetting := 'Y';
                  world_check_iface.create_wc_seafarer_id (x.seafarer_id,
                                                           p_return_code,
                                                           p_ret_msg
                                                          );
                  exsicd_utils.create_tc_document_references
                                               (p_req.wc_screening_request_id,
                                                x.esi_id,
                                                p_return_code,
                                                p_ret_msg
                                               );
               ELSE                                  /* refresh the results */
--dbms_output.put_line('Refresh' );
                  FOR tc_rec IN get_related_tc (x.seafarer_id)
                  LOOP
                     tc_req_rec.citizenship_country_code := NULL;
                     tc_req_rec.passport_issuing_country_code := NULL;
                     tc_req_rec.residence_country_code := NULL;
                     tc_req_rec.wc_city_list_id := NULL;
                     tc_req_rec.wc_screening_request_id := NULL;

                     OPEN get_tc_request (tc_rec.wc_screening_request_id);

                     FETCH get_tc_request
                      INTO tc_req_rec;

                     CLOSE get_tc_request;

                     IF tc_req_rec.wc_screening_request_id IS NOT NULL
                     THEN
                        BEGIN
                           UPDATE wc_screening_request
                              SET passport_issuing_country_code =
                                               x.passport_issuing_country_code,
                                  last_update_date = SYSDATE,
                                  last_updated_by = 3
                            WHERE wc_screening_request_id =
                                            tc_req_rec.wc_screening_request_id
                              AND passport_issuing_country_code IS NULL
                              AND x.passport_issuing_country_code IS NOT NULL;

                           UPDATE wc_screening_request
                              SET citizenship_country_code = x.nationality,
                                  last_update_date = SYSDATE,
                                  last_updated_by = 3
                            WHERE wc_screening_request_id =
                                            tc_req_rec.wc_screening_request_id
                              AND citizenship_country_code IS NULL
                              AND x.nationality IS NOT NULL;

                           UPDATE wc_screening_request
                              SET residence_country_code =
                                                      x.residence_country_code,
                                  last_update_date = SYSDATE,
                                  last_updated_by = 3
                            WHERE wc_screening_request_id =
                                            tc_req_rec.wc_screening_request_id
                              AND residence_country_code IS NULL
                              AND x.residence_country_code IS NOT NULL;

                           UPDATE wc_screening_request
                              SET wc_city_list_id = x.wc_city_list_id,
                                  last_update_date = SYSDATE,
                                  last_updated_by = 3
                            WHERE wc_screening_request_id =
                                            tc_req_rec.wc_screening_request_id
                              AND wc_city_list_id IS NULL
                              AND x.wc_city_list_id IS NOT NULL;

                           COMMIT;
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              ROLLBACK;
                        END;
                     END IF;
                  END LOOP;

                  --SAURABH 09-SEP-2018 T20180620.0018
                  -- revetting to be done only if last revetting is done before 24 hrs
                  BEGIN
                     SELECT MAX (status_date)
                       INTO l_last_revetting_date
                       FROM wc_request_approval_history
                      WHERE status_date IS NOT NULL
                        AND wc_screening_request_id =
                                                 p_req.wc_screening_request_id;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        l_last_revetting_date := NULL;
                  END;

                  --
                  -- SAURABH 05-JUL-2018 T20180620.0018
                  IF    l_last_revetting_date IS NULL
                     OR TRUNC (l_last_revetting_date) < TRUNC (SYSDATE - 1)
                  THEN
                     --
                     l_new_vetting := 'Y';
                     world_check_iface.refresh_all_related_tc (p_xref,
                                                               p_return_code,
                                                               p_ret_msg
                                                              );
                  ELSE
                     --
                     fnd_file.put_line
                                   (fnd_file.LOG,
                                    'Revetting recently done, skip revetting'
                                   );
                  END IF;

                  exsicd_utils.create_tc_document_references
                                               (p_req.wc_screening_request_id,
                                                x.esi_id,
                                                p_return_code,
                                                p_ret_msg
                                               );
               END IF;
            ELSE                                         /* not they dont't */
--dbms_output.put_line('Seafarer does not exist');
               tc_status := world_check_iface.get_wc_status (p_xref, p_req);

               IF cc_request_id != -1
               THEN
                  fnd_file.put_line (fnd_file.LOG,
                                        'Seafarer does not Exist: '
                                     || TO_CHAR (x.seafarer_id)
                                     || ' '
                                     || tc_status
                                    );
               END IF;

               IF tc_status = 'NO_RECORD'
               THEN
                  l_new_vetting := 'Y';
                  p_req.wc_screening_request_id := NULL;
                  p_req.status := 'PENDING';
                  p_req.name_screened := x.first_name || ' ' || x.last_name;
                  p_req.date_of_birth := x.birth_date;
                  p_req.sex := x.gender;
                  p_req.name_identifier := NULL;
                  p_req.passport_number := NULL;
                  p_req.entity_type := 'INDIVIDUAL';
                  p_req.citizenship_country_code := x.nationality;
                  p_req.passport_issuing_country_code :=
                                              x.passport_issuing_country_code;
                  p_req.residence_country_code := x.residence_country_code;
                  p_req.wc_city_list_id := x.wc_city_list_id;
                  p_xref.source_table := 'SICD_SEAFARERS';
                  p_xref.source_table_column := 'SEAFARER_ID';
                  p_xref.source_table_id := x.seafarer_id;
                  p_xref.source_table_status_column := NULL;
                  p_xref.worldcheck_external_xref_id := NULL;
                  p_xref.wc_screening_request_id :=
                                                p_req.wc_screening_request_id;
--dbms_output.put_line('Create' );
                  world_check_iface.get_custom_tag_info (p_xref,
                                                         p_custom_id1,
                                                         p_custom_id2
                                                        );
                  world_check_iface.create_wc_generic (p_xref,
                                                       p_req,
                                                       p_custom_id1,
                                                       p_custom_id2,
                                                       p_return_code,
                                                       p_ret_msg
                                                      );
                  exsicd_utils.create_tc_document_references
                                               (p_req.wc_screening_request_id,
                                                x.esi_id,
                                                p_return_code,
                                                p_ret_msg
                                               );
               END IF;
            END IF;

/* check country sanction status */

            --dbms_output.put_line('get_sanction_status '|| p_req.CITIZENSHIP_COUNTRY_CODE||'  '||world_check_iface.get_sanction_status(p_req.CITIZENSHIP_COUNTRY_CODE));
--dbms_output.put_line('get_sanction_status '|| p_req.PASSPORT_ISSUING_COUNTRY_CODE||'  '||world_check_iface.get_sanction_status(p_req.PASSPORT_ISSUING_COUNTRY_CODE));
--dbms_output.put_line('get_sanction_status '|| p_req.RESIDENCE_COUNTRY_CODE||'  '||world_check_iface.get_sanction_status(p_req.RESIDENCE_COUNTRY_CODE));
--dbms_output.put_line('world_check_iface.get_city_tc_status(p_req.WC_CITY_LIST_ID) '||world_check_iface.get_city_tc_status(p_req.WC_CITY_LIST_ID));
            IF     world_check_iface.get_sanction_status
                                               (p_req.citizenship_country_code) =
                                                                        'NONE'
               AND world_check_iface.get_sanction_status
                                          (p_req.passport_issuing_country_code) =
                                                                        'NONE'
               AND world_check_iface.get_sanction_status
                                                 (p_req.residence_country_code) =
                                                                        'NONE'
            THEN
               provisional_approval := TRUE;
            ELSIF    world_check_iface.get_sanction_status
                                               (p_req.citizenship_country_code) =
                                                                  'PROHIBITED'
                  OR world_check_iface.get_sanction_status
                                          (p_req.passport_issuing_country_code) =
                                                                  'PROHIBITED'
                  OR world_check_iface.get_sanction_status
                                                 (p_req.residence_country_code) =
                                                                  'PROHIBITED'
            THEN
               provisional_approval := FALSE;
            ELSIF    world_check_iface.get_sanction_status
                                               (p_req.citizenship_country_code) =
                                                                 'CONDITIONAL'
                  OR world_check_iface.get_sanction_status
                                          (p_req.passport_issuing_country_code) =
                                                                 'CONDITIONAL'
                  OR world_check_iface.get_sanction_status
                                                 (p_req.residence_country_code) =
                                                                 'CONDITIONAL'
            THEN
               IF    world_check_iface.is_city_required
                                              (p_req.citizenship_country_code)
                  OR world_check_iface.is_city_required
                                          (p_req.passport_issuing_country_code)
                  OR world_check_iface.is_city_required
                                                 (p_req.residence_country_code)
               THEN
                  IF p_req.wc_city_list_id IS NULL
                  THEN
                     provisional_approval := FALSE;
                  ELSIF world_check_iface.get_city_tc_status
                                                        (p_req.wc_city_list_id) IN
                                                  ('TC_OK', 'TC_PROVISIONAL')
                  THEN                       /* check ciity sanction status */
                     provisional_approval := TRUE;
                  ELSE
                     provisional_approval := FALSE;
                  END IF;
               END IF;
            END IF;

            IF provisional_approval = TRUE
            THEN               /* lets check sanction status for each match */
               FOR x IN get_contents (p_req.wc_screening_request_id)
               LOOP
--dbms_output.put_line('world_check_iface.is_match_sanctioned(x.wc_content_id) '||world_check_iface.is_match_sanctioned(x.wc_content_id));
                  IF world_check_iface.is_match_sanctioned (x.wc_content_id) =
                                                                          'Y'
                  THEN
                     provisional_approval := FALSE;
                  END IF;
               END LOOP;
            END IF;

            tc_status := world_check_iface.get_wc_status (p_xref, p_req);

--dbms_output.put_line('tc_status '||tc_status);
/*
if provisional_approval then
dbms_output.put_line('Provisional Approval = TRUE');
else
dbms_output.put_line('Provisional Approval = FALSE');
end if; */
            IF    tc_status = 'Pending'
               -- SAURABH 27-MAY-2019 T20170323.0014
               OR (tc_status = 'Approved' AND NVL (l_new_vetting, 'N') = 'Y')
            THEN
               IF provisional_approval OR tc_status = 'Approved'
               THEN
                  pending_status := 'Provisional';
               ELSE
                  pending_status := 'Pending Provisional';
               END IF;

               v_sql :=
                  'UPDATE VSSL.WC_SCREENING_REQUEST
SET    STATUS = :1,
       STATUS_UPDATED_BY = :2,
       STATUS_DATE= :3
WHERE  WC_SCREENING_REQUEST_ID = :4 ';

               BEGIN
                  EXECUTE IMMEDIATE v_sql
                              USING
                                    pending_status,
                                    -- SAURABH 27-MAY-2019 T20170323.0014
                                    --world_check_iface.c_automatic_approval_uid,
                                    NVL
                                       (l_user_id,
                                        world_check_iface.c_automatic_approval_uid
                                       ),
                                    --WORLDCHECK_AUTOMATIC_APPROVAL
                                    SYSDATE,
                                    p_req.wc_screening_request_id;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     return_code := -1;
                     ret_msg := 'Create provisional TC error: ' || SQLERRM;
                     ROLLBACK;
                     RETURN;
               END;

               COMMIT;
            END IF;
         END LOOP;
      -- SAURABH OWS  09-OCT-2019
      ELSIF rmi_ows_common_util.is_ows_user = 'Y'
      THEN
         DBMS_OUTPUT.put_line ('Create Provisional Start..');

         FOR x IN get_seafarers
         LOOP
            tc_status := 'NO_RECORD';
            l_last_revetting_date := NULL;
            l_create_new_req := 'N';
            l_new_vetting := 'N';
            p_xref.source_table_id := x.seafarer_id;
            FOUND := 'N';
            write_log ('Seafarer ID ' || x.seafarer_id);

            OPEN get_seafarer (x.seafarer_id);

            FETCH get_seafarer
             INTO FOUND;

            CLOSE get_seafarer;

            write_log ('Seafarer in Party Master ' || FOUND);

            /* does the seafarer exist in the sicd_seafarer tables */

            /**********************************************************
            -------------------- Pseudo Logic -------------------------
            Check If Seafarer Exists in Party Master or not
            If Not then Insert
            Check Batch ID and Expiration Date
            If Approval Expired or not available then
            Call Create Batch Vetting
            **********************************************************/
            --
            IF NVL (FOUND, 'N') = 'N'
            THEN
               write_log ('Seafarer does not exist in party master');
               --
                  -- Create Party Master
               l_party_rec := NULL;
               l_party_rec.id := xwrl.xwrl_party_master_seq.nextval;
               l_party_rec.wc_screening_request_id := NULL;
               l_party_rec.relationship_type := 'Primary';
               l_party_rec.entity_type := 'INDIVIDUAL';
               l_party_rec.state := 'Verified';
               l_party_rec.status := 'Enabled';
               l_party_rec.source_table := 'SICD_SEAFARERS';
               l_party_rec.source_table_column := 'SEAFARER_ID';
               l_party_rec.source_id := x.seafarer_id;
               l_party_rec.xref_source_table := NULL;
               l_party_rec.xref_source_table_column := NULL;
               l_party_rec.xref_source_id := NULL;
               l_party_rec.full_name := TRIM(x.first_name || ' ' || x.last_name);
               l_party_rec.family_name := x.last_name;
               l_party_rec.given_name := x.first_name;
               l_party_rec.date_of_birth :=
                                           TO_CHAR (x.birth_date, 'YYYYMMDD');
               l_party_rec.sex := UPPER (x.gender);
               l_party_rec.imo_number := NULL;
               l_party_rec.department := 'SICD';
               l_party_rec.office := NULL;
               l_party_rec.priority := NULL;
               l_party_rec.risk_level := NULL;
               l_party_rec.document_type := NULL;
               l_party_rec.closed_date := NULL;
               l_party_rec.assigned_to := NULL;
               l_party_rec.vessel_indicator := NULL;
               l_party_rec.passport_number := NULL;
               l_party_rec.passport_issuing_country_code :=
                  rmi_ows_common_util.get_country_iso_code
                                             (x.passport_issuing_country_code);
               l_party_rec.citizenship_country_code :=
                     rmi_ows_common_util.get_country_iso_code (x.nationality);
               l_party_rec.country_of_residence :=
                  rmi_ows_common_util.get_country_iso_code
                                                    (x.residence_country_code);
               l_party_rec.city_of_residence_id := x.wc_city_list_id;
               l_party_rec.note := NULL;
               l_party_rec.start_date := SYSDATE;
               l_party_rec.end_date := NULL;
               l_party_rec.last_update_date := SYSDATE;
               l_party_rec.last_updated_by := l_user_id;
               l_party_rec.creation_date := SYSDATE;
               l_party_rec.created_by := l_user_id;
               l_party_rec.last_update_login := l_login_id;
               l_party_rec.source_target_column := NULL;

               IF has_cra (x.esi_id) = 'Y'
               THEN
                  l_party_rec.priority := '1';
                  l_party_rec.document_type := 'PPR';
               END IF;

               INSERT INTO xwrl_party_master
                    VALUES l_party_rec;

               -- T20191218.0022 
               -- SAURABH 17-FEB-2020 Update DPC with Master ID
               UPDATE rmi_data_privacy_consent
               SET    master_id =  l_party_rec.id
               WHERE  entity_id = x.seafarer_id
               AND    entity_type = 'SEAFARERS';

               l_new_vetting := 'Y';
            ELSE
               write_log ('Seafarer Exists in party Master..');
               -- update master
               rmi_ows_common_util.query_cross_reference ('SICD_SEAFARERS',
                                                          'SEAFARER_ID',
                                                          x.seafarer_id,
                                                          entity_data
                                                         );
               write_log ('Total Reference Count ' || entity_data.COUNT);

               FOR i IN 1 .. entity_data.COUNT
               LOOP
                  UPDATE xwrl_party_master
                     SET date_of_birth = TO_CHAR (x.birth_date, 'YYYYMMDD'),
                         sex = UPPER (x.gender),
                         passport_issuing_country_code =
                            rmi_ows_common_util.get_country_iso_code
                                              (x.passport_issuing_country_code),
                         citizenship_country_code =
                            rmi_ows_common_util.get_country_iso_code
                                                                (x.nationality),
                         country_of_residence =
                            rmi_ows_common_util.get_country_iso_code
                                                     (x.residence_country_code),
                         city_of_residence_id = x.wc_city_list_id,
                         last_update_date = SYSDATE,
                         last_updated_by = l_user_id
                   WHERE 1 = 1
                     AND TRIM (xwrl_utils.cleanse_name (full_name)) =
                            TRIM (xwrl_utils.cleanse_name (   x.first_name
                                                           || ' '
                                                           || x.last_name
                                                          )
                                 )
                     AND ID = entity_data (i).master_id
                     AND entity_data (i).alias_id IS NULL
                     AND entity_data (i).xref_id IS NULL
                     AND (
--                             NVL (given_name, 'xx')    <> NVL (x.first_name, 'xx')
--                          OR NVL (family_name, 'xx')   <> NVL (x.last_name, 'xx')
--                          OR
                             NVL (date_of_birth, 'xx') <>
                                            TO_CHAR (x.birth_date, 'YYYYMMDD')
                          OR NVL (UPPER (sex), 'xx') <> UPPER (x.gender)
                          OR NVL (passport_issuing_country_code, 'xx') <>
                                rmi_ows_common_util.get_country_iso_code
                                              (x.passport_issuing_country_code)
                          OR NVL (citizenship_country_code, 'xx') <>
                                rmi_ows_common_util.get_country_iso_code
                                                                (x.nationality)
                          OR NVL (country_of_residence, 'xx') <>
                                rmi_ows_common_util.get_country_iso_code
                                                     (x.residence_country_code)
                          OR NVL (city_of_residence_id, -999) <>
                                                             x.wc_city_list_id
                         );

                  IF SQL%ROWCOUNT > 0
                  THEN
                     l_new_vetting := 'Y';
                     write_log ('Master Updated..');
                  END IF;



                  UPDATE xwrl_party_alias
                     SET date_of_birth = TO_CHAR (x.birth_date, 'YYYYMMDD'),
                         sex = UPPER (x.gender),
                         passport_issuing_country_code =
                            rmi_ows_common_util.get_country_iso_code
                                              (x.passport_issuing_country_code),
                         citizenship_country_code =
                            rmi_ows_common_util.get_country_iso_code
                                                                (x.nationality),
                         country_of_residence =
                            rmi_ows_common_util.get_country_iso_code
                                                     (x.residence_country_code),
                         city_of_residence_id = x.wc_city_list_id,
                         last_update_date = SYSDATE,
                         last_updated_by = l_user_id
                   WHERE 1 = 1
                     AND TRIM (xwrl_utils.cleanse_name (full_name)) =
                            TRIM (xwrl_utils.cleanse_name (   x.first_name
                                                           || ' '
                                                           || x.last_name
                                                          )
                                 )
                     AND master_id = entity_data (i).master_id
                     AND ID = entity_data (i).alias_id
                     AND entity_data (i).xref_id IS NULL
                     AND (
--                     NVL (given_name, 'xx') <>
--                                                      NVL (x.first_name, 'xx')
--                          OR NVL (family_name, 'xx') <>
--                                                       NVL (x.last_name, 'xx')
--                          OR
                             NVL (date_of_birth, 'xx') <>
                                            TO_CHAR (x.birth_date, 'YYYYMMDD')
                          OR NVL (UPPER (sex), 'xx') <> UPPER (x.gender)
                          OR NVL (passport_issuing_country_code, 'xx') <>
                                rmi_ows_common_util.get_country_iso_code
                                              (x.passport_issuing_country_code)
                          OR NVL (citizenship_country_code, 'xx') <>
                                rmi_ows_common_util.get_country_iso_code
                                                                (x.nationality)
                          OR NVL (country_of_residence, 'xx') <>
                                rmi_ows_common_util.get_country_iso_code
                                                     (x.residence_country_code)
                          OR NVL (city_of_residence_id, -999) <>
                                                             x.wc_city_list_id
                         );

                  IF SQL%ROWCOUNT > 0
                  THEN
                     l_new_vetting := 'Y';
                     write_log ('Alias Updated..');
                  END IF;

                  UPDATE xwrl_party_master
                     SET date_of_birth = TO_CHAR (x.birth_date, 'YYYYMMDD'),
                         sex = UPPER (x.gender),
                         passport_issuing_country_code =
                            rmi_ows_common_util.get_country_iso_code
                                              (x.passport_issuing_country_code),
                         citizenship_country_code =
                            rmi_ows_common_util.get_country_iso_code
                                                                (x.nationality),
                         country_of_residence =
                            rmi_ows_common_util.get_country_iso_code
                                                     (x.residence_country_code),
                         city_of_residence_id = x.wc_city_list_id,
                         last_update_date = SYSDATE,
                         last_updated_by = l_user_id
                   WHERE 1 = 1
                     AND TRIM (xwrl_utils.cleanse_name (full_name)) =
                            TRIM (xwrl_utils.cleanse_name (   x.first_name
                                                           || ' '
                                                           || x.last_name
                                                          )
                                 )
                     AND ID =
                            (SELECT relationship_master_id
                               FROM xwrl_party_xref
                              WHERE 1 = 1
                                AND ID = entity_data (i).xref_id
                                AND master_id = entity_data (i).master_id)
                     AND entity_data (i).alias_id IS NULL
                     AND (
--                     NVL (given_name, 'xx') <>
--                                                      NVL (x.first_name, 'xx')
--                          OR NVL (family_name, 'xx') <>
--                                                       NVL (x.last_name, 'xx')
--                          OR
                             NVL (date_of_birth, 'xx') <>
                                NVL (TO_CHAR (x.birth_date, 'YYYYMMDD'), 'xx')
                          OR NVL (UPPER (sex), 'xx') <> UPPER (x.gender)
                          OR NVL (passport_issuing_country_code, 'xx') <>
                                rmi_ows_common_util.get_country_iso_code
                                              (x.passport_issuing_country_code)
                          OR NVL (citizenship_country_code, 'xx') <>
                                rmi_ows_common_util.get_country_iso_code
                                                                (x.nationality)
                          OR NVL (country_of_residence, 'xx') <>
                                rmi_ows_common_util.get_country_iso_code
                                                     (x.residence_country_code)
                          OR NVL (city_of_residence_id, -999) <>
                                                             x.wc_city_list_id
                         );

                  IF SQL%ROWCOUNT > 0
                  THEN
                     l_new_vetting := 'Y';
                     write_log ('Xref Updated..');
                  END IF;

                  UPDATE xwrl_party_master
                     SET priority = '1',
                         document_type = 'PPR',
                         department = 'SICD'
                   WHERE has_cra (x.esi_id) = 'Y'
                     AND ID = entity_data (i).master_id;

                  UPDATE xwrl_party_master
                     SET priority = NULL,
                         document_type = NULL,
                         department = 'SICD'
                   WHERE has_cra (x.esi_id) = 'N'
                     AND ID = entity_data (i).master_id;


                  UPDATE rmi_data_privacy_consent
                   SET    master_id =  entity_data (i).master_id
                  WHERE  entity_id = x.seafarer_id
                  AND    entity_type = 'SEAFARERS'
                  AND    master_id IS NULL;

                  UPDATE rmi_data_privacy_consent
                   SET    master_id =  (select master_id from xwrl_party_alias where id = entity_data (i).alias_id)
                  WHERE  entity_id = x.seafarer_id
                  AND    entity_type = 'SEAFARERS'
                  AND    master_id IS NULL;


               END LOOP;

               --
               COMMIT;
            END IF;

            IF l_new_vetting = 'Y'
            THEN
               COMMIT;
            END IF;

            --IF 'Y' = 'Y'
            --THEN
            write_log ('Peform TC Start..');

            -- Get Latest TC Status for Seafarer in OWS

            -- Check Batch ID and Expiration Date
            BEGIN
               SELECT MAX (batch_id)
                 INTO l_batch_id
                 FROM xwrl_requests
                WHERE 1 = 1
                  AND source_table = 'SICD_SEAFARERS'
                  AND source_id = x.seafarer_id
                  AND case_state NOT IN ('D', 'E');
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_batch_id := NULL;
            END;

            write_log ('Batch ID ' || l_batch_id);

            BEGIN
               SELECT MAX (expiration_date)
                 INTO l_expiration_date
                 FROM xwrl_requests
                WHERE batch_id = l_batch_id AND expiration_date IS NOT NULL;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_expiration_date := NULL;
            END;

            write_log ('Approval Expiration Date ' || l_expiration_date);
            tc_status :=
               rmi_ows_common_util.get_wc_status ('SICD_SEAFARERS',
                                                  'SEAFARER_ID',
                                                  x.seafarer_id,
                                                     x.first_name
                                                  || ' '
                                                  || x.last_name
                                                 );
            write_log ('Seafarer tc status ' || tc_status);
            write_log ('l_new_vetting ' || l_new_vetting);

            IF     tc_status IN ('Approved', 'Provisional')
               AND l_expiration_date >= SYSDATE
               AND NVL (l_new_vetting, 'N') = 'N'
            THEN
               write_log ('Skip Vetting as TC done within 24 Hours');

               rmi_ows_common_util.create_document_references (l_batch_id,
                                                               x.esi_id,
                                                               p_return_code,
                                                               p_ret_msg
                                                              );
            ELSE
               write_log ('Create new OWS Request..' || x.first_name);
               rmi_ows_common_util.create_new_vetting
                                     (p_source_table             => 'SICD_SEAFARERS',
                                      p_source_table_column      => 'SEAFARER_ID',
                                      p_source_id                => x.seafarer_id,
                                      x_batch_id                 => x_batch_id,
                                      x_return_status            => x_return_status,
                                      x_return_msg               => x_return_msg
                                     );
               write_log ('new OWS Request..' || x_batch_id);
               rmi_ows_common_util.create_document_references (x_batch_id,
                                                               x.esi_id,
                                                               p_return_code,
                                                               p_ret_msg
                                                              );
            END IF;

               /* if no  tc record exists then create one */
--               IF tc_status = 'NO_RECORD'
--               THEN
--                  write_log ('Create new OWS Request..' || x.first_name);
--                  l_new_vetting := 'Y';
--                  -- create new vetting
--                  l_batch_id := xwrl_batch_seq.NEXTVAL;
--                  l_new_vetting := 'Y';
--                  l_ows_req_in.entity_type := 'INDIVIDUAL';
--                  l_ows_req_in.source_table := 'SICD_SEAFARERS';
--                  l_ows_req_in.source_table_column := 'SEAFARER_ID';
--                  l_ows_req_in.source_id := x.seafarer_id;
--                  l_ows_req_in.full_name :=
--                                           x.first_name || ' ' || x.last_name;
--                  l_ows_req_in.first_name := x.first_name;
--                  l_ows_req_in.last_name := x.last_name;
--                  l_ows_req_in.date_of_birth := x.birth_date;
--                  l_ows_req_in.gender := x.gender;
----               l_ows_req_in.passport_number := x.passport_number;
--                  l_ows_req_in.batch_id := l_batch_id;
--                  l_ows_req_in.city :=
--                        rmi_ows_common_util.get_city_name (x.wc_city_list_id);
--                  l_ows_req_in.city_id := x.wc_city_list_id;
--                  l_ows_req_in.nationality := x.nationality;
--                  l_ows_req_in.passport_issuing_country_code :=
--                                              x.passport_issuing_country_code;
--                  l_ows_req_in.residence_country_code :=
--                                                     x.residence_country_code;
--                  rmi_ows_common_util.create_ows_generic (l_ows_req_in,
--                                                          p_custom_id1,
--                                                          p_custom_id2,
--                                                          p_return_code,
--                                                          p_ret_msg,
--                                                          l_ows_id
--                                                         );
--                  write_log ('OWS Request ID ' || l_ows_id);
--                  rmi_ows_common_util.create_tc_document_references
--                                                               (l_ows_id,
--                                                                x.esi_id,
--                                                                p_return_code,
--                                                                p_ret_msg
--                                                               );
--                  write_log ('Create Ref Code ' || p_return_code);
--                  write_log ('Create Ref Msg ' || p_ret_msg);
--               ELSE
--                  write_log ('OWS Request exists with status' || tc_status);
--                  l_prev_batch_id :=
--                     rmi_ows_common_util.get_batch_id ('SICD_SEAFARERS',
--                                                       x.seafarer_id
--                                                      );
--                  write_log ('Batch ID' || l_batch_id);

            --                  FOR tc_rec IN get_related_tc_ows (x.seafarer_id)
--                  LOOP
--                     --
--                     --
--                     write_log ('Check related TC' || tc_status);
--                     tc_req_rec := NULL;
--                     l_ows_id := NULL;

            --                     BEGIN
--                        SELECT MAX (ID)
--                          INTO l_ows_id
--                          FROM xwrl_requests
--                         WHERE source_table = tc_rec.source_table
--                           AND source_id = tc_rec.source_id
--                           AND TRIM (xwrl_utils.cleanse_name (name_screened)) =
--                                  TRIM
--                                     (xwrl_utils.cleanse_name
--                                                             (tc_rec.full_name)
--                                     );
--                     EXCEPTION
--                        WHEN OTHERS
--                        THEN
--                           l_ows_id := NULL;
--                     END;

            --                     --
--                     --
--                     l_ows_req :=
--                               rmi_ows_common_util.get_case_details (l_ows_id);
--                     write_log ('OWS Req ID' || l_ows_req.ID);

            --                     IF    l_ows_req.expiration_date IS NULL
--                        OR (    l_ows_req.expiration_date < SYSDATE
--                            AND l_ows_req.case_workflow IN ('A', 'PR')
--                           )
--                     THEN
--                        --  need to re submit OWS Request
--                        l_new_vetting := 'Y';
--                        -- create new vetting
--                        l_batch_id := xwrl_batch_seq.NEXTVAL;
--                        l_ows_req_in.entity_type := 'INDIVIDUAL';
--                        l_ows_req_in.source_table := 'SICD_SEAFARERS';
--                        l_ows_req_in.source_table_column := 'SEAFARER_ID';
--                        l_ows_req_in.source_id := tc_rec.source_id;
--                        l_ows_req_in.full_name := tc_rec.full_name;
--                        l_ows_req_in.first_name := tc_rec.given_name;
--                        l_ows_req_in.last_name := tc_rec.family_name;
--                        l_ows_req_in.date_of_birth :=
--                                   TO_DATE (tc_rec.date_of_birth, 'YYYYMMDD');
--                        l_ows_req_in.gender := tc_rec.sex;
--                        l_ows_req_in.passport_number :=
--                                                       tc_rec.passport_number;
--                        l_ows_req_in.batch_id := l_batch_id;
--                        l_ows_req_in.city :=
--                           rmi_ows_common_util.get_city_name
--                                                 (tc_rec.city_of_residence_id);
--                        l_ows_req_in.city_id := tc_rec.city_of_residence_id;
--                        l_ows_req_in.nationality :=
--                                              tc_rec.citizenship_country_code;
--                        l_ows_req_in.passport_issuing_country_code :=
--                                         tc_rec.passport_issuing_country_code;
--                        l_ows_req_in.residence_country_code :=
--                                                  tc_rec.country_of_residence;
--                        rmi_ows_common_util.create_ows_generic
--                                                              (l_ows_req_in,
--                                                               p_custom_id1,
--                                                               p_custom_id2,
--                                                               p_return_code,
--                                                               p_ret_msg,
--                                                               l_ows_id
--                                                              );
--                        --
--                        rmi_ows_common_util.create_tc_document_references
--                                                               (l_ows_id,
--                                                                x.esi_id,
--                                                                p_return_code,
--                                                                p_ret_msg
--                                                               );
--                     ELSE
--                        --
--                        fnd_file.put_line
--                                   (fnd_file.LOG,
--                                    'Revetting recently done, skip revetting'
--                                   );
--                     END IF;
--                  --
--                  END LOOP;

            --                  IF l_new_vetting = 'Y' AND l_prev_batch_id IS NOT NULL
--                  THEN
--                     write_log ('Close Batch' || l_prev_batch_id);

            --                     FOR rec IN (SELECT ID, case_id
--                                   FROM xwrl_requests
--                                  WHERE batch_id = l_prev_batch_id)
--                     LOOP
--                        rmi_ows_common_util.close_ows_case
--                                                  (p_user_name       => l_username,
--                                                   p_case_id         => rec.case_id,
--                                                   p_request_id      => rec.ID
--                                                  );
--                        DBMS_OUTPUT.put_line ('Case ID ' || rec.case_id);
--                     END LOOP;

            --                     --
--                     UPDATE xwrl_requests
--                        SET case_state = 'D',
--                            case_status = 'C',
--                            last_update_date = SYSDATE,
--                            last_updated_by = l_user_id,
--                            last_update_login = l_login_id
--                      WHERE 1 = 1 AND batch_id = l_prev_batch_id;

            --                     DBMS_OUTPUT.put_line (   'Batch Updated '
--                                           || l_batch_id
--                                           || ' '
--                                           || SQL%ROWCOUNT
--                                          );
--                     COMMIT;
--                  END IF;
--               --
--               END IF;
            --
--            ELSE
--               write_log ('Seafarer does not exist in party master');
--               --tc_status := world_check_iface.get_wc_status (p_xref, p_req);
--               tc_status := 'NO_RECORD';

            --               --write_log ('Seafarer Status' || tc_status);
--               IF tc_status = 'NO_RECORD'
--               THEN
--                  -- Create Party Master
--                  l_party_rec := NULL;
--                  l_party_rec.wc_screening_request_id := NULL;
--                  l_party_rec.relationship_type := 'Primary';
--                  l_party_rec.entity_type := 'INDIVIDUAL';
--                  l_party_rec.state := 'Verified';
--                  l_party_rec.status := 'Enabled';
--                  l_party_rec.source_table := 'SICD_SEAFARERS';
--                  l_party_rec.source_table_column := 'SEAFARER_ID';
--                  l_party_rec.source_id := x.seafarer_id;
--                  l_party_rec.xref_source_table := NULL;
--                  l_party_rec.xref_source_table_column := NULL;
--                  l_party_rec.xref_source_id := NULL;
--                  l_party_rec.full_name := x.first_name || ' ' || x.last_name;
--                  l_party_rec.family_name := x.last_name;
--                  l_party_rec.given_name := x.first_name;
--                  l_party_rec.date_of_birth :=
--                                           TO_CHAR (x.birth_date, 'YYYYMMDD');
--                  l_party_rec.sex := UPPER (x.gender);
--                  l_party_rec.imo_number := NULL;
--                  l_party_rec.department := NULL;
--                  l_party_rec.office := NULL;
--                  l_party_rec.priority := NULL;
--                  l_party_rec.risk_level := NULL;
--                  l_party_rec.document_type := NULL;
--                  l_party_rec.closed_date := NULL;
--                  l_party_rec.assigned_to := NULL;
--                  l_party_rec.vessel_indicator := NULL;
--                  l_party_rec.passport_number := NULL;
--                  l_party_rec.passport_issuing_country_code :=
--                                              x.passport_issuing_country_code;
--                  l_party_rec.citizenship_country_code := x.nationality;
--                  l_party_rec.country_of_residence :=
--                                                     x.residence_country_code;
--                  l_party_rec.city_of_residence_id := x.wc_city_list_id;
--                  l_party_rec.note := NULL;
--                  l_party_rec.start_date := SYSDATE;
--                  l_party_rec.end_date := NULL;
--                  l_party_rec.last_update_date := SYSDATE;
--                  l_party_rec.last_updated_by := l_user_id;
--                  l_party_rec.creation_date := SYSDATE;
--                  l_party_rec.created_by := l_user_id;
--                  l_party_rec.last_update_login := l_login_id;
--                  l_party_rec.source_target_column := NULL;

            --                  INSERT INTO xwrl_party_master
--                       VALUES l_party_rec;

            --                  COMMIT;
--                  -- create new vetting
--                  l_batch_id := xwrl_batch_seq.NEXTVAL;
--                  l_new_vetting := 'Y';
--                  l_ows_req_in.entity_type := 'INDIVIDUAL';
--                  l_ows_req_in.source_table := 'SICD_SEAFARERS';
--                  l_ows_req_in.source_table_column := 'SEAFARER_ID';
--                  l_ows_req_in.source_id := x.seafarer_id;
--                  l_ows_req_in.full_name :=
--                                           x.first_name || ' ' || x.last_name;
--                  l_ows_req_in.first_name := x.first_name;
--                  l_ows_req_in.last_name := x.last_name;
--                  l_ows_req_in.date_of_birth := x.birth_date;
--                  l_ows_req_in.gender := x.gender;
----               l_ows_req_in.passport_number := x.passport_number;
--                  l_ows_req_in.batch_id := l_batch_id;
--                  l_ows_req_in.city :=
--                        rmi_ows_common_util.get_city_name (x.wc_city_list_id);
--                  l_ows_req_in.city_id := x.wc_city_list_id;
--                  l_ows_req_in.nationality := x.nationality;
--                  l_ows_req_in.passport_issuing_country_code :=
--                                              x.passport_issuing_country_code;
--                  l_ows_req_in.residence_country_code :=
--                                                     x.residence_country_code;
--                  rmi_ows_common_util.create_ows_generic (l_ows_req_in,
--                                                          p_custom_id1,
--                                                          p_custom_id2,
--                                                          p_return_code,
--                                                          p_ret_msg,
--                                                          l_ows_id
--                                                         );
--                  rmi_ows_common_util.create_tc_document_references
--                                                               (l_ows_id,
--                                                                x.esi_id,
--                                                                p_return_code,
--                                                                p_ret_msg
--                                                               );
--            END IF;

            --END IF;
            --write_log ('OWS id' || l_ows_id);
            --l_ows_req := rmi_ows_common_util.get_case_details (l_ows_id);
            IF     world_check_iface.get_sanction_status (x.nationality) =
                                                                        'NONE'
               AND world_check_iface.get_sanction_status
                                              (x.passport_issuing_country_code) =
                                                                        'NONE'
               AND world_check_iface.get_sanction_status
                                                     (x.residence_country_code) =
                                                                        'NONE'
            THEN
               provisional_approval := TRUE;
            ELSIF    world_check_iface.get_sanction_status (x.nationality) =
                                                                  'PROHIBITED'
                  OR world_check_iface.get_sanction_status
                                              (x.passport_issuing_country_code) =
                                                                  'PROHIBITED'
                  OR world_check_iface.get_sanction_status
                                                     (x.residence_country_code) =
                                                                  'PROHIBITED'
            THEN
               provisional_approval := FALSE;
            ELSIF    world_check_iface.get_sanction_status (x.nationality) =
                                                                 'CONDITIONAL'
                  OR world_check_iface.get_sanction_status
                                              (x.passport_issuing_country_code) =
                                                                 'CONDITIONAL'
                  OR world_check_iface.get_sanction_status
                                                     (x.residence_country_code) =
                                                                 'CONDITIONAL'
            THEN
               IF    world_check_iface.is_city_required (x.nationality)
                  OR world_check_iface.is_city_required
                                              (x.passport_issuing_country_code)
                  OR world_check_iface.is_city_required
                                                     (x.residence_country_code)
               THEN
                  IF x.wc_city_list_id IS NULL
                  THEN
                     provisional_approval := FALSE;
                  ELSIF world_check_iface.get_city_tc_status
                                                            (x.wc_city_list_id) IN
                                                  ('TC_OK', 'TC_PROVISIONAL')
                  THEN                       /* check ciity sanction status */
                     provisional_approval := TRUE;
                  ELSE
                     provisional_approval := FALSE;
                  END IF;
               END IF;
            END IF;

            IF provisional_approval = TRUE
            THEN               /* lets check sanction status for each match */
               IF rmi_ows_common_util.is_request_sanctioned (l_ows_id) = 'Y'
               THEN
                  provisional_approval := FALSE;
               END IF;
            END IF;

--            p_xref.wc_screening_request_id := l_ows_id;
--            p_xref.source_table := 'SICD_SEAFARERS';
--            p_xref.source_table_column := 'SEAFARER_ID';
--            p_xref.source_table_id := x.seafarer_id;
            --write_log ('tc_status ' || l_ows_req.case_workflow);
            tc_status :=
                     --rmi_ows_common_util.case_wf_status (l_ows_req.case_workflow);
               --world_check_iface.get_wc_status (p_xref, p_req);
               rmi_ows_common_util.get_wc_status ('SICD_SEAFARERS',
                                                  'SEAFARER_ID',
                                                  x.seafarer_id,
                                                     x.first_name
                                                  || ' '
                                                  || x.last_name
                                                 );
            write_log ('tc_status ' || tc_status);

            IF    tc_status = 'Pending'
               OR (tc_status = 'Approved' AND NVL (l_new_vetting, 'N') = 'Y')
               -- SAURABH T20200217.0019 11-MAR-2020
               OR (tc_status = 'Legal Review' AND NVL (l_new_vetting, 'N') = 'Y')
            THEN

               IF provisional_approval OR tc_status = 'Approved'
               THEN
                  pending_status := 'Provisional';
               -- SAURABH T20200217.0019 11-MAR-2020
               ELSIF tc_status = 'Legal Review' THEN
                  pending_status := 'Processor Review';
               ELSE
                  pending_status := 'Pending Provisional';
               END IF;

               write_log ('pending_status ' || pending_status);
               v_sql :=
                  'UPDATE XWRL.XWRL_REQUESTS
SET    CASE_WORKFLOW = NVL(:1,CASE_WORKFLOW),
       LAST_UPDATED_BY = :2,
       LAST_UPDATE_DATE= :3
WHERE  BATCH_ID = :4 ';
               write_log ('v_sql ' || v_sql);

               BEGIN
                  EXECUTE IMMEDIATE v_sql
                              USING
                                    rmi_ows_common_util.case_wf_status_dsp
                                                               (pending_status),
                                    NVL
                                       (l_user_id,
                                        world_check_iface.c_automatic_approval_uid
                                       ),
                                    SYSDATE,
                                    x_batch_id;

                  write_log ('Req Status Updated ' || l_batch_id);
                  --- Below code modified by Gopi Vella To make sure that the remaining records are processed
                  --- Even one record fails.
                  COMMIT;                               -- Added By Gopi Vella
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     write_log ('Exception ' || SQLERRM);
                     --return_code := -1; --- Modified By Gopi Vella
                     ret_msg := 'Create provisional TC error: ' || SQLERRM;
                     ROLLBACK;
               --RETURN; --- Modified By Gopi Vella
               END;
            --COMMIT;

            --End Code Change
            END IF;
         END LOOP;
      END IF;
   END;

   PROCEDURE resend_book_cra (
      errbuf           OUT      VARCHAR2,
      retcode          OUT      NUMBER,
      c_esi_batch_id   IN       VARCHAR2
   )
   IS
      return_code                 NUMBER                             := 0;
      ret_msg                     VARCHAR2 (500)                     := NULL;
      p_document_id               NUMBER                             := NULL;
      v_button                    NUMBER;
      no_parameters               EXCEPTION;
      x_res                       BOOLEAN;
      v_request_id                NUMBER;
      v_request_name              VARCHAR2 (100);
      v_document_id               VARCHAR2 (100);
      loop_counter                NUMBER;
      file_name                   VARCHAR2 (255);
      file_type                   VARCHAR2 (30);
      phase_code                  VARCHAR2 (1);
      status_code                 VARCHAR2 (1);
      counter                     NUMBER                             := 0;
      total_count                 NUMBER                             := 0;
      pct_comp                    NUMBER                             := 0;
      x_result                    VARCHAR2 (500);
      return_message              VARCHAR2 (5000);
      p_output_filename           VARCHAR2 (200);
      v_comm_id                   NUMBER;
      v_ie_header_id              NUMBER;
      user_id                     NUMBER;
      sender_email_address        VARCHAR2 (200);
      destination_email_address   VARCHAR2 (200);
      dest_cc                     VARCHAR2 (200)
                                               := 'mtimmons@register-iri.com';
      email_message               VARCHAR2 (4000);
      email_re                    VARCHAR2 (200);
      letter_template_id          NUMBER                             := NULL;
      letter_id                   NUMBER;
      x_res                       BOOLEAN;
      resp_appl_id                NUMBER;
      responsibility_id           NUMBER;
      attachments                 sendmailjpkg.attachments_list
                                          := sendmailjpkg.attachments_list
                                                                          ();
      dest_file_name              VARCHAR2 (400)                     := NULL;
      doc_list                    pdf_meld_utils_pkg.cc_request_list;
      seafarers_list              VARCHAR2 (4000)                    := NULL;

      CURSOR get_batch_count (x_esi_batch_id IN NUMBER)
      IS
         SELECT COUNT (*)
           FROM exsicd_batch_iface b,
                exsicd_seafarers_iface s,
                exsicd_seafarer_docs_iface doc
          WHERE b.esi_batch_id = x_esi_batch_id
            AND s.esi_batch_id = b.esi_batch_id
            AND doc.esi_id(+) = s.esi_id
            AND (doc.grade_type = 'SQC' OR s.issue_type != 'Current');

      batch_count                 NUMBER                             := 0;

      CURSOR get_batch (x_esi_batch_id IN NUMBER)
      IS
         SELECT b.*
           FROM exsicd_batch_iface b,
                exsicd_seafarers_iface s,
                exsicd_seafarer_docs_iface doc
          WHERE b.esi_batch_id = x_esi_batch_id
            AND s.esi_batch_id = b.esi_batch_id
            AND doc.esi_id(+) = s.esi_id
            AND (doc.grade_type = 'SQC' OR s.issue_type != 'Current');

      exsicd_batch                get_batch%ROWTYPE;

      CURSOR get_pending_acknowledgements (p_esi_batch_id IN NUMBER)
      IS
         SELECT *
           FROM exsicd_seafarers_iface
          WHERE esi_batch_id = p_esi_batch_id
            AND world_check_iface.get_seafarer_wc_status (seafarer_id) IN
                              ('Pending', 'Pending Provisional', 'NO_RECORD');

      CURSOR get_approved_acknowledgements (p_esi_batch_id IN NUMBER)
      IS
         SELECT COUNT (*)
           FROM exsicd_seafarers_iface
          WHERE esi_batch_id = p_esi_batch_id
            AND world_check_iface.get_seafarer_wc_status (seafarer_id) IN
                                                  ('Provisional', 'Approved');

      nof_approved                NUMBER                             := 0;

      CURSOR get_conc_request_info (rqst_id IN NUMBER)
      IS
         SELECT phase_code, status_code, file_name, file_type
           FROM fnd_conc_req_outputs_v
          WHERE request_id = rqst_id;

      CURSOR get_print_style
      IS
         SELECT output_print_style
           FROM fnd_concurrent_programs_vl
          WHERE concurrent_program_name = 'SICD151B_PDF';

      def_print_style             VARCHAR2 (100);
      p_esi_batch_id              NUMBER;
      first_loop                  VARCHAR2 (1)                       := 'Y';
   BEGIN
      p_esi_batch_id := TO_NUMBER (c_esi_batch_id);
      retcode := 0;
      errbuf := 'Everything is OK.';
      resp_appl_id := TO_NUMBER (fnd_profile.VALUE ('RESP_APPL_ID'));
      responsibility_id := TO_NUMBER (fnd_profile.VALUE ('RESP_ID'));
      user_id := fnd_profile.VALUE ('USER_ID');

      IF user_id IS NULL
      THEN
         user_id := 2805;
      END IF;

      IF responsibility_id IS NULL
      THEN
         responsibility_id := 50779;
      END IF;

      IF resp_appl_id IS NULL
      THEN
         resp_appl_id := 20030;
      END IF;

      mo_global.init ('ONT');
      mo_global.set_policy_context ('S', 122);
      fnd_global.apps_initialize (user_id, responsibility_id, resp_appl_id);
      DBMS_APPLICATION_INFO.set_client_info (122);

      OPEN get_batch_count (p_esi_batch_id);

      FETCH get_batch_count
       INTO batch_count;

      CLOSE get_batch_count;

      /* find out if they are ordering other documents besides a officers certificate if they are then send acknowledgement otherwise do not*/
      fnd_file.put_line (fnd_file.LOG,
                            'Number of seafarers requiring a book '
                         || TO_CHAR (batch_count)
                        );

      IF return_code != 0
      THEN
         fnd_file.put_line (fnd_file.LOG,
                            'Error Creating Provisional TC  ' || ret_msg
                           );
         retcode := 1;
         errbuf := 'Check Error Log';
         RETURN;
      END IF;

      OPEN get_approved_acknowledgements (p_esi_batch_id);

      FETCH get_approved_acknowledgements
       INTO nof_approved;

      CLOSE get_approved_acknowledgements;

      fnd_file.put_line (fnd_file.LOG,
                            'Number of Approved Acknowledgements: '
                         || TO_CHAR (nof_approved)
                        );

      IF batch_count > 0 AND nof_approved > 0
      THEN
         OPEN get_batch (p_esi_batch_id);

         FETCH get_batch
          INTO exsicd_batch;

         CLOSE get_batch;

         OPEN get_print_style;

         FETCH get_print_style
          INTO def_print_style;

         CLOSE get_print_style;

         fnd_file.put_line (fnd_file.LOG, 'Running');
         /*  x_res :=
              fnd_request.set_print_options (fnd_profile.VALUE ('PRINTER'),
                                             def_print_style,
                                             0);*/
         fnd_file.put_line (fnd_file.LOG, 'Submitting MI-273OR Report');
         v_request_id :=
            fnd_request.submit_request
                          ('EXSICD'                           --app short name
                                   ,
                           'EXSICD_BOOK_CRA'              --program short name
                                            ,
                           'MI-273OR Book Application Acknowledgement (PDF)'
                                                                            --description
            ,
                           NULL                                   --start time
                               ,
                           FALSE                                 --sub request
                                ,
                           p_esi_batch_id,
                           'Y',          -- SAURABH 11-JUN-2019 T20190710.0040
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           ''
                          );
         COMMIT;
         fnd_file.put_line (fnd_file.LOG,
                            'request_id = ' || TO_CHAR (v_request_id)
                           );

         OPEN get_conc_request_info (v_request_id);

         FETCH get_conc_request_info
          INTO phase_code, status_code, file_name, file_type;

         CLOSE get_conc_request_info;

         WHILE phase_code <> 'C'
         LOOP
            /* loop while the report is running it will time out after 45 seconds */
            OPEN get_conc_request_info (v_request_id);

            FETCH get_conc_request_info
             INTO phase_code, status_code, file_name, file_type;

            CLOSE get_conc_request_info;

            IF loop_counter > 15
            THEN
               retcode := 1;
               errbuf := 'Check Error Log';
               fnd_file.put_line (fnd_file.LOG, 'The request timed out');
               fnd_file.put_line (fnd_file.LOG, 'End of process');
               RETURN;
            END IF;

            DBMS_LOCK.sleep (3);
         END LOOP;

         fnd_file.put_line (fnd_file.LOG,
                               ' phase_code = '
                            || phase_code
                            || ' status_code = '
                            || status_code
                           );

         IF phase_code = 'C' AND status_code = 'C'
         THEN
            /* it ran now lock the pdf and email it. */
            doc_list (1).request_id := v_request_id;
            dest_file_name :=
                        'ACK' || TO_CHAR (SYSDATE, 'RRMMDDhh24miss')
                        || '.pdf';
            fnd_file.put_line (fnd_file.LOG, 'Running PDFMELD');
            pdf_meld_utils_pkg.meld_concurrent_request (doc_list,
                                                        dest_file_name,
                                                        return_code,
                                                        return_message,
                                                        p_output_filename
                                                       );

            IF return_code <> 0
            THEN
               fnd_file.put_line
                             (fnd_file.LOG,
                                 'PDFMELD returned an error.  Return Code = '
                              || TO_CHAR (return_code)
                              || ' '
                              || return_message
                             );
               retcode := 1;
               errbuf := 'Check Error Log';
               fnd_file.put_line (fnd_file.LOG, 'End of process');
               RETURN;
            ELSE
               fnd_file.put_line (fnd_file.LOG, 'PDFMELD ran successfully');
               email_re := 'Acknowledgement of Application';
               email_message :=
                     'Please see attached acknowledgement of application.  Acknowledgement should be kept in the applicant'
                  || CHR (39)
                  || 's possession aboard the'
                  || CHR (10)
                  || 'vessel until full term documents are received.';
               first_loop := 'Y';

               FOR x IN get_pending_acknowledgements (p_esi_batch_id)
               LOOP
                  IF first_loop = 'Y'
                  THEN
                     email_message :=
                           email_message
                        || CHR (10)
                        || CHR (10)
                        || 'The Republic of the Marshall Islands Maritime Administrator ("Administrator") is unable to acknowledge receipt of application for the following seafarers at this time.   The Administrator will revert directly..';
                     first_loop := 'N';
                  END IF;

                  email_message :=
                             email_message || CHR (10) || CHR (10)
                             || 'Name(s):';
                  email_message :=
                        email_message
                     || CHR (10)
                     || x.first_name
                     || ' '
                     || x.last_name;
               END LOOP;

               fnd_file.put_line (fnd_file.LOG,
                                  'Preparing to email document.');
               sender_email_address :=
                  exsicd_profiles_pkg.get_user_profile
                                                   (exsicd_batch.created_by,
                                                    'CRA Sender Email Address'
                                                   );
               destination_email_address :=
                  NVL
                     (exsicd_profiles_pkg.get_user_profile
                                                (exsicd_batch.created_by,
                                                 'CRA Recipient Email Address'
                                                ),
                      'seafarers@register-iri.com'
                     );
               dest_cc := NULL;
               dest_cc :=
                  exsicd_profiles_pkg.get_user_profile
                                                     (exsicd_batch.created_by,
                                                      'CC on Correspondence'
                                                     );
               attachments.EXTEND;
               attachments.EXTEND (2);
               fnd_file.put_line (fnd_file.LOG, 'Sending email parameters:');
               fnd_file.put_line (fnd_file.LOG,
                                     'SMTP Mailer '
                                  || iri_html.get_url ('SMTP_MAILER')
                                 );
               fnd_file.put_line (fnd_file.LOG,
                                  'Sender ' || sender_email_address
                                 );
               fnd_file.put_line (fnd_file.LOG,
                                  'Recipient ' || destination_email_address
                                 );
               fnd_file.put_line (fnd_file.LOG, 'Message: ' || email_message);
               x_result :=
                  sendmailjpkg.sendmail
                     (smtpservername      => iri_html.get_url ('SMTP_MAILER'),
                      sender              => sender_email_address,
                      recipient           => destination_email_address,
                      ccrecipient         => dest_cc,
                      subject             => email_re,
                      errormessage        => return_message,
                      BODY                => email_message,
                      attachments         => sendmailjpkg.attachments_list
                                                            (p_output_filename)
                     );
               fnd_file.put_line (fnd_file.LOG, 'Sending Email');

               IF return_message IS NULL
               THEN
                  return_message := 'None';
               END IF;

               fnd_file.put_line (fnd_file.LOG,
                                  'Error Message ' || return_message
                                 );
               COMMIT;
            END IF;
         ELSIF phase_code = 'C' AND status_code = 'E'
         THEN                         /* it ran but the request errored out */
            retcode := 1;
            errbuf := 'Check Error Log';
            fnd_file.put_line (fnd_file.LOG, 'The request timed out');
            /* do some error logging */
            fnd_file.put_line (fnd_file.LOG, 'End of process');
            RETURN;
         END IF;
-- SAURABH  T20170825.0016 17-AUG-2018
--else
      ELSIF batch_count > 0
      THEN
         -- Cannot send acknowledge receipt of application but a Book or SQC is there
                /* no acknowledgements to sent */
         OPEN get_batch (p_esi_batch_id);

         FETCH get_batch
          INTO exsicd_batch;

         CLOSE get_batch;

         fnd_file.put_line (fnd_file.LOG,
                            'No acknowledgments to send for this order.'
                           );
         first_loop := 'Y';

         FOR x IN get_pending_acknowledgements (p_esi_batch_id)
         LOOP
            IF first_loop = 'Y'
            THEN
               email_message :=
                     email_message
                  || CHR (10)
                  || CHR (10)
                  || 'The Republic of the Marshall Islands Maritime Administrator ("Administrator") is unable to acknowledge receipt of application for the following seafarers at this time..   The Administrator will revert directly.';
               first_loop := 'N';
            END IF;

            email_message := email_message || CHR (10) || CHR (10)
                             || 'Name(s):';
            email_message :=
                email_message || CHR (10) || x.first_name || ' '
                || x.last_name;
         END LOOP;

         fnd_file.put_line (fnd_file.LOG, 'Preparing to email document.');
         fnd_file.put_line (fnd_file.LOG,
                            'Created By ' || TO_CHAR (exsicd_batch.created_by)
                           );
         email_re := 'Acknowledgement of Application';
         sender_email_address :=
            exsicd_profiles_pkg.get_user_profile (exsicd_batch.created_by,
                                                  'CRA Sender Email Address'
                                                 );
         destination_email_address :=
            NVL
               (exsicd_profiles_pkg.get_user_profile
                                                (exsicd_batch.created_by,
                                                 'CRA Recipient Email Address'
                                                ),
                'seafarers@register-iri.com'
               );
         dest_cc := NULL;
         dest_cc :=
            exsicd_profiles_pkg.get_user_profile (exsicd_batch.created_by,
                                                  'CC on Correspondence'
                                                 );
         attachments.EXTEND;
         attachments.EXTEND (2);
         fnd_file.put_line (fnd_file.LOG, 'Sending email parameters:');
         fnd_file.put_line (fnd_file.LOG,
                            'SMTP Mailer ' || iri_html.get_url ('SMTP_MAILER')
                           );
         fnd_file.put_line (fnd_file.LOG, 'Sender ' || sender_email_address);
         fnd_file.put_line (fnd_file.LOG,
                            'Recipient ' || destination_email_address
                           );
         fnd_file.put_line (fnd_file.LOG, 'Subject: ' || email_re);
         fnd_file.put_line (fnd_file.LOG, 'Message: ' || email_message);

         IF email_message IS NULL
         THEN
            fnd_file.put_line (fnd_file.LOG, 'There is no message to send ');
         ELSE
            x_result :=
               sendmailjpkg.sendmail
                          (smtpservername      => iri_html.get_url
                                                                ('SMTP_MAILER'),
                           sender              => sender_email_address,
                           recipient           => destination_email_address,
                           ccrecipient         => dest_cc,
                           subject             => email_re,
                           errormessage        => return_message,
                           BODY                => email_message
                          );
            fnd_file.put_line (fnd_file.LOG, 'Sending Email');
         END IF;
      END IF;

      fnd_file.put_line (fnd_file.LOG, 'End of process');
   END;

   FUNCTION get_seaf_order_type (p_esi_id IN NUMBER)
      RETURN VARCHAR2
   IS
/*BOOK,
BOOK-SQC
BOOK-SQC-OC
SQC-OC
BOOK-OC
OC
SQC      */
      CURSOR get_book
      IS
         SELECT COUNT (*)
           FROM exsicd_seafarers_iface s
          WHERE s.esi_id = p_esi_id AND s.issue_type != 'Current';

      book_count   NUMBER        := 0;

      CURSOR get_sqc
      IS
         SELECT COUNT (*)
           FROM exsicd_seafarer_docs_iface doc
          WHERE doc.esi_id = p_esi_id AND doc.grade_type = 'SQC';

      sqc_count    NUMBER        := 0;

      CURSOR get_oc
      IS
         SELECT COUNT (*)
           FROM exsicd_seafarer_docs_iface doc
          WHERE doc.esi_id = p_esi_id AND doc.grade_type = 'OC';

      oc_count     NUMBER;
      ret_str      VARCHAR2 (30) := NULL;
      delimiter    VARCHAR2 (1)  := NULL;
   BEGIN
      OPEN get_book;

      FETCH get_book
       INTO book_count;

      CLOSE get_book;

      IF book_count > 0
      THEN
         ret_str := 'BOOK';
         delimiter := '-';
      END IF;

      OPEN get_sqc;

      FETCH get_sqc
       INTO sqc_count;

      CLOSE get_sqc;

      IF sqc_count > 0
      THEN
         ret_str := ret_str || delimiter || 'SQC';
         delimiter := '-';
      END IF;

      OPEN get_oc;

      FETCH get_oc
       INTO oc_count;

      CLOSE get_oc;

      IF oc_count > 0
      THEN
         ret_str := ret_str || delimiter || 'OC';
      END IF;

      RETURN ret_str;
   END;
END iri_sicd_online;
/


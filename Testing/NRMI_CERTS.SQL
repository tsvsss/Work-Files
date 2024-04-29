CREATE OR REPLACE package body APPS.NRMI_CERTS as
/* Formatted on 3/27/2015 3:05:31 PM (QP5 v5.163.1008.3004) */
PROCEDURE create_trade_compliance (
   p_nrmi_certificates_id   IN       NUMBER,
   p_return_code            OUT      VARCHAR2,
   p_return_message         OUT      VARCHAR2
)
IS
   /* p_return_code  =
   SUCCESS,
   ERROR_CREATING_WC
   CERTIFICATE_NOT_FOUND
   SQLERROR

   */
   CURSOR get_cert
   IS
      SELECT *
        FROM nrmi_certificates
       WHERE nrmi_certificates_id = p_nrmi_certificates_id;

   cert_rec                    get_cert%ROWTYPE;

   CURSOR get_vessel
   IS
      SELECT *
        FROM nrmi_vessels
       WHERE nrmi_certificates_id = p_nrmi_certificates_id;

   CURSOR get_known_parties
   IS
      SELECT *
        FROM nrmi_known_parties
       WHERE nrmi_certificates_id = p_nrmi_certificates_id;

   xref                        world_check_iface.wc_external_xref_rec;
   ows_xref                    rmi_ows_common_util.wc_external_xref_rec;
   req                         world_check_iface.wc_screening_request_rec;
   ows_req                     rmi_ows_common_util.ows_request_rec;
   return_code                 NUMBER;
   return_message              VARCHAR2 (250);

   CURSOR get_base_tc_req (
      p_source_table          IN   VARCHAR2,
      p_source_table_column   IN   VARCHAR2,
      p_source_table_id       IN   NUMBER,
      p_name_screened         IN   VARCHAR2
   )
   IS
      SELECT req.*
        FROM vssl.worldcheck_external_xref xref,
             vssl.wc_screening_request req
       WHERE xref.source_table = p_source_table
         AND xref.source_table_column = p_source_table_column
         AND xref.source_table_id = p_source_table_id
         AND xref.wc_screening_request_id = req.wc_screening_request_id
         AND req.name_screened = p_name_screened;

   base_req                    get_base_tc_req%ROWTYPE;

   CURSOR get_request_info (p_wc_screening_request_id IN NUMBER)
   IS
      SELECT *
        FROM wc_screening_request
       WHERE wc_screening_request_id = p_wc_screening_request_id;

   CURSOR get_ows_info (p_id IN NUMBER)
   IS
      SELECT *
        FROM xwrl_requests
       WHERE ID = p_id;

   CURSOR get_edoc_data (p_edoc_id IN NUMBER)
   IS
      SELECT *
        FROM iri_edocs
       WHERE ID = p_edoc_id;

   l_edoc_rec                  get_edoc_data%ROWTYPE;
   scrrqst                     get_request_info%ROWTYPE;
   user_id                     NUMBER;
   login_id                    NUMBER;

   CURSOR get_wc_matches (p_wc_screening_request_id IN NUMBER)
   IS
      SELECT *
        FROM wc_matches
       WHERE wc_screening_request_id = p_wc_screening_request_id;

   scrrqst_ows                 get_ows_info%ROWTYPE;
   mtch                        get_wc_matches%ROWTYPE;
   p_wc_screening_request_id   NUMBER;
   l_xwrl_requests             xwrl_requests%ROWTYPE;
   x_id                        NUMBER;
   x_batch_id                  NUMBER;
   l_screening_tab             rmi_ows_common_util.screening_tab;
   l_vessel_rec                nrmi_vessels%ROWTYPE;
   l_id                        NUMBER;
   l_req_rec                   xwrl_requests%ROWTYPE;
   l_batch_id                  NUMBER;
BEGIN
   p_return_message := 'Normal';
   p_return_code := c_success;
   user_id := get_userid;
   login_id := get_loginid;

   OPEN get_cert;

   FETCH get_cert
    INTO cert_rec;

   CLOSE get_cert;

   IF (cert_rec.nrmi_certificates_id IS NULL)
   THEN
      p_return_code := 'CERTIFICATE_NOT_FOUND';
      p_return_message := 'Certificate order not found';
      RETURN;
   END IF;

   FOR vrec IN get_vessel
   LOOP
      DBMS_OUTPUT.put_line ('TC Vessels' || vrec.nrmi_vessels_id);
      x_id := NULL;

      /* vessel name */
      IF (vrec.nrmi_certificates_id IS NULL)
      THEN
         p_return_code := 'VESSEL_NOT_FOUND';
         p_return_message := 'Vessel not found on order';
         RETURN;
      END IF;
   END LOOP;

   IF rmi_ows_common_util.is_ows_user = 'N'
   THEN
      req.wc_screening_request_id := NULL;
      req.status := 'Pending';
      req.name_screened := cert_rec.rq_name;
      req.date_of_birth := NULL;
      req.sex := NULL;
      req.name_identifier := NULL;
      req.passport_number := NULL;
      req.entity_type := world_check_iface.c_corporation;
      req.passport_issuing_country_code := NULL;
      req.corp_residence_country_code := NULL;
      req.residence_country_code := NULL;
      req.citizenship_country_code := NULL;
      req.notify_user_upon_approval := 'N';
      xref.source_table := 'NRMI_CERTIFICATES';
      xref.source_table_column := 'NRMI_CERTIFICATES_ID';
      xref.source_table_id := cert_rec.nrmi_certificates_id;
      xref.source_table_status_column := NULL;
      xref.worldcheck_external_xref_id := NULL;
      xref.wc_screening_request_id := req.wc_screening_request_id;

      IF world_check_iface.does_wc_exist (xref, req) = FALSE
      THEN
         world_check_iface.initiate_wc_screening
                                     (xref,
                                      req,
                                      'NRMI_CERTIFICATES_ID',
                                      TO_CHAR (cert_rec.nrmi_certificates_id),
                                      return_code,
                                      p_return_message
                                     );

         ----dbms_output.put_line ( 'initiate_wc_screening ' ||to_char(return_code) || p_ret_msg);
         IF return_code = 200
         THEN
            OPEN get_request_info (req.wc_screening_request_id);

            FETCH get_request_info
             INTO scrrqst;

            CLOSE get_request_info;

            xref.source_table := 'NRMI_CERTIFICATES_rq';
            xref.source_table_column := 'NRMI_CERTIFICATES_ID';
            xref.source_table_id := cert_rec.nrmi_certificates_id;
            xref.worldcheck_external_xref_id := NULL;
            world_check_iface.create_new_xref (xref,
                                               return_code,
                                               p_return_message
                                              );
            world_check_iface.process_name_matches
                                                 (scrrqst.name_identifier,
                                                  req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );

            --dbms_output.put_line ( 'process_name_matches ' ||to_char(return_code) || p_ret_msg);
            IF return_code = 200
            THEN
               --dbms_output.put_line ('1');
               OPEN get_wc_matches (req.wc_screening_request_id);

               --dbms_output.put_line ('2');
               FETCH get_wc_matches
                INTO mtch;

               --dbms_output.put_line ('3');
               CLOSE get_wc_matches;

               --dbms_output.put_line ('#'||to_char(mtch.NUMBER_OF_MATCHES));
               IF mtch.number_of_matches > 0
               THEN
                  --dbms_output.put_line ('4');
                  FOR x IN get_wc_matches (req.wc_screening_request_id)
                  LOOP
                     world_check_iface.populate_match_details
                                                         (x.wc_matches_id,
                                                          mtch.wc_matches_id,
                                                          return_code,
                                                          p_return_message
                                                         );
                  END LOOP;

                  world_check_iface.update_wc_match_status
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );

                  --dbms_output.put_line ( 'populate_match_details ' ||to_char(return_code) || p_ret_msg);
                  /* double check to see if any matches still exist if not then approve the world check request */
                  --open get_WC_MATCHES(req.WC_SCREENING_REQUEST_ID);
                  --fetch get_WC_MATCHES into mtch;
                  --close get_WC_MATCHES;
                  IF mtch.number_of_matches = 0
                  THEN
                     --dbms_output.put_line ( 'push_status_to_creator -1' );
                     req.status := 'Approved';
                     world_check_iface.approve_screening_request
                                                (req.wc_screening_request_id,
                                                 return_code,
                                                 p_return_message
                                                );
                     world_check_iface.push_status_to_creator
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );
                  --dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
                  END IF;
               ELSE
                  --dbms_output.put_line ('5');
                  req.status := 'Approved';
                  world_check_iface.approve_screening_request
                                                (req.wc_screening_request_id,
                                                 return_code,
                                                 p_return_message
                                                );
                  --dbms_output.put_line ('6');
                  world_check_iface.push_status_to_creator
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );
               --dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
               END IF;
            END IF;
         ELSE
            p_return_code := 'ERROR_CREATING_WC';
         END IF;

         IF req.status != 'Approved'
         THEN
            set_tc_to_legal_review (req.wc_screening_request_id,
                                    p_return_code,
                                    p_return_message
                                   );
         END IF;
      END IF;

      --dbms_output.put_line ( 'end');

      --dbms_output.put_line ( 'requestor name complete' ||to_char(return_code) || p_return_message);
      IF cert_rec.bt_customer_name IS NOT NULL
      THEN
         req.wc_screening_request_id := NULL;
         req.status := 'Pending';
         req.name_screened := cert_rec.bt_customer_name;
         req.date_of_birth := NULL;
         req.sex := NULL;
         req.name_identifier := NULL;
         req.passport_number := NULL;
         req.entity_type := world_check_iface.c_corporation;
         req.passport_issuing_country_code := NULL;
         req.corp_residence_country_code := NULL;
         req.residence_country_code := NULL;
         req.citizenship_country_code := NULL;
         req.notify_user_upon_approval := 'N';
         xref.source_table := 'NRMI_CERTIFICATES';
         xref.source_table_column := 'NRMI_CERTIFICATES_ID';
         xref.source_table_id := cert_rec.nrmi_certificates_id;
         xref.source_table_status_column := NULL;
         xref.worldcheck_external_xref_id := NULL;
         xref.wc_screening_request_id := req.wc_screening_request_id;

         IF world_check_iface.does_wc_exist (xref, req) = FALSE
         THEN
            world_check_iface.initiate_wc_screening
                                     (xref,
                                      req,
                                      'NRMI_CERTIFICATES_ID',
                                      TO_CHAR (cert_rec.nrmi_certificates_id),
                                      return_code,
                                      p_return_message
                                     );

            --dbms_output.put_line ( 'initiate_wc_screening ' ||to_char(return_code) || p_ret_msg);
            IF return_code = 200
            THEN
               OPEN get_request_info (req.wc_screening_request_id);

               FETCH get_request_info
                INTO scrrqst;

               CLOSE get_request_info;

               xref.source_table := 'NRMI_CERTIFICATES_bt';
               xref.source_table_column := 'NRMI_CERTIFICATES_ID';
               xref.source_table_id := cert_rec.nrmi_certificates_id;
               xref.worldcheck_external_xref_id := NULL;
               world_check_iface.create_new_xref (xref,
                                                  return_code,
                                                  p_return_message
                                                 );
               world_check_iface.process_name_matches
                                                 (scrrqst.name_identifier,
                                                  req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );

               --dbms_output.put_line ( 'process_name_matches ' ||to_char(return_code) || p_ret_msg);
               IF return_code = 200
               THEN
                  --dbms_output.put_line ('1');
                  OPEN get_wc_matches (req.wc_screening_request_id);

                  --dbms_output.put_line ('2');
                  FETCH get_wc_matches
                   INTO mtch;

                  --dbms_output.put_line ('3');
                  CLOSE get_wc_matches;

                  --raise_application_error(-20000,'xxxx'); /* delete this line */
                  --dbms_output.put_line ('#'||to_char(mtch.NUMBER_OF_MATCHES));
                  IF mtch.number_of_matches > 0
                  THEN
                     --dbms_output.put_line ('4');
                     FOR x IN get_wc_matches (req.wc_screening_request_id)
                     LOOP
                        world_check_iface.populate_match_details
                                                         (x.wc_matches_id,
                                                          mtch.wc_matches_id,
                                                          return_code,
                                                          p_return_message
                                                         );
                     END LOOP;

                     world_check_iface.update_wc_match_status
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );

                     --dbms_output.put_line ( 'populate_match_details ' ||to_char(return_code) || p_ret_msg);
                     /* double check to see if any matches still exist if not then approve the world check request */
                     --open get_WC_MATCHES(req.WC_SCREENING_REQUEST_ID);
                     --fetch get_WC_MATCHES into mtch;
                     --close get_WC_MATCHES;
                     IF mtch.number_of_matches = 0
                     THEN
                        --dbms_output.put_line ( 'push_status_to_creator -1' );
                        req.status := 'Approved';
                        world_check_iface.approve_screening_request
                                                (req.wc_screening_request_id,
                                                 return_code,
                                                 p_return_message
                                                );
                        world_check_iface.push_status_to_creator
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );
                     --dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
                     END IF;
                  ELSE
                     --dbms_output.put_line ('5');
                     req.status := 'Approved';
                     world_check_iface.approve_screening_request
                                                (req.wc_screening_request_id,
                                                 return_code,
                                                 p_return_message
                                                );
                     --dbms_output.put_line ('6');
                     world_check_iface.push_status_to_creator
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );
                  --dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
                  END IF;
               END IF;
            ELSE
               p_return_code := 'ERROR_CREATING_WC';
            END IF;
         --dbms_output.put_line ( 'BT name complete ' ||to_char(return_code) || p_return_message);
         ELSE                                        /*  world check exists */
            OPEN get_base_tc_req (xref.source_table,
                                  xref.source_table_column,
                                  xref.source_table_id,
                                  cert_rec.bt_customer_name
                                 );

            FETCH get_base_tc_req
             INTO base_req;

            CLOSE get_base_tc_req;

            req.wc_screening_request_id := NULL;
            req.status := 'Pending';
            req.name_screened := cert_rec.bt_customer_name;
            req.date_of_birth := NULL;
            req.sex := NULL;
            req.name_identifier := NULL;
            req.passport_number := NULL;
            req.entity_type := world_check_iface.c_corporation;
            req.passport_issuing_country_code := NULL;
            req.corp_residence_country_code := NULL;
            req.residence_country_code := NULL;
            req.citizenship_country_code := NULL;
            req.notify_user_upon_approval := 'N';
            xref.worldcheck_external_xref_id := NULL;
            xref.source_table_status_column := NULL;
            xref.worldcheck_external_xref_id := NULL;
            xref.wc_screening_request_id := base_req.wc_screening_request_id;
            xref.source_table := 'NRMI_CERTIFICATES_bt';
            xref.source_table_column := 'NRMI_CERTIFICATES_ID';
            xref.source_table_id := cert_rec.nrmi_certificates_id;

            IF world_check_iface.does_wc_exist (xref, req) = FALSE
            THEN
/* now let's check to see if the second xref exists if it doesn't then created it */
               world_check_iface.create_new_xref (xref,
                                                  return_code,
                                                  p_return_message
                                                 );
            END IF;
         END IF;

         IF req.status != 'Approved'
         THEN
            set_tc_to_legal_review (req.wc_screening_request_id,
                                    p_return_code,
                                    p_return_message
                                   );
         END IF;
      END IF;

      FOR vrec IN get_vessel
      LOOP
         /* vessel name */
         IF (vrec.nrmi_certificates_id IS NULL)
         THEN
            p_return_code := 'VESSEL_NOT_FOUND';
            p_return_message := 'Vessel not found on order';
            RETURN;
         END IF;

         req.wc_screening_request_id := NULL;
         req.status := 'Pending';
         req.name_screened := vrec.vessel_name;
         req.date_of_birth := NULL;
         req.sex := NULL;
         req.name_identifier := NULL;
         req.passport_number := NULL;
         req.entity_type := world_check_iface.c_vessel;
         req.passport_issuing_country_code := NULL;
         req.corp_residence_country_code := NULL;
         req.residence_country_code := NULL;
         req.citizenship_country_code := NULL;
         req.notify_user_upon_approval := 'N';
         xref.source_table := 'NRMI_CERTIFICATES';
         xref.source_table_column := 'NRMI_CERTIFICATES_ID';
         xref.source_table_id := cert_rec.nrmi_certificates_id;
         xref.source_table_status_column := NULL;
         xref.worldcheck_external_xref_id := NULL;
         xref.wc_screening_request_id := req.wc_screening_request_id;

         IF world_check_iface.does_wc_exist (xref, req) = FALSE
         THEN
            world_check_iface.initiate_wc_screening
                                     (xref,
                                      req,
                                      'NRMI_CERTIFICATES_ID',
                                      TO_CHAR (cert_rec.nrmi_certificates_id),
                                      return_code,
                                      p_return_message
                                     );

            --dbms_output.put_line ( 'initiate_wc_screening ' ||to_char(return_code) || p_ret_msg);
            IF return_code = 200
            THEN
               OPEN get_request_info (req.wc_screening_request_id);

               FETCH get_request_info
                INTO scrrqst;

               CLOSE get_request_info;

               xref.source_table := 'NRMI_VESSELS_vssl';
               xref.source_table_column := 'NRMI_VESSELS_ID';
               xref.source_table_id := vrec.nrmi_vessels_id;
               xref.worldcheck_external_xref_id := NULL;
               world_check_iface.create_new_xref (xref,
                                                  return_code,
                                                  p_return_message
                                                 );
               --dbms_output.put_line ( 'create new xref vessel name:  ' ||vrec.VESSEL_NAME ||to_char(return_code) || p_return_message);
               world_check_iface.process_name_matches
                                                 (scrrqst.name_identifier,
                                                  req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );

               --dbms_output.put_line ( 'process_name_matches ' ||to_char(return_code) || p_ret_msg);
               IF return_code = 200
               THEN
                  --dbms_output.put_line ('1');
                  OPEN get_wc_matches (req.wc_screening_request_id);

                  --dbms_output.put_line ('2');
                  FETCH get_wc_matches
                   INTO mtch;

                  --dbms_output.put_line ('3');
                  CLOSE get_wc_matches;

                  --raise_application_error(-20000,'xxxx'); /* delete this line */
                  --dbms_output.put_line ('#'||to_char(mtch.NUMBER_OF_MATCHES));
                  IF mtch.number_of_matches > 0
                  THEN
                     --dbms_output.put_line ('4');
                     FOR x IN get_wc_matches (req.wc_screening_request_id)
                     LOOP
                        world_check_iface.populate_match_details
                                                         (x.wc_matches_id,
                                                          mtch.wc_matches_id,
                                                          return_code,
                                                          p_return_message
                                                         );
                     END LOOP;

                     IF vrec.cor_edoc_id IS NOT NULL
                     THEN
                        BEGIN
                           INSERT INTO vssl.wc_request_documents
                                       (created_by,
                                        creation_date,
                                        doc_description,
                                        edocs_id,
                                        last_update_date,
                                        last_update_login,
                                        last_updated_by,
                                        wc_request_documents_id,
                                        wc_screening_request_id
                                       )
                                VALUES (user_id               /* CREATED_BY */
                                               ,
                                        SYSDATE            /* CREATION_DATE */
                                               ,
                                           'COR - IMO Number '
                                        || TO_CHAR (vrec.vessel_imo_number)
                                                                           /* DOC_DESCRIPTION */
                           ,
                                        vrec.cor_edoc_id        /* EDOCS_ID */
                                                        ,
                                        SYSDATE         /* LAST_UPDATE_DATE */
                                               ,
                                        login_id       /* LAST_UPDATE_LOGIN */
                                                ,
                                        user_id          /* LAST_UPDATED_BY */
                                               ,
                                        NULL     /* WC_REQUEST_DOCUMENTS_ID */
                                            ,
                                        req.wc_screening_request_id
                                       /* WC_SCREENING_REQUEST_ID */
                                       );
                        EXCEPTION
                           WHEN DUP_VAL_ON_INDEX
                           THEN
                              NULL;
                           WHEN OTHERS
                           THEN
                              p_return_message :=
                                              'Inserting ID Doc: ' || SQLERRM;
                              ROLLBACK;
                              return_code := 'ERROR';
                              RETURN;
                        END;

                        COMMIT;
                     END IF;

                     IF vrec.blue_card_edoc_id IS NOT NULL
                     THEN
                        BEGIN
                           INSERT INTO vssl.wc_request_documents
                                       (created_by,
                                        creation_date,
                                        doc_description,
                                        edocs_id,
                                        last_update_date,
                                        last_update_login,
                                        last_updated_by,
                                        wc_request_documents_id,
                                        wc_screening_request_id
                                       )
                                VALUES (user_id               /* CREATED_BY */
                                               ,
                                        SYSDATE            /* CREATION_DATE */
                                               ,
                                           'BLUE CARD - IMO Number '
                                        || TO_CHAR (vrec.vessel_imo_number)
                                                                           /* DOC_DESCRIPTION */
                           ,
                                        vrec.blue_card_edoc_id  /* EDOCS_ID */
                                                              ,
                                        SYSDATE         /* LAST_UPDATE_DATE */
                                               ,
                                        login_id       /* LAST_UPDATE_LOGIN */
                                                ,
                                        user_id          /* LAST_UPDATED_BY */
                                               ,
                                        NULL     /* WC_REQUEST_DOCUMENTS_ID */
                                            ,
                                        req.wc_screening_request_id
                                       /* WC_SCREENING_REQUEST_ID */
                                       );
                        EXCEPTION
                           WHEN DUP_VAL_ON_INDEX
                           THEN
                              NULL;
                           WHEN OTHERS
                           THEN
                              p_return_message :=
                                              'Inserting ID Doc: ' || SQLERRM;
                              ROLLBACK;
                              return_code := 'ERROR';
                              RETURN;
                        END;

                        COMMIT;
                     END IF;

                     world_check_iface.update_wc_match_status
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );

                     --dbms_output.put_line ( 'populate_match_details ' ||to_char(return_code) || p_ret_msg);
                     /* double check to see if any matches still exist if not then approve the world check request */
                     --open get_WC_MATCHES(req.WC_SCREENING_REQUEST_ID);
                     --fetch get_WC_MATCHES into mtch;
                     --close get_WC_MATCHES;
                     IF mtch.number_of_matches = 0
                     THEN
                        --dbms_output.put_line ( 'push_status_to_creator -1' );
                        req.status := 'Approved';
                        world_check_iface.approve_screening_request
                                                (req.wc_screening_request_id,
                                                 return_code,
                                                 p_return_message
                                                );
                        world_check_iface.push_status_to_creator
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );
                     --dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
                     END IF;
                  ELSE
                     --dbms_output.put_line ('5');
                     req.status := 'Approved';
                     world_check_iface.approve_screening_request
                                                (req.wc_screening_request_id,
                                                 return_code,
                                                 p_return_message
                                                );
                     --dbms_output.put_line ('6');
                     world_check_iface.push_status_to_creator
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );
                  --dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
                  END IF;
               END IF;
            ELSE
               p_return_code := 'ERROR_CREATING_WC';
            END IF;

            IF req.status != 'Approved'
            THEN
               set_tc_to_legal_review (req.wc_screening_request_id,
                                       p_return_code,
                                       p_return_message
                                      );
               create_tc_document_references (req.wc_screening_request_id,
                                              vrec.application_edoc_id,
                                              vrec.cor_edoc_id,
                                              vrec.blue_card_edoc_id,
                                              p_return_code,
                                              p_return_message
                                             );
            END IF;
         --dbms_output.put_line ( 'vessel name:  ' ||vrec.VESSEL_NAME ||to_char(return_code) || p_return_message);
         ELSE               /* tc exists let's check for the the other Xref */
            OPEN get_base_tc_req (xref.source_table,
                                  xref.source_table_column,
                                  xref.source_table_id,
                                  vrec.vessel_name
                                 );

            FETCH get_base_tc_req
             INTO base_req;

            CLOSE get_base_tc_req;

            req.wc_screening_request_id := NULL;
            req.status := 'Pending';
            req.name_screened := vrec.vessel_name;
            req.date_of_birth := NULL;
            req.sex := NULL;
            req.name_identifier := NULL;
            req.passport_number := NULL;
            req.entity_type := world_check_iface.c_vessel;
            req.passport_issuing_country_code := NULL;
            req.corp_residence_country_code := NULL;
            req.residence_country_code := NULL;
            req.citizenship_country_code := NULL;
            req.notify_user_upon_approval := 'N';
            xref.source_table := 'NRMI_VESSELS_vssl';
            xref.source_table_column := 'NRMI_VESSELS_ID';
            xref.source_table_id := vrec.nrmi_vessels_id;
            xref.worldcheck_external_xref_id := NULL;
            xref.source_table_status_column := NULL;
            xref.worldcheck_external_xref_id := NULL;
            xref.wc_screening_request_id := base_req.wc_screening_request_id;

            IF world_check_iface.does_wc_exist (xref, req) = FALSE
            THEN
               world_check_iface.create_new_xref (xref,
                                                  return_code,
                                                  p_return_message
                                                 );
               DBMS_OUTPUT.put_line (   'vessel name:  '
                                     || vrec.vessel_name
                                     || ' Create xref'
                                     || TO_CHAR (return_code)
                                     || p_return_message
                                    );
            END IF;
         END IF;                                     /*end of create vessel */

         /* registered owner */
         IF vrec.registered_owner_name IS NOT NULL
         THEN
            req.wc_screening_request_id := NULL;
            req.status := 'Pending';
            req.name_screened := vrec.registered_owner_name;
            req.date_of_birth := NULL;
            req.sex := NULL;
            req.name_identifier := NULL;
            req.passport_number := NULL;
            req.entity_type := world_check_iface.c_corporation;
            req.passport_issuing_country_code := NULL;
            req.corp_residence_country_code := NULL;
            req.residence_country_code := NULL;
            req.citizenship_country_code := NULL;
            req.notify_user_upon_approval := 'N';
            xref.source_table := 'NRMI_CERTIFICATES';
            xref.source_table_column := 'NRMI_CERTIFICATES_ID';
            xref.source_table_id := cert_rec.nrmi_certificates_id;
            xref.source_table_status_column := NULL;
            xref.worldcheck_external_xref_id := NULL;
            xref.wc_screening_request_id := req.wc_screening_request_id;

            IF world_check_iface.does_wc_exist (xref, req) = FALSE
            THEN
               world_check_iface.initiate_wc_screening
                                     (xref,
                                      req,
                                      'NRMI_CERTIFICATES_ID',
                                      TO_CHAR (cert_rec.nrmi_certificates_id),
                                      return_code,
                                      p_return_message
                                     );

               --dbms_output.put_line ( 'initiate_wc_screening ' ||to_char(return_code) || p_return_message);
               IF return_code = 200
               THEN
                  OPEN get_request_info (req.wc_screening_request_id);

                  FETCH get_request_info
                   INTO scrrqst;

                  CLOSE get_request_info;

                  world_check_iface.process_name_matches
                                                (scrrqst.name_identifier,
                                                 req.wc_screening_request_id,
                                                 return_code,
                                                 p_return_message
                                                );

                  --dbms_output.put_line ( 'process_name_matches ' ||to_char(return_code) || p_return_message);
                  IF return_code = 200
                  THEN
                     --dbms_output.put_line ('1');
                     OPEN get_wc_matches (req.wc_screening_request_id);

                     --dbms_output.put_line ('2');
                     FETCH get_wc_matches
                      INTO mtch;

                     --dbms_output.put_line ('3');
                     CLOSE get_wc_matches;

                     --raise_application_error(-20000,'xxxx'); /* delete this line */
                     --dbms_output.put_line ('#'||to_char(mtch.NUMBER_OF_MATCHES));
                     IF mtch.number_of_matches > 0
                     THEN
                        --dbms_output.put_line ('4');
                        FOR x IN get_wc_matches (req.wc_screening_request_id)
                        LOOP
                           world_check_iface.populate_match_details
                                                         (x.wc_matches_id,
                                                          mtch.wc_matches_id,
                                                          return_code,
                                                          p_return_message
                                                         );
                        END LOOP;

                        xref.source_table := 'NRMI_VESSELS_reg_own';
                        xref.source_table_column := 'NRMI_VESSELS_ID';
                        xref.source_table_id := vrec.nrmi_vessels_id;
                        xref.worldcheck_external_xref_id := NULL;
                        world_check_iface.create_new_xref (xref,
                                                           return_code,
                                                           p_return_message
                                                          );
                        world_check_iface.update_wc_match_status
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );

                        --dbms_output.put_line ( 'populate_match_details ' ||to_char(return_code) || p_ret_msg);
                        /* double check to see if any matches still exist if not then approve the world check request */
                        --open get_WC_MATCHES(req.WC_SCREENING_REQUEST_ID);
                        --fetch get_WC_MATCHES into mtch;
                        --close get_WC_MATCHES;
                        IF mtch.number_of_matches = 0
                        THEN
                           --dbms_output.put_line ( 'push_status_to_creator -1' );
                           req.status := 'Approved';
                           world_check_iface.approve_screening_request
                                                (req.wc_screening_request_id,
                                                 return_code,
                                                 p_return_message
                                                );
                           world_check_iface.push_status_to_creator
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );
                        --dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
                        END IF;
                     ELSE
                        --dbms_output.put_line ('5');
                        req.status := 'Approved';
                        world_check_iface.approve_screening_request
                                                (req.wc_screening_request_id,
                                                 return_code,
                                                 p_return_message
                                                );
                        --dbms_output.put_line ('6');
                        world_check_iface.push_status_to_creator
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );
                     --dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
                     END IF;
                  END IF;
               ELSE
                  p_return_code := 'ERROR_CREATING_WC';
               END IF;
            ELSE                                     /*  world check exists */
               --dbms_output.put_line ( 'reg owner name exists, check if it exists as second ref.');
               OPEN get_base_tc_req (xref.source_table,
                                     xref.source_table_column,
                                     xref.source_table_id,
                                     req.name_screened
                                    );

               FETCH get_base_tc_req
                INTO base_req;

               CLOSE get_base_tc_req;

               xref.source_table := 'NRMI_VESSELS_reg_own';
               xref.source_table_column := 'NRMI_VESSELS_ID';
               xref.source_table_id := vrec.nrmi_vessels_id;
               xref.worldcheck_external_xref_id := NULL;

               IF world_check_iface.does_wc_exist (xref, req) = FALSE
               THEN
/* now let's check to see if the second xref exists if it doesn't then created it */
                  xref.wc_screening_request_id :=
                                             base_req.wc_screening_request_id;
                  --dbms_output.put_line ( 'the reference does not exist, so create one.');
                  world_check_iface.create_new_xref (xref,
                                                     return_code,
                                                     p_return_message
                                                    );
               END IF;
            --dbms_output.put_line ( 'end');
            END IF;

            --dbms_output.put_line ( 'RO Name:  ' ||vrec.REGISTERED_OWNER_NAME ||to_char(return_code) || p_return_message);
            IF req.status != 'Approved'
            THEN
               set_tc_to_legal_review (req.wc_screening_request_id,
                                       p_return_code,
                                       p_return_message
                                      );
               create_tc_document_references (req.wc_screening_request_id,
                                              vrec.application_edoc_id,
                                              vrec.cor_edoc_id,
                                              vrec.blue_card_edoc_id,
                                              p_return_code,
                                              p_return_message
                                             );
            END IF;
         END IF;
      END LOOP;

      --dbms_output.put_line ( 'KNOWN PARTIES' );
      FOR y IN get_known_parties
      LOOP
         req.wc_screening_request_id := NULL;
         req.status := 'Pending';
         req.name_screened := y.kp_name;
         req.date_of_birth := NULL;
         req.sex := NULL;
         req.name_identifier := NULL;
         req.passport_number := NULL;
         req.entity_type := world_check_iface.c_individual;
         req.passport_issuing_country_code := NULL;
         req.corp_residence_country_code := NULL;
         req.residence_country_code := NULL;
         req.citizenship_country_code := NULL;
         req.notify_user_upon_approval := 'N';
         xref.source_table := 'NRMI_CERTIFICATES';
         xref.source_table_column := 'NRMI_CERTIFICATES_ID';
         xref.source_table_id := cert_rec.nrmi_certificates_id;
         xref.source_table_status_column := NULL;
         xref.worldcheck_external_xref_id := NULL;
         xref.wc_screening_request_id := req.wc_screening_request_id;

         IF world_check_iface.does_wc_exist (xref, req) = FALSE
         THEN
            world_check_iface.initiate_wc_screening
                                     (xref,
                                      req,
                                      'NRMI_CERTIFICATES_ID',
                                      TO_CHAR (cert_rec.nrmi_certificates_id),
                                      return_code,
                                      p_return_message
                                     );

            --dbms_output.put_line ( 'initiate_wc_screening ' ||to_char(return_code) || p_ret_msg);
            IF return_code = 200
            THEN
               OPEN get_request_info (req.wc_screening_request_id);

               FETCH get_request_info
                INTO scrrqst;

               CLOSE get_request_info;

               xref.source_table := 'NRMI_VESSELS_KNOWN_PARTY';
               xref.source_table_column := 'NRMI_KP_ID';
               xref.source_table_id := y.nrmi_kp_id;
               xref.worldcheck_external_xref_id := NULL;
               world_check_iface.create_new_xref (xref,
                                                  return_code,
                                                  p_return_message
                                                 );
               world_check_iface.process_name_matches
                                                 (scrrqst.name_identifier,
                                                  req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );

               --dbms_output.put_line ( 'process_name_matches ' ||to_char(return_code) || p_ret_msg);
               IF return_code = 200
               THEN
                  --dbms_output.put_line ('1');
                  OPEN get_wc_matches (req.wc_screening_request_id);

                  --dbms_output.put_line ('2');
                  FETCH get_wc_matches
                   INTO mtch;

                  --dbms_output.put_line ('3');
                  CLOSE get_wc_matches;

                  --raise_application_error(-20000,'xxxx'); /* delete this line */
                  --dbms_output.put_line ('#'||to_char(mtch.NUMBER_OF_MATCHES));
                  IF mtch.number_of_matches > 0
                  THEN
                     --dbms_output.put_line ('4');
                     FOR x IN get_wc_matches (req.wc_screening_request_id)
                     LOOP
                        world_check_iface.populate_match_details
                                                         (x.wc_matches_id,
                                                          mtch.wc_matches_id,
                                                          return_code,
                                                          p_return_message
                                                         );
                     END LOOP;

                     world_check_iface.update_wc_match_status
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );

                     --dbms_output.put_line ( 'populate_match_details ' ||to_char(return_code) || p_ret_msg);
                     /* double check to see if any matches still exist if not then approve the world check request */
                     --open get_WC_MATCHES(req.WC_SCREENING_REQUEST_ID);
                     --fetch get_WC_MATCHES into mtch;
                     --close get_WC_MATCHES;
                     IF mtch.number_of_matches = 0
                     THEN
                        --dbms_output.put_line ( 'push_status_to_creator -1' );
                        req.status := 'Approved';
                        world_check_iface.approve_screening_request
                                                (req.wc_screening_request_id,
                                                 return_code,
                                                 p_return_message
                                                );
                        world_check_iface.push_status_to_creator
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );
                     --dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
                     END IF;
                  ELSE
                     --dbms_output.put_line ('5');
                     req.status := 'Approved';
                     world_check_iface.approve_screening_request
                                                (req.wc_screening_request_id,
                                                 return_code,
                                                 p_return_message
                                                );
                     --dbms_output.put_line ('6');
                     world_check_iface.push_status_to_creator
                                                 (req.wc_screening_request_id,
                                                  return_code,
                                                  p_return_message
                                                 );
                  --dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
                  END IF;
               END IF;
            ELSE
               p_return_code := 'ERROR_CREATING_WC';
            END IF;

            --dbms_output.put_line ( 'end');
            IF req.status != 'Approved'
            THEN
               set_tc_to_legal_review (req.wc_screening_request_id,
                                       p_return_code,
                                       p_return_message
                                      );
            END IF;
         END IF;
      END LOOP;
   --dbms_output.put_line ( 'Know Parties Comp.' ||to_char(return_code) || p_return_message);
   ELSIF rmi_ows_common_util.is_ows_user = 'Y'
   THEN
      DBMS_OUTPUT.put_line ('OWS Start');
      --
      ows_xref.source_table := 'NRMI_CERTIFICATES';
      ows_xref.source_table_column := 'NRMI_CERTIFICATES_ID';
      ows_xref.source_table_id := cert_rec.nrmi_certificates_id;

      IF rmi_ows_common_util.master_exists (ows_xref.source_table,
                                            ows_xref.source_table_column,
                                            ows_xref.source_table_id
                                           ) = 'N'
      THEN
         rmi_ows_common_util.insert_party_master
                                               (ows_xref.source_table,
                                                ows_xref.source_table_column,
                                                ows_xref.source_table_id,
                                                x_id
                                               );
      END IF;

--      l_batch_id :=
--         rmi_ows_common_util.get_batch_id (ows_xref.source_table,
   --                                        ows_xref.source_table_id
   --                                       );

      -- check if open case available or not
      IF l_batch_id IS NULL
      THEN
         -- NO open case
         -- create new case
         rmi_ows_common_util.create_batch_vetting
                      (p_source_table             => ows_xref.source_table,
                       p_source_table_column      => ows_xref.source_table_column,
                       p_source_id                => ows_xref.source_table_id,
                       x_batch_id                 => x_batch_id,
                       x_return_status            => p_return_code,
                       x_return_msg               => p_return_message
                      );
         l_batch_id := x_batch_id;
      END IF;

      FOR l_xwrl_requests IN (SELECT case_workflow, ID, expiration_date
                                FROM xwrl_requests
                               WHERE batch_id = l_batch_id)
      LOOP
         IF l_xwrl_requests.case_workflow != 'A'
            OR
            (l_xwrl_requests.case_workflow = 'A' AND l_xwrl_requests.expiration_date < SYSDATE) 
         THEN
            rmi_ows_common_util.update_request_status
               (p_id                  => l_xwrl_requests.ID,
                p_status_code         => rmi_ows_common_util.case_wf_status_dsp
                                                               ('Legal Review'),
                p_return_code         => p_return_code,
                p_return_message      => p_return_message
               );
            DBMS_OUTPUT.put_line ('After Update status ');
         END IF;
      END LOOP;

      IF l_batch_id IS NOT NULL
      THEN
         rmi_ows_common_util.query_cross_reference
                            (p_source_table       => ows_xref.source_table,
                             p_source_column      => ows_xref.source_table_column,
                             p_source_id          => ows_xref.source_table_id,
                             t_data               => l_screening_tab
                            );

         --
         FOR i IN 1 .. l_screening_tab.COUNT
         LOOP
            --
            IF l_screening_tab (i).entity_type = 'VESSEL'
            THEN
               BEGIN
                  SELECT *
                    INTO l_vessel_rec
                    FROM nrmi_vessels
                   WHERE nrmi_certificates_id = ows_xref.source_table_id
                     AND vessel_name = l_screening_tab (i).full_name;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_vessel_rec := NULL;
               END;

               BEGIN
                  SELECT MAX (ID)
                    INTO l_id
                    FROM xwrl_requests
                   WHERE batch_id = l_batch_id
                     AND name_screened = l_screening_tab (i).full_name;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_id := NULL;
               END;

               IF l_id IS NOT NULL
               THEN
                  --l_req_rec := rmi_ows_common_util.get_case_details (l_id);
                  
                  SELECT id,case_id INTO l_req_rec.id,l_req_rec.case_id
                  FROM xwrl_requests req
                  WHERE req.ID = l_id;

                  IF l_vessel_rec.application_edoc_id IS NOT NULL
                  THEN
                     OPEN get_edoc_data (l_vessel_rec.application_edoc_id);

                     FETCH get_edoc_data
                      INTO l_edoc_rec;

                     CLOSE get_edoc_data;

                     BEGIN
                        INSERT INTO xwrl.xwrl_case_documents
                                    (ID,
                                     request_id, case_id,
                                     edoc_id, document_file,
                                     document_name, document_category,
                                     document_type, file_name,
                                     file_path, content_type, image_file,
                                     image_name, image_path, url_path,
                                     last_update_date, last_updated_by,
                                     creation_date, created_by,
                                     last_update_login
                                    )
                             VALUES (xwrl_case_documents_seq.NEXTVAL,
                                     l_req_rec.ID, l_req_rec.case_id,
                                     l_vessel_rec.application_edoc_id, '',
                                     '', '',                   -- Doc Category
                                     'MI-237nrmi', l_edoc_rec.file_name,
                                     l_edoc_rec.disk_path, NULL, NULL,
                                     NULL, NULL,                 -- image path
                                                l_edoc_rec.url,
                                     SYSDATE, user_id,
                                     SYSDATE, user_id,
                                     login_id
                                    );
                     EXCEPTION
                        WHEN DUP_VAL_ON_INDEX
                        THEN
                           NULL;
                        WHEN OTHERS
                        THEN
                           p_return_message :=
                                              'Inserting ID Doc: ' || SQLERRM;
                           ROLLBACK;
                           return_code := 'ERROR';
                           RETURN;
                     END;

                     COMMIT;
                  END IF;

                  DBMS_OUTPUT.put_line ('insert 2' || x_id);

                  IF l_vessel_rec.cor_edoc_id IS NOT NULL
                  THEN
                     BEGIN
                        OPEN get_edoc_data (l_vessel_rec.cor_edoc_id);

                        FETCH get_edoc_data
                         INTO l_edoc_rec;

                        CLOSE get_edoc_data;

                        INSERT INTO xwrl.xwrl_case_documents
                                    (ID,
                                     request_id, case_id,
                                     edoc_id, document_file, document_name,
                                     document_category,
                                     document_type,
                                     file_name,
                                     file_path, content_type, image_file,
                                     image_name, image_path, url_path,
                                     last_update_date, last_updated_by,
                                     creation_date, created_by,
                                     last_update_login
                                    )
                             VALUES (xwrl_case_documents_seq.NEXTVAL,
                                     l_req_rec.ID, l_req_rec.case_id,
                                     l_vessel_rec.cor_edoc_id, '', '',
                                     '',                       -- Doc Category
                                        'COR - IMO Number '
                                     || TO_CHAR
                                               (l_vessel_rec.vessel_imo_number),
                                     l_edoc_rec.file_name,
                                     l_edoc_rec.disk_path, NULL, NULL,
                                     NULL, NULL,                 -- image path
                                                l_edoc_rec.url,
                                     SYSDATE, user_id,
                                     SYSDATE, user_id,
                                     login_id
                                    );
                     EXCEPTION
                        WHEN DUP_VAL_ON_INDEX
                        THEN
                           NULL;
                        WHEN OTHERS
                        THEN
                           p_return_message :=
                                              'Inserting ID Doc: ' || SQLERRM;
                           ROLLBACK;
                           return_code := 'ERROR';
                           RETURN;
                     END;

                     COMMIT;
                  END IF;

                  DBMS_OUTPUT.put_line ('insert 3' || x_id);

                  IF l_vessel_rec.blue_card_edoc_id IS NOT NULL
                  THEN
                     OPEN get_edoc_data (l_vessel_rec.blue_card_edoc_id);

                     FETCH get_edoc_data
                      INTO l_edoc_rec;

                     CLOSE get_edoc_data;

                     BEGIN
                        INSERT INTO xwrl.xwrl_case_documents
                                    (ID,
                                     request_id, case_id,
                                     edoc_id, document_file, document_name,
                                     document_category,
                                     document_type,
                                     file_name,
                                     file_path, content_type, image_file,
                                     image_name, image_path, url_path,
                                     last_update_date, last_updated_by,
                                     creation_date, created_by,
                                     last_update_login
                                    )
                             VALUES (xwrl_case_documents_seq.NEXTVAL,
                                     l_req_rec.ID, l_req_rec.case_id,
                                     l_vessel_rec.blue_card_edoc_id, '', '',
                                     '',                       -- Doc Category
                                        'BLUE CARD - IMO Number '
                                     || TO_CHAR
                                               (l_vessel_rec.vessel_imo_number),
                                     l_edoc_rec.file_name,
                                     l_edoc_rec.disk_path, NULL, NULL,
                                     NULL, NULL,                 -- image path
                                                l_edoc_rec.url,
                                     SYSDATE, user_id,
                                     SYSDATE, user_id,
                                     login_id
                                    );
                     EXCEPTION
                        WHEN DUP_VAL_ON_INDEX
                        THEN
                           NULL;
                        WHEN OTHERS
                        THEN
                           p_return_message :=
                                              'Inserting ID Doc: ' || SQLERRM;
                           ROLLBACK;
                           return_code := 'ERROR';
                           RETURN;
                     END;

                     COMMIT;
                  END IF;

                  create_tc_document_references
                                            (l_req_rec.ID,
                                             l_vessel_rec.application_edoc_id,
                                             l_vessel_rec.cor_edoc_id,
                                             l_vessel_rec.blue_card_edoc_id,
                                             p_return_code,
                                             p_return_message
                                            );
               END IF;
            END IF;
         END LOOP;
      END IF;
   END IF;

   BEGIN
      UPDATE nrmi_certificates
         SET status = 'Pending T.C.',
             last_update_date = SYSDATE,
             last_updated_by = get_userid
       WHERE nrmi_certificates_id = p_nrmi_certificates_id;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_return_code := 'SQLERROR';
         p_return_message := SQLERRM;
   END;

   IF p_return_code = '0'
   THEN
      p_return_code := 'SUCCESS';
   END IF;

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      p_return_code := 'SQLERROR';
      p_return_message := SQLERRM;

      IF get_cert%ISOPEN
      THEN
         CLOSE get_cert;
      END IF;

      IF get_request_info%ISOPEN
      THEN
         CLOSE get_request_info;
      END IF;

      IF get_wc_matches%ISOPEN
      THEN
         CLOSE get_wc_matches;
      END IF;
END;

PROCEDURE create_customer (
   p_nrmi_certificates_id   IN       NUMBER,
   update_recs              IN       VARCHAR2 DEFAULT 'N',
   p_customer_id            OUT      NUMBER,
   p_bill_to_site_id        OUT      NUMBER,
   p_ship_to_site_id        OUT      NUMBER,
   p_return_code            OUT      VARCHAR2,
   p_return_message         OUT      VARCHAR2
)
IS
   p_organization_name   VARCHAR2 (32767)                         := NULL;
   p_party_id_force      VARCHAR2 (32767);
   p_attribute8          VARCHAR2 (32767)                         := NULL;
   p_return_status       VARCHAR2 (32767);
   p_msg_count           NUMBER;
   p_msg_data            VARCHAR2 (32767);
   p_party_id            NUMBER                                   := NULL;
   p_party_number        VARCHAR2 (32767)                         := NULL;
   p_profile_id          NUMBER;
   p_account_name        VARCHAR2 (32767);
   p_cust_account_id     NUMBER                                   := NULL;
   p_account_number      VARCHAR2 (32767);
   p_location_id         NUMBER;
   p_address1            VARCHAR2 (32767);
   p_address2            VARCHAR2 (32767);
   p_address3            VARCHAR2 (32767);
   p_address4            VARCHAR2 (32767);
   p_city                VARCHAR2 (32767);
   p_postal_code         VARCHAR2 (32767);
   p_state               VARCHAR2 (32767);
   p_province            VARCHAR2 (32767);
   p_county              VARCHAR2 (32767);
   p_country             VARCHAR2 (32767);
   p_party_site_id       NUMBER;
   p_party_site_number   VARCHAR2 (32767);
   p_cust_acct_site_id   NUMBER;
   p_site_use_code       VARCHAR2 (32767);
   p_site_use_id         NUMBER;

   CURSOR get_cert
   IS
      SELECT *
        FROM nrmi_certificates
       WHERE nrmi_certificates_id = p_nrmi_certificates_id;

   cert_rec              get_cert%ROWTYPE;
   xref                  rmi_ows_common_util.wc_external_xref_rec;
   req                   rmi_ows_common_util.ows_request_rec;
   return_code           NUMBER;
   return_message        VARCHAR2 (250);

--cursor get_base_tc_req(P_SOURCE_TABLE in varchar2,p_SOURCE_TABLE_COLUMN in varchar2, p_SOURCE_TABLE_ID in number, p_NAME_SCREENED in varchar2)  is
--select req.* from VSSL.WORLDCHECK_EXTERNAL_XREF xref, VSSL.WC_SCREENING_REQUEST req where
--xref.SOURCE_TABLE=P_SOURCE_TABLE  and
--xref.SOURCE_TABLE_COLUMN=p_SOURCE_TABLE_COLUMN   and
--xref.SOURCE_TABLE_ID= p_SOURCE_TABLE_ID and
--xref.WC_SCREENING_REQUEST_ID = req.WC_SCREENING_REQUEST_ID
--and req.NAME_SCREENED = p_NAME_SCREENED;
   CURSOR get_base_tc_req (
      p_source_table          IN   VARCHAR2,
      p_source_table_column   IN   VARCHAR2,
      p_source_table_id       IN   NUMBER,
      p_name_screened         IN   VARCHAR2
   )
   IS
      SELECT   *
          FROM xwrl_requests req
         WHERE 1 = 1
           AND source_table = p_source_table
--           AND req.source_table_column = p_source_table_column
           AND req.source_id = p_source_table_id
           AND xwrl_utils.cleanse_name(req.name_screened) = xwrl_utils.cleanse_name(p_name_screened)
           --AND case_status = 'O'
           AND case_status NOT IN ('D','E')
      ORDER BY creation_date DESC;

--      SELECT req.*
--        FROM vssl.worldcheck_external_xref xref, xwrl_requests req
--       WHERE xref.source_table = p_source_table
--         AND xref.source_table_column = p_source_table_column
--         AND xref.source_table_id = p_source_table_id
--         AND xref.wc_screening_request_id = req.ID
--         AND req.name_screened = p_name_screened;
   base_req              get_base_tc_req%ROWTYPE;

--base_req_ows get_base_ows_req%rowtype;

   --cursor get_base_tc_req2(p_SOURCE_TABLE_COLUMN in varchar2, p_SOURCE_TABLE_ID in number, p_NAME_SCREENED in varchar2)  is
--select req.* from VSSL.WORLDCHECK_EXTERNAL_XREF xref, VSSL.WC_SCREENING_REQUEST req where
--xref.SOURCE_TABLE_COLUMN=p_SOURCE_TABLE_COLUMN   and
--xref.SOURCE_TABLE_ID= p_SOURCE_TABLE_ID and
--xref.WC_SCREENING_REQUEST_ID = req.WC_SCREENING_REQUEST_ID
--and req.NAME_SCREENED = p_NAME_SCREENED;
   CURSOR get_base_tc_req2 (
      p_source_table_column   IN   VARCHAR2,
      p_source_table_id       IN   NUMBER,
      p_name_screened         IN   VARCHAR2
   )
   IS
      SELECT   req.*
          FROM xwrl_requests req
         WHERE 1=1--req.source_table_column = p_source_table_column
           AND req.source_id = p_source_table_id
           AND xwrl_utils.cleanse_name(req.name_screened) = xwrl_utils.cleanse_name(p_name_screened)
           AND case_status NOT IN ('D','E')
      ORDER BY creation_date DESC;

   base_req2             get_base_tc_req%ROWTYPE;

   CURSOR get_organization (p_org_name IN VARCHAR2)
   IS
      SELECT party_id
        FROM hz_parties
       WHERE party_name = p_org_name
         AND party_type = 'ORGANIZATION'
         AND status = 'A';
                  --- Added By Gopi Vella on 25-FEB-2019 FOR HD T20190222.0022

   CURSOR get_account (p_party_id IN NUMBER)
   IS
      SELECT cust_account_id
        FROM hz_cust_accounts ca
       WHERE ca.party_id = p_party_id AND ca.account_name = 'NRMI';

   x_id                  NUMBER;
BEGIN
   IF DEBUG_MODE
   THEN
      DBMS_OUTPUT.put_line ('Create Customer Start');
   ELSE
      fnd_file.put_line (fnd_file.LOG, 'Create Customer Start');
   END IF;

   BEGIN
      OPEN get_cert;

      FETCH get_cert
       INTO cert_rec;

      CLOSE get_cert;

      IF cert_rec.bt_customer_name IS NOT NULL
      THEN
         p_organization_name := cert_rec.bt_customer_name;
         --xref.source_table := 'NRMI_CERTIFICATES_bt';
         xref.source_table := 'NRMI_CERTIFICATES';
      ELSE
         p_organization_name := cert_rec.rq_name;
         xref.source_table := 'NRMI_CERTIFICATES';
      END IF;

      req.name_screened := p_organization_name;
      xref.source_table_column := 'NRMI_CERTIFICATES_ID';
      xref.source_table_id := cert_rec.nrmi_certificates_id;

/* get tc record so we can attach it to the customer record after it is created */
      OPEN get_base_tc_req (xref.source_table,
                            xref.source_table_column,
                            xref.source_table_id,
                            req.name_screened
                           );

      FETCH get_base_tc_req
       INTO base_req;

      CLOSE get_base_tc_req;

      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line (   xref.source_table
                               || ' '
                               || xref.source_table_column
                               || ' '
                               || TO_CHAR (xref.source_table_id)
                               || ' '
                               || req.name_screened
                               || ' '
                               || NVL (TO_CHAR (base_req.ID),
                                       'No WC_SCREENING_REQUEST_ID'
                                      )
                              );
      ELSE
         fnd_file.put_line (fnd_file.LOG,
                               xref.source_table
                            || ' '
                            || xref.source_table_column
                            || ' '
                            || TO_CHAR (xref.source_table_id)
                            || ' '
                            || req.name_screened
                            || ' '
                            || NVL (TO_CHAR (base_req.ID),
                                    'No WC_SCREENING_REQUEST_ID'
                                   )
                           );
      END IF;

      IF base_req.ID IS NULL
      THEN
         OPEN get_base_tc_req2 (xref.source_table_column,
                                xref.source_table_id,
                                req.name_screened
                               );

         FETCH get_base_tc_req2
          INTO base_req2;

         CLOSE get_base_tc_req2;

         IF base_req2.ID IS NULL
         THEN
            raise_application_error
                  (-20001,
                   'Trade Compliance Record does not exist for this customer'
                  );
         END IF;
      END IF;

      p_party_id_force := NULL;
      p_attribute8 := 'MASTER AND OWNER';
      p_return_status := NULL;
      p_msg_count := NULL;
      p_msg_data := NULL;
      p_party_id := NULL;
      p_party_number := NULL;
      p_profile_id := NULL;

      OPEN get_organization (p_organization_name);

      FETCH get_organization
       INTO p_party_id;

      CLOSE get_organization;

      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line (   p_organization_name
                               || ' P_PARTY_ID: '
                               || TO_CHAR (p_party_id)
                              );
      ELSE
         fnd_file.put_line (fnd_file.LOG,
                               p_organization_name
                            || ' P_PARTY_ID: '
                            || TO_CHAR (p_party_id)
                           );
      END IF;



      IF p_party_id IS NULL
      THEN
         iri_tca.create_organization (p_organization_name,
                                      p_party_id_force,
                                      p_attribute8,
                                      p_return_status,
                                      p_msg_count,
                                      p_msg_data,
                                      p_party_id,
                                      p_party_number,
                                      p_profile_id
                                     );

         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line (   'Create Organization: '
                                  || p_organization_name
                                  || ' P_PARTY_ID: '
                                  || TO_CHAR (p_party_id)
                                 );
         ELSE
            fnd_file.put_line (fnd_file.LOG,
                                  'Create Organization: '
                               || p_organization_name
                               || ' P_PARTY_ID: '
                               || TO_CHAR (p_party_id)
                              );
         END IF;

         IF p_return_status <> 'S'
         THEN
            p_return_code := c_error;
            p_return_message := 'Create Organization';
            raise_application_error (-20000,
                                     'Create Customer Failed: ' || p_msg_data
                                    );
         END IF;
      END IF;



      p_account_name := NULL;
      p_cust_account_id := NULL;
      p_account_number := NULL;

      OPEN get_account (p_party_id);

      FETCH get_account
       INTO p_cust_account_id;

      CLOSE get_account;

      IF p_cust_account_id IS NULL
      THEN
         p_account_name := 'NRMI';
         iri_tca.create_cust_account (p_party_id,
                                      p_account_name,
                                      p_cust_account_id,
                                      p_account_number,
                                      p_return_status,
                                      p_msg_count,
                                      p_msg_data
                                     );

         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line (   'Create Accoount: '
                                  || p_account_name
                                  || ' P_CUST_ACCOUNT_ID: '
                                  || TO_CHAR (p_cust_account_id)
                                  || ' P_ACCOUNT_NUMBER '
                                  || p_account_number
                                 );
         ELSE
            fnd_file.put_line (fnd_file.LOG,
                                  'Create Accoount: '
                               || p_account_name
                               || ' P_CUST_ACCOUNT_ID: '
                               || TO_CHAR (p_cust_account_id)
                               || ' P_ACCOUNT_NUMBER '
                               || p_account_number
                              );
         END IF;


         IF p_return_status <> 'S'
         THEN
            p_return_code := c_error;
            p_return_message := 'Create Customer Account';
            raise_application_error (-20000,
                                     'Create Customer Failed: ' || p_msg_data
                                    );
         END IF;



      --dbms_output.put_line(' P_ACCOUNT_NUMBER = '||P_ACCOUNT_NUMBER||'  '||P_RETURN_STATUS||' '||P_MSG_DATA);
      END IF;

      p_customer_id := p_cust_account_id;

      IF cert_rec.bt_customer_name IS NOT NULL
      THEN
         p_location_id := NULL;
         p_address1 := cert_rec.bt_address1;
         p_address2 := cert_rec.bt_address2;
         p_address3 := cert_rec.bt_address3;
         p_address4 := NULL;
         p_city := cert_rec.bt_city;
         p_postal_code := cert_rec.bt_postal_code;
         p_state := cert_rec.bt_province;
         p_province := NULL;
         p_county := NULL;
         p_country := cert_rec.bt_country;
      ELSE
         p_location_id := NULL;
         p_address1 := cert_rec.rq_address1;
         p_address2 := cert_rec.rq_address2;
         p_address3 := cert_rec.rq_address3;
         p_address4 := NULL;
         p_city := cert_rec.rq_city;
         p_postal_code := cert_rec.rq_postal_code;
         p_state := cert_rec.rq_province;
         p_province := NULL;
         p_county := NULL;
         p_country := cert_rec.rq_country;
      END IF;

      iri_tca.create_location (p_location_id,
                               p_address1,
                               p_address2,
                               p_address3,
                               p_address4,
                               p_city,
                               p_postal_code,
                               p_state,
                               p_province,
                               p_county,
                               p_country,
                               p_return_status,
                               p_msg_count,
                               p_msg_data
                              );

      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line (   'Create Location: '
                               || p_account_name
                               || ' P_LOCATION_ID: '
                               || TO_CHAR (p_location_id)
                              );
      ELSE
         fnd_file.put_line (fnd_file.LOG,
                               'Create Location: '
                            || p_account_name
                            || ' P_LOCATION_ID: '
                            || TO_CHAR (p_location_id)
                           );
      END IF;

      IF p_return_status <> 'S'
      THEN
         p_return_code := c_error;
         p_return_message := 'Create Location';
         raise_application_error (-20000,
                                  'Create Customer Failed: ' || p_msg_data
                                 );
      END IF;



      --dbms_output.put_line(' P_LOCATION_ID = '||to_char(P_LOCATION_ID)||'  '||P_RETURN_STATUS||' '||P_MSG_DATA);
      iri_tca.create_party_site (p_party_id,
                                 p_location_id,
                                 p_party_site_id,
                                 p_party_site_number,
                                 p_return_status,
                                 p_msg_count,
                                 p_msg_data
                                );

      IF p_return_status <> 'S'
      THEN
         p_return_code := c_error;
         p_return_message := 'Create Party Site';
         raise_application_error (-20000,
                                  'Create Customer Failed: ' || p_msg_data
                                 );
      END IF;



      ---dbms_output.put_line(' P_PARTY_SITE_NUMBER = '||P_PARTY_SITE_NUMBER||'  '||P_RETURN_STATUS||' '||P_MSG_DATA);
      iri_tca.create_cust_acct_site (p_cust_account_id,
                                     p_party_site_id,
                                     p_cust_acct_site_id,
                                     p_return_status,
                                     p_msg_count,
                                     p_msg_data
                                    );



      IF p_return_status <> 'S'
      THEN
         p_return_code := c_error;
         p_return_message := 'Create Customer Account Site';
         raise_application_error (-20000,
                                  'Create Customer Failed: ' || p_msg_data
                                 );
      END IF;



      --dbms_output.put_line(' P_CUST_ACCT_SITE_ID = '||to_char(P_CUST_ACCT_SITE_ID)||'  '||P_RETURN_STATUS||' '||P_MSG_DATA);

      /* bill to */
      p_site_use_code := 'BILL_TO';
      iri_tca.create_cust_site_use (p_cust_acct_site_id,
                                    p_site_use_code,
                                    p_site_use_id,
                                    p_return_status,
                                    p_msg_count,
                                    p_msg_data
                                   );

      IF p_return_status <> 'S'
      THEN
         p_return_code := c_error;
         p_return_message := 'Create Bill to Site Use';
         raise_application_error (-20000,
                                  'Create Customer Failed: ' || p_msg_data
                                 );
      END IF;

      p_bill_to_site_id := p_site_use_id;
      --dbms_output.put_line(' P_SITE_USE_ID BILL_TO = '||to_char(P_SITE_USE_ID)||'  '||P_RETURN_STATUS||' '||P_MSG_DATA);
         /* ship to */
      p_site_use_code := 'SHIP_TO';
      iri_tca.create_cust_site_use (p_cust_acct_site_id,
                                    p_site_use_code,
                                    p_site_use_id,
                                    p_return_status,
                                    p_msg_count,
                                    p_msg_data
                                   );

      IF p_return_status <> 'S'
      THEN
         p_return_code := c_error;
         p_return_message := 'Create Ship to Site Use';
         raise_application_error (-20000,
                                  'Create Customer Failed: ' || p_msg_data
                                 );
      END IF;



      p_ship_to_site_id := p_site_use_id;
      ---dbms_output.put_line(' P_SITE_USE_ID SHIP_TO = '||to_char(P_SITE_USE_ID)||'  '||P_RETURN_STATUS||' '||P_MSG_DATA);
      p_return_code := c_success;
      p_return_message := 'Normal';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_return_code := c_error;
         p_return_message := 'Error Creating Customer ' || SQLERRM;
   END;

   IF DEBUG_MODE
   THEN
      DBMS_OUTPUT.put_line (   'T.C. Xref CUSTOMER_ID: '
                            || TO_CHAR (p_cust_account_id)
                           );
   ELSE
      fnd_file.put_line (fnd_file.LOG,
                            'T.C. Xref CUSTOMER_ID: '
                         || TO_CHAR (p_cust_account_id)
                        );
   END IF;


   req.ID := NULL;
   xref.wc_screening_request_id := NULL;
   xref.source_table := 'AR_CUSTOMERS';
   xref.source_table_column := 'CUSTOMER_ID';
   xref.source_table_id := p_cust_account_id;
   rmi_ows_common_util.insert_party_master (xref.source_table,
                                            xref.source_table_column,
                                            xref.source_table_id,
                                            x_id
                                           );

--   IF rmi_ows_common_util.does_wc_exist (xref, req) = FALSE
--   THEN
--/* now let's check to see if the second xref exists if it doesn't then created it */
--      IF DEBUG_MODE
--      THEN
--         DBMS_OUTPUT.put_line
--                             (   'world_check_iface.create_new_xref  '
--                              || TO_CHAR
--                                       (NVL (base_req.id,
--                                             -999
--                                            )
--                                       )
--                             );
--      ELSE
--         fnd_file.put_line (fnd_file.LOG,
--                               'world_check_iface.create_new_xref  '
--                            || TO_CHAR (NVL (base_req.id,
--                                             -999
--                                            )
--                                       )
--                           );
--      END IF;

   --      xref.wc_screening_request_id := NVL (base_req.ID, base_req2.ID);
--      rmi_ows_common_util.create_new_xref (xref, return_code,
--                                           p_return_message);
--   END IF;
   IF p_return_code = c_success AND NVL (update_recs, 'N') = 'Y'
   THEN
      BEGIN
         UPDATE nrmi_certificates
            SET customer_id = p_cust_account_id,
                customer_bill_to_site_id = p_bill_to_site_id,
                customer_ship_to_site_id = p_ship_to_site_id,
                status = 'Customer Created'
          WHERE nrmi_certificates_id = p_nrmi_certificates_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_return_code := c_error;
            p_return_message := 'Error Updating Customer_id ' || SQLERRM;
      END;

      COMMIT;
   END IF;
END;

/* Formatted on 3/10/2015 11:40:37 AM (QP5 v5.163.1008.3004) */
PROCEDURE create_invoice (
   P_NRMI_CERTIFICATES_ID   IN     NUMBER,
   p_do_updates             IN     VARCHAR2 DEFAULT 'N',
   p_order_header_id           OUT NUMBER,
   p_customer_trx_id           OUT NUMBER,
   p_invoice_edoc_id           OUT NUMBER,
   p_return_code               OUT VARCHAR2,
   p_return_message            OUT VARCHAR2)
IS
   default_order_type              NUMBER := 1008; /* SICD=1003, VREG=1004, yacht=1005, corp=1006 */
   default_order_context           VARCHAR2 (30) := 'MARITIME'; /* CORP, MARITIME, SICD, VREG, YACHT */
   default_payment_term_id         NUMBER := 1000;        /* DUE ON RECEIPT */
   c_organization_id               NUMBER := 122;
   c_operating_unit                VARCHAR2 (240) := NULL;


   -- ZK 06282018 Fee Schedule update 07/01/2018
   -- v_price_list_id                 NUMBER := 18508;   -- Name 'MARITIME'

   v_price_list_id                 NUMBER := 224955;  -- Name 'Maritime Price List - Effective 01-JUL-2018'

   -- ZK06282018

   rmi_wreck_removal_item_id       NUMBER := 63195;
   nrmi_wreck_removal_item_id      NUMBER := 65195;  -- V.CV.CRT.CLCWRECKN ZK added item codefor clarity 06282018
   -- FD_nrmi_wreck_removal_item_id   NUMBER := 65196;  -- No longer used ZK 06282018 
   FD1_nrmi_wreck_removal_item_id   NUMBER := 66195; -- V.CV.CRT.CLCWRNFL1 ZK added item code for clarity 06282018
   FD2_nrmi_wreck_removal_item_id   NUMBER := 66196; --V.CV.CRT.CLCWRNFL2 ZK added item code for clarity 06282018


   part_to_order                   NUMBER := NULL;

   p_api_version_number            NUMBER := 1.0;
   p_init_msg_list                 VARCHAR2 (300) := apps.FND_API.G_FALSE;
   p_return_values                 VARCHAR2 (300) := apps.FND_API.G_TRUE;
   p_action_commit                 VARCHAR2 (300);
   x_return_status                 VARCHAR2 (300);
   x_msg_count                     NUMBER;
   x_msg_data                      VARCHAR2 (2000);
   p_header_rec                    Oe_Order_Pub.Header_Rec_Type;
   p_old_header_rec                Oe_Order_Pub.Header_Rec_Type;
   p_header_val_rec                Oe_Order_Pub.Header_Val_Rec_Type;
   p_old_header_val_rec            Oe_Order_Pub.Header_Val_Rec_Type;

   p_Header_Adj_tbl                Oe_Order_Pub.Header_Adj_Tbl_Type;
   p_old_Header_Adj_tbl            Oe_Order_Pub.Header_Adj_Tbl_Type;
   p_Header_Adj_val_tbl            Oe_Order_Pub.Header_Adj_Val_Tbl_Type;
   p_old_Header_Adj_val_tbl        Oe_Order_Pub.Header_Adj_Val_Tbl_Type;
   p_Header_price_Att_tbl          Oe_Order_Pub.Header_Price_Att_Tbl_Type;
   p_old_Header_Price_Att_tbl      Oe_Order_Pub.Header_Price_Att_Tbl_Type;
   p_Header_Adj_Att_tbl            Oe_Order_Pub.Header_Adj_Att_Tbl_Type;
   p_old_Header_Adj_Att_tbl        Oe_Order_Pub.Header_Adj_Att_Tbl_Type;
   p_Header_Adj_Assoc_tbl          Oe_Order_Pub.Header_Adj_Assoc_Tbl_Type;
   p_old_Header_Adj_Assoc_tbl      Oe_Order_Pub.Header_Adj_Assoc_Tbl_Type;
   p_Header_Scredit_tbl            Oe_Order_Pub.Header_Scredit_Tbl_Type;
   p_old_Header_Scredit_tbl        Oe_Order_Pub.Header_Scredit_Tbl_Type;
   p_Header_Scredit_val_tbl        Oe_Order_Pub.Header_Scredit_Val_Tbl_Type;
   p_old_Header_Scredit_val_tbl    Oe_Order_Pub.Header_Scredit_Val_Tbl_Type;
   p_line_tbl                      Oe_Order_Pub.Line_Tbl_Type;
   p_old_line_tbl                  Oe_Order_Pub.Line_Tbl_Type;
   p_line_val_tbl                  Oe_Order_Pub.Line_Val_Tbl_Type;
   p_old_line_val_tbl              Oe_Order_Pub.Line_Val_Tbl_Type;
   p_Line_Adj_tbl                  Oe_Order_Pub.Line_Adj_Tbl_Type;
   p_old_Line_Adj_tbl              Oe_Order_Pub.Line_Adj_Tbl_Type;
   p_Line_Adj_val_tbl              Oe_Order_Pub.Line_Adj_Val_Tbl_Type;
   p_old_Line_Adj_val_tbl          Oe_Order_Pub.Line_Adj_Val_Tbl_Type;
   p_Line_price_Att_tbl            Oe_Order_Pub.Line_Price_Att_Tbl_Type;
   p_old_Line_Price_Att_tbl        Oe_Order_Pub.Line_Price_Att_Tbl_Type;
   p_Line_Adj_Att_tbl              Oe_Order_Pub.Line_Adj_Att_Tbl_Type;
   p_old_Line_Adj_Att_tbl          Oe_Order_Pub.Line_Adj_Att_Tbl_Type;
   p_Line_Adj_Assoc_tbl            Oe_Order_Pub.Line_Adj_Assoc_Tbl_Type;
   p_old_Line_Adj_Assoc_tbl        Oe_Order_Pub.Line_Adj_Assoc_Tbl_Type;
   p_Line_Scredit_tbl              Oe_Order_Pub.Line_Scredit_Tbl_Type;
   p_old_Line_Scredit_tbl          Oe_Order_Pub.Line_Scredit_Tbl_Type;
   p_Line_Scredit_val_tbl          Oe_Order_Pub.Line_Scredit_Val_Tbl_Type;
   p_old_Line_Scredit_val_tbl      Oe_Order_Pub.Line_Scredit_Val_Tbl_Type;
   p_Lot_Serial_tbl                Oe_Order_Pub.Lot_Serial_Tbl_Type;

   p_old_Lot_Serial_tbl            Oe_Order_Pub.Lot_Serial_Tbl_Type;
   p_Lot_Serial_val_tbl            Oe_Order_Pub.Lot_Serial_Val_Tbl_Type;
   p_old_Lot_Serial_val_tbl        Oe_Order_Pub.Lot_Serial_Val_Tbl_Type;
   p_action_request_tbl            Oe_Order_Pub.Request_Tbl_Type;
   x_header_rec                    Oe_Order_Pub.Header_Rec_Type;
   x_header_val_rec                Oe_Order_Pub.Header_Val_Rec_Type;
   x_Header_Adj_tbl                Oe_Order_Pub.Header_Adj_Tbl_Type;
   x_Header_Adj_val_tbl            Oe_Order_Pub.Header_Adj_Val_Tbl_Type;
   x_Header_price_Att_tbl          Oe_Order_Pub.Header_Price_Att_Tbl_Type;
   x_Header_Adj_Att_tbl            Oe_Order_Pub.Header_Adj_Att_Tbl_Type;
   x_Header_Adj_Assoc_tbl          Oe_Order_Pub.Header_Adj_Assoc_Tbl_Type;
   x_Header_Scredit_tbl            Oe_Order_Pub.Header_Scredit_Tbl_Type;
   x_Header_Scredit_val_tbl        Oe_Order_Pub.Header_Scredit_Val_Tbl_Type;
   x_line_tbl                      Oe_Order_Pub.Line_Tbl_Type;
   x_line_val_tbl                  Oe_Order_Pub.Line_Val_Tbl_Type;
   x_Line_Adj_tbl                  Oe_Order_Pub.Line_Adj_Tbl_Type;
   x_Line_Adj_val_tbl              Oe_Order_Pub.Line_Adj_Val_Tbl_Type;
   x_Line_price_Att_tbl            Oe_Order_Pub.Line_Price_Att_Tbl_Type;
   x_Line_Adj_Att_tbl              Oe_Order_Pub.Line_Adj_Att_Tbl_Type;
   x_Line_Adj_Assoc_tbl            Oe_Order_Pub.Line_Adj_Assoc_Tbl_Type;
   x_Line_Scredit_tbl              Oe_Order_Pub.Line_Scredit_Tbl_Type;
   x_Line_Scredit_val_tbl          Oe_Order_Pub.Line_Scredit_Val_Tbl_Type;
   x_Lot_Serial_tbl                Oe_Order_Pub.Lot_Serial_Tbl_Type;
   x_Lot_Serial_val_tbl            Oe_Order_Pub.Lot_Serial_Val_Tbl_Type;
   x_action_request_tbl            Oe_Order_Pub.Request_Tbl_Type;

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

   l_orig_header_rec               Oe_Order_Pub.Header_Rec_Type;
   l_orig_header_val_rec           Oe_Order_Pub.Header_Val_Rec_Type;
   l_orig_header_adj_tbl           Oe_Order_Pub.Header_Adj_Tbl_Type;
   l_orig_header_adj_val_tbl       Oe_Order_Pub.Header_Adj_Val_Tbl_Type;
   l_orig_header_price_att_tbl     Oe_Order_Pub.Header_Price_Att_Tbl_Type;
   l_orig_header_adj_att_tbl       Oe_Order_Pub.Header_Adj_Att_Tbl_Type;
   l_orig_header_adj_assoc_tbl     Oe_Order_Pub.Header_Adj_Assoc_Tbl_Type;
   l_orig_header_scredit_tbl       Oe_Order_Pub.Header_Scredit_Tbl_Type;
   l_orig_header_scredit_val_tbl   Oe_Order_Pub.Header_Scredit_Val_Tbl_Type;
   l_orig_line_tbl                 Oe_Order_Pub.Line_Tbl_Type;
   l_orig_line_val_tbl             Oe_Order_Pub.Line_Val_Tbl_Type;
   l_orig_line_adj_tbl             Oe_Order_Pub.Line_Adj_Tbl_Type;
   l_orig_line_adj_val_tbl         Oe_Order_Pub.Line_Adj_Val_Tbl_Type;
   l_orig_line_price_att_tbl       Oe_Order_Pub.Line_Price_Att_Tbl_Type;
   l_orig_line_adj_att_tbl         Oe_Order_Pub.Line_Adj_Att_Tbl_Type;
   l_orig_line_adj_assoc_tbl       Oe_Order_Pub.Line_Adj_Assoc_Tbl_Type;
   l_orig_line_scredit_tbl         Oe_Order_Pub.Line_Scredit_Tbl_Type;
   l_orig_line_scredit_val_tbl     Oe_Order_Pub.Line_Scredit_Val_Tbl_Type;
   l_orig_lot_serial_tbl           Oe_Order_Pub.Lot_Serial_Tbl_Type;
   l_orig_lot_serial_val_tbl       Oe_Order_Pub.Lot_Serial_Val_Tbl_Type;


   CURSOR get_default_sales_rep_id (cust_id IN NUMBER)
   IS
      SELECT PRIMARY_SALESREP_ID
        FROM ar_customers
       WHERE customer_id = cust_id;

   sales_rep_id                    NUMBER;

   CURSOR get_cert
   IS
      SELECT *
        FROM NRMI_CERTIFICATES
       WHERE NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;

   cert_rec                        get_cert%ROWTYPE;


   CURSOR get_nof_vessels_prev_order (
      p_customer_id IN NUMBER, p_requestor_name in varchar2,p_YEAR in varchar2 )
   IS
      SELECT COUNT (*)
        FROM NRMI_CERTIFICATES crt, NRMI_VESSELS nv
       WHERE crt.NRMI_CERTIFICATES_ID = nv.NRMI_CERTIFICATES_ID
             AND (crt.CUSTOMER_ID = p_customer_id or RQ_NAME = p_requestor_name)
             and crt.status not in ('Rejected','Cancelled')
             and crt.CREATION_DATE  >  add_months(to_date('01-JAN-'||p_YEAR,'dd-mon-rrrr'),-1) ;

   nof_vessels_po                  NUMBER := 0;

   CURSOR get_vessel
   IS
      SELECT *
        FROM NRMI_VESSELS
       WHERE NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;

   resp_appl_id                    NUMBER;
   responsibility_id               NUMBER;
   user_id                         NUMBER;



   yacht_compliance_id             NUMBER;
   order_line_number               NUMBER;
   p_description                   VARCHAR2 (100);
   std_price                       NUMBER;
   prorated_price                  NUMBER;
   prorated_quantity               NUMBER;
   error_num                       NUMBER;
   d_date                          DATE;
   d_str                           VARCHAR2 (100);
   v_cnt                           NUMBER := 0;
   y                               INTEGER;
   trx_number                      NUMBER;
   x_request_id                    NUMBER;
   phase_code                      VARCHAR2 (1);
   status_code                     VARCHAR2 (1);

   --v_req_data varchar2(10);


   CURSOR get_vessel_cert
   IS
      SELECT *
        FROM NRMI_VESSELS
       WHERE NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID
             AND certificate_number IS NULL
        FOR UPDATE skip locked;



   CURSOR get_conc_request_info (rqst_id IN NUMBER)
   IS
      SELECT phase_code,
             status_code,
             file_name,
             file_type
        FROM fnd_conc_req_outputs_v
       WHERE request_id = rqst_id;

   CURSOR get_order_number (p_header_id IN NUMBER)
   IS
      SELECT order_number
        FROM oe_order_headers_all
       WHERE header_id = p_header_id;

   order_number                    NUMBER;

   CURSOR get_ra_interface (p_order_number IN NUMBER)
   IS
      SELECT *
        FROM ra_interface_lines_all
       WHERE SALES_ORDER = p_order_number;

   ra_iface                        get_ra_interface%ROWTYPE;

   CURSOR get_trx_number (
      sales_order IN VARCHAR2)
   IS
      SELECT MAX (trx_number)
        FROM ra_customer_trx_all
       WHERE interface_header_attribute1 = sales_order
             AND creation_date > SYSDATE - 1;

   loop_counter                    NUMBER;
   v_req_data                      VARCHAR2 (10);

   x_res                           BOOLEAN;
   t_message                       VARCHAR2 (2000);
   file_name                       VARCHAR2 (255);
   file_type                       VARCHAR2 (30);
   param_id                        NUMBER := NULL;
BEGIN
   /* populate certificate number so that it will show on invoice */
   FOR x IN get_vessel_cert
   LOOP
      UPDATE NRMI_VESSELS
         SET certificate_number = TO_CHAR (clc_certificate_number.NEXTVAL),
             issue_date = SYSDATE
       WHERE CURRENT OF get_vessel_cert;
   END LOOP;

   COMMIT;


   p_return_code := c_success;
   p_return_message := 'Completed Normal';

   resp_appl_id := TO_NUMBER (FND_PROFILE.VALUE ('RESP_APPL_ID'));
   responsibility_id := TO_NUMBER (FND_PROFILE.VALUE ('RESP_ID'));
   user_id := FND_PROFILE.VALUE ('USER_ID');

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

   MO_GLOBAL.INIT ('ONT');
   MO_GLOBAL.SET_POLICY_CONTEXT ('S', 122);
   FND_GLOBAL.APPS_INITIALIZE (user_id, responsibility_id, resp_appl_id);
   DBMS_APPLICATION_INFO.set_client_info (122);
   oe_msg_pub.initialize;
   oe_debug_pub.SetDebugLevel (5);
   oe_debug_pub.Initialize;
   oe_debug_pub.debug_on;

   OPEN get_cert;

   FETCH get_cert INTO cert_rec;

   CLOSE get_cert;



   IF cert_rec.bill_at_mi_rate = 'Y'
   THEN
      part_to_order := rmi_wreck_removal_item_id;
   ELSE

      OPEN get_nof_vessels_prev_order (cert_rec.CUSTOMER_ID, cert_rec.RQ_NAME,to_char(cert_rec.creation_date,'YYYY'));

      FETCH get_nof_vessels_prev_order INTO nof_vessels_po;

      CLOSE get_nof_vessels_prev_order;


      IF DEBUG_MODE
      THEN

      DBMS_OUTPUT.put_line ('Processing Request Number: '||to_char(P_NRMI_CERTIFICATES_ID)); 
         DBMS_OUTPUT.put_line ('Vessels on orders: '||to_char(nof_vessels_po));

      ELSE

         fnd_file.put_line (FND_FILE.LOG, 'Processing Request Number: '||to_char(P_NRMI_CERTIFICATES_ID));
         fnd_file.put_line (FND_FILE.LOG, 'Vessels on orders: '||to_char(nof_vessels_po));

      END IF;


/* ZK 06282018 07/01/2018 Fee Schedule Update

      IF  NVL (nof_vessels_po, 0) between 1 and 4
      THEN
         part_to_order := nrmi_wreck_removal_item_id; 
      ELSIF  NVL (nof_vessels_po, 0) between 5 and 10 then
        part_to_order := FD_nrmi_wreck_removal_item_id;
       ELSIF  NVL (nof_vessels_po, 0) between 11 and 100 then
        part_to_order := FD1_nrmi_wreck_removal_item_id;
       ELSIF  NVL (nof_vessels_po, 0)  > 100 then
       part_to_order := FD2_nrmi_wreck_removal_item_id;
      END IF;

*/

-- ZK 06282018 07/01/2018 Fee Schedule Update 

      IF  NVL (nof_vessels_po, 0) BETWEEN 1 AND 10

      THEN

         part_to_order := nrmi_wreck_removal_item_id; 

       ELSIF  NVL (nof_vessels_po, 0) BETWEEN 11 and 39 THEN

        part_to_order := FD2_nrmi_wreck_removal_item_id;

       ELSIF  NVL (nof_vessels_po, 0)  > 39 THEN

       part_to_order := FD1_nrmi_wreck_removal_item_id;

      END IF; 

-- ZK 06282018       


      if cert_rec.NRMI_CERTIFICATES_ID = 11765 /* over-ride price for special deal */
      then
       part_to_order := FD1_nrmi_wreck_removal_item_id;
       end if;

   END IF;


   P_header_rec := OE_ORDER_PUB.G_MISS_HEADER_REC;
   P_header_rec.order_type_id := default_order_type;
   P_header_rec.pricing_date := SYSDATE;
   P_header_rec.transactional_curr_code := 'USD';
   p_header_rec.price_list_id := v_price_list_id;               -- ZK 04012014


   /* get the default salesrep_id for the customer    */
   /* if the customer does not have a default then    */
   /* get the person running the procedure's default  */
   /* salesrep_id                                     */

   IF sales_rep_id IS NULL
   THEN
      P_header_rec.salesrep_id := FND_PROFILE.VALUE ('ONT_DEFAULT_PERSON_ID'); /* get default sales rep id for user*/
   ELSE
      P_header_rec.salesrep_id := sales_rep_id; /* get default sales rep id for customer*/
   END IF;

   P_header_rec.operation := OE_GLOBALS.G_OPR_CREATE;
   --P_header_rec.CONTEXT:= default_order_context;

   P_header_rec.sold_to_org_id := cert_rec.CUSTOMER_ID;
   P_header_rec.invoice_to_org_id := cert_rec.CUSTOMER_BILL_TO_SITE_ID;
   P_header_rec.ship_to_org_id := cert_rec.CUSTOMER_SHIP_TO_SITE_ID;
   P_header_rec.payment_term_id := default_payment_term_id;


   order_line_number := 1;

   FOR x IN get_vessel
   LOOP
      P_line_tbl (order_line_number) := OE_ORDER_PUB.G_MISS_LINE_REC;
      P_line_tbl (order_line_number).inventory_item_id := part_to_order;
      P_line_tbl (order_line_number).ordered_quantity := 1;
      P_line_tbl (order_line_number).order_quantity_uom := 'EA';
      p_line_tbl (order_line_number).context := 'MARITIME';

      p_description :=
         x.vessel_name || ' - Cert. No.: ' || TO_CHAR (x.CERTIFICATE_NUMBER);

      P_line_tbl (order_line_number).ATTRIBUTE1 := p_description;
      P_line_tbl (order_line_number).operation := OE_GLOBALS.G_OPR_CREATE;

      order_line_number := order_line_number + 1;
   END LOOP;

   /* book the order */

   p_action_request_tbl := Oe_Order_Pub.G_MISS_REQUEST_TBL;
   P_action_request_tbl (1).request_type := OE_GLOBALS.G_BOOK_ORDER;
   p_action_request_tbl (1).entity_code := OE_GLOBALS.G_ENTITY_HEADER;


   -- CALL TO PROCESS ORDER
   OE_Order_PUB.Process_Order (c_organization_id, c_operating_unit, p_api_version_number, FND_API.G_TRUE, p_return_values, p_action_commit, x_return_status, x_msg_count, x_msg_data, p_header_rec, p_old_header_rec, p_header_val_rec, p_old_header_val_rec, p_Header_Adj_tbl, p_old_Header_Adj_tbl, p_Header_Adj_val_tbl, p_old_Header_Adj_val_tbl, p_Header_price_Att_tbl, p_old_Header_Price_Att_tbl, p_Header_Adj_Att_tbl, p_old_Header_Adj_Att_tbl, p_Header_Adj_Assoc_tbl, p_old_Header_Adj_Assoc_tbl, p_Header_Scredit_tbl, p_old_Header_Scredit_tbl, p_Header_Scredit_val_tbl, p_old_Header_Scredit_val_tbl, p_line_tbl, p_old_line_tbl, p_line_val_tbl, p_old_line_val_tbl, p_Line_Adj_tbl, p_old_Line_Adj_tbl, p_Line_Adj_val_tbl, p_old_Line_Adj_val_tbl, p_Line_price_Att_tbl, p_old_Line_Price_Att_tbl, p_Line_Adj_Att_tbl, p_old_Line_Adj_Att_tbl, p_Line_Adj_Assoc_tbl, p_old_Line_Adj_Assoc_tbl, p_Line_Scredit_tbl, p_old_Line_Scredit_tbl, p_Line_Scredit_val_tbl, p_old_Line_Scredit_val_tbl, p_Lot_Serial_tbl, p_old_Lot_Serial_tbl, p_Lot_Serial_val_tbl, p_old_Lot_Serial_val_tbl, p_action_request_tbl, x_header_rec, x_header_val_rec, x_Header_Adj_tbl, x_Header_Adj_val_tbl, x_Header_price_Att_tbl, x_Header_Adj_Att_tbl, x_Header_Adj_Assoc_tbl, x_Header_Scredit_tbl, x_Header_Scredit_val_tbl, x_line_tbl, x_line_val_tbl, x_Line_Adj_tbl, x_Line_Adj_val_tbl, x_Line_price_Att_tbl, x_Line_Adj_Att_tbl, x_Line_Adj_Assoc_tbl, x_Line_Scredit_tbl, x_Line_Scredit_val_tbl, x_Lot_Serial_tbl, x_Lot_Serial_val_tbl, x_action_request_tbl);


   IF x_return_status = FND_API.G_RET_STS_SUCCESS
   THEN
      --success
      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line (c_success);
      ELSE
         fnd_file.put_line (FND_FILE.LOG, c_success);
      END IF;

      IF x_msg_count > 0
      THEN
         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line ('Warning Messages **********');
         ELSE
            fnd_file.put_line (FND_FILE.LOG, 'Warning Messages **********');
         END IF;

         FOR l_index IN 1 .. x_msg_count
         LOOP
            l_message :=
               oe_msg_pub.get (p_msg_index => l_index, p_encoded => 'F');

            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line (l_message);
            ELSE
               fnd_file.put_line (FND_FILE.LOG, l_message);
            END IF;
         END LOOP;

         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line ('End Warning Messages **********');
         ELSE
            fnd_file.put_line (FND_FILE.LOG, 'End Warning Messages **********');
         END IF;
      END IF;
   ELSE
      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line ('FAILURE');
         --DBMS_OUTPUT.put_line ('Attempting to process Official Number: ' || P_header_rec.attribute2);
         DBMS_OUTPUT.put_line ('RETURN STATUS: ' || x_return_status);
         DBMS_OUTPUT.put_line ('MESSAGE COUNT: ' || TO_CHAR (x_msg_count));

         IF x_msg_count > 0
         THEN
            DBMS_OUTPUT.put_line ('Error Messages **********');

            FOR l_index IN 1 .. x_msg_count
            LOOP
               l_message :=
                  oe_msg_pub.get (p_msg_index => l_index, p_encoded => 'F');
               DBMS_OUTPUT.put_line (l_message);
            END LOOP;

            DBMS_OUTPUT.put_line ('End Error Messages **********');
         END IF;
      ELSE
         fnd_file.put_line (FND_FILE.LOG, 'FAILURE*');
         --fnd_file.put_line (FND_FILE.LOG, 'Attempting to process Official Number: ' || P_header_rec.attribute2);
         fnd_file.put_line (FND_FILE.LOG, 'RETURN STATUS*: ' || x_return_status);
         fnd_file.put_line (FND_FILE.LOG, 'MESSAGE COUNT*: ' || TO_CHAR (x_msg_count));

         IF x_msg_count > 0
         THEN
            fnd_file.put_line (FND_FILE.LOG, 'Error Messages **********');

            FOR l_index IN 1 .. x_msg_count
            LOOP
               l_message :=
                  oe_msg_pub.get (p_msg_index => l_index, p_encoded => 'F');
               fnd_file.put_line (FND_FILE.LOG, l_message);
            END LOOP;

            fnd_file.put_line (FND_FILE.LOG, 'End Error Messages **********');
         END IF;
      END IF;
   END IF;

   l_order_id_n := x_header_rec.header_id;
   p_order_header_id := x_header_rec.header_id;

   oe_order_pub.get_order (p_api_version_number => 1.0, p_init_msg_list => FND_API.G_FALSE, p_return_values => FND_API.G_FALSE, x_return_status => l_status_c, x_msg_count => l_msg_count_n, x_msg_data => l_message_s, p_header_id => l_order_id_n, p_header => FND_API.G_MISS_CHAR, x_header_rec => l_orig_header_rec, x_header_val_rec => l_orig_header_val_rec, x_Header_Adj_tbl => l_orig_header_adj_tbl, x_Header_Adj_val_tbl => l_orig_header_adj_val_tbl, x_Header_price_Att_tbl => l_orig_header_price_att_tbl, x_Header_Adj_Att_tbl => l_orig_header_adj_att_tbl, x_Header_Adj_Assoc_tbl => l_orig_header_adj_assoc_tbl, x_Header_Scredit_tbl => l_orig_header_scredit_tbl, x_Header_Scredit_val_tbl => l_orig_header_scredit_val_tbl, x_line_tbl => l_orig_line_tbl, x_line_val_tbl => l_orig_line_val_tbl, x_line_adj_tbl => l_orig_line_adj_tbl, x_line_adj_val_tbl => l_orig_line_adj_val_tbl, x_line_price_att_tbl => l_orig_line_price_att_tbl, x_line_adj_att_tbl => l_orig_line_adj_att_tbl, x_line_adj_assoc_tbl => l_orig_line_adj_assoc_tbl, x_line_scredit_tbl => l_orig_line_scredit_tbl, x_line_scredit_val_tbl => l_orig_line_scredit_val_tbl, x_lot_serial_tbl => l_orig_lot_serial_tbl, x_lot_serial_val_tbl => l_orig_lot_serial_val_tbl);


   IF DEBUG_MODE
   THEN
      DBMS_OUTPUT.put_line ('Order Listing **********');
      DBMS_OUTPUT.put_line ('Order Number:' || x_header_rec.order_number);
      DBMS_OUTPUT.put_line ('Order header_id:' || x_header_rec.header_id);
      DBMS_OUTPUT.put_line (
         'Order Status:' || l_orig_header_rec.flow_status_code);
      DBMS_OUTPUT.put_line (
            'Line'
         || LPAD ('inventory_item_id', 22, ' ')
         || LPAD ('Unit Price', 12, ' ')
         || LPAD ('Extended Price', 20, ' '));

      FOR i IN 1 .. l_orig_line_tbl.COUNT
      LOOP
         DBMS_OUTPUT.put_line (
            l_orig_line_tbl (i).line_number
            || LPAD (TO_CHAR (l_orig_line_tbl (i).inventory_item_id),
                     22,
                     ' ')
            || LPAD (l_orig_line_tbl (i).unit_selling_price, 12, ' ')
            || LPAD (
               l_orig_line_tbl (i).unit_selling_price * l_orig_line_tbl (i).ordered_quantity,
               18, ' '));
      END LOOP;
   ELSE
      fnd_file.put_line (FND_FILE.LOG, 'Order Listing **********');
      fnd_file.put_line (FND_FILE.LOG, 'Order Number:' || x_header_rec.order_number);
      -- fnd_file.put_line (FND_FILE.OUTPUT,  to_char(x.official_number)||' | '||x_header_rec.order_number);

      fnd_file.put_line (FND_FILE.LOG, 'Order header_id:' || x_header_rec.header_id);
      fnd_file.put_line (FND_FILE.LOG, 'Order Status:' || l_orig_header_rec.flow_status_code);
      fnd_file.put_line (FND_FILE.LOG, 'Line' || LPAD ('inventory_item_id', 22, ' ') || LPAD ('Unit Price', 12, ' ') || LPAD ('Extended Price', 20, ' '));

      FOR i IN 1 .. l_orig_line_tbl.COUNT
      LOOP
         fnd_file.put_line (FND_FILE.LOG, l_orig_line_tbl (i).line_number || LPAD (TO_CHAR (l_orig_line_tbl (i).inventory_item_id), 22, ' ') || LPAD (l_orig_line_tbl (i).unit_selling_price, 12, ' ') || LPAD (l_orig_line_tbl (i).unit_selling_price * l_orig_line_tbl (i).ordered_quantity, 18, ' '));
      END LOOP;
   END IF;


   COMMIT;



   OPEN get_order_number (p_order_header_id);

   FETCH get_order_number INTO order_number;

   CLOSE get_order_number;


   loop_counter := 0;

   LOOP
      loop_counter := loop_counter + 1;
      DBMS_LOCK.sleep (1);

      OPEN get_ra_interface (order_number);

      FETCH get_ra_interface INTO ra_iface;

      CLOSE get_ra_interface;

      IF loop_counter > 500
      THEN
         p_return_code := 'TIMED_OUT';
         p_return_message := 'Request Timed Out';
         RETURN;
      ELSIF ra_iface.INTERFACE_LINE_CONTEXT IS NOT NULL
      THEN
         EXIT;
      END IF;
   END LOOP;

   p_customer_trx_id := ra_iface.customer_trx_id;


   /* run auto-invoice */
   v_req_data := fnd_conc_global.request_data;
   x_res := fnd_request.set_print_options ('IT811', 'PORTRAIT', 0);
   x_request_id :=
      iri_conc.autoinvoice_order (ra_iface.sales_order,
                                  ra_iface.BATCH_SOURCE_NAME);
   COMMIT;

   IF (x_request_id = 0)
   THEN
      p_return_code := 'TIMED_OUT';
      p_return_message := 'Request Timed Out';
      RETURN;
   END IF;

   loop_counter := 0;

   LOOP
      loop_counter := loop_counter + 1;
      DBMS_LOCK.sleep (1);

      OPEN get_conc_request_info (x_request_id);

      FETCH get_conc_request_info
      INTO phase_code, status_code, file_name, file_type;

      CLOSE get_conc_request_info;

      IF phase_code = 'C' AND status_code = 'C'
      THEN
         EXIT;
      ELSIF phase_code = 'C' AND status_code = 'E'
      THEN
         p_return_code := c_error;
         p_return_message := 'Invoice Errored Out';
         RETURN;
     ELSIF loop_counter > 500
      THEN
         p_return_code := c_error;
         p_return_message := 'Invoice Timed Out';
         RETURN;
      END IF;
   END LOOP;


   OPEN get_ra_interface (order_number);

   FETCH get_ra_interface INTO ra_iface;

   CLOSE get_ra_interface;


   p_customer_trx_id := ra_iface.customer_trx_id;


   /*   Print invoice */


   trx_number := NULL;

   OPEN get_trx_number (order_number);

   FETCH get_trx_number INTO trx_number;

   CLOSE get_trx_number;



   IF trx_number IS NOT NULL
   THEN
      x_res := fnd_request.set_print_options ('IT811', 'PORTRAIT', 0);

      x_request_id :=
         FND_REQUEST.SUBMIT_REQUEST ('CUSTOM'                 --app short name
                                             , 'IRI_INV_PDF' --program short name
                                                            ,
         'IRI Invoices (PDF)'                                    --description
                             , NULL                               --start time
                                   , FALSE                       --sub request
                                          , trx_number, '', '', '', '', '',
         '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
         '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
         '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
         '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
         '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
         '', '', '', '', '', '', '', '', '');

      COMMIT;

      IF x_request_id IS NULL
      THEN
         p_return_code := c_error;
         p_return_message := 'Cannont submit request';
         p_invoice_edoc_id := NULL;
         RETURN;
      END IF;

      loop_counter := 0;

      LOOP
         loop_counter := loop_counter + 1;

         OPEN get_conc_request_info (x_request_id);

         FETCH get_conc_request_info
         INTO phase_code, status_code, file_name, file_type;

         CLOSE get_conc_request_info;

         IF phase_code = 'C'
         THEN
            EXIT;
         END IF;

         IF loop_counter > 300 --sarora 10/11/2016 changed from 15
         THEN
            p_return_code := c_error;
            p_return_message := 'Invoice Timed Out';
            RETURN;
         END IF;

         DBMS_LOCK.sleep (3);
      END LOOP;

      IF phase_code = 'C' AND status_code = 'E'
      THEN
         p_return_code := c_error;
         p_return_message := 'Invoice Errored Out';
         RETURN;
      END IF;

      BEGIN
         iri_edocs_pkg.add_file_to_edocs (file_name, 1447, TO_CHAR (P_NRMI_CERTIFICATES_ID), p_invoice_edoc_id);

         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line (
               'Saving to Edocs ' || TO_CHAR (p_invoice_edoc_id));
         ELSE
            fnd_file.put_line (FND_FILE.LOG, 'Saving to Edocs ' || TO_CHAR (p_invoice_edoc_id));
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_invoice_edoc_id := NULL;
      END;

      IF p_do_updates = 'Y'
      THEN
         BEGIN
            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line ('Processing Invoice Updates');
            ELSE
               fnd_file.put_line (FND_FILE.LOG, 'Processing Invoice Updates');
            END IF;

            UPDATE NRMI_CERTIFICATES
               SET RA_CUSTOMER_TRX_ID = p_customer_trx_id,
                   OE_HEADER_ID = p_order_header_id,
                   INVOICE_EDOC_ID = p_invoice_edoc_id,
                   status = 'Invoice Created'
             WHERE NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;
             COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               p_return_code := c_error;
               p_return_message :=
                  'Error updating NRMI_CERTIFICATES ' || SQLERRM;

         END;
      END IF;
   END IF;

   IF DEBUG_MODE
   THEN
      DBMS_OUTPUT.put_line ('Exit Create Invoice');
   ELSE
      fnd_file.put_line (FND_FILE.LOG, 'Exit Create Invoice');
   END IF;
END;

procedure create_certificates(P_NRMI_CERTIFICATES_ID in number,  p_return_code out varchar2, p_return_message out varchar2) is

cursor get_vessel is select * from NRMI_VESSELS where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID and CERTIFICATE_EDOC_ID is null;

cursor get_updates is select * from NRMI_CERT_UPDATES where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;

loop_counter number;
v_req_data varchar2(10);

  x_res boolean;
   x_request_id number;
    phase_code varchar2(1);
  status_code varchar2(1);

        cursor get_conc_request_info(rqst_id in number) is
    select phase_code,status_code,file_name,file_type
     from fnd_conc_req_outputs_v 
    where request_id=rqst_id;

    file_name varchar2(255);
  file_type varchar2(30);

  P_CERTIFICATE_EDOC_ID number;

     resp_appl_id                     NUMBER;
   responsibility_id                NUMBER;
   user_id                          NUMBER;


begin
p_return_code:=c_success;
p_return_message:='Completed Normal';

   resp_appl_id := TO_NUMBER (FND_PROFILE.VALUE ('RESP_APPL_ID'));
   responsibility_id := TO_NUMBER (FND_PROFILE.VALUE ('RESP_ID'));
   user_id := FND_PROFILE.VALUE ('USER_ID');

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

   MO_GLOBAL.INIT ('ONT');
   MO_GLOBAL.SET_POLICY_CONTEXT ('S', 122);
   FND_GLOBAL.APPS_INITIALIZE (user_id, responsibility_id, resp_appl_id);
   DBMS_APPLICATION_INFO.set_client_info (122);


  dbms_output.put_line('Start');

for x in get_vessel loop

  dbms_output.put_line('for loop');

x_res :=fnd_request.set_print_options(
'IT811', 
'PORTRAIT', 
0);

x_request_id := FND_REQUEST.SUBMIT_REQUEST ( 
'VSSL' --app short name 
,'IRIWRLC_NRMI' --program short name 
,'MI-237: Civil Liablilty Cert Wreck Removal, Nirobi,  2007 (WRLC)' --description 
,NULL --start time 
,FALSE --sub request 
,x.NRMI_VESSELS_ID
,'Y'
,''
,''
,''
,''
,'','','','' 
,'','','','','','','','','','' 
,'','','','','','','','','','' 
,'','','','','','','','','','' 
,'','','','','','','','','','' 
,'','','','','','','','','','' 
,'','','','','','','','','','' 
,'','','','','','','','','','' 
,'','','','','','','','','','' 
,'','','','','','','','','','' ); 

commit;

if x_request_id is null then

  p_return_code:=c_error ;
p_return_message :='Cannont submit request';
P_CERTIFICATE_EDOC_ID:=null;
  dbms_output.put_line('error submitting request');

return;  
end if;

loop_counter:=0;
      LOOP

         loop_counter := loop_counter + 1;

         OPEN get_conc_request_info (x_request_id);

         FETCH get_conc_request_info
          INTO phase_code, status_code, file_name, file_type;

         CLOSE get_conc_request_info;

         IF phase_code = 'C'
         THEN
            EXIT;
         END IF;

         IF loop_counter > 15
         THEN

              p_return_code:=c_error ;
               p_return_message :='Certificate Timed Out';
               return;  
         END IF;

         DBMS_LOCK.sleep (3);
      END LOOP;

   IF phase_code = 'C' AND status_code = 'E'
      THEN                      
         p_return_code:=c_error ;
           p_return_message :='Certifiacate Errored Out';
         return;  
      END IF;

begin
iri_edocs_pkg.add_file_to_edocs(file_name,1445,to_char(P_NRMI_CERTIFICATES_ID), P_CERTIFICATE_EDOC_ID);
exception when others then
P_CERTIFICATE_EDOC_ID:=null;
p_return_code:=c_error ;
 p_return_message :='Error creating Certificate:'||sqlerrm;
end;

INSERT INTO VSSL.NRMI_CERT_UPDATES (
   NRMI_VESSELS_ID, CERTIFICATE_EDOC_ID, NRMI_CERTIFICATES_ID) 
VALUES ( x.NRMI_VESSELS_ID   /* NRMI_VESSELS_ID */,
 P_CERTIFICATE_EDOC_ID /* CERTIFICATE_EDOC_ID */,
x.NRMI_CERTIFICATES_ID  /* NRMI_CERTIFICATES_ID */ );
end loop;

commit;


for x in get_updates loop

update NRMI_VESSELS
set  CERTIFICATE_EDOC_ID= x.CERTIFICATE_EDOC_ID
where NRMI_VESSELS_ID = x.NRMI_VESSELS_ID;

end loop;

commit;

delete from NRMI_CERT_UPDATES
where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;

commit;

if p_return_code = c_success then
advance_workflow(P_NRMI_CERTIFICATES_ID, p_return_code, p_return_message);
end if;

end;
procedure send_certificates(P_NRMI_CERTIFICATES_ID in number, p_do_updates in varchar2 default 'N', p_return_code out varchar2, p_return_message out varchar2) is

counter number;
max_attachments number:=5;

  cursor get_cert is select * from NRMI_CERTIFICATES where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;
  cert_rec get_cert%rowtype;

cursor get_vessel is select * from NRMI_VESSELS where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID and certificate_sent_date is null and CERTIFICATE_EDOC_ID is not null and rownum < max_attachments;

cursor get_vessel_certs_to_send is select count(*) from NRMI_VESSELS where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID  and certificate_sent_date is null  and CERTIFICATE_EDOC_ID is not null;
total_certs number:=0;

cert_edoc_id_list iri_stack;
cert_vessel_list iri_stack;
cert_number_list IRI_Stack_varchar;

P_NRMI_VESSELS_ID number;

conn utl_smtp.connection;
filename varchar2(255);

email_text varchar2(5000);
header_line varchar2(300);
detail_line varchar2(300);

email_msg varchar2(4000);
sender_email_address varchar2(300);

dest_email_address varchar2(300);

start_email boolean;
      v_return         NUMBER;
      v_errormessage   VARCHAR2 (2000);
v_attach               sendmailjpkg.attachments_list;

cert_blob blob;
p_cert_edoc_id number;
p_cert_number varchar2(100);
i number;
len number;

p_text varchar2(20000);

begin

 --dbms_output.put_line('start'); 
cert_blob:=empty_blob;

cert_edoc_id_list:= new iri_stack(null,null,null);
cert_vessel_list := new iri_stack(null,null,null);
cert_number_list:= new  IRI_Stack_varchar(null,null,null);

p_return_code:=c_success;
p_return_message:='Completed Normal';

open get_cert;
fetch get_cert into cert_rec; 
close get_cert;

open get_vessel_certs_to_send;
fetch get_vessel_certs_to_send into total_certs;
close get_vessel_certs_to_send;


while  total_certs > 0 loop

if debug_mode then
dest_email_address:='mtimmons@register-iri.com';
else
dest_email_address:=nvl(cert_rec.BT_EMAIL_ADDRESS ,cert_rec.rq_email_address);
end if;

cert_edoc_id_list.initialize;
cert_vessel_list.initialize;
cert_number_list.initialize;
  conn := Demo_Mail.begin_mail(
  sender     => 'WRLC@register-iri.com',
  recipients => dest_email_address, 
  cc=> test_cc_email_address,
  subject    => 'WRLC(s) for Placement on Board Ship(s)',
  mime_type  => demo_mail.MULTIPART_MIME_TYPE);

p_text:='Dear Sir or Madam:<BR><BR>';
p_text:=p_text||'Please find attached the following electronically conveyed Certificate(s) of Insurance or Other Financial Security in Respect of Liability for the Removal of Wrecks (WRLC) issued to the following ship(s) registered in a non-State Party pursuant to the requirements of the Nairobi International Convention on the Removal of Wrecks, 2007 (the ;Convention;). <BR><BR>';
p_text:=p_text||'<table border=1 cellpadding=10><tr><th>Ship Name</th><th>Distinctive Number or Letters</th><th>IMO Number</th></tr>';
for x in get_vessel loop
p_text:=p_text||'<tr><td>'||x.vessel_name||'</td><td>'||X.official_number||'</td><td>'||to_char(x.VESSEL_IMO_NUMBER)||'</td></tr>';
cert_edoc_id_list.push(x.CERTIFICATE_EDOC_ID);
cert_number_list.push(x.vessel_name);
cert_vessel_list.push(x.NRMI_VESSELS_ID);
end loop;
p_text:=p_text||'</table><br><br>';
p_text:=p_text||'Please print out each WRLC on good quality bond paper using a color printer and place the WRLC on board each respective ship as required under the provisions of the Convention.<BR><BR>';
p_text:=p_text||'Please be advised that, as per Section 9.4 of Marine Notice No. 2-011-45, ;it shall be the responsibility of the registered owner or operator of the ship registered in a non-State Party to place the WRLC on board the ship and to notify and provide a copy of the WRLC to its flag State administration.;<BR><BR>';
p_text:=p_text||'Please note, upon entry into force of the Convention in your flag State jurisdiction, you will need to obtain a WRLC from that State party. Subsequent renewal of any WRLC issued by the Republic of the Marshall Islands Maritime Administrator to a non-State party ship will be reliant on further application by the owner or his/her representative.<BR><BR>';
p_text:=p_text|| 'Any inquiries may be directed to WRLC@register-iri.com.<BR><BR>';


  demo_mail.attach_text(
conn =>conn,
data => p_text,
mime_type => 'text/html');

-- dbms_output.put_line('attaching files');  
while not cert_edoc_id_list.empty loop

cert_edoc_id_list.pop(p_cert_edoc_id);

cert_number_list.pop(p_cert_number);

cert_blob:=empty_blob();

email_processing.read_edoc_into_blob(p_cert_edoc_id, cert_blob, p_return_code, p_return_message);



demo_mail.begin_attachment(
 conn => conn,
 mime_type =>'application/pdf',
 inline => TRUE,
 filename => p_cert_number||'.pdf',
 transfer_enc => 'base64');


i := 1;
 len := DBMS_LOB.getLength(cert_blob);

 if len <100 then
   raise_application_error(-20001,'There is no certificate to send');
 end if;

 --dbms_output.put_line(to_char(len));
 WHILE (i < len) LOOP
 IF(i + demo_mail.MAX_BASE64_LINE_WIDTH < len)THEN
 UTL_SMTP.Write_Raw_Data (conn
 , UTL_ENCODE.Base64_Encode(
 DBMS_LOB.Substr(cert_blob, demo_mail.MAX_BASE64_LINE_WIDTH, i)));
 ELSE
 UTL_SMTP.Write_Raw_Data (conn
 , UTL_ENCODE.Base64_Encode(
 DBMS_LOB.Substr(cert_blob, (len - i)+1, i)));
 END IF;
 UTL_SMTP.Write_Data(conn, UTL_TCP.CRLF);
 i := i + demo_mail.MAX_BASE64_LINE_WIDTH;
 END LOOP;

 demo_mail.end_attachment(conn => conn);

end  loop;

  Demo_Mail.end_mail( conn => conn );

commit;  
 --dbms_output.put_line('mail_sent');  

while not cert_vessel_list.empty loop

cert_vessel_list.pop(P_NRMI_VESSELS_ID);

update NRMI_VESSELS
set CERTIFICATE_SENT_DATE=sysdate
where NRMI_VESSELS_ID=P_NRMI_VESSELS_ID;

end loop;


total_certs:=0;
open get_vessel_certs_to_send;
fetch get_vessel_certs_to_send into total_certs;
close get_vessel_certs_to_send;

end loop;


if p_return_code = c_success then
commit;
if p_do_updates = 'Y' then
nrmi_certs.advance_workflow(P_NRMI_CERTIFICATES_ID, p_return_code, p_return_message);
end if;
end if;



end;

procedure send_acknowledgement(P_NRMI_CERTIFICATES_ID in number, p_return_code out varchar2, p_return_message out varchar2) is

counter number;
max_attachments number:=5;

dest_email_address varchar2(300);

  cursor get_cert is select * from NRMI_CERTIFICATES where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID  FOR UPDATE skip locked;
  cert_rec get_cert%rowtype;

cursor get_vessel is select * from NRMI_VESSELS where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;

conn utl_smtp.connection;
filename varchar2(255);

email_text varchar2(5000);
header_line varchar2(300);
detail_line varchar2(300);

email_msg varchar2(4000);
sender_email_address varchar2(300);

start_email boolean;
      v_return         NUMBER;
      v_errormessage   VARCHAR2 (2000);
v_attach               sendmailjpkg.attachments_list;

begin

p_return_code:=c_success;
p_return_message:='Completed Normal';

begin
open get_cert;
fetch get_cert into cert_rec; 



if debug_mode then
dest_email_address:='mtimmons@register-iri.com';
else
dest_email_address:=nvl(cert_rec.BT_EMAIL_ADDRESS ,cert_rec.rq_email_address);
end if;

counter :=0;
  conn := Demo_Mail.begin_mail(
  sender     => 'WRLC@register-iri.com',
  recipients => dest_email_address,
  cc=> test_cc_email_address,
  subject    => 'WRLC(s) Application Received',
  mime_type  => 'text/html');

    Demo_Mail.write_text(
    conn    => conn,
    message =>'Dear Sir or Madam:<BR><BR>');

  Demo_Mail.write_text(
    conn    => conn,
    message =>'Thank you for your application for Certificate(s) of Insurance or Other Financial Security in Respect of Liability for the Removal of Wrecks (WRLC) with respect to the following ship(s.)<BR><BR>');

  Demo_Mail.write_text(
    conn    => conn,
    message =>'<table border=1 cellpadding=10><tr><th>Ship Name</th><th>Distinctive Number or Letters</th><th>IMO Number</th></tr>');

for x in get_vessel loop
  Demo_Mail.write_text(
    conn    => conn,
    message =>'<tr><td>'||x.vessel_name||'</td><td>'||X.official_number||'</td><td>'||to_char(x.VESSEL_IMO_NUMBER)||'</td></tr>');
end loop;

  Demo_Mail.write_text(
    conn    => conn,
    message =>'</table><br><br>');

      Demo_Mail.write_text(
    conn    => conn,
    message =>'Your application is being processed.  Most applications are processed within two business days and, upon acceptance of the application, an invoice will be sent to you no later than three business days from the date of this notification.');

    -- Added ZK 03312015
     Demo_Mail.write_text(
    conn    => conn,
    message =>'<br><br>Please check your junk folder / spam filter as some notifications from WRLC@register-iri.com may be directed to these folders instead of the applicant'||''''||'s  inbox.  You may also include the sender, WRLC@register-iri.com, on your Safe List.');
    -- ZK 03312015

          Demo_Mail.write_text(
    conn    => conn,
    message =>'<br><br>Any inquiries may be directed to WRLC@register-iri.com.');

  Demo_Mail.end_mail( conn => conn );

update NRMI_CERTIFICATES
set ackno_sent_date=sysdate
where current of get_cert ;  
  commit;
exception when others then
p_return_code:=c_error;
p_return_message :='Error Sending Acknowledgement '||sqlerrm;
end;
close get_cert;
/*
if p_return_code = c_success then
commit;
advance_workflow(P_NRMI_CERTIFICATES_ID, p_return_code, p_return_message);
end if;*/

end;

procedure send_invoice(P_NRMI_CERTIFICATES_ID in number,p_do_updates varchar2 default 'N', p_return_code out varchar2, p_return_message out varchar2) is

counter number;
max_attachments number:=5;

dest_email_address varchar2(300);

  cursor get_cert is select * from NRMI_CERTIFICATES where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;
  cert_rec get_cert%rowtype;

cursor get_vessel is select * from NRMI_VESSELS where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;

conn utl_smtp.connection;
filename varchar2(255);

email_text varchar2(5000);
header_line varchar2(300);
detail_line varchar2(300);

email_msg varchar2(4000);
sender_email_address varchar2(300);

start_email boolean;
      v_return         NUMBER;
      v_errormessage   VARCHAR2 (2000);
v_attach               sendmailjpkg.attachments_list;

invoice_blob blob;
i number;
len number;

p_text varchar2(20000);

begin
invoice_blob:=empty_blob;

p_return_code:=c_success;
p_return_message:='Completed Normal';

begin
open get_cert;
fetch get_cert into cert_rec; 
close get_cert;



if debug_mode then
dest_email_address:='mtimmons@register-iri.com';
else
dest_email_address:=nvl(cert_rec.BT_EMAIL_ADDRESS ,cert_rec.rq_email_address);
end if;

  conn := Demo_Mail.begin_mail(
  sender     => 'WRLC@register-iri.com',
  recipients => dest_email_address,
  cc=> test_cc_email_address,
  subject    => 'WRLC(s) Application Approved, Invoice Attached for Payment',
  mime_type  => demo_mail.MULTIPART_MIME_TYPE);

p_text:='Dear Sir or Madam:<BR><BR>';
p_text:=p_text||'Your application for Certificate(s) of Insurance or Other Financial Security in Respect of Liability for the Removal of Wrecks (WRLC) with respect to the following ship(s) has been accepted. <BR><BR>';
p_text:=p_text||'<table border=1 cellpadding=10><tr><th>Ship Name</th><th>Distinctive Number or Letters</th><th>IMO Number</th></tr>';
for x in get_vessel loop
p_text:=p_text||'<tr><td>'||x.vessel_name||'</td><td>'||X.official_number||'</td><td>'||to_char(x.VESSEL_IMO_NUMBER)||'</td></tr>';
end loop;
p_text:=p_text||'</table><br><br>';
p_text:=p_text||'Please find attached an invoice for this transaction.  Payment must be received prior to the issuance of the WRLC(s).  The quickest and easiest way to make payment is by using a credit card online at the following address: <BR><BR>';

-- 11022017 ZK  T20171102.0014
p_text:=p_text||'<a href="https://www.tcmi-inc.com/tcmi/maritime.jsf">https://www.tcmi-inc.com/tcmi/home</a>';
--p_text:=p_text||'<a href="https://www.tcmi-inc.com/miPayments/index.cfm/Payment/maritime?invoice='||GET_TRX_NUMBER(cert_rec.RA_CUSTOMER_TRX_ID)||'1200='||to_char(GET_TRANSACTION_AMOUNT(cert_rec.RA_CUSTOMER_TRX_ID))||'">https://www.tcmi-inc.com/miPayments/index.cfm/Payment/maritime</a>';
-- 11022017 ZK  T20171102.0014

p_text:=p_text||'<br><br>The invoice number must be entered to ensure evidence of payment for the WRLC(s).  Once payment has been submitted, you will receive an immediate email confirmation of payment.<BR><BR>';
p_text:=p_text||'Payment may also be remitted by check or bank draft payable to ;The Trust Company of the Marshall Islands, Inc.; in United States (US) dollars and drawn on a US bank or the US branch of an international bank. <BR><BR>';
p_text:=p_text||'Wire transfers are also acceptable. The most convenient office of the Administrator may be contacted for wire transfer instructions. <BR><BR>';
p_text:=p_text||'Payment by check, bank draft, or wire transfer will take longer to process. Again, please note that the invoice number must be referenced for all forms of payment in order to ensure evidence of payment for the WRLC(s).<BR><BR>';
p_text:=p_text|| 'Any inquiries may be directed to WRLC@register-iri.com.<BR><BR>';


  demo_mail.attach_text(
conn =>conn,
data => p_text,
mime_type => 'text/html');

email_processing.read_edoc_into_blob(cert_rec.invoice_edoc_id, invoice_blob, p_return_code, p_return_message);

demo_mail.begin_attachment(
 conn => conn,
 mime_type =>'application/pdf',
 inline => TRUE,
 filename => GET_TRX_NUMBER(cert_rec.RA_CUSTOMER_TRX_ID)||'.pdf',
 transfer_enc => 'base64');


i := 1;
 len := DBMS_LOB.getLength(invoice_blob);
 dbms_output.put_line(to_char(len));
 WHILE (i < len) LOOP
 IF(i + demo_mail.MAX_BASE64_LINE_WIDTH < len)THEN
 UTL_SMTP.Write_Raw_Data (conn
 , UTL_ENCODE.Base64_Encode(
 DBMS_LOB.Substr(invoice_blob, demo_mail.MAX_BASE64_LINE_WIDTH, i)));
 ELSE
 UTL_SMTP.Write_Raw_Data (conn
 , UTL_ENCODE.Base64_Encode(
 DBMS_LOB.Substr(invoice_blob, (len - i)+1, i)));
 END IF;
 UTL_SMTP.Write_Data(conn, UTL_TCP.CRLF);
 i := i + demo_mail.MAX_BASE64_LINE_WIDTH;
 END LOOP;

 demo_mail.end_attachment(conn => conn);

  Demo_Mail.end_mail( conn => conn );

if p_do_updates = 'Y' then
update NRMI_CERTIFICATES
set INVOICE_SENT_DATE = sysdate
where NRMI_CERTIFICATES_ID = cert_rec.NRMI_CERTIFICATES_ID;
commit;
if p_return_code = c_success then
advance_workflow(P_NRMI_CERTIFICATES_ID, p_return_code, p_return_message);
end if;
end if;

exception when others then
p_return_code:=c_error;
p_return_message :='Error Sending Invoice '||sqlerrm;
end;




end;


procedure populate_iface(p_NRMI_APPLICATION_ID in number, p_return_code out varchar2, p_return_message out varchar2) is

cursor get_appl is select * from NRMI_APPLICATION where NRMI_APPLICATION_ID = p_NRMI_APPLICATION_ID;

appl get_appl%rowtype;

cursor app_data is select x.* from nrmi_application app, xmltable(
                                                  '/topmostSubform' passing app.APPLICATION_XML
                                                 columns 
                                                  Vessel_Name varchar2(200)  path 'Vessel_Name',
                                                  Port_of_Registry varchar2(200)  path 'Port_of_Registry',
                                                  Gross_Tons varchar2(200)  path 'Gross_Tons',
                                                  Official_Number varchar2(200)  path 'Official_Number',
                                                  IMO_Number varchar2(200)  path 'IMO_Number',
                                                  RO_Name varchar2(200)  path 'RO_Name',
                                                  RO_ADDR1 varchar2(200)  path 'RO_ADDR1',
                                                  RO_ADDR2 varchar2(200)  path 'RO_ADDR2' ,  
                                                  RO_CITY varchar2(200)  path 'RO_CITY',
                                                  RO_PROVINCE varchar2(200)  path 'RO_PROVINCE',
                                                  RO_COUNTRY varchar2(200)  path 'RO_COUNTRY',
                                                  RO_POSTAL_CODE varchar2(200)  path 'RO_POSTAL_CODE',
                                                  RO_TEL varchar2(200)  path 'RO_TEL',
                                                  RO_EMAIL varchar2(200)  path 'RO_EMAIL',
                                                  ISS_NAME varchar2(200)  path 'ISS_NAME',
                                                  ISS_ADDR1 varchar2(200)  path 'ISS_ADDR1' ,  
                                                  ISS_ADDR2 varchar2(200)  path 'ISS_ADDR2',
                                                  ISS_CITY varchar2(200)  path 'ISS_CITY',
                                                  ISS_PROVINCE varchar2(200)  path 'ISS_PROVINCE',
                                                  ISS_COUNTRY varchar2(200)  path 'ISS_COUNTRY',
                                                  ISS_POSTAL_CODE varchar2(200)  path 'ISS_POSTAL_CODE',
                                                  RE_SAME varchar2(200)  path 'RE_SAME',
                                                  RE_NAME varchar2(200)  path 'RE_NAME',
                                                  RE_ADDR1 varchar2(200)  path 'RE_ADDR1' ,  
                                                  RE_ADDR2 varchar2(200)  path 'RE_ADDR2',
                                                  RE_CITY varchar2(200)  path 'RE_CITY',
                                                  RE_PROVINCE varchar2(200)  path 'RE_PROVINCE',
                                                  RE_COUNTRY varchar2(200)  path 'RE_COUNTRY',
                                                  RE_POSTAL_CODE varchar2(200)  path 'RE_POSTAL_CODE',
                                                  RE_TEL varchar2(200)  path 'RE_TEL',
                                                  RE_EMAIL varchar2(200)  path 'RE_EMAIL',
                                                  PAY_SAME varchar2(200)  path 'PAY_SAME' ,  
                                                  PAY_NAME varchar2(200)  path 'PAY_NAME',
                                                  PAY_ADDR1 varchar2(200)  path 'PAY_ADDR1' ,  
                                                  PAY_ADDR2 varchar2(200)  path 'PAY_ADDR2',
                                                  PAY_CITY varchar2(200)  path 'PAY_CITY',
                                                  PAY_PROVINCE varchar2(200)  path 'PAY_PROVINCE',
                                                  PAY_COUNTRY varchar2(200)  path 'PAY_COUNTRY',
                                                  PAY_POSTAL_CODE varchar2(200)  path 'PAY_POSTAL_CODE',
                                                  PAY_TEL varchar2(200)  path 'PAY_TEL',
                                                  PAY_EMAIL varchar2(200)  path 'PAY_EMAIL',
                                                  ATTESTATION varchar2(200)  path 'ATTESTATION',
                                                  ATTEST_DATE varchar2(200)  path 'ATTEST_DATE'


                                                   ) x 
where   nrmi_application_id=p_NRMI_APPLICATION_ID;     

app_rec app_data%rowtype;

v_plain   CLOB;

xvar xmltype;

str_var varchar2(4000);
start_delimiter varchar2(4000);

start_position number;
end_position number;

attest_date date:=null;
date_convert_error boolean :=false;

begin

p_return_code:=c_success;
p_return_message:='Normal';

   --DBMS_LOB.createtemporary (v_doc, TRUE);
   DBMS_LOB.createtemporary (v_plain, TRUE);

open get_appl;
fetch get_appl into appl;
close get_appl; 


v_plain:=clobfromblob(appl.application) ;

v_plain:=REGEXP_REPLACE(v_plain,chr(10),null); /* get rid of carriage return */
v_plain:=REGEXP_REPLACE(v_plain,'><','>'||chr(10)||'<'); /* line the begin and end of the tags on the same line */

v_plain:=REGEXP_REPLACE(v_plain,'<RE_PROVINCE/>','<RE_PROVINCE></RE_PROVINCE>'); /* remove the single tags with double tags */

--dbms_output.put_line('RE_PROVINCE :'||to_char(REGEXP_COUNT(v_plain,'RE_PROVINCE')));



if REGEXP_COUNT(v_plain,'RE_PROVINCE') =3 then
--ms_output.put_line('RE_PROVINCE more than 2');
v_plain:=REGEXP_REPLACE(v_plain,'RE_PROVINCE','RE_POSTAL_CODE',1,3);
--dbms_output.put_line('remplacement 2');
elsif REGEXP_COUNT(v_plain,'RE_PROVINCE') =4 then
--ms_output.put_line('RE_PROVINCE more than 2');
v_plain:=REGEXP_REPLACE(v_plain,'RE_PROVINCE','RE_POSTAL_CODE',1,3);
--dbms_output.put_line('replacement 1');
v_plain:=REGEXP_REPLACE(v_plain,'RE_PROVINCE','RE_POSTAL_CODE',1,3);
--dbms_output.put_line('remplacement 2');
end if;

--xvar:=blob_to_xmltype(appl.application);

xvar:=XMLTYPE(v_plain);


   -- ctx_doc.ifilter (appl.application,v_plain);

   UPDATE NRMI_APPLICATION
      SET application_text = v_plain,
      application_xml=xvar
    WHERE nrmi_application_id= p_NRMI_APPLICATION_ID;
   COMMIT;


open app_data;
fetch app_data into app_rec;
close app_data;

begin
attest_date:=  to_date(app_rec. ATTEST_DATE ,'RRRR-MM-DD');
exception when others then
date_convert_error:=TRUE;
end;

if date_convert_error  then
date_convert_error:=FALSE;
begin
attest_date:=  to_date(app_rec. ATTEST_DATE ,'DD/MM/RRRR');
exception when others then
date_convert_error:=TRUE;
end;
end if;

if date_convert_error  then
date_convert_error:=FALSE;
begin
attest_date:=  to_date(app_rec. ATTEST_DATE ,'RRRR/MM/DD');
exception when others then
date_convert_error:=TRUE;
end;
end if;

if date_convert_error  then
date_convert_error:=FALSE;
begin
attest_date:=  to_date(app_rec. ATTEST_DATE ,'MM/DD/RRRR');
exception when others then
attest_date:=null;
end;
end if;

INSERT INTO VSSL.NRMI_APPLICATION_IFACE (
   NRMI_APPLICATION_IFACE_ID, NRMI_APPLICATION_ID, VESSEL_NAME, 
   PORT_OF_REGISTRY, GROSS_TONS, OFFICIAL_NUMBER, 
   IMO_NUMBER, RO_NAME, RO_ADDR1, 
   RO_ADDR2, RO_CITY, RO_PROVINCE, 
   RO_COUNTRY, RO_TEL, RO_EMAIL, 
   ISS_NAME, ISS_ADDR1, ISS_ADDR2, 
   ISS_CIITY, ISS_PROVINCE, ISS_COUNTRY, 
   ISS_POSTAL_CODE, RO_POSTAL_CODE, RE_SAME, 
   RE_NAME, RE_ADDR1, RE_ADDR2, 
   RE_CITY, RE_PROVINCE, RE_COUNTRY, 
   RE_POSTAL_CODE, RE_TEL, RE_EMAIL, 
   PAY_SAME, PAY_NAME, PAY_ADDR1, 
   PAY_ADDR2, PAY_CITY, PAY_PROVINCE, 
   PAY_COUNTRY, PAY_POSTAL_CODE, PAY_TEL, 
   PAY_EMAIL, ATTESTATION_NAME, ATTESTATION_DATE, 
   CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, 
   LAST_UPDATED_BY, LAST_UPDATE_LOGIN, BLUE_CARD_EDOC_ID, 
   COR_EDOC_ID, APPLICATION_EDOC_ID) 
VALUES ( null  /* NRMI_APPLICATION_IFACE_ID */,
 p_NRMI_APPLICATION_ID  /* NRMI_APPLICATION_ID */,
  ltrim(rtrim(upper(app_rec.VESSEL_NAME))),
  ltrim(rtrim(upper(app_rec. PORT_OF_REGISTRY ))),
  ltrim(rtrim(upper(app_rec. GROSS_TONS ))),
  ltrim(rtrim(upper(app_rec. OFFICIAL_NUMBER))),
    ltrim(rtrim(upper(app_rec. IMO_NUMBER))),
    ltrim(rtrim(upper(app_rec. RO_NAME))),
    ltrim(rtrim(upper(app_rec. RO_ADDR1))),
    ltrim(rtrim(upper(app_rec. RO_ADDR2))),
    ltrim(rtrim(upper(app_rec. RO_CITY))),
    ltrim(rtrim(upper(app_rec. RO_PROVINCE))),
    ltrim(rtrim(upper(app_rec. RO_COUNTRY))),
    ltrim(rtrim(upper(app_rec. RO_TEL))),
    ltrim(rtrim(upper(app_rec. RO_EMAIL))),
    ltrim(rtrim(upper(app_rec. ISS_NAME ))),
    ltrim(rtrim(upper(app_rec. ISS_ADDR1))),
    ltrim(rtrim(upper(app_rec. ISS_ADDR2))),
    ltrim(rtrim(upper(app_rec. ISS_CITY))),
    ltrim(rtrim(upper(app_rec. ISS_PROVINCE))),
    ltrim(rtrim(upper(app_rec. ISS_COUNTRY))),
    ltrim(rtrim(upper(app_rec. ISS_POSTAL_CODE))),
    ltrim(rtrim(upper(app_rec. RO_POSTAL_CODE ))),
    ltrim(rtrim(upper(app_rec. RE_SAME))),
    ltrim(rtrim(upper(app_rec. RE_NAME))),
    ltrim(rtrim(upper(app_rec. RE_ADDR1 ))),
    ltrim(rtrim(upper(app_rec. RE_ADDR2))),
    ltrim(rtrim(upper(app_rec. RE_CITY))),
    ltrim(rtrim(upper(app_rec. RE_PROVINCE))),
    ltrim(rtrim(upper(app_rec. RE_COUNTRY))),
    ltrim(rtrim(upper(app_rec. RE_POSTAL_CODE))),
    ltrim(rtrim(upper(app_rec. RE_TEL))),
    ltrim(rtrim(upper(app_rec. RE_EMAIL ))),
    ltrim(rtrim(upper(app_rec. PAY_SAME ))),
    ltrim(rtrim(upper(app_rec. PAY_NAME ))),
    ltrim(rtrim(upper(app_rec. PAY_ADDR1))),
    ltrim(rtrim(upper(app_rec. PAY_ADDR2))),
    ltrim(rtrim(upper(app_rec. PAY_CITY))),
    ltrim(rtrim(upper(app_rec. PAY_PROVINCE))),
    ltrim(rtrim(upper(app_rec. PAY_COUNTRY))),
    ltrim(rtrim(upper(app_rec. PAY_POSTAL_CODE))),
    ltrim(rtrim(upper(app_rec. PAY_TEL))),
    ltrim(rtrim(upper(app_rec.PAY_EMAIL))),
    ltrim(rtrim(upper(app_rec.ATTESTATION))),
  attest_date,
  sysdate /*CREATION_DATE */,
  get_userid /*CREATED_BY */ ,
  sysdate /* LAST_UPDATE_DATE  */,
  get_userid /* LAST_UPDATED_BY  */ ,
  get_loginid /* LAST_UPDATE_LOGIN */,
  null  /*BLUE_CARD_EDOC_ID */,
  null  /*COR_EDOC_ID */,
  null  /*APPLICATION_EDOC_ID */ );

commit;

end;

procedure process_iface(p_NRMI_APPLICATION_ID in number, NRMI_CERTIFICATES_ID out number,p_NRMI_VESSELS_ID out number, p_return_code out varchar2, p_return_message out varchar2) is

cursor get_iface is select * from NRMI_APPLICATION_IFACE where NRMI_APPLICATION_ID = p_NRMI_APPLICATION_ID;
iface_rec get_iface%rowtype;



P_NRMI_CERTIFICATES_ID number;

ro_country_code varchar2(2);
req_country_code varchar2(2);
pay_country_code varchar2(2);
club_country_code varchar2(2);

v_imo_number integer :=null;
v_gross_tons number:=null;

address_string varchar2(300) := null;
port_of_reg_string varchar2(50) := NULL;
club_id number:=null;
club_address_string varchar2(300):=null;
req_co_name varchar2(100) := null;
bill_to_name  varchar2(100) := null;

kp_name varchar2(100);

begin

p_return_code:=c_success;
p_return_message:='Normal';

P_NRMI_CERTIFICATES_ID:=null;

open get_iface;
fetch get_iface into iface_rec;
close get_iface;

if upper(iface_rec.PAY_POSTAL_CODE)='N/A' then
iface_rec.PAY_POSTAL_CODE:=null;
end if;
if upper(iface_rec.PAY_PROVINCE)='N/A' then
iface_rec.PAY_PROVINCE:=null;
end if;

if upper(iface_rec.RE_POSTAL_CODE)='N/A' then
iface_rec.RE_POSTAL_CODE:=null;
end if;
if upper(iface_rec.RE_PROVINCE)='N/A' then
iface_rec.RE_PROVINCE:=null;
end if;

if upper(iface_rec.RO_POSTAL_CODE)='N/A' then
iface_rec.RO_POSTAL_CODE:=null;
end if;
if upper(iface_rec.RO_PROVINCE)='N/A' then
iface_rec.RO_PROVINCE:=null;
end if;


if upper(iface_rec.ISS_POSTAL_CODE)='N/A' then
iface_rec.ISS_POSTAL_CODE:=null;
end if;
if upper(iface_rec.ISS_PROVINCE)='N/A' then
iface_rec.ISS_PROVINCE:=null;
end if;

req_co_name:=upper(nvl(iface_rec.RE_NAME,iface_rec.RO_NAME));
--bill_to_name:=upper(nvl(iface_rec.PAY_NAME,iface_rec.RE_NAME));
bill_to_name:=upper(iface_rec.PAY_NAME);

dbms_output.put_line(NVL(bill_to_name,'XXXX')||' '||req_co_name);

if bill_to_name = req_co_name then
bill_to_name:=null;
end if;

/* find out if there are any pending orders if so then append new vessels to them*/

P_NRMI_CERTIFICATES_ID:= nrmi_certs.get_pending_orders(bill_to_name,req_co_name);

dbms_output.put_line(nvl(TO_CHAR(P_NRMI_CERTIFICATES_ID),'Not Found'));

if req_co_name is null then
req_co_name:=upper(iface_rec.RO_NAME);
end if;


if bill_to_name is null then
bill_to_name:=upper(iface_rec.RO_NAME);
end if;







/* if not then create new order */
if P_NRMI_CERTIFICATES_ID is null then

SELECT NRMI_CERTIFICATES_ID_SEQ.NEXTVAL INTO P_NRMI_CERTIFICATES_ID FROM dual;

NRMI_CERTIFICATES_ID:=P_NRMI_CERTIFICATES_ID;

--dbms_output.put_line(iface_rec.pay_same||'   '|| iface_rec.RE_SAME); 

if upper(iface_rec.pay_same)='YES' then
 iface_rec.pay_same := 'ON';
end if;

if upper(iface_rec.RE_SAME)='YES' then
 iface_rec.RE_SAME := 'ON';
end if;

if upper(iface_rec.pay_same)='NO' then
 iface_rec.pay_same := 'OFF';
end if;

if upper(iface_rec.RE_SAME)='NO' then
 iface_rec.RE_SAME := 'OFF';
end if;


if  iface_rec.RE_SAME = 'ON' and  ltrim(rtrim(iface_rec.RE_NAME)) is not null then
 iface_rec.RE_SAME := 'OFF';
end if;

/*
if upper(nvl(iface_rec.RE_name,'xx'))=upper(iface_rec.RO_NAME) and 
upper(nvl(iface_rec.RE_ADDR1,'xx'))=upper(iface_rec.RO_ADDR1) and
upper(nvl(iface_rec.RE_ADDR2,'xx'))=upper(nvl(iface_rec.RO_ADDR2,'xx'))
then
 iface_rec.RE_same := 'ON';
   iface_rec.RE_NAME:=null;
   iface_rec.RE_ADDR1:=null;
  iface_rec.RE_ADDR2:=null;
   iface_rec.RE_CITY:=null;
  iface_rec.RE_PROVINCE:=null;
   iface_rec.RE_POSTAL_CODE :=null;
   req_country_code :=null;
   iface_rec.RE_EMAIL:=null;
  iface_rec.RE_TEL :=null;
else
 iface_rec.RE_same := 'OFF';
end if;
*/

if upper(nvl(iface_rec.RE_name,'xx'))=upper(iface_rec.PAY_NAME) and 
upper(nvl(iface_rec.RE_ADDR1,'xx'))=upper(iface_rec.PAY_ADDR1) and
upper(nvl(iface_rec.RE_ADDR2,'xx'))=upper(nvl(iface_rec.PAY_ADDR2,'xx'))
 then
 iface_rec.pay_same := 'ON';
   iface_rec.pay_NAME:=null;
   iface_rec.pay_ADDR1:=null;
  iface_rec.pay_ADDR2:=null;
   iface_rec.pay_CITY:=null;
  iface_rec.pay_PROVINCE:=null;
   iface_rec.pay_POSTAL_CODE :=null;
   pay_country_code :=null;
   iface_rec.pay_EMAIL:=null;
  iface_rec.pay_TEL :=null;
else
 iface_rec.pay_same := 'OFF';
end if;


--dbms_output.put_line('NRMI_APPLICATION_ID='||to_char(p_NRMI_APPLICATION_ID)||' pay_same '||iface_rec.pay_same||'   re_same '||iface_rec.RE_SAME); 

if iface_rec.pay_same = 'ON' and iface_rec.RE_SAME = 'ON' 
or (iface_rec.pay_same = 'YES' and iface_rec.RE_SAME = 'YES' ) then 

ro_country_code:=get_country_code(iface_rec.RO_COUNTRY);

INSERT INTO VSSL.NRMI_CERTIFICATES (
   NRMI_CERTIFICATES_ID, BT_CUSTOMER_NAME, BT_ADDRESS1, 
   BT_ADDRESS2, BT_ADDRESS3, BT_CITY, 
   BT_PROVINCE, BT_POSTAL_CODE, BT_COUNTRY, 
   BT_EMAIL_ADDRESS, CUSTOMER_ID, CUSTOMER_BILL_TO_SITE_ID, 
   CUSTOMER_SHIP_TO_SITE_ID, RA_CUSTOMER_TRX_ID, OE_HEADER_ID, 
   STATUS, RQ_NAME, RQ_ADDRESS1, 
   RQ_ADDRESS2, RQ_CITY, RQ_PROVINCE, 
   RQ_POSTAL_CODE, RQ_COUNTRY, RQ_TELEPHONE, RQ_EMAIL_ADDRESS,
   CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, 
   LAST_UPDATED_BY, LAST_UPDATE_LOGIN, RQ_ADDRESS3, 
   INVOICE_EDOC_ID, INVOICE_SENT_DATE) 
VALUES ( P_NRMI_CERTIFICATES_ID /* NRMI_CERTIFICATES_ID */,
 null  /* BT_CUSTOMER_NAME */,
  null /* BT_ADDRESS1 */,
  null /* BT_ADDRESS2 */,
  null /* BT_ADDRESS3 */,
  null /* BT_CITY */,
  null /* BT_PROVINCE */,
  null /* BT_POSTAL_CODE */,
 null /* BT_COUNTRY */,
 null /* EMAIL_ADDRESS */,
 null /* CUSTOMER_ID */,
 null /* CUSTOMER_BILL_TO_SITE_ID */,
 null /* CUSTOMER_SHIP_TO_SITE_ID */,
 null /* RA_CUSTOMER_TRX_ID */,
 null /* OE_HEADER_ID */,
 'Received' /* STATUS */,
 upper(  rtrim(ltrim(iface_rec.RO_NAME))) /* RQ_NAME */,
  upper( iface_rec.Ro_ADDR1) /* RQ_ADDRESS1 */,
  upper(iface_rec.Ro_ADDR2) /* RQ_ADDRESS2 */,
   upper(iface_rec.RO_CITY ) /* RQ_CITY */,
  upper(iface_rec.RO_PROVINCE) /* RQ_PROVINCE */,
  upper( iface_rec.RO_POSTAL_CODE) /* RQ_POSTAL_CODE */,
   ro_country_code /* RQ_COUNTRY */,
     iface_rec.RO_TEL /* RQ_TELEPHONE */,
   upper(replace(iface_rec.RO_EMAIL,';',null)),
sysdate /* CREATION_DATE */,
get_userid /* CREATED_BY */,
sysdate  /* LAST_UPDATE_DATE */,
get_userid /* LAST_UPDATED_BY */,
get_loginid /* LAST_UPDATE_LOGIN */,
null  /* RQ_ADDRESS3 */,
null /* INVOICE_EDOC_ID */,
null /* INVOICE_SENT_DATE */ );
elsif (iface_rec.pay_same = 'ON' and iface_rec.RE_SAME = 'OFF' ) 
or (iface_rec.pay_same = 'YES' and iface_rec.RE_SAME = 'NO' ) then  

pay_country_code:=get_country_code(iface_rec.pay_COUNTRY);
ro_country_code:=get_country_code(iface_rec.RO_COUNTRY);
req_country_code:=get_country_code(iface_rec.RE_COUNTRY);

INSERT INTO VSSL.NRMI_CERTIFICATES (
   NRMI_CERTIFICATES_ID, BT_CUSTOMER_NAME, BT_ADDRESS1, 
   BT_ADDRESS2, BT_ADDRESS3, BT_CITY, 
   BT_PROVINCE, BT_POSTAL_CODE, BT_COUNTRY, 
   BT_EMAIL_ADDRESS, CUSTOMER_ID, CUSTOMER_BILL_TO_SITE_ID, 
   CUSTOMER_SHIP_TO_SITE_ID, RA_CUSTOMER_TRX_ID, OE_HEADER_ID, 
   STATUS, RQ_NAME, RQ_ADDRESS1, 
   RQ_ADDRESS2, RQ_CITY, RQ_PROVINCE, 
   RQ_POSTAL_CODE, RQ_COUNTRY, RQ_EMAIL_ADDRESS, RQ_TELEPHONE,
   CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, 
   LAST_UPDATED_BY, LAST_UPDATE_LOGIN, RQ_ADDRESS3, 
   INVOICE_EDOC_ID, INVOICE_SENT_DATE) 
VALUES ( P_NRMI_CERTIFICATES_ID /* NRMI_CERTIFICATES_ID */,
   null  /* BT_CUSTOMER_NAME */,
   null /* BT_ADDRESS1 */,
  null /* BT_ADDRESS2 */,
  null /* BT_ADDRESS3 */,
  null /* BT_CITY */,
  null /* BT_PROVINCE */,
  null /* BT_POSTAL_CODE */,
  null /* BT_COUNTRY */,
 null /* EMAIL_ADDRESS */,
 null /* CUSTOMER_ID */,
 null /* CUSTOMER_BILL_TO_SITE_ID */,
 null /* CUSTOMER_SHIP_TO_SITE_ID */,
 null /* RA_CUSTOMER_TRX_ID */,
 null /* OE_HEADER_ID */,
 'Received' /* STATUS */,
 upper( ltrim(rtrim( iface_rec.RE_NAME))) /* RQ_NAME */,
 upper(  iface_rec.RE_ADDR1) /* RQ_ADDRESS1 */,
 upper( iface_rec.RE_ADDR2) /* RQ_ADDRESS2 */,
 upper( iface_rec.RE_CITY) /* RQ_CITY */,
 upper( iface_rec.RE_PROVINCE) /* RQ_PROVINCE */,
  upper( iface_rec.RE_POSTAL_CODE) /* RQ_POSTAL_CODE */,
   req_country_code /* RQ_COUNTRY */,
  upper( replace(iface_rec.RE_EMAIL,';',null)),
  iface_rec.RE_TEL /* RQ_TELEPHONE */,
sysdate /* CREATION_DATE */,
get_userid /* CREATED_BY */,
sysdate  /* LAST_UPDATE_DATE */,
get_userid /* LAST_UPDATED_BY */,
get_loginid /* LAST_UPDATE_LOGIN */,
null  /* RQ_ADDRESS3 */,
null /* INVOICE_EDOC_ID */,
null /* INVOICE_SENT_DATE */ );

elsif (iface_rec.pay_same = 'OFF' and iface_rec.RE_SAME = 'OFF') 
or (iface_rec.pay_same = 'NO' and iface_rec.RE_SAME = 'NO' ) then 

pay_country_code:=get_country_code(iface_rec.pay_COUNTRY);
req_country_code:=get_country_code(iface_rec.RE_COUNTRY);

INSERT INTO VSSL.NRMI_CERTIFICATES (
   NRMI_CERTIFICATES_ID, BT_CUSTOMER_NAME, BT_ADDRESS1, 
   BT_ADDRESS2, BT_ADDRESS3, BT_CITY, 
   BT_PROVINCE, BT_POSTAL_CODE, BT_COUNTRY, 
   BT_EMAIL_ADDRESS, CUSTOMER_ID, CUSTOMER_BILL_TO_SITE_ID, 
   CUSTOMER_SHIP_TO_SITE_ID, RA_CUSTOMER_TRX_ID, OE_HEADER_ID, 
   STATUS, RQ_NAME, RQ_ADDRESS1, 
   RQ_ADDRESS2, RQ_CITY, RQ_PROVINCE, 
   RQ_POSTAL_CODE, RQ_COUNTRY, RQ_TELEPHONE, 
   CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, 
   LAST_UPDATED_BY, LAST_UPDATE_LOGIN, RQ_ADDRESS3, 
   INVOICE_EDOC_ID, INVOICE_SENT_DATE, RQ_EMAIL_ADDRESS) 
VALUES (P_NRMI_CERTIFICATES_ID /* NRMI_CERTIFICATES_ID */,
 upper(ltrim(rtrim(iface_rec.pay_NAME ))) /* BT_CUSTOMER_NAME */,
 upper(iface_rec.pay_ADDR1) /* BT_ADDRESS1 */,
 upper( iface_rec.pay_ADDR2) /* BT_ADDRESS2 */,
 null /* BT_ADDRESS3 */,
 upper(iface_rec.pay_CITY ) /* BT_CITY */,
Upper( iface_rec.pay_PROVINCE) /* BT_PROVINCE */,
 upper(iface_rec.pay_POSTAL_CODE ) /* BT_POSTAL_CODE */,
 pay_country_code /* BT_COUNTRY */,
 upper( iface_rec.pay_EMAIL)  /* BT_EMAIL_ADDRESS */,
null /* CUSTOMER_ID */,
null /* CUSTOMER_BILL_TO_SITE_ID */,
null /* CUSTOMER_SHIP_TO_SITE_ID */,
null /* RA_CUSTOMER_TRX_ID */,
null /* OE_HEADER_ID */,
'Received'  /* STATUS */,
 upper( ltrim(rtrim(iface_rec.Re_NAME))) /* RQ_NAME */,
  upper(    iface_rec.Re_ADDR1) /* RQ_ADDRESS1 */,
   upper(  iface_rec.Re_ADDR2 )/* RQ_ADDRESS2 */,
   upper(   iface_rec.Re_CITY) /* RQ_CITY */,
  upper(  iface_rec.Re_PROVINCE )/* RQ_PROVINCE */,
   upper(   iface_rec.Re_POSTAL_CODE) /* RQ_POSTAL_CODE */,
    req_country_code /* RQ_COUNTRY */,
      iface_rec.Re_TEL /* RQ_TELEPHONE */,
 sysdate /* CREATION_DATE */,
get_userid /* CREATED_BY */,
 sysdate/* LAST_UPDATE_DATE */,
get_userid /* LAST_UPDATED_BY */,
get_loginid /* LAST_UPDATE_LOGIN */,
null  /* RQ_ADDRESS3 */,
null  /* INVOICE_EDOC_ID */,
null  /* INVOICE_SENT_DATE */,
   replace(iface_rec.Re_EMAIL,';',null) /* RQ_EMAIL_ADDRESS */ );

-- dbms_output.put_line('Insert into NRMI_CERTIFICATES'); 
elsif (iface_rec.pay_same = 'OFF' and iface_rec.RE_SAME = 'ON') 
or (iface_rec.pay_same = 'NO' and iface_rec.RE_SAME = 'NO' ) then 

pay_country_code:=get_country_code(iface_rec.pay_COUNTRY);
req_country_code:=get_country_code(iface_rec.RE_COUNTRY);

INSERT INTO VSSL.NRMI_CERTIFICATES (
   NRMI_CERTIFICATES_ID, BT_CUSTOMER_NAME, BT_ADDRESS1, 
   BT_ADDRESS2, BT_ADDRESS3, BT_CITY, 
   BT_PROVINCE, BT_POSTAL_CODE, BT_COUNTRY, 
   BT_EMAIL_ADDRESS, CUSTOMER_ID, CUSTOMER_BILL_TO_SITE_ID, 
   CUSTOMER_SHIP_TO_SITE_ID, RA_CUSTOMER_TRX_ID, OE_HEADER_ID, 
   STATUS, RQ_NAME, RQ_ADDRESS1, 
   RQ_ADDRESS2, RQ_CITY, RQ_PROVINCE, 
   RQ_POSTAL_CODE, RQ_COUNTRY, RQ_TELEPHONE, 
   CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, 
   LAST_UPDATED_BY, LAST_UPDATE_LOGIN, RQ_ADDRESS3, 
   INVOICE_EDOC_ID, INVOICE_SENT_DATE, RQ_EMAIL_ADDRESS) 
VALUES (P_NRMI_CERTIFICATES_ID /* NRMI_CERTIFICATES_ID */,
 upper(ltrim(rtrim(iface_rec.pay_NAME ))) /* BT_CUSTOMER_NAME */,
 upper(iface_rec.pay_ADDR1) /* BT_ADDRESS1 */,
 upper( iface_rec.pay_ADDR2) /* BT_ADDRESS2 */,
 null /* BT_ADDRESS3 */,
 upper(iface_rec.pay_CITY ) /* BT_CITY */,
Upper( iface_rec.pay_PROVINCE) /* BT_PROVINCE */,
 upper(iface_rec.pay_POSTAL_CODE ) /* BT_POSTAL_CODE */,
 pay_country_code /* BT_COUNTRY */,
 upper( iface_rec.pay_EMAIL)  /* BT_EMAIL_ADDRESS */,
null /* CUSTOMER_ID */,
null /* CUSTOMER_BILL_TO_SITE_ID */,
null /* CUSTOMER_SHIP_TO_SITE_ID */,
null /* RA_CUSTOMER_TRX_ID */,
null /* OE_HEADER_ID */,
'Received'  /* STATUS */,
 upper( ltrim(rtrim(iface_rec.Re_NAME))) /* RQ_NAME */,
  upper(    iface_rec.Re_ADDR1) /* RQ_ADDRESS1 */,
   upper(  iface_rec.Re_ADDR2 )/* RQ_ADDRESS2 */,
   upper(   iface_rec.Re_CITY) /* RQ_CITY */,
  upper(  iface_rec.Re_PROVINCE )/* RQ_PROVINCE */,
   upper(   iface_rec.Re_POSTAL_CODE) /* RQ_POSTAL_CODE */,
    req_country_code /* RQ_COUNTRY */,
      iface_rec.Re_TEL /* RQ_TELEPHONE */,
 sysdate /* CREATION_DATE */,
get_userid /* CREATED_BY */,
 sysdate/* LAST_UPDATE_DATE */,
get_userid /* LAST_UPDATED_BY */,
get_loginid /* LAST_UPDATE_LOGIN */,
null  /* RQ_ADDRESS3 */,
null  /* INVOICE_EDOC_ID */,
null  /* INVOICE_SENT_DATE */,
   replace(iface_rec.Re_EMAIL,';',null) /* RQ_EMAIL_ADDRESS */ );

-- dbms_output.put_line('Insert into NRMI_CERTIFICATES'); 
else
p_return_code:='FAILURE';
p_return_message:='Did not insert parent record into NRMI_CERTIFICATES';
rollback;
return;
end if;
--commit;

/* now add new vessel */

end if;


NRMI_CERTIFICATES_ID:=P_NRMI_CERTIFICATES_ID;

address_string:=arp_addr_label_pkg.format_address(
    null,
    upper(iface_rec.Ro_ADDR1),
    upper(iface_rec.Ro_ADDR2),
    null,
    null ,
     upper(iface_rec.RO_CITY),
    null,
     upper(iface_rec.RO_PROVINCE),
     null,
     upper(iface_rec.RO_POSTAL_CODE),
    get_territory_short_name(ro_country_code),
    ro_country_code,
        null,
        null,
    null,
        null,
        null,
    null  /*default_country_code */,
     null   /* default_country_desc */ ,
    'N' /*print_home_country_flag*/ ,
    'N' /*    print_default_attn_flag */ ,
   50 /* p_width */ ,
     6  /* p_height_min */,
      9 /*  p_height_max */);

begin
v_imo_number :=to_number(iface_rec.IMO_NUMBER);
exception
when others then
v_imo_number:=null;
end;

begin
v_gross_tons :=to_number(replace(iface_rec.gross_tons,',',null));
exception
when others then
v_gross_tons:=null;
end;

begin
port_of_reg_string :=validate_port(iface_rec.PORT_OF_REGISTRY);
exception when others then
port_of_reg_string:=null;
end;

begin
club_id:=null;
club_country_code:=get_country_code(iface_rec.ISS_COUNTRY);
club_address_string:=arp_addr_label_pkg.format_address(
    null,
    upper(iface_rec.ISS_ADDR1),
    upper(iface_rec.ISS_ADDR2),
    null,
    null ,
    upper( iface_rec.ISS_CIITY),
    null,
     upper(iface_rec.ISS_PROVINCE),
    upper( iface_rec.ISS_PROVINCE),
     upper(iface_rec.ISS_POSTAL_CODE),
    get_territory_short_name(club_country_code),
    ro_country_code,
        null,
        null,
    null,
        null,
        null,
    null  /*default_country_code */,
     null   /* default_country_desc */ ,
    'N' /*print_home_country_flag*/ ,
    'N' /*    print_default_attn_flag */ ,
   50 /* p_width */ ,
     6  /* p_height_min */,
      9 /*  p_height_max */);

club_id:=validate_pi_club(iface_rec.ISS_NAME,club_address_string);
exception when others then
club_id:=null;
end;


SELECT NRMI_VESSELS_ID_SEQ.NEXTVAL INTO p_NRMI_VESSELS_ID FROM dual;

begin
INSERT INTO VSSL.NRMI_VESSELS (
   NRMI_VESSELS_ID, NRMI_CERTIFICATES_ID, VESSEL_NAME, 
   VESSEL_IMO_NUMBER, REGISTERED_OWNER_NAME, CERTIFICATE_NUMBER, 
   P_AND_I_CLUB_ID, COR_EDOC_ID, BLUE_CARD_EDOC_ID, 
   OFFICIAL_NUMBER, GROSS_TONNAGE, PORT_OF_REGISTRY, 
   ADDRESS_REG_OWN, ISSUE_DATE, EFFECTIVE_DATE, 
   EXPIRATION_DATE, CERTIFICATE_EDOC_ID, CREATION_DATE, 
   CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY, 
   LAST_UPDATE_LOGIN, APPLICATION_EDOC_ID, CERTIFICATE_SENT_DATE, 
   NRMI_APPLICATION_IFACE_ID, RO_EMAIL_ADDRESS,STATUS) 
VALUES ( p_NRMI_VESSELS_ID  /* NRMI_VESSELS_ID */,
 P_NRMI_CERTIFICATES_ID   /* NRMI_CERTIFICATES_ID */,
 upper(iface_rec.VESSEL_NAME) /* VESSEL_NAME */,
 v_imo_number  /* VESSEL_IMO_NUMBER */,
 upper(iface_rec.RO_NAME) /* REGISTERED_OWNER_NAME */,
 null /* CERTIFICATE_NUMBER */,
 club_id /* P_AND_I_CLUB_ID */,
 iface_rec.COR_EDOC_ID   /* COR_EDOC_ID */,
 iface_rec.BLUE_CARD_EDOC_ID /* BLUE_CARD_EDOC_ID */,
 upper(iface_rec.OFFICIAL_NUMBER) /* OFFICIAL_NUMBER */,
 v_gross_tons /* GROSS_TONNAGE */,
 upper(port_of_reg_string) /* PORT_OF_REGISTRY */,
 address_string /* ADDRESS_REG_OWN */,
 null /* ISSUE_DATE */,
 null /* EFFECTIVE_DATE */, --'20-FEB-2017'  -- sgoel T20180124.0030 value changed to null --sarora hdt 34601 change year to 2017- ZK Changed 02102016  '14-APR-2015'  
 null /* EXPIRATION_DATE */,--'20-FEB-2018' -- sgoel T20180124.0030 value changed to null --sarora hdt34601 cahnge year to 2018- ZK Changed 02102016  '20-FEB-2016'
 null /* CERTIFICATE_EDOC_ID */,
 sysdate   /* CREATION_DATE */,
 get_userid   /* CREATED_BY */,
 sysdate   /* LAST_UPDATE_DATE */,
 get_userid   /* LAST_UPDATED_BY */,
 get_loginid   /* LAST_UPDATE_LOGIN */,
 iface_rec.APPLICATION_EDOC_ID     /* APPLICATION_EDOC_ID */,
 null   /* CERTIFICATE_SENT_DATE */,
 iface_rec.NRMI_APPLICATION_IFACE_ID /* NRMI_APPLICATION_IFACE_ID */,
 upper(iface_rec.RO_EMAIL) /* RO_EMAIL_ADDRESS */ 
 ,'A' /* STATUS */);
exception when others
then
--raise_application_error(-20001,'Error Inserting into NRMI_VESSELS '||sqlerrm);
p_return_code:='FAILURE';
p_return_message:='Did not insert parent record into NRMI_VESSELS ('||v_imo_number||')';
rollback;
return;
end;

/* check for existing known parties */

kp_name:=ltrim(rtrim(iface_rec.ATTESTATION_NAME));

if not  know_party_exists(kp_name,P_NRMI_CERTIFICATES_ID) then
/* if none then add them */

INSERT INTO VSSL.NRMI_KNOWN_PARTIES (
   NRMI_KP_ID, NRMI_CERTIFICATES_ID, KP_NAME, 
   CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, 
   LAST_UPDATED_BY, LAST_UPDATE_LOGIN) 
VALUES ( null /* NRMI_KP_ID */,
P_NRMI_CERTIFICATES_ID   /* NRMI_CERTIFICATES_ID */,
upper(kp_name)  /* KP_NAME */,
sysdate /* CREATION_DATE */,
get_userid  /* CREATED_BY */,
 sysdate  /* LAST_UPDATE_DATE */,
get_userid  /* LAST_UPDATED_BY */,
get_loginid /* LAST_UPDATE_LOGIN */ );
end if;

commit;

end;



function get_country_code(p_country_name in varchar) return varchar2 is

cursor get_code_by_name is
select  terr.territory_code  from
       FND_TERRITORIES TERR
       ,FND_TERRITORIES_TL TERR_TL
      WHERE  terr.territory_code = terr_tl.territory_code
      and utl_match.jaro_winkler_similarity(upper(p_country_name),upper(TERRITORY_SHORT_NAME)) > 90
      order by utl_match.jaro_winkler_similarity(upper(p_country_name),upper(TERRITORY_SHORT_NAME)) desc ;

cursor get_code_by_abbr is
select  terr.territory_code  from
       FND_TERRITORIES TERR
       ,FND_TERRITORIES_TL TERR_TL
      WHERE  terr.territory_code = terr_tl.territory_code and
       terr.territory_code =   replace(p_country_name,'.','');

ctry_code varchar2(2) :=null;

begin

if p_country_name is null or 
  p_country_name = 'US' or
  p_country_name = 'USA' or
  p_country_name = 'U.S.A.' then
  --return('US');
  return null;
end if;

open get_code_by_name;
fetch get_code_by_name into ctry_code;
close get_code_by_name;

if ctry_code is null then
open get_code_by_abbr;
fetch get_code_by_abbr into ctry_code;
close get_code_by_abbr;
end if;


return ctry_code;

end;

function validate_port(p_port_name in varchar2) return varchar2 is

cursor get_port is
select  port_name from NRMI_PORTS_OF_REGISTRY
where   utl_match.jaro_winkler_similarity(upper(port_name),upper(p_port_name)) > 90
order by utl_match.jaro_winkler_similarity(upper(port_name),upper(p_port_name)) desc;

port_name varchar2(100);

begin 

open get_port;
fetch get_port into port_name;
close get_port;

return port_name;

end;

function validate_pi_club(c_name in varchar2, p_address in varchar2) return number is

cursor get_pi is select id from VSSL_CERT_CLUB
where   utl_match.jaro_winkler_similarity(upper(c_name),upper(NAME)) > 90
and   utl_match.jaro_winkler_similarity(upper(p_address),upper(ADDRESS)) > 90;

club_id number:=null;

begin

open get_pi;
fetch get_pi into club_id;
close get_pi;

return club_id;
end;

function get_pending_orders(bill_to_name in varchar2, request_name in varchar2) return number is

cursor get_pending_orders(p_bill_to_customer_name in varchar2, request_customer_name in varchar2) is
select NRMI_CERTIFICATES_ID from NRMI_CERTIFICATES
where utl_match.jaro_winkler_similarity(upper(RQ_NAME),upper(request_customer_name))>93 and
utl_match.jaro_winkler_similarity(upper(nvl(BT_CUSTOMER_NAME,'XX')),upper(nvl(p_bill_to_customer_name,'XX')))>93
and upper(status) = 'RECEIVED'
order by NRMI_CERTIFICATES_ID;

P_NRMI_CERTIFICATES_ID number:=null;

begin


open get_pending_orders(bill_to_name,request_name);
fetch get_pending_orders into P_NRMI_CERTIFICATES_ID;
close get_pending_orders;

return P_NRMI_CERTIFICATES_ID;

end;

function know_party_exists(P_NAME in varchar2 ,P_NRMI_CERTIFICATES_ID in number) return boolean is

cursor get_kp is  select count(*) from NRMI_KNOWN_PARTIES
where KP_NAME = nvl(P_NAME,'xx')  and NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;

r_count number:=0;

begin

open get_kp;
fetch get_kp into r_count;
close get_kp;

if r_count > 0 then return(true); end if;

return false;

end;


procedure advance_workflow(P_NRMI_CERTIFICATES_ID in number, p_return_code out varchar2, p_return_message out varchar2) is

  cursor get_cert is select * from NRMI_CERTIFICATES where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;
  cert_rec get_cert%rowtype;

cursor get_workflow(p_status_code in varchar2) is
select * from nrmi_workflow where STATUS = p_status_code;

current_status get_workflow%rowtype;

cursor get_next_workflow(p_next_step in integer)
is select * from nrmi_workflow where workflow_step=p_next_step;

next_status get_workflow%rowtype;

begin
p_return_code:=c_success;
p_return_message:='Normal';

open get_cert;
fetch get_cert into cert_rec;
close get_cert;

open get_workflow(cert_rec.status);
fetch get_workflow into current_status;
close get_workflow;

if current_status.next_step is not null then

open get_next_workflow(current_status.next_step);
fetch get_next_workflow into next_status;
close get_next_workflow;

begin
update NRMI_CERTIFICATES
set status=next_status.status
where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;
exception when others
then
rollback;
p_return_code:=c_error;
p_return_message:='Error Updating Workflow: '||sqlerrm;
end;
commit;

end if;

end;


function get_tc_status_for_req(P_NRMI_CERTIFICATES_ID in number) return varchar2 is

cursor get_cert is select * from NRMI_CERTIFICATES where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;

cert_rec get_cert%rowtype;


cursor get_vessel is select * from NRMI_VESSELS where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;

cursor get_known_parties is select * from NRMI_KNOWN_PARTIES where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;


xref world_check_iface.WC_EXTERNAL_XREF_REC;
req world_check_iface.WC_SCREENING_REQUEST_REC;

overall_status varchar2(30):='Approved';
item_status varchar2(30):='Pending';

begin
--dbms_output.put_line('Start');

open get_cert;
fetch get_cert into cert_rec;
close get_cert;

req.WC_SCREENING_REQUEST_ID:=null;
/*xref.WC_SCREENING_REQUEST_ID:=null;
xref.source_table:='NRMI_CERTIFICATES_rq';
xref.source_table_column:='NRMI_CERTIFICATES_ID';
xref.source_table_id:=P_NRMI_CERTIFICATES_ID;
item_status :=world_check_iface.get_wc_status(xref ,  req );
*/ -- OWS 12112019

item_status :=rmi_ows_common_util.get_wc_status('NRMI_CERTIFICATES','NRMI_CERTIFICATES_ID',P_NRMI_CERTIFICATES_ID,cert_rec.RQ_NAME); -- OWS 12112019

--dbms_output.put_line('1'||item_status);
if item_status ='NO_RECORD'  
then
overall_status:='Re-Run T.C.';
elsif item_status !='Approved'  
then
overall_status:='Pending';
return(overall_status);
end if;

if cert_rec.BT_CUSTOMER_NAME is not null then
req.WC_SCREENING_REQUEST_ID:=null;
/*
xref.WC_SCREENING_REQUEST_ID:=null;
xref.source_table := 'NRMI_CERTIFICATES_bt';
xref.source_table_column:='NRMI_CERTIFICATES_ID';
xref.source_table_id:=P_NRMI_CERTIFICATES_ID;
item_status :=world_check_iface.get_wc_status(xref ,  req );
--dbms_output.put_line('2'||item_status);
*/ -- OWS: 12122019 

item_status :=rmi_ows_common_util.get_wc_status('NRMI_CERTIFICATES','NRMI_CERTIFICATES_ID',P_NRMI_CERTIFICATES_ID,cert_rec.BT_CUSTOMER_NAME); -- OWS 12112019


if item_status ='NO_RECORD'  
then
overall_status:='Re-Run T.C.';
elsif item_status !='Approved'  
then
overall_status:='Pending';
return(overall_status);
end if;
end if;

/*
req.WC_SCREENING_REQUEST_ID:=null;
xref.WC_SCREENING_REQUEST_ID:=null;
xref.source_table:='AR_CUSTOMERS';
xref.source_table_column:='CUSTOMER_ID';
xref.source_table_id:=cert_rec.CUSTOMER_ID;
item_status :=world_check_iface.get_wc_status(xref ,  req );


if item_status !='Approved'  
then
overall_status:='Pending';
return(overall_status);
end if;*/

--dbms_output.put_line('3'||item_status);
for x in get_vessel loop

req.WC_SCREENING_REQUEST_ID:=null;
/*
xref.WC_SCREENING_REQUEST_ID:=null;
xref.source_table:='NRMI_VESSELS_vssl';
xref.source_table_column:='NRMI_VESSELS_ID';
xref.source_table_id:=x.NRMI_VESSELS_ID;
item_status :=world_check_iface.get_wc_status(xref ,  req );
--dbms_output.put_line('4'||item_status||' '||to_char(xref.source_table_id));
*/ -- OWS 12112019

item_status :=rmi_ows_common_util.get_wc_status('NRMI_CERTIFICATES','NRMI_VESSELS_ID',P_NRMI_CERTIFICATES_ID,x.VESSEL_NAME); -- OWS 12112019


if item_status ='NO_RECORD'  
then
overall_status:='Re-Run T.C.';
elsif item_status !='Approved'  
then
overall_status:='Pending';
return(overall_status);
end if;

req.WC_SCREENING_REQUEST_ID:=null;
/*xref.WC_SCREENING_REQUEST_ID:=null;
xref.source_table:='NRMI_VESSELS_reg_own';
xref.source_table_column:='NRMI_VESSELS_ID';
xref.source_table_id:=x.NRMI_VESSELS_ID;
item_status :=world_check_iface.get_wc_status(xref ,  req );
--dbms_output.put_line('5'||item_status);
*/ --OWS 12112019

item_status :=rmi_ows_common_util.get_wc_status('NRMI_CERTIFICATES','NRMI_VESSELS_ID',P_NRMI_CERTIFICATES_ID,x.REGISTERED_OWNER_NAME); -- OWS 12112019

if item_status ='NO_RECORD'  
then
overall_status:='Re-Run T.C.';
elsif item_status !='Approved'  
then
overall_status:='Pending';
return(overall_status);
end if;

end loop;

for x in get_known_parties loop

req.WC_SCREENING_REQUEST_ID:=null;
/*
xref.WC_SCREENING_REQUEST_ID:=null;
xref.source_table:='NRMI_VESSELS_KNOWN_PARTY';
xref.source_table_column:='NRMI_KP_ID';
xref.source_table_id:=x.NRMI_KP_ID;
item_status :=world_check_iface.get_wc_status(xref ,  req );
--dbms_output.put_line('6'||item_status);
*/--OWS 12112019

item_status :=rmi_ows_common_util.get_wc_status('NRMI_CERTIFICATES','NRMI_KP_ID',P_NRMI_CERTIFICATES_ID,x.KP_NAME); --OWS 12112019

if item_status ='NO_RECORD'  
then
overall_status:='Re-Run T.C.';
elsif item_status !='Approved'  
then
overall_status:='Pending';
return(overall_status);
end if;

end loop;
return(overall_status);
end;


function cert_order_locked(P_NRMI_CERTIFICATES_ID in number) return boolean is

cursor find_lock is
select 'xx'  from NRMI_CERTIFICATES where NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID for update nowait;

e_resource_busy exception;
pragma exception_init(e_resource_busy,-54);

retval boolean :=FALSE;
begin
begin
  open find_lock;
  close find_lock;
  rollback;
  exception when e_resource_busy then
    retval:=TRUE;
end;
return(retval);
end;

procedure set_tc_to_legal_review(p_wc_screening_request_id in number, p_return_code out varchar2, p_return_message out varchar2) is
v_sql    VARCHAR2(2000):=null;
begin

--dbms_output.put_line ( 'approve_screening_request start');
p_return_code:=c_success;
p_return_message:='Normal';

v_sql:= 'UPDATE VSSL.WC_SCREENING_REQUEST
SET    STATUS = :1,
       STATUS_UPDATED_BY = :2,
       STATUS_DATE= :3
WHERE  WC_SCREENING_REQUEST_ID = :4 '
;
begin
 EXECUTE IMMEDIATE v_sql
 using 
'Legal Review',
get_userid,   --WORLDCHECK_AUTOMATIC_APPROVAL
sysdate, 
 p_wc_screening_request_id;

 exception when others then
 p_return_code:= 'SQLERROR';
 p_return_message := 'approve_screening_request '||SQLERRM;
 rollback;
 return;
 end;
commit;


end;


procedure create_tc_document_references(P_WC_SCREENING_REQUEST_ID in number, p_application_edoc_id in number, p_cor_edoc_id in number, p_bluecard_edoc_id in number, P_RETURN_CODE in out varchar2, P_ERROR_MSG in out varchar2) is

/* this procedure will create references in the trade compliance moduel (WC_REQUEST_DOCUMENTS) for a seafarer from the external system*/
/* passport, COC, Sea-Time, etc -*/

/* return _code  =
SUCCESS
WARNING
ERROR */

   p_name_identifier varchar2(100);
   user_id number;
   login_id number;
begin
p_return_code:=c_success;
 P_ERROR_MSG :=null;

   user_id:= get_userid;
   login_id := get_loginid;



if  p_application_edoc_id is not null then
begin
INSERT INTO VSSL.WC_REQUEST_DOCUMENTS (
   CREATED_BY, CREATION_DATE, DOC_DESCRIPTION, 
   EDOCS_ID, LAST_UPDATE_DATE, LAST_UPDATE_LOGIN, 
   LAST_UPDATED_BY, WC_REQUEST_DOCUMENTS_ID, WC_SCREENING_REQUEST_ID) 
VALUES ( 
 user_id/* CREATED_BY */,
 sysdate /* CREATION_DATE */,
 'MI-237nrmi' /* DOC_DESCRIPTION */,
 p_application_edoc_id/* EDOCS_ID */,
 sysdate /* LAST_UPDATE_DATE */,
 login_id /* LAST_UPDATE_LOGIN */,
 user_id /* LAST_UPDATED_BY */,
 null /* WC_REQUEST_DOCUMENTS_ID */,
 P_WC_SCREENING_REQUEST_ID /* WC_SCREENING_REQUEST_ID */ );
 exception when dup_val_on_index then
null;
when others then
P_ERROR_MSG:='Inserting ID Doc: '||sqlerrm;
rollback;
p_return_code:=c_error;
return;
end;
commit;
end if;

if  p_cor_edoc_id is not null then
begin
INSERT INTO VSSL.WC_REQUEST_DOCUMENTS (
   CREATED_BY, CREATION_DATE, DOC_DESCRIPTION, 
   EDOCS_ID, LAST_UPDATE_DATE, LAST_UPDATE_LOGIN, 
   LAST_UPDATED_BY, WC_REQUEST_DOCUMENTS_ID, WC_SCREENING_REQUEST_ID) 
VALUES ( 
 user_id/* CREATED_BY */,
 sysdate /* CREATION_DATE */,
  'Certificate of Registry' /* DOC_DESCRIPTION */,
 p_cor_edoc_id /* EDOCS_ID */,
 sysdate /* LAST_UPDATE_DATE */,
 login_id /* LAST_UPDATE_LOGIN */,
 user_id /* LAST_UPDATED_BY */,
 null /* WC_REQUEST_DOCUMENTS_ID */,
 P_WC_SCREENING_REQUEST_ID /* WC_SCREENING_REQUEST_ID */ );
exception 
 when dup_val_on_index then
null;
when others then
P_ERROR_MSG:='Inserting Sea Service: '||sqlerrm;
rollback;
p_return_code:=c_error;
return;
end;
commit;
end if;


if  p_bluecard_edoc_id is not null then
begin
INSERT INTO VSSL.WC_REQUEST_DOCUMENTS (
   CREATED_BY, CREATION_DATE, DOC_DESCRIPTION, 
   EDOCS_ID, LAST_UPDATE_DATE, LAST_UPDATE_LOGIN, 
   LAST_UPDATED_BY, WC_REQUEST_DOCUMENTS_ID, WC_SCREENING_REQUEST_ID) 
VALUES ( 
 user_id/* CREATED_BY */,
 sysdate /* CREATION_DATE */,
  'Blue Card' /* DOC_DESCRIPTION */,
p_bluecard_edoc_id /* EDOCS_ID */,
 sysdate /* LAST_UPDATE_DATE */,
 login_id /* LAST_UPDATE_LOGIN */,
 user_id /* LAST_UPDATED_BY */,
 null /* WC_REQUEST_DOCUMENTS_ID */,
 P_WC_SCREENING_REQUEST_ID /* WC_SCREENING_REQUEST_ID */ );
 exception when dup_val_on_index then
null;
when others then
P_ERROR_MSG:='Inserting MI-271: '||sqlerrm;
rollback;
p_return_code:=c_error;
return;
end;
commit;
end if;



end;    


procedure monitor_for_tc_approval is

/* look for orders where trade compliance has been approved by the status has not been advanced */

cursor get_cert_order is
select * from NRMI_CERTIFICATES where status='Pending T.C.';
p_NRMI_CERTIFICATES_ID number; 

cert_update_list iri_stack;

begin


cert_update_list := new iri_stack(null,null,null);
cert_update_list.initialize;

for x in get_cert_order loop

p_NRMI_CERTIFICATES_ID:=x.NRMI_CERTIFICATES_ID;


if get_tc_status_for_req(x.NRMI_CERTIFICATES_ID)='Approved' then
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Updating Status on Order: '||to_char(x.NRMI_CERTIFICATES_ID));
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'Updating Status on Order: '||to_char(x.NRMI_CERTIFICATES_ID));
               END IF;
cert_update_list.push(x.NRMI_CERTIFICATES_ID);               
end if;
end loop;


while not cert_update_list.empty loop

cert_update_list.pop(p_NRMI_CERTIFICATES_ID);
              IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Updating Status for Order: '||to_char(p_NRMI_CERTIFICATES_ID));
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Updating Status for Order: '||to_char(p_NRMI_CERTIFICATES_ID));
               END IF;
begin               
update NRMI_CERTIFICATES
set   status='T.C. Complete'
where NRMI_CERTIFICATES_ID = p_NRMI_CERTIFICATES_ID;
exception when others then
rollback;
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Error: Updating Order Status: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'Error: Updating Order Status: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               END IF;
end;               
commit;
end loop;

exception when others then
rollback;
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('monitor_for_customer_creation: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'monitor_for_customer_creation: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               END IF;



end;


procedure monitor_for_customer_creation is

return_code varchar2(30);
return_message varchar2(300);

p_customer_id  number;
p_bill_to_site_id  number;
p_ship_to_site_id  number;

p_NRMI_CERTIFICATES_ID number; 

cert_update_list iri_stack;
cust_id_list iri_stack;
bill_to_list  iri_stack;
ship_to_list  iri_stack;

cursor get_cert_order is
select * from NRMI_CERTIFICATES where status='T.C. Complete';
begin

cert_update_list := new iri_stack(null,null,null);
cust_id_list := new iri_stack(null,null,null);
bill_to_list := new iri_stack(null,null,null);
ship_to_list := new iri_stack(null,null,null);

cert_update_list.initialize;
cust_id_list.initialize;
bill_to_list.initialize;
ship_to_list.initialize;

for x in get_cert_order loop
p_NRMI_CERTIFICATES_ID:=x.NRMI_CERTIFICATES_ID;

create_customer(x.NRMI_CERTIFICATES_ID, 'N',p_customer_id, p_bill_to_site_id , p_ship_to_site_id,  return_code ,return_message);

              IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Creating Customers for Order: '||to_char(x.NRMI_CERTIFICATES_ID)||' Status: '||return_code||' '||return_message);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Creating Customers for Order: '||to_char(x.NRMI_CERTIFICATES_ID)||' Status: '||return_code||' '||return_message);
               END IF;

if return_code= c_success then

cert_update_list.push(x.NRMI_CERTIFICATES_ID);
cust_id_list.push(p_customer_id);
bill_to_list.push(p_bill_to_site_id);
ship_to_list.push(p_ship_to_site_id);


               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Error: Updating Order Status: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'Error: Updating Order Status: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               END IF;

end if;

end loop;
commit;

while not cert_update_list.empty loop

cert_update_list.pop(p_NRMI_CERTIFICATES_ID);
cust_id_list.pop(p_customer_id);
bill_to_list.pop(p_bill_to_site_id);
ship_to_list.pop(p_ship_to_site_id);


              IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Updating Status for Order: '||to_char(p_NRMI_CERTIFICATES_ID));
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Updating Status for Order: '||to_char(p_NRMI_CERTIFICATES_ID));
               END IF;
begin               
update NRMI_CERTIFICATES
set  status = 'Customer Created',
CUSTOMER_ID = p_customer_id, 
CUSTOMER_BILL_TO_SITE_ID = p_bill_to_site_id,
CUSTOMER_SHIP_TO_SITE_ID = p_ship_to_site_id
where NRMI_CERTIFICATES_ID = p_NRMI_CERTIFICATES_ID;
exception when others then
rollback;
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Error: Updating Order Status: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'Error: Updating Order Status: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               END IF;
end;               
commit;
end loop;


exception when others then
rollback;
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('monitor_for_customer_creation: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'monitor_for_customer_creation: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               END IF;



end;

/* Formatted on 3/9/2015 5:17:16 PM (QP5 v5.163.1008.3004) */
PROCEDURE monitor_for_invoice_creation
IS
   return_code              VARCHAR2 (30);
   return_message           VARCHAR2 (300);

   p_order_header_id        NUMBER;
   p_customer_trx_id        NUMBER;
   p_invoice_edoc_id        NUMBER;

   cert_update_list         iri_stack;
   order_header_list         iri_stack;
   customer_trx_list         iri_stack;
   invoice_edoc_list         iri_stack;

   CURSOR get_cert_order
   IS
      SELECT *
        FROM NRMI_CERTIFICATES
       WHERE status = 'Customer Created';



   p_NRMI_CERTIFICATES_ID   NUMBER;
BEGIN
   cert_update_list := NEW iri_stack (NULL, NULL, NULL);
   order_header_list := NEW iri_stack (NULL, NULL, NULL);
   customer_trx_list := NEW iri_stack (NULL, NULL, NULL);
   invoice_edoc_list := NEW iri_stack (NULL, NULL, NULL);
   cert_update_list.initialize;
   order_header_list.initialize;
   customer_trx_list.initialize;
   invoice_edoc_list.initialize;

begin
   FOR x IN get_cert_order
   LOOP
      p_NRMI_CERTIFICATES_ID := x.NRMI_CERTIFICATES_ID;

      if x.CUSTOMER_ID is not null and x.CUSTOMER_BILL_TO_SITE_ID is not null and x.CUSTOMER_SHIP_TO_SITE_ID is not null then

      create_invoice (x.NRMI_CERTIFICATES_ID, 'N', p_order_header_id, p_customer_trx_id, p_invoice_edoc_id, return_code, return_message);

      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line (
               'Creating Invoice for Order: '
            || TO_CHAR (x.NRMI_CERTIFICATES_ID)
            || ' Status: '
            || return_code
            || ' '
            || return_message
            || ' p_order_header_id = '
            || TO_CHAR (p_order_header_id)
            || ' p_customer_trx_id= '
            || TO_CHAR (p_customer_trx_id)
            || '  p_invoice_edoc_id = '
            || TO_CHAR (p_invoice_edoc_id));
      ELSE
         fnd_file.put_line (FND_FILE.LOG, 'Creating Invoice for Order: ' || TO_CHAR (x.NRMI_CERTIFICATES_ID) || ' Status: ' || return_code || ' ' || return_message || ' p_order_header_id = ' || TO_CHAR (p_order_header_id) || ' p_customer_trx_id= ' || TO_CHAR (p_customer_trx_id) || '  p_invoice_edoc_id = ' || TO_CHAR (p_invoice_edoc_id));
      END IF;

      IF return_code = c_success
      THEN
         cert_update_list.push (x.NRMI_CERTIFICATES_ID);
         order_header_list.push (p_order_header_id);
         customer_trx_list.push (p_customer_trx_id);
         invoice_edoc_list.push (p_invoice_edoc_id);
      END IF;
      end if;

   END LOOP;
exception when others then
      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line (
            'Errror in Invoice Creation Loop: ' || TO_CHAR (p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
      ELSE
         fnd_file.put_line (FND_FILE.LOG, 'Errror in Invoice Creation Loop: ' || TO_CHAR (p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
      END IF;

end;

   COMMIT;

   WHILE NOT cert_update_list.empty
   LOOP
      cert_update_list.pop (p_NRMI_CERTIFICATES_ID);  
      order_header_list.pop (p_order_header_id);
      customer_trx_list.pop (p_customer_trx_id);
      invoice_edoc_list.pop (p_invoice_edoc_id);

      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line (
            'Updating Status for Order: ' || TO_CHAR (p_NRMI_CERTIFICATES_ID));
      ELSE
         fnd_file.put_line (FND_FILE.LOG, 'Updating Status for Order: ' || TO_CHAR (p_NRMI_CERTIFICATES_ID));
      END IF;

      BEGIN
         UPDATE NRMI_CERTIFICATES
            SET status = 'Invoice Created',
            RA_CUSTOMER_TRX_ID=p_customer_trx_id,
            OE_HEADER_ID=p_order_header_id,
            INVOICE_EDOC_ID=p_invoice_edoc_id
          WHERE NRMI_CERTIFICATES_ID = p_NRMI_CERTIFICATES_ID;
      EXCEPTION
         WHEN OTHERS
         THEN
            ROLLBACK;

            IF DEBUG_MODE
            THEN
               DBMS_OUTPUT.put_line (
                     'Error: Updating Order Status: '
                  || TO_CHAR (p_NRMI_CERTIFICATES_ID)
                  || ' '
                  || SQLERRM);
            ELSE
               fnd_file.put_line (FND_FILE.LOG, 'Error: Updating Order Status: ' || TO_CHAR (p_NRMI_CERTIFICATES_ID) || ' ' || SQLERRM);
            END IF;
      END;

      COMMIT;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      ROLLBACK;

      IF DEBUG_MODE
      THEN
         DBMS_OUTPUT.put_line (
               'monitor_for_invoice_creation: '
            || TO_CHAR (p_NRMI_CERTIFICATES_ID)
            || ' '
            || SQLERRM);
      ELSE
         fnd_file.put_line (FND_FILE.LOG, 'monitor_for_invoice_creation: ' || TO_CHAR (p_NRMI_CERTIFICATES_ID) || ' ' || SQLERRM);
      END IF;
END;

procedure monitor_for_invoices_to_send is

return_code varchar2(30);
return_message varchar2(300);

cursor get_cert_order is
select * from NRMI_CERTIFICATES where status='Invoice Created';

p_NRMI_CERTIFICATES_ID number; 

cert_update_list iri_stack;

begin

cert_update_list := new iri_stack(null,null,null);
cert_update_list.initialize;

for x in get_cert_order loop

p_NRMI_CERTIFICATES_ID:=x.NRMI_CERTIFICATES_ID;
send_invoice(x.NRMI_CERTIFICATES_ID, 'N',  return_code, return_message);

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Sending Invoice for Order: '||to_char(x.NRMI_CERTIFICATES_ID)||' Status: '||return_code||' '||return_message);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Sending Invoice for Order: '||to_char(x.NRMI_CERTIFICATES_ID)||' Status: '||return_code||' '||return_message);
               END IF;

if return_code= c_success then
cert_update_list.push(x.NRMI_CERTIFICATES_ID);
end if;

end loop;

commit;



while not cert_update_list.empty loop

cert_update_list.pop(p_NRMI_CERTIFICATES_ID);
              IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Updating Status for Order: '||to_char(p_NRMI_CERTIFICATES_ID));
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Updating Status for Order: '||to_char(p_NRMI_CERTIFICATES_ID));
               END IF;
begin               
update NRMI_CERTIFICATES
set  status='Invoice Sent',
 INVOICE_SENT_DATE = sysdate
where NRMI_CERTIFICATES_ID = p_NRMI_CERTIFICATES_ID;

exception when others then
rollback;
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Error: Updating Order Status: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'Error: Updating Order Status: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               END IF;
end;               
commit;
end loop;

exception when others then
rollback;
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('monitor_for_invoices_to_send: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'monitor_for_invoices_to_send: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               END IF;


end;


procedure monitor_for_certs_to_create is

return_code varchar2(30);
return_message varchar2(300);

p_NRMI_CERTIFICATES_ID number; 

cursor get_cert_order is
select * from NRMI_CERTIFICATES where status='Invoice Sent';
amount_due number;
begin

for x in get_cert_order loop
p_NRMI_CERTIFICATES_ID:=x.NRMI_CERTIFICATES_ID;
amount_due:=get_transaction_amount_due(x.RA_CUSTOMER_TRX_ID);
if amount_due =0 then
create_certificates(x.NRMI_CERTIFICATES_ID, return_code, return_message);
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Creating Certificates for Order: '||to_char(x.NRMI_CERTIFICATES_ID)||' Status: '||return_code||' '||return_message);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Creating Certificates for Order: '||to_char(x.NRMI_CERTIFICATES_ID)||' Status: '||return_code||' '||return_message);
               END IF;
else

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Order Unpaid: '||to_char(x.NRMI_CERTIFICATES_ID));
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Order Unpaid: '||to_char(x.NRMI_CERTIFICATES_ID));
               END IF;
end if;

end loop;

exception when others then
rollback;
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Error Updating Status on Order: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'Error Updating Status on Order: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               END IF;

end;

procedure monitor_for_certs_to_send is

return_code varchar2(30);
return_message varchar2(300);

cursor get_cert_order is
select * from NRMI_CERTIFICATES where status='Certificates Created';

p_NRMI_CERTIFICATES_ID number; 

begin

for x in get_cert_order loop

p_NRMI_CERTIFICATES_ID:=x.NRMI_CERTIFICATES_ID;
send_certificates(x.NRMI_CERTIFICATES_ID,'Y', return_code, return_message);

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Sending Certificates for Order: '||to_char(x.NRMI_CERTIFICATES_ID)||' Status: '||return_code||' '||return_message);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Sending Certificates for Order: '||to_char(x.NRMI_CERTIFICATES_ID)||' Status: '||return_code||' '||return_message);
               END IF;
end loop;

exception when others then
rollback;
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Error Updating Status on Order: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'Error Updating Status on Order: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               END IF;

end;


procedure monitor_for_orders_to_complete is

return_code varchar2(30);
return_message varchar2(300);

cursor get_cert_order is
select * from NRMI_CERTIFICATES where status='Certificates Sent'  FOR UPDATE skip locked;

p_NRMI_CERTIFICATES_ID number; 

begin

for x in get_cert_order loop
p_NRMI_CERTIFICATES_ID:=x.NRMI_CERTIFICATES_ID;

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Updating Status on Order: '||to_char(x.NRMI_CERTIFICATES_ID));
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'Updating Status on Order: '||to_char(x.NRMI_CERTIFICATES_ID));
               END IF;
update NRMI_CERTIFICATES
set status='Complete'
where current of get_cert_order;
end loop;
commit;
exception when others then
rollback;
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Error Updating Status on Order: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'Error Updating Status on Order: '||to_char(p_NRMI_CERTIFICATES_ID)||' '||sqlerrm);
               END IF;

end;

----- Code Commented By Gopi Vella On 13-FEB-2017 To Introduce Batch Processing ---------------------

/*procedure monitor_interface is 

cursor get_interface is
select * 
from 
NRMI_APPLICATION_IFACE 
where creation_date is null and last_update_date is null
order by nrmi_application_iface_id;

app_update_list iri_stack;

cert_tc_list iri_stack;

  P_NRMI_APPLICATION_ID NUMBER;
  P_NRMI_CERTIFICATES_ID NUMBER;
  P_NRMI_VESSELS_ID NUMBER;
  P_RETURN_CODE VARCHAR2(100);
  P_RETURN_MESSAGE VARCHAR2(100);




begin
app_update_list := new iri_stack(null,null,null);
cert_tc_list := new iri_stack(null,null,null);
app_update_list.initialize;
cert_tc_list.initialize;

for x in get_interface loop

p_NRMI_CERTIFICATES_ID:=null;

              IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Processing Application: '||to_char(X.NRMI_APPLICATION_ID));
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Processing Application:  '||to_char(X.NRMI_APPLICATION_ID));
               END IF;

NRMI_CERTS.PROCESS_IFACE ( X.NRMI_APPLICATION_ID, p_NRMI_CERTIFICATES_ID, P_NRMI_VESSELS_ID, P_RETURN_CODE, P_RETURN_MESSAGE );

             IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Application Result: '||P_RETURN_CODE||' '||P_RETURN_MESSAGE);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Application Result: '||P_RETURN_CODE||' '||P_RETURN_MESSAGE);
               END IF;

if P_RETURN_CODE = c_success then
app_update_list.push(X.NRMI_APPLICATION_ID);
cert_tc_list.push(p_NRMI_CERTIFICATES_ID);
end if;

end loop;

DBMS_OUTPUT.put_line ('Out of for loop');

while not app_update_list.empty loop

app_update_list.pop(P_NRMI_APPLICATION_ID);
              IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Updating Status for Application: '||to_char(P_NRMI_APPLICATION_ID));
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Updating Status for Application: '||to_char(P_NRMI_APPLICATION_ID));
               END IF;
begin               
update NRMI_APPLICATION_IFACE
set  
creation_date = sysdate,
last_update_date = sysdate,
created_by =3,
last_updated_by=3
where NRMI_APPLICATION_ID= P_NRMI_APPLICATION_ID;

exception when others then
rollback;
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Error: Updating  Application: '||to_char(P_NRMI_APPLICATION_ID)||' '||sqlerrm);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'Error: Updating  Application: '||to_char(P_NRMI_APPLICATION_ID)||' '||sqlerrm);
               END IF;
end;               
commit;
end loop;



end;*/

PROCEDURE monitor_interface 
IS 

   CURSOR get_interface 
   IS
   SELECT *
     FROM nrmi_application_iface 
    WHERE creation_date    IS NULL 
      AND last_update_date IS NULL
    ORDER BY nrmi_application_iface_id;

   app_update_list iri_stack;
   cert_tc_list    iri_stack;

   p_nrmi_application_id  NUMBER;
   p_nrmi_certificates_id NUMBER;
   p_nrmi_vessels_id      NUMBER;
   p_return_code          VARCHAR2(100);
   p_return_message       VARCHAR2(100);

   TYPE t_nrmi_application_iface IS TABLE OF nrmi_application_iface%ROWTYPE
      INDEX BY BINARY_INTEGER;

   l_nrmi_application_iface t_nrmi_application_iface;

BEGIN
   app_update_list := NEW iri_stack(NULL,NULL,NULL);
   cert_tc_list    := NEW iri_stack(NULL,NULL,NULL);

   app_update_list.initialize;
   cert_tc_list.initialize;

   OPEN get_interface;      
   LOOP
      FETCH get_interface BULK COLLECT INTO l_nrmi_application_iface LIMIT 25;
      EXIT WHEN l_nrmi_application_iface.COUNT = 0; 

      FOR i IN l_nrmi_application_iface.FIRST..l_nrmi_application_iface.LAST
      LOOP
         IF debug_mode
         THEN
            DBMS_OUTPUT.put_line ('Inside Bulk Collect');
         ELSE
            fnd_file.put_line (FND_FILE.LOG, 'Inside Bulk Collect');
         END IF;

         p_nrmi_certificates_id := NULL;

         IF debug_mode
         THEN
            DBMS_OUTPUT.put_line ('Processing Application: '||TO_CHAR(l_nrmi_application_iface(i).nrmi_application_id));
         ELSE
            fnd_file.put_line (FND_FILE.LOG, 'Processing Application:  '||TO_CHAR(l_nrmi_application_iface(i).nrmi_application_id));
         END IF;

         nrmi_certs.process_iface(l_nrmi_application_iface(i).nrmi_application_id,p_nrmi_certificates_id,p_nrmi_vessels_id,p_return_code,p_return_message);

         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line ('Application Result: '||p_return_code||' '||p_return_message);
         ELSE
            fnd_file.put_line (FND_FILE.LOG, 'Application Result: '||p_return_code||' '||p_return_message);
         END IF;

         IF p_return_code = c_success 
         THEN
            app_update_list.push(l_nrmi_application_iface(i).nrmi_application_id);
            cert_tc_list.push(p_nrmi_certificates_id);
         END IF;

      END LOOP;

      IF debug_mode
      THEN
         DBMS_OUTPUT.put_line ('Out of for loop');
      ELSE
         fnd_file.put_line (FND_FILE.LOG, 'Out of for loop');
      END IF;

      WHILE NOT app_update_list.empty 
      LOOP
         app_update_list.pop(p_nrmi_application_id);

         IF DEBUG_MODE
         THEN
            DBMS_OUTPUT.put_line ('Updating Status for Application: '||TO_CHAR(p_nrmi_application_id));
         ELSE
            fnd_file.put_line (FND_FILE.LOG, 'Updating Status for Application: '||TO_CHAR(p_nrmi_application_id));
         END IF;

         BEGIN               
            UPDATE nrmi_application_iface
               SET creation_date       = SYSDATE,
                   last_update_date    = SYSDATE,
                   created_by          = 3,
                   last_updated_by     = 3
             WHERE nrmi_application_id = p_nrmi_application_id;

             IF debug_mode
             THEN
                 DBMS_OUTPUT.put_line ('Updated Application Status Successfully');
             ELSE
                 fnd_file.put_line (FND_FILE.LOG,'Updated Application Status Successfully');
             END IF;

         EXCEPTION 
            WHEN OTHERS THEN
               ROLLBACK;

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Error: Updating  Application: '||TO_CHAR(p_nrmi_application_id)||' '||SQLERRM);
               ELSE
                  fnd_file.put_line (FND_FILE.LOG,'Error: Updating  Application: '||TO_CHAR(p_nrmi_application_id)||' '||SQLERRM);
               END IF;
         END;               

         COMMIT;

      END LOOP;

      app_update_list.initialize;
      cert_tc_list.initialize;

   END LOOP;

   IF debug_mode
   THEN
       DBMS_OUTPUT.put_line ('Processing Complete Close Cursor');
   ELSE
       fnd_file.put_line (FND_FILE.LOG,'Processing Complete Close Cursor');
   END IF;

   CLOSE get_interface;   

EXCEPTION   
   WHEN OTHERS THEN
      fnd_file.put_line(fnd_file.log,'Exception Occurred In Monitor Interface Program: '||SQLERRM);
END monitor_interface;

---- End Code Change -----------------------------------------------------------



procedure nrmi_certs_workflow(errbuf    OUT    VARCHAR2 , retcode   OUT    NUMBER) is

begin

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Start');
                  DBMS_OUTPUT.put_line ('Running monitor_interface*******************************************');
               ELSE
                 fnd_file.put_line (FND_FILE.LOG, 'Start');
                  fnd_file.put_line (FND_FILE.LOG, 'Running monitor_interface****************************************');
               END IF;

monitor_interface;

               IF DEBUG_MODE
               THEN

                  DBMS_OUTPUT.put_line ('Running monitor_for_tc_approval*******************************************');
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Running monitor_for_tc_approval****************************************');
               END IF;

monitor_for_tc_approval;

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Running monitor_for_customer_creation****************************************');
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Running monitor_for_customer_creation****************************************');
               END IF;
monitor_for_customer_creation;

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Running monitor_for_invoice_creation****************************************');
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Running monitor_for_invoice_creation****************************************');
               END IF;
monitor_for_invoice_creation;
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Running monitor_for_invoices_to_send****************************************');
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Running monitor_for_invoices_to_send****************************************');
               END IF;
monitor_for_invoices_to_send;

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Running monitor_for_certs_to_create****************************************');
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Running monitor_for_certs_to_create****************************************');
               END IF;
monitor_for_certs_to_create;

               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Running monitor_for_certs_to_send****************************************');
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Running monitor_for_certs_to_send****************************************');
               END IF;


monitor_for_certs_to_send;
               IF DEBUG_MODE
               THEN
                  DBMS_OUTPUT.put_line ('Running monitor_for_orders_to_complete');
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'Running monitor_for_orders_to_complete');
               END IF;
monitor_for_orders_to_complete;
               IF DEBUG_MODE
               THEN
                    DBMS_OUTPUT.put_line ('End');
               ELSE
                  fnd_file.put_line (FND_FILE.LOG, 'End');
               END IF; 
    end;


function check_for_duplicates(p_imo_number in number, p_NRMI_VESSELS_ID in number) return boolean is

cursor get_vessels is select count(*) from NRMI_VESSELS where 
NRMI_VESSELS_ID != nvl(p_NRMI_VESSELS_ID ,-100) and VESSEL_IMO_NUMBER = p_imo_number
and status='Active';

nof_vessels number:=0;

begin

open get_vessels;
fetch get_vessels into nof_vessels;
close get_vessels;
if nof_vessels > 0 then
return true;
end if;

return false;
end;

function vessels_on_order(P_NRMI_CERTIFICATES_ID in number) return number is

cursor get_vessels is select count(*) from NRMI_VESSELS where 
NRMI_CERTIFICATES_ID = P_NRMI_CERTIFICATES_ID;

nof_vessels number:=0;

begin
open get_vessels;
fetch get_vessels into nof_vessels;
close get_vessels;

return(nof_vessels);
end;


procedure split_order(p_nrmi_certificates_id in number) is

cursor get_certs is
select * from nrmi_certificates where nrmi_certificates_id=p_nrmi_certificates_id;

cert_rec get_certs%rowtype;

cursor get_vessels is
select * from nrmi_vessels where  nrmi_certificates_id=p_nrmi_certificates_id;

cursor get_kp is
select * from NRMI_KNOWN_PARTIES where  nrmi_certificates_id=p_nrmi_certificates_id;

new_NRMI_CERTIFICATES_ID number;

begin

open get_certs;
fetch get_certs into cert_rec;
close get_certs;

for x in  get_vessels loop

new_NRMI_CERTIFICATES_ID:=NRMI_CERTIFICATES_ID_SEQ.NEXTVAL;

INSERT INTO VSSL.NRMI_CERTIFICATES (
   ACKNO_SENT_DATE, BILL_AT_MI_RATE, BT_ADDRESS1, 
   BT_ADDRESS2, BT_ADDRESS3, BT_CITY, 
   BT_COUNTRY, BT_CUSTOMER_NAME, BT_EMAIL_ADDRESS, 
   BT_POSTAL_CODE, BT_PROVINCE, CREATED_BY, 
   CREATION_DATE, CUSTOMER_BILL_TO_SITE_ID, CUSTOMER_ID, 
   CUSTOMER_SHIP_TO_SITE_ID, INVOICE_EDOC_ID, INVOICE_SENT_DATE, 
   LAST_UPDATE_DATE, LAST_UPDATE_LOGIN, LAST_UPDATED_BY, 
   NRMI_CERTIFICATES_ID, OE_HEADER_ID, RA_CUSTOMER_TRX_ID, 
   RQ_ADDRESS1, RQ_ADDRESS2, RQ_ADDRESS3, 
   RQ_CITY, RQ_COUNTRY, RQ_EMAIL_ADDRESS, 
   RQ_NAME, RQ_POSTAL_CODE, RQ_PROVINCE, 
   RQ_TELEPHONE, STATUS) 
VALUES ( 
cert_rec.ACKNO_SENT_DATE /* ACKNO_SENT_DATE */,
cert_rec.BILL_AT_MI_RATE /* BILL_AT_MI_RATE */,
cert_rec.BT_ADDRESS1 /* BT_ADDRESS1 */,
cert_rec.BT_ADDRESS2 /* BT_ADDRESS2 */,
cert_rec.BT_ADDRESS3 /* BT_ADDRESS3 */,
cert_rec.BT_CITY /* BT_CITY */,
cert_rec.BT_COUNTRY /* BT_COUNTRY */,
cert_rec.BT_CUSTOMER_NAME/* BT_CUSTOMER_NAME */,
cert_rec.BT_EMAIL_ADDRESS /* BT_EMAIL_ADDRESS */,
cert_rec.BT_POSTAL_CODE/* BT_POSTAL_CODE */,
cert_rec.BT_PROVINCE /* BT_PROVINCE */,
cert_rec.CREATED_BY /* CREATED_BY */,
cert_rec.CREATION_DATE /* CREATION_DATE */,
null /* CUSTOMER_BILL_TO_SITE_ID */,
null /* CUSTOMER_ID */,
null /* CUSTOMER_SHIP_TO_SITE_ID */,
null /* INVOICE_EDOC_ID */,
null /* INVOICE_SENT_DATE */,
cert_rec.LAST_UPDATE_DATE/* LAST_UPDATE_DATE */,
cert_rec.LAST_UPDATE_LOGIN /* LAST_UPDATE_LOGIN */,
cert_rec.LAST_UPDATED_BY /* LAST_UPDATED_BY */,
new_NRMI_CERTIFICATES_ID /* NRMI_CERTIFICATES_ID */,
null /* OE_HEADER_ID */,
null /* RA_CUSTOMER_TRX_ID */,
cert_rec.RQ_ADDRESS1 /* RQ_ADDRESS1 */,
cert_rec.RQ_ADDRESS2 /* RQ_ADDRESS2 */,
cert_rec.RQ_ADDRESS3 /* RQ_ADDRESS3 */,
cert_rec.RQ_CITY /* RQ_CITY */,
cert_rec.RQ_COUNTRY /* RQ_COUNTRY */,
cert_rec.RQ_EMAIL_ADDRESS /* RQ_EMAIL_ADDRESS */,
cert_rec.RQ_NAME /* RQ_NAME */,
cert_rec.RQ_POSTAL_CODE /* RQ_POSTAL_CODE */,
cert_rec.RQ_PROVINCE /* RQ_PROVINCE */,
cert_rec.RQ_TELEPHONE /* RQ_TELEPHONE */,
'Data Hold'  /* STATUS */ );


INSERT INTO VSSL.NRMI_VESSELS (
   ADDRESS_REG_OWN, APPLICATION_EDOC_ID, BLUE_CARD_EDOC_ID, 
   CERTIFICATE_EDOC_ID, CERTIFICATE_NUMBER, CERTIFICATE_SENT_DATE, 
   COR_EDOC_ID, CREATED_BY, CREATION_DATE, 
   EFFECTIVE_DATE, EXPIRATION_DATE, GROSS_TONNAGE, 
   ISSUE_DATE, LAST_UPDATE_DATE, LAST_UPDATE_LOGIN, 
   LAST_UPDATED_BY, NRMI_APPLICATION_IFACE_ID, NRMI_CERTIFICATES_ID, 
   NRMI_VESSELS_ID, OFFICIAL_NUMBER, P_AND_I_CLUB_ID, 
   PORT_OF_REGISTRY, REGISTERED_OWNER_NAME, RO_EMAIL_ADDRESS, 
   STATUS, VESSEL_IMO_NUMBER, VESSEL_NAME) 
VALUES ( 
x.ADDRESS_REG_OWN /* ADDRESS_REG_OWN */,
x.APPLICATION_EDOC_ID /* APPLICATION_EDOC_ID */,
x.BLUE_CARD_EDOC_ID /* BLUE_CARD_EDOC_ID */,
x.CERTIFICATE_EDOC_ID /* CERTIFICATE_EDOC_ID */,
x.CERTIFICATE_NUMBER /* CERTIFICATE_NUMBER */,
x.CERTIFICATE_SENT_DATE /* CERTIFICATE_SENT_DATE */,
x.COR_EDOC_ID /* COR_EDOC_ID */,
x.CREATED_BY /* CREATED_BY */,
x.CREATION_DATE /* CREATION_DATE */,
x.EFFECTIVE_DATE /* EFFECTIVE_DATE */,
x.EXPIRATION_DATE /* EXPIRATION_DATE */,
x.GROSS_TONNAGE /* GROSS_TONNAGE */,
x.ISSUE_DATE /* ISSUE_DATE */,
x.LAST_UPDATE_DATE /* LAST_UPDATE_DATE */,
x.LAST_UPDATE_LOGIN /* LAST_UPDATE_LOGIN */,
x.LAST_UPDATED_BY /* LAST_UPDATED_BY */,
x.NRMI_APPLICATION_IFACE_ID /* NRMI_APPLICATION_IFACE_ID */,
new_NRMI_CERTIFICATES_ID /* NRMI_CERTIFICATES_ID */,
null  /* NRMI_VESSELS_ID */,
x.OFFICIAL_NUMBER /* OFFICIAL_NUMBER */,
x.P_AND_I_CLUB_ID /* P_AND_I_CLUB_ID */,
x.PORT_OF_REGISTRY /* PORT_OF_REGISTRY */,
x.REGISTERED_OWNER_NAME /* REGISTERED_OWNER_NAME */,
x.RO_EMAIL_ADDRESS /* RO_EMAIL_ADDRESS */,
x.STATUS /* STATUS */,
x.VESSEL_IMO_NUMBER /* VESSEL_IMO_NUMBER */,
x.VESSEL_NAME /* VESSEL_NAME */ );

for y in get_kp loop
INSERT INTO VSSL.NRMI_KNOWN_PARTIES (
   CREATED_BY, CREATION_DATE, KP_NAME, 
   LAST_UPDATE_DATE, LAST_UPDATE_LOGIN, LAST_UPDATED_BY, 
   NRMI_CERTIFICATES_ID, NRMI_KP_ID) 
VALUES (
y.CREATED_BY /* CREATED_BY */,
y.CREATION_DATE  /* CREATION_DATE */,
y.KP_NAME  /* KP_NAME */,
y.LAST_UPDATE_DATE /* LAST_UPDATE_DATE */,
y.LAST_UPDATE_LOGIN /* LAST_UPDATE_LOGIN */,
y.LAST_UPDATED_BY /* LAST_UPDATED_BY */,
new_NRMI_CERTIFICATES_ID /* NRMI_CERTIFICATES_ID */,
null  /* NRMI_KP_ID */ );

end loop;



end loop;

commit;

end;

end; 
/


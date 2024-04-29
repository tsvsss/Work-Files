CREATE OR REPLACE package APPS.NRMI_CERTS as

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: nrmi_certs.pks 1.1 2019/11/15 12:00:00ET   IRI Exp                                                     $*/
/********************************************************************************************************************
* Object Type         : Package Specification                                                                       *
* Name                : NRMI_CERTS                                                                                  *
* Script Name         : nrmi_certs.pks                                                                              *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : SAGARWAL                                                                                    *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    :                                                                                             *
* Last Reviewed Date  :                                                                                             *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                SAGARWAL          15-NOV-2019  I      Trade Compliance            *
*                                                                                                                   *
********************************************************************************************************************/

debug_mode boolean := FALSE;

test_cc_email_address varchar2(100):='WRLC@register-iri.com';

c_success constant varchar2(30):='SUCCESS';
c_error constant varchar2(30):='ERROR';

procedure create_trade_compliance(P_NRMI_CERTIFICATES_ID in number, p_return_code out varchar2, p_return_message out varchar2);
procedure create_customer(P_NRMI_CERTIFICATES_ID in number ,update_recs in varchar2 default 'N',p_customer_id out number, p_bill_to_site_id out number, p_ship_to_site_id out number,  p_return_code out varchar2, p_return_message out varchar2);
procedure create_invoice(P_NRMI_CERTIFICATES_ID in number, p_do_updates in varchar2 default 'N', p_order_header_id out number, p_customer_trx_id out number, p_invoice_edoc_id out number, p_return_code out varchar2, p_return_message out varchar2);
procedure create_certificates(P_NRMI_CERTIFICATES_ID in number,  p_return_code out varchar2, p_return_message out varchar2);
procedure send_certificates(P_NRMI_CERTIFICATES_ID in number, p_do_updates in varchar2 default 'N', p_return_code out varchar2, p_return_message out varchar2);
procedure send_invoice(P_NRMI_CERTIFICATES_ID in number,p_do_updates varchar2 default 'N', p_return_code out varchar2, p_return_message out varchar2) ;
procedure send_acknowledgement(P_NRMI_CERTIFICATES_ID in number, p_return_code out varchar2, p_return_message out varchar2);
procedure populate_iface(p_NRMI_APPLICATION_ID in number, p_return_code out varchar2, p_return_message out varchar2);
procedure process_iface(p_NRMI_APPLICATION_ID in number, NRMI_CERTIFICATES_ID out number,p_NRMI_VESSELS_ID out number, p_return_code out varchar2, p_return_message out varchar2);
function get_country_code(p_country_name in varchar) return varchar2;
function validate_port(p_port_name in varchar2) return varchar2;
function validate_pi_club(c_name in varchar2, p_address in varchar2) return number;
function get_pending_orders(bill_to_name in varchar2, request_name in varchar2) return number;
function know_party_exists(P_NAME in varchar2 ,P_NRMI_CERTIFICATES_ID in number) return boolean;
procedure advance_workflow(P_NRMI_CERTIFICATES_ID in number, p_return_code out varchar2, p_return_message out varchar2);
function get_tc_status_for_req(P_NRMI_CERTIFICATES_ID in number) return varchar2 ;
function cert_order_locked(P_NRMI_CERTIFICATES_ID in number) return boolean;
procedure set_tc_to_legal_review(p_wc_screening_request_id in number, p_return_code out varchar2, p_return_message out varchar2);
procedure create_tc_document_references(P_WC_SCREENING_REQUEST_ID in number, p_application_edoc_id in number, p_cor_edoc_id in number, p_bluecard_edoc_id in number, P_RETURN_CODE in out varchar2, P_ERROR_MSG in out varchar2);
function check_for_duplicates(p_imo_number in number, p_NRMI_VESSELS_ID in number) return boolean;
function vessels_on_order(P_NRMI_CERTIFICATES_ID in number) return number;


/* automation procedures */
procedure monitor_interface;
procedure monitor_for_tc_approval;
procedure monitor_for_customer_creation;
procedure monitor_for_invoice_creation;
procedure monitor_for_invoices_to_send;
procedure monitor_for_certs_to_create;
procedure monitor_for_certs_to_send;
procedure monitor_for_orders_to_complete;

procedure nrmi_certs_workflow(errbuf    OUT    VARCHAR2 , retcode   OUT    NUMBER);


procedure split_order(p_nrmi_certificates_id in number);

end;
/


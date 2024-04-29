CREATE OR REPLACE PACKAGE xwrl_utils AS

   TYPE p_rec IS RECORD (
      key VARCHAR2 (300)
      , value VARCHAR2 (32767)
   );

   TYPE p_tab IS
      TABLE OF p_rec INDEX BY BINARY_INTEGER;

   server_unavailable EXCEPTION;
   server_not_whitelisted EXCEPTION;
   server_timeout EXCEPTION;
   server_end_of_input EXCEPTION;
   PRAGMA exception_init (server_not_whitelisted, -12541);  --ORA-12541: TNS:no listener
   PRAGMA exception_init (server_timeout, -12535);  --ORA-12535: TNS:operation timed out
   PRAGMA exception_init (server_end_of_input, -29259);  --ORA-29259: end-of-input reached

   PROCEDURE test_ows_web_service (
      p_debug          BOOLEAN
      , p_server         VARCHAR2
      , p_service_name   VARCHAR2
   );

   PROCEDURE ows_web_service (
      p_debug           BOOLEAN
      , p_show_request    BOOLEAN
      , p_show_response   BOOLEAN
      , p_server          VARCHAR2
      , p_service_name    VARCHAR2
      , p_list            p_tab
      , p_id              INTEGER
   );

   PROCEDURE ows_indivdiual_screening (
      p_debug                     BOOLEAN
      , p_show_request              BOOLEAN
      , p_show_response             BOOLEAN
      , p_server                    VARCHAR2
      , p_listsubkey                VARCHAR2
      , p_listrecordtype            VARCHAR2
      , p_listrecordorigin          VARCHAR2
      , p_custid                    VARCHAR2
      , p_custsubid                 VARCHAR2
      , p_passportnumber            VARCHAR2
      , p_nationalid                VARCHAR2
      , p_title                     VARCHAR2
      , p_fullname                  VARCHAR2
      , p_givennames                VARCHAR2
      , p_familyname                VARCHAR2
      , p_nametype                  VARCHAR2
      , p_namequality               VARCHAR2
      , p_primaryname               VARCHAR2
      , p_originalscriptname        VARCHAR2
      , p_gender                    VARCHAR2
      , p_dateofbirth               VARCHAR2
      , p_yearofbirth               VARCHAR2
      , p_occupation                VARCHAR2
      , p_address1                  VARCHAR2
      , p_address2                  VARCHAR2
      , p_address3                  VARCHAR2
      , p_address4                  VARCHAR2
      , p_city                      VARCHAR2
      , p_state                     VARCHAR2
      , p_postalcode                VARCHAR2
      , p_addresscountrycode        VARCHAR2
      , p_residencycountrycode      VARCHAR2
      , p_countryofbirthcode        VARCHAR2
      , p_nationalitycountrycodes   VARCHAR2
      , p_profilehyperlink          VARCHAR2
      , p_riskscore                 VARCHAR2
      , p_dataconfidencescore       VARCHAR2
      , p_dataconfidencecomment     VARCHAR2
      , p_customstring1             VARCHAR2
      , p_customstring2             VARCHAR2
      , p_customstring3             VARCHAR2
      , p_customstring4             VARCHAR2
      , p_customstring5             VARCHAR2
      , p_customstring6             VARCHAR2
      , p_customstring7             VARCHAR2
      , p_customstring8             VARCHAR2
      , p_customstring9             VARCHAR2
      , p_customstring10            VARCHAR2
      , p_customstring11            VARCHAR2
      , p_customstring12            VARCHAR2
      , p_customstring13            VARCHAR2
      , p_customstring14            VARCHAR2
      , p_customstring15            VARCHAR2
      , p_customstring16            VARCHAR2
      , p_customstring17            VARCHAR2
      , p_customstring18            VARCHAR2
      , p_customstring19            VARCHAR2
      , p_customstring20            VARCHAR2
      , p_customstring21            VARCHAR2
      , p_customstring22            VARCHAR2
      , p_customstring23            VARCHAR2
      , p_customstring24            VARCHAR2
      , p_customstring25            VARCHAR2
      , p_customstring26            VARCHAR2
      , p_customstring27            VARCHAR2
      , p_customstring28            VARCHAR2
      , p_customstring29            VARCHAR2
      , p_customstring30            VARCHAR2
      , p_customstring31            VARCHAR2
      , p_customstring32            VARCHAR2
      , p_customstring33            VARCHAR2
      , p_customstring34            VARCHAR2
      , p_customstring35            VARCHAR2
      , p_customstring36            VARCHAR2
      , p_customstring37            VARCHAR2
      , p_customstring38            VARCHAR2
      , p_customstring39            VARCHAR2
      , p_customstring40            VARCHAR2
      , p_customdate1               VARCHAR2
      , p_customdate2               VARCHAR2
      , p_customdate3               VARCHAR2
      , p_customdate4               VARCHAR2
      , p_customdate5               VARCHAR2
      , p_customnumber1             VARCHAR2
      , p_customnumber2             VARCHAR2
      , p_customnumber3             VARCHAR2
      , p_customnumber4             VARCHAR2
      , p_customnumber5             VARCHAR2
   );

   PROCEDURE ows_entity_screening (
      p_debug                     BOOLEAN
      , p_show_request              BOOLEAN
      , p_show_response             BOOLEAN
      , p_server                    VARCHAR2
      , p_listsubkey                VARCHAR2
      , p_listrecordtype            VARCHAR2
      , p_listrecordorigin          VARCHAR2
      , p_custid                    VARCHAR2
      , p_custsubid                 VARCHAR2
      , p_registrationnumber        VARCHAR2
      , p_entityname                VARCHAR2
      , p_nametype                  VARCHAR2
      , p_namequality               VARCHAR2
      , p_primaryname               VARCHAR2
      , p_originalscriptname        VARCHAR2
      , p_aliasisacronym            VARCHAR2
      , p_address1                  VARCHAR2
      , p_address2                  VARCHAR2
      , p_address3                  VARCHAR2
      , p_address4                  VARCHAR2
      , p_city                      VARCHAR2
      , p_state                     VARCHAR2
      , p_postalcode                VARCHAR2
      , p_addresscountrycode        VARCHAR2
      , p_registrationcountrycode   VARCHAR2
      , p_operatingcountrycodes     VARCHAR2
      , p_profilehyperlink          VARCHAR2
      , p_riskscore                 VARCHAR2
      , p_dataconfidencescore       VARCHAR2
      , p_dataconfidencecomment     VARCHAR2
      , p_customstring1             VARCHAR2
      , p_customstring2             VARCHAR2
      , p_customstring3             VARCHAR2
      , p_customstring4             VARCHAR2
      , p_customstring5             VARCHAR2
      , p_customstring6             VARCHAR2
      , p_customstring7             VARCHAR2
      , p_customstring8             VARCHAR2
      , p_customstring9             VARCHAR2
      , p_customstring10            VARCHAR2
      , p_customstring11            VARCHAR2
      , p_customstring12            VARCHAR2
      , p_customstring13            VARCHAR2
      , p_customstring14            VARCHAR2
      , p_customstring15            VARCHAR2
      , p_customstring16            VARCHAR2
      , p_customstring17            VARCHAR2
      , p_customstring18            VARCHAR2
      , p_customstring19            VARCHAR2
      , p_customstring20            VARCHAR2
      , p_customstring21            VARCHAR2
      , p_customstring22            VARCHAR2
      , p_customstring23            VARCHAR2
      , p_customstring24            VARCHAR2
      , p_customstring25            VARCHAR2
      , p_customstring26            VARCHAR2
      , p_customstring27            VARCHAR2
      , p_customstring28            VARCHAR2
      , p_customstring29            VARCHAR2
      , p_customstring30            VARCHAR2
      , p_customstring31            VARCHAR2
      , p_customstring32            VARCHAR2
      , p_customstring33            VARCHAR2
      , p_customstring34            VARCHAR2
      , p_customstring35            VARCHAR2
      , p_customstring36            VARCHAR2
      , p_customstring37            VARCHAR2
      , p_customstring38            VARCHAR2
      , p_customstring39            VARCHAR2
      , p_customstring40            VARCHAR2
      , p_customdate1               VARCHAR2
      , p_customdate2               VARCHAR2
      , p_customdate3               VARCHAR2
      , p_customdate4               VARCHAR2
      , p_customdate5               VARCHAR2
      , p_customnumber1             VARCHAR2
      , p_customnumber2             VARCHAR2
      , p_customnumber3             VARCHAR2
      , p_customnumber4             VARCHAR2
      , p_customnumber5             VARCHAR2
   );

END xwrl_utils;
/

CREATE OR REPLACE PACKAGE BODY xwrl_utils AS

   FUNCTION get_server (
      p_name VARCHAR2
   ) RETURN VARCHAR2 AS

      v_id      VARCHAR2 (100) := 'SERVER';
      v_key     VARCHAR2 (100);  -- Note: Values are POC, NON-PROD and PROD
      v_value   VARCHAR2 (100);
      CURSOR c1 (
         p_id VARCHAR2
         , p_key VARCHAR2
      ) IS
      SELECT
         value_string
      FROM
         xwrl_parameters
      WHERE
         id = p_id
         AND key = p_key;

   BEGIN

      v_key := p_name;

      FOR c1rec IN c1 (v_id, v_key) LOOP v_value := c1rec.value_string;
      END LOOP;

      RETURN v_value;

   END get_server;

   FUNCTION get_path (
      p_name VARCHAR2
   ) RETURN VARCHAR2 AS

      v_id      VARCHAR2 (100) := 'PATH';
      v_key     VARCHAR2 (100);  -- Note: Values are INDIVIDUAL, ENTITY, TEST
      v_value   VARCHAR2 (100);
      CURSOR c1 (
         p_id VARCHAR2
         , p_key VARCHAR2
      ) IS
      SELECT
         value_string
      FROM
         xwrl_parameters
      WHERE
         id = p_id
         AND key = p_key;

   BEGIN

      v_key := p_name;

      FOR c1rec IN c1 (v_id, v_key) LOOP v_value := c1rec.value_string;
      END LOOP;

      RETURN v_value;

   END get_path;

   FUNCTION get_xml (
      p_name VARCHAR2
   ) RETURN XMLTYPE AS
      v_id    VARCHAR2 (100) := 'XML';
      v_key   VARCHAR2 (100);  -- Note: Values are INDIVIDUAL and ENTITY
      v_xml   XMLTYPE;
      CURSOR c1 (
         p_id VARCHAR2
         , p_key VARCHAR2
      ) IS
      SELECT
         value_xml
      FROM
         xwrl_parameters
      WHERE
         id = p_id
         AND key = p_key;

   BEGIN

      v_key := p_name;

      FOR c1rec IN c1 (v_id, v_key) LOOP v_xml := c1rec.value_xml;
      END LOOP;

      RETURN v_xml;
   END get_xml;

   FUNCTION get_xml (
      p_id INTEGER
   ) RETURN XMLTYPE AS

      v_xml XMLTYPE;

      CURSOR c1 IS
      SELECT
         request
      FROM
         xwrl_requests
      WHERE
         id = p_id;

   BEGIN

      FOR c1rec IN c1 LOOP v_xml := c1rec.request;
      END LOOP;

      RETURN v_xml;
   END get_xml;

   FUNCTION get_path (
      p_id INTEGER
   ) RETURN VARCHAR2 AS

      v_path VARCHAR2 (50);

      CURSOR c1 IS
      SELECT
         path
      FROM
         xwrl_requests
      WHERE
         id = p_id;

   BEGIN

      FOR c1rec IN c1 LOOP v_path := c1rec.path;
      END LOOP;

      RETURN v_path;
   END get_path;

   FUNCTION test_ows_web_service (
      p_debug          BOOLEAN
      , p_server         VARCHAR2
      , p_service_name   VARCHAR2
   ) RETURN BOOLEAN AS
      v_server   VARCHAR2 (100);
      v_path     VARCHAR2 (100);
      v_url      VARCHAR2 (500);
      v_req      utl_http.req;
      v_resp     utl_http.resp;
   BEGIN
      v_server := p_server;
      v_path := p_service_name;
      v_url := get_server (v_server) || get_path (v_path);
      IF p_debug THEN
         dbms_output.put_line ('/--- Test URL Function --/');
         dbms_output.put_line ('p_server: ' || p_server);
         dbms_output.put_line ('p_service_name: ' || p_service_name);
         dbms_output.put_line ('v_url: ' || v_url);
      END IF;
      v_req := utl_http.begin_request (v_url);
      v_resp := utl_http.get_response (v_req);
      utl_http.end_response (v_resp);
      RETURN true;

   EXCEPTION
      WHEN utl_http.end_of_body THEN
         utl_http.end_response (v_resp);
         RETURN false;
      WHEN utl_http.too_many_requests THEN
         utl_http.end_response (v_resp);
         RETURN false;

   END test_ows_web_service;

   PROCEDURE print_clob (
      p_clob IN CLOB
   ) IS
      v_offset       NUMBER DEFAULT 1;
      v_chunk_size   NUMBER := 10000;
   BEGIN
      LOOP
         EXIT WHEN v_offset > dbms_lob.getlength (p_clob);
         dbms_output.put_line (dbms_lob.substr (p_clob, v_chunk_size, v_offset));
         v_offset := v_offset + v_chunk_size;
      END LOOP;
   END print_clob;

   FUNCTION to_xmltype (
      clobcol CLOB
   ) RETURN XMLTYPE AS
   BEGIN
      RETURN xmltype (clobcol);
   END to_xmltype;

   PROCEDURE show_xml (
      p_xml IN XMLTYPE
   ) IS
      v_str LONG;
   BEGIN
      v_str := p_xml.extract ('/*').getstringval ();
      LOOP
         EXIT WHEN v_str IS NULL;
         dbms_output.put_line (substr (v_str, 1, instr (v_str, chr (10)) - 1));
         v_str := substr (v_str, instr (v_str, chr (10)) + 1);
      END LOOP;
   END show_xml;

   PROCEDURE test_ows_web_service (
      p_debug          BOOLEAN
      , p_server         VARCHAR2
      , p_service_name   VARCHAR2
   ) IS
      v_server   VARCHAR2 (100);
      v_path     VARCHAR2 (100);
      v_url      VARCHAR2 (500);
      v_req      utl_http.req;
      v_resp     utl_http.resp;
   BEGIN
      v_server := p_server;
      v_path := p_service_name;
      v_url := get_server (v_server) || get_path (v_path);
      IF p_debug THEN
         dbms_output.put_line ('/--- Test URL Procedure --/');
         dbms_output.put_line ('p_server: ' || p_server);
         dbms_output.put_line ('p_service_name: ' || p_service_name);
         dbms_output.put_line ('v_url: ' || v_url);
      END IF;
      v_req := utl_http.begin_request (v_url);
      v_resp := utl_http.get_response (v_req);
      utl_http.end_response (v_resp);
   EXCEPTION
      WHEN utl_http.end_of_body THEN
         utl_http.end_response (v_resp);
      WHEN utl_http.too_many_requests THEN
         utl_http.end_response (v_resp);

   END test_ows_web_service;

   PROCEDURE err_ows_web_service (
      p_debug         BOOLEAN
      , p_resp          utl_http.resp
      , p_content       CLOB
      , p_request_rec   xwrl.xwrl_requests%rowtype
   ) IS
      v_resp          utl_http.resp;
      v_content       CLOB;
      v_request_rec   xwrl.xwrl_requests%rowtype;

   BEGIN

      v_resp := p_resp;
      v_content := p_content;
      v_request_rec := p_request_rec;

      IF p_debug THEN
         dbms_output.put_line ('/--- Process Error ---/');
         dbms_output.put_line ('Error Code: ' || utl_http.get_detailed_sqlcode);
         dbms_output.put_line ('Error Msg: ' || utl_http.get_detailed_sqlerrm);
      END IF;

      IF p_debug THEN
         dbms_output.put_line ('/--- End Resposne ---/');
      END IF;

      utl_http.end_response (v_resp);
			/* Note: Caused error 
			ORA-06502: PL/SQL: numeric or value error: invalid LOB locator specified: ORA-22275
			ORA-06512: at "SYS.DBMS_LOB", line 818
			IF p_debug THEN
				dbms_output.put_line('/--- Free LOB  ---/');
			END IF;
			dbms_lob.freetemporary(v_content);
			*/

			-- Save Record w/ error
      v_request_rec.status := 'ERROR';
      v_request_rec.error_code := 'ORA' || utl_http.get_detailed_sqlcode;
      v_request_rec.error_message := utl_http.get_detailed_sqlerrm;

      IF v_request_rec.error_code = 'ORA-12541' THEN
         v_request_rec.error_message := v_request_rec.error_message || ' *** Server Needs to be Whitelisted ***';
      ELSIF v_request_rec.error_code = 'ORA-29259' THEN
         v_request_rec.error_message := v_request_rec.error_message || ' *** Check if both OWS servers are down ***';
      END IF;

      v_request_rec.creation_date := SYSDATE;
      v_request_rec.last_update_date := SYSDATE;

      IF p_debug THEN
         dbms_output.put_line ('/--- Insert Record ---/');
      END IF;

      INSERT INTO xwrl_requests VALUES v_request_rec;
      COMMIT;

      IF p_debug THEN
         dbms_output.put_line ('/--- Finish Error Process  ---/');
      END IF;

   END err_ows_web_service;

   PROCEDURE ows_web_service (
      p_debug           BOOLEAN
      , p_show_request    BOOLEAN
      , p_show_response   BOOLEAN
      , p_server          VARCHAR2
      , p_service_name    VARCHAR2
      , p_list            p_tab
      , p_id              INTEGER
   ) AS

      v_server               VARCHAR2 (100);
      v_path                 VARCHAR2 (100);
      v_url                  VARCHAR2 (500);
      v_req                  utl_http.req;
      v_resp                 utl_http.resp;
      v_content              CLOB;
      v_buffer               VARCHAR2 (32767);

      v_soap_xml             XMLTYPE;
      v_soap_key             VARCHAR2 (100);
      v_soap_value           VARCHAR2 (1000);
      v_soap_query           VARCHAR2 (1000);
      v_soap_delim           VARCHAR2 (5);
      v_soap_request         CLOB;
      i                      BINARY_INTEGER;

      v_request_rec          xwrl.xwrl_requests%rowtype;
      is_service_available   BOOLEAN := false;
      v_id                   INTEGER;
      is_resubmit            BOOLEAN := false;

   BEGIN

	-- Initial request record
      v_request_rec := NULL;
   
      IF p_id IS NOT NULL THEN  -- Note: A resubmit uses a Request ID
         is_resubmit := true;
      END IF;
      
   -- Create URL 
      IF p_debug THEN
         dbms_output.put_line ('/--- Create URL --/');
         dbms_output.put_line ('p_server: ' || p_server);
         dbms_output.put_line ('p_service_name: ' || p_service_name);
         dbms_output.put_line ('p_id: ' || p_id);
      END IF;
      
      v_server := p_server;
      
      IF is_resubmit THEN  -- Note: A resubmit uses a Request ID
         v_path := get_path (p_id);
      ELSE
         v_path := p_service_name;
      END IF;
      v_url := get_server (v_server) || get_path (v_path);
      IF p_debug THEN
         dbms_output.put_line ('v_url: ' || v_url);
      END IF;

      v_request_rec.server := p_server;
      v_request_rec.path := v_path;

      IF is_resubmit THEN -- Note: A resubmit uses a Request ID
         v_request_rec.resubmit_id := p_id;
      END IF;

	-- Get XML 
      IF p_debug THEN
         dbms_output.put_line ('/--- Get XML --/');
      END IF;

      IF is_resubmit THEN -- Note: A resubmit uses a Request ID
         v_soap_xml := get_xml (p_id);
      ELSE

         IF p_service_name = 'INDIVIDUAL' THEN
            v_soap_xml := get_xml ('REQUEST_INDIVIDUAL');
         ELSIF p_service_name = 'ENTITY' THEN
            v_soap_xml := get_xml ('REQUEST_ENTITY');
         END IF;
   
      -- Replace Node Values 
         IF p_debug THEN
            dbms_output.put_line ('/--- Replace Node Values --/');
         END IF;
         IF p_debug THEN
            dbms_output.put_line ('p_list: ' || p_list.count);
         END IF;
   
         i := p_list.first;
         v_soap_delim := chr (40);  -- Left Parenthesis
         v_soap_query := 'declare namespace ws="http://www.datanomic.com/ws"; copy $tmp := .  modify ';
   
         WHILE i IS NOT NULL LOOP
            IF p_debug THEN
               dbms_output.put_line ('p_key: ' || p_list (i).key);
               dbms_output.put_line ('p_value: ' || p_list (i).value);
            END IF;
             -- UPDATEXML is dep_recated in 12c
            --v_soap_key := '//*:'|| p_list(i).key|| '/text()';
            --v_soap_value := p_list(i).value;        
            -- SELECT updatexml(v_soap_xml, v_soap_key, v_soap_value) INTO v_soap_xml FROM dual;
            v_soap_key := p_list (i).key;
            v_soap_value := p_list (i).value;
            IF p_debug THEN
               dbms_output.put_line ('v_soap_key: ' || v_soap_key);
               dbms_output.put_line ('v_soap_value: ' || v_soap_value);
            END IF;
   
            v_soap_query := v_soap_query || v_soap_delim || 'replace value of node $tmp//*/ws:request/ws:' || v_soap_key || ' with "' || v_soap_value || '" ';
            i := p_list.next (i);
            v_soap_delim := chr (44); -- comma
   
         END LOOP;
   
         v_soap_query := v_soap_query || ') return $tmp';
         IF p_debug THEN
            dbms_output.put_line ('v_soap_query: ' || v_soap_query);
         END IF;
   
         -- Replace UPDATEXML with XMLQUERY     
         SELECT
            xmlquery
         (v_soap_query PASSING v_soap_xml RETURNING CONTENT )  INTO v_soap_xml
         FROM
               dual;

   END IF;

      v_request_rec.request := v_soap_xml;
      v_soap_request := v_soap_xml.getclobval ();

      IF p_show_request THEN
         show_xml (to_xmltype (v_soap_request));
      END IF;

	-- Check OWS service
      IF p_debug THEN
         dbms_output.put_line ('/--- Check OWS service --/');
      END IF;
      is_service_available := test_ows_web_service (p_debug => p_debug, p_server => p_server, p_service_name => 'TEST');
      IF is_service_available = false THEN
         RAISE xwrl_utils.server_unavailable;
      END IF;

   -- Send Request 
      IF p_debug THEN
         dbms_output.put_line ('/--- Send Request --/');
      END IF;
      v_req := utl_http.begin_request (url => v_url, method => 'POST');
      utl_http.set_header (r => v_req, name => 'Content-Length', value => dbms_lob.getlength (v_soap_request));
      utl_http.set_header (r => v_req, name => 'Content-Type', value => 'text/xml;charset=UTF-8');
      utl_http.set_header (r => v_req, name => 'Transfer-Encoding', value => 'chunked');
      utl_http.set_body_charset ('UTF-8');
      utl_http.write_text (r => v_req, data => v_soap_request);

	--- Get Response 
      IF p_debug THEN
         dbms_output.put_line ('/--- Get Response ---/');
      END IF;
      v_resp := utl_http.get_response (v_req);
      IF p_debug THEN
         dbms_output.put_line ('Response Status: ' || v_resp.status_code);
         dbms_output.put_line ('Reason Phrase: ' || v_resp.reason_phrase);
         dbms_output.put_line ('HTTP Version: ' || v_resp.http_version);
      END IF;

  --- Read Response 
      IF p_debug THEN
         dbms_output.put_line ('/--- Read Response ---/');
      END IF;
      dbms_lob.createtemporary (v_content, false);
      BEGIN
         LOOP
            utl_http.read_text (v_resp, v_buffer, 32000);
            dbms_lob.writeappend (v_content, length (v_buffer), v_buffer);
            IF p_debug THEN
               dbms_output.put_line ('Size=' || length (v_content));
            END IF;
         END LOOP;
      EXCEPTION
         WHEN utl_http.end_of_body THEN
            utl_http.end_response (v_resp);
      END;

      v_request_rec.response := to_xmltype (v_content);

      IF p_show_response THEN
         show_xml (to_xmltype (v_content));
      END IF;

      dbms_lob.freetemporary (v_content);

   -- Save Record
      IF v_resp.status_code = utl_http.http_ok THEN
         v_request_rec.status := 'COMPLETE';
      ELSE
         v_request_rec.status := 'ERROR';
         v_request_rec.error_message := 'Please see response.';
      END IF;

      v_request_rec.creation_date := SYSDATE;
      v_request_rec.last_update_date := SYSDATE;

      INSERT INTO xwrl_requests VALUES v_request_rec RETURNING id INTO v_id;
      COMMIT;

      IF p_debug THEN
         dbms_output.put_line ('ID =' || v_id);
      END IF;

      IF is_resubmit THEN -- Note: A resubmit uses a Request ID
         UPDATE xwrl_requests
         SET
            status = 'RESUBMIT'
         WHERE
            id = p_id;
         COMMIT;
      END IF;

   EXCEPTION
   -- Need to create an email notification for these exceptions
   -- Note: Those with an Error condition can be resubmitted
      WHEN utl_http.http_server_error THEN
         dbms_output.put_line ('Error: utl_http.HTTP_SERVER_ERROR');
         v_request_rec.error_message := v_request_rec.error_message || ' *** Check if Real-Time Screening Jobs are running ***';
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         raise_application_error (-20100, 'Error: utl_http.HTTP_SERVER_ERROR');
      WHEN utl_http.transfer_timeout THEN
         dbms_output.put_line ('Error: utl_http.TRANSFER_TIMEOUT');
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         raise_application_error (-20100, 'Error: utl_http.TRANSFER_TIMEOUT');
      WHEN utl_http.too_many_requests THEN
		   /* Note: You can have a maximum of 5 HTTP requests per session (see MOS note 961468. */
         dbms_output.put_line ('Error: utl_http.TOO_MANY_REQUESTS');
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         raise_application_error (-20100, 'Error: utl_http.TOO_MANY_REQUESTS');
      WHEN xwrl_utils.server_unavailable THEN
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.SERVER_UNAVAILABLE');
         raise_application_error (-20100, 'Error: xwrl_utils.SERVER_UNAVAILABLE');
      WHEN xwrl_utils.server_not_whitelisted THEN
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.SERVER_NOT_WHITELISTED');
         raise_application_error (-20100, 'Error: xwrl_utils.SERVER_NOT_WHITELISTED');
      WHEN xwrl_utils.server_timeout THEN
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.SERVER_TIMEOUT');
         raise_application_error (-20100, 'Error: xwrl_utils.SERVER_TIMEOUT');
      WHEN xwrl_utils.server_end_of_input THEN
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.SERVER_END_OF_INPUT');
         raise_application_error (-20100, 'Error: xwrl_utils.SERVER_END_OF_INPUT');

   END ows_web_service;

   PROCEDURE ows_indivdiual_screening (
      p_debug                     BOOLEAN
      , p_show_request              BOOLEAN
      , p_show_response             BOOLEAN
      , p_server                    VARCHAR2
      , p_listsubkey                VARCHAR2
      , p_listrecordtype            VARCHAR2
      , p_listrecordorigin          VARCHAR2
      , p_custid                    VARCHAR2
      , p_custsubid                 VARCHAR2
      , p_passportnumber            VARCHAR2
      , p_nationalid                VARCHAR2
      , p_title                     VARCHAR2
      , p_fullname                  VARCHAR2
      , p_givennames                VARCHAR2
      , p_familyname                VARCHAR2
      , p_nametype                  VARCHAR2
      , p_namequality               VARCHAR2
      , p_primaryname               VARCHAR2
      , p_originalscriptname        VARCHAR2
      , p_gender                    VARCHAR2
      , p_dateofbirth               VARCHAR2
      , p_yearofbirth               VARCHAR2
      , p_occupation                VARCHAR2
      , p_address1                  VARCHAR2
      , p_address2                  VARCHAR2
      , p_address3                  VARCHAR2
      , p_address4                  VARCHAR2
      , p_city                      VARCHAR2
      , p_state                     VARCHAR2
      , p_postalcode                VARCHAR2
      , p_addresscountrycode        VARCHAR2
      , p_residencycountrycode      VARCHAR2
      , p_countryofbirthcode        VARCHAR2
      , p_nationalitycountrycodes   VARCHAR2
      , p_profilehyperlink          VARCHAR2
      , p_riskscore                 VARCHAR2
      , p_dataconfidencescore       VARCHAR2
      , p_dataconfidencecomment     VARCHAR2
      , p_customstring1             VARCHAR2
      , p_customstring2             VARCHAR2
      , p_customstring3             VARCHAR2
      , p_customstring4             VARCHAR2
      , p_customstring5             VARCHAR2
      , p_customstring6             VARCHAR2
      , p_customstring7             VARCHAR2
      , p_customstring8             VARCHAR2
      , p_customstring9             VARCHAR2
      , p_customstring10            VARCHAR2
      , p_customstring11            VARCHAR2
      , p_customstring12            VARCHAR2
      , p_customstring13            VARCHAR2
      , p_customstring14            VARCHAR2
      , p_customstring15            VARCHAR2
      , p_customstring16            VARCHAR2
      , p_customstring17            VARCHAR2
      , p_customstring18            VARCHAR2
      , p_customstring19            VARCHAR2
      , p_customstring20            VARCHAR2
      , p_customstring21            VARCHAR2
      , p_customstring22            VARCHAR2
      , p_customstring23            VARCHAR2
      , p_customstring24            VARCHAR2
      , p_customstring25            VARCHAR2
      , p_customstring26            VARCHAR2
      , p_customstring27            VARCHAR2
      , p_customstring28            VARCHAR2
      , p_customstring29            VARCHAR2
      , p_customstring30            VARCHAR2
      , p_customstring31            VARCHAR2
      , p_customstring32            VARCHAR2
      , p_customstring33            VARCHAR2
      , p_customstring34            VARCHAR2
      , p_customstring35            VARCHAR2
      , p_customstring36            VARCHAR2
      , p_customstring37            VARCHAR2
      , p_customstring38            VARCHAR2
      , p_customstring39            VARCHAR2
      , p_customstring40            VARCHAR2
      , p_customdate1               VARCHAR2
      , p_customdate2               VARCHAR2
      , p_customdate3               VARCHAR2
      , p_customdate4               VARCHAR2
      , p_customdate5               VARCHAR2
      , p_customnumber1             VARCHAR2
      , p_customnumber2             VARCHAR2
      , p_customnumber3             VARCHAR2
      , p_customnumber4             VARCHAR2
      , p_customnumber5             VARCHAR2
   ) IS

      p_list p_tab;

   BEGIN

      IF p_listsubkey IS NOT NULL THEN
         p_list (1).key := 'ListSubKey';
         p_list (1).value := p_listsubkey;
      END IF;
      IF p_listrecordtype IS NOT NULL THEN
         p_list (2).key := 'ListRecordType';
         p_list (2).value := p_listrecordtype;
      END IF;
      IF p_listrecordorigin IS NOT NULL THEN
         p_list (3).key := 'ListRecordOrigin';
         p_list (3).value := p_listrecordorigin;
      END IF;
      IF p_custid IS NOT NULL THEN
         p_list (4).key := 'CustId';
         p_list (4).value := p_custid;
      END IF;
      IF p_custsubid IS NOT NULL THEN
         p_list (5).key := 'CustSubId';
         p_list (5).value := p_custsubid;
      END IF;
      IF p_passportnumber IS NOT NULL THEN
         p_list (6).key := 'PassportNumber';
         p_list (6).value := p_passportnumber;
      END IF;
      IF p_nationalid IS NOT NULL THEN
         p_list (7).key := 'NationalId';
         p_list (7).value := p_nationalid;
      END IF;
      IF p_title IS NOT NULL THEN
         p_list (8).key := 'Title';
         p_list (8).value := p_title;
      END IF;
      IF p_fullname IS NOT NULL THEN
         p_list (9).key := 'FullName';
         p_list (9).value := p_fullname;
      END IF;
      IF p_givennames IS NOT NULL THEN
         p_list (10).key := 'GivenNames';
         p_list (10).value := p_givennames;
      END IF;
      IF p_familyname IS NOT NULL THEN
         p_list (11).key := 'FamilyName';
         p_list (11).value := p_familyname;
      END IF;
      IF p_nametype IS NOT NULL THEN
         p_list (12).key := 'NameType';
         p_list (12).value := p_nametype;
      END IF;
      IF p_namequality IS NOT NULL THEN
         p_list (13).key := 'NameQuality';
         p_list (13).value := p_namequality;
      END IF;
      IF p_primaryname IS NOT NULL THEN
         p_list (14).key := 'PrimaryName';
         p_list (14).value := p_primaryname;
      END IF;
      IF p_originalscriptname IS NOT NULL THEN
         p_list (15).key := 'OriginalScriptName';
         p_list (15).value := p_originalscriptname;
      END IF;
      IF p_gender IS NOT NULL THEN
         p_list (16).key := 'Gender';
         p_list (16).value := p_gender;
      END IF;
      IF p_dateofbirth IS NOT NULL THEN
         p_list (17).key := 'DateOfBirth';
         p_list (17).value := p_dateofbirth;
      END IF;
      IF p_yearofbirth IS NOT NULL THEN
         p_list (18).key := 'YearOfBirth';
         p_list (18).value := p_yearofbirth;
      END IF;
      IF p_occupation IS NOT NULL THEN
         p_list (19).key := 'Occupation';
         p_list (19).value := p_occupation;
      END IF;
      IF p_address1 IS NOT NULL THEN
         p_list (20).key := 'Address1';
         p_list (20).value := p_address1;
      END IF;
      IF p_address2 IS NOT NULL THEN
         p_list (21).key := 'Address2';
         p_list (21).value := p_address2;
      END IF;
      IF p_address3 IS NOT NULL THEN
         p_list (22).key := 'Address3';
         p_list (22).value := p_address3;
      END IF;
      IF p_address4 IS NOT NULL THEN
         p_list (23).key := 'Address4';
         p_list (23).value := p_address4;
      END IF;
      IF p_city IS NOT NULL THEN
         p_list (24).key := 'City';
         p_list (24).value := p_city;
      END IF;
      IF p_state IS NOT NULL THEN
         p_list (25).key := 'State';
         p_list (25).value := p_state;
      END IF;
      IF p_postalcode IS NOT NULL THEN
         p_list (26).key := 'PostalCode';
         p_list (26).value := p_postalcode;
      END IF;
      IF p_addresscountrycode IS NOT NULL THEN
         p_list (27).key := 'AddressCountryCode';
         p_list (27).value := p_addresscountrycode;
      END IF;
      IF p_residencycountrycode IS NOT NULL THEN
         p_list (28).key := 'ResidencyCountryCode';
         p_list (28).value := p_residencycountrycode;
      END IF;
      IF p_countryofbirthcode IS NOT NULL THEN
         p_list (29).key := 'CountryOfBirthCode';
         p_list (29).value := p_countryofbirthcode;
      END IF;
      IF p_nationalitycountrycodes IS NOT NULL THEN
         p_list (30).key := 'NationalityCountryCodes';
         p_list (30).value := p_nationalitycountrycodes;
      END IF;
      IF p_profilehyperlink IS NOT NULL THEN
         p_list (31).key := 'ProfileHyperlink';
         p_list (31).value := p_profilehyperlink;
      END IF;
      IF p_riskscore IS NOT NULL THEN
         p_list (32).key := 'RiskScore';
         p_list (32).value := p_riskscore;
      END IF;
      IF p_dataconfidencescore IS NOT NULL THEN
         p_list (33).key := 'DataConfidenceScore';
         p_list (33).value := p_dataconfidencescore;
      END IF;
      IF p_dataconfidencecomment IS NOT NULL THEN
         p_list (34).key := 'DataConfidenceComment';
         p_list (34).value := p_dataconfidencecomment;
      END IF;
      IF p_customstring1 IS NOT NULL THEN
         p_list (35).key := 'CustomString1';
         p_list (35).value := p_customstring1;
      END IF;
      IF p_customstring2 IS NOT NULL THEN
         p_list (36).key := 'CustomString2';
         p_list (36).value := p_customstring2;
      END IF;
      IF p_customstring3 IS NOT NULL THEN
         p_list (37).key := 'CustomString3';
         p_list (37).value := p_customstring3;
      END IF;
      IF p_customstring4 IS NOT NULL THEN
         p_list (38).key := 'CustomString4';
         p_list (38).value := p_customstring4;
      END IF;
      IF p_customstring5 IS NOT NULL THEN
         p_list (39).key := 'CustomString5';
         p_list (39).value := p_customstring5;
      END IF;
      IF p_customstring6 IS NOT NULL THEN
         p_list (40).key := 'CustomString6';
         p_list (40).value := p_customstring6;
      END IF;
      IF p_customstring7 IS NOT NULL THEN
         p_list (41).key := 'CustomString7';
         p_list (41).value := p_customstring7;
      END IF;
      IF p_customstring8 IS NOT NULL THEN
         p_list (42).key := 'CustomString8';
         p_list (42).value := p_customstring8;
      END IF;
      IF p_customstring9 IS NOT NULL THEN
         p_list (43).key := 'CustomString9';
         p_list (43).value := p_customstring9;
      END IF;
      IF p_customstring10 IS NOT NULL THEN
         p_list (44).key := 'CustomString10';
         p_list (44).value := p_customstring10;
      END IF;
      IF p_customstring11 IS NOT NULL THEN
         p_list (45).key := 'CustomString11';
         p_list (45).value := p_customstring11;
      END IF;
      IF p_customstring12 IS NOT NULL THEN
         p_list (46).key := 'CustomString12';
         p_list (46).value := p_customstring12;
      END IF;
      IF p_customstring13 IS NOT NULL THEN
         p_list (47).key := 'CustomString13';
         p_list (47).value := p_customstring13;
      END IF;
      IF p_customstring14 IS NOT NULL THEN
         p_list (48).key := 'CustomString14';
         p_list (48).value := p_customstring14;
      END IF;
      IF p_customstring15 IS NOT NULL THEN
         p_list (49).key := 'CustomString15';
         p_list (49).value := p_customstring15;
      END IF;
      IF p_customstring16 IS NOT NULL THEN
         p_list (50).key := 'CustomString16';
         p_list (50).value := p_customstring16;
      END IF;
      IF p_customstring17 IS NOT NULL THEN
         p_list (51).key := 'CustomString17';
         p_list (51).value := p_customstring17;
      END IF;
      IF p_customstring18 IS NOT NULL THEN
         p_list (52).key := 'CustomString18';
         p_list (52).value := p_customstring18;
      END IF;
      IF p_customstring19 IS NOT NULL THEN
         p_list (53).key := 'CustomString19';
         p_list (53).value := p_customstring19;
      END IF;
      IF p_customstring20 IS NOT NULL THEN
         p_list (54).key := 'CustomString20';
         p_list (54).value := p_customstring20;
      END IF;
      IF p_customstring21 IS NOT NULL THEN
         p_list (55).key := 'CustomString21';
         p_list (55).value := p_customstring21;
      END IF;
      IF p_customstring22 IS NOT NULL THEN
         p_list (56).key := 'CustomString22';
         p_list (56).value := p_customstring22;
      END IF;
      IF p_customstring23 IS NOT NULL THEN
         p_list (57).key := 'CustomString23';
         p_list (57).value := p_customstring23;
      END IF;
      IF p_customstring24 IS NOT NULL THEN
         p_list (58).key := 'CustomString24';
         p_list (58).value := p_customstring24;
      END IF;
      IF p_customstring25 IS NOT NULL THEN
         p_list (59).key := 'CustomString25';
         p_list (59).value := p_customstring25;
      END IF;
      IF p_customstring26 IS NOT NULL THEN
         p_list (60).key := 'CustomString26';
         p_list (60).value := p_customstring26;
      END IF;
      IF p_customstring27 IS NOT NULL THEN
         p_list (61).key := 'CustomString27';
         p_list (61).value := p_customstring27;
      END IF;
      IF p_customstring28 IS NOT NULL THEN
         p_list (62).key := 'CustomString28';
         p_list (62).value := p_customstring28;
      END IF;
      IF p_customstring29 IS NOT NULL THEN
         p_list (63).key := 'CustomString29';
         p_list (63).value := p_customstring29;
      END IF;
      IF p_customstring30 IS NOT NULL THEN
         p_list (64).key := 'CustomString30';
         p_list (64).value := p_customstring30;
      END IF;
      IF p_customstring31 IS NOT NULL THEN
         p_list (65).key := 'CustomString31';
         p_list (65).value := p_customstring31;
      END IF;
      IF p_customstring32 IS NOT NULL THEN
         p_list (66).key := 'CustomString32';
         p_list (66).value := p_customstring32;
      END IF;
      IF p_customstring33 IS NOT NULL THEN
         p_list (67).key := 'CustomString33';
         p_list (67).value := p_customstring33;
      END IF;
      IF p_customstring34 IS NOT NULL THEN
         p_list (68).key := 'CustomString34';
         p_list (68).value := p_customstring34;
      END IF;
      IF p_customstring35 IS NOT NULL THEN
         p_list (69).key := 'CustomString35';
         p_list (69).value := p_customstring35;
      END IF;
      IF p_customstring36 IS NOT NULL THEN
         p_list (70).key := 'CustomString36';
         p_list (70).value := p_customstring36;
      END IF;
      IF p_customstring37 IS NOT NULL THEN
         p_list (71).key := 'CustomString37';
         p_list (71).value := p_customstring37;
      END IF;
      IF p_customstring38 IS NOT NULL THEN
         p_list (72).key := 'CustomString38';
         p_list (72).value := p_customstring38;
      END IF;
      IF p_customstring39 IS NOT NULL THEN
         p_list (73).key := 'CustomString39';
         p_list (73).value := p_customstring39;
      END IF;
      IF p_customstring40 IS NOT NULL THEN
         p_list (74).key := 'CustomString40';
         p_list (74).value := p_customstring40;
      END IF;
      IF p_customdate1 IS NOT NULL THEN
         p_list (75).key := 'CustomDate1';
         p_list (75).value := p_customdate1;
      END IF;
      IF p_customdate2 IS NOT NULL THEN
         p_list (76).key := 'CustomDate2';
         p_list (76).value := p_customdate2;
      END IF;
      IF p_customdate3 IS NOT NULL THEN
         p_list (77).key := 'CustomDate3';
         p_list (77).value := p_customdate3;
      END IF;
      IF p_customdate4 IS NOT NULL THEN
         p_list (78).key := 'CustomDate4';
         p_list (78).value := p_customdate4;
      END IF;
      IF p_customdate5 IS NOT NULL THEN
         p_list (79).key := 'CustomDate5';
         p_list (79).value := p_customdate5;
      END IF;
      IF p_customnumber1 IS NOT NULL THEN
         p_list (80).key := 'CustomNumber1';
         p_list (80).value := p_customnumber1;
      END IF;
      IF p_customnumber2 IS NOT NULL THEN
         p_list (81).key := 'CustomNumber2';
         p_list (81).value := p_customnumber2;
      END IF;
      IF p_customnumber3 IS NOT NULL THEN
         p_list (82).key := 'CustomNumber3';
         p_list (82).value := p_customnumber3;
      END IF;
      IF p_customnumber4 IS NOT NULL THEN
         p_list (83).key := 'CustomNumber4';
         p_list (83).value := p_customnumber4;
      END IF;
      IF p_customnumber5 IS NOT NULL THEN
         p_list (84).key := 'CustomNumber5';
         p_list (84).value := p_customnumber5;
      END IF;

      xwrl_utils.ows_web_service (p_debug => p_debug, p_show_request => p_show_request, p_show_response => p_show_response, p_server => p_server, p_service_name => 'INDIVIDUAL', p_list => p_list, p_id => NULL);

   END ows_indivdiual_screening;

   PROCEDURE ows_entity_screening (
      p_debug                     BOOLEAN
      , p_show_request              BOOLEAN
      , p_show_response             BOOLEAN
      , p_server                    VARCHAR2
      , p_listsubkey                VARCHAR2
      , p_listrecordtype            VARCHAR2
      , p_listrecordorigin          VARCHAR2
      , p_custid                    VARCHAR2
      , p_custsubid                 VARCHAR2
      , p_registrationnumber        VARCHAR2
      , p_entityname                VARCHAR2
      , p_nametype                  VARCHAR2
      , p_namequality               VARCHAR2
      , p_primaryname               VARCHAR2
      , p_originalscriptname        VARCHAR2
      , p_aliasisacronym            VARCHAR2
      , p_address1                  VARCHAR2
      , p_address2                  VARCHAR2
      , p_address3                  VARCHAR2
      , p_address4                  VARCHAR2
      , p_city                      VARCHAR2
      , p_state                     VARCHAR2
      , p_postalcode                VARCHAR2
      , p_addresscountrycode        VARCHAR2
      , p_registrationcountrycode   VARCHAR2
      , p_operatingcountrycodes     VARCHAR2
      , p_profilehyperlink          VARCHAR2
      , p_riskscore                 VARCHAR2
      , p_dataconfidencescore       VARCHAR2
      , p_dataconfidencecomment     VARCHAR2
      , p_customstring1             VARCHAR2
      , p_customstring2             VARCHAR2
      , p_customstring3             VARCHAR2
      , p_customstring4             VARCHAR2
      , p_customstring5             VARCHAR2
      , p_customstring6             VARCHAR2
      , p_customstring7             VARCHAR2
      , p_customstring8             VARCHAR2
      , p_customstring9             VARCHAR2
      , p_customstring10            VARCHAR2
      , p_customstring11            VARCHAR2
      , p_customstring12            VARCHAR2
      , p_customstring13            VARCHAR2
      , p_customstring14            VARCHAR2
      , p_customstring15            VARCHAR2
      , p_customstring16            VARCHAR2
      , p_customstring17            VARCHAR2
      , p_customstring18            VARCHAR2
      , p_customstring19            VARCHAR2
      , p_customstring20            VARCHAR2
      , p_customstring21            VARCHAR2
      , p_customstring22            VARCHAR2
      , p_customstring23            VARCHAR2
      , p_customstring24            VARCHAR2
      , p_customstring25            VARCHAR2
      , p_customstring26            VARCHAR2
      , p_customstring27            VARCHAR2
      , p_customstring28            VARCHAR2
      , p_customstring29            VARCHAR2
      , p_customstring30            VARCHAR2
      , p_customstring31            VARCHAR2
      , p_customstring32            VARCHAR2
      , p_customstring33            VARCHAR2
      , p_customstring34            VARCHAR2
      , p_customstring35            VARCHAR2
      , p_customstring36            VARCHAR2
      , p_customstring37            VARCHAR2
      , p_customstring38            VARCHAR2
      , p_customstring39            VARCHAR2
      , p_customstring40            VARCHAR2
      , p_customdate1               VARCHAR2
      , p_customdate2               VARCHAR2
      , p_customdate3               VARCHAR2
      , p_customdate4               VARCHAR2
      , p_customdate5               VARCHAR2
      , p_customnumber1             VARCHAR2
      , p_customnumber2             VARCHAR2
      , p_customnumber3             VARCHAR2
      , p_customnumber4             VARCHAR2
      , p_customnumber5             VARCHAR2
   ) IS

      p_list p_tab;

   BEGIN

      IF p_listsubkey IS NOT NULL THEN
         p_list (1).key := 'ListSubKey';
         p_list (1).value := p_listsubkey;
      END IF;
      IF p_listrecordtype IS NOT NULL THEN
         p_list (2).key := 'ListRecordType';
         p_list (2).value := p_listrecordtype;
      END IF;
      IF p_listrecordorigin IS NOT NULL THEN
         p_list (3).key := 'ListRecordOrigin';
         p_list (3).value := p_listrecordorigin;
      END IF;
      IF p_custid IS NOT NULL THEN
         p_list (4).key := 'CustId';
         p_list (4).value := p_custid;
      END IF;
      IF p_custsubid IS NOT NULL THEN
         p_list (5).key := 'CustSubId';
         p_list (5).value := p_custsubid;
      END IF;
      IF p_registrationnumber IS NOT NULL THEN
         p_list (6).key := 'RegistrationNumber';
         p_list (6).value := p_registrationnumber;
      END IF;
      IF p_entityname IS NOT NULL THEN
         p_list (7).key := 'EntityName';
         p_list (7).value := p_entityname;
      END IF;
      IF p_nametype IS NOT NULL THEN
         p_list (8).key := 'NameType';
         p_list (8).value := p_nametype;
      END IF;
      IF p_namequality IS NOT NULL THEN
         p_list (9).key := 'NameQuality';
         p_list (9).value := p_namequality;
      END IF;
      IF p_primaryname IS NOT NULL THEN
         p_list (10).key := 'PrimaryName';
         p_list (10).value := p_primaryname;
      END IF;
      IF p_originalscriptname IS NOT NULL THEN
         p_list (11).key := 'OriginalScriptName';
         p_list (11).value := p_originalscriptname;
      END IF;
      IF p_aliasisacronym IS NOT NULL THEN
         p_list (12).key := 'AliasIsAcronym';
         p_list (12).value := p_aliasisacronym;
      END IF;
      IF p_address1 IS NOT NULL THEN
         p_list (13).key := 'Address1';
         p_list (13).value := p_address1;
      END IF;
      IF p_address2 IS NOT NULL THEN
         p_list (14).key := 'Address2';
         p_list (14).value := p_address2;
      END IF;
      IF p_address3 IS NOT NULL THEN
         p_list (15).key := 'Address3';
         p_list (15).value := p_address3;
      END IF;
      IF p_address4 IS NOT NULL THEN
         p_list (16).key := 'Address4';
         p_list (16).value := p_address4;
      END IF;
      IF p_city IS NOT NULL THEN
         p_list (17).key := 'City';
         p_list (17).value := p_city;
      END IF;
      IF p_state IS NOT NULL THEN
         p_list (18).key := 'State';
         p_list (18).value := p_state;
      END IF;
      IF p_postalcode IS NOT NULL THEN
         p_list (19).key := 'PostalCode';
         p_list (19).value := p_postalcode;
      END IF;
      IF p_addresscountrycode IS NOT NULL THEN
         p_list (20).key := 'AddressCountryCode';
         p_list (20).value := p_addresscountrycode;
      END IF;
      IF p_registrationcountrycode IS NOT NULL THEN
         p_list (21).key := 'RegistrationCountryCode';
         p_list (21).value := p_registrationcountrycode;
      END IF;
      IF p_operatingcountrycodes IS NOT NULL THEN
         p_list (22).key := 'OperatingCountryCodes';
         p_list (22).value := p_operatingcountrycodes;
      END IF;
      IF p_profilehyperlink IS NOT NULL THEN
         p_list (23).key := 'ProfileHyperlink';
         p_list (23).value := p_profilehyperlink;
      END IF;
      IF p_riskscore IS NOT NULL THEN
         p_list (24).key := 'RiskScore';
         p_list (24).value := p_riskscore;
      END IF;
      IF p_dataconfidencescore IS NOT NULL THEN
         p_list (25).key := 'DataConfidenceScore';
         p_list (25).value := p_dataconfidencescore;
      END IF;
      IF p_dataconfidencecomment IS NOT NULL THEN
         p_list (26).key := 'DataConfidenceComment';
         p_list (26).value := p_dataconfidencecomment;
      END IF;
      IF p_customstring1 IS NOT NULL THEN
         p_list (27).key := 'CustomString1';
         p_list (27).value := p_customstring1;
      END IF;
      IF p_customstring2 IS NOT NULL THEN
         p_list (28).key := 'CustomString2';
         p_list (28).value := p_customstring2;
      END IF;
      IF p_customstring3 IS NOT NULL THEN
         p_list (29).key := 'CustomString3';
         p_list (29).value := p_customstring3;
      END IF;
      IF p_customstring4 IS NOT NULL THEN
         p_list (30).key := 'CustomString4';
         p_list (30).value := p_customstring4;
      END IF;
      IF p_customstring5 IS NOT NULL THEN
         p_list (31).key := 'CustomString5';
         p_list (31).value := p_customstring5;
      END IF;
      IF p_customstring6 IS NOT NULL THEN
         p_list (32).key := 'CustomString6';
         p_list (32).value := p_customstring6;
      END IF;
      IF p_customstring7 IS NOT NULL THEN
         p_list (33).key := 'CustomString7';
         p_list (33).value := p_customstring7;
      END IF;
      IF p_customstring8 IS NOT NULL THEN
         p_list (34).key := 'CustomString8';
         p_list (34).value := p_customstring8;
      END IF;
      IF p_customstring9 IS NOT NULL THEN
         p_list (35).key := 'CustomString9';
         p_list (35).value := p_customstring9;
      END IF;
      IF p_customstring10 IS NOT NULL THEN
         p_list (36).key := 'CustomString10';
         p_list (36).value := p_customstring10;
      END IF;
      IF p_customstring11 IS NOT NULL THEN
         p_list (37).key := 'CustomString11';
         p_list (37).value := p_customstring11;
      END IF;
      IF p_customstring12 IS NOT NULL THEN
         p_list (38).key := 'CustomString12';
         p_list (38).value := p_customstring12;
      END IF;
      IF p_customstring13 IS NOT NULL THEN
         p_list (39).key := 'CustomString13';
         p_list (39).value := p_customstring13;
      END IF;
      IF p_customstring14 IS NOT NULL THEN
         p_list (40).key := 'CustomString14';
         p_list (40).value := p_customstring14;
      END IF;
      IF p_customstring15 IS NOT NULL THEN
         p_list (41).key := 'CustomString15';
         p_list (41).value := p_customstring15;
      END IF;
      IF p_customstring16 IS NOT NULL THEN
         p_list (42).key := 'CustomString16';
         p_list (42).value := p_customstring16;
      END IF;
      IF p_customstring17 IS NOT NULL THEN
         p_list (43).key := 'CustomString17';
         p_list (43).value := p_customstring17;
      END IF;
      IF p_customstring18 IS NOT NULL THEN
         p_list (44).key := 'CustomString18';
         p_list (44).value := p_customstring18;
      END IF;
      IF p_customstring19 IS NOT NULL THEN
         p_list (45).key := 'CustomString19';
         p_list (45).value := p_customstring19;
      END IF;
      IF p_customstring20 IS NOT NULL THEN
         p_list (46).key := 'CustomString20';
         p_list (46).value := p_customstring20;
      END IF;
      IF p_customstring21 IS NOT NULL THEN
         p_list (47).key := 'CustomString21';
         p_list (47).value := p_customstring21;
      END IF;
      IF p_customstring22 IS NOT NULL THEN
         p_list (48).key := 'CustomString22';
         p_list (48).value := p_customstring22;
      END IF;
      IF p_customstring23 IS NOT NULL THEN
         p_list (49).key := 'CustomString23';
         p_list (49).value := p_customstring23;
      END IF;
      IF p_customstring24 IS NOT NULL THEN
         p_list (50).key := 'CustomString24';
         p_list (50).value := p_customstring24;
      END IF;
      IF p_customstring25 IS NOT NULL THEN
         p_list (51).key := 'CustomString25';
         p_list (51).value := p_customstring25;
      END IF;
      IF p_customstring26 IS NOT NULL THEN
         p_list (52).key := 'CustomString26';
         p_list (52).value := p_customstring26;
      END IF;
      IF p_customstring27 IS NOT NULL THEN
         p_list (53).key := 'CustomString27';
         p_list (53).value := p_customstring27;
      END IF;
      IF p_customstring28 IS NOT NULL THEN
         p_list (54).key := 'CustomString28';
         p_list (54).value := p_customstring28;
      END IF;
      IF p_customstring29 IS NOT NULL THEN
         p_list (55).key := 'CustomString29';
         p_list (55).value := p_customstring29;
      END IF;
      IF p_customstring30 IS NOT NULL THEN
         p_list (56).key := 'CustomString30';
         p_list (56).value := p_customstring30;
      END IF;
      IF p_customstring31 IS NOT NULL THEN
         p_list (57).key := 'CustomString31';
         p_list (57).value := p_customstring31;
      END IF;
      IF p_customstring32 IS NOT NULL THEN
         p_list (58).key := 'CustomString32';
         p_list (58).value := p_customstring32;
      END IF;
      IF p_customstring33 IS NOT NULL THEN
         p_list (59).key := 'CustomString33';
         p_list (59).value := p_customstring33;
      END IF;
      IF p_customstring34 IS NOT NULL THEN
         p_list (60).key := 'CustomString34';
         p_list (60).value := p_customstring34;
      END IF;
      IF p_customstring35 IS NOT NULL THEN
         p_list (61).key := 'CustomString35';
         p_list (61).value := p_customstring35;
      END IF;
      IF p_customstring36 IS NOT NULL THEN
         p_list (62).key := 'CustomString36';
         p_list (62).value := p_customstring36;
      END IF;
      IF p_customstring37 IS NOT NULL THEN
         p_list (63).key := 'CustomString37';
         p_list (63).value := p_customstring37;
      END IF;
      IF p_customstring38 IS NOT NULL THEN
         p_list (64).key := 'CustomString38';
         p_list (64).value := p_customstring38;
      END IF;
      IF p_customstring39 IS NOT NULL THEN
         p_list (65).key := 'CustomString39';
         p_list (65).value := p_customstring39;
      END IF;
      IF p_customstring40 IS NOT NULL THEN
         p_list (66).key := 'CustomString40';
         p_list (66).value := p_customstring40;
      END IF;
      IF p_customdate1 IS NOT NULL THEN
         p_list (67).key := 'CustomDate1';
         p_list (67).value := p_customdate1;
      END IF;
      IF p_customdate2 IS NOT NULL THEN
         p_list (68).key := 'CustomDate2';
         p_list (68).value := p_customdate2;
      END IF;
      IF p_customdate3 IS NOT NULL THEN
         p_list (69).key := 'CustomDate3';
         p_list (69).value := p_customdate3;
      END IF;
      IF p_customdate4 IS NOT NULL THEN
         p_list (70).key := 'CustomDate4';
         p_list (70).value := p_customdate4;
      END IF;
      IF p_customdate5 IS NOT NULL THEN
         p_list (71).key := 'CustomDate5';
         p_list (71).value := p_customdate5;
      END IF;
      IF p_customnumber1 IS NOT NULL THEN
         p_list (72).key := 'CustomNumber1';
         p_list (72).value := p_customnumber1;
      END IF;
      IF p_customnumber2 IS NOT NULL THEN
         p_list (73).key := 'CustomNumber2';
         p_list (73).value := p_customnumber2;
      END IF;
      IF p_customnumber3 IS NOT NULL THEN
         p_list (74).key := 'CustomNumber3';
         p_list (74).value := p_customnumber3;
      END IF;
      IF p_customnumber4 IS NOT NULL THEN
         p_list (75).key := 'CustomNumber4';
         p_list (75).value := p_customnumber4;
      END IF;
      IF p_customnumber5 IS NOT NULL THEN
         p_list (76).key := 'CustomNumber5';
         p_list (76).value := p_customnumber5;
      END IF;

      xwrl_utils.ows_web_service (p_debug => p_debug, p_show_request => p_show_request, p_show_response => p_show_response, p_server => p_server, p_service_name => 'ENTITY', p_list => p_list, p_id => NULL);

   END ows_entity_screening;

END xwrl_utils;
/
CREATE OR REPLACE PACKAGE xwrl_utils AS

   TYPE p_rec IS RECORD (
      key VARCHAR2 (300)
      , value VARCHAR2 (32767)
   );

   TYPE p_tab IS
      TABLE OF p_rec INDEX BY BINARY_INTEGER;

   invalid_request EXCEPTION;
   server_unavailable EXCEPTION;
   
   server_not_whitelisted EXCEPTION;
   server_timeout EXCEPTION;
   server_end_of_input EXCEPTION;  
   syntax_error EXCEPTION;
   xml_parsing EXCEPTION;
   PRAGMA exception_init (server_not_whitelisted, -12541);  --ORA-12541: TNS:no listener
   PRAGMA exception_init (server_timeout, -12535);  --ORA-12535: TNS:operation timed out
   PRAGMA exception_init (server_end_of_input, -29259);  --ORA-29259: end-of-input reached
   PRAGMA exception_init (syntax_error, -19112);  --ORA-19112: error raised during evaluation: Syntax error
   PRAGMA exception_init (xml_parsing, -31011);  --ORA-31011: XML parsing failed
   
   
   
   FUNCTION get_instance RETURN VARCHAR2;
   
   FUNCTION get_wl_server (
      p_id VARCHAR2
      ,p_key varchar2
   ) RETURN VARCHAR2;
   
   FUNCTION get_max_jobs RETURN INTEGER;
   
   FUNCTION get_ratio RETURN INTEGER;
   
   FUNCTION get_frequency RETURN INTEGER;
   
   FUNCTION test_ows_web_service (
      p_debug          BOOLEAN
      , p_server         VARCHAR2
      , p_service_name   VARCHAR2
   ) RETURN BOOLEAN;

   PROCEDURE ows_web_service (
      p_debug           BOOLEAN
      , p_show_request    BOOLEAN
      , p_show_response   BOOLEAN
      , p_server          VARCHAR2
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL      
      , p_job_id                VARCHAR2 DEFAULT NULL
      , p_service_name    VARCHAR2
      , p_list            p_tab
      , p_id              INTEGER
   );

   PROCEDURE ows_individual_screening (
      p_debug                     VARCHAR2 DEFAULT 'FALSE'
      , p_show_request              VARCHAR2 DEFAULT 'FALSE'
      , p_show_response             VARCHAR2 DEFAULT 'FALSE'
      , p_server                    VARCHAR2 DEFAULT NULL
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL
      , p_job_id                VARCHAR2 DEFAULT NULL
      , p_listsubkey                VARCHAR2 DEFAULT NULL
      , p_listrecordtype            VARCHAR2 DEFAULT NULL
      , p_listrecordorigin          VARCHAR2 DEFAULT NULL
      , p_custid                    VARCHAR2 DEFAULT NULL
      , p_custsubid                 VARCHAR2 DEFAULT NULL
      , p_passportnumber            VARCHAR2 DEFAULT NULL
      , p_nationalid                VARCHAR2 DEFAULT NULL
      , p_title                     VARCHAR2 DEFAULT NULL
      , p_fullname                  VARCHAR2 DEFAULT NULL
      , p_givennames                VARCHAR2 DEFAULT NULL
      , p_familyname                VARCHAR2 DEFAULT NULL
      , p_nametype                  VARCHAR2 DEFAULT NULL
      , p_namequality               VARCHAR2 DEFAULT NULL
      , p_primaryname               VARCHAR2 DEFAULT NULL
      , p_originalscriptname        VARCHAR2 DEFAULT NULL
      , p_gender                    VARCHAR2 DEFAULT NULL
      , p_dateofbirth               VARCHAR2 DEFAULT NULL
      , p_yearofbirth               VARCHAR2 DEFAULT NULL
      , p_occupation                VARCHAR2 DEFAULT NULL
      , p_address1                  VARCHAR2 DEFAULT NULL
      , p_address2                  VARCHAR2 DEFAULT NULL
      , p_address3                  VARCHAR2 DEFAULT NULL
      , p_address4                  VARCHAR2 DEFAULT NULL
      , p_city                      VARCHAR2 DEFAULT NULL
      , p_state                     VARCHAR2 DEFAULT NULL
      , p_postalcode                VARCHAR2 DEFAULT NULL
      , p_addresscountrycode        VARCHAR2 DEFAULT NULL
      , p_residencycountrycode      VARCHAR2 DEFAULT NULL
      , p_countryofbirthcode        VARCHAR2 DEFAULT NULL
      , p_nationalitycountrycodes   VARCHAR2 DEFAULT NULL
      , p_profilehyperlink          VARCHAR2 DEFAULT NULL
      , p_riskscore                 VARCHAR2 DEFAULT NULL
      , p_dataconfidencescore       VARCHAR2 DEFAULT NULL
      , p_dataconfidencecomment     VARCHAR2 DEFAULT NULL
      , p_customstring1             VARCHAR2 DEFAULT NULL
      , p_customstring2             VARCHAR2 DEFAULT NULL
      , p_customstring3             VARCHAR2 DEFAULT NULL
      , p_customstring4             VARCHAR2 DEFAULT NULL
      , p_customstring5             VARCHAR2 DEFAULT NULL
      , p_customstring6             VARCHAR2 DEFAULT NULL
      , p_customstring7             VARCHAR2 DEFAULT NULL
      , p_customstring8             VARCHAR2 DEFAULT NULL
      , p_customstring9             VARCHAR2 DEFAULT NULL
      , p_customstring10            VARCHAR2 DEFAULT NULL
      , p_customstring11            VARCHAR2 DEFAULT NULL
      , p_customstring12            VARCHAR2 DEFAULT NULL
      , p_customstring13            VARCHAR2 DEFAULT NULL
      , p_customstring14            VARCHAR2 DEFAULT NULL
      , p_customstring15            VARCHAR2 DEFAULT NULL
      , p_customstring16            VARCHAR2 DEFAULT NULL
      , p_customstring17            VARCHAR2 DEFAULT NULL
      , p_customstring18            VARCHAR2 DEFAULT NULL
      , p_customstring19            VARCHAR2 DEFAULT NULL
      , p_customstring20            VARCHAR2 DEFAULT NULL
      , p_customstring21            VARCHAR2 DEFAULT NULL
      , p_customstring22            VARCHAR2 DEFAULT NULL
      , p_customstring23            VARCHAR2 DEFAULT NULL
      , p_customstring24            VARCHAR2 DEFAULT NULL
      , p_customstring25            VARCHAR2 DEFAULT NULL
      , p_customstring26            VARCHAR2 DEFAULT NULL
      , p_customstring27            VARCHAR2 DEFAULT NULL
      , p_customstring28            VARCHAR2 DEFAULT NULL
      , p_customstring29            VARCHAR2 DEFAULT NULL
      , p_customstring30            VARCHAR2 DEFAULT NULL
      , p_customstring31            VARCHAR2 DEFAULT NULL
      , p_customstring32            VARCHAR2 DEFAULT NULL
      , p_customstring33            VARCHAR2 DEFAULT NULL
      , p_customstring34            VARCHAR2 DEFAULT NULL
      , p_customstring35            VARCHAR2 DEFAULT NULL
      , p_customstring36            VARCHAR2 DEFAULT NULL
      , p_customstring37            VARCHAR2 DEFAULT NULL
      , p_customstring38            VARCHAR2 DEFAULT NULL
      , p_customstring39            VARCHAR2 DEFAULT NULL
      , p_customstring40            VARCHAR2 DEFAULT NULL
      , p_customdate1               VARCHAR2 DEFAULT NULL
      , p_customdate2               VARCHAR2 DEFAULT NULL
      , p_customdate3               VARCHAR2 DEFAULT NULL
      , p_customdate4               VARCHAR2 DEFAULT NULL
      , p_customdate5               VARCHAR2 DEFAULT NULL
      , p_customnumber1             VARCHAR2 DEFAULT NULL
      , p_customnumber2             VARCHAR2 DEFAULT NULL
      , p_customnumber3             VARCHAR2 DEFAULT NULL
      , p_customnumber4             VARCHAR2 DEFAULT NULL
      , p_customnumber5             VARCHAR2 DEFAULT NULL      
   );

   PROCEDURE ows_entity_screening (
      p_debug                     VARCHAR2 DEFAULT 'FALSE'
      , p_show_request              VARCHAR2 DEFAULT 'FALSE'
      , p_show_response             VARCHAR2 DEFAULT 'FALSE'
      , p_server                    VARCHAR2 DEFAULT NULL 
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL      
      , p_job_id                VARCHAR2 DEFAULT NULL
      , p_listsubkey                VARCHAR2 DEFAULT NULL
      , p_listrecordtype            VARCHAR2 DEFAULT NULL
      , p_listrecordorigin          VARCHAR2 DEFAULT NULL
      , p_custid                    VARCHAR2 DEFAULT NULL
      , p_custsubid                 VARCHAR2 DEFAULT NULL
      , p_registrationnumber        VARCHAR2 DEFAULT NULL
      , p_entityname                VARCHAR2 DEFAULT NULL
      , p_nametype                  VARCHAR2 DEFAULT NULL
      , p_namequality               VARCHAR2 DEFAULT NULL
      , p_primaryname               VARCHAR2 DEFAULT NULL
      , p_originalscriptname        VARCHAR2 DEFAULT NULL
      , p_aliasisacronym            VARCHAR2 DEFAULT NULL
      , p_address1                  VARCHAR2 DEFAULT NULL
      , p_address2                  VARCHAR2 DEFAULT NULL
      , p_address3                  VARCHAR2 DEFAULT NULL
      , p_address4                  VARCHAR2 DEFAULT NULL
      , p_city                      VARCHAR2 DEFAULT NULL
      , p_state                     VARCHAR2 DEFAULT NULL
      , p_postalcode                VARCHAR2 DEFAULT NULL
      , p_addresscountrycode        VARCHAR2 DEFAULT NULL
      , p_registrationcountrycode   VARCHAR2 DEFAULT NULL
      , p_operatingcountrycodes     VARCHAR2 DEFAULT NULL
      , p_profilehyperlink          VARCHAR2 DEFAULT NULL
      , p_riskscore                 VARCHAR2 DEFAULT NULL
      , p_dataconfidencescore       VARCHAR2 DEFAULT NULL
      , p_dataconfidencecomment     VARCHAR2 DEFAULT NULL
      , p_customstring1             VARCHAR2 DEFAULT NULL
      , p_customstring2             VARCHAR2 DEFAULT NULL
      , p_customstring3             VARCHAR2 DEFAULT NULL
      , p_customstring4             VARCHAR2 DEFAULT NULL
      , p_customstring5             VARCHAR2 DEFAULT NULL
      , p_customstring6             VARCHAR2 DEFAULT NULL
      , p_customstring7             VARCHAR2 DEFAULT NULL
      , p_customstring8             VARCHAR2 DEFAULT NULL
      , p_customstring9             VARCHAR2 DEFAULT NULL
      , p_customstring10            VARCHAR2 DEFAULT NULL
      , p_customstring11            VARCHAR2 DEFAULT NULL
      , p_customstring12            VARCHAR2 DEFAULT NULL
      , p_customstring13            VARCHAR2 DEFAULT NULL
      , p_customstring14            VARCHAR2 DEFAULT NULL
      , p_customstring15            VARCHAR2 DEFAULT NULL
      , p_customstring16            VARCHAR2 DEFAULT NULL
      , p_customstring17            VARCHAR2 DEFAULT NULL
      , p_customstring18            VARCHAR2 DEFAULT NULL
      , p_customstring19            VARCHAR2 DEFAULT NULL
      , p_customstring20            VARCHAR2 DEFAULT NULL
      , p_customstring21            VARCHAR2 DEFAULT NULL
      , p_customstring22            VARCHAR2 DEFAULT NULL
      , p_customstring23            VARCHAR2 DEFAULT NULL
      , p_customstring24            VARCHAR2 DEFAULT NULL
      , p_customstring25            VARCHAR2 DEFAULT NULL
      , p_customstring26            VARCHAR2 DEFAULT NULL
      , p_customstring27            VARCHAR2 DEFAULT NULL
      , p_customstring28            VARCHAR2 DEFAULT NULL
      , p_customstring29            VARCHAR2 DEFAULT NULL
      , p_customstring30            VARCHAR2 DEFAULT NULL
      , p_customstring31            VARCHAR2 DEFAULT NULL
      , p_customstring32            VARCHAR2 DEFAULT NULL
      , p_customstring33            VARCHAR2 DEFAULT NULL
      , p_customstring34            VARCHAR2 DEFAULT NULL
      , p_customstring35            VARCHAR2 DEFAULT NULL
      , p_customstring36            VARCHAR2 DEFAULT NULL
      , p_customstring37            VARCHAR2 DEFAULT NULL
      , p_customstring38            VARCHAR2 DEFAULT NULL
      , p_customstring39            VARCHAR2 DEFAULT NULL
      , p_customstring40            VARCHAR2 DEFAULT NULL
      , p_customdate1               VARCHAR2 DEFAULT NULL
      , p_customdate2               VARCHAR2 DEFAULT NULL
      , p_customdate3               VARCHAR2 DEFAULT NULL
      , p_customdate4               VARCHAR2 DEFAULT NULL
      , p_customdate5               VARCHAR2 DEFAULT NULL
      , p_customnumber1             VARCHAR2 DEFAULT NULL
      , p_customnumber2             VARCHAR2 DEFAULT NULL
      , p_customnumber3             VARCHAR2 DEFAULT NULL
      , p_customnumber4             VARCHAR2 DEFAULT NULL
      , p_customnumber5             VARCHAR2 DEFAULT NULL
   );
   
      PROCEDURE ows_resubmit_screening (
      p_debug                     VARCHAR2 DEFAULT 'FALSE'
      , p_show_request              VARCHAR2 DEFAULT 'FALSE'
      , p_show_response             VARCHAR2 DEFAULT 'FALSE'
      , p_server          VARCHAR2
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL      
      , p_job_id                VARCHAR2 DEFAULT NULL
      , p_id              INTEGER
   );

END xwrl_utils;
/

CREATE OR REPLACE PACKAGE BODY xwrl_utils AS

   FUNCTION get_server (
      p_name VARCHAR2
   ) RETURN VARCHAR2 AS

      v_id      VARCHAR2 (100) := 'SERVER';
      v_key     VARCHAR2 (100);  
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
   
      FUNCTION get_wl_server (
      p_id VARCHAR2
      ,p_key varchar2
   ) RETURN VARCHAR2 AS

      v_id      VARCHAR2 (100);
      v_key     VARCHAR2 (100);  
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

      v_id := p_id;
      v_key := p_key;

      FOR c1rec IN c1 (v_id, v_key) LOOP v_value := c1rec.value_string;
      END LOOP;

      RETURN v_value;

   END get_wl_server;   

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
   
    FUNCTION get_loadbalance_server (
      p_name VARCHAR2
   ) RETURN VARCHAR2 AS

      v_id      VARCHAR2 (100) := 'LOADBALANCE_SERVER';
      v_key     VARCHAR2 (100);  
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

   END get_loadbalance_server;

   FUNCTION get_max_jobs RETURN INTEGER AS

      v_id      VARCHAR2 (100) := 'LOADBALANCER';
      v_key     VARCHAR2 (100) := 'MAX_JOBS';
      v_value   INTEGER;
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

      FOR c1rec IN c1 (v_id, v_key) LOOP v_value := c1rec.value_string;
      END LOOP;

      RETURN v_value;

   END get_max_jobs;
   
   FUNCTION get_ratio RETURN INTEGER AS

      v_id      VARCHAR2 (100) := 'LOADBALANCER';
      v_key     VARCHAR2 (100) := 'RATIO';
      v_value   INTEGER;
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

      FOR c1rec IN c1 (v_id, v_key) LOOP v_value := c1rec.value_string;
      END LOOP;

      RETURN v_value;

   END get_ratio;
   
   FUNCTION get_instance RETURN VARCHAR2 AS
   
   v_instance varchar2(50);
   
   BEGIN
   select instance_name into v_instance from v$instance;
   return v_instance;
   
   END get_instance;

FUNCTION get_frequency RETURN INTEGER AS

      v_id      VARCHAR2 (100) := 'FREQUENCY';
      v_key     VARCHAR2 (100) := get_instance;
      v_value   INTEGER;
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

      FOR c1rec IN c1 (v_id, v_key) LOOP v_value := c1rec.value_string;
      END LOOP;

      RETURN v_value;

   END get_frequency;


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
      utl_http.set_transfer_timeout(120);
      v_req := utl_http.begin_request (v_url);
      v_resp := utl_http.get_response (v_req);
      utl_http.end_response (v_resp);
      RETURN true;

   EXCEPTION
   WHEN others THEN  
        utl_http.end_response (v_resp);  -- Need to close out the Response on failure
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
         dbms_output.put_line ('v_request_rec.status : '||v_request_rec.status);
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
      IF v_request_rec.status != 'INVALID' THEN
         v_request_rec.status := 'ERROR';
         if utl_http.get_detailed_sqlcode is not null then
            v_request_rec.error_code := 'ORA' || utl_http.get_detailed_sqlcode;
        else             
            v_request_rec.error_code := 'ORA'||sqlcode;
        end if;
        if utl_http.get_detailed_sqlerrm is not null then
            v_request_rec.error_message := utl_http.get_detailed_sqlerrm;
        else 
            v_request_rec.error_message := sqlerrm;
       end if;            
   
         IF v_request_rec.error_code = 'ORA-12541' THEN
            v_request_rec.error_code :=  'ORA-12541' ;
            v_request_rec.error_message := v_request_rec.error_message || ' *** Server Needs to be Whitelisted ***';
         ELSIF v_request_rec.error_code = 'ORA-29259' THEN
            v_request_rec.error_code :=  'ORA-29259' ;
            v_request_rec.error_message := v_request_rec.error_message || ' *** Check if both OWS servers are down ***';            
         ELSIF v_request_rec.error_code = 'ORA-19112' THEN
           v_request_rec.error_code :=  'ORA-19112' ;
            v_request_rec.error_message := v_request_rec.error_message || ' *** Syntax error in the XML request ***';            
         ELSIF v_request_rec.error_code = 'ORA-31011' THEN
            v_request_rec.error_code :=  'ORA-31011' ;
            v_request_rec.error_message := v_request_rec.error_message || ' *** XML parsing failed ***';               
         END IF;
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

   PROCEDURE save_request_ind_columns (
      p_id INTEGER
   ) IS

      CURSOR c1 IS
      SELECT
         t.id
         , replace (x.listsubkey, '?', NULL) listsubkey
         , replace (x.listrecordtype, '?', NULL) listrecordtype
         , replace (x.listrecordorigin, '?', NULL) listrecordorigin
         , replace (x.custid, '?', NULL) custid
         , replace (x.custsubid, '?', NULL) custsubid
         , replace (x.passportnumber, '?', NULL) passportnumber
         , replace (x.nationalid, '?', NULL) nationalid
         , replace (x.title, '?', NULL) title
         , replace (x.fullname, '?', NULL) fullname
         , replace (x.givennames, '?', NULL) givennames
         , replace (x.familyname, '?', NULL) familyname
         , replace (x.nametype, '?', NULL) nametype
         , replace (x.namequality, '?', NULL) namequality
         , replace (x.primaryname, '?', NULL) primaryname
         , replace (x.originalscriptname, '?', NULL) originalscriptname
         , replace (x.gender, '?', NULL) gender
         , replace (x.dateofbirth, '?', NULL) dateofbirth
         , replace (x.yearofbirth, '?', NULL) yearofbirth
         , replace (x.occupation, '?', NULL) occupation
         , replace (x.address1, '?', NULL) address1
         , replace (x.address2, '?', NULL) address2
         , replace (x.address3, '?', NULL) address3
         , replace (x.address4, '?', NULL) address4
         , replace (x.city, '?', NULL) city
         , replace (x.state, '?', NULL) state
         , replace (x.postalcode, '?', NULL) postalcode
         , replace (x.addresscountrycode, '?', NULL) addresscountrycode
         , replace (x.residencycountrycode, '?', NULL) residencycountrycode
         , replace (x.countryofbirthcode, '?', NULL) countryofbirthcode
         , replace (x.nationalitycountrycodes, '?', NULL) nationalitycountrycodes
         , replace (x.profilehyperlink, '?', NULL) profilehyperlink
         , replace (x.riskscore, '?', NULL) riskscore
         , replace (x.dataconfidencescore, '?', NULL) dataconfidencescore
         , replace (x.dataconfidencecomment, '?', NULL) dataconfidencecomment
         , replace (x.customstring1, '?', NULL) customstring1
         , replace (x.customstring2, '?', NULL) customstring2
         , replace (x.customstring3, '?', NULL) customstring3
         , replace (x.customstring4, '?', NULL) customstring4
         , replace (x.customstring5, '?', NULL) customstring5
         , replace (x.customstring6, '?', NULL) customstring6
         , replace (x.customstring7, '?', NULL) customstring7
         , replace (x.customstring8, '?', NULL) customstring8
         , replace (x.customstring9, '?', NULL) customstring9
         , replace (x.customstring10, '?', NULL) customstring10
         , replace (x.customstring11, '?', NULL) customstring11
         , replace (x.customstring12, '?', NULL) customstring12
         , replace (x.customstring13, '?', NULL) customstring13
         , replace (x.customstring14, '?', NULL) customstring14
         , replace (x.customstring15, '?', NULL) customstring15
         , replace (x.customstring16, '?', NULL) customstring16
         , replace (x.customstring17, '?', NULL) customstring17
         , replace (x.customstring18, '?', NULL) customstring18
         , replace (x.customstring19, '?', NULL) customstring19
         , replace (x.customstring20, '?', NULL) customstring20
         , replace (x.customstring21, '?', NULL) customstring21
         , replace (x.customstring22, '?', NULL) customstring22
         , replace (x.customstring23, '?', NULL) customstring23
         , replace (x.customstring24, '?', NULL) customstring24
         , replace (x.customstring25, '?', NULL) customstring25
         , replace (x.customstring26, '?', NULL) customstring26
         , replace (x.customstring27, '?', NULL) customstring27
         , replace (x.customstring28, '?', NULL) customstring28
         , replace (x.customstring29, '?', NULL) customstring29
         , replace (x.customstring30, '?', NULL) customstring30
         , replace (x.customstring31, '?', NULL) customstring31
         , replace (x.customstring32, '?', NULL) customstring32
         , replace (x.customstring33, '?', NULL) customstring33
         , replace (x.customstring34, '?', NULL) customstring34
         , replace (x.customstring35, '?', NULL) customstring35
         , replace (x.customstring36, '?', NULL) customstring36
         , replace (x.customstring37, '?', NULL) customstring37
         , replace (x.customstring38, '?', NULL) customstring38
         , replace (x.customstring39, '?', NULL) customstring39
         , replace (x.customstring40, '?', NULL) customstring40
         , replace (x.customdate1, '?', NULL) customdate1
         , replace (x.customdate2, '?', NULL) customdate2
         , replace (x.customdate3, '?', NULL) customdate3
         , replace (x.customdate4, '?', NULL) customdate4
         , replace (x.customdate5, '?', NULL) customdate5
         , replace (x.customnumber1, '?', NULL) customnumber1
         , replace (x.customnumber2, '?', NULL) customnumber2
         , replace (x.customnumber3, '?', NULL) customnumber3
         , replace (x.customnumber4, '?', NULL) customnumber4
         , replace (x.customnumber5, '?', NULL) customnumber5
      FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "ws"), '//ws:request' PASSING t.request COLUMNS rec FOR ORDINALITY, listsubkey VARCHAR2 (2700) PATH 'ws:ListSubKey', listrecordtype VARCHAR2 (2700) PATH 'ws:ListRecordType', listrecordorigin VARCHAR2 (2700) PATH 'ws:ListRecordOrigin', custid VARCHAR2 (2700) PATH 'ws:CustId', custsubid VARCHAR2 (2700) PATH 'ws:CustSubId', passportnumber VARCHAR2 (2700) PATH 'ws:PassportNumber',
         nationalid VARCHAR2 (2700) PATH 'ws:NationalId', title VARCHAR2 (2700) PATH 'ws:Title', fullname VARCHAR2 (2700) PATH 'ws:FullName', givennames VARCHAR2 (2700) PATH 'ws:GivenNames', familyname VARCHAR2 (2700) PATH 'ws:FamilyName', nametype VARCHAR2 (2700) PATH 'ws:NameType', namequality VARCHAR2 (2700) PATH 'ws:NameQuality', primaryname VARCHAR2 (2700) PATH 'ws:PrimaryName', originalscriptname VARCHAR2 (2700) PATH 'ws:OriginalScriptName', gender VARCHAR2 (2700) PATH 'ws:Gender', dateofbirth
         VARCHAR2 (2700) PATH 'ws:DateOfBirth', yearofbirth VARCHAR2 (2700) PATH 'ws:YearOfBirth', occupation VARCHAR2 (2700) PATH 'ws:Occupation', address1 VARCHAR2 (2700) PATH 'ws:Address1', address2 VARCHAR2 (2700) PATH 'ws:Address2', address3 VARCHAR2 (2700) PATH 'ws:Address3', address4 VARCHAR2 (2700) PATH 'ws:Address4', city VARCHAR2 (2700) PATH 'ws:City', state VARCHAR2 (2700) PATH 'ws:State', postalcode VARCHAR2 (2700) PATH 'ws:PostalCode', addresscountrycode VARCHAR2 (2700) PATH 'ws:AddressCountryCode'
         , residencycountrycode VARCHAR2 (2700) PATH 'ws:ResidencyCountryCode', countryofbirthcode VARCHAR2 (2700) PATH 'ws:CountryOfBirthCode', nationalitycountrycodes VARCHAR2 (2700) PATH 'ws:NationalityCountryCodes', profilehyperlink VARCHAR2 (2700) PATH 'ws:ProfileHyperlink', riskscore VARCHAR2 (2700) PATH 'ws:RiskScore', dataconfidencescore VARCHAR2 (2700) PATH 'ws:DataConfidenceScore', dataconfidencecomment VARCHAR2 (2700) PATH 'ws:DataConfidenceComment', customstring1 VARCHAR2 (2700) PATH 'ws:CustomString1'
         , customstring2 VARCHAR2 (2700) PATH 'ws:CustomString2', customstring3 VARCHAR2 (2700) PATH 'ws:CustomString3', customstring4 VARCHAR2 (2700) PATH 'ws:CustomString4', customstring5 VARCHAR2 (2700) PATH 'ws:CustomString5', customstring6 VARCHAR2 (2700) PATH 'ws:CustomString6', customstring7 VARCHAR2 (2700) PATH 'ws:CustomString7', customstring8 VARCHAR2 (2700) PATH 'ws:CustomString8', customstring9 VARCHAR2 (2700) PATH 'ws:CustomString9', customstring10 VARCHAR2 (2700) PATH 'ws:CustomString10'
         , customstring11 VARCHAR2 (2700) PATH 'ws:CustomString11', customstring12 VARCHAR2 (2700) PATH 'ws:CustomString12', customstring13 VARCHAR2 (2700) PATH 'ws:CustomString13', customstring14 VARCHAR2 (2700) PATH 'ws:CustomString14', customstring15 VARCHAR2 (2700) PATH 'ws:CustomString15', customstring16 VARCHAR2 (2700) PATH 'ws:CustomString16', customstring17 VARCHAR2 (2700) PATH 'ws:CustomString17', customstring18 VARCHAR2 (2700) PATH 'ws:CustomString18', customstring19 VARCHAR2 (2700) PATH
         'ws:CustomString19', customstring20 VARCHAR2 (2700) PATH 'ws:CustomString20', customstring21 VARCHAR2 (2700) PATH 'ws:CustomString21', customstring22 VARCHAR2 (2700) PATH 'ws:CustomString22', customstring23 VARCHAR2 (2700) PATH 'ws:CustomString23', customstring24 VARCHAR2 (2700) PATH 'ws:CustomString24', customstring25 VARCHAR2 (2700) PATH 'ws:CustomString25', customstring26 VARCHAR2 (2700) PATH 'ws:CustomString26', customstring27 VARCHAR2 (2700) PATH 'ws:CustomString27', customstring28 VARCHAR2
         (2700) PATH 'ws:CustomString28', customstring29 VARCHAR2 (2700) PATH 'ws:CustomString29', customstring30 VARCHAR2 (2700) PATH 'ws:CustomString30', customstring31 VARCHAR2 (2700) PATH 'ws:CustomString31', customstring32 VARCHAR2 (2700) PATH 'ws:CustomString32', customstring33 VARCHAR2 (2700) PATH 'ws:CustomString33', customstring34 VARCHAR2 (2700) PATH 'ws:CustomString34', customstring35 VARCHAR2 (2700) PATH 'ws:CustomString35', customstring36 VARCHAR2 (2700) PATH 'ws:CustomString36', customstring37
         VARCHAR2 (2700) PATH 'ws:CustomString37', customstring38 VARCHAR2 (2700) PATH 'ws:CustomString38', customstring39 VARCHAR2 (2700) PATH 'ws:CustomString39', customstring40 VARCHAR2 (2700) PATH 'ws:CustomString40', customdate1 VARCHAR2 (2700) PATH 'ws:CustomDate1', customdate2 VARCHAR2 (2700) PATH 'ws:CustomDate2', customdate3 VARCHAR2 (2700) PATH 'ws:CustomDate3', customdate4 VARCHAR2 (2700) PATH 'ws:CustomDate4', customdate5 VARCHAR2 (2700) PATH 'ws:CustomDate5', customnumber1 VARCHAR2 (
         2700) PATH 'ws:CustomNumber1', customnumber2 VARCHAR2 (2700) PATH 'ws:CustomNumber2', customnumber3 VARCHAR2 (2700) PATH 'ws:CustomNumber3', customnumber4 VARCHAR2 (2700) PATH 'ws:CustomNumber4', customnumber5 VARCHAR2 (2700) PATH 'ws:CustomNumber5') x
      WHERE
         t.id = p_id  -- Individual
         ;

      v_rec xwrl_request_ind_columns%rowtype;

   BEGIN

      FOR c1rec IN c1 LOOP

         v_rec.request_id := c1rec.id;
         v_rec.listsubkey := c1rec.listsubkey;
         v_rec.listrecordtype := c1rec.listrecordtype;
         v_rec.listrecordorigin := c1rec.listrecordorigin;
         v_rec.custid := c1rec.custid;
         v_rec.custsubid := c1rec.custsubid;
         v_rec.passportnumber := c1rec.passportnumber;
         v_rec.nationalid := c1rec.nationalid;
         v_rec.title := c1rec.title;
         v_rec.fullname := c1rec.fullname;
         v_rec.givennames := c1rec.givennames;
         v_rec.familyname := c1rec.familyname;
         v_rec.nametype := c1rec.nametype;
         v_rec.namequality := c1rec.namequality;
         v_rec.primaryname := c1rec.primaryname;
         v_rec.originalscriptname := c1rec.originalscriptname;
         v_rec.gender := c1rec.gender;
         v_rec.dateofbirth := c1rec.dateofbirth;
         v_rec.yearofbirth := c1rec.yearofbirth;
         v_rec.occupation := c1rec.occupation;
         v_rec.address1 := c1rec.address1;
         v_rec.address2 := c1rec.address2;
         v_rec.address3 := c1rec.address3;
         v_rec.address4 := c1rec.address4;
         v_rec.city := c1rec.city;
         v_rec.state := c1rec.state;
         v_rec.postalcode := c1rec.postalcode;
         v_rec.addresscountrycode := c1rec.addresscountrycode;
         v_rec.residencycountrycode := c1rec.residencycountrycode;
         v_rec.countryofbirthcode := c1rec.countryofbirthcode;
         v_rec.nationalitycountrycodes := c1rec.nationalitycountrycodes;
         v_rec.profilehyperlink := c1rec.profilehyperlink;
         v_rec.riskscore := c1rec.riskscore;
         v_rec.dataconfidencescore := c1rec.dataconfidencescore;
         v_rec.dataconfidencecomment := c1rec.dataconfidencecomment;
         v_rec.customstring1 := c1rec.customstring1;
         v_rec.customstring2 := c1rec.customstring2;
         v_rec.customstring3 := c1rec.customstring3;
         v_rec.customstring4 := c1rec.customstring4;
         v_rec.customstring5 := c1rec.customstring5;
         v_rec.customstring6 := c1rec.customstring6;
         v_rec.customstring7 := c1rec.customstring7;
         v_rec.customstring8 := c1rec.customstring8;
         v_rec.customstring9 := c1rec.customstring9;
         v_rec.customstring10 := c1rec.customstring10;
         v_rec.customstring11 := c1rec.customstring11;
         v_rec.customstring12 := c1rec.customstring12;
         v_rec.customstring13 := c1rec.customstring13;
         v_rec.customstring14 := c1rec.customstring14;
         v_rec.customstring15 := c1rec.customstring15;
         v_rec.customstring16 := c1rec.customstring16;
         v_rec.customstring17 := c1rec.customstring17;
         v_rec.customstring18 := c1rec.customstring18;
         v_rec.customstring19 := c1rec.customstring19;
         v_rec.customstring20 := c1rec.customstring20;
         v_rec.customstring21 := c1rec.customstring21;
         v_rec.customstring22 := c1rec.customstring22;
         v_rec.customstring23 := c1rec.customstring23;
         v_rec.customstring24 := c1rec.customstring24;
         v_rec.customstring25 := c1rec.customstring25;
         v_rec.customstring26 := c1rec.customstring26;
         v_rec.customstring27 := c1rec.customstring27;
         v_rec.customstring28 := c1rec.customstring28;
         v_rec.customstring29 := c1rec.customstring29;
         v_rec.customstring30 := c1rec.customstring30;
         v_rec.customstring31 := c1rec.customstring31;
         v_rec.customstring32 := c1rec.customstring32;
         v_rec.customstring33 := c1rec.customstring33;
         v_rec.customstring34 := c1rec.customstring34;
         v_rec.customstring35 := c1rec.customstring35;
         v_rec.customstring36 := c1rec.customstring36;
         v_rec.customstring37 := c1rec.customstring37;
         v_rec.customstring38 := c1rec.customstring38;
         v_rec.customstring39 := c1rec.customstring39;
         v_rec.customstring40 := c1rec.customstring40;
         v_rec.customdate1 := c1rec.customdate1;
         v_rec.customdate2 := c1rec.customdate2;
         v_rec.customdate3 := c1rec.customdate3;
         v_rec.customdate4 := c1rec.customdate4;
         v_rec.customdate5 := c1rec.customdate5;
         v_rec.customnumber1 := c1rec.customnumber1;
         v_rec.customnumber2 := c1rec.customnumber2;
         v_rec.customnumber3 := c1rec.customnumber3;
         v_rec.customnumber4 := c1rec.customnumber4;
         v_rec.customnumber5 := c1rec.customnumber5;
         
         INSERT INTO xwrl_request_ind_columns
         VALUES v_rec;

      END LOOP;

      COMMIT;

   END save_request_ind_columns;

   PROCEDURE save_response_ind_columns (
      p_id INTEGER
   ) IS

      CURSOR c1 IS
      SELECT
         t.id
         , x.rec
         , x.listkey
         , x.listsubkey
         , x.listrecordtype
         , x.listrecordorigin
         , x.listid
         , x.listgivennames
         , x.listfamilyname
         , x.listfullname
         , x.listnametype
         , x.listprimaryname
         , x.listoriginalscriptname
         , x.listdob
         , x.listcity
         , x.listcountry
         , x.listcountryofbirth
         , x.listnationality
         , x.matchrule
         , x.matchscore
         , x.casekey
         , x.alertid
         , x.riskscore
         , x.riskscorepep
      FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "dn"), '//dn:response/dn:record' PASSING t.response COLUMNS rec FOR ORDINALITY, listkey VARCHAR2 (2700) PATH 'dn:ListKey', listsubkey VARCHAR2 (2700) PATH 'dn:ListSubKey', listrecordtype VARCHAR2 (2700) PATH 'dn:ListRecordType', listrecordorigin VARCHAR2 (2700) PATH 'dn:ListRecordOrigin', listid VARCHAR2 (2700) PATH 'dn:ListId', listgivennames VARCHAR2 (2700) PATH 'dn:ListGivenNames'
         , listfamilyname VARCHAR2 (2700) PATH 'dn:ListFamilyName', listfullname VARCHAR2 (2700) PATH 'dn:ListFullName', listnametype VARCHAR2 (2700) PATH 'dn:ListNameType', listprimaryname VARCHAR2 (2700) PATH 'dn:ListPrimaryName', listoriginalscriptname VARCHAR2 (2700) PATH 'dn:ListOriginalScriptName', listdob VARCHAR2 (2700) PATH 'dn:ListDOB', listcity VARCHAR2 (2700) PATH 'dn:ListCity', listcountry VARCHAR2 (2700) PATH 'dn:ListCountry', listcountryofbirth VARCHAR2 (2700) PATH 'dn:ListCountryOfBirth'
         , listnationality VARCHAR2 (2700) PATH 'dn:ListNationality', matchrule VARCHAR2 (2700) PATH 'dn:MatchRule', matchscore VARCHAR2 (2700) PATH 'dn:MatchScore', casekey VARCHAR2 (2700) PATH 'dn:CaseKey', alertid VARCHAR2 (2700) PATH 'dn:AlertId', riskscore VARCHAR2 (2700) PATH 'dn:RiskScore', riskscorepep VARCHAR2 (2700) PATH 'dn:RiskScorePEP') x
      WHERE
         t.id = p_id  -- Individual
         ;

      v_rec xwrl_response_ind_columns%rowtype;

   BEGIN

      FOR c1rec IN c1 LOOP

         v_rec.request_id := c1rec.id;
         v_rec.rec := c1rec.rec;
         v_rec.listkey := c1rec.listkey;
         v_rec.listsubkey := c1rec.listsubkey;
         v_rec.listrecordtype := c1rec.listrecordtype;
         v_rec.listrecordorigin := c1rec.listrecordorigin;
         v_rec.listid := c1rec.listid;
         v_rec.listgivennames := c1rec.listgivennames;
         v_rec.listfamilyname := c1rec.listfamilyname;
         v_rec.listfullname := c1rec.listfullname;
         v_rec.listnametype := c1rec.listnametype;
         v_rec.listprimaryname := c1rec.listprimaryname;
         v_rec.listoriginalscriptname := c1rec.listoriginalscriptname;
         v_rec.listdob := c1rec.listdob;
         v_rec.listcity := c1rec.listcity;
         v_rec.listcountry := c1rec.listcountry;
         v_rec.listcountryofbirth := c1rec.listcountryofbirth;
         v_rec.listnationality := c1rec.listnationality;
         v_rec.matchrule := c1rec.matchrule;
         v_rec.matchscore := c1rec.matchscore;
         v_rec.casekey := c1rec.casekey;
         v_rec.alertid := c1rec.alertid;
         v_rec.riskscore := c1rec.riskscore;
         v_rec.riskscorepep := c1rec.riskscorepep;

         INSERT INTO xwrl_response_ind_columns VALUES v_rec;

      END LOOP;

      COMMIT;

   END save_response_ind_columns;

   PROCEDURE save_request_entity_columns (
      p_id INTEGER
   ) IS

      CURSOR c1 IS
      SELECT
         t.id
         , replace (x.listsubkey, '?', NULL) listsubkey
         , replace (x.listrecordtype, '?', NULL) listrecordtype
         , replace (x.listrecordorigin, '?', NULL) listrecordorigin
         , replace (x.custid, '?', NULL) custid
         , replace (x.custsubid, '?', NULL) custsubid
         , replace (x.registrationnumber, '?', NULL) registrationnumber
         , replace (x.entityname, '?', NULL) entityname
         , replace (x.nametype, '?', NULL) nametype
         , replace (x.namequality, '?', NULL) namequality
         , replace (x.primaryname, '?', NULL) primaryname
         , replace (x.originalscriptname, '?', NULL) originalscriptname
         , replace (x.aliasisacronym, '?', NULL) aliasisacronym
         , replace (x.address1, '?', NULL) address1
         , replace (x.address2, '?', NULL) address2
         , replace (x.address3, '?', NULL) address3
         , replace (x.address4, '?', NULL) address4
         , replace (x.city, '?', NULL) city
         , replace (x.state, '?', NULL) state
         , replace (x.postalcode, '?', NULL) postalcode
         , replace (x.addresscountrycode, '?', NULL) addresscountrycode
         , replace (x.registrationcountrycode, '?', NULL) registrationcountrycode
         , replace (x.operatingcountrycodes, '?', NULL) operatingcountrycodes
         , replace (x.profilehyperlink, '?', NULL) profilehyperlink
         , replace (x.riskscore, '?', NULL) riskscore
         , replace (x.dataconfidencescore, '?', NULL) dataconfidencescore
         , replace (x.dataconfidencecomment, '?', NULL) dataconfidencecomment
         , replace (x.customstring1, '?', NULL) customstring1
         , replace (x.customstring2, '?', NULL) customstring2
         , replace (x.customstring3, '?', NULL) customstring3
         , replace (x.customstring4, '?', NULL) customstring4
         , replace (x.customstring5, '?', NULL) customstring5
         , replace (x.customstring6, '?', NULL) customstring6
         , replace (x.customstring7, '?', NULL) customstring7
         , replace (x.customstring8, '?', NULL) customstring8
         , replace (x.customstring9, '?', NULL) customstring9
         , replace (x.customstring10, '?', NULL) customstring10
         , replace (x.customstring11, '?', NULL) customstring11
         , replace (x.customstring12, '?', NULL) customstring12
         , replace (x.customstring13, '?', NULL) customstring13
         , replace (x.customstring14, '?', NULL) customstring14
         , replace (x.customstring15, '?', NULL) customstring15
         , replace (x.customstring16, '?', NULL) customstring16
         , replace (x.customstring17, '?', NULL) customstring17
         , replace (x.customstring18, '?', NULL) customstring18
         , replace (x.customstring19, '?', NULL) customstring19
         , replace (x.customstring20, '?', NULL) customstring20
         , replace (x.customstring21, '?', NULL) customstring21
         , replace (x.customstring22, '?', NULL) customstring22
         , replace (x.customstring23, '?', NULL) customstring23
         , replace (x.customstring24, '?', NULL) customstring24
         , replace (x.customstring25, '?', NULL) customstring25
         , replace (x.customstring26, '?', NULL) customstring26
         , replace (x.customstring27, '?', NULL) customstring27
         , replace (x.customstring28, '?', NULL) customstring28
         , replace (x.customstring29, '?', NULL) customstring29
         , replace (x.customstring30, '?', NULL) customstring30
         , replace (x.customstring31, '?', NULL) customstring31
         , replace (x.customstring32, '?', NULL) customstring32
         , replace (x.customstring33, '?', NULL) customstring33
         , replace (x.customstring34, '?', NULL) customstring34
         , replace (x.customstring35, '?', NULL) customstring35
         , replace (x.customstring36, '?', NULL) customstring36
         , replace (x.customstring37, '?', NULL) customstring37
         , replace (x.customstring38, '?', NULL) customstring38
         , replace (x.customstring39, '?', NULL) customstring39
         , replace (x.customstring40, '?', NULL) customstring40
         , replace (x.customdate1, '?', NULL) customdate1
         , replace (x.customdate2, '?', NULL) customdate2
         , replace (x.customdate3, '?', NULL) customdate3
         , replace (x.customdate4, '?', NULL) customdate4
         , replace (x.customdate5, '?', NULL) customdate5
         , replace (x.customnumber1, '?', NULL) customnumber1
         , replace (x.customnumber2, '?', NULL) customnumber2
         , replace (x.customnumber3, '?', NULL) customnumber3
         , replace (x.customnumber4, '?', NULL) customnumber4
         , replace (x.customnumber5, '?', NULL) customnumber5
      FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "ws"), '//ws:request' PASSING t.request COLUMNS rec FOR ORDINALITY, listsubkey VARCHAR2 (2700) PATH 'ws:ListSubKey', listrecordtype VARCHAR2 (2700) PATH 'ws:ListRecordType', listrecordorigin VARCHAR2 (2700) PATH 'ws:ListRecordOrigin', custid VARCHAR2 (2700) PATH 'ws:CustId', custsubid VARCHAR2 (2700) PATH 'ws:CustSubId', registrationnumber VARCHAR2 (2700) PATH 'ws:RegistrationNumber'
         , entityname VARCHAR2 (2700) PATH 'ws:EntityName', nametype VARCHAR2 (2700) PATH 'ws:NameType', namequality VARCHAR2 (2700) PATH 'ws:NameQuality', primaryname VARCHAR2 (2700) PATH 'ws:PrimaryName', originalscriptname VARCHAR2 (2700) PATH 'ws:OriginalScriptName', aliasisacronym VARCHAR2 (2700) PATH 'ws:AliasIsAcronym', address1 VARCHAR2 (2700) PATH 'ws:Address1', address2 VARCHAR2 (2700) PATH 'ws:Address2', address3 VARCHAR2 (2700) PATH 'ws:Address3', address4 VARCHAR2 (2700) PATH 'ws:Address4'
         , city VARCHAR2 (2700) PATH 'ws:City', state VARCHAR2 (2700) PATH 'ws:State', postalcode VARCHAR2 (2700) PATH 'ws:PostalCode', addresscountrycode VARCHAR2 (2700) PATH 'ws:AddressCountryCode', registrationcountrycode VARCHAR2 (2700) PATH 'ws:RegistrationCountryCode', operatingcountrycodes VARCHAR2 (2700) PATH 'ws:OperatingCountryCodes', profilehyperlink VARCHAR2 (2700) PATH 'ws:ProfileHyperlink', riskscore VARCHAR2 (2700) PATH 'ws:RiskScore', dataconfidencescore VARCHAR2 (2700) PATH 'ws:DataConfidenceScore'
         , dataconfidencecomment VARCHAR2 (2700) PATH 'ws:DataConfidenceComment', customstring1 VARCHAR2 (2700) PATH 'ws:CustomString1', customstring2 VARCHAR2 (2700) PATH 'ws:CustomString2', customstring3 VARCHAR2 (2700) PATH 'ws:CustomString3', customstring4 VARCHAR2 (2700) PATH 'ws:CustomString4', customstring5 VARCHAR2 (2700) PATH 'ws:CustomString5', customstring6 VARCHAR2 (2700) PATH 'ws:CustomString6', customstring7 VARCHAR2 (2700) PATH 'ws:CustomString7', customstring8 VARCHAR2 (2700) PATH
         'ws:CustomString8', customstring9 VARCHAR2 (2700) PATH 'ws:CustomString9', customstring10 VARCHAR2 (2700) PATH 'ws:CustomString10', customstring11 VARCHAR2 (2700) PATH 'ws:CustomString11', customstring12 VARCHAR2 (2700) PATH 'ws:CustomString12', customstring13 VARCHAR2 (2700) PATH 'ws:CustomString13', customstring14 VARCHAR2 (2700) PATH 'ws:CustomString14', customstring15 VARCHAR2 (2700) PATH 'ws:CustomString15', customstring16 VARCHAR2 (2700) PATH 'ws:CustomString16', customstring17 VARCHAR2
         (2700) PATH 'ws:CustomString17', customstring18 VARCHAR2 (2700) PATH 'ws:CustomString18', customstring19 VARCHAR2 (2700) PATH 'ws:CustomString19', customstring20 VARCHAR2 (2700) PATH 'ws:CustomString20', customstring21 VARCHAR2 (2700) PATH 'ws:CustomString21', customstring22 VARCHAR2 (2700) PATH 'ws:CustomString22', customstring23 VARCHAR2 (2700) PATH 'ws:CustomString23', customstring24 VARCHAR2 (2700) PATH 'ws:CustomString24', customstring25 VARCHAR2 (2700) PATH 'ws:CustomString25', customstring26
         VARCHAR2 (2700) PATH 'ws:CustomString26', customstring27 VARCHAR2 (2700) PATH 'ws:CustomString27', customstring28 VARCHAR2 (2700) PATH 'ws:CustomString28', customstring29 VARCHAR2 (2700) PATH 'ws:CustomString29', customstring30 VARCHAR2 (2700) PATH 'ws:CustomString30', customstring31 VARCHAR2 (2700) PATH 'ws:CustomString31', customstring32 VARCHAR2 (2700) PATH 'ws:CustomString32', customstring33 VARCHAR2 (2700) PATH 'ws:CustomString33', customstring34 VARCHAR2 (2700) PATH 'ws:CustomString34'
         , customstring35 VARCHAR2 (2700) PATH 'ws:CustomString35', customstring36 VARCHAR2 (2700) PATH 'ws:CustomString36', customstring37 VARCHAR2 (2700) PATH 'ws:CustomString37', customstring38 VARCHAR2 (2700) PATH 'ws:CustomString38', customstring39 VARCHAR2 (2700) PATH 'ws:CustomString39', customstring40 VARCHAR2 (2700) PATH 'ws:CustomString40', customdate1 VARCHAR2 (2700) PATH 'ws:CustomDate1', customdate2 VARCHAR2 (2700) PATH 'ws:CustomDate2', customdate3 VARCHAR2 (2700) PATH 'ws:CustomDate3'
         , customdate4 VARCHAR2 (2700) PATH 'ws:CustomDate4', customdate5 VARCHAR2 (2700) PATH 'ws:CustomDate5', customnumber1 VARCHAR2 (2700) PATH 'ws:CustomNumber1', customnumber2 VARCHAR2 (2700) PATH 'ws:CustomNumber2', customnumber3 VARCHAR2 (2700) PATH 'ws:CustomNumber3', customnumber4 VARCHAR2 (2700) PATH 'ws:CustomNumber4', customnumber5 VARCHAR2 (2700) PATH 'ws:CustomNumber5') x
      WHERE
         t.id = p_id -- Entity
         ;

      v_rec xwrl_request_entity_columns%rowtype;

   BEGIN

      FOR c1rec IN c1 LOOP
         v_rec.request_id := c1rec.id;
         v_rec.listsubkey := c1rec.listsubkey;
         v_rec.listrecordtype := c1rec.listrecordtype;
         v_rec.listrecordorigin := c1rec.listrecordorigin;
         v_rec.custid := c1rec.custid;
         v_rec.custsubid := c1rec.custsubid;
         v_rec.registrationnumber := c1rec.registrationnumber;
         v_rec.entityname := c1rec.entityname;
         v_rec.nametype := c1rec.nametype;
         v_rec.namequality := c1rec.namequality;
         v_rec.primaryname := c1rec.primaryname;
         v_rec.originalscriptname := c1rec.originalscriptname;
         v_rec.aliasisacronym := c1rec.aliasisacronym;
         v_rec.address1 := c1rec.address1;
         v_rec.address2 := c1rec.address2;
         v_rec.address3 := c1rec.address3;
         v_rec.address4 := c1rec.address4;
         v_rec.city := c1rec.city;
         v_rec.state := c1rec.state;
         v_rec.postalcode := c1rec.postalcode;
         v_rec.addresscountrycode := c1rec.addresscountrycode;
         v_rec.registrationcountrycode := c1rec.registrationcountrycode;
         v_rec.operatingcountrycodes := c1rec.operatingcountrycodes;
         v_rec.profilehyperlink := c1rec.profilehyperlink;
         v_rec.riskscore := c1rec.riskscore;
         v_rec.dataconfidencescore := c1rec.dataconfidencescore;
         v_rec.dataconfidencecomment := c1rec.dataconfidencecomment;
         v_rec.customstring1 := c1rec.customstring1;
         v_rec.customstring2 := c1rec.customstring2;
         v_rec.customstring3 := c1rec.customstring3;
         v_rec.customstring4 := c1rec.customstring4;
         v_rec.customstring5 := c1rec.customstring5;
         v_rec.customstring6 := c1rec.customstring6;
         v_rec.customstring7 := c1rec.customstring7;
         v_rec.customstring8 := c1rec.customstring8;
         v_rec.customstring9 := c1rec.customstring9;
         v_rec.customstring10 := c1rec.customstring10;
         v_rec.customstring11 := c1rec.customstring11;
         v_rec.customstring12 := c1rec.customstring12;
         v_rec.customstring13 := c1rec.customstring13;
         v_rec.customstring14 := c1rec.customstring14;
         v_rec.customstring15 := c1rec.customstring15;
         v_rec.customstring16 := c1rec.customstring16;
         v_rec.customstring17 := c1rec.customstring17;
         v_rec.customstring18 := c1rec.customstring18;
         v_rec.customstring19 := c1rec.customstring19;
         v_rec.customstring20 := c1rec.customstring20;
         v_rec.customstring21 := c1rec.customstring21;
         v_rec.customstring22 := c1rec.customstring22;
         v_rec.customstring23 := c1rec.customstring23;
         v_rec.customstring24 := c1rec.customstring24;
         v_rec.customstring25 := c1rec.customstring25;
         v_rec.customstring26 := c1rec.customstring26;
         v_rec.customstring27 := c1rec.customstring27;
         v_rec.customstring28 := c1rec.customstring28;
         v_rec.customstring29 := c1rec.customstring29;
         v_rec.customstring30 := c1rec.customstring30;
         v_rec.customstring31 := c1rec.customstring31;
         v_rec.customstring32 := c1rec.customstring32;
         v_rec.customstring33 := c1rec.customstring33;
         v_rec.customstring34 := c1rec.customstring34;
         v_rec.customstring35 := c1rec.customstring35;
         v_rec.customstring36 := c1rec.customstring36;
         v_rec.customstring37 := c1rec.customstring37;
         v_rec.customstring38 := c1rec.customstring38;
         v_rec.customstring39 := c1rec.customstring39;
         v_rec.customstring40 := c1rec.customstring40;
         v_rec.customdate1 := c1rec.customdate1;
         v_rec.customdate2 := c1rec.customdate2;
         v_rec.customdate3 := c1rec.customdate3;
         v_rec.customdate4 := c1rec.customdate4;
         v_rec.customdate5 := c1rec.customdate5;
         v_rec.customnumber1 := c1rec.customnumber1;
         v_rec.customnumber2 := c1rec.customnumber2;
         v_rec.customnumber3 := c1rec.customnumber3;
         v_rec.customnumber4 := c1rec.customnumber4;
         v_rec.customnumber5 := c1rec.customnumber5;

         INSERT INTO xwrl_request_entity_columns VALUES v_rec;

      END LOOP;

      COMMIT;

   END save_request_entity_columns;

   PROCEDURE save_response_entity_columns (
      p_id INTEGER
   ) IS

      CURSOR c1 IS
      SELECT
         t.id
         , x.rec
         , x.listkey
         , x.listsubkey
         , x.listrecordtype
         , x.listrecordorigin
         , x.listid
         , x.listentityname
         , x.listprimaryname
         , x.listoriginalscriptname
         , x.listnametype
         , x.listcity
         , x.listcountry
         , x.listoperatingcountries
         , x.listregistrationcountries
         , x.matchrule
         , x.matchscore
         , x.casekey
         , x.alertid
         , x.riskscore
         , x.riskscorepep
      FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "dn"), '//dn:response/dn:record' PASSING t.response COLUMNS rec FOR ORDINALITY, listkey VARCHAR2 (2700) PATH 'dn:ListKey', listsubkey VARCHAR2 (2700) PATH 'dn:ListSubKey', listrecordtype VARCHAR2 (2700) PATH 'dn:ListRecordType', listrecordorigin VARCHAR2 (2700) PATH 'dn:ListRecordOrigin', listid VARCHAR2 (2700) PATH 'dn:ListId', listentityname VARCHAR2 (2700) PATH 'dn:ListEntityName'
         , listprimaryname VARCHAR2 (2700) PATH 'dn:ListPrimaryName', listoriginalscriptname VARCHAR2 (2700) PATH 'dn:ListOriginalScriptName', listnametype VARCHAR2 (2700) PATH 'dn:ListNameType', listcity VARCHAR2 (2700) PATH 'dn:ListCity', listcountry VARCHAR2 (2700) PATH 'dn:ListCountry', listoperatingcountries VARCHAR2 (2700) PATH 'dn:ListOperatingCountries', listregistrationcountries VARCHAR2 (2700) PATH 'dn:ListRegistrationCountries', matchrule VARCHAR2 (2700) PATH 'dn:MatchRule', matchscore
         VARCHAR2 (2700) PATH 'dn:MatchScore', casekey VARCHAR2 (2700) PATH 'dn:CaseKey', alertid VARCHAR2 (2700) PATH 'dn:AlertId', riskscore VARCHAR2 (2700) PATH 'dn:RiskScore', riskscorepep VARCHAR2 (2700) PATH 'dn:RiskScorePEP') x
      WHERE
         t.id = p_id -- Entity
         ;

      v_rec xwrl_response_entity_columns%rowtype;

   BEGIN

      FOR c1rec IN c1 LOOP

         v_rec.request_id := c1rec.id;
         v_rec.rec := c1rec.rec;
         v_rec.listkey := c1rec.listkey;
         v_rec.listsubkey := c1rec.listsubkey;
         v_rec.listrecordtype := c1rec.listrecordtype;
         v_rec.listrecordorigin := c1rec.listrecordorigin;
         v_rec.listid := c1rec.listid;
         v_rec.listentityname := c1rec.listentityname;
         v_rec.listprimaryname := c1rec.listprimaryname;
         v_rec.listoriginalscriptname := c1rec.listoriginalscriptname;
         v_rec.listnametype := c1rec.listnametype;
         v_rec.listcity := c1rec.listcity;
         v_rec.listcountry := c1rec.listcountry;
         v_rec.listoperatingcountries := c1rec.listoperatingcountries;
         v_rec.listregistrationcountries := c1rec.listregistrationcountries;
         v_rec.matchrule := c1rec.matchrule;
         v_rec.matchscore := c1rec.matchscore;
         v_rec.casekey := c1rec.casekey;
         v_rec.alertid := c1rec.alertid;
         v_rec.riskscore := c1rec.riskscore;
         v_rec.riskscorepep := c1rec.riskscorepep;

         INSERT INTO xwrl_response_entity_columns VALUES v_rec;

      END LOOP;

      COMMIT;

   END save_response_entity_columns;

   PROCEDURE save_request_rows (
      p_id INTEGER
   ) IS

      CURSOR c1 IS
      SELECT
         t.id
         , t.path
         , x.rw
         , x.key
         , replace (x.value, '?', NULL) value
      FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "soapenv", 'http://www.datanomic.com/ws' AS "ws"), '//ws:request/ws:*' PASSING t.request COLUMNS rw FOR ORDINALITY, key VARCHAR2 (100) PATH 'name()', value VARCHAR2 (2700) PATH 'text()') x
      WHERE
         t.id = p_id  -- Individual or Entity
         ;

      v_rec xwrl_request_rows%rowtype;

   BEGIN

      FOR c1rec IN c1 LOOP
         v_rec.request_id := c1rec.id;
         v_rec.path := c1rec.path;
         v_rec.rw := c1rec.rw;
         v_rec.key := c1rec.key;
         v_rec.value := c1rec.value;

         INSERT INTO xwrl_request_rows VALUES v_rec;

      END LOOP;

      COMMIT;

   END save_request_rows;

   PROCEDURE save_response_rows (
      p_id INTEGER
   ) IS

      CURSOR c1 IS
      SELECT
         t.id
         , t.path
         , resp.ows_id
         , rec.rec_row
         , det.det_row
         , det.key
         , det.value
      FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "dn"), '//dn:response' PASSING t.response COLUMNS ows_id VARCHAR2 (50) PATH '@id', record_list XMLTYPE PATH '*') resp
         , XMLTABLE ('/*' PASSING resp.record_list COLUMNS rec_row FOR ORDINALITY, detail_list XMLTYPE PATH '*') rec
         , XMLTABLE ('/*' PASSING rec.detail_list COLUMNS det_row FOR ORDINALITY, key VARCHAR2 (100) PATH 'name()', value VARCHAR2 (2700) PATH 'text()') det
      WHERE
         t.id = p_id  -- Individual or Entity.det_row      
      ORDER BY
         rec.rec_row
         , det.det_row;

      v_rec xwrl_response_rows%rowtype;

   BEGIN

      FOR c1rec IN c1 LOOP
         v_rec.request_id := c1rec.id;
         v_rec.path := c1rec.path;
         v_rec.ows_id := c1rec.ows_id;
         v_rec.rec_row := c1rec.rec_row;
         v_rec.det_row := c1rec.det_row;
         v_rec.key := c1rec.key;
         v_rec.value := c1rec.value;

         INSERT INTO xwrl_response_rows VALUES v_rec;

      END LOOP;

      COMMIT;

   END save_response_rows;

   PROCEDURE ows_web_service (
      p_debug           BOOLEAN
      , p_show_request    BOOLEAN
      , p_show_response   BOOLEAN
      , p_server          VARCHAR2
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL      
      , p_job_id                VARCHAR2 DEFAULT NULL
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
      v_count INTEGER;

   BEGIN

	-- Initial request record
      v_request_rec := NULL;
      v_request_rec.status := 'INITIALIZED';
      v_request_rec.job_id := p_job_id;

      IF p_id IS NOT NULL THEN  -- Note: A resubmit uses a Request ID
         is_resubmit := true;
      END IF;
      
  -- Save record attributes
      v_request_rec.source_table := p_source_table;
      v_request_rec.source_id := p_source_id;
      v_request_rec.wc_screening_request_id := p_wc_screening_request_id;
      
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

      -- Check parameters
         IF p_debug THEN
            dbms_output.put_line ('/--- Check parameters --/');
            dbms_output.put_line ('p_list: ' || p_list.count);
         END IF;

         IF p_list.count = 0 THEN
               v_request_rec.status := 'INVALID';
               v_request_rec.error_message := 'Invalid Request.  Need at least one parameter';
              raise xwrl_utils.invalid_request;
         END IF;

         IF p_service_name = 'INDIVIDUAL' THEN
            v_soap_xml := get_xml ('REQUEST_INDIVIDUAL');
         ELSIF p_service_name = 'ENTITY' THEN
            v_soap_xml := get_xml ('REQUEST_ENTITY');
         END IF;
   
      -- Replace Node Values 
         IF p_debug THEN
            dbms_output.put_line ('/--- Replace Node Values --/');
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
         
         v_request_rec.soap_query := v_soap_query;  -- Savepoint of query in case XMLQUERY fails with syntax error
   
         -- Replaced UPDATEXML with XMLQUERY              
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
      is_service_available := test_ows_web_service (p_debug => p_debug, p_server => p_server, p_service_name => 'EDQ');
      IF is_service_available = false THEN
         v_request_rec.status := 'ERROR';
         RAISE xwrl_utils.server_unavailable;
      END IF;

   -- Send Request 
      IF p_debug THEN
         dbms_output.put_line ('/--- Send Request --/');
      END IF;
      utl_http.set_transfer_timeout(300); -- Note: Longest running job was 7:52
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
            status = decode(v_request_rec.status,'ERROR','FAILED','RESUBMIT')
         WHERE
            id = p_id;
         COMMIT;
      END IF;

   -- Parse Request to save data
      IF v_path = 'INDIVIDUAL' THEN
         xwrl_utils.save_request_ind_columns (v_id);         
      ELSIF v_path = 'ENTITY' THEN
         xwrl_utils.save_request_entity_columns (v_id);         
      END IF;
      xwrl_utils.save_request_rows (v_id);
     
   -- Parse Respone to save data
      IF v_path = 'INDIVIDUAL' THEN
         xwrl_utils.save_response_ind_columns (v_id);
         SELECT COUNT(*) INTO v_count FROM xwrl_response_ind_columns WHERE request_id = v_id;
      ELSIF v_path = 'ENTITY' THEN
         xwrl_utils.save_response_entity_columns (v_id);
         SELECT COUNT(*) INTO v_count FROM xwrl_response_entity_columns WHERE request_id = v_id;
      END IF;
      xwrl_utils.save_response_rows (v_id);      
      
      UPDATE xwrl_requests
      SET matches = v_count
      WHERE id = v_id;
      
      COMMIT;

   EXCEPTION
   -- Need to create an email notification for these exceptions
   -- Note: Those with an Error condition can be resubmitted
   -- Note: Needed a comment out raise exception for the dbms_scheduler job to run so errors are logged in the request table.            
      WHEN utl_http.BAD_ARGUMENT THEN
         dbms_output.put_line ('Error: utl_http.BAD_ARGUMENT'); -- 29261
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.BAD_ARGUMENT');      
      WHEN utl_http.BAD_URL THEN
         dbms_output.put_line ('Error: utl_http.BAD_URL'); -- 29262
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.BAD_URL');               
      WHEN utl_http.END_OF_BODY THEN
         dbms_output.put_line ('Error: utl_http.END_OF_BODY'); -- 29266
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.END_OF_BODY');               
      WHEN utl_http.HEADER_NOT_FOUND THEN
         dbms_output.put_line ('Error: utl_http.HEADER_NOT_FOUND'); -- 29265
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.HEADER_NOT_FOUND');               
      WHEN utl_http.HTTP_CLIENT_ERROR THEN
         dbms_output.put_line ('Error: utl_http.HTTP_CLIENT_ERROR'); -- 29268
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.HTTP_CLIENT_ERROR');               
      WHEN utl_http.HTTP_SERVER_ERROR THEN
         dbms_output.put_line ('Error: utl_http.HTTP_SERVER_ERROR'); -- 29269
         v_request_rec.error_message := v_request_rec.error_message || ' *** Check if Real-Time Screening Jobs are running ***';
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.HTTP_SERVER_ERROR');           
      WHEN utl_http.NETWORK_ACCESS_DENIED THEN
         dbms_output.put_line ('Error: utl_http.NETWORK_ACCESS_DENIED'); -- 29247
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.NETWORK_ACCESS_DENIED');      
      WHEN utl_http.ILLEGAL_CALL THEN
         dbms_output.put_line ('Error: utl_http.ILLEGAL_CALL'); -- 29267
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.ILLEGAL_CALL');      
      /*
      WHEN utl_http.PARTIAL_MULTIBYTE_EXCEPTION THEN
         dbms_output.put_line ('Error: utl_http.PARTIAL_MULTIBYTE_EXCEPTION'); -- 29275
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.PARTIAL_MULTIBYTE_EXCEPTION');      
         */
      WHEN utl_http.PROTOCOL_ERROR THEN
         dbms_output.put_line ('Error: utl_http.PROTOCOL_ERROR'); -- 29263
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.PROTOCOL_ERROR');      
      WHEN utl_http.REQUEST_FAILED THEN
		   /* Note: You can have a maximum of 5 HTTP requests per session (see MOS note 961468. */
         dbms_output.put_line ('Error: utl_http.REQUEST_FAILED'); -- 29273
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.REQUEST_FAILED');          
      WHEN utl_http.TOO_MANY_REQUESTS THEN
		   /* Note: You can have a maximum of 5 HTTP requests per session (see MOS note 961468. */
         dbms_output.put_line ('Error: utl_http.TOO_MANY_REQUESTS'); -- 29270
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.TOO_MANY_REQUESTS');         
      WHEN utl_http.TRANSFER_TIMEOUT THEN
         dbms_output.put_line ('Error: utl_http.TRANSFER_TIMEOUT'); -- 29276
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.TRANSFER_TIMEOUT');
       WHEN utl_http.UNKNOWN_SCHEME THEN
         dbms_output.put_line ('Error: utl_http.UNKNOWN_SCHEME'); -- 29264
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         --raise_application_error (-20100, 'Error: utl_http.UNKNOWN_SCHEME')
         
      WHEN xwrl_utils.server_unavailable THEN
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.SERVER_UNAVAILABLE');
         --raise_application_error (-20100, 'Error: xwrl_utils.SERVER_UNAVAILABLE');
      WHEN xwrl_utils.server_not_whitelisted THEN
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.SERVER_NOT_WHITELISTED');
         --raise_application_error (-20100, 'Error: xwrl_utils.SERVER_NOT_WHITELISTED');
      WHEN xwrl_utils.server_timeout THEN
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.SERVER_TIMEOUT');
         --raise_application_error (-20100, 'Error: xwrl_utils.SERVER_TIMEOUT');
      WHEN xwrl_utils.server_end_of_input THEN
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.SERVER_END_OF_INPUT');
         --raise_application_error (-20100, 'Error: xwrl_utils.SERVER_END_OF_INPUT');
      WHEN xwrl_utils.syntax_error THEN
         v_request_rec.error_message := 'ORA-19112: error raised during evaluation: ';
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.SYNTAX_ERROR');
         --raise_application_error (-20100, 'Error: xwrl_utils.SYNTAX_ERROR');         
      WHEN xwrl_utils.xml_parsing THEN
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.XML_PARSING');
         --raise_application_error (-20100, 'Error: xwrl_utils.XML_PARSING');                  
      WHEN xwrl_utils.invalid_request THEN
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.INVALID_REQUEST');
         --raise_application_error (-20100, 'Error: xwrl_utils.INVALID_REQUEST');                  
      WHEN OTHERS THEN         
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.OTHERS');         
         --raise_application_error (-20100, 'Error: OTHERS');                  
   END ows_web_service;

   PROCEDURE ows_individual_screening (
      p_debug                     VARCHAR2 DEFAULT 'FALSE'
      , p_show_request              VARCHAR2 DEFAULT 'FALSE'
      , p_show_response             VARCHAR2 DEFAULT 'FALSE'
      , p_server                    VARCHAR2 DEFAULT NULL 
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL      
      , p_job_id                VARCHAR2 DEFAULT NULL
      , p_listsubkey                VARCHAR2 DEFAULT NULL
      , p_listrecordtype            VARCHAR2 DEFAULT NULL
      , p_listrecordorigin          VARCHAR2 DEFAULT NULL
      , p_custid                    VARCHAR2 DEFAULT NULL
      , p_custsubid                 VARCHAR2 DEFAULT NULL
      , p_passportnumber            VARCHAR2 DEFAULT NULL
      , p_nationalid                VARCHAR2 DEFAULT NULL
      , p_title                     VARCHAR2 DEFAULT NULL
      , p_fullname                  VARCHAR2 DEFAULT NULL
      , p_givennames                VARCHAR2 DEFAULT NULL
      , p_familyname                VARCHAR2 DEFAULT NULL
      , p_nametype                  VARCHAR2 DEFAULT NULL
      , p_namequality               VARCHAR2 DEFAULT NULL
      , p_primaryname               VARCHAR2 DEFAULT NULL
      , p_originalscriptname        VARCHAR2 DEFAULT NULL
      , p_gender                    VARCHAR2 DEFAULT NULL
      , p_dateofbirth               VARCHAR2 DEFAULT NULL
      , p_yearofbirth               VARCHAR2 DEFAULT NULL
      , p_occupation                VARCHAR2 DEFAULT NULL
      , p_address1                  VARCHAR2 DEFAULT NULL
      , p_address2                  VARCHAR2 DEFAULT NULL
      , p_address3                  VARCHAR2 DEFAULT NULL
      , p_address4                  VARCHAR2 DEFAULT NULL
      , p_city                      VARCHAR2 DEFAULT NULL
      , p_state                     VARCHAR2 DEFAULT NULL
      , p_postalcode                VARCHAR2 DEFAULT NULL
      , p_addresscountrycode        VARCHAR2 DEFAULT NULL
      , p_residencycountrycode      VARCHAR2 DEFAULT NULL
      , p_countryofbirthcode        VARCHAR2 DEFAULT NULL
      , p_nationalitycountrycodes   VARCHAR2 DEFAULT NULL
      , p_profilehyperlink          VARCHAR2 DEFAULT NULL
      , p_riskscore                 VARCHAR2 DEFAULT NULL
      , p_dataconfidencescore       VARCHAR2 DEFAULT NULL
      , p_dataconfidencecomment     VARCHAR2 DEFAULT NULL
      , p_customstring1             VARCHAR2 DEFAULT NULL
      , p_customstring2             VARCHAR2 DEFAULT NULL
      , p_customstring3             VARCHAR2 DEFAULT NULL
      , p_customstring4             VARCHAR2 DEFAULT NULL
      , p_customstring5             VARCHAR2 DEFAULT NULL
      , p_customstring6             VARCHAR2 DEFAULT NULL
      , p_customstring7             VARCHAR2 DEFAULT NULL
      , p_customstring8             VARCHAR2 DEFAULT NULL
      , p_customstring9             VARCHAR2 DEFAULT NULL
      , p_customstring10            VARCHAR2 DEFAULT NULL
      , p_customstring11            VARCHAR2 DEFAULT NULL
      , p_customstring12            VARCHAR2 DEFAULT NULL
      , p_customstring13            VARCHAR2 DEFAULT NULL
      , p_customstring14            VARCHAR2 DEFAULT NULL
      , p_customstring15            VARCHAR2 DEFAULT NULL
      , p_customstring16            VARCHAR2 DEFAULT NULL
      , p_customstring17            VARCHAR2 DEFAULT NULL
      , p_customstring18            VARCHAR2 DEFAULT NULL
      , p_customstring19            VARCHAR2 DEFAULT NULL
      , p_customstring20            VARCHAR2 DEFAULT NULL
      , p_customstring21            VARCHAR2 DEFAULT NULL
      , p_customstring22            VARCHAR2 DEFAULT NULL
      , p_customstring23            VARCHAR2 DEFAULT NULL
      , p_customstring24            VARCHAR2 DEFAULT NULL
      , p_customstring25            VARCHAR2 DEFAULT NULL
      , p_customstring26            VARCHAR2 DEFAULT NULL
      , p_customstring27            VARCHAR2 DEFAULT NULL
      , p_customstring28            VARCHAR2 DEFAULT NULL
      , p_customstring29            VARCHAR2 DEFAULT NULL
      , p_customstring30            VARCHAR2 DEFAULT NULL
      , p_customstring31            VARCHAR2 DEFAULT NULL
      , p_customstring32            VARCHAR2 DEFAULT NULL
      , p_customstring33            VARCHAR2 DEFAULT NULL
      , p_customstring34            VARCHAR2 DEFAULT NULL
      , p_customstring35            VARCHAR2 DEFAULT NULL
      , p_customstring36            VARCHAR2 DEFAULT NULL
      , p_customstring37            VARCHAR2 DEFAULT NULL
      , p_customstring38            VARCHAR2 DEFAULT NULL
      , p_customstring39            VARCHAR2 DEFAULT NULL
      , p_customstring40            VARCHAR2 DEFAULT NULL
      , p_customdate1               VARCHAR2 DEFAULT NULL
      , p_customdate2               VARCHAR2 DEFAULT NULL
      , p_customdate3               VARCHAR2 DEFAULT NULL
      , p_customdate4               VARCHAR2 DEFAULT NULL
      , p_customdate5               VARCHAR2 DEFAULT NULL
      , p_customnumber1             VARCHAR2 DEFAULT NULL
      , p_customnumber2             VARCHAR2 DEFAULT NULL
      , p_customnumber3             VARCHAR2 DEFAULT NULL
      , p_customnumber4             VARCHAR2 DEFAULT NULL
      , p_customnumber5             VARCHAR2 DEFAULT NULL
   ) IS

      v_debug                     boolean := false;
      v_show_request              boolean := false;
      v_show_response             boolean := false;
      v_instance varchar2(50);
      v_server varchar2(50);      
      v_list p_tab;

   BEGIN   

      IF p_debug = 'TRUE' THEN
          v_debug := true;
      END IF;

      IF p_show_request = 'TRUE' THEN
          v_show_request := true;
      END IF;
      
      IF p_show_response = 'TRUE' THEN
          v_show_response := true;
      END IF;

      IF p_server IS NOT NULL THEN
          v_server := p_server;
      ELSE
         v_instance := get_instance;
          v_server := get_wl_server ('LOADBALANCE_SERVER',v_instance);
      END IF;     
      
      IF p_listsubkey IS NOT NULL THEN
         v_list (1).key := 'ListSubKey';
         v_list (1).value := p_listsubkey;
      END IF;
      IF p_listrecordtype IS NOT NULL THEN
         v_list (2).key := 'ListRecordType';
         v_list (2).value := p_listrecordtype;
      END IF;
      IF p_listrecordorigin IS NOT NULL THEN
         v_list (3).key := 'ListRecordOrigin';
         v_list (3).value := p_listrecordorigin;
      END IF;
      IF p_custid IS NOT NULL THEN
         v_list (4).key := 'CustId';
         v_list (4).value := p_custid;
      END IF;
      IF p_custsubid IS NOT NULL THEN
         v_list (5).key := 'CustSubId';
         v_list (5).value := p_custsubid;
      END IF;
      IF p_passportnumber IS NOT NULL THEN
         v_list (6).key := 'PassportNumber';
         v_list (6).value := p_passportnumber;
      END IF;
      IF p_nationalid IS NOT NULL THEN
         v_list (7).key := 'NationalId';
         v_list (7).value := p_nationalid;
      END IF;
      IF p_title IS NOT NULL THEN
         v_list (8).key := 'Title';
         v_list (8).value := p_title;
      END IF;
      IF p_fullname IS NOT NULL THEN
         v_list (9).key := 'FullName';
         v_list (9).value := p_fullname;
      END IF;
      IF p_givennames IS NOT NULL THEN
         v_list (10).key := 'GivenNames';
         v_list (10).value := p_givennames;
      END IF;
      IF p_familyname IS NOT NULL THEN
         v_list (11).key := 'FamilyName';
         v_list (11).value := p_familyname;
      END IF;
      IF p_nametype IS NOT NULL THEN
         v_list (12).key := 'NameType';
         v_list (12).value := p_nametype;
      END IF;
      IF p_namequality IS NOT NULL THEN
         v_list (13).key := 'NameQuality';
         v_list (13).value := p_namequality;
      END IF;
      IF p_primaryname IS NOT NULL THEN
         v_list (14).key := 'PrimaryName';
         v_list (14).value := p_primaryname;
      END IF;
      IF p_originalscriptname IS NOT NULL THEN
         v_list (15).key := 'OriginalScriptName';
         v_list (15).value := p_originalscriptname;
      END IF;
      IF p_gender IS NOT NULL THEN
         v_list (16).key := 'Gender';
         v_list (16).value := p_gender;
      END IF;
      IF p_dateofbirth IS NOT NULL THEN
         v_list (17).key := 'DateOfBirth';
         v_list (17).value := p_dateofbirth;
      END IF;
      IF p_yearofbirth IS NOT NULL THEN
         v_list (18).key := 'YearOfBirth';
         v_list (18).value := p_yearofbirth;
      END IF;
      IF p_occupation IS NOT NULL THEN
         v_list (19).key := 'Occupation';
         v_list (19).value := p_occupation;
      END IF;
      IF p_address1 IS NOT NULL THEN
         v_list (20).key := 'Address1';
         v_list (20).value := p_address1;
      END IF;
      IF p_address2 IS NOT NULL THEN
         v_list (21).key := 'Address2';
         v_list (21).value := p_address2;
      END IF;
      IF p_address3 IS NOT NULL THEN
         v_list (22).key := 'Address3';
         v_list (22).value := p_address3;
      END IF;
      IF p_address4 IS NOT NULL THEN
         v_list (23).key := 'Address4';
         v_list (23).value := p_address4;
      END IF;
      IF p_city IS NOT NULL THEN
         v_list (24).key := 'City';
         v_list (24).value := p_city;
      END IF;
      IF p_state IS NOT NULL THEN
         v_list (25).key := 'State';
         v_list (25).value := p_state;
      END IF;
      IF p_postalcode IS NOT NULL THEN
         v_list (26).key := 'PostalCode';
         v_list (26).value := p_postalcode;
      END IF;
      IF p_addresscountrycode IS NOT NULL THEN
         v_list (27).key := 'AddressCountryCode';
         v_list (27).value := p_addresscountrycode;
      END IF;
      IF p_residencycountrycode IS NOT NULL THEN
         v_list (28).key := 'ResidencyCountryCode';
         v_list (28).value := p_residencycountrycode;
      END IF;
      IF p_countryofbirthcode IS NOT NULL THEN
         v_list (29).key := 'CountryOfBirthCode';
         v_list (29).value := p_countryofbirthcode;
      END IF;
      IF p_nationalitycountrycodes IS NOT NULL THEN
         v_list (30).key := 'NationalityCountryCodes';
         v_list (30).value := p_nationalitycountrycodes;
      END IF;
      IF p_profilehyperlink IS NOT NULL THEN
         v_list (31).key := 'ProfileHyperlink';
         v_list (31).value := p_profilehyperlink;
      END IF;
      IF p_riskscore IS NOT NULL THEN
         v_list (32).key := 'RiskScore';
         v_list (32).value := p_riskscore;
      END IF;
      IF p_dataconfidencescore IS NOT NULL THEN
         v_list (33).key := 'DataConfidenceScore';
         v_list (33).value := p_dataconfidencescore;
      END IF;
      IF p_dataconfidencecomment IS NOT NULL THEN
         v_list (34).key := 'DataConfidenceComment';
         v_list (34).value := p_dataconfidencecomment;
      END IF;
      IF p_customstring1 IS NOT NULL THEN
         v_list (35).key := 'CustomString1';
         v_list (35).value := p_customstring1;
      END IF;
      IF p_customstring2 IS NOT NULL THEN
         v_list (36).key := 'CustomString2';
         v_list (36).value := p_customstring2;
      END IF;
      IF p_customstring3 IS NOT NULL THEN
         v_list (37).key := 'CustomString3';
         v_list (37).value := p_customstring3;
      END IF;
      IF p_customstring4 IS NOT NULL THEN
         v_list (38).key := 'CustomString4';
         v_list (38).value := p_customstring4;
      END IF;
      IF p_customstring5 IS NOT NULL THEN
         v_list (39).key := 'CustomString5';
         v_list (39).value := p_customstring5;
      END IF;
      IF p_customstring6 IS NOT NULL THEN
         v_list (40).key := 'CustomString6';
         v_list (40).value := p_customstring6;
      END IF;
      IF p_customstring7 IS NOT NULL THEN
         v_list (41).key := 'CustomString7';
         v_list (41).value := p_customstring7;
      END IF;
      IF p_customstring8 IS NOT NULL THEN
         v_list (42).key := 'CustomString8';
         v_list (42).value := p_customstring8;
      END IF;
      IF p_customstring9 IS NOT NULL THEN
         v_list (43).key := 'CustomString9';
         v_list (43).value := p_customstring9;
      END IF;
      IF p_customstring10 IS NOT NULL THEN
         v_list (44).key := 'CustomString10';
         v_list (44).value := p_customstring10;
      END IF;
      IF p_customstring11 IS NOT NULL THEN
         v_list (45).key := 'CustomString11';
         v_list (45).value := p_customstring11;
      END IF;
      IF p_customstring12 IS NOT NULL THEN
         v_list (46).key := 'CustomString12';
         v_list (46).value := p_customstring12;
      END IF;
      IF p_customstring13 IS NOT NULL THEN
         v_list (47).key := 'CustomString13';
         v_list (47).value := p_customstring13;
      END IF;
      IF p_customstring14 IS NOT NULL THEN
         v_list (48).key := 'CustomString14';
         v_list (48).value := p_customstring14;
      END IF;
      IF p_customstring15 IS NOT NULL THEN
         v_list (49).key := 'CustomString15';
         v_list (49).value := p_customstring15;
      END IF;
      IF p_customstring16 IS NOT NULL THEN
         v_list (50).key := 'CustomString16';
         v_list (50).value := p_customstring16;
      END IF;
      IF p_customstring17 IS NOT NULL THEN
         v_list (51).key := 'CustomString17';
         v_list (51).value := p_customstring17;
      END IF;
      IF p_customstring18 IS NOT NULL THEN
         v_list (52).key := 'CustomString18';
         v_list (52).value := p_customstring18;
      END IF;
      IF p_customstring19 IS NOT NULL THEN
         v_list (53).key := 'CustomString19';
         v_list (53).value := p_customstring19;
      END IF;
      IF p_customstring20 IS NOT NULL THEN
         v_list (54).key := 'CustomString20';
         v_list (54).value := p_customstring20;
      END IF;
      IF p_customstring21 IS NOT NULL THEN
         v_list (55).key := 'CustomString21';
         v_list (55).value := p_customstring21;
      END IF;
      IF p_customstring22 IS NOT NULL THEN
         v_list (56).key := 'CustomString22';
         v_list (56).value := p_customstring22;
      END IF;
      IF p_customstring23 IS NOT NULL THEN
         v_list (57).key := 'CustomString23';
         v_list (57).value := p_customstring23;
      END IF;
      IF p_customstring24 IS NOT NULL THEN
         v_list (58).key := 'CustomString24';
         v_list (58).value := p_customstring24;
      END IF;
      IF p_customstring25 IS NOT NULL THEN
         v_list (59).key := 'CustomString25';
         v_list (59).value := p_customstring25;
      END IF;
      IF p_customstring26 IS NOT NULL THEN
         v_list (60).key := 'CustomString26';
         v_list (60).value := p_customstring26;
      END IF;
      IF p_customstring27 IS NOT NULL THEN
         v_list (61).key := 'CustomString27';
         v_list (61).value := p_customstring27;
      END IF;
      IF p_customstring28 IS NOT NULL THEN
         v_list (62).key := 'CustomString28';
         v_list (62).value := p_customstring28;
      END IF;
      IF p_customstring29 IS NOT NULL THEN
         v_list (63).key := 'CustomString29';
         v_list (63).value := p_customstring29;
      END IF;
      IF p_customstring30 IS NOT NULL THEN
         v_list (64).key := 'CustomString30';
         v_list (64).value := p_customstring30;
      END IF;
      IF p_customstring31 IS NOT NULL THEN
         v_list (65).key := 'CustomString31';
         v_list (65).value := p_customstring31;
      END IF;
      IF p_customstring32 IS NOT NULL THEN
         v_list (66).key := 'CustomString32';
         v_list (66).value := p_customstring32;
      END IF;
      IF p_customstring33 IS NOT NULL THEN
         v_list (67).key := 'CustomString33';
         v_list (67).value := p_customstring33;
      END IF;
      IF p_customstring34 IS NOT NULL THEN
         v_list (68).key := 'CustomString34';
         v_list (68).value := p_customstring34;
      END IF;
      IF p_customstring35 IS NOT NULL THEN
         v_list (69).key := 'CustomString35';
         v_list (69).value := p_customstring35;
      END IF;
      IF p_customstring36 IS NOT NULL THEN
         v_list (70).key := 'CustomString36';
         v_list (70).value := p_customstring36;
      END IF;
      IF p_customstring37 IS NOT NULL THEN
         v_list (71).key := 'CustomString37';
         v_list (71).value := p_customstring37;
      END IF;
      IF p_customstring38 IS NOT NULL THEN
         v_list (72).key := 'CustomString38';
         v_list (72).value := p_customstring38;
      END IF;
      IF p_customstring39 IS NOT NULL THEN
         v_list (73).key := 'CustomString39';
         v_list (73).value := p_customstring39;
      END IF;
      IF p_customstring40 IS NOT NULL THEN
         v_list (74).key := 'CustomString40';
         v_list (74).value := p_customstring40;
      END IF;
      IF p_customdate1 IS NOT NULL THEN
         v_list (75).key := 'CustomDate1';
         v_list (75).value := p_customdate1;
      END IF;
      IF p_customdate2 IS NOT NULL THEN
         v_list (76).key := 'CustomDate2';
         v_list (76).value := p_customdate2;
      END IF;
      IF p_customdate3 IS NOT NULL THEN
         v_list (77).key := 'CustomDate3';
         v_list (77).value := p_customdate3;
      END IF;
      IF p_customdate4 IS NOT NULL THEN
         v_list (78).key := 'CustomDate4';
         v_list (78).value := p_customdate4;
      END IF;
      IF p_customdate5 IS NOT NULL THEN
         v_list (79).key := 'CustomDate5';
         v_list (79).value := p_customdate5;
      END IF;
      IF p_customnumber1 IS NOT NULL THEN
         v_list (80).key := 'CustomNumber1';
         v_list (80).value := p_customnumber1;
      END IF;
      IF p_customnumber2 IS NOT NULL THEN
         v_list (81).key := 'CustomNumber2';
         v_list (81).value := p_customnumber2;
      END IF;
      IF p_customnumber3 IS NOT NULL THEN
         v_list (82).key := 'CustomNumber3';
         v_list (82).value := p_customnumber3;
      END IF;
      IF p_customnumber4 IS NOT NULL THEN
         v_list (83).key := 'CustomNumber4';
         v_list (83).value := p_customnumber4;
      END IF;
      IF p_customnumber5 IS NOT NULL THEN
         v_list (84).key := 'CustomNumber5';
         v_list (84).value := p_customnumber5;
      END IF;

      xwrl_utils.ows_web_service (p_debug => v_debug, p_show_request => v_show_request, p_show_response => v_show_response, p_server => v_server,p_source_table => p_source_table, p_source_id => p_source_id, p_wc_screening_request_id => p_wc_screening_request_id, p_job_id => p_job_id, p_service_name => 'INDIVIDUAL', p_list => v_list, p_id => NULL);

   END ows_individual_screening;

   PROCEDURE ows_entity_screening (
      p_debug                     VARCHAR2 DEFAULT 'FALSE'
      , p_show_request              VARCHAR2 DEFAULT 'FALSE'
      , p_show_response             VARCHAR2 DEFAULT 'FALSE'
      , p_server                    VARCHAR2 DEFAULT NULL
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL      
      , p_job_id                VARCHAR2 DEFAULT NULL
      , p_listsubkey                VARCHAR2 DEFAULT NULL
      , p_listrecordtype            VARCHAR2 DEFAULT NULL
      , p_listrecordorigin          VARCHAR2 DEFAULT NULL
      , p_custid                    VARCHAR2 DEFAULT NULL
      , p_custsubid                 VARCHAR2 DEFAULT NULL
      , p_registrationnumber        VARCHAR2 DEFAULT NULL
      , p_entityname                VARCHAR2 DEFAULT NULL
      , p_nametype                  VARCHAR2 DEFAULT NULL
      , p_namequality               VARCHAR2 DEFAULT NULL
      , p_primaryname               VARCHAR2 DEFAULT NULL
      , p_originalscriptname        VARCHAR2 DEFAULT NULL
      , p_aliasisacronym            VARCHAR2 DEFAULT NULL
      , p_address1                  VARCHAR2 DEFAULT NULL
      , p_address2                  VARCHAR2 DEFAULT NULL
      , p_address3                  VARCHAR2 DEFAULT NULL
      , p_address4                  VARCHAR2 DEFAULT NULL
      , p_city                      VARCHAR2 DEFAULT NULL
      , p_state                     VARCHAR2 DEFAULT NULL
      , p_postalcode                VARCHAR2 DEFAULT NULL
      , p_addresscountrycode        VARCHAR2 DEFAULT NULL
      , p_registrationcountrycode   VARCHAR2 DEFAULT NULL
      , p_operatingcountrycodes     VARCHAR2 DEFAULT NULL
      , p_profilehyperlink          VARCHAR2 DEFAULT NULL
      , p_riskscore                 VARCHAR2 DEFAULT NULL
      , p_dataconfidencescore       VARCHAR2 DEFAULT NULL
      , p_dataconfidencecomment     VARCHAR2 DEFAULT NULL
      , p_customstring1             VARCHAR2 DEFAULT NULL
      , p_customstring2             VARCHAR2 DEFAULT NULL
      , p_customstring3             VARCHAR2 DEFAULT NULL
      , p_customstring4             VARCHAR2 DEFAULT NULL
      , p_customstring5             VARCHAR2 DEFAULT NULL
      , p_customstring6             VARCHAR2 DEFAULT NULL
      , p_customstring7             VARCHAR2 DEFAULT NULL
      , p_customstring8             VARCHAR2 DEFAULT NULL
      , p_customstring9             VARCHAR2 DEFAULT NULL
      , p_customstring10            VARCHAR2 DEFAULT NULL
      , p_customstring11            VARCHAR2 DEFAULT NULL
      , p_customstring12            VARCHAR2 DEFAULT NULL
      , p_customstring13            VARCHAR2 DEFAULT NULL
      , p_customstring14            VARCHAR2 DEFAULT NULL
      , p_customstring15            VARCHAR2 DEFAULT NULL
      , p_customstring16            VARCHAR2 DEFAULT NULL
      , p_customstring17            VARCHAR2 DEFAULT NULL
      , p_customstring18            VARCHAR2 DEFAULT NULL
      , p_customstring19            VARCHAR2 DEFAULT NULL
      , p_customstring20            VARCHAR2 DEFAULT NULL
      , p_customstring21            VARCHAR2 DEFAULT NULL
      , p_customstring22            VARCHAR2 DEFAULT NULL
      , p_customstring23            VARCHAR2 DEFAULT NULL
      , p_customstring24            VARCHAR2 DEFAULT NULL
      , p_customstring25            VARCHAR2 DEFAULT NULL
      , p_customstring26            VARCHAR2 DEFAULT NULL
      , p_customstring27            VARCHAR2 DEFAULT NULL
      , p_customstring28            VARCHAR2 DEFAULT NULL
      , p_customstring29            VARCHAR2 DEFAULT NULL
      , p_customstring30            VARCHAR2 DEFAULT NULL
      , p_customstring31            VARCHAR2 DEFAULT NULL
      , p_customstring32            VARCHAR2 DEFAULT NULL
      , p_customstring33            VARCHAR2 DEFAULT NULL
      , p_customstring34            VARCHAR2 DEFAULT NULL
      , p_customstring35            VARCHAR2 DEFAULT NULL
      , p_customstring36            VARCHAR2 DEFAULT NULL
      , p_customstring37            VARCHAR2 DEFAULT NULL
      , p_customstring38            VARCHAR2 DEFAULT NULL
      , p_customstring39            VARCHAR2 DEFAULT NULL
      , p_customstring40            VARCHAR2 DEFAULT NULL
      , p_customdate1               VARCHAR2 DEFAULT NULL
      , p_customdate2               VARCHAR2 DEFAULT NULL
      , p_customdate3               VARCHAR2 DEFAULT NULL
      , p_customdate4               VARCHAR2 DEFAULT NULL
      , p_customdate5               VARCHAR2 DEFAULT NULL
      , p_customnumber1             VARCHAR2 DEFAULT NULL
      , p_customnumber2             VARCHAR2 DEFAULT NULL
      , p_customnumber3             VARCHAR2 DEFAULT NULL
      , p_customnumber4             VARCHAR2 DEFAULT NULL
      , p_customnumber5             VARCHAR2 DEFAULT NULL
   ) IS

      v_debug                     boolean := false;
      v_show_request              boolean := false;
      v_show_response             boolean := false;
      v_instance varchar2(50);
      v_server varchar2(50);
      v_list p_tab;

   BEGIN
   
      IF P_debug = 'TRUE' THEN
          v_debug := true;
      END IF;

      IF P_show_request = 'TRUE' THEN
          v_show_request := true;
      END IF;
      
      IF p_show_response = 'TRUE' THEN
          v_show_response := true;
      END IF;

      IF p_server IS NOT NULL THEN
          v_server := p_server;
      ELSE
         v_instance := get_instance;
          v_server := get_wl_server ('LOADBALANCE_SERVER',v_instance);
      END IF;     

      IF p_listsubkey IS NOT NULL THEN
         v_list (1).key := 'ListSubKey';
         v_list (1).value := p_listsubkey;
      END IF;
      IF p_listrecordtype IS NOT NULL THEN
         v_list (2).key := 'ListRecordType';
         v_list (2).value := p_listrecordtype;
      END IF;
      IF p_listrecordorigin IS NOT NULL THEN
         v_list (3).key := 'ListRecordOrigin';
         v_list (3).value := p_listrecordorigin;
      END IF;
      IF p_custid IS NOT NULL THEN
         v_list (4).key := 'CustId';
         v_list (4).value := p_custid;
      END IF;
      IF p_custsubid IS NOT NULL THEN
         v_list (5).key := 'CustSubId';
         v_list (5).value := p_custsubid;
      END IF;
      IF p_registrationnumber IS NOT NULL THEN
         v_list (6).key := 'RegistrationNumber';
         v_list (6).value := p_registrationnumber;
      END IF;
      IF p_entityname IS NOT NULL THEN
         v_list (7).key := 'EntityName';
         v_list (7).value := p_entityname;
      END IF;
      IF p_nametype IS NOT NULL THEN
         v_list (8).key := 'NameType';
         v_list (8).value := p_nametype;
      END IF;
      IF p_namequality IS NOT NULL THEN
         v_list (9).key := 'NameQuality';
         v_list (9).value := p_namequality;
      END IF;
      IF p_primaryname IS NOT NULL THEN
         v_list (10).key := 'PrimaryName';
         v_list (10).value := p_primaryname;
      END IF;
      IF p_originalscriptname IS NOT NULL THEN
         v_list (11).key := 'OriginalScriptName';
         v_list (11).value := p_originalscriptname;
      END IF;
      IF p_aliasisacronym IS NOT NULL THEN
         v_list (12).key := 'AliasIsAcronym';
         v_list (12).value := p_aliasisacronym;
      END IF;
      IF p_address1 IS NOT NULL THEN
         v_list (13).key := 'Address1';
         v_list (13).value := p_address1;
      END IF;
      IF p_address2 IS NOT NULL THEN
         v_list (14).key := 'Address2';
         v_list (14).value := p_address2;
      END IF;
      IF p_address3 IS NOT NULL THEN
         v_list (15).key := 'Address3';
         v_list (15).value := p_address3;
      END IF;
      IF p_address4 IS NOT NULL THEN
         v_list (16).key := 'Address4';
         v_list (16).value := p_address4;
      END IF;
      IF p_city IS NOT NULL THEN
         v_list (17).key := 'City';
         v_list (17).value := p_city;
      END IF;
      IF p_state IS NOT NULL THEN
         v_list (18).key := 'State';
         v_list (18).value := p_state;
      END IF;
      IF p_postalcode IS NOT NULL THEN
         v_list (19).key := 'PostalCode';
         v_list (19).value := p_postalcode;
      END IF;
      IF p_addresscountrycode IS NOT NULL THEN
         v_list (20).key := 'AddressCountryCode';
         v_list (20).value := p_addresscountrycode;
      END IF;
      IF p_registrationcountrycode IS NOT NULL THEN
         v_list (21).key := 'RegistrationCountryCode';
         v_list (21).value := p_registrationcountrycode;
      END IF;
      IF p_operatingcountrycodes IS NOT NULL THEN
         v_list (22).key := 'OperatingCountryCodes';
         v_list (22).value := p_operatingcountrycodes;
      END IF;
      IF p_profilehyperlink IS NOT NULL THEN
         v_list (23).key := 'ProfileHyperlink';
         v_list (23).value := p_profilehyperlink;
      END IF;
      IF p_riskscore IS NOT NULL THEN
         v_list (24).key := 'RiskScore';
         v_list (24).value := p_riskscore;
      END IF;
      IF p_dataconfidencescore IS NOT NULL THEN
         v_list (25).key := 'DataConfidenceScore';
         v_list (25).value := p_dataconfidencescore;
      END IF;
      IF p_dataconfidencecomment IS NOT NULL THEN
         v_list (26).key := 'DataConfidenceComment';
         v_list (26).value := p_dataconfidencecomment;
      END IF;
      IF p_customstring1 IS NOT NULL THEN
         v_list (27).key := 'CustomString1';
         v_list (27).value := p_customstring1;
      END IF;
      IF p_customstring2 IS NOT NULL THEN
         v_list (28).key := 'CustomString2';
         v_list (28).value := p_customstring2;
      END IF;
      IF p_customstring3 IS NOT NULL THEN
         v_list (29).key := 'CustomString3';
         v_list (29).value := p_customstring3;
      END IF;
      IF p_customstring4 IS NOT NULL THEN
         v_list (30).key := 'CustomString4';
         v_list (30).value := p_customstring4;
      END IF;
      IF p_customstring5 IS NOT NULL THEN
         v_list (31).key := 'CustomString5';
         v_list (31).value := p_customstring5;
      END IF;
      IF p_customstring6 IS NOT NULL THEN
         v_list (32).key := 'CustomString6';
         v_list (32).value := p_customstring6;
      END IF;
      IF p_customstring7 IS NOT NULL THEN
         v_list (33).key := 'CustomString7';
         v_list (33).value := p_customstring7;
      END IF;
      IF p_customstring8 IS NOT NULL THEN
         v_list (34).key := 'CustomString8';
         v_list (34).value := p_customstring8;
      END IF;
      IF p_customstring9 IS NOT NULL THEN
         v_list (35).key := 'CustomString9';
         v_list (35).value := p_customstring9;
      END IF;
      IF p_customstring10 IS NOT NULL THEN
         v_list (36).key := 'CustomString10';
         v_list (36).value := p_customstring10;
      END IF;
      IF p_customstring11 IS NOT NULL THEN
         v_list (37).key := 'CustomString11';
         v_list (37).value := p_customstring11;
      END IF;
      IF p_customstring12 IS NOT NULL THEN
         v_list (38).key := 'CustomString12';
         v_list (38).value := p_customstring12;
      END IF;
      IF p_customstring13 IS NOT NULL THEN
         v_list (39).key := 'CustomString13';
         v_list (39).value := p_customstring13;
      END IF;
      IF p_customstring14 IS NOT NULL THEN
         v_list (40).key := 'CustomString14';
         v_list (40).value := p_customstring14;
      END IF;
      IF p_customstring15 IS NOT NULL THEN
         v_list (41).key := 'CustomString15';
         v_list (41).value := p_customstring15;
      END IF;
      IF p_customstring16 IS NOT NULL THEN
         v_list (42).key := 'CustomString16';
         v_list (42).value := p_customstring16;
      END IF;
      IF p_customstring17 IS NOT NULL THEN
         v_list (43).key := 'CustomString17';
         v_list (43).value := p_customstring17;
      END IF;
      IF p_customstring18 IS NOT NULL THEN
         v_list (44).key := 'CustomString18';
         v_list (44).value := p_customstring18;
      END IF;
      IF p_customstring19 IS NOT NULL THEN
         v_list (45).key := 'CustomString19';
         v_list (45).value := p_customstring19;
      END IF;
      IF p_customstring20 IS NOT NULL THEN
         v_list (46).key := 'CustomString20';
         v_list (46).value := p_customstring20;
      END IF;
      IF p_customstring21 IS NOT NULL THEN
         v_list (47).key := 'CustomString21';
         v_list (47).value := p_customstring21;
      END IF;
      IF p_customstring22 IS NOT NULL THEN
         v_list (48).key := 'CustomString22';
         v_list (48).value := p_customstring22;
      END IF;
      IF p_customstring23 IS NOT NULL THEN
         v_list (49).key := 'CustomString23';
         v_list (49).value := p_customstring23;
      END IF;
      IF p_customstring24 IS NOT NULL THEN
         v_list (50).key := 'CustomString24';
         v_list (50).value := p_customstring24;
      END IF;
      IF p_customstring25 IS NOT NULL THEN
         v_list (51).key := 'CustomString25';
         v_list (51).value := p_customstring25;
      END IF;
      IF p_customstring26 IS NOT NULL THEN
         v_list (52).key := 'CustomString26';
         v_list (52).value := p_customstring26;
      END IF;
      IF p_customstring27 IS NOT NULL THEN
         v_list (53).key := 'CustomString27';
         v_list (53).value := p_customstring27;
      END IF;
      IF p_customstring28 IS NOT NULL THEN
         v_list (54).key := 'CustomString28';
         v_list (54).value := p_customstring28;
      END IF;
      IF p_customstring29 IS NOT NULL THEN
         v_list (55).key := 'CustomString29';
         v_list (55).value := p_customstring29;
      END IF;
      IF p_customstring30 IS NOT NULL THEN
         v_list (56).key := 'CustomString30';
         v_list (56).value := p_customstring30;
      END IF;
      IF p_customstring31 IS NOT NULL THEN
         v_list (57).key := 'CustomString31';
         v_list (57).value := p_customstring31;
      END IF;
      IF p_customstring32 IS NOT NULL THEN
         v_list (58).key := 'CustomString32';
         v_list (58).value := p_customstring32;
      END IF;
      IF p_customstring33 IS NOT NULL THEN
         v_list (59).key := 'CustomString33';
         v_list (59).value := p_customstring33;
      END IF;
      IF p_customstring34 IS NOT NULL THEN
         v_list (60).key := 'CustomString34';
         v_list (60).value := p_customstring34;
      END IF;
      IF p_customstring35 IS NOT NULL THEN
         v_list (61).key := 'CustomString35';
         v_list (61).value := p_customstring35;
      END IF;
      IF p_customstring36 IS NOT NULL THEN
         v_list (62).key := 'CustomString36';
         v_list (62).value := p_customstring36;
      END IF;
      IF p_customstring37 IS NOT NULL THEN
         v_list (63).key := 'CustomString37';
         v_list (63).value := p_customstring37;
      END IF;
      IF p_customstring38 IS NOT NULL THEN
         v_list (64).key := 'CustomString38';
         v_list (64).value := p_customstring38;
      END IF;
      IF p_customstring39 IS NOT NULL THEN
         v_list (65).key := 'CustomString39';
         v_list (65).value := p_customstring39;
      END IF;
      IF p_customstring40 IS NOT NULL THEN
         v_list (66).key := 'CustomString40';
         v_list (66).value := p_customstring40;
      END IF;
      IF p_customdate1 IS NOT NULL THEN
         v_list (67).key := 'CustomDate1';
         v_list (67).value := p_customdate1;
      END IF;
      IF p_customdate2 IS NOT NULL THEN
         v_list (68).key := 'CustomDate2';
         v_list (68).value := p_customdate2;
      END IF;
      IF p_customdate3 IS NOT NULL THEN
         v_list (69).key := 'CustomDate3';
         v_list (69).value := p_customdate3;
      END IF;
      IF p_customdate4 IS NOT NULL THEN
         v_list (70).key := 'CustomDate4';
         v_list (70).value := p_customdate4;
      END IF;
      IF p_customdate5 IS NOT NULL THEN
         v_list (71).key := 'CustomDate5';
         v_list (71).value := p_customdate5;
      END IF;
      IF p_customnumber1 IS NOT NULL THEN
         v_list (72).key := 'CustomNumber1';
         v_list (72).value := p_customnumber1;
      END IF;
      IF p_customnumber2 IS NOT NULL THEN
         v_list (73).key := 'CustomNumber2';
         v_list (73).value := p_customnumber2;
      END IF;
      IF p_customnumber3 IS NOT NULL THEN
         v_list (74).key := 'CustomNumber3';
         v_list (74).value := p_customnumber3;
      END IF;
      IF p_customnumber4 IS NOT NULL THEN
         v_list (75).key := 'CustomNumber4';
         v_list (75).value := p_customnumber4;
      END IF;
      IF p_customnumber5 IS NOT NULL THEN
         v_list (76).key := 'CustomNumber5';
         v_list (76).value := p_customnumber5;
      END IF;

      xwrl_utils.ows_web_service (p_debug => v_debug, p_show_request => v_show_request, p_show_response => v_show_response, p_server => v_server,p_source_table => p_source_table, p_source_id => p_source_id, p_wc_screening_request_id => p_wc_screening_request_id, p_job_id => p_job_id, p_service_name => 'ENTITY', p_list => v_list, p_id => NULL);

   END ows_entity_screening;

      PROCEDURE ows_resubmit_screening (
      p_debug                     VARCHAR2 DEFAULT 'FALSE'
      , p_show_request              VARCHAR2 DEFAULT 'FALSE'
      , p_show_response             VARCHAR2 DEFAULT 'FALSE'
      , p_server          VARCHAR2
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL      
      , p_job_id                VARCHAR2 DEFAULT NULL
      , p_id              INTEGER
   ) IS
   
         v_debug                     boolean := false;
      v_show_request              boolean := false;
      v_show_response             boolean := false;
      v_instance varchar2(50);
      v_server varchar2(50);
      v_list p_tab;
   
   BEGIN
   
      IF P_debug = 'TRUE' THEN
          v_debug := true;
      END IF;

      IF P_show_request = 'TRUE' THEN
          v_show_request := true;
      END IF;
      
      IF p_show_response = 'TRUE' THEN
          v_show_response := true;
      END IF;
      
      IF p_server IS NOT NULL THEN
          v_server := p_server;
      ELSE
         v_instance := get_instance;
          v_server := get_wl_server ('LOADBALANCE_SERVER',v_instance);
      END IF;      
      
      xwrl_utils.ows_web_service (p_debug => v_debug, p_show_request => v_show_request, p_show_response => v_show_response, p_server => v_server,p_source_table => p_source_table, p_source_id => p_source_id, p_wc_screening_request_id => p_wc_screening_request_id, p_job_id => p_job_id, p_service_name => NULL, p_list => v_list, p_id => p_id);     
   
   END ows_resubmit_screening;

END xwrl_utils;
/
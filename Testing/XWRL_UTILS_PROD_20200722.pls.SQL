create or replace PACKAGE BODY        "XWRL_UTILS" AS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_xwrl_utils.pkb 1.1 2019/11/15 12:00:00ET   IRI Exp                                         $*/
/********************************************************************************************************************
* Object Type         : Package Body                                                                                *
* Name                : xwrl_utils                                                                                  *
* Script Name         : apps_create_xwrl_utils.pkb                                                                  *
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
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I      Add    create_audit_record          *
* 16-NOV-2019 IRI              1.3                TSUAZO          16-NOV-2019  I      Remove    create_audit_record          *
* 17-NOV-2019 IRI              1.4                TSUAZO          17-NOV-2019  I     Update cleanse_name          *
* 17-NOV-2019 IRI              1.5                TSUAZO          17-NOV-2019  I     Add RMI_OWS_COMMON_UTIL functions          *                                                                                                               
* 12-DEC-2019 IRI              1.6                TSUAZO          12-DEC-2019  I     Add Master ID, Alias ID and XREF ID     *  
* 19-DEC-2019 IRI              1.7                VTONDAPU        19-DEC-2019  I     Added Gender, Passport info in SAVE_REQUEST_IND_COLUMNS AND OWS_WEB_SERVICE PROCEDURES    * 
* 02-FEB-2020 IRI              1.8                TSUAZO        02-FEB-2020  I     Modify RESUBMIT to copy previous record into temporary record    * 
* 19-FEB-2020 IRI              1.9                TSUAZO        19-FEB-2020  I     Fix v_path for RESUBMIT     * 
* 21-FEB-2020 IRI              1.10                TSUAZO        21-FEB-2020  I     deptment and deptment_ext     * 
* 27-FEB-2020 IRI              1.11                TSUAZO        27-FEB-2020  I     deptment and deptment_ext     * 
* 04-APR-2020 IRI              1.12                TSUAZO        04-APR-2020 IRI    I     FIX OFFICE CODE IN SQL STATEMENT     * 
* 21-APR-2020 IRI              1.13                TSUAZO        21-APR-2020 IRI    I     utl_http.set_transfer_timeout(600) to utl_http.set_transfer_timeout(1800)     * 
* 07-MAY-2020 IRI              1.14                TSUAZO        07-MAY-2020 IRI    I     Use Compressed XML    * 
* 08-MAY-2020 IRI              1.15                TSUAZO        08-MAY-2020 IRI    I     Add use_xml_compressed function    * 
* 22-MAY-2020 IRI              1.16                TSUAZO        22-MAY-2020 IRI    I     Add gender exclusion for U, Unspecified, Unknown    * 
* 27-JUNE-2020 IRI              1.17                TSUAZO        27-JUNE-2020 IRI    I     Update resubmit logic with use_xml_compressed function    * 

********************************************************************************************************************/


   FUNCTION cleanse_name (
   p_name varchar2
   ) return varchar2 as 

   v_name varchar2(1000);

   begin

   --v_name := p_name;
   --v_name := replace (v_name, '&', chr (38) || 'amp;'); -- replace ampersand for XML processing
   --v_name := replace (v_name, '"');  -- replace double quotes for XML processing
   -- tsuazo 11/17/2019  strip special characters
   v_name := REGEXP_REPLACE(UPPER(p_name), '[^0-9A-Za-z ]',' ');

   return v_name;

   end cleanse_name;

   FUNCTION use_xml_compressed RETURN boolean as

         v_id      VARCHAR2 (100) := 'XML';
      v_key     VARCHAR2 (100) := 'COMPRESSED_XML';  
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
         id = v_id
         AND key = v_key;

         v_return boolean := false;

    BEGIN

      FOR c1rec IN c1 (v_id, v_key) LOOP v_value := c1rec.value_string;
      END LOOP;

      if v_value = 'TRUE' then
         v_return := true;
     end if;

      RETURN v_return;

   END use_xml_compressed;  


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

   FUNCTION ows_date_format (
   p_date VARCHAR2
   ) RETURN VARCHAR2 AS

   v_year varchar2(30);
   v_month varchar2(30);
   v_day varchar2(30);
   v_date varchar2(30);

   begin

   /*Note: OWS date format is YYYY-MM-DDT00:00:00Z */

   SELECT   EXTRACT( YEAR FROM to_date(p_date,'YYYYMMDD') ) into v_year FROM  DUAL;

   SELECT   LPAD(EXTRACT( MONTH FROM to_date(p_date,'YYYYMMDD') ),2,0) into v_month FROM  DUAL;

   SELECT   LPAD(EXTRACT( DAY FROM to_date(p_date,'YYYYMMDD') ),2,0) into v_day FROM  DUAL;

   v_date := v_year||'-'||v_month||'-'||v_day||'T00:00:00Z';

   return v_date;

   END ows_date_format;

      FUNCTION get_wl_server (
      p_id VARCHAR2
      ,p_key varchar2
   ) RETURN VARCHAR2 AS

   pragma autonomous_transaction;

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

      v_id      VARCHAR2 (100) := 'MAX_JOBS';
      v_key     VARCHAR2 (100);
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

     v_key := get_wl_server ('LOADBALANCE_SERVER',get_instance);

      FOR c1rec IN c1 (v_id, v_key) LOOP v_value := c1rec.value_string;
      END LOOP;

      RETURN v_value;

   END get_max_jobs;

      FUNCTION get_max_pause RETURN INTEGER AS

      v_id      VARCHAR2 (100) := 'MAX_PAUSE';
      v_key     VARCHAR2 (100);
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

     v_key := get_wl_server ('LOADBALANCE_SERVER',get_instance);

      FOR c1rec IN c1 (v_id, v_key) LOOP v_value := c1rec.value_string;
      END LOOP;

      RETURN v_value;

   END get_max_pause;

         FUNCTION get_ebs_pause RETURN INTEGER AS

      v_id      VARCHAR2 (100) := 'EBS_PAUSE';
      v_key     VARCHAR2 (100);
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

     v_key := get_wl_server ('LOADBALANCE_SERVER',get_instance);

      FOR c1rec IN c1 (v_id, v_key) LOOP v_value := c1rec.value_string;
      END LOOP;

      RETURN v_value;

   END get_ebs_pause;

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

      FUNCTION get_compressed_xml (
      p_id INTEGER
   ) RETURN XMLTYPE AS

      v_xml XMLTYPE;

      CURSOR c1 IS
      SELECT
         compressed_request
      FROM
         xwrl_requests
      WHERE
         id = p_id;

   BEGIN

      FOR c1rec IN c1 LOOP v_xml := c1rec.compressed_request;
      END LOOP;

      RETURN v_xml;
   END get_compressed_xml;

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
      utl_http.set_transfer_timeout(1800);
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

			/* Note: Caused error 
			ORA-06502: PL/SQL: numeric or value error: invalid LOB locator specified: ORA-22275
			ORA-06512: at "SYS.DBMS_LOB", line 818
			IF p_debug THEN
				dbms_output.put_line('/--- Free LOB  ---/');
			END IF;
			dbms_lob.freetemporary(v_content);
			*/

			-- Save Record w/ error
      IF (v_request_rec.status != 'INVALID' and v_request_rec.status != 'FAILED') THEN
         v_request_rec.status := 'ERROR';
         if utl_http.get_detailed_sqlcode is not null then
            v_request_rec.error_code := 'ORA-' || utl_http.get_detailed_sqlcode;      
        else             
            v_request_rec.error_code := 'ORA-'||sqlcode;
       end if;
        if utl_http.get_detailed_sqlerrm is not null then
            v_request_rec.error_message := utl_http.get_detailed_sqlerrm;
       else 
            v_request_rec.error_message := sqlerrm;
       end if;            

      utl_http.end_response (v_resp);

         IF v_request_rec.error_code = 'ORA-12541' THEN
            v_request_rec.error_code :=  'ORA-12541' ;
            v_request_rec.error_message := v_request_rec.error_message || ' *** Server Needs to be Whitelisted ***';
         ELSIF v_request_rec.error_code = 'ORA-29259' THEN
            v_request_rec.error_code :=  'ORA-29259' ;
            v_request_rec.error_message := v_request_rec.error_message || ' *** Check if EDQ server is down ***';            
         ELSIF v_request_rec.error_code = 'ORA-19112' THEN
           v_request_rec.error_code :=  'ORA-19112' ;
            v_request_rec.error_message := v_request_rec.error_message || ' *** Syntax error in the XML request ***';            
         ELSIF v_request_rec.error_code = 'ORA-31011' THEN
            v_request_rec.error_code :=  'ORA-31011' ;
            v_request_rec.error_message := v_request_rec.error_message || ' *** XML parsing failed ***';               
         END IF;
      END IF;

      v_request_rec.case_state := 'E';
      v_request_rec.creation_date := SYSDATE;
      v_request_rec.last_update_date := SYSDATE;

      IF p_debug THEN
         dbms_output.put_line ('/--- Insert Record ---/');
      END IF;

      insert into xwrl_requests VALUES v_request_rec;
      COMMIT;  -- tsuazo 11/4/2019 confirming this commit is at the end of the loop or procedure

      IF p_debug THEN
         dbms_output.put_line ('/--- Finish Error Process  ---/');
      END IF;

   END err_ows_web_service;

   PROCEDURE save_request_ind_columns (
      p_id INTEGER
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL      
      ,x_name_screened OUT varchar2
      ,x_dob out varchar2
      ,x_AddressCountryCode out varchar2
      ,x_ResidencyCountryCode out varchar2
      ,x_CountryOfBirthCode out varchar2
      ,x_NationalityCountryCodes out varchar2
      ,x_gender out varchar2    -- VTONDAPU 12/19/2019
      ,x_passport out varchar2   -- VTONDAPU 12/19/2019
   ) IS

      CURSOR c1 IS
      SELECT
         t.id
        ,x.ListSubKey
,x.ListRecordType
,x.ListRecordOrigin
,x.CustId
,x.CustSubId
,x.PassportNumber
,x.NationalId
,x.Title
,x.FullName
,x.GivenNames
,x.FamilyName
,x.NameType
,x.NameQuality
,x.PrimaryName
,x.OriginalScriptName
,x.Gender
,x.DateOfBirth
,x.YearOfBirth
,x.Occupation
,x.Address1
,x.Address2
,x.Address3
,x.Address4
,x.City
,x.State
,x.PostalCode
,x.AddressCountryCode
,x.ResidencyCountryCode
,x.CountryOfBirthCode
,x.NationalityCountryCodes
,x.ProfileHyperlink
,x.RiskScore
,x.DataConfidenceScore
,x.DataConfidenceComment
,x.CustomString1
,x.CustomString2
,x.CustomString3
,x.CustomString4
,x.CustomString5
,x.CustomString6
,x.CustomString7
,x.CustomString8
,x.CustomString9
,x.CustomString10
,x.CustomString11
,x.CustomString12
,x.CustomString13
,x.CustomString14
,x.CustomString15
,x.CustomString16
,x.CustomString17
,x.CustomString18
,x.CustomString19
,x.CustomString20
,x.CustomString21
,x.CustomString22
,x.CustomString23
,x.CustomString24
,x.CustomString25
,x.CustomString26
,x.CustomString27
,x.CustomString28
,x.CustomString29
,x.CustomString30
,x.CustomString31
,x.CustomString32
,x.CustomString33
,x.CustomString34
,x.CustomString35
,x.CustomString36
,x.CustomString37
,x.CustomString38
,x.CustomString39
,x.CustomString40
,x.CustomDate1
,x.CustomDate2
,x.CustomDate3
,x.CustomDate4
,x.CustomDate5
,x.CustomNumber1
,x.CustomNumber2
,x.CustomNumber3
,x.CustomNumber4
,x.CustomNumber5
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

         v_rec.created_by := p_user_id;
         v_rec.creation_date := SYSDATE;
         v_rec.last_updated_by := p_user_id;
         v_rec.last_update_date := SYSDATE;
         v_rec.last_update_login := p_session_id;

         insert into xwrl_request_ind_columns
         VALUES v_rec;

      END LOOP;

      if v_rec.fullname is not null then
            x_name_screened := v_rec.fullname;
      else
            x_name_screened := ltrim(v_rec.givennames||' '|| v_rec.familyname);
      end if;

      x_dob := v_rec.dateofbirth;

      x_AddressCountryCode := v_rec.AddressCountryCode;
      x_ResidencyCountryCode := v_rec.ResidencyCountryCode;
      x_CountryOfBirthCode := v_rec.CountryOfBirthCode;
      x_NationalityCountryCodes := v_rec.NationalityCountryCodes;
      x_gender := v_rec.gender;   -- VTONDAPU 12/19/2019
      x_passport := v_rec.passportnumber;   -- VTONDAPU 12/19/2019

      COMMIT;  -- tsuazo 11/4/2019 confirming this commit is at the end of the loop

   END save_request_ind_columns;

  PROCEDURE save_response_ind_columns (
      p_id INTEGER
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL
   ) IS

      CURSOR c1 IS
      SELECT
         t.id,
         x.rec,
x.ListKey,
x.ListSubKey,
x.ListRecordType,
x.ListRecordOrigin,
x.ListId,
x.ListGivenNames,
x.ListFamilyName,
x.ListFullName,
x.ListNameType,
x.ListPrimaryName,
x.ListOriginalScriptName,
x.ListDOB,
x.ListCity,
x.ListCountry,
x.ListCountryOfBirth,
x.ListNationality,
x.MatchRule,
x.MatchScore,
x.CaseKey,
x.AlertId,
x.RiskScore,
x.RiskScorePEP,
x.Category,
x.dnPassportNumber,
x.dnNationalId,
x.dnTitle,
x.dnYOB,
x.dnGender,
x.DeceasedFlag,
x.DeceasedDate,
x.dnOccupation,
x.dnAddress,
x.dnCity,
x.dnState,
x.dnPostalCode,
x.dnAddressCountryCode,
x.dnResidencyCountryCode,
x.dnCountryOfBirthCode,
x.dnNationalityCountryCodes,
x.ExternalSources,
x.CachedExtSources,
x.dnAddedDate,
x.dnLastUpdatedDate
      FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "dn"), '//dn:response/dn:record' PASSING t.response COLUMNS rec FOR ORDINALITY, 
		 ListKey varchar2(2700) path 'dn:ListKey',
ListSubKey varchar2(2700) path 'dn:ListSubKey',
ListRecordType varchar2(2700) path 'dn:ListRecordType',
ListRecordOrigin varchar2(2700) path 'dn:ListRecordOrigin',
ListId varchar2(2700) path 'dn:ListId',
ListGivenNames varchar2(2700) path 'dn:ListGivenNames',
ListFamilyName varchar2(2700) path 'dn:ListFamilyName',
ListFullName varchar2(2700) path 'dn:ListFullName',
ListNameType varchar2(2700) path 'dn:ListNameType',
ListPrimaryName varchar2(2700) path 'dn:ListPrimaryName',
ListOriginalScriptName varchar2(2700) path 'dn:ListOriginalScriptName',
ListDOB varchar2(2700) path 'dn:ListDOB',
ListCity varchar2(2700) path 'dn:ListCity',
ListCountry varchar2(2700) path 'dn:ListCountry',
ListCountryOfBirth varchar2(2700) path 'dn:ListCountryOfBirth',
ListNationality varchar2(2700) path 'dn:ListNationality',
MatchRule varchar2(2700) path 'dn:MatchRule',
MatchScore varchar2(2700) path 'dn:MatchScore',
CaseKey varchar2(2700) path 'dn:CaseKey',
AlertId varchar2(2700) path 'dn:AlertId',
RiskScore varchar2(2700) path 'dn:RiskScore',
RiskScorePEP varchar2(2700) path 'dn:RiskScorePEP',
Category varchar2(2700) path 'dn:Category',
dnPassportNumber varchar2(2700) path 'dn:dnPassportNumber',
dnNationalId varchar2(2700) path 'dn:dnNationalId',
dnTitle varchar2(2700) path 'dn:dnTitle',
dnYOB varchar2(2700) path 'dn:dnYOB',
dnGender varchar2(2700) path 'dn:dnGender',
DeceasedFlag varchar2(2700) path 'dn:DeceasedFlag',
DeceasedDate varchar2(2700) path 'dn:DeceasedDate',
dnOccupation varchar2(2700) path 'dn:dnOccupation',
dnAddress varchar2(2700) path 'dn:dnAddress',
dnCity varchar2(2700) path 'dn:dnCity',
dnState varchar2(2700) path 'dn:dnState',
dnPostalCode varchar2(2700) path 'dn:dnPostalCode',
dnAddressCountryCode varchar2(2700) path 'dn:dnAddressCountryCode',
dnResidencyCountryCode varchar2(2700) path 'dn:dnResidencyCountryCode',
dnCountryOfBirthCode varchar2(2700) path 'dn:dnCountryOfBirthCode',
dnNationalityCountryCodes varchar2(2700) path 'dn:dnNationalityCountryCodes',
ExternalSources varchar2(2700) path 'dn:ExternalSources',
CachedExtSources varchar2(2700) path 'dn:CachedExtSources',
dnAddedDate varchar2(2700) path 'dn:dnAddedDate',
dnLastUpdatedDate varchar2(2700) path 'dn:dnLastUpdatedDate'
		 ) x
      WHERE
         t.id = p_id  -- Individual
         ;

      v_rec xwrl_response_ind_columns%rowtype;
      v_case_id varchar2(2700);

   BEGIN

      FOR c1rec IN c1 LOOP

         v_rec.request_id := c1rec.id;
         v_rec.rec := c1rec.rec;

		v_rec.ListKey := c1rec.ListKey;
		v_rec.ListSubKey := c1rec.ListSubKey;
		v_rec.ListRecordType := c1rec.ListRecordType;
		v_rec.ListRecordOrigin := c1rec.ListRecordOrigin;
		v_rec.ListId := c1rec.ListId;
		v_rec.ListGivenNames := c1rec.ListGivenNames;
		v_rec.ListFamilyName := c1rec.ListFamilyName;
		v_rec.ListFullName := c1rec.ListFullName;
		v_rec.ListNameType := c1rec.ListNameType;
		v_rec.ListPrimaryName := c1rec.ListPrimaryName;
		v_rec.ListOriginalScriptName := c1rec.ListOriginalScriptName;
		v_rec.ListDOB := c1rec.ListDOB;
		v_rec.ListCity := c1rec.ListCity;
		v_rec.ListCountry := c1rec.ListCountry;
		v_rec.ListCountryOfBirth := c1rec.ListCountryOfBirth;
		v_rec.ListNationality := c1rec.ListNationality;
		v_rec.MatchRule := c1rec.MatchRule;
		v_rec.MatchScore := c1rec.MatchScore;
		v_rec.CaseKey := c1rec.CaseKey;
		v_rec.AlertId := c1rec.AlertId;
		v_rec.RiskScore := c1rec.RiskScore;
		v_rec.RiskScorePEP := c1rec.RiskScorePEP;
		v_rec.Category := c1rec.Category;
		v_rec.dnPassportNumber := c1rec.dnPassportNumber;
		v_rec.dnNationalId := c1rec.dnNationalId;
		v_rec.dnTitle := c1rec.dnTitle;
		v_rec.dnYOB := c1rec.dnYOB;
		v_rec.dnGender := c1rec.dnGender;
		v_rec.DeceasedFlag := c1rec.DeceasedFlag;
		v_rec.DeceasedDate := c1rec.DeceasedDate;
		v_rec.dnOccupation := c1rec.dnOccupation;
		v_rec.dnAddress := c1rec.dnAddress;
		v_rec.dnCity := c1rec.dnCity;
		v_rec.dnState := c1rec.dnState;
		v_rec.dnPostalCode := c1rec.dnPostalCode;
		v_rec.dnAddressCountryCode := c1rec.dnAddressCountryCode;
		v_rec.dnResidencyCountryCode := c1rec.dnResidencyCountryCode;
		v_rec.dnCountryOfBirthCode := c1rec.dnCountryOfBirthCode;
		v_rec.dnNationalityCountryCodes := c1rec.dnNationalityCountryCodes;
		v_rec.ExternalSources := c1rec.ExternalSources;
		v_rec.CachedExtSources := c1rec.CachedExtSources;
		v_rec.dnAddedDate := c1rec.dnAddedDate;
		v_rec.dnLastUpdatedDate := c1rec.dnLastUpdatedDate;

         v_rec.x_state := c1rec.listrecordtype||' - Open'; -- Hardcoded because value is not available from OWS at this time.

         v_rec.created_by := p_user_id;
         v_rec.creation_date := SYSDATE;
         v_rec.last_updated_by := p_user_id;
         v_rec.last_update_date := SYSDATE;
         v_rec.last_update_login := p_session_id;

         insert into xwrl_response_ind_columns VALUES v_rec;
         COMMIT; -- TSUAZO 11/17/2019

      END LOOP;

      -- Extract Case Number from XML.
      -- If the XML does not contain Case Number then do nothing
      begin            
      SELECT
         substr(x.id,instr(x.id,'|',1,2)+1,length(x.id)) case_id
         into v_case_id
FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "dn"), '//dn:response' PASSING t.response COLUMNS rec FOR ORDINALITY,id varchar2(2700) path '@id'
         ) x 
      WHERE
         t.id = p_id
         ;

      update xwrl_requests
      set case_id = v_case_id
      where id = p_id;

      exception 
      when no_data_found then null;
      end;

      COMMIT;  -- tsuazo 11/4/2019 confirming this commit is at the end of the loop

   END save_response_ind_columns;

   PROCEDURE save_request_entity_columns (
      p_id INTEGER
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL      
      ,x_name_screened OUT varchar2
      ,x_AddressCountryCode out varchar2
      ,x_RegistrationCountryCode out varchar2
      ,x_OperatingCountryCodes out varchar2      
   ) IS

      CURSOR c1 IS
      SELECT
         t.id
,x.ListSubKey
,x.ListRecordType
,x.ListRecordOrigin
,x.CustId
,x.CustSubId
,x.RegistrationNumber
,x.EntityName
,x.NameType
,x.NameQuality
,x.PrimaryName
,x.OriginalScriptName
,x.AliasIsAcronym
,x.Address1
,x.Address2
,x.Address3
,x.Address4
,x.City
,x.State
,x.PostalCode
,x.AddressCountryCode
,x.RegistrationCountryCode
,x.OperatingCountryCodes
,x.ProfileHyperlink
,x.RiskScore
,x.DataConfidenceScore
,x.DataConfidenceComment
,x.CustomString1
,x.CustomString2
,x.CustomString3
,x.CustomString4
,x.CustomString5
,x.CustomString6
,x.CustomString7
,x.CustomString8
,x.CustomString9
,x.CustomString10
,x.CustomString11
,x.CustomString12
,x.CustomString13
,x.CustomString14
,x.CustomString15
,x.CustomString16
,x.CustomString17
,x.CustomString18
,x.CustomString19
,x.CustomString20
,x.CustomString21
,x.CustomString22
,x.CustomString23
,x.CustomString24
,x.CustomString25
,x.CustomString26
,x.CustomString27
,x.CustomString28
,x.CustomString29
,x.CustomString30
,x.CustomString31
,x.CustomString32
,x.CustomString33
,x.CustomString34
,x.CustomString35
,x.CustomString36
,x.CustomString37
,x.CustomString38
,x.CustomString39
,x.CustomString40
,x.CustomDate1
,x.CustomDate2
,x.CustomDate3
,x.CustomDate4
,x.CustomDate5
,x.CustomNumber1
,x.CustomNumber2
,x.CustomNumber3
,x.CustomNumber4
,x.CustomNumber5
      FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "ws"), '//ws:request' PASSING t.request COLUMNS rec FOR ORDINALITY, listsubkey VARCHAR2 (2700) PATH 'ws:ListSubKey', listrecordtype VARCHAR2 (2700) PATH 'ws:ListRecordType', listrecordorigin VARCHAR2 (2700) PATH 'ws:ListRecordOrigin', custid VARCHAR2 (2700) PATH 'ws:CustId', custsubid VARCHAR2 (2700) PATH 'ws:CustSubId', registrationnumber VARCHAR2 (2700) PATH 'ws:RegistrationNumber'
         , entityname VARCHAR2 (2700) PATH 'ws:EntityName', nametype VARCHAR2 (2700) PATH 'ws:NameType', namequality VARCHAR2 (2700) PATH 'ws:NameQuality', primaryname VARCHAR2 (2700) PATH 'ws:PrimaryName', originalscriptname VARCHAR2 (2700) PATH 'ws:OriginalScriptName', aliasisacronym VARCHAR2 (2700) PATH 'ws:AliasIsAcronym', address1 VARCHAR2 (2700) PATH 'ws:Address1', address2 VARCHAR2 (2700) PATH 'ws:Address2', address3 VARCHAR2 (2700) PATH 'ws:Address3', address4 VARCHAR2 (2700) PATH 'ws:Address4'
         , city VARCHAR2 (2700) PATH 'ws:City', state VARCHAR2 (2700) PATH 'ws:State', postalcode VARCHAR2 (2700) PATH 'ws:PostalCode', addresscountrycode VARCHAR2 (2700) PATH 'ws:AddressCountryCode', registrationcountrycode VARCHAR2 (2700) PATH 'ws:RegistrationCountryCode', OperatingCountryCodes VARCHAR2 (2700) PATH 'ws:OperatingCountryCodes', profilehyperlink VARCHAR2 (2700) PATH 'ws:ProfileHyperlink', riskscore VARCHAR2 (2700) PATH 'ws:RiskScore', dataconfidencescore VARCHAR2 (2700) PATH 'ws:DataConfidenceScore'
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
         v_rec.OperatingCountryCodes := c1rec.OperatingCountryCodes;
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

         v_rec.created_by := p_user_id;
         v_rec.creation_date := SYSDATE;
         v_rec.last_updated_by := p_user_id;
         v_rec.last_update_date := SYSDATE;
         v_rec.last_update_login := p_session_id;

         insert into xwrl_request_entity_columns VALUES v_rec;

      END LOOP;

      x_name_screened := v_rec.entityname;
      x_AddressCountryCode := v_rec.AddressCountryCode;
      x_RegistrationCountryCode := v_rec.RegistrationCountryCode;
      x_OperatingCountryCodes := v_rec.OperatingCountryCodes;



      COMMIT;  -- tsuazo 11/4/2019 confirming this commit is at the end of the loop

   END save_request_entity_columns;

   PROCEDURE save_response_entity_columns (
      p_id INTEGER
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL      
   ) IS

      CURSOR c1 IS
      SELECT
         t.id,
          x.rec,
      x.ListKey,
		x.ListSubKey,
		x.ListRecordType,
		x.ListRecordOrigin,
		x.ListId,
		x.ListEntityName,
		x.ListPrimaryName,
		x.ListOriginalScriptName,
		x.ListNameType,
		x.ListCity,
		x.ListCountry,
		x.ListOperatingCountries,
		x.ListRegistrationCountries,
		x.MatchRule,
		x.MatchScore,
		x.CaseKey,
		x.AlertId,
		x.RiskScore,
		x.RiskScorePEP,
		x.Category,
		x.dnRegistrationNumber,
		x.dnOriginalEntityName,
		x.dnEntityName,
		x.dnNameType,
		x.dnNameQuality,
		x.dnPrimaryName,
		x.dnVesselIndicator,
		x.dnVesselInfo,
		x.dnAddress,
		x.dnCity,
		x.dnState,
		x.dnPostalCode,
		x.dnAddressCountryCode,
		x.dnRegistrationCountryCode,
		x.dnOperatingCountryCodes,
		x.dnPEPClassification,
		x.dnAllCountryCodes,
		x.ExternalSources,
		x.CachedExtSources,
		x.dnInactiveFlag,
		x.dnInactiveSinceDate,
		x.dnAddedDate,
		x.dnLastUpdatedDate
      FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "dn"), '//dn:response/dn:record' PASSING t.response COLUMNS rec FOR ORDINALITY, 
		 ListKey varchar2(2700) path 'dn:ListKey',
ListSubKey varchar2(2700) path 'dn:ListSubKey',
ListRecordType varchar2(2700) path 'dn:ListRecordType',
ListRecordOrigin varchar2(2700) path 'dn:ListRecordOrigin',
ListId varchar2(2700) path 'dn:ListId',
ListEntityName varchar2(2700) path 'dn:ListEntityName',
ListPrimaryName varchar2(2700) path 'dn:ListPrimaryName',
ListOriginalScriptName varchar2(2700) path 'dn:ListOriginalScriptName',
ListNameType varchar2(2700) path 'dn:ListNameType',
ListCity varchar2(2700) path 'dn:ListCity',
ListCountry varchar2(2700) path 'dn:ListCountry',
ListOperatingCountries varchar2(2700) path 'dn:ListOperatingCountries',
ListRegistrationCountries varchar2(2700) path 'dn:ListRegistrationCountries',
MatchRule varchar2(2700) path 'dn:MatchRule',
MatchScore varchar2(2700) path 'dn:MatchScore',
CaseKey varchar2(2700) path 'dn:CaseKey',
AlertId varchar2(2700) path 'dn:AlertId',
RiskScore varchar2(2700) path 'dn:RiskScore',
RiskScorePEP varchar2(2700) path 'dn:RiskScorePEP',
Category varchar2(2700) path 'dn:Category',
dnRegistrationNumber varchar2(2700) path 'dn:dnRegistrationNumber',
dnOriginalEntityName varchar2(2700) path 'dn:dnOriginalEntityName',
dnEntityName varchar2(2700) path 'dn:dnEntityName',
dnNameType varchar2(2700) path 'dn:dnNameType',
dnNameQuality varchar2(2700) path 'dn:dnNameQuality',
dnPrimaryName varchar2(2700) path 'dn:dnPrimaryName',
dnVesselIndicator varchar2(2700) path 'dn:dnVesselIndicator',
dnVesselInfo varchar2(2700) path 'dn:dnVesselInfo',
dnAddress varchar2(2700) path 'dn:dnAddress',
dnCity varchar2(2700) path 'dn:dnCity',
dnState varchar2(2700) path 'dn:dnState',
dnPostalCode varchar2(2700) path 'dn:dnPostalCode',
dnAddressCountryCode varchar2(2700) path 'dn:dnAddressCountryCode',
dnRegistrationCountryCode varchar2(2700) path 'dn:dnRegistrationCountryCode',
dnOperatingCountryCodes varchar2(2700) path 'dn:dnOperatingCountryCodes',
dnPEPClassification varchar2(2700) path 'dn:dnPEPClassification',
dnAllCountryCodes varchar2(2700) path 'dn:dnAllCountryCodes',
ExternalSources varchar2(2700) path 'dn:ExternalSources',
CachedExtSources varchar2(2700) path 'dn:CachedExtSources',
dnInactiveFlag varchar2(2700) path 'dn:dnInactiveFlag',
dnInactiveSinceDate varchar2(2700) path 'dn:dnInactiveSinceDate',
dnAddedDate varchar2(2700) path 'dn:dnAddedDate',
dnLastUpdatedDate varchar2(2700) path 'dn:dnLastUpdatedDate') x
      WHERE
         t.id = p_id -- Entity
         ;

      v_rec xwrl_response_entity_columns%rowtype;
      v_case_id varchar2(2700);

   BEGIN

      FOR c1rec IN c1 LOOP

         v_rec.request_id := c1rec.id;
         v_rec.rec := c1rec.rec;

		v_rec.ListKey := c1rec.ListKey;
		v_rec.ListSubKey := c1rec.ListSubKey;
		v_rec.ListRecordType := c1rec.ListRecordType;
		v_rec.ListRecordOrigin := c1rec.ListRecordOrigin;
		v_rec.ListId := c1rec.ListId;
		v_rec.ListEntityName := c1rec.ListEntityName;
		v_rec.ListPrimaryName := c1rec.ListPrimaryName;
		v_rec.ListOriginalScriptName := c1rec.ListOriginalScriptName;
		v_rec.ListNameType := c1rec.ListNameType;
		v_rec.ListCity := c1rec.ListCity;
		v_rec.ListCountry := c1rec.ListCountry;
		v_rec.ListOperatingCountries := c1rec.ListOperatingCountries;
		v_rec.ListRegistrationCountries := c1rec.ListRegistrationCountries;
		v_rec.MatchRule := c1rec.MatchRule;
		v_rec.MatchScore := c1rec.MatchScore;
		v_rec.CaseKey := c1rec.CaseKey;
		v_rec.AlertId := c1rec.AlertId;
		v_rec.RiskScore := c1rec.RiskScore;
		v_rec.RiskScorePEP := c1rec.RiskScorePEP;
		v_rec.Category := c1rec.Category;
		v_rec.dnRegistrationNumber := c1rec.dnRegistrationNumber;
		v_rec.dnOriginalEntityName := c1rec.dnOriginalEntityName;
		v_rec.dnEntityName := c1rec.dnEntityName;
		v_rec.dnNameType := c1rec.dnNameType;
		v_rec.dnNameQuality := c1rec.dnNameQuality;
		v_rec.dnPrimaryName := c1rec.dnPrimaryName;
		v_rec.dnVesselIndicator := c1rec.dnVesselIndicator;
		v_rec.dnVesselInfo := c1rec.dnVesselInfo;
		v_rec.dnAddress := c1rec.dnAddress;
		v_rec.dnCity := c1rec.dnCity;
		v_rec.dnState := c1rec.dnState;
		v_rec.dnPostalCode := c1rec.dnPostalCode;
		v_rec.dnAddressCountryCode := c1rec.dnAddressCountryCode;
		v_rec.dnRegistrationCountryCode := c1rec.dnRegistrationCountryCode;
		v_rec.dnOperatingCountryCodes := c1rec.dnOperatingCountryCodes;
		v_rec.dnPEPClassification := c1rec.dnPEPClassification;
		v_rec.dnAllCountryCodes := c1rec.dnAllCountryCodes;
		v_rec.ExternalSources := c1rec.ExternalSources;
		v_rec.CachedExtSources := c1rec.CachedExtSources;
		v_rec.dnInactiveFlag := c1rec.dnInactiveFlag;
		v_rec.dnInactiveSinceDate := c1rec.dnInactiveSinceDate;
		v_rec.dnAddedDate := c1rec.dnAddedDate;
		v_rec.dnLastUpdatedDate := c1rec.dnLastUpdatedDate;

         v_rec.x_state := c1rec.listrecordtype||' - Open'; -- Hardcoded because value is not available from OWS at this time.

         v_rec.created_by := p_user_id;
         v_rec.creation_date := SYSDATE;
         v_rec.last_updated_by := p_user_id;
         v_rec.last_update_date := SYSDATE;
         v_rec.last_update_login := p_session_id;

         insert into xwrl_response_entity_columns VALUES v_rec;
         COMMIT; -- TSUAZO 11/17/2019

      END LOOP;

       -- Extract Case Number from XML.
      -- If the XML does not contain Case Number then do nothing
      begin
            SELECT
         substr(x.id,instr(x.id,'|',1,2)+1,length(x.id)) case_id
         into v_case_id
FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "dn"), '//dn:response' PASSING t.response COLUMNS rec FOR ORDINALITY,id varchar2(2700) path '@id'
         ) x 
      WHERE
         t.id = p_id
         ;

      update xwrl_requests
      set case_id = v_case_id
      where id = p_id;

      exception
      when no_data_found then null;

      end;

      COMMIT;  -- tsuazo 11/4/2019 confirming this commit is at the end of the loop

   END save_response_entity_columns;

   PROCEDURE save_request_rows (
      p_id INTEGER
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL      
   ) IS

      CURSOR c1 IS
      SELECT
         t.id
         , t.path
         , x.rw
         , x.key
         ,x.value 
      FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "soapenv", 'http://www.datanomic.com/ws' AS "ws"), '//ws:request/ws:*' PASSING t.request COLUMNS rw FOR ORDINALITY, key VARCHAR2 (100) PATH 'name()', value VARCHAR2 (2700) PATH 'text()') x
      WHERE
         t.id = p_id  -- Individual or Entity
         ;

      v_rec xwrl_request_rows%rowtype;
      v_case_id varchar2(2700);

   BEGIN

      FOR c1rec IN c1 LOOP
         v_rec.request_id := c1rec.id;
         v_rec.path := c1rec.path;
         v_rec.rw := c1rec.rw;
         v_rec.key := c1rec.key;
         v_rec.value := c1rec.value;

         v_rec.created_by := p_user_id;
         v_rec.creation_date := SYSDATE;
         v_rec.last_updated_by := p_user_id;
         v_rec.last_update_date := SYSDATE;
         v_rec.last_update_login := p_session_id;

         insert into xwrl_request_rows VALUES v_rec;

      END LOOP;


      COMMIT;  -- tsuazo 11/4/2019 confirming this commit is at the end of the loop

   END save_request_rows;

   procedure process_labels (
   p_request_id in number
   ) is

cursor c1 is

select  id, label, sort_id, display, parm_key, parm_label, parm_sort_id, parm_display
from (
with params as (
SELECT ID parm_id, KEY parm_key, VALUE_STRING parm_label, SORT_ORDER parm_sort_id, DISPLAY_FLAG parm_display
FROM XWRL_PARAMETERS
WHERE ID = 'RESPONSE_ROWS'
--AND DISPLAY_FLAG = 'Y'
--ORDER BY SORT_ORDER
)
select resp.id id, resp.label, resp.sort_id, resp.display, params.parm_key, params.parm_label, params.parm_sort_id, params.parm_display
from xwrl_response_rows resp
,params
where resp.key = params.parm_key
and resp.request_id = p_request_id
--and resp. id = 8378999
--and rownum < 100
--and resp.display is null
--order by resp.id desc
);

begin

for c1rec in c1 loop

/*
dbms_output.put_line('c1rec.id: '||c1rec.id);
dbms_output.put_line('c1rec.parm_label: '||c1rec.parm_label);
dbms_output.put_line('c1rec.parm_label: '||c1rec.parm_display);
dbms_output.put_line('c1rec.parm_label: '||c1rec.parm_sort_id);
*/

update xwrl_response_rows
set label = c1rec.parm_label
,display = c1rec.parm_display
,sort_id = c1rec.parm_sort_id
where id = c1rec.id;

end loop;

commit;   -- tsuazo 11/4/2019 confirming this commit is at the end of the loop.  Note. This was moved to outside the loop.

end process_labels;


   PROCEDURE save_response_rows (
      p_id INTEGER
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL      
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

         v_rec.created_by := p_user_id;
         v_rec.creation_date := SYSDATE;
         v_rec.last_updated_by := p_user_id;
         v_rec.last_update_date := SYSDATE;
         v_rec.last_update_login := p_session_id;

         insert into xwrl_response_rows VALUES v_rec;

      END LOOP;

      process_labels(p_id);

      COMMIT;  -- tsuazo 11/4/2019 confirming this commit is at the end of the loop

   END save_response_rows;

   PROCEDURE ows_web_service (
      p_debug           BOOLEAN
      , p_show_request    BOOLEAN
      , p_show_response   BOOLEAN
      , p_server          VARCHAR2
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL      
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL         
      ,p_job_id                VARCHAR2 DEFAULT NULL
      ,p_batch_id NUMBER DEFAULT NULL   
	  ,p_master_id NUMBER DEFAULT NULL 
	  ,p_alias_id NUMBER DEFAULT NULL 
	  ,p_xref_id  NUMBER DEFAULT NULL 	  
      ,p_update_user_id number default null
      ,p_parent_id number default null
      ,p_relationship_type VARCHAR2 DEFAULT NULL
      ,p_city_id number default null               
      ,p_name_screened varchar2 default null
      ,p_imo_number integer default null
      ,p_vessel_indicator varchar2 default null
      ,p_department varchar2 default null
      ,p_office  varchar2 default null
      ,p_priority  varchar2 default null
      ,p_risk_level  varchar2 default null
      ,p_document_type  varchar2 default null
      ,p_closed_date  date default null
      ,p_assigned_to number default null      
      , p_service_name    VARCHAR2
      , p_list            p_tab
      , p_id              INTEGER
       , x_id OUT INTEGER
   ) AS

      v_server               VARCHAR2 (100);
      v_path                 VARCHAR2 (100);
      v_url                  VARCHAR2 (500);
      v_req                  utl_http.req;
      v_resp                 utl_http.resp;
      v_content              CLOB;
      v_buffer               VARCHAR2 (32767);

      v_soap_xml             XMLTYPE;
      v_compressed_soap_xml             XMLTYPE;
      v_soap_key             VARCHAR2 (100);
      v_soap_value           VARCHAR2 (1000);
      v_soap_query           VARCHAR2 (1000);
      v_compressed_soap_query           VARCHAR2 (1000);
      v_soap_delim           VARCHAR2 (5);
      v_soap_request         CLOB;
      v_compressed_soap_request         CLOB;
      v_compressed_count integer;

      i                      BINARY_INTEGER;

      v_request_rec          xwrl.xwrl_requests%rowtype;
      is_service_available   BOOLEAN := false;
      v_id                   INTEGER;
      is_resubmit            BOOLEAN := false;
      v_count INTEGER;
            v_risk_count INTEGER;

       -- Note: Need Saurabh to create the objects
      xref                  rmi_ows_common_util.wc_external_xref_rec;
      v_return_code number;
      v_ret_msg varchar2(4000);
      v_name_screened varchar2(2700);
      v_dob varchar2(2700);
      v_AddressCountryCode varchar2(2700);
      v_ResidencyCountryCode varchar2(2700);
      v_CountryOfBirthCode varchar2(2700);
      v_NationalityCountryCodes varchar2(2700);
      v_RegistrationCountryCode varchar2(2700);
      v_OperatingCountryCodes varchar2(2700);

	  v_gender varchar2(5);   -- VTONDAPU 12/19/2019
      v_passport varchar2(30);  -- VTONDAPU 12/19/2019

      v_office_code varchar2(100);
      v_dept_code varchar2(100);
      v_dept varchar2(300);
      v_doc_type varchar2(100);
      v_key_count integer;

   BEGIN

  -- Initialize id
     x_id := 0;

	-- Initialize request record
      v_request_rec := NULL;
      v_request_rec.status := 'INITIALIZED';
      v_request_rec.case_status := 'O';
      v_request_rec.case_state := 'N';
      v_request_rec.case_workflow := 'P';
      v_request_rec.priority := 3; -- Low
      v_request_rec.risk_level :=1; -- Low
      v_request_rec.job_id := p_job_id;
      v_request_rec.batch_id := p_batch_id;
      v_request_rec.parent_id := p_parent_id;
      v_request_rec.city_of_residence_id := p_city_id;
      v_request_rec.name_screened := p_name_screened;
      v_request_rec.imo_number := p_imo_number;
      v_request_rec.vessel_indicator := p_vessel_indicator;
      v_request_rec.department := p_department;
      v_request_rec.office := p_office;
	  v_request_rec.master_id := p_master_id;
	  v_request_rec.alias_id := p_alias_id;
	  v_request_rec.xref_id := p_xref_id;

      if p_priority is not null then
         v_request_rec.priority := p_priority;
      end if;

      if p_risk_level is not null then
         v_request_rec.risk_level := p_risk_level;
      end if;

      v_request_rec.document_type := p_document_type;
      v_request_rec.closed_date := p_closed_date;
      v_request_rec.assigned_to := p_assigned_to;

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
         --v_path := get_path (p_id);
         select * into v_request_rec from xwrl_requests where id = p_id; --  tsuazo copy previous record into temporary record 2020-02-07
         v_request_rec.ID := null;
         v_request_rec.resubmit_id := p_id;
         v_request_rec.case_status := 'O';
         v_request_rec.case_state := 'N';
         v_request_rec.error_code := NULL;
         v_request_rec.error_message := NULL;
         v_path := v_request_rec.path;
      ELSE
         v_path := p_service_name;
      END IF;

	  v_url := get_server (v_server) || get_path (v_path);
      v_request_rec.edq_url := v_url; -- tsuazo Add URL 20200227

	  IF p_debug THEN
         dbms_output.put_line ('v_url: ' || v_url);
      END IF;

      v_request_rec.server := p_server;
      v_request_rec.path := v_path;

      /*
      IF is_resubmit THEN -- Note: A resubmit uses a Request ID
         v_request_rec.resubmit_id := p_id;
      END IF;
      */

	-- Get XML 
      IF p_debug THEN
         dbms_output.put_line ('/--- Get XML --/');
      END IF;

      IF is_resubmit THEN -- Note: A resubmit uses a Request ID

         v_soap_xml := get_xml (p_id); 
         v_compressed_soap_xml := get_compressed_xml(p_id);     -- tsuazo 20200627 use compressed XML

         IF v_soap_xml IS NULL THEN
            raise invalid_xml;
         END IF;
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

         IF p_service_name = 'INDIVIDUAL' THEN
            v_compressed_soap_xml := get_xml ('REQUEST_INDIVIDUAL_COMPRESSED');
         ELSIF p_service_name = 'ENTITY' THEN
            v_compressed_soap_xml := get_xml ('REQUEST_ENTITY_COMPRESSED');
         END IF;

      -- Replace Node Values 
         IF p_debug THEN
            dbms_output.put_line ('/--- Replace Node Values --/');
         END IF;

         i := p_list.first;
         v_compressed_count := 0;
         v_soap_delim := chr (40);  -- Left Parenthesis
         v_soap_query := 'declare namespace ws="http://www.datanomic.com/ws"; copy $tmp := .  modify ';
         v_compressed_soap_query := 'declare namespace ws="http://www.datanomic.com/ws"; copy $tmp := .  modify ';

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
            v_soap_delim := chr (44); -- comma       

            -- TSUAZO 05/06/2020 Enable ability to use a compressed version of XML
            IF  use_xml_compressed THEN  -- tsuazo 20200508 use compressed XML

                  v_key_count := 0;
                  IF p_service_name = 'INDIVIDUAL' THEN
                                   SELECT count(*) into v_key_count
                                    FROM
                                       xwrl_parameters t,
                                       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
                                       '//ws:*'
                                       PASSING t.value_xml
                                       COLUMNS key varchar2(2700) PATH 'name()'
                                       , value varchar2(2700) PATH 'text()'
                                     ) x
                                    WHERE
                                       t.id = 'XML'
                                       AND t.key = 'REQUEST_INDIVIDUAL_COMPRESSED'
                                       and x.key = v_soap_key;       

                                       IF v_soap_key = 'Gender' and upper(v_soap_value) in ('U','UNKNOWN','UNSPECIFIED')  then -- TSUAZO 20200522 exclude these values
                                             v_key_count :=0;
                                       end if;

                  ELSIF p_service_name = 'ENTITY' THEN
                                    SELECT count(*) into v_key_count
                                    FROM
                                       xwrl_parameters t,
                                       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
                                       '//ws:*'
                                       PASSING t.value_xml
                                       COLUMNS key varchar2(2700) PATH 'name()'
                                       , value varchar2(2700) PATH 'text()'
                                     ) x
                                    WHERE
                                       t.id = 'XML'
                                       AND t.key = 'REQUEST_ENTITY_COMPRESSED'
                                       and x.key = v_soap_key;
                  END IF;

                 if v_key_count = 1 THEN
                     v_compressed_count := v_compressed_count + 1;
                     --dbms_output.put_line('v_key_count '||v_key_count);
                     if v_compressed_count = 1 then
                        v_soap_delim := chr (40);
                     end if;
                     v_compressed_soap_query := v_compressed_soap_query || v_soap_delim || 'replace value of node $tmp//*/ws:request/ws:' || v_soap_key || ' with "' || v_soap_value || '" ';               
                     v_soap_delim := chr (44); -- comma

                 END IF;

           END IF;

         i := p_list.next (i);

         END LOOP;

         v_soap_query := v_soap_query || ') return $tmp';
         v_compressed_soap_query := v_compressed_soap_query || ') return $tmp';
         IF p_show_request THEN
                dbms_output.put_line ('v_soap_query: ' || v_soap_query);
                dbms_output.put_line ('v_compressed_soap_query: ' || v_compressed_soap_query);   
         END IF;

         v_request_rec.soap_query := v_soap_query;  -- Savepoint of query in case XMLQUERY fails with syntax error

         -- Replaced UPDATEXML with XMLQUERY              
         --dbms_output.put_line('xmlquery');
         SELECT
            xmlquery
         (v_soap_query PASSING v_soap_xml RETURNING CONTENT )  INTO v_soap_xml
         FROM
               dual;

         IF  use_xml_compressed THEN  -- tsuazo 20200508 use compressed XML
               --dbms_output.put_line('compressed xmlquery');
               SELECT
                  xmlquery
               (v_compressed_soap_query PASSING v_compressed_soap_xml RETURNING CONTENT )  INTO v_compressed_soap_xml
               FROM
                     dual;
               END IF;
      end if;

      v_request_rec.request := v_soap_xml;  -- store the full XML format so that requests columns can be populated
       IF  use_xml_compressed THEN  -- tsuazo 20200508 use compressed XML
         v_request_rec.compressed_request := v_compressed_soap_xml;
      end if;

       IF  use_xml_compressed THEN  -- tsuazo 20200508 use compressed XML
            --dbms_output.put_line('getclobval');
            v_soap_request := v_compressed_soap_xml.getclobval ();
      ELSE
            v_soap_request := v_soap_xml.getclobval ();
      END IF;
      IF p_show_request THEN
         show_xml (to_xmltype (v_soap_request));
      END IF;

	-- Check OWS service
   /* Note: This is checked once at job submission.  Do not call directly as this makes  additional http call for each request.
      IF p_debug THEN
         dbms_output.put_line ('/--- Check OWS service --/');
      END IF;
      is_service_available := test_ows_web_service (p_debug => p_debug, p_server => p_server, p_service_name => 'EDQ');
      IF is_service_available = false THEN
         v_request_rec.status := 'ERROR';
         RAISE xwrl_utils.server_unavailable;
      END IF;
      */

   -- Send Request 
      IF p_debug THEN
         dbms_output.put_line ('/--- Send Request --/');
      END IF;
      utl_http.set_transfer_timeout(1800); -- Note: Longest running job in Prod stess test is a little over 5 minutes.  Checking Load Balance ratio.
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

      IF NOT is_resubmit THEN

            v_request_rec.created_by := p_user_id;   
            if p_update_user_id is null then
                  v_request_rec.last_updated_by := p_user_id;
            else
                v_request_rec.last_updated_by := p_update_user_id;
            end if;

            v_request_rec.creation_date := SYSDATE;
            v_request_rec.last_update_date := SYSDATE;
            v_request_rec.last_update_login := p_session_id;

      END IF;

      insert into xwrl_requests VALUES v_request_rec RETURNING id INTO v_id;
      --COMMIT;   -- tsuazo 11/4/2019 -- tsuazo 11/4/2019 confirming this commit is at the end of the loop.  Commenting this one.
      COMMIT; -- TSUAZO 11/17/2019
      x_id := v_id;

      IF p_debug THEN
         dbms_output.put_line ('ID =' || v_id);
      END IF;

      IF is_resubmit THEN -- Note: A resubmit uses a Request ID
         UPDATE xwrl_requests
         SET
            status = decode(v_request_rec.status,'ERROR','FAILED','RESUBMIT')
      ,last_updated_by = p_user_id
      ,last_update_date = SYSDATE
      ,last_update_login = p_session_id          
         WHERE
            id = p_id;
         --COMMIT; -- tsuazo 11/4/2019 confirming this commit is at the end of the loop.  Commenting this one.
         COMMIT; -- TSUAZO 11/17/2019
      END IF;

   -- Parse Request to save data
      IF v_path = 'INDIVIDUAL' THEN
         xwrl_utils.save_request_ind_columns (p_id => v_id, p_user_id => p_user_id, p_session_id  => p_session_id, x_name_screened => v_name_screened, x_dob => v_dob
         , x_AddressCountryCode => v_AddressCountryCode
         , x_ResidencyCountryCode => v_ResidencyCountryCode
         , x_CountryOfBirthCode => v_CountryOfBirthCode
         , x_NationalityCountryCodes => v_NationalityCountryCodes
		 ,x_gender => v_gender  -- VTONDAPU 12/19/2019
         ,x_passport => v_passport  -- VTONDAPU 12/19/2019
         );         
      ELSIF v_path = 'ENTITY' THEN
         -- Note: Entity is using registrationcountrycode for residencycountrycode
         xwrl_utils.save_request_entity_columns (p_id => v_id, p_user_id => p_user_id, p_session_id  => p_session_id, x_name_screened => v_name_screened
         , x_AddressCountryCode => v_AddressCountryCode
         , x_RegistrationCountryCode => v_RegistrationCountryCode
         , x_OperatingCountryCodes => v_OperatingCountryCodes
         );
      END IF;
      xwrl_utils.save_request_rows (p_id => v_id, p_user_id => p_user_id, p_session_id  => p_session_id);

      if v_name_screened is not null then
         v_request_rec.name_screened := v_name_screened;
      end if;

      if v_dob is not  null then
          v_request_rec.date_of_birth := v_dob;
      end if;

   -- Parse Respone to save data
      IF v_path = 'INDIVIDUAL' THEN
         xwrl_utils.save_response_ind_columns (p_id => v_id, p_user_id => p_user_id, p_session_id  => p_session_id);
         SELECT COUNT(*) INTO v_count FROM xwrl_response_ind_columns WHERE request_id = v_id;
         SELECT COUNT(*) INTO v_risk_count FROM xwrl_response_ind_columns WHERE request_id = v_id  and listrecordtype = 'SAN';
      ELSIF v_path = 'ENTITY' THEN
         xwrl_utils.save_response_entity_columns (p_id => v_id, p_user_id => p_user_id, p_session_id  => p_session_id);
         SELECT COUNT(*) INTO v_count FROM xwrl_response_entity_columns WHERE request_id = v_id;
         SELECT COUNT(*) INTO v_risk_count FROM xwrl_response_entity_columns WHERE request_id = v_id   and listrecordtype = 'SAN';
      END IF;
      xwrl_utils.save_response_rows (p_id => v_id, p_user_id => p_user_id, p_session_id  => p_session_id);      

      -- Set Priority and Risk based on Match Count 

      -- Risk Evaluation
      -- Note: No records is Low; Records is Medium, if records contain SAN, risk is High

      if v_count >  0 then
            v_request_rec.risk_level :=2; -- Medium      
      end if;

      if v_risk_count >  0 then
            v_request_rec.risk_level := 3; -- High
      end if;

      SELECT rmi_ows_common_util.get_department (ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (ID) dept,
       rmi_ows_common_util.get_office (ID,'CODE') office,
       rmi_ows_common_util.get_doc_type (ID) doc_type       
    INTO
      v_dept_code,
      v_dept,
      v_office_code,
      v_doc_type
     FROM xwrl_requests
     WHERE id = v_id;

      -- Update the audit columns
      UPDATE xwrl_requests
      SET matches = v_count
      ,name_screened = v_name_screened
      ,date_of_birth = v_dob
      ,priority = v_request_rec.priority
      ,department = v_dept_code
      ,department_ext = v_dept
      ,office = v_office_code
      ,document_type = v_doc_type
      ,country_of_address = v_AddressCountryCode
      ,country_of_residence = v_ResidencyCountryCode
      ,country_of_nationality = v_NationalityCountryCodes
      ,country_of_birth = v_CountryOfBirthCode      
      ,country_of_registration = v_RegistrationCountryCode
      ,country_of_operation = v_OperatingCountryCodes
      ,risk_level = v_request_rec.risk_level
      ,last_updated_by = v_request_rec.last_updated_by
      ,last_update_date = SYSDATE
      ,last_update_login = p_session_id        
	  ,gender = v_gender       -- VTONDAPU 12/19/2019
      ,passport_number = v_passport	 -- VTONDAPU 12/19/2019
      WHERE id = v_id;
      COMMIT; -- TSUAZO 11/17/2019
      -- Update the XREF table 
       -- Note: Need Saurabh to create the objects

      BEGIN
         IF (p_source_table IS NOT NULL AND p_source_id IS NOT NULL) THEN
            xref.source_table := p_source_table;
            xref.source_table_id := p_source_id;
            xref.source_table_status_column := NULL;
            xref.worldcheck_external_xref_id := NULL;
            xref.wc_screening_request_id := x_id;
             rmi_ows_common_util.create_new_xref (xref, v_return_code, v_ret_msg);
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;     

      COMMIT;  -- tsuazo 11/4/2019 confirming this commit is at the end of the loop

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
      WHEN xwrl_utils.invalid_xml THEN
         v_request_rec.status := 'FAILED';
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.INVALID_XML');
         --raise_application_error (-20100, 'Error: xwrl_utils.INVALID_XML');                 
      WHEN OTHERS THEN         
         v_ret_msg := sqlerrm;
         err_ows_web_service (p_debug, v_resp, v_content, v_request_rec);
         dbms_output.put_line ('Error: xwrl_utils.OTHERS '||v_ret_msg);         
         --raise_application_error (-20100, 'Error: OTHERS');                  
   END ows_web_service;

   PROCEDURE ows_individual_screening (
      p_debug                     VARCHAR2 DEFAULT 'FALSE'
      , p_show_request              VARCHAR2 DEFAULT 'FALSE'
      , p_show_response             VARCHAR2 DEFAULT 'FALSE'
      , p_server                    VARCHAR2 DEFAULT NULL 
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL      
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL                 
      ,p_job_id                VARCHAR2 DEFAULT NULL
      ,p_batch_id NUMBER DEFAULT NULL      
	  ,p_master_id NUMBER DEFAULT NULL 
	  ,p_alias_id NUMBER DEFAULT NULL 
	  ,p_xref_id  NUMBER DEFAULT NULL 	  
      ,p_update_user_id number default null
      ,p_parent_id number default null
      ,p_relationship_type VARCHAR2 DEFAULT NULL
      ,p_city_id number default null 
      ,p_name_screened varchar2 default null
      ,p_department varchar2 default null
      ,p_office  varchar2 default null
      ,p_priority  varchar2 default null
      ,p_risk_level  varchar2 default null
      ,p_document_type  varchar2 default null
      ,p_closed_date  date default null
      ,p_assigned_to number default null      
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
      , x_id OUT INTEGER
   ) IS

      v_debug                     boolean := false;
      v_show_request              boolean := false;
      v_show_response             boolean := false;
      v_instance varchar2(50);
      v_server varchar2(50);      
      v_list p_tab;

     v_full_name varchar2(2700);

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
         v_list (9).value := cleanse_name(p_fullname);
    /* TSUAZO commented out after conversation with Rajiv 10/28/2019.  He has modified the filtering that my go into Production
              his recommendation is to use Given and Family names if you have them then use Full Name when you don't
      ELSE 
           v_full_name := ltrim(cleanse_name(p_givennames)||' '|| cleanse_name(p_familyname)); -- TSUAZO added 10/26/2019
           */
      END IF;
      IF p_givennames IS NOT NULL THEN
         v_list (10).key := 'GivenNames';
         v_list (10).value := cleanse_name(p_givennames);
      END IF;
      IF p_familyname IS NOT NULL THEN
         v_list (11).key := 'FamilyName';
         v_list (11).value := cleanse_name(p_familyname);
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
         v_list (14).value := cleanse_name(p_primaryname);
      END IF;
      IF p_originalscriptname IS NOT NULL THEN
         v_list (15).key := 'OriginalScriptName';
         v_list (15).value := p_originalscriptname;
      END IF;
      IF p_gender IS NOT NULL THEN
         --if upper(p_gender) not in ('U','UNKNOWN','UNSPECIFIED')  then -- TSUAZO 20200522 exclude these values
            v_list (16).key := 'Gender';
            v_list (16).value := p_gender;
         --END IF;
      END IF;
      IF p_dateofbirth IS NOT NULL THEN
         v_list (17).key := 'DateOfBirth';
         v_list (17).value := ows_date_format(p_dateofbirth);
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

      xwrl_utils.ows_web_service (p_debug => v_debug, p_show_request => v_show_request, p_show_response => v_show_response, p_server => v_server, p_user_id => p_user_id, p_session_id => p_session_id, p_source_table => p_source_table, p_source_id => p_source_id, p_wc_screening_request_id => p_wc_screening_request_id, p_job_id => p_job_id
      ,p_batch_id => p_batch_id
	  ,p_master_id => p_master_id
	  ,p_alias_id => p_alias_id
	  ,p_xref_id => p_xref_id
      ,p_update_user_id => p_update_user_id
      ,p_parent_id  => p_parent_id
      ,p_relationship_type => p_relationship_type
      ,p_city_id => p_city_id      
      ,p_name_screened => p_name_screened
      ,p_department => p_department
      ,p_office => p_office
      ,p_priority => p_priority
      ,p_risk_level => p_risk_level
      ,p_document_type => p_document_type
      ,p_closed_date => p_closed_date
      ,p_assigned_to => p_assigned_to
      ,p_service_name => 'INDIVIDUAL', p_list => v_list, p_id => NULL, x_id => x_id);

      xwrl_ows_utils.auto_clear_individuals(p_user_id => p_user_id, p_session_id => p_session_id, p_request_id => x_id);

   END ows_individual_screening;

   PROCEDURE ows_entity_screening (
       p_debug                     VARCHAR2 DEFAULT 'FALSE'
      , p_show_request              VARCHAR2 DEFAULT 'FALSE'
      , p_show_response             VARCHAR2 DEFAULT 'FALSE'
      , p_server                    VARCHAR2 DEFAULT NULL
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL      
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL      
      ,p_job_id                VARCHAR2 DEFAULT NULL
      ,p_batch_id NUMBER DEFAULT NULL     
	  ,p_master_id NUMBER DEFAULT NULL 
	  ,p_alias_id NUMBER DEFAULT NULL 
	  ,p_xref_id  NUMBER DEFAULT NULL 	  
      ,p_update_user_id number default null
      ,p_parent_id number default null
      ,p_relationship_type VARCHAR2 DEFAULT NULL
      ,p_city_id number default null                  
      ,p_name_screened varchar2 default null
      ,p_imo_number integer default null
      ,p_vessel_indicator varchar2 default null
      ,p_department varchar2 default null
      ,p_office  varchar2 default null
      ,p_priority  varchar2 default null
      ,p_risk_level  varchar2 default null
      ,p_document_type  varchar2 default null
      ,p_closed_date  date default null
      ,p_assigned_to number default null
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
      , p_OperatingCountryCodes     VARCHAR2 DEFAULT NULL
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
      , x_id OUT INTEGER
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
         v_list (7).value := cleanse_name(p_entityname);
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
      IF p_OperatingCountryCodes IS NOT NULL THEN
         v_list (22).key := 'OperatingCountryCodes';
         v_list (22).value := p_OperatingCountryCodes;
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

      xwrl_utils.ows_web_service (p_debug => v_debug, p_show_request => v_show_request, p_show_response => v_show_response, p_server => v_server, p_user_id => p_user_id, p_session_id => p_session_id, p_source_table => p_source_table, p_source_id => p_source_id, p_wc_screening_request_id => p_wc_screening_request_id, p_job_id => p_job_id
      ,p_batch_id => p_batch_id
	  ,p_master_id => p_master_id
	  ,p_alias_id => p_alias_id
	  ,p_xref_id => p_xref_id	  
      ,p_update_user_id => p_update_user_id
      ,p_parent_id  => p_parent_id
      ,p_relationship_type => p_relationship_type
      ,p_city_id => p_city_id
      ,p_name_screened => p_name_screened
      ,p_imo_number => p_imo_number
      ,p_vessel_indicator => p_vessel_indicator
      ,p_department => p_department
      ,p_office => p_office
      ,p_priority => p_priority
      ,p_risk_level => p_risk_level
      ,p_document_type => p_document_type
      ,p_closed_date => p_closed_date
      ,p_assigned_to => p_assigned_to
      ,p_service_name => 'ENTITY', p_list => v_list, p_id => NULL, x_id => x_id);

      xwrl_ows_utils.auto_clear_entities(p_user_id => p_user_id, p_session_id => p_session_id, p_request_id => x_id);

   END ows_entity_screening;

      PROCEDURE ows_resubmit_screening (
       p_debug                     VARCHAR2 DEFAULT 'FALSE'
      , p_show_request              VARCHAR2 DEFAULT 'FALSE'
      , p_show_response             VARCHAR2 DEFAULT 'FALSE'
      , p_server          VARCHAR2
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL      
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL      
      , p_job_id                VARCHAR2 DEFAULT NULL
      , p_id              INTEGER
      , x_id OUT INTEGER
   ) IS

      v_debug                     boolean := false;
      v_show_request              boolean := false;
      v_show_response             boolean := false;
      v_instance varchar2(50);
      v_server varchar2(50);
      v_list p_tab;
      v_path varchar2(50);

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

      xwrl_utils.ows_web_service (p_debug => v_debug, p_show_request => v_show_request, p_show_response => v_show_response, p_server => v_server, p_user_id => p_user_id, p_session_id => p_session_id, p_source_table => p_source_table, p_source_id => p_source_id, p_wc_screening_request_id => p_wc_screening_request_id, p_job_id => p_job_id, p_service_name => NULL, p_list => v_list, p_id => p_id, x_id => x_id);     

      select path into v_path from xwrl_requests where id = x_id;

      if v_path = 'INDIVIDUAL' THEN
         xwrl_ows_utils.auto_clear_individuals(p_user_id => p_user_id, p_session_id => p_session_id, p_request_id => x_id);      
      elsif v_path = 'ENTITY' THEN
         xwrl_ows_utils.auto_clear_entities(p_user_id => p_user_id, p_session_id => p_session_id, p_request_id => x_id);
      end if;

   END ows_resubmit_screening;

END xwrl_utils;
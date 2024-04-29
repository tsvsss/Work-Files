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
   
   PROCEDURE save_request_ind_columns (p_id integer) IS

   CURSOR C1 IS
      SELECT t.id
,replace(x.ListSubKey,'?',null) ListSubKey
,replace(x.ListRecordType,'?',null) ListRecordType
,replace(x.ListRecordOrigin,'?',null) ListRecordOrigin
,replace(x.CustId,'?',null) CustId
,replace(x.CustSubId,'?',null) CustSubId
,replace(x.PassportNumber,'?',null) PassportNumber
,replace(x.NationalId,'?',null) NationalId
,replace(x.Title,'?',null) Title
,replace(x.FullName,'?',null) FullName
,replace(x.GivenNames,'?',null) GivenNames
,replace(x.FamilyName,'?',null) FamilyName
,replace(x.NameType,'?',null) NameType
,replace(x.NameQuality,'?',null) NameQuality
,replace(x.PrimaryName,'?',null) PrimaryName
,replace(x.OriginalScriptName,'?',null) OriginalScriptName
,replace(x.Gender,'?',null) Gender
,replace(x.DateOfBirth,'?',null) DateOfBirth
,replace(x.YearOfBirth,'?',null) YearOfBirth
,replace(x.Occupation,'?',null) Occupation
,replace(x.Address1,'?',null) Address1
,replace(x.Address2,'?',null) Address2
,replace(x.Address3,'?',null) Address3
,replace(x.Address4,'?',null) Address4
,replace(x.City,'?',null) City
,replace(x.State,'?',null) State
,replace(x.PostalCode,'?',null) PostalCode
,replace(x.AddressCountryCode,'?',null) AddressCountryCode
,replace(x.ResidencyCountryCode,'?',null) ResidencyCountryCode
,replace(x.CountryOfBirthCode,'?',null) CountryOfBirthCode
,replace(x.NationalityCountryCodes,'?',null) NationalityCountryCodes
,replace(x.ProfileHyperlink,'?',null) ProfileHyperlink
,replace(x.RiskScore,'?',null) RiskScore
,replace(x.DataConfidenceScore,'?',null) DataConfidenceScore
,replace(x.DataConfidenceComment,'?',null) DataConfidenceComment
,replace(x.CustomString1,'?',null) CustomString1
,replace(x.CustomString2,'?',null) CustomString2
,replace(x.CustomString3,'?',null) CustomString3
,replace(x.CustomString4,'?',null) CustomString4
,replace(x.CustomString5,'?',null) CustomString5
,replace(x.CustomString6,'?',null) CustomString6
,replace(x.CustomString7,'?',null) CustomString7
,replace(x.CustomString8,'?',null) CustomString8
,replace(x.CustomString9,'?',null) CustomString9
,replace(x.CustomString10,'?',null) CustomString10
,replace(x.CustomString11,'?',null) CustomString11
,replace(x.CustomString12,'?',null) CustomString12
,replace(x.CustomString13,'?',null) CustomString13
,replace(x.CustomString14,'?',null) CustomString14
,replace(x.CustomString15,'?',null) CustomString15
,replace(x.CustomString16,'?',null) CustomString16
,replace(x.CustomString17,'?',null) CustomString17
,replace(x.CustomString18,'?',null) CustomString18
,replace(x.CustomString19,'?',null) CustomString19
,replace(x.CustomString20,'?',null) CustomString20
,replace(x.CustomString21,'?',null) CustomString21
,replace(x.CustomString22,'?',null) CustomString22
,replace(x.CustomString23,'?',null) CustomString23
,replace(x.CustomString24,'?',null) CustomString24
,replace(x.CustomString25,'?',null) CustomString25
,replace(x.CustomString26,'?',null) CustomString26
,replace(x.CustomString27,'?',null) CustomString27
,replace(x.CustomString28,'?',null) CustomString28
,replace(x.CustomString29,'?',null) CustomString29
,replace(x.CustomString30,'?',null) CustomString30
,replace(x.CustomString31,'?',null) CustomString31
,replace(x.CustomString32,'?',null) CustomString32
,replace(x.CustomString33,'?',null) CustomString33
,replace(x.CustomString34,'?',null) CustomString34
,replace(x.CustomString35,'?',null) CustomString35
,replace(x.CustomString36,'?',null) CustomString36
,replace(x.CustomString37,'?',null) CustomString37
,replace(x.CustomString38,'?',null) CustomString38
,replace(x.CustomString39,'?',null) CustomString39
,replace(x.CustomString40,'?',null) CustomString40
,replace(x.CustomDate1,'?',null) CustomDate1
,replace(x.CustomDate2,'?',null) CustomDate2
,replace(x.CustomDate3,'?',null) CustomDate3
,replace(x.CustomDate4,'?',null) CustomDate4
,replace(x.CustomDate5,'?',null) CustomDate5
,replace(x.CustomNumber1,'?',null) CustomNumber1
,replace(x.CustomNumber2,'?',null) CustomNumber2
,replace(x.CustomNumber3,'?',null) CustomNumber3
,replace(x.CustomNumber4,'?',null) CustomNumber4
,replace(x.CustomNumber5,'?',null) CustomNumber5
from xwrl_requests t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "env", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:request'
         PASSING t.request
         columns          
         rec for ordinality,
         ListSubKey varchar2(2700) path 'ws:ListSubKey',
ListRecordType varchar2(2700) path 'ws:ListRecordType',
ListRecordOrigin varchar2(2700) path 'ws:ListRecordOrigin',
CustId varchar2(2700) path 'ws:CustId',
CustSubId varchar2(2700) path 'ws:CustSubId',
PassportNumber varchar2(2700) path 'ws:PassportNumber',
NationalId varchar2(2700) path 'ws:NationalId',
Title varchar2(2700) path 'ws:Title',
FullName varchar2(2700) path 'ws:FullName',
GivenNames varchar2(2700) path 'ws:GivenNames',
FamilyName varchar2(2700) path 'ws:FamilyName',
NameType varchar2(2700) path 'ws:NameType',
NameQuality varchar2(2700) path 'ws:NameQuality',
PrimaryName varchar2(2700) path 'ws:PrimaryName',
OriginalScriptName varchar2(2700) path 'ws:OriginalScriptName',
Gender varchar2(2700) path 'ws:Gender',
DateOfBirth varchar2(2700) path 'ws:DateOfBirth',
YearOfBirth varchar2(2700) path 'ws:YearOfBirth',
Occupation varchar2(2700) path 'ws:Occupation',
Address1 varchar2(2700) path 'ws:Address1',
Address2 varchar2(2700) path 'ws:Address2',
Address3 varchar2(2700) path 'ws:Address3',
Address4 varchar2(2700) path 'ws:Address4',
City varchar2(2700) path 'ws:City',
State varchar2(2700) path 'ws:State',
PostalCode varchar2(2700) path 'ws:PostalCode',
AddressCountryCode varchar2(2700) path 'ws:AddressCountryCode',
ResidencyCountryCode varchar2(2700) path 'ws:ResidencyCountryCode',
CountryOfBirthCode varchar2(2700) path 'ws:CountryOfBirthCode',
NationalityCountryCodes varchar2(2700) path 'ws:NationalityCountryCodes',
ProfileHyperlink varchar2(2700) path 'ws:ProfileHyperlink',
RiskScore varchar2(2700) path 'ws:RiskScore',
DataConfidenceScore varchar2(2700) path 'ws:DataConfidenceScore',
DataConfidenceComment varchar2(2700) path 'ws:DataConfidenceComment',
CustomString1 varchar2(2700) path 'ws:CustomString1',
CustomString2 varchar2(2700) path 'ws:CustomString2',
CustomString3 varchar2(2700) path 'ws:CustomString3',
CustomString4 varchar2(2700) path 'ws:CustomString4',
CustomString5 varchar2(2700) path 'ws:CustomString5',
CustomString6 varchar2(2700) path 'ws:CustomString6',
CustomString7 varchar2(2700) path 'ws:CustomString7',
CustomString8 varchar2(2700) path 'ws:CustomString8',
CustomString9 varchar2(2700) path 'ws:CustomString9',
CustomString10 varchar2(2700) path 'ws:CustomString10',
CustomString11 varchar2(2700) path 'ws:CustomString11',
CustomString12 varchar2(2700) path 'ws:CustomString12',
CustomString13 varchar2(2700) path 'ws:CustomString13',
CustomString14 varchar2(2700) path 'ws:CustomString14',
CustomString15 varchar2(2700) path 'ws:CustomString15',
CustomString16 varchar2(2700) path 'ws:CustomString16',
CustomString17 varchar2(2700) path 'ws:CustomString17',
CustomString18 varchar2(2700) path 'ws:CustomString18',
CustomString19 varchar2(2700) path 'ws:CustomString19',
CustomString20 varchar2(2700) path 'ws:CustomString20',
CustomString21 varchar2(2700) path 'ws:CustomString21',
CustomString22 varchar2(2700) path 'ws:CustomString22',
CustomString23 varchar2(2700) path 'ws:CustomString23',
CustomString24 varchar2(2700) path 'ws:CustomString24',
CustomString25 varchar2(2700) path 'ws:CustomString25',
CustomString26 varchar2(2700) path 'ws:CustomString26',
CustomString27 varchar2(2700) path 'ws:CustomString27',
CustomString28 varchar2(2700) path 'ws:CustomString28',
CustomString29 varchar2(2700) path 'ws:CustomString29',
CustomString30 varchar2(2700) path 'ws:CustomString30',
CustomString31 varchar2(2700) path 'ws:CustomString31',
CustomString32 varchar2(2700) path 'ws:CustomString32',
CustomString33 varchar2(2700) path 'ws:CustomString33',
CustomString34 varchar2(2700) path 'ws:CustomString34',
CustomString35 varchar2(2700) path 'ws:CustomString35',
CustomString36 varchar2(2700) path 'ws:CustomString36',
CustomString37 varchar2(2700) path 'ws:CustomString37',
CustomString38 varchar2(2700) path 'ws:CustomString38',
CustomString39 varchar2(2700) path 'ws:CustomString39',
CustomString40 varchar2(2700) path 'ws:CustomString40',
CustomDate1 varchar2(2700) path 'ws:CustomDate1',
CustomDate2 varchar2(2700) path 'ws:CustomDate2',
CustomDate3 varchar2(2700) path 'ws:CustomDate3',
CustomDate4 varchar2(2700) path 'ws:CustomDate4',
CustomDate5 varchar2(2700) path 'ws:CustomDate5',
CustomNumber1 varchar2(2700) path 'ws:CustomNumber1',
CustomNumber2 varchar2(2700) path 'ws:CustomNumber2',
CustomNumber3 varchar2(2700) path 'ws:CustomNumber3',
CustomNumber4 varchar2(2700) path 'ws:CustomNumber4',
CustomNumber5 varchar2(2700) path 'ws:CustomNumber5'
 ) x
      where t.id = p_id  -- Individual
;

v_rec xwrl_request_ind_columns%ROWTYPE;
   
   BEGIN
   
for c1rec in c1 loop

v_rec.request_id := c1rec.id;
v_rec.ListSubKey := c1rec.ListSubKey;
v_rec.ListRecordType := c1rec.ListRecordType;
v_rec.ListRecordOrigin := c1rec.ListRecordOrigin;
v_rec.CustId := c1rec.CustId;
v_rec.CustSubId := c1rec.CustSubId;
v_rec.PassportNumber := c1rec.PassportNumber;
v_rec.NationalId := c1rec.NationalId;
v_rec.Title := c1rec.Title;
v_rec.FullName := c1rec.FullName;
v_rec.GivenNames := c1rec.GivenNames;
v_rec.FamilyName := c1rec.FamilyName;
v_rec.NameType := c1rec.NameType;
v_rec.NameQuality := c1rec.NameQuality;
v_rec.PrimaryName := c1rec.PrimaryName;
v_rec.OriginalScriptName := c1rec.OriginalScriptName;
v_rec.Gender := c1rec.Gender;
v_rec.DateOfBirth := c1rec.DateOfBirth;
v_rec.YearOfBirth := c1rec.YearOfBirth;
v_rec.Occupation := c1rec.Occupation;
v_rec.Address1 := c1rec.Address1;
v_rec.Address2 := c1rec.Address2;
v_rec.Address3 := c1rec.Address3;
v_rec.Address4 := c1rec.Address4;
v_rec.City := c1rec.City;
v_rec.State := c1rec.State;
v_rec.PostalCode := c1rec.PostalCode;
v_rec.AddressCountryCode := c1rec.AddressCountryCode;
v_rec.ResidencyCountryCode := c1rec.ResidencyCountryCode;
v_rec.CountryOfBirthCode := c1rec.CountryOfBirthCode;
v_rec.NationalityCountryCodes := c1rec.NationalityCountryCodes;
v_rec.ProfileHyperlink := c1rec.ProfileHyperlink;
v_rec.RiskScore := c1rec.RiskScore;
v_rec.DataConfidenceScore := c1rec.DataConfidenceScore;
v_rec.DataConfidenceComment := c1rec.DataConfidenceComment;
v_rec.CustomString1 := c1rec.CustomString1;
v_rec.CustomString2 := c1rec.CustomString2;
v_rec.CustomString3 := c1rec.CustomString3;
v_rec.CustomString4 := c1rec.CustomString4;
v_rec.CustomString5 := c1rec.CustomString5;
v_rec.CustomString6 := c1rec.CustomString6;
v_rec.CustomString7 := c1rec.CustomString7;
v_rec.CustomString8 := c1rec.CustomString8;
v_rec.CustomString9 := c1rec.CustomString9;
v_rec.CustomString10 := c1rec.CustomString10;
v_rec.CustomString11 := c1rec.CustomString11;
v_rec.CustomString12 := c1rec.CustomString12;
v_rec.CustomString13 := c1rec.CustomString13;
v_rec.CustomString14 := c1rec.CustomString14;
v_rec.CustomString15 := c1rec.CustomString15;
v_rec.CustomString16 := c1rec.CustomString16;
v_rec.CustomString17 := c1rec.CustomString17;
v_rec.CustomString18 := c1rec.CustomString18;
v_rec.CustomString19 := c1rec.CustomString19;
v_rec.CustomString20 := c1rec.CustomString20;
v_rec.CustomString21 := c1rec.CustomString21;
v_rec.CustomString22 := c1rec.CustomString22;
v_rec.CustomString23 := c1rec.CustomString23;
v_rec.CustomString24 := c1rec.CustomString24;
v_rec.CustomString25 := c1rec.CustomString25;
v_rec.CustomString26 := c1rec.CustomString26;
v_rec.CustomString27 := c1rec.CustomString27;
v_rec.CustomString28 := c1rec.CustomString28;
v_rec.CustomString29 := c1rec.CustomString29;
v_rec.CustomString30 := c1rec.CustomString30;
v_rec.CustomString31 := c1rec.CustomString31;
v_rec.CustomString32 := c1rec.CustomString32;
v_rec.CustomString33 := c1rec.CustomString33;
v_rec.CustomString34 := c1rec.CustomString34;
v_rec.CustomString35 := c1rec.CustomString35;
v_rec.CustomString36 := c1rec.CustomString36;
v_rec.CustomString37 := c1rec.CustomString37;
v_rec.CustomString38 := c1rec.CustomString38;
v_rec.CustomString39 := c1rec.CustomString39;
v_rec.CustomString40 := c1rec.CustomString40;
v_rec.CustomDate1 := c1rec.CustomDate1;
v_rec.CustomDate2 := c1rec.CustomDate2;
v_rec.CustomDate3 := c1rec.CustomDate3;
v_rec.CustomDate4 := c1rec.CustomDate4;
v_rec.CustomDate5 := c1rec.CustomDate5;
v_rec.CustomNumber1 := c1rec.CustomNumber1;
v_rec.CustomNumber2 := c1rec.CustomNumber2;
v_rec.CustomNumber3 := c1rec.CustomNumber3;
v_rec.CustomNumber4 := c1rec.CustomNumber4;
v_rec.CustomNumber5 := c1rec.CustomNumber5;

end loop;

commit;
      
   END save_request_ind_columns;   
   
PROCEDURE save_response_ind_columns (p_id integer) IS

   CURSOR C1 IS
   SELECT t.id,
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
x.RiskScorePEP
from xwrl_requests t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "env", 'http://www.datanomic.com/ws' as "dn"),
         '//dn:response/dn:record'
         PASSING t.response
         columns 
          rec for ordinality,
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
RiskScorePEP varchar2(2700) path 'dn:RiskScorePEP'
       ) x
      where t.id = p_id  -- Individual
;

v_rec xwrl_response_ind_columns%rowtype;

begin

for c1rec in c1 loop

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

insert  into xwrl_response_ind_columns values v_rec;

end loop;

commit;
   
   END save_response_ind_columns;
   
   PROCEDURE save_request_entity_columns (p_id integer) IS
   
   cursor c1 is
   SELECT t.id
,replace(x.ListSubKey,'?',null) ListSubKey
,replace(x.ListRecordType,'?',null) ListRecordType
,replace(x.ListRecordOrigin,'?',null) ListRecordOrigin
,replace(x.CustId,'?',null) CustId
,replace(x.CustSubId,'?',null) CustSubId
,replace(x.RegistrationNumber,'?',null) RegistrationNumber
,replace(x.EntityName,'?',null) EntityName
,replace(x.NameType,'?',null) NameType
,replace(x.NameQuality,'?',null) NameQuality
,replace(x.PrimaryName,'?',null) PrimaryName
,replace(x.OriginalScriptName,'?',null) OriginalScriptName
,replace(x.AliasIsAcronym,'?',null) AliasIsAcronym
,replace(x.Address1,'?',null) Address1
,replace(x.Address2,'?',null) Address2
,replace(x.Address3,'?',null) Address3
,replace(x.Address4,'?',null) Address4
,replace(x.City,'?',null) City
,replace(x.State,'?',null) State
,replace(x.PostalCode,'?',null) PostalCode
,replace(x.AddressCountryCode,'?',null) AddressCountryCode
,replace(x.RegistrationCountryCode,'?',null) RegistrationCountryCode
,replace(x.OperatingCountryCodes,'?',null) OperatingCountryCodes
,replace(x.ProfileHyperlink,'?',null) ProfileHyperlink
,replace(x.RiskScore,'?',null) RiskScore
,replace(x.DataConfidenceScore,'?',null) DataConfidenceScore
,replace(x.DataConfidenceComment,'?',null) DataConfidenceComment
,replace(x.CustomString1,'?',null) CustomString1
,replace(x.CustomString2,'?',null) CustomString2
,replace(x.CustomString3,'?',null) CustomString3
,replace(x.CustomString4,'?',null) CustomString4
,replace(x.CustomString5,'?',null) CustomString5
,replace(x.CustomString6,'?',null) CustomString6
,replace(x.CustomString7,'?',null) CustomString7
,replace(x.CustomString8,'?',null) CustomString8
,replace(x.CustomString9,'?',null) CustomString9
,replace(x.CustomString10,'?',null) CustomString10
,replace(x.CustomString11,'?',null) CustomString11
,replace(x.CustomString12,'?',null) CustomString12
,replace(x.CustomString13,'?',null) CustomString13
,replace(x.CustomString14,'?',null) CustomString14
,replace(x.CustomString15,'?',null) CustomString15
,replace(x.CustomString16,'?',null) CustomString16
,replace(x.CustomString17,'?',null) CustomString17
,replace(x.CustomString18,'?',null) CustomString18
,replace(x.CustomString19,'?',null) CustomString19
,replace(x.CustomString20,'?',null) CustomString20
,replace(x.CustomString21,'?',null) CustomString21
,replace(x.CustomString22,'?',null) CustomString22
,replace(x.CustomString23,'?',null) CustomString23
,replace(x.CustomString24,'?',null) CustomString24
,replace(x.CustomString25,'?',null) CustomString25
,replace(x.CustomString26,'?',null) CustomString26
,replace(x.CustomString27,'?',null) CustomString27
,replace(x.CustomString28,'?',null) CustomString28
,replace(x.CustomString29,'?',null) CustomString29
,replace(x.CustomString30,'?',null) CustomString30
,replace(x.CustomString31,'?',null) CustomString31
,replace(x.CustomString32,'?',null) CustomString32
,replace(x.CustomString33,'?',null) CustomString33
,replace(x.CustomString34,'?',null) CustomString34
,replace(x.CustomString35,'?',null) CustomString35
,replace(x.CustomString36,'?',null) CustomString36
,replace(x.CustomString37,'?',null) CustomString37
,replace(x.CustomString38,'?',null) CustomString38
,replace(x.CustomString39,'?',null) CustomString39
,replace(x.CustomString40,'?',null) CustomString40
,replace(x.CustomDate1,'?',null) CustomDate1
,replace(x.CustomDate2,'?',null) CustomDate2
,replace(x.CustomDate3,'?',null) CustomDate3
,replace(x.CustomDate4,'?',null) CustomDate4
,replace(x.CustomDate5,'?',null) CustomDate5
,replace(x.CustomNumber1,'?',null) CustomNumber1
,replace(x.CustomNumber2,'?',null) CustomNumber2
,replace(x.CustomNumber3,'?',null) CustomNumber3
,replace(x.CustomNumber4,'?',null) CustomNumber4
,replace(x.CustomNumber5,'?',null) CustomNumber5
from xwrl_requests t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "env", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:request'
         PASSING t.request
         columns 
         rec for ordinality,
         ListSubKey varchar2(2700) path 'ws:ListSubKey',
ListRecordType varchar2(2700) path 'ws:ListRecordType',
ListRecordOrigin varchar2(2700) path 'ws:ListRecordOrigin',
CustId varchar2(2700) path 'ws:CustId',
CustSubId varchar2(2700) path 'ws:CustSubId',
RegistrationNumber varchar2(2700) path 'ws:RegistrationNumber',
EntityName varchar2(2700) path 'ws:EntityName',
NameType varchar2(2700) path 'ws:NameType',
NameQuality varchar2(2700) path 'ws:NameQuality',
PrimaryName varchar2(2700) path 'ws:PrimaryName',
OriginalScriptName varchar2(2700) path 'ws:OriginalScriptName',
AliasIsAcronym varchar2(2700) path 'ws:AliasIsAcronym',
Address1 varchar2(2700) path 'ws:Address1',
Address2 varchar2(2700) path 'ws:Address2',
Address3 varchar2(2700) path 'ws:Address3',
Address4 varchar2(2700) path 'ws:Address4',
City varchar2(2700) path 'ws:City',
State varchar2(2700) path 'ws:State',
PostalCode varchar2(2700) path 'ws:PostalCode',
AddressCountryCode varchar2(2700) path 'ws:AddressCountryCode',
RegistrationCountryCode varchar2(2700) path 'ws:RegistrationCountryCode',
OperatingCountryCodes varchar2(2700) path 'ws:OperatingCountryCodes',
ProfileHyperlink varchar2(2700) path 'ws:ProfileHyperlink',
RiskScore varchar2(2700) path 'ws:RiskScore',
DataConfidenceScore varchar2(2700) path 'ws:DataConfidenceScore',
DataConfidenceComment varchar2(2700) path 'ws:DataConfidenceComment',
CustomString1 varchar2(2700) path 'ws:CustomString1',
CustomString2 varchar2(2700) path 'ws:CustomString2',
CustomString3 varchar2(2700) path 'ws:CustomString3',
CustomString4 varchar2(2700) path 'ws:CustomString4',
CustomString5 varchar2(2700) path 'ws:CustomString5',
CustomString6 varchar2(2700) path 'ws:CustomString6',
CustomString7 varchar2(2700) path 'ws:CustomString7',
CustomString8 varchar2(2700) path 'ws:CustomString8',
CustomString9 varchar2(2700) path 'ws:CustomString9',
CustomString10 varchar2(2700) path 'ws:CustomString10',
CustomString11 varchar2(2700) path 'ws:CustomString11',
CustomString12 varchar2(2700) path 'ws:CustomString12',
CustomString13 varchar2(2700) path 'ws:CustomString13',
CustomString14 varchar2(2700) path 'ws:CustomString14',
CustomString15 varchar2(2700) path 'ws:CustomString15',
CustomString16 varchar2(2700) path 'ws:CustomString16',
CustomString17 varchar2(2700) path 'ws:CustomString17',
CustomString18 varchar2(2700) path 'ws:CustomString18',
CustomString19 varchar2(2700) path 'ws:CustomString19',
CustomString20 varchar2(2700) path 'ws:CustomString20',
CustomString21 varchar2(2700) path 'ws:CustomString21',
CustomString22 varchar2(2700) path 'ws:CustomString22',
CustomString23 varchar2(2700) path 'ws:CustomString23',
CustomString24 varchar2(2700) path 'ws:CustomString24',
CustomString25 varchar2(2700) path 'ws:CustomString25',
CustomString26 varchar2(2700) path 'ws:CustomString26',
CustomString27 varchar2(2700) path 'ws:CustomString27',
CustomString28 varchar2(2700) path 'ws:CustomString28',
CustomString29 varchar2(2700) path 'ws:CustomString29',
CustomString30 varchar2(2700) path 'ws:CustomString30',
CustomString31 varchar2(2700) path 'ws:CustomString31',
CustomString32 varchar2(2700) path 'ws:CustomString32',
CustomString33 varchar2(2700) path 'ws:CustomString33',
CustomString34 varchar2(2700) path 'ws:CustomString34',
CustomString35 varchar2(2700) path 'ws:CustomString35',
CustomString36 varchar2(2700) path 'ws:CustomString36',
CustomString37 varchar2(2700) path 'ws:CustomString37',
CustomString38 varchar2(2700) path 'ws:CustomString38',
CustomString39 varchar2(2700) path 'ws:CustomString39',
CustomString40 varchar2(2700) path 'ws:CustomString40',
CustomDate1 varchar2(2700) path 'ws:CustomDate1',
CustomDate2 varchar2(2700) path 'ws:CustomDate2',
CustomDate3 varchar2(2700) path 'ws:CustomDate3',
CustomDate4 varchar2(2700) path 'ws:CustomDate4',
CustomDate5 varchar2(2700) path 'ws:CustomDate5',
CustomNumber1 varchar2(2700) path 'ws:CustomNumber1',
CustomNumber2 varchar2(2700) path 'ws:CustomNumber2',
CustomNumber3 varchar2(2700) path 'ws:CustomNumber3',
CustomNumber4 varchar2(2700) path 'ws:CustomNumber4',
CustomNumber5 varchar2(2700) path 'ws:CustomNumber5'
 ) x
      where t.id = p_id -- Entity
   ;
   
   v_rec xwrl_request_entity_columns%rowtype;
   
   begin
   
   for c1rec in c1 loop
   v_rec.request_id := c1rec.id;
   v_rec.ListSubKey := c1rec.ListSubKey;
v_rec.ListRecordType := c1rec.ListRecordType;
v_rec.ListRecordOrigin := c1rec.ListRecordOrigin;
v_rec.CustId := c1rec.CustId;
v_rec.CustSubId := c1rec.CustSubId;
v_rec.RegistrationNumber := c1rec.RegistrationNumber;
v_rec.EntityName := c1rec.EntityName;
v_rec.NameType := c1rec.NameType;
v_rec.NameQuality := c1rec.NameQuality;
v_rec.PrimaryName := c1rec.PrimaryName;
v_rec.OriginalScriptName := c1rec.OriginalScriptName;
v_rec.AliasIsAcronym := c1rec.AliasIsAcronym;
v_rec.Address1 := c1rec.Address1;
v_rec.Address2 := c1rec.Address2;
v_rec.Address3 := c1rec.Address3;
v_rec.Address4 := c1rec.Address4;
v_rec.City := c1rec.City;
v_rec.State := c1rec.State;
v_rec.PostalCode := c1rec.PostalCode;
v_rec.AddressCountryCode := c1rec.AddressCountryCode;
v_rec.RegistrationCountryCode := c1rec.RegistrationCountryCode;
v_rec.OperatingCountryCodes := c1rec.OperatingCountryCodes;
v_rec.ProfileHyperlink := c1rec.ProfileHyperlink;
v_rec.RiskScore := c1rec.RiskScore;
v_rec.DataConfidenceScore := c1rec.DataConfidenceScore;
v_rec.DataConfidenceComment := c1rec.DataConfidenceComment;
v_rec.CustomString1 := c1rec.CustomString1;
v_rec.CustomString2 := c1rec.CustomString2;
v_rec.CustomString3 := c1rec.CustomString3;
v_rec.CustomString4 := c1rec.CustomString4;
v_rec.CustomString5 := c1rec.CustomString5;
v_rec.CustomString6 := c1rec.CustomString6;
v_rec.CustomString7 := c1rec.CustomString7;
v_rec.CustomString8 := c1rec.CustomString8;
v_rec.CustomString9 := c1rec.CustomString9;
v_rec.CustomString10 := c1rec.CustomString10;
v_rec.CustomString11 := c1rec.CustomString11;
v_rec.CustomString12 := c1rec.CustomString12;
v_rec.CustomString13 := c1rec.CustomString13;
v_rec.CustomString14 := c1rec.CustomString14;
v_rec.CustomString15 := c1rec.CustomString15;
v_rec.CustomString16 := c1rec.CustomString16;
v_rec.CustomString17 := c1rec.CustomString17;
v_rec.CustomString18 := c1rec.CustomString18;
v_rec.CustomString19 := c1rec.CustomString19;
v_rec.CustomString20 := c1rec.CustomString20;
v_rec.CustomString21 := c1rec.CustomString21;
v_rec.CustomString22 := c1rec.CustomString22;
v_rec.CustomString23 := c1rec.CustomString23;
v_rec.CustomString24 := c1rec.CustomString24;
v_rec.CustomString25 := c1rec.CustomString25;
v_rec.CustomString26 := c1rec.CustomString26;
v_rec.CustomString27 := c1rec.CustomString27;
v_rec.CustomString28 := c1rec.CustomString28;
v_rec.CustomString29 := c1rec.CustomString29;
v_rec.CustomString30 := c1rec.CustomString30;
v_rec.CustomString31 := c1rec.CustomString31;
v_rec.CustomString32 := c1rec.CustomString32;
v_rec.CustomString33 := c1rec.CustomString33;
v_rec.CustomString34 := c1rec.CustomString34;
v_rec.CustomString35 := c1rec.CustomString35;
v_rec.CustomString36 := c1rec.CustomString36;
v_rec.CustomString37 := c1rec.CustomString37;
v_rec.CustomString38 := c1rec.CustomString38;
v_rec.CustomString39 := c1rec.CustomString39;
v_rec.CustomString40 := c1rec.CustomString40;
v_rec.CustomDate1 := c1rec.CustomDate1;
v_rec.CustomDate2 := c1rec.CustomDate2;
v_rec.CustomDate3 := c1rec.CustomDate3;
v_rec.CustomDate4 := c1rec.CustomDate4;
v_rec.CustomDate5 := c1rec.CustomDate5;
v_rec.CustomNumber1 := c1rec.CustomNumber1;
v_rec.CustomNumber2 := c1rec.CustomNumber2;
v_rec.CustomNumber3 := c1rec.CustomNumber3;
v_rec.CustomNumber4 := c1rec.CustomNumber4;
v_rec.CustomNumber5 := c1rec.CustomNumber5;

   insert  into xwrl_request_entity_columns values v_rec;
   
   end loop;
   
commit;
   
   END save_request_entity_columns; 
   
   PROCEDURE save_response_entity_columns (p_id integer) IS
   
   cursor c1 is
   SELECT t.id, 
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
x.RiskScorePEP
from xwrl_requests t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "env", 'http://www.datanomic.com/ws' as "dn"),
         '//dn:response/dn:record'
         PASSING t.response
         columns  rec for ordinality,
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
RiskScorePEP varchar2(2700) path 'dn:RiskScorePEP'
       ) x
      where t.id = p_id -- Entity
;

v_rec xwrl_response_entity_columns%rowtype;
   
   begin
   
   for c1rec in c1 loop
   
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
   
      insert  into xwrl_response_entity_columns values v_rec;
   
   end loop;
   
commit;
   
   END save_response_entity_columns;
   
   PROCEDURE save_request_rows (p_id integer) IS
   
   CURSOR c1 IS
   SELECT t.id,t.path,x.rw,x.key,replace(x.value,'?',null) value
from xwrl_requests t,
  XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:request/ws:*'
         PASSING t.request
         columns   rw for ordinality,
         key varchar2(100)  path 'name()',
          value varchar2(2700)  path 'text()'
       )  x
      where t.id = p_id  -- Individual or Entity
      ;
      
      v_rec xwrl_request_rows%rowtype;
   
   BEGIN
   
   for c1rec in c1 loop
      v_rec.request_id := c1rec.id;
      v_rec.path := c1rec.path;
      v_rec.rw := c1rec.rw;
      v_rec.key := c1rec.key;
      v_rec.value := c1rec.value;
      
      insert into xwrl_request_rows values v_rec;
   
   end loop;
   
   commit;
   
   END save_request_rows;
   
   PROCEDURE save_response_rows (p_id integer) IS
   
   CURSOR c1 IS
SELECT t.id,t.path,resp.ows_id,rec.rec_row,det.det_row,det.key,det.value
from xwrl_requests t,
       XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "env", 'http://www.datanomic.com/ws' as "dn"),
         '//dn:response'
         PASSING t.response
         columns  ows_id    varchar2(50) path '@id'
         ,record_list xmltype path '*'
       ) resp
       ,xmltable(
       '/*'
       passing resp.record_list
       columns rec_row for ordinality
       ,detail_list xmltype path '*') rec
        ,xmltable(
       '/*'
       passing rec.detail_list
       columns det_row for ordinality,
       key varchar2(100)  path 'name()',
          value varchar2(2700)  path 'text()') det
      where t.id = p_id  -- Individual or Entity.det_row      
      order by rec.rec_row,det.det_row;
      
      v_rec xwrl_response_rows%rowtype;
   
   BEGIN
   
   for c1rec in c1 loop
      v_rec.request_id := c1rec.id;
      v_rec.path := c1rec.path;
      v_rec.ows_id := c1rec.ows_id;
      v_rec.rec_row := c1rec.rec_row;
      v_rec.det_row := c1rec.det_row;
      v_rec.key := c1rec.key;
      v_rec.value := c1rec.value;
      
      insert into xwrl_response_rows values v_rec;
   
   end loop;
   
   commit;
   
   END save_response_rows;

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

   -- Parse Request to save data
     IF v_path = 'INDIVIDUAL' THEN
         xwrl_utils.save_request_ind_columns(v_id);              
      ELSIF v_path = 'ENTITY' THEN         
      xwrl_utils.save_request_entity_columns(v_id);     
     END IF;     
     xwrl_utils.save_request_rows(v_id);
     
   -- Parse Respone to save data
     IF v_path = 'INDIVIDUAL' THEN
         xwrl_utils.save_response_ind_columns(v_id);
      ELSIF v_path = 'ENTITY' THEN         
         xwrl_utils.save_response_entity_columns(v_id);
     END IF;     
     xwrl_utils.save_response_rows(v_id);     

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
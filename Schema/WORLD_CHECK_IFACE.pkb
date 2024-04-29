CREATE OR REPLACE package body APPS.world_check_iface as

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: world_check_iface.pkb 1.1 2019/11/15 12:00:00ET   IRI Exp       										  $*/
/********************************************************************************************************************
* Object Type         : Package Body                                                                                *
* Name                : world_check_iface                                                                           *
* Script Name         : world_check_iface.pkb                                                                       *
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

function soap_envelope_start return varchar2 is
return_string varchar2(32000) :=null;
begin
--this is a change mt spot
return_string:= '<?xml version="1.0" encoding="utf-8"?>
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:scr="http://screening.complinet.com/">';
return return_string;
end;

function soap_envelope_end return varchar2 is
return_string varchar2(32000) :=null;
begin
return_string:= ' </soapenv:Envelope>';
return return_string;
end;

function soap_header return varchar2 is
return_string varchar2(32000) :=null;
begin
return_string:= '<soapenv:Header>
  <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
    <wsse:UsernameToken wsu:Id="UsernameToken-19" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
      <wsse:Username>cgaughf@register-iri.com</wsse:Username>
      <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">legal123</wsse:Password>
    </wsse:UsernameToken>
  </wsse:Security>
   </soapenv:Header>';

return return_string;
end;

function world_check_request( asignee_identifier in varchar2, custom_id1 in varchar2, custom_id2 in varchar2, group_identifier in varchar2, search_name in varchar2, name_type in varchar2) return varchar2 is
return_string varchar2(32000) :=null;
begin
return_string:='
<soapenv:Body>
 <scr:screen>
    <screenRequest>
      <assigneeIdentifier>'||xml_encode_string(asignee_identifier)||'</assigneeIdentifier>
      <customId1>'||xml_encode_string( custom_id1)||'</customId1>
      <customId2>'||xml_encode_string(custom_id2)||'</customId2>
      <groupIdentifier>'||group_identifier||'</groupIdentifier>
      <name>'||xml_encode_string(search_name)||'</name>
      <nameType>'||name_type||'</nameType>
      </screenRequest>
    </scr:screen>
  </soapenv:Body>';
return return_string;
end;

function get_name_details(p_name_identifier in varchar2, p_match_type in varchar2,p_start in varchar2, p_limit in varchar2) return varchar2 is
return_string varchar2(32000) :=null;
begin
return_string:='
      <soapenv:Body>
      <scr:getMatches>
         <nameIdentifier>'||p_name_identifier||'</nameIdentifier>
         <matchType>'||p_match_type||'</matchType>
         <start>'||p_start||'</start>
         <limit>'||p_limit||'</limit>
      </scr:getMatches>
   </soapenv:Body>';
return return_string;
end;

function get_name_matches(p_match_identifier in varchar2, p_match_risk in varchar2 default 'UNKNOWN', p_match_status in varchar2 default 'UNSPECIFIED' , p_note in varchar2 default null ) return varchar2 is
return_string varchar2(2000) :=null;
begin
return_string:='
 <soapenv:Body>
      <scr:resolve>
         <matchIdentifierList>
            <matchIdentifiers>
               <matchIdentifier>'||p_match_identifier||'</matchIdentifier>
            </matchIdentifiers>
         </matchIdentifierList>
         <matchRisk>'|| p_match_risk||'</matchRisk>
         <matchStatus>'|| p_match_status||'</matchStatus>
         <note>'|| p_note||'</note>
      </scr:resolve>
   </soapenv:Body>';
return return_string;
end;

function get_new_updated_names return varchar2 is
return_string varchar2(2000) :=null;
begin
return_string:='
   <soapenv:Header/>
   <soapenv:Body>
      <scr:getStoredNameFilter>
      </scr:getStoredNameFilter>
   </soapenv:Body>';
return return_string;
end;

function get_content_details(p_match_identifier in varchar2 ) return varchar2 is
return_string varchar2(2000) :=null;
begin
return_string:='
   <soapenv:Body>
         <scr:getDetails>
         <matchIdentifier>'||p_match_identifier||'</matchIdentifier>
      </scr:getDetails>
   </soapenv:Body>';
return return_string;
end;

function get_content_summary(p_match_identifier in varchar2 ) return varchar2 is
return_string varchar2(2000) :=null;
begin
return_string:='
   <soapenv:Body>
      <scr:getSummariesForMatch>
         <!--Optional:-->
         <matchIdentifier>'||p_match_identifier||'</matchIdentifier>
      </scr:getSummariesForMatch>
   </soapenv:Body>';
return return_string;
end;

function saveForOngoingScreening(p_name_identifier in varchar2 ) return varchar2 is
return_string varchar2(2000) :=null;
begin
return_string:=' <soapenv:Body>
      <scr:saveForOngoingScreening>
         <nameIdentifierList>
            <nameIdentifiers>
               <nameIdentifier>'||p_name_identifier||'</nameIdentifier>
            </nameIdentifiers>
         </nameIdentifierList>
      </scr:saveForOngoingScreening>
   </soapenv:Body>';
return return_string;
end;

function delete_screening(p_name_identifier in varchar2 ) return varchar2 is
return_string varchar2(2000) :=null;
begin
return_string:='<soapenv:Body>
      <scr:delete>
         <!--Optional:-->
         <nameIdentifierList>
            <nameIdentifiers>
               <!--1 or more repetitions:-->
               <nameIdentifier>'||p_name_identifier||'</nameIdentifier>
            </nameIdentifiers>
         </nameIdentifierList>
      </scr:delete>
   </soapenv:Body>';
return return_string;
end;

function change_status(p_name_identifier in varchar2, p_status in varchar2 ) return varchar2 is
return_string varchar2(2000) :=null;
begin
return_string:='<soapenv:Body>
      <scr:changeNameStatus>
         <!--Optional:-->
         <nameIdentifierList>
            <nameIdentifiers>
               <!--1 or more repetitions:-->
               <nameIdentifier>'||p_name_identifier||'</nameIdentifier>
            </nameIdentifiers>
         </nameIdentifierList>
         <!--Optional:-->
         <nameStatus>'||p_status||'</nameStatus>
      </scr:changeNameStatus>
   </soapenv:Body>';
return return_string;
end;

function add_name_note(p_name_identifier in varchar2, p_note in varchar2 ) return varchar2 is
return_string varchar2(2000) :=null;
begin
return_string:='<soapenv:Body>
      <scr:addNote>
         <!--Optional:-->
         <nameIdentifierList>
            <nameIdentifiers>
               <!--1 or more repetitions:-->
               <nameIdentifier>'||p_name_identifier||'</nameIdentifier>
            </nameIdentifiers>
         </nameIdentifierList>
         <!--Optional:-->
         <note>'||p_note||'</note>
      </scr:addNote>
   </soapenv:Body>';
return return_string;
end;

function add_match_note(p_match_identifier in varchar2, p_note in varchar2 ) return varchar2 is
return_string varchar2(2000) :=null;
begin
return_string:=' <soapenv:Body>
      <scr:addNote>
         <!--Optional:-->
         <matchIdentifierList>
            <matchIdentifiers>
               <!--1 or more repetitions:-->
               <matchIdentifier>'||xml_encode_string(p_match_identifier)||'</matchIdentifier>
            </matchIdentifiers>
         </matchIdentifierList>
         <!--Optional:-->
         <note>'||p_note||'</note>
      </scr:addNote>
   </soapenv:Body>';
return return_string;
end;

function add_match_status(p_match_identifier in varchar2, p_status in varchar2, p_note in varchar2, p_matchrisk in varchar2 ) return varchar2 is
return_string varchar2(2000) :=null;
begin
return_string:='
   <soapenv:Body>
      <scr:resolve>
         <!--Optional:-->
         <matchIdentifierList>
            <matchIdentifiers>
               <!--1 or more repetitions:-->
               <matchIdentifier>'||p_match_identifier||'</matchIdentifier>
            </matchIdentifiers>
         </matchIdentifierList>
         <!--Optional:-->
         <matchRisk>'||p_matchrisk||'</matchRisk>
         <!--Optional:-->
         <matchStatus>'||p_status||'</matchStatus>
         <!--Optional:-->
         <note>'||jcharfunc.remove_special_chars(xml_encode_string(p_note))||'</note>
      </scr:resolve>
   </soapenv:Body>
   ';
return return_string;
end;

function archive_rec(p_name_identifier in varchar2 ) return varchar2 is
return_string varchar2(2000) :=null;
begin
return_string:='<soapenv:Body>
      <scr:archive>
         <!--Optional:-->
         <nameIdentifierList>
            <nameIdentifiers>
               <!--1 or more repetitions:-->
               <nameIdentifier>'||p_name_identifier||'</nameIdentifier>
            </nameIdentifiers>
         </nameIdentifierList>
      </scr:archive>
   </soapenv:Body>';
return return_string;
end;



function get_content_titles(p_match_identifier in varchar2 ) return varchar2 is
return_string varchar2(2000) :=null;
begin
return_string:='
   <soapenv:Header/>
   <soapenv:Body>
      <scr:getTitlesForMatch>
         <matchIdentifier>'||p_match_identifier||'</matchIdentifier>
      </scr:getTitlesForMatch>
   </soapenv:Body>';
return return_string;
end;

function get_world_check_request_url  return varchar2 is
--return_string varchar2(100) :='https://screening.complinet.com/soap/v1/screener';
--- Code Modified By Gopi Vella on 13-JAN-2018 to Call SHA2 API as DB is Upgraded to 12c ------
--return_string varchar2(100) :='https://screeningapi.complinet.com/soap/v1/screener';
return_string varchar2(100) :='https://screening.complinet.com/soap/v1/screener';
---End Code Change ----------------------------------------------------------------------------
--return_string varchar2(100) :='https://screeningapi.complinet.com/soap/v1/screener';

begin
return return_string;
end;

function get_world_check_name_url  return varchar2 is
--return_string varchar2(100) :='https://screening.complinet.com/soap/v1/name';
--- Code Modified By Gopi Vella on 13-JAN-2018 to Call SHA2 API as DB is Upgraded to 12c -----
--return_string varchar2(100) :='https://screeningapi.complinet.com/soap/v1/name';
return_string varchar2(100) :='https://screening.complinet.com/soap/v1/name';
---End Code Change ----------------------------------------------------------------------------
--return_string varchar2(100) :='https://screeningapi.complinet.com/soap/v1/screener';

begin
return return_string;
end;

function get_world_check_matches_url  return varchar2 is
--return_string varchar2(100) :='https://screening.complinet.com/soap/v1/match';
--- Code Modified By Gopi Vella on 13-JAN-2018 to Call SHA2 API as DB is Upgraded to 12c ------
--return_string varchar2(100) :='https://screeningapi.complinet.com/soap/v1/match';
return_string varchar2(100) :='https://screening.complinet.com/soap/v1/match';
---End Code Change ----------------------------------------------------------------------------
--return_string varchar2(100) :='https://screeningapi.complinet.com/soap/v1/match';
begin
return return_string;
end;

function get_world_check_content_url  return varchar2 is
--return_string varchar2(100) :='https://screening.complinet.com/soap/v1/content';

--return_string varchar2(100) :='https://screeningapi.complinet.com/soap/v1/content';
--- Code Modified By Gopi Vella on 13-JAN-2018 to Call SHA2 API as DB is Upgraded to 12c ------
--return_string varchar2(100) :='https://screeningapi.complinet.com/soap/v1/content';
return_string varchar2(100) :='https://screening.complinet.com/soap/v1/content';
---End Code Change ----------------------------------------------------------------------------
begin
return return_string;
end;

function get_stored_name_url  return varchar2 is
--return_string varchar2(100) :='https://screening.complinet.com/soap/v1/storedName';
--- Code Modified By Gopi Vella on 13-JAN-2018 to Call SHA2 API as DB is Upgraded to 12c ------
--return_string varchar2(100) :='https://screeningapi.complinet.com//soap/v1/storedName';
return_string varchar2(100) :='https://screening.complinet.com//soap/v1/storedName';
---End Code Change ----------------------------------------------------------------------------
--return_string varchar2(100) :='https://screeningapi.complinet.com//soap/v1/storedName';

begin
return return_string;
end;
procedure send_request (p_url in varchar2, p_request in varchar2, p_http_request out UTL_HTTP.req ) is

   l_http_request      UTL_HTTP.req;
   l_http_response     UTL_HTTP.resp;
   l_buffer_size       NUMBER (10) := 512;
   l_line_size         NUMBER (10) := 50;
   l_lines_count       NUMBER (10) := 20;
   l_string_request    VARCHAR2 (4000);
   l_line              VARCHAR2 (128);
   l_substring_msg     VARCHAR2 (512);
   l_raw_data          RAW (512);
   l_clob_response     CLOB;
   l_error             VARCHAR2(500);

begin
--dbms_output.put_line('Send Request');  
   l_string_request:=p_request;
  -- UTL_HTTP.set_detailed_excp_support(TRUE);
   UTL_HTTP.set_transfer_timeout (60);
   --- Modified By Gopi Vella To Change The File Path Pointing To Core Instance---------------------------------------------
   --UTL_HTTP.set_wallet ('file:/mnt/nfs/oracle_files/wallet/', 'InternationalRegistries123'); /* setup ssl certificate */
   --UTL_HTTP.set_wallet ('file:/irip/oracle_files/wallet/', 'InternationalRegistries123'); /* setup ssl certificate */
   UTL_HTTP.set_wallet ('file:/irip/oracle_files/wallet/', 'InternationalRegistries123'); /* setup ssl certificate */
   ----- End Code Change ---------------------------------------------------------------------------------------------------

  --dbms_output.put_line(p_url);

  --dbms_output.put_line(l_string_request);

    l_http_request := UTL_HTTP.begin_request (
         url            => p_url ,
         method         => 'POST',
         http_version   => 'HTTP/1.1');
   --dbms_output.put_line('after_reqest');
   UTL_HTTP.set_header (l_http_request, 'User-Agent', 'Mozilla/4.0');
   UTL_HTTP.set_header (l_http_request, 'Connection', 'close');
   UTL_HTTP.set_header (l_http_request, 'Content-Type', 'application/soap+xml; charset=utf-8');
   UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (l_string_request));

   <<request_loop>>
   FOR i IN 0 .. CEIL (LENGTH (l_string_request) / l_buffer_size) - 1
   LOOP
      l_substring_msg :=
         SUBSTR (l_string_request, i * l_buffer_size + 1, l_buffer_size);

      BEGIN
         l_raw_data := UTL_RAW.cast_to_raw (l_substring_msg);
         UTL_HTTP.write_raw (r => l_http_request, data => l_raw_data);

         --dbms_output.put_line(UTL_RAW.CAST_TO_VARCHAR2(l_raw_data));
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            EXIT request_loop;
      END;
   END LOOP request_loop;

    p_http_request:= l_http_request;
  EXCEPTION
     WHEN OTHERS THEN
        l_error :=  SQLERRM;
        dbms_output.put_line('Error in Send Request: '||l_error);
  END;

procedure read_response(p_http_request in out UTL_HTTP.req, p_response out XMLTYPE, return_code out number, return_message out varchar2 ) is

l_http_response     UTL_HTTP.resp;
l_buffer_size       NUMBER (10) := 512;
l_line_size         NUMBER (10) := 50;

l_string_request    VARCHAR2 (4000);
l_line              VARCHAR2 (128);
l_substring_msg     VARCHAR2 (512);
l_raw_data          RAW (512);
l_clob_response     CLOB;
v_msg varchar2(100);
loop_counter number:=1;

v_name VARCHAR2(100);
 v_value VARCHAR2(500);

begin
--dbms_output.put_line('**read response**');

-- this is where the error is on the get response MT
v_msg:='UTL_HTTP.get_response';

   l_http_response := UTL_HTTP.get_response (p_http_request);

   --dbms_output.put_line ('Response> status_code: "' || l_http_response.status_code || '"');
   --dbms_output.put_line ('Response> reason_phrase: "' || l_http_response.reason_phrase || '"');
   --dbms_output.put_line ('Response> http_version: "' || l_http_response.http_version || '"');

   BEGIN
     <<response_loop>>
      LOOP
      v_msg:='UTL_HTTP.read_raw ='||to_char(loop_counter);
         UTL_HTTP.read_raw (l_http_response, l_raw_data, l_buffer_size);

         --dbms_output.put_line('**read response b** '||to_char(loop_counter)||' '||UTL_RAW.cast_to_varchar2 (l_raw_data));
         l_clob_response := l_clob_response || UTL_RAW.cast_to_varchar2 (l_raw_data);
         loop_counter:=loop_counter+1;
      END LOOP response_loop;
   EXCEPTION
      WHEN UTL_HTTP.end_of_body
      THEN
         v_msg:='UTL_HTTP.end_response';
         UTL_HTTP.end_response (l_http_response);
       when others then
       UTL_HTTP.end_response (l_http_response);
       return_code:=  Utl_Http.get_detailed_sqlcode;
       return_message:='ERROR:   '||l_http_response.reason_phrase||Utl_Http.get_detailed_sqlcode  || Utl_Http.Get_Detailed_Sqlerrm;

       return;
   END;
   return_code:=l_http_response.status_code;
      IF (l_http_response.status_code = 200)
   THEN                                  -- Create XML type from response text
      p_response := XMLType.createXML (l_clob_response);  -- Clean SOAP header
      return_message:='OK';
   --elsIF (l_http_response.status_code = 500)
    else
    return_message:='ERROR:   '||l_http_response.reason_phrase||Utl_Http.get_detailed_sqlcode  || Utl_Http.Get_Detailed_Sqlerrm;
    --var_str := DBMS_LOB.SUBSTR (l_clob_response, 4000, 1);
    --dbms_output.put_line (var_str);
   END IF;

   IF p_http_request.private_hndl IS NOT NULL
   THEN
      UTL_HTTP.end_request (p_http_request);
   END IF;

   IF l_http_response.private_hndl IS NOT NULL
   THEN
      UTL_HTTP.end_response (l_http_response);
   END IF;         

--exception
--when others then
--raise_application_error(-20023,'ERROR:   '||l_http_response.reason_phrase||' '||Utl_Http.get_detailed_sqlcode  ||' '||Utl_Http.Get_Detailed_Sqlerrm||' '||v_msg||' '||to_char(l_http_response.status_code));
 --return_message:= Utl_Http.get_detailed_sqlcode  || Utl_Http.Get_Detailed_Sqlerrm;
END;


procedure printElements(doc xmldom.DOMDocument,p_tag_name in varchar2) is
nl xmldom.DOMNodeList;
len number;
n xmldom.DOMNode;

begin
  --dbms_output.put_line('Start Print Elements ');
   -- get all elements
   nl := xmldom.getElementsByTagName(doc, p_tag_name);
   len := xmldom.getLength(nl);

   -- loop through elements
   for i in 0..len-1 loop
      n := xmldom.item(nl, i);
      --dbms_output.put_line(xmldom.getNodeName(n) || ' ');
   end loop;
    --dbms_output.put_line('End Print Elements ');
   --------dbms_output.put_line('');
end printElements;

procedure printElementAttributes(doc xmldom.DOMDocument,p_tag_name in varchar2) is
nl XMLDOM.DOMNODELIST;
len1 NUMBER;
len2 NUMBER;
n XMLDOM.DOMNODE;
e XMLDOM.DOMELEMENT;
nnm XMLDOM.DOMNAMEDNODEMAP;
attrname VARCHAR2(4000);
attrval VARCHAR2(4000);
text_value VARCHAR2(4000):=NULL;
n_child XMLDOM.DOMNODE;

BEGIN

-- get all elements
nl := XMLDOM.getElementsByTagName(doc, p_tag_name);
len1 := XMLDOM.getLength(nl);
----dbms_output.put_line('getElementsByTagName ='||to_char(nl));
----dbms_output.put_line('getLength ='||to_char(len1));
-- loop through elements
FOR j in 0..len1-1 LOOP
n := XMLDOM.item(nl, j);
e := XMLDOM.makeElement(n);
--dbms_output.put_line(xmldom.getTagName(e) || ':');

-- get all attributes of element
nnm := xmldom.getAttributes(n);

n_child:=xmldom.getFirstChild(n);
text_value:=xmldom.getNodeValue(n_child);
--dbms_output.put_line(xmldom.getTagName(e) || ':' ||text_value);

/*
IF (xmldom.isNull(nnm) = FALSE) THEN
len2 := xmldom.getLength(nnm);
------dbms_output.put_line('length='||len2);

-- loop through attributes

FOR i IN 0..len2-1 LOOP
n := xmldom.item(nnm, i);
attrname := xmldom.getNodeName(n);
attrval := xmldom.getNodeValue(n);
----dbms_output.put(' ' || attrname || ' = ' || attrval);
END LOOP;
------dbms_output.put_line('');
END IF;
*/
END LOOP;

END printElementAttributes;


procedure write_xml_file (v_domdoc in DBMS_XMLDOM.DOMDocument, v_dir in varchar2, v_file in varchar2 )  is
BEGIN
  --v_domdoc := DBMS_XMLDOM.NewDOMDocument(v_xml);
  DBMS_XMLDOM.WRITETOFILE(v_domdoc, v_dir||'/'||v_file);
  DBMS_XMLDOM.FreeDocument(v_domdoc);
END;

procedure test is
   l_string_request    VARCHAR2 (4000);
   l_http_request UTL_HTTP.req;
   l_response XMLTYPE;
   return_code number;
   return_message varchar2(1000);

   node xmldom.DOMNode;
begin
process_new_info(  l_response, return_code, return_message);
if return_code !=200 then
---nsert into world_check_xml values(1, l_response);
commit;
else
raise_application_error(-20000,'Test '||to_char(return_code)||' '||return_message);
end if;
--write_xml_file (dbms_xmldom.newDOMDocument(l_response), 'SICD', 'content.xml' );
--printElements(dbms_xmldom.newDOMDocument(l_response));
--printElementAttributes(dbms_xmldom.newDOMDocument(l_response),'*');

end;


procedure create_screening(search_name in varchar2, p_request_id out number, p_return_code out number, p_return_message out varchar2 ) is
   l_string_request    VARCHAR2 (4000);
   l_http_request UTL_HTTP.req;
    l_response_xml xmltype;
   l_request_id number:= null;
      return_code number;
   return_message varchar2(1000);
   p_name_identifier varchar2(100);
   user_id number;
   login_id number;
begin
   user_id:= get_userid;
   login_id := get_loginid;
l_string_request :=soap_envelope_start;
l_string_request := l_string_request || soap_header;
l_string_request := l_string_request || world_check_request('cng_so_5412', 'example1a', 'example2', 'cnu_so_19200',search_name, 'INDIVIDUAL');
l_string_request := l_string_request ||soap_envelope_end;
send_request (get_world_check_request_url, l_string_request, l_http_request);
read_response(l_http_request, l_response_xml,return_code,  return_message) ;

p_return_code :=return_code;
p_return_message:=return_message;

if return_code =200 then

SELECT WC_SCREENING_REQUEST_ID_SEQ.NEXTVAL INTO l_request_id FROM dual;
p_request_id:= l_request_id;

select x.name_identifier into p_name_identifier from  dual, xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:screenResponse/return' passing l_response_xml
                                                 columns
                                                  name_identifier varchar2(500) path '.'
                                                 ) x ;

INSERT INTO VSSL.WC_SCREENING_REQUEST (
   WC_SCREENING_REQUEST_ID, NAME_SCREENED,NAME_IDENTIFIER, XML_RESPONSE,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY,
   LAST_UPDATE_DATE, LAST_UPDATE_LOGIN)
VALUES ( p_request_id /* WC_SCREENING_REQUEST_ID */,
 search_name /* NAME_SCREENED */,
 p_name_identifier /* NAME_IDENTIFIER */,
 l_response_xml /* XML_RESPONSE*/,
user_id /* CREATED_BY */,
SYSDATE  /* CREATION_DATE */,
user_id /* LAST_UPDATED_BY */,
SYSDATE /* LAST_UPDATED_DATE */,
login_id /* LAST_UPDATE_LOGIN */ );
COMMIT;
end if;

end;

/* Formatted on 21-Aug-13 7:05:00 PM (QP5 v5.163.1008.3004) */
PROCEDURE process_name_matches (p_name_identifier           IN     VARCHAR2,
                                p_wc_screening_request_id   IN     NUMBER,
                                p_return_code                  OUT NUMBER,
                                p_return_message               OUT VARCHAR2)
IS
   l_string_request   VARCHAR2 (4000);
   l_http_request     UTL_HTTP.req;
   l_response_xml     XMLTYPE;
   l_request_id       NUMBER := NULL;
   return_code        NUMBER := 200;
   return_message     VARCHAR2 (1000);
   user_id            NUMBER;
   login_id           NUMBER;
   errmsg varchar2(200);
   p_match_count      VARCHAR2 (20);
   match_count        NUMBER;
   var_match_id       NUMBER;

   max_hits           NUMBER;
   one                NUMBER;
   incrementor        NUMBER;
BEGIN
   user_id := get_userid;
   login_id := get_loginid;
   max_hits := c_maximum_number_of_hits;
   incrementor := 1000;
   one := 1;
   starting_pos := 0;
   match_count  := c_maximum_number_of_hits;

   dbms_output.put_line('Inside Process Name Matches');

   WHILE starting_pos <= match_count
   LOOP
      prev_starting_pos := starting_pos;
      l_string_request := soap_envelope_start;
      l_string_request := l_string_request || soap_header;
      l_string_request :=
         l_string_request
         || get_name_details (p_name_identifier,
                              'WATCHLIST',
                              TO_CHAR (starting_pos),
                              TO_CHAR (max_hits));
      l_string_request := l_string_request || soap_envelope_end;

      --mt this is the spot

      --dbms_output.put_line('Posting to: '    || get_world_check_name_url);
      --dbms_output.put_line('String Request: '|| l_string_request);
      begin
      send_request (get_world_check_name_url,
                    l_string_request,
                    l_http_request);
      exception when others
      then dbms_output.put_line('SQL Error: '||sqlerrm);
      end;

      begin
      read_response (l_http_request,
                     l_response_xml,
                     return_code,
                     return_message);
       exception when others
      then dbms_output.put_line('SQL Error: '||sqlerrm);
      end;

      dbms_output.put_line('Return Code: '   ||return_code);
      dbms_output.put_line('Return Message: '||return_message);

      p_return_code := return_code;
      p_return_message := return_message;

      IF return_code = 200
      THEN
              --dbms_output.put_line('Get Match Count');      

              SELECT x.match_count
                INTO p_match_count
                FROM DUAL,
                     XMLTABLE (
                        XMLNamespaces (
                           'http://schemas.xmlsoap.org/soap/envelope/' AS "soap",
                           'http://screening.complinet.com/' AS "ns2"),
                        'soap:Envelope/soap:Body/ns2:getMatchesResponse/return/matchCount'
                        PASSING l_response_xml
                        COLUMNS match_count VARCHAR2 (500) PATH '.') x;

         match_count := TO_NUMBER (NVL (p_match_count, '0'));

         BEGIN
            var_match_id := WC_MATCHES_ID_SEQ.NEXTVAL;

            --dbms_output.put_line('Inserting into WC_MATCHES');      

            INSERT INTO VSSL.WC_MATCHES (WC_MATCHES_ID,
                                         WC_SCREENING_REQUEST_ID,
                                         NUMBER_OF_MATCHES,
                                         NAME_IDENTIFIER,
                                         XML_RESPONSE,
                                         CREATION_DATE,
                                         CREATED_BY,
                                         LAST_UPDATE_DATE,
                                         LAST_UPDATED_BY,
                                         LAST_UPDATE_LOGIN)
                 VALUES (
                           var_match_id                    /* WC_MATCHES_ID */
                                       ,
                           p_wc_screening_request_id /* WC_SCREENING_REQUEST_ID */
                                                    ,
                           match_count                  /*NUMBER_OF_MATCHES */
                                      ,
                           p_name_identifier            /* MATCH_IDENTIFIER */
                                            ,
                           l_response_xml                    /* XML_RESPONSE*/
                                         ,
                           SYSDATE                         /* CREATION_DATE */
                                  ,
                           user_id                            /* CREATED_BY */
                                  ,
                           SYSDATE                      /* LAST_UPDATE_DATE */
                                  ,
                           user_id                       /* LAST_UPDATED_BY */
                                  ,
                           login_id                    /* LAST_UPDATE_LOGIN */
                                   );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               BEGIN
                  BEGIN
                     UPDATE WC_MATCHES
                        SET XML_RESPONSE = l_response_xml,
                            NUMBER_OF_MATCHES = match_count
                      WHERE NAME_IDENTIFIER = p_name_identifier;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        raise_application_error (
                           -20001,
                           'process_name_matches update ' || SQLERRM);
                  END;
               END;
            end;
      else
        errmsg:=sqlerrm;
        raise_application_error(-20020, ' process_name_matches = '||TO_CHAR(return_code)||' '||p_return_message||' '||errmsg); -- 07302018 ZK added p_return_message
      END if;

     starting_pos := prev_starting_pos + incrementor;

         COMMIT;
   END loop;
match_count:=c_maximum_number_of_hits;
end;

procedure populate_match_details(p_match_id in number,primary_match_id in number, p_return_code out number, p_return_message out varchar2) is


cursor get_matches(p_match_id in number) is select * from  WC_MATCHES where wc_matches_id=p_match_id;
matches get_matches%rowtype;

cursor get_screening_request(p_screening_request_id in number) is select * from wc_screening_request where wc_screening_request_id=p_screening_request_id;

request_rec get_screening_request%rowtype;

cursor get_match_details(p_match_id in number) is
select x.* from  WC_MATCHES xt, xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getMatchesResponse/return/matches/match' passing xt.xml_response
                                                 columns
                                                  matchEntityIdentifier varchar2(200) path 'matchEntityIdentifier',
                                                  matchFoundBy varchar2(200) path 'matchFoundBy',
                                                  matchIdentifier varchar2(200) path 'matchIdentifier',
                                                  matchResolution varchar2(200) path 'matchResolution',
                                                  matchRisk varchar2(200) path 'matchRisk',
                                                  matchScore varchar2(200) path 'matchScore',
                                                  matchStatus varchar2(200) path 'matchStatus',
                                                  matchType varchar2(200) path 'matchType',
                                                  matchUpdated varchar2(200) path 'matchUpdated'
                                                 ) x
   where WC_MATCHES_ID=p_match_id
   order by X.matchscore desc;

cursor get_sanction (p_xml_var in xmltype) is
select count(*) from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/details/detail' passing p_xml_var
                                                 columns
                                                  title varchar2(200)  path 'title',
                                                  txt clob  path 'text'

                                                 ) x
where instr(x.title,'SANCTION') >0;




cursor get_name(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/names/name' passing p_xml_var
                                                 columns
                                                  fullname varchar2(200)  path 'fullName',
                                                  nametype varchar(200) path '@type',
                                                  givenname varchar2(200)  path 'givenName',
                                                  lastname varchar2(200) path 'lastName'
                                                 ) x ;

cursor get_sex(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/individual' passing p_xml_var
                                                 columns
                                                  sex varchar2(200)  path 'gender',
                                                  age varchar2(200) path 'age',
                                                  as_of varchar2(200) path 'ageAsOfDate'
                                                 ) x ;

cursor get_country(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/countryLinks/countryLink/country' passing p_xml_var
                                                 columns
                                                  name varchar2(200)  path 'name'
                                                 ) x ;
cursor get_category(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/individual' passing p_xml_var
                                                 columns
                                                  category_type varchar2(200)  path 'category'
                                                 ) x ;


cursor get_is_dead(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                   'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/individual' passing p_xml_var
                                                 columns
                                                  isdead varchar2(500)  path 'isDeceased'
                                                 ) x ;

cursor get_birth(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/individual/events/event' passing p_xml_var
                                                 columns
                                                  event_type varchar2(500)  path '@type',
                                                  event_date varchar2(500) path   './fullDate'
                                                 ) x
where x.event_type='BIRTH';

cursor get_addresses(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/addresses/address' passing p_xml_var
                                                 columns
                                                  country varchar2(500)  path 'country/name',
                                                  city    varchar2(500) path 'city',
                                                  street varchar2(500) path 'street'
                                                 ) x ;

cursor get_myanmar(p_xml_var in xmltype) is
select count(*)
from                                           xmltable(XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/countryLinks/countryLink/country' passing p_xml_var
                                                 columns
                                                  name varchar2(200)  path 'name'
                                                 ) x,
                                                 xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/individual' passing p_xml_var
                                                 columns
                                                  category_type varchar2(200)  path 'category'
                                                 ) y
where x.name='MYANMAR' and (y.category_type='MILITARY');

cursor get_myanmar2 (p_xml_var in xmltype)  is
select count(*)
from  xmltable(XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/countryLinks/countryLink/country' passing p_xml_var
                                                 columns
                                                  name varchar2(200)  path 'name'
                                                 ) x,
                                                 xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/names/name' passing p_xml_var
                                                 columns
                                                  fullname varchar2(200)  path 'fullName',
                                                  nametype varchar(200) path '@type',
                                                  givenname varchar2(200)  path 'givenName',
                                                  lastname varchar2(200) path 'lastName'
                                                 ) y
where  x.name='MYANMAR'  and
(instr(upper(y.fullname),'GENERAL',1) >0 or
instr(upper(y.fullname),'ADMIRAL',1) >0 or
instr(upper(y.fullname),'COLONEL',1) >0 or
instr(upper(y.fullname),'MAJOR',1) >0 or
instr(upper(y.fullname),'COMMANDER',1) >0 or
instr(upper(y.fullname),'ENSIGN',1) >0 or
instr(upper(y.fullname),'CAPTAIN',1) >0 or
instr(upper(y.fullname),'LIEUTENANT',1) >0 or
instr(upper(y.fullname),'SERGEANT',1) >0 or
instr(upper(y.fullname),'WARRANT',1) >0 or
instr(upper(y.fullname),'CORPORAL',1) >0 );

  cursor get_military_id_count(p_xml_var in xmltype) is
select count(*)  from
xmltable( XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/countryLinks/countryLink/country' passing p_xml_var
                                                 columns
                                                  name varchar2(200)  path 'name'
                                                 ) x,

 xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/details/detail' passing p_xml_var
                                                 columns
                                                  title varchar2(200)  path 'title',
                                                  txt clob  path 'text'

                                                 ) y
where y.title ='IDENTIFICATION' and  dbms_lob.instr(y.txt,'Military') >0 and
 x.name='MYANMAR';

cursor get_content(p_WC_SCREENING_REQUEST_ID in number,p_MATCHIDENTIFIER in varchar2,p_MATCHENTITYIDENTIFIER in varchar2  ) is
select * from WC_CONTENT where
WC_SCREENING_REQUEST_ID=p_WC_SCREENING_REQUEST_ID and
MATCHIDENTIFIER =p_MATCHIDENTIFIER and
MATCHENTITYIDENTIFIER = p_MATCHENTITYIDENTIFIER;

wc_content_rec get_content%rowtype;


l_response_xml xmltype;
return_code number;
return_message varchar2(1000);
surname varchar2(100);
givenname varchar2(100);

location_msg varchar2(100):='populate_match_details:';
msg varchar2(100);
xmlvar xmltype;
given_name varchar2(100);
last_name varchar2(100);
match_full_name varchar2(200);


sex varchar2(100);
category_name varchar2(200);
p_status varchar2(50);
age varchar2(200);
age_val number;
as_of varchar2(200);
as_of_date date;
approx_birth_date date;
birth_date_str varchar2(20);
error_converting varchar2(1);
event_name varchar2(200);
is_dead varchar2(200);
p_notes varchar2(300):=null;
delimiter varchar2(5):=null;
p_user_clearable varchar2(1) :='Y';
computer_clearable varchar2(1):='Y';

passport_country varchar2(200):=null;
ppc_is_match varchar2(1):='N';
citizenship_country varchar2(200):=null;
cc_is_match varchar2(1):='N';
residence_country varchar2(200):=null;
r_is_match varchar2(1):='N';
corp_residence varchar2(200):=null;
cr_is_match varchar2(1):='N';

address_match varchar2(1):='N';
age_match varchar2(1):='N';
country_match  varchar2(1):='N';
xml_len number;


 P_NM_NAME                  VARCHAR2(1);
 p_NM_DOB_AGE               VARCHAR2(1);
 P_NM_SEX                   VARCHAR2(1);
 p_NM_DEAD                  VARCHAR2(1);
 p_NM_VISUAL                VARCHAR2(1) :='N';
 P_NM_FATHERS_NAME VARCHAR2(1) :='N';
 p_NM_IMO_NUMBER VARCHAR2(1) :='N';
 p_NM_ADDRESS VARCHAR2(1) :='N';
 p_NM_COUNTRY VARCHAR2(1) :='N';
 p_NM_CNNM varchar2(1) :='N';

sanction_title varchar2(200);
sanction_txt clob;
sanction_match varchar2(1):='N';
sanction_count number;


name_count binary_integer;
name_array dbms_utility.lname_array;
name_str varchar2(4000);
name_match varchar2(1):='N';
last_name_max_score BINARY_DOUBLE;
given_name_max_score BINARY_DOUBLE;
score BINARY_DOUBLE;
process_name varchar2(1);

is_myanmar varchar2(1):='N';

user_id number;
login_id number;

sex_matches varchar2(1) :='Y';
updated_by number;

n_of_criteria_that_dont_match number:=0;

counter number:=0;
content_number number:=0;

begin
msg:='Start';

msg:='Get Matches';
--dbms_output.put_line(msg);
----dbms_output.put_line(msg);
--open get_matches(p_match_id);
--fetch get_matches into matches;
--close get_matches;

for matches in  get_matches(p_match_id) loop
--dbms_output.put_line('matches.number_of_matches '||to_char(matches.number_of_matches));

if matches.number_of_matches >0 then

open get_screening_request(matches.WC_SCREENING_REQUEST_ID);
fetch get_screening_request into request_rec;
close get_screening_request;


passport_country:= get_acellus_country_name (request_rec.PASSPORT_ISSUING_COUNTRY_CODE);
citizenship_country:=get_acellus_country_name (request_rec.CITIZENSHIP_COUNTRY_CODE);
residence_country:=get_acellus_country_name (request_rec.residence_country_code);
corp_residence:=get_acellus_country_name (request_rec.CORP_RESIDENCE_COUNTRY_CODE);


msg:='get_contents_details';
content_number:=0;
for det in get_match_details(matches.WC_MATCHES_ID) loop
content_number:=content_number +1;
----dbms_output.put_line('********************************************************************');
----dbms_output.put_line('passport_country '||passport_country);
----dbms_output.put_line('citizenship_country '||citizenship_country);
----dbms_output.put_line('residence_country '||residence_country);

mt_match_counter:=mt_match_counter+1;
/***** Reset Variables for next pass */
user_id:= get_userid;
login_id := get_loginid;
p_user_clearable:='Y';
computer_clearable:='Y';
ppc_is_match:='N';
cc_is_match:='N';
r_is_match:='N';
cr_is_match:='N';
name_match:='Y';
birth_date_str:=null;
sex_matches:='Y';
is_myanmar :='N';

 P_NM_NAME:='N';
 p_NM_DOB_AGE:='N';
 P_NM_SEX:='N';
 p_NM_DEAD:='N';
 p_NM_VISUAL:='N';

address_match:='Y';
age_match:='Y';
country_match:='Y';
p_notes:=null;
delimiter:=' ';
p_status:=c_initial_screen;

n_of_criteria_that_dont_match:=0;

sanction_count :=0;
/***********************************/

----dbms_output.put_line('**'||msg||'**');
begin
l_response_xml:=null;

get_contents_details(det.MATCHIDENTIFIER, l_response_xml, return_code, return_message );

if  l_response_xml is null then
--dbms_output.put_line('l_response_xml is null');
  INSERT INTO VSSL.WORLD_CHECK_COMM_ERROR_LOG (
   ERROR_LOG_ID, MATCH_IDENTIFIER, WEBSERVICE_IDENTIFIER,
   ERROR_DATE_TIME, ERROR_CODE, ERROR_MESSAGE)
VALUES ( null /* ERROR_LOG_ID */,
 'Match_identifier: '||det.MATCHIDENTIFIER||' matchEntityIdentifier:  '||det.matchEntityIdentifier /* MATCH_IDENTIFIER */,
 'Initial Query - Null Response '||to_char(content_number)||' of '||to_char(matches.number_of_matches)  /* WEBSERVICE_IDENTIFIER */,
 sysdate /* ERROR_DATE_TIME */,
 return_code /* ERROR_CODE */,
 return_message /* ERROR_MESSAGE */ );
 commit;
 raise_application_error(-20003,'Did not populate l_response_xml variable');
 end if;


EXCEPTION WHEN OTHERS THEN
----dbms_output.put_line(upper('Error reading details' ));
----dbms_output.put_line(upper(return_message));

return_message:=sqlerrm;

INSERT INTO VSSL.WORLD_CHECK_COMM_ERROR_LOG (ERROR_LOG_ID,
                                             MATCH_IDENTIFIER,
                                             WEBSERVICE_IDENTIFIER,
                                             ERROR_DATE_TIME,
                                             ERROR_CODE,
                                             ERROR_MESSAGE)
     VALUES (NULL                                           /* ERROR_LOG_ID */
                 ,
              'Match_identifier: '||det.MATCHIDENTIFIER||' matchEntityIdentifier:  '||det.matchEntityIdentifier /* MATCH_IDENTIFIER */,

             'Initial Query - Null Response / Exception Handler ' /* WEBSERVICE_IDENTIFIER */,

             SYSDATE                                     /* ERROR_DATE_TIME */
                    ,
             return_code                                      /* ERROR_CODE */
                        ,
             return_message                                /* ERROR_MESSAGE */
                           );

COMMIT;

 /* there is a failure reading the contents so let's try it again */
 counter:=1;
 return_code := -99;
 WHILE counter < 7 AND return_code != 200   LOOP

 DBMS_LOCK.sleep( 2 );

INSERT INTO VSSL.WORLD_CHECK_COMM_ERROR_LOG (ERROR_LOG_ID,
                                             MATCH_IDENTIFIER,
                                             WEBSERVICE_IDENTIFIER,
                                             ERROR_DATE_TIME,
                                             ERROR_CODE,
                                             ERROR_MESSAGE)
     VALUES (NULL                                           /* ERROR_LOG_ID */
                 ,
              'Match_identifier: '||det.MATCHIDENTIFIER||' matchEntityIdentifier:  '||det.matchEntityIdentifier /* MATCH_IDENTIFIER */,

             'Exception Handler Start of Loop - pass number: ' ||to_char(counter)                        /* WEBSERVICE_IDENTIFIER */
                      ,
             SYSDATE                                     /* ERROR_DATE_TIME */
                    ,
             return_code                                      /* ERROR_CODE */
                        ,
             return_message                                /* ERROR_MESSAGE */
                           );

COMMIT;
l_response_xml:=null;
  return_code:=NULL;
  return_message :=NULL;

BEGIN
   get_contents_details (det.MATCHIDENTIFIER, l_response_xml, return_code, return_message);
EXCEPTION
   WHEN OTHERS
   THEN
      INSERT INTO VSSL.WORLD_CHECK_COMM_ERROR_LOG (ERROR_LOG_ID,
                                                   MATCH_IDENTIFIER,
                                                   WEBSERVICE_IDENTIFIER,
                                                   ERROR_DATE_TIME,
                                                   ERROR_CODE,
                                                   ERROR_MESSAGE)
           VALUES (NULL                                     /* ERROR_LOG_ID */
                       ,
                    'Match_identifier: '||det.MATCHIDENTIFIER||' matchEntityIdentifier:  '||det.matchEntityIdentifier /* MATCH_IDENTIFIER */,

                     'Exception Handler Loop - When OTHERS - pass number: ' ||to_char(  counter)                        /* WEBSERVICE_IDENTIFIER */
                            ,
                   SYSDATE                               /* ERROR_DATE_TIME */
                          ,
                   return_code                                /* ERROR_CODE */
                              ,
                   return_message                          /* ERROR_MESSAGE */
                                 );

      COMMIT;

END;

if l_response_xml is not null then
begin
xml_len:=dbms_lob.getlength(xmltype.getclobval(l_response_xml));
exception when others
then
xml_len:=0;
end;
else
xml_len:=0;
end if;

 INSERT INTO VSSL.WORLD_CHECK_COMM_ERROR_LOG (ERROR_LOG_ID,
                                                   MATCH_IDENTIFIER,
                                                   WEBSERVICE_IDENTIFIER,
                                                   ERROR_DATE_TIME,
                                                   ERROR_CODE,
                                                   ERROR_MESSAGE)
           VALUES (NULL                                     /* ERROR_LOG_ID */
                       ,
                    'Match_identifier: '||det.MATCHIDENTIFIER||' matchEntityIdentifier:  '||det.matchEntityIdentifier /* MATCH_IDENTIFIER */,

                     'Exception Handler Loop - No Exception - pass number: ' ||to_char(  counter) ||' Returned Length :'||to_char(xml_len)||' Return Code: '||to_char(return_code)                          /* WEBSERVICE_IDENTIFIER */
                            ,
                   SYSDATE                               /* ERROR_DATE_TIME */
                          ,
                   return_code                                /* ERROR_CODE */
                              ,
                   return_message                          /* ERROR_MESSAGE */
                                 );

      COMMIT;

  if l_response_xml is null and return_code = 200 then
  /* if it returned no details but did not generate an error then have it loop again */
  return_code := -99;
   INSERT INTO VSSL.WORLD_CHECK_COMM_ERROR_LOG (ERROR_LOG_ID,
                                                   MATCH_IDENTIFIER,
                                                   WEBSERVICE_IDENTIFIER,
                                                   ERROR_DATE_TIME,
                                                   ERROR_CODE,
                                                   ERROR_MESSAGE )

           VALUES (NULL                                     /* ERROR_LOG_ID */
                       ,
                    'Match_identifier: '||det.MATCHIDENTIFIER||' matchEntityIdentifier:  '||det.matchEntityIdentifier /* MATCH_IDENTIFIER */,

                   'Exception Handler Loop - pass number: ' || to_char(  counter)  ||' Returned null value  Length :'||to_char(xml_len)||' Return Code: '||to_char(return_code)               /* WEBSERVICE_IDENTIFIER */
                            ,
                   SYSDATE                               /* ERROR_DATE_TIME */
                          ,
                   return_code                                /* ERROR_CODE */
                              ,
                   return_message                          /* ERROR_MESSAGE */

                                 );

      COMMIT;
elsif l_response_xml is null and return_code != 200 then
     return_code := -99;
    INSERT INTO VSSL.WORLD_CHECK_COMM_ERROR_LOG (ERROR_LOG_ID,
                                                   MATCH_IDENTIFIER,
                                                   WEBSERVICE_IDENTIFIER,
                                                   ERROR_DATE_TIME,
                                                   ERROR_CODE,
                                                   ERROR_MESSAGE,
                                                   XML_RESPONSE )
           VALUES (NULL                                     /* ERROR_LOG_ID */
                       ,
                    'Match_identifier: '||det.MATCHIDENTIFIER||' matchEntityIdentifier:  '||det.matchEntityIdentifier /* MATCH_IDENTIFIER */,

                   'Exception Handler Loop - pass number: ' || to_char(  counter)  ||' Returned null value  Length :'||to_char(xml_len)||' Return Code: '||to_char(return_code)
                            ,
                   SYSDATE                               /* ERROR_DATE_TIME */
                          ,
                   return_code                                /* ERROR_CODE */
                              ,
                   return_message                          /* ERROR_MESSAGE */
                                      ,
                   l_response_xml
                                 );

      COMMIT;
elsif l_response_xml is not null then
    INSERT INTO VSSL.WORLD_CHECK_COMM_ERROR_LOG (ERROR_LOG_ID,
                                                   MATCH_IDENTIFIER,
                                                   WEBSERVICE_IDENTIFIER,
                                                   ERROR_DATE_TIME,
                                                   ERROR_CODE,
                                                   ERROR_MESSAGE,
                                                   XML_RESPONSE )
           VALUES (NULL                                     /* ERROR_LOG_ID */
                       ,
                    'Match_identifier: '||det.MATCHIDENTIFIER||' matchEntityIdentifier:  '||det.matchEntityIdentifier /* MATCH_IDENTIFIER */,

                   'Exception Handler Loop - pass number: ' ||to_char(  counter)  ||' Returned a value  Length :'||to_char(xml_len)                    /* WEBSERVICE_IDENTIFIER */
                            ,
                   SYSDATE                               /* ERROR_DATE_TIME */
                          ,
                   return_code                                /* ERROR_CODE */
                              ,
                   return_message                          /* ERROR_MESSAGE */
                                      ,
                   l_response_xml
                                 );

      COMMIT;
else
      return_code := -99;
      l_response_xml:=null;
    INSERT INTO VSSL.WORLD_CHECK_COMM_ERROR_LOG (ERROR_LOG_ID,
                                                   MATCH_IDENTIFIER,
                                                   WEBSERVICE_IDENTIFIER,
                                                   ERROR_DATE_TIME,
                                                   ERROR_CODE,
                                                   ERROR_MESSAGE,
                                                   XML_RESPONSE )
           VALUES (NULL                                     /* ERROR_LOG_ID */
                       ,
                    'Match_identifier: '||det.MATCHIDENTIFIER||' matchEntityIdentifier:  '||det.matchEntityIdentifier /* MATCH_IDENTIFIER */,

                    'Exception Handler Loop - pass number: ' ||to_char(  counter)  ||' dropped to default else clause  Length :'||to_char(xml_len)                 /* WEBSERVICE_IDENTIFIER */
                            ,
                   SYSDATE                               /* ERROR_DATE_TIME */
                          ,
                   return_code                                /* ERROR_CODE */
                              ,
                   return_message                          /* ERROR_MESSAGE */
                                      ,
                   l_response_xml
                                 );

      COMMIT;
  end if;

  counter:=counter + 1;

 END LOOP;

END;



----dbms_output.put_line('**'||msg||'**');
if return_code != 200 then
  INSERT INTO VSSL.WORLD_CHECK_COMM_ERROR_LOG (
   ERROR_LOG_ID, MATCH_IDENTIFIER, WEBSERVICE_IDENTIFIER,
   ERROR_DATE_TIME, ERROR_CODE, ERROR_MESSAGE)
VALUES ( null /* ERROR_LOG_ID */,
 det.MATCHIDENTIFIER /* MATCH_IDENTIFIER */,
 'Content' /* WEBSERVICE_IDENTIFIER */,
 sysdate /* ERROR_DATE_TIME */,
 return_code /* ERROR_CODE */,
 return_message /* ERROR_MESSAGE */ );
 commit;
 l_response_xml:=null;
 raise_application_error(-20001,'populate_match_details-Get Contents_Detail '|| return_message);
end if;


sanction_match:='N';
sanction_count:=0;
open get_sanction(l_response_xml);
fetch get_sanction into sanction_count;
close get_sanction;

for a in get_category(l_response_xml) loop
----dbms_output.put_line(upper(a.category_type));

if upper(a.category_type) ='TERRORISM'  and (p_user_clearable='Y' or computer_clearable='Y')
then
p_user_clearable:='N';
computer_clearable:='N';
elsif upper(a.category_type) ='BLACKLISTED'  and (p_user_clearable='Y' or computer_clearable='Y')
then
p_user_clearable:='Y';
computer_clearable:='Y';
--- Added By Gopi Vella For T20190730.0031 
elsif upper(a.category_type) ='CRIME - TERROR'  and (p_user_clearable='Y' or computer_clearable='Y')
then
p_user_clearable:='N';
computer_clearable:='N';
--- End Code Change

--- Added By Zakia Khan  T20190805.0014
ELSIF UPPER(a.category_type) = 'NONCONVICTION TERROR'  AND (p_user_clearable='Y' OR computer_clearable='Y')
THEN
    p_user_clearable:='N';
    computer_clearable:='N';
--- End Code Change

elsif upper(a.category_type) ='CRIME - FINANCIAL'  and (p_user_clearable='Y' or computer_clearable='Y')
then
p_user_clearable:='Y';
computer_clearable:='M';
elsif upper(a.category_type) ='CRIME - NARCOTICS'  and (p_user_clearable='Y' or computer_clearable='Y')
then
p_user_clearable:='Y';
computer_clearable:='M';
elsif upper(a.category_type) ='CRIME - ORGANIZED' and (p_user_clearable='Y' or computer_clearable='Y')
then
p_user_clearable:='Y';
computer_clearable:='Y';
elsif upper(a.category_type) ='CRIME - OTHER' and (p_user_clearable='Y' or computer_clearable='Y')
then
p_user_clearable:='Y';
computer_clearable:='Y';
elsif upper(a.category_type) ='CRIME - WAR'  and (p_user_clearable='Y' or computer_clearable='Y')
then
p_user_clearable:='Y';
computer_clearable:='Y';
elsif upper(a.category_type) ='MILITARY' and (p_user_clearable='Y' and computer_clearable='Y')
then
p_user_clearable:='Y';
computer_clearable:='Y';
elsif upper(a.category_type) ='POLITICAL INDIVIDUAL'  and (p_user_clearable='Y' and computer_clearable='Y')
then
p_user_clearable:='Y';
computer_clearable:='Y';
else
p_user_clearable:='Y';
computer_clearable:='Y';
end if;


end loop;

/* check sanctions after category they may be sanctioned but not in a prohibited category */

if nvl(sanction_count,0) > 0 then
sanction_match:='Y';
p_user_clearable:='N';
computer_clearable:='N';
end if;

sanction_count:=0;

open get_myanmar(l_response_xml);
fetch get_myanmar into sanction_count;
close get_myanmar;

if sanction_count > 0 then
sanction_match:='Y';
p_user_clearable:='N';
computer_clearable:='N';
is_myanmar :='Y';
end if;

sanction_count:=0;
open get_myanmar2(l_response_xml);
fetch get_myanmar2 into sanction_count;
close get_myanmar2;

if sanction_count > 0 then
sanction_match:='Y';
p_user_clearable:='N';
computer_clearable:='N';
is_myanmar :='Y';
end if;

open get_military_id_count(l_response_xml);
fetch get_military_id_count into sanction_count;
close get_military_id_count;

if sanction_count > 0 then
sanction_match:='Y';
p_user_clearable:='N';
computer_clearable:='N';
is_myanmar :='Y';
end if;

msg:='get_name';



name_match:='N';
for abc in get_name(l_response_xml) loop
match_full_name:=upper(abc.fullname);

if is_myanmar = 'Y' then
match_full_name := REPLACE(upper(match_full_name),'U -',''); /* if they are Myanmar the get rid of the opening U - it basically means Mr. */
end if;
----dbms_output.put_line(abc.nametype||' '||abc.fullname);

if abc.nametype='PRIMARY' then
last_name := substr(abc.lastname,1,100);
given_name := substr(abc.givenname,1,100);
if given_name ='-' then given_name:=null; end if;
if last_name ='-' then last_name:=null; end if;

----dbms_output.put_line(abc.nametype||' '||abc.lastname||' '||abc.givenname);
end if;

name_str:= replace(request_rec.name_screened,'-',','); --get rid of dashes
name_str:=replace(name_str,'.',' '); --get rid of periods
name_str:= rtrim(ltrim(name_str)); --get rid of leading and trailing spaces


match_full_name:= replace(match_full_name,'-',' '); --get rid of dashes
match_full_name:=replace(match_full_name,'.',' '); --get rid of periods
match_full_name:= rtrim(ltrim(match_full_name)); --get rid of leading and trailing spaces

----dbms_output.put_line('name_match '||name_match);
----dbms_output.put_line('name_str '||name_str);
----dbms_output.put_line('match_full_name '||match_full_name);

if PKG_STRING_UTILS.strings_equavalent(name_str, match_full_name,'SUBSTR',0.80, score) ='Y'  and name_match ='N' then
name_match:='Y';
end if;
----dbms_output.put_line('name_match '||name_match);
end loop;
----dbms_output.put_line('name_match '||name_match);
if name_match ='N' then
 P_NM_NAME:='Y'; /* namd is not a match*/
n_of_criteria_that_dont_match:=n_of_criteria_that_dont_match+1;
end if;




msg:='get_country';
for abc in get_country(l_response_xml) loop
----dbms_output.put_line('Get Country: '||abc.name);
if abc.name is not null then
if upper(nvl(passport_country,abc.name))=upper(abc.name) then
ppc_is_match:='Y';
end if;
if upper(nvl(citizenship_country,abc.name))=upper(abc.name) then
cc_is_match :='Y';
end if;
if upper(nvl(residence_country,abc.name))=upper(abc.name) then
r_is_match:='Y';
end if;
if upper(nvl(corp_residence,abc.name) )=upper(abc.name) then
cr_is_match:='Y';
end if;
end if;
end loop;

if request_rec.entity_type=c_INDIVIDUAL  then
if ppc_is_match='N' and cc_is_match='N' and r_is_match='N' then
 p_NM_COUNTRY:='Y';
country_match :='N';
n_of_criteria_that_dont_match:=n_of_criteria_that_dont_match+1;
end if;
elsif request_rec.entity_type=c_CORPORATION then
if cr_is_match = 'N' then
 p_NM_COUNTRY:='Y';
country_match :='N';
n_of_criteria_that_dont_match:=n_of_criteria_that_dont_match+1;
end if;
end if;


ppc_is_match:='N';
cc_is_match:='N';
r_is_match:='N';
cr_is_match:='N';

msg:='get_addresses';

FOR abc IN get_addresses(l_response_xml) LOOP

IF abc.country IS NOT NULL THEN
IF UPPER(NVL(passport_country,abc.country))=UPPER(abc.country) THEN
ppc_is_match:='Y';
END IF;
IF UPPER(NVL(citizenship_country,abc.country))=UPPER(abc.country) THEN
cc_is_match :='Y';
END IF;
IF UPPER(NVL(residence_country,abc.country))=UPPER(abc.country) THEN
r_is_match:='Y';
END IF;

IF UPPER(NVL(corp_residence,abc.country) )=UPPER(abc.country) THEN
cr_is_match:='Y';
END IF;
END IF;
END LOOP;

if request_rec.entity_type=c_INDIVIDUAL then
if ppc_is_match='N' and cc_is_match='N' and r_is_match='N' then

p_NM_ADDRESS:='Y';
address_match :='N';
n_of_criteria_that_dont_match:=n_of_criteria_that_dont_match+1;
end if;
elsif request_rec.entity_type=c_CORPORATION  then
if cr_is_match='N' then
p_NM_ADDRESS:='Y';
address_match :='N';
n_of_criteria_that_dont_match:=n_of_criteria_that_dont_match+1;
end if;
end if;


msg:=' get_is_dead';
open  get_is_dead(l_response_xml);
fetch get_is_dead into is_dead;
close get_is_dead;

if upper(is_dead) = 'DECEASED' or upper(is_dead) = 'TRUE' then
p_NM_DEAD:='Y';
is_dead :='Y';
n_of_criteria_that_dont_match:=3;
else
is_dead :='N';
end if;

sex:=null;
age:=null;
as_of:=null;


msg:=' get_sex ';
open  get_sex(l_response_xml);
fetch get_sex into sex,age,as_of;
close get_sex;

if nvl(upper(sex),'UNKNOWN') != 'UNKNOWN' then
if nvl(upper(request_rec.sex),'XX') in ('MALE','FEMALE') then
if (upper(sex) != upper(request_rec.sex)) then
 P_NM_SEX:='Y';
sex_matches:='N';
n_of_criteria_that_dont_match:=3;
else
sex_matches:='Y';
end if;
else
sex_matches:='Y';
end if;
else
sex_matches:='Y';
end if;

msg:=' calc_age';

if request_rec.DATE_OF_BIRTH is not null then

open get_birth(l_response_xml);
fetch  get_birth into event_name ,  birth_date_str;
close  get_birth;

error_converting:='N';

if birth_date_str is not null then
begin
approx_birth_date:=to_date(birth_date_str,'RRRR-MM-DD');
exception
when others then
 begin  /* sometimes they only give the year so let's assume Jan-1 as the day */
 birth_date_str:=substr(birth_date_str,1,4);
 approx_birth_date:=to_date(birth_date_str||'-01-01','RRRR-MM-DD');
 exception when others then
  error_converting:='Y';
 end;
end;
if error_converting = 'N' then
if abs(request_rec.DATE_OF_BIRTH-approx_birth_date) > 730 then  /* if age  difference > 2 years */
p_NM_DOB_AGE:='Y';
age_match:='N';
n_of_criteria_that_dont_match:=3;
end if;
end if;
elsif (age is not null) and (as_of is not null) and (request_rec.DATE_OF_BIRTH is not null) then
age_val:=to_number(age);
begin
as_of_date:=to_date(substr(as_of,1,instr(as_of,'T','1')-1),'RRRR-MM-DD');
exception
when others then
error_converting:='Y';
end;

if error_converting = 'N' then
approx_birth_date:=add_months(as_of_date,age_val * -12);
if abs(request_rec.DATE_OF_BIRTH-approx_birth_date) > 730 then  /* if age  difference > 2 years */
age_match:='N';
p_NM_DOB_AGE:='Y';
n_of_criteria_that_dont_match:=3;
end if;
end if;
end if;

end if;

/* process name */


/* automatic clearance */
--p_notes:=p_notes||delimiter||'comp='||computer_clearable||'- sex= '||sex_matches||'- dead='||is_dead||'- addr='||address_match||'- age='||age_match||'- cty='||country_match||'- nme='||name_match;
--p_notes:=p_notes||delimiter||'comp='||computer_clearable||' n='||to_char(n_of_criteria_that_dont_match);

IF computer_clearable='Y' or (computer_clearable='M' and n_of_criteria_that_dont_match>2 )  THEN

if n_of_criteria_that_dont_match>2 then
        p_status:=c_false_match;
        user_id:=c_automatic_approval_UID;
elsIF is_dead ='Y' THEN
        p_status:=c_false_match;
        user_id:=c_automatic_approval_UID;
ELSIF  sex_matches='N' THEN
        p_status:=c_false_match;
        user_id:=c_automatic_approval_UID;
ELSIF  age_match = 'N' THEN
        p_status:=c_false_match;
        user_id:=c_automatic_approval_UID;
ELSIF name_match ='N' THEN
        p_status:=c_false_match;
        user_id:=c_automatic_approval_UID;
ELSIF (address_match = 'N' AND
     country_match = 'N') THEN
        p_status:=c_initial_screen;
        user_id:=c_automatic_approval_UID;
ELSE
        p_status:=c_initial_screen;
        user_id:=c_automatic_approval_UID;
    END IF;
ELSE
    p_status:=c_initial_screen;
END IF;

if (p_status=c_false_match) and (p_notes is null) then
p_notes:='sex= '||sex_matches||'- dead='||is_dead||'- addr='||address_match||'- age='||age_match||'- cty='||country_match||'- nme='||name_match;
end if;


if det.MATCHSTATUS is null then
 p_status := c_unspecified;
end if;


p_notes:=world_check_iface.build_comment(P_NM_NAME, p_NM_DOB_AGE, P_NM_SEX ,p_NM_DEAD,p_NM_VISUAL,p_NM_ADDRESS, p_NM_COUNTRY,P_NM_CNNM);

--p_notes:= null;  /* notes is now for typed comments only */

msg:='insert into WC_CONTENT';
begin

----dbms_output.put_line('Insert');
INSERT INTO VSSL.WC_CONTENT (
   WC_CONTENT_ID, WC_MATCHES_ID, XML_RESPONSE,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY,
   LAST_UPDATE_DATE, LAST_UPDATE_LOGIN, MATCHENTITYIDENTIFIER,
   MATCHIDENTIFIER, MATCHSCORE, MATCHSTATUS,
   MATCHTYPE,surname,given_name, sex,notes,user_clearable ,WC_SCREENING_REQUEST_ID,NM_NAME,
   NM_DOB_AGE, NM_SEX, NM_DEAD,
   NM_VISUAL, NM_FATHER_NAME, NM_IMO_NUMBER, NM_CNNM)
VALUES ( null /* WC_CONTENT_ID */,
primary_match_id /* WC_MATCHES_ID */,
 l_response_xml /*XML_RESPONSE*/,
 user_id /* CREATED_BY */,
sysdate  /* CREATION_DATE */,
 user_id /* LAST_UPDATED_BY */,
sysdate  /* LAST_UPDATE_DATE */,
login_id  /* LAST_UPDATE_LOGIN */,
det.MATCHENTITYIDENTIFIER  /* MATCHENTITYIDENTIFIER */,
det.MATCHIDENTIFIER  /* MATCHIDENTIFIER */,
det.MATCHSCORE  /* MATCHSCORE */,
p_status, --det.MATCHSTATUS  /* MATCHSTATUS */,
det.MATCHTYPE/* MATCHSTATUS  */ ,
last_name,
given_name,
sex,
p_notes,
p_user_clearable,
matches.WC_SCREENING_REQUEST_ID,p_NM_NAME,
   p_NM_DOB_AGE, p_NM_SEX, p_NM_DEAD,
   p_NM_VISUAL, P_NM_FATHERS_NAME,p_NM_IMO_NUMBER,P_NM_CNNM);

exception
when DUP_VAL_ON_INDEX then
----dbms_output.put_line('Dup val on index');
open get_content(matches.WC_SCREENING_REQUEST_ID,det.MATCHIDENTIFIER, det.MATCHENTITYIDENTIFIER);
fetch get_content into wc_content_rec;
close get_content;

if wc_content_rec.matchstatus in (c_initial_screen,c_new) then

if wc_content_rec.NOTES is null then
p_notes:=world_check_iface.build_comment(P_NM_NAME, p_NM_DOB_AGE, P_NM_SEX ,p_NM_DEAD,p_NM_VISUAL,p_NM_ADDRESS, p_NM_COUNTRY,P_NM_CNNM);


else
p_notes:= wc_content_rec.NOTES ;  /* don't overwrite the notes */
end if;



----dbms_output.put_line('Update: '||wc_content_rec.given_name||' '||wc_content_rec.SURNAME||' '||given_name||' '||last_name);
update  VSSL.WC_CONTENT
set XML_RESPONSE= l_response_xml,
WC_MATCHES_ID=primary_match_id,
MATCHSTATUS=p_status,
NOTES = p_notes,
given_name = nvl(wc_content_rec.given_name,given_name),
SURNAME= nvl(wc_content_rec.SURNAME,last_name),
LAST_UPDATED_BY=c_automatic_approval_UID,
last_update_date = sysdate,
user_clearable = p_user_clearable,
       NM_NAME                 = p_NM_NAME,
       NM_DOB_AGE              = p_NM_DOB_AGE,
       NM_SEX                  = p_NM_SEX,
       NM_DEAD                 = p_NM_DEAD,
       NM_VISUAL               = p_NM_VISUAL,
       NM_FATHER_NAME = P_NM_FATHERS_NAME,
       NM_IMO_NUMBER = p_NM_IMO_NUMBER,
       NM_CNNM = P_NM_CNNM
where WC_CONTENT_ID=wc_content_rec.WC_CONTENT_ID;


if p_status is null then
raise_application_error(-20001,'Populate match details - Update - Status is null');
end if;

if wc_content_rec.WC_CONTENT_ID is null then
raise_application_error(-20001,'Populate match details - Update - WC_CONTENT_ID is null');
end if;

else

----dbms_output.put_line(to_char(wc_content_rec.WC_CONTENT_ID)||' '||wc_content_rec.SURNAME||' ' ||wc_content_rec.given_name||' '||nvl(p_status,'Status is blank')||' '||nvl(p_notes,'Notes are blank'));
----dbms_output.put_line(to_char(wc_content_rec.WC_CONTENT_ID)||' '||last_name||' ' ||given_name||' '||nvl(p_status,'Status is blank')||' '||nvl(p_notes,'Notes are blank'));
----dbms_output.put_line('comp='||computer_clearable||'- sex= '||sex_matches||'- dead='||is_dead||'- addr='||address_match||'- age='||age_match||'- cty='||country_match||'- nme='||name_match);
----dbms_output.put_line('process_name '||process_name);


----dbms_output.put_line('primary_match_id = '||to_char(primary_match_id)||'  '||'WC_CONTENT_ID ='||to_char(wc_content_rec.WC_CONTENT_ID)||' p_match_id='||to_char(p_match_id)||'wc_content_rec.WC_MATCHES_ID ='||to_char(wc_content_rec.WC_MATCHES_ID));
update  VSSL.WC_CONTENT
set XML_RESPONSE= l_response_xml,
WC_MATCHES_ID=primary_match_id,
--given_name = nvl(wc_content_rec.given_name,given_name),
--SURNAME= nvl(wc_content_rec.SURNAME,last_name),
--LAST_UPDATED_BY=c_automatic_approval_UID,
--last_update_date = sysdate,
--user_clearable = p_user_clearable
       NM_NAME                 = p_NM_NAME,
       NM_DOB_AGE              = p_NM_DOB_AGE,
       NM_SEX                  = p_NM_SEX,
       NM_DEAD                 = p_NM_DEAD,
       NM_VISUAL               = p_NM_VISUAL,
       NM_FATHER_NAME = P_NM_FATHERS_NAME,
       NM_IMO_NUMBER = p_NM_IMO_NUMBER,
       NM_CNNM = P_NM_CNNM
where WC_CONTENT_ID=wc_content_rec.WC_CONTENT_ID;

end if;
--and
--MATCHIDENTIFIER =det.MATCHIDENTIFIER and
--MATCHENTITYIDENTIFIER = det.MATCHENTITYIDENTIFIER;
------dbms_output.put_line('Exception - Duplicate val on index '||sqlerrm);
commit;


when others then
raise_application_error(-20001,sqlerrm||location_msg||msg);
end;
commit;
msg:='***';
end loop;

end if;
end loop;

p_return_code:=return_code;
p_return_message:=return_message;
msg:='End populate_match_details';
exception when others then
raise_application_error(-20001,sqlerrm||location_msg||msg);
end;


procedure get_contents_summary(p_match_identifier in varchar2, p_result_xml out xmltype, p_return_code out number, p_return_message out varchar2) is
   l_string_request    VARCHAR2 (4000);
   l_http_request UTL_HTTP.req;
    l_response_xml xmltype;
   l_request_id number:= null;
      return_code number;
   return_message varchar2(1000);
   p_name_identifier varchar2(100);
   user_id number;
   login_id number;
begin
   user_id:= get_userid;
   login_id := get_loginid;
l_string_request :=soap_envelope_start;
l_string_request := l_string_request || soap_header;
l_string_request := l_string_request || get_content_summary(p_match_identifier );
l_string_request := l_string_request ||soap_envelope_end;
send_request ( get_world_check_content_url , l_string_request, l_http_request);
read_response(l_http_request, l_response_xml,return_code,  return_message) ;

p_return_code :=return_code;
p_return_message:=return_message;

if return_code =200 then
p_result_xml:= l_response_xml;
end if;
end;

procedure get_contents_details(p_match_identifier in varchar2, p_result_xml out xmltype, p_return_code out number, p_return_message out varchar2) is
   l_string_request    VARCHAR2 (4000);
   l_http_request UTL_HTTP.req;
    l_response_xml xmltype;
   l_request_id number:= null;
      return_code number;
   return_message varchar2(1000);
   p_name_identifier varchar2(100);
   user_id number;
   login_id number;
begin
   user_id:= get_userid;
   login_id := get_loginid;
l_string_request :=soap_envelope_start;
l_string_request := l_string_request || soap_header;
l_string_request := l_string_request || get_content_details(p_match_identifier );
l_string_request := l_string_request ||soap_envelope_end;
----dbms_output.put_line('**send**');
send_request ( get_world_check_content_url , l_string_request, l_http_request);
----dbms_output.put_line('**read**');
read_response(l_http_request, l_response_xml,return_code,  return_message) ;
----dbms_output.put_line('**after read '||to_char(p_return_code)||'**');
p_return_code :=return_code;
p_return_message:=return_message;

if return_code =200 then
p_result_xml:= l_response_xml;
--else
--raise_application_error(-20021,' get_contents_details = '||to_char(return_code));
end if;
--exception when others then
--raise_application_error(-20021,' get_contents_details = '||to_char(return_code)||' '||sqlerrm);
end;


PROCEDURE approve_screening_request (
   p_wc_screening_request_id   IN       NUMBER,
   p_return_code               OUT      NUMBER,
   p_return_message            OUT      VARCHAR2
)
IS
   v_sql             VARCHAR2 (2000)       := NULL;

   CURSOR get_vetting
   IS
      SELECT *
        FROM wc_screening_request
       WHERE wc_screening_request_id = p_wc_screening_request_id;

   vet_rec           get_vetting%ROWTYPE;
   sanction_status   VARCHAR2 (30);
   auto_approve      BOOLEAN               := TRUE;

   --SAURABH 18-SEP-2019 T20190912.0051
   l_user_id         NUMBER                := fnd_profile.VALUE ('USER_ID');

BEGIN
   OPEN get_vetting;

   FETCH get_vetting
    INTO vet_rec;

   CLOSE get_vetting;

   sanction_status :=
      world_check_iface.get_sanction_status
                                       (vet_rec.passport_issuing_country_code);

----dbms_output.put_line('Passport '||sanction_status);
   IF sanction_status IN ('PROHIBITED')
   THEN
      auto_approve := FALSE;
   END IF;

   sanction_status :=
      world_check_iface.get_sanction_status (vet_rec.citizenship_country_code);

----dbms_output.put_line('Citizenship '||sanction_status);
   IF sanction_status IN ('PROHIBITED')
   THEN
      auto_approve := FALSE;
   END IF;

   sanction_status :=
        world_check_iface.get_sanction_status (vet_rec.residence_country_code);

----dbms_output.put_line('Residence '||sanction_status);
   IF sanction_status IN ('PROHIBITED')
   THEN
      auto_approve := FALSE;
   END IF;

/*
if auto_approve = TRUE  then
--dbms_output.put_line('Auto Approve is TRUE');
else
--dbms_output.put_line('Auto Approve is FALSE');
end if;
*/
   sanction_status :=
      world_check_iface.get_sanction_status
                                        (vet_rec.passport_issuing_country_code);

   IF     sanction_status IN ('CONDITIONAL')
      AND get_city_tc_status (vet_rec.wc_city_list_id) IN
                                              ('TC_VERIFY', 'TC_PROVISIONAL')
   THEN
      auto_approve := FALSE;
   END IF;

   sanction_status :=
      world_check_iface.get_sanction_status (vet_rec.citizenship_country_code);

   IF     sanction_status IN ('CONDITIONAL')
      AND get_city_tc_status (vet_rec.wc_city_list_id) IN
                                              ('TC_VERIFY', 'TC_PROVISIONAL')
   THEN
      auto_approve := FALSE;
   END IF;

   sanction_status :=
        world_check_iface.get_sanction_status (vet_rec.residence_country_code);

   IF     sanction_status IN ('CONDITIONAL')
      AND get_city_tc_status (vet_rec.wc_city_list_id) IN
                                              ('TC_VERIFY', 'TC_PROVISIONAL')
   THEN
      auto_approve := FALSE;
   END IF;

----dbms_output.put_line ( 'approve_screening_request start');
   IF auto_approve = TRUE
   THEN
----dbms_output.put_line('SAVE IT');
      p_return_code := 200;
      p_return_message := 'Normal';

--SAURABH 18-SEP-2019 T20190912.0051

      --v_sql:= 'UPDATE VSSL.WC_SCREENING_REQUEST
--SET    STATUS = :1,
--       STATUS_UPDATED_BY = :2,
--       STATUS_DATE= :3
--WHERE  WC_SCREENING_REQUEST_ID = :4 '

      --SAURABH 18-SEP-2019 T20190912.0051
      v_sql :=
         'UPDATE VSSL.WC_SCREENING_REQUEST
SET    STATUS = :1,
       STATUS_UPDATED_BY = :2,
       STATUS_DATE= :3,
       LAST_UPDATED_BY = :4
WHERE  WC_SCREENING_REQUEST_ID = :5 ';

      BEGIN
         EXECUTE IMMEDIATE v_sql
                     USING 'Approved',
                           c_automatic_approval_uid,
                           --WORLDCHECK_AUTOMATIC_APPROVAL
                           SYSDATE,
                           l_user_id,
                           p_wc_screening_request_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_return_code := 'SQLERROR';
            p_return_message := 'approve_screening_request ' || SQLERRM;
            ROLLBACK;
            auto_approve := FALSE;
      END;

      COMMIT;
----dbms_output.put_line('commit');
   END IF;
END;

-- T20180410.0005 Re-Vetting for Embargoed Countries
-- SAURABH 25-APR0-2018
-- Created new function for approve screening request
-- This function will return true if no sanctions applied 
-- If there are any sancations on screening request function will return false
FUNCTION approve_screening_request (
   p_wc_screening_request_id   IN       NUMBER,
   p_return_code               OUT      NUMBER,
   p_return_message            OUT      VARCHAR2
)
   RETURN BOOLEAN
IS
   v_sql             VARCHAR2 (2000)       := NULL;

   CURSOR get_vetting
   IS
      SELECT *
        FROM wc_screening_request
       WHERE wc_screening_request_id = p_wc_screening_request_id;

   vet_rec           get_vetting%ROWTYPE;
   sanction_status   VARCHAR2 (30);
   auto_approve      BOOLEAN               := TRUE;

   --SAURABH 18-SEP-2019 T20190912.0051
   l_user_id         NUMBER                := fnd_profile.VALUE ('USER_ID');

BEGIN
   OPEN get_vetting;

   FETCH get_vetting
    INTO vet_rec;

   CLOSE get_vetting;

   sanction_status :=
      world_check_iface.get_sanction_status
                                       (vet_rec.passport_issuing_country_code);

----dbms_output.put_line('Passport '||sanction_status);
   IF sanction_status IN ('PROHIBITED')
   THEN
      auto_approve := FALSE;
   END IF;

   sanction_status :=
      world_check_iface.get_sanction_status (vet_rec.citizenship_country_code);

----dbms_output.put_line('Citizenship '||sanction_status);
   IF sanction_status IN ('PROHIBITED')
   THEN
      auto_approve := FALSE;
   END IF;

   sanction_status :=
        world_check_iface.get_sanction_status (vet_rec.residence_country_code);

----dbms_output.put_line('Residence '||sanction_status);
   IF sanction_status IN ('PROHIBITED')
   THEN
      auto_approve := FALSE;
   END IF;

/*
if auto_approve = TRUE  then
--dbms_output.put_line('Auto Approve is TRUE');
else
--dbms_output.put_line('Auto Approve is FALSE');
end if;
*/
   sanction_status :=
      world_check_iface.get_sanction_status
                                        (vet_rec.passport_issuing_country_code);

   IF     sanction_status IN ('CONDITIONAL')
      AND get_city_tc_status (vet_rec.wc_city_list_id) IN
                                              ('TC_VERIFY', 'TC_PROVISIONAL')
   THEN
      auto_approve := FALSE;
   END IF;

   sanction_status :=
      world_check_iface.get_sanction_status (vet_rec.citizenship_country_code);

   IF     sanction_status IN ('CONDITIONAL')
      AND get_city_tc_status (vet_rec.wc_city_list_id) IN
                                              ('TC_VERIFY', 'TC_PROVISIONAL')
   THEN
      auto_approve := FALSE;
   END IF;

   sanction_status :=
        world_check_iface.get_sanction_status (vet_rec.residence_country_code);

   IF     sanction_status IN ('CONDITIONAL')
      AND get_city_tc_status (vet_rec.wc_city_list_id) IN
                                              ('TC_VERIFY', 'TC_PROVISIONAL')
   THEN
      auto_approve := FALSE;
   END IF;

----dbms_output.put_line ( 'approve_screening_request start');
   IF auto_approve = TRUE
   THEN
----dbms_output.put_line('SAVE IT');
      p_return_code := 200;
      p_return_message := 'Normal';

--SAURABH 18-SEP-2019 T20190912.0051

      --v_sql:= 'UPDATE VSSL.WC_SCREENING_REQUEST
--SET    STATUS = :1,
--       STATUS_UPDATED_BY = :2,
--       STATUS_DATE= :3
--WHERE  WC_SCREENING_REQUEST_ID = :4 '

      --SAURABH 18-SEP-2019 T20190912.0051

      v_sql :=
         'UPDATE VSSL.WC_SCREENING_REQUEST
SET    STATUS = :1,
       STATUS_UPDATED_BY = :2,
       STATUS_DATE= :3,
       LAST_UPDATED_BY = :4
WHERE  WC_SCREENING_REQUEST_ID = :5 ';

      BEGIN
         EXECUTE IMMEDIATE v_sql
                     USING 'Approved',
                           c_automatic_approval_uid,
                           --WORLDCHECK_AUTOMATIC_APPROVAL
                           SYSDATE,
                           l_user_id,
                           p_wc_screening_request_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_return_code := 'SQLERROR';
            p_return_message := 'approve_screening_request ' || SQLERRM;
            ROLLBACK;
            auto_approve := FALSE;
      END;

      COMMIT;
----dbms_output.put_line('commit');
   END IF;

   RETURN auto_approve;
END;


procedure display_details(p_wc_content_id in number, p_ddata IN OUT display_details_tab) is

cursor get_data is
select * from WC_CONTENT where wc_content_id = p_wc_content_id;

content_rec get_data%rowtype;

data_display varchar2(4000);


cursor get_name(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/names/name' passing p_xml_var
                                                 columns
                                                  fullname varchar2(200)  path 'fullName',
                                                  nametype varchar(200) path '@type',
                                                  givenname varchar2(200)  path 'givenName',
                                                  lastname varchar2(200) path 'lastName'
                                                 ) x ;

cursor get_sex(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/individual' passing p_xml_var
                                                 columns
                                                  sex varchar2(200)  path 'gender',
                                                  age varchar2(200) path 'age',
                                                  as_of varchar2(200) path 'ageAsOfDate'
                                                 ) x ;
sex varchar2(200);
age varchar2(200);
as_of varchar2(200);
is_dead varchar2(200);

cursor get_category(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/individual' passing p_xml_var
                                                 columns
                                                  category_type varchar2(200)  path 'category'
                                                 ) x ;

cursor get_country(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/countryLinks/countryLink/country' passing p_xml_var
                                                 columns
                                                  name varchar2(200)  path 'name'
                                                 ) x ;

cursor get_details(p_xml_var in xmltype) is
select x.*  from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/details/detail' passing p_xml_var
                                                 columns
                                                  title varchar2(200)  path 'title',
                                                  txt clob  path 'text'

                                                 ) x ;



cursor get_weblinks(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/weblinks/weblink' passing p_xml_var
                                                 columns
                                                  url_link varchar2(500)  path 'URI'
                                                 ) x ;


cursor get_actions(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/actionDetails/actionDetail' passing p_xml_var
                                                 columns
                                                  action_type varchar2(500)  path '@actionType',
                                                  a_name     varchar2(500) path 'source/name'
                                                 ) x ;
cursor get_addresses(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/addresses/address' passing p_xml_var
                                                 columns
                                                  country varchar2(500)  path 'country/name',
                                                  region varchar2(500) path 'region' ,
                                                  city    varchar2(500) path 'city',
                                                  street varchar2(500) path 'street'
                                                 ) x ;

cursor get_life_events(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/individual/events/event' passing p_xml_var
                                                 columns
                                                  event_type varchar2(500)  path '@type',
                                                  event_date varchar2(500) path   './fullDate'
                                                 ) x ;

cursor get_is_dead(p_xml_var in xmltype) is
select x.* from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                   'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/individual' passing p_xml_var
                                                 columns
                                                  isdead varchar2(500)  path 'isDeceased'
                                                 ) x ;

ii   NUMBER := 1;

start_counter number;
location_str varchar2(100):='Start';
begin
------dbms_output.put_line('start');
if p_wc_content_id is null then
p_ddata (ii).heading:='No results.';
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:=data_display;
else

open get_data;
fetch get_data into content_rec;
close get_data;
location_str:='Get Content';
----dbms_output.put_line('get_content');

if content_rec.xml_response is null then
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
p_ddata (ii).heading:='Error: ';
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:='Content did not download correctly from World Check, press synchronize matches';
end if;

for abc in get_name(content_rec.xml_response) loop
location_str:='Get Name';
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
p_ddata (ii).heading:='Name ('||abc.nametype||')';
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:=abc.fullname;
ii := ii + 1;
end loop;



open get_sex(content_rec.xml_response);
fetch get_sex into sex,age,as_of;
close get_sex;
----dbms_output.put_line('get_sex');
if sex is not null then
location_str:='Get Sex';
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
p_ddata (ii).heading:='Sex';
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:=sex;
ii := ii + 1;
end if;

if age is not null then
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
p_ddata (ii).heading:='Age';
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:=age;
ii := ii + 1;
if as_of is not null then
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
p_ddata (ii).heading:='As Of';
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:=as_of;
ii := ii + 1;
end if;
end if;
location_str:='Get Age';
for x in get_life_events(content_rec.xml_response) loop
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
p_ddata (ii).heading:=x.event_type;
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:=x.event_date;
ii := ii + 1;
end loop;
location_str:='Get Events';
----dbms_output.put_line('get_events');
is_dead:='FALSE';

open get_is_dead(content_rec.xml_response);
fetch get_is_dead into is_dead;
close get_is_dead;

is_dead := upper(is_dead);

if is_dead = 'TRUE' then
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
p_ddata (ii).heading:='Deceased';
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:='True';
ii := ii + 1;
end if;
----dbms_output.put_line('get_dead');
open get_category(content_rec.xml_response);
fetch get_category into data_display;
close get_category;

if  data_display is not null then
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
p_ddata (ii).heading:='Category';
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:=data_display;
ii := ii + 1;
end if;


location_str:='Get Country';

for x in get_country(content_rec.xml_response) loop
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
p_ddata (ii).heading:='Country';
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:=x.name;
ii := ii + 1;
end loop;
----dbms_output.put_line('get_country');
begin
for x in  get_details(content_rec.xml_response) loop
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
p_ddata (ii).heading:=x.title;
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:=dbms_lob.substr( x.txt, 4000, 1 );
ii := ii + 1;
end loop;
exception when others
then
null;
end;

location_str:='Get Details';
----dbms_output.put_line(' get_details');

start_counter:=ii;
for x in  get_weblinks(content_rec.xml_response) loop
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
if start_counter =ii then
p_ddata (ii).heading:='Web Links';
else
p_ddata (ii).heading:='';
end if;
p_ddata (ii).data_type:='URL';
p_ddata (ii).display_data:=x.url_link;
ii := ii + 1;
end loop;

----dbms_output.put_line('get_weblinks');


location_str:='Get Actions';
for x in  get_actions(content_rec.xml_response) loop
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
p_ddata (ii).heading:= x.action_type;
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:=x.a_name;
ii := ii + 1;
end loop;


start_counter:=ii;
location_str:='Get Addresses';
for x in  get_addresses(content_rec.xml_response) loop
p_ddata (ii).WC_CONTENT_ID:=p_wc_content_id;
if start_counter =ii then
p_ddata (ii).heading:='Addresses';
else
p_ddata (ii).heading:='';
end if;
p_ddata (ii).data_type:='Display';
p_ddata (ii).display_data:= x.country||'-'||x.region||' - '||x.city||' - '||x.street;
ii := ii + 1;
end loop;


end if;

exception when others then
raise_application_error (-20001, sqlerrm||' display_details '||location_str);

end;

procedure process_delete_screening(p_name_identifier in varchar2, return_code out number, return_message out varchar2) is

   l_string_request    VARCHAR2 (4000);
   l_http_request UTL_HTTP.req;
    l_response_xml xmltype;
   l_request_id number:= null;
   user_id number;
   login_id number;
begin
l_string_request :=soap_envelope_start;
l_string_request := l_string_request || soap_header;
l_string_request := l_string_request ||delete_screening(p_name_identifier );
l_string_request := l_string_request ||soap_envelope_end;
send_request (get_world_check_name_url, l_string_request, l_http_request);
read_response(l_http_request, l_response_xml,return_code,  return_message) ;
end;


procedure process_new_info(  l_response_xml out  xmltype, return_code out number, return_message out varchar2) is

   l_string_request    VARCHAR2 (4000);
   l_http_request UTL_HTTP.req;

   l_request_id number:= null;
   user_id number;
   login_id number;
begin
l_string_request :=soap_envelope_start;
l_string_request := l_string_request || soap_header;
l_string_request := l_string_request ||get_new_updated_names;
l_string_request := l_string_request ||soap_envelope_end;
send_request (get_stored_name_url , l_string_request, l_http_request);
read_response(l_http_request, l_response_xml,return_code,  return_message) ;
end;
procedure archive_screening(p_name_identifier in varchar2, return_code out number, return_message out varchar2) is

   l_string_request    VARCHAR2 (4000);
   l_http_request UTL_HTTP.req;
    l_response_xml xmltype;
   l_request_id number:= null;
   user_id number;
   login_id number;
begin
l_string_request :=soap_envelope_start;
l_string_request := l_string_request || soap_header;
l_string_request := l_string_request ||delete_screening(p_name_identifier );
l_string_request := l_string_request ||soap_envelope_end;
send_request (get_world_check_name_url, l_string_request, l_http_request);
read_response(l_http_request, l_response_xml,return_code,  return_message) ;
end;

procedure initiate_wc_screening(xref in out world_check_iface.WC_EXTERNAL_XREF_REC, req in out world_check_iface.WC_SCREENING_REQUEST_REC, p_custom_id1 in varchar2, p_custom_id2 in varchar2, return_code out number, return_message out varchar2) is
   l_string_request    VARCHAR2 (4000);
   l_http_request UTL_HTTP.req;
    l_response_xml xmltype;
   l_request_id number:= null;
   p_name_identifier varchar2(100);
   user_id number;
   login_id number;
   on_ofac_list varchar2(1):='N';
   search_results  trade_compliance.name_search_results;
   sub_message varchar2(50) := 'Start';
begin
--dbms_output.put_line ( 'initiate_wc_screening start');
   user_id:= get_userid;
   login_id := get_loginid;
   req.NAME_SCREENED:=ltrim(rtrim(req.NAME_SCREENED));
l_string_request :=soap_envelope_start;
l_string_request := l_string_request || soap_header;
l_string_request := l_string_request || world_check_request( 'cnu_so_19200', p_custom_id1, p_custom_id2,'cng_so_5412',req.NAME_SCREENED,req.ENTITY_TYPE);
l_string_request := l_string_request ||soap_envelope_end;
send_request (get_world_check_request_url, l_string_request, l_http_request);
sub_message:=' send_request ';

--dbms_output.put_line ('get_world_check_request_url'||get_world_check_request_url);
--dbms_output.put_line ('l_string_request '||l_string_request);
read_response(l_http_request, l_response_xml,return_code,  return_message) ;
sub_message:=' read_responset '||return_message;
----dbms_output.put_line ( 'initiate_wc_screening make request ' ||to_char(return_code));

if return_code =200 then

SELECT WC_SCREENING_REQUEST_ID_SEQ.NEXTVAL INTO req.WC_SCREENING_REQUEST_ID FROM dual;

select x.name_identifier into req.name_identifier from  dual, xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:screenResponse/return' passing l_response_xml
                                                 columns
                                                  name_identifier varchar2(500) path '.'
                                                 ) x ;

req.STATUS:='Pending';


----dbms_output.put_line ( 'CHECK OFAC' );
if req.ENTITY_TYPE = c_VESSEL then
on_ofac_list:=trade_compliance.is_imo_number_on_ofac_list(req.NAME_SCREENED);
on_ofac_list:=trade_compliance.is_vssl_name_on_ofac_list(req.NAME_SCREENED);
elsif req.ENTITY_TYPE =c_INDIVIDUAL then
on_ofac_list:=trade_compliance.is_person_on_ofac_list(req.NAME_SCREENED, search_results);
elsif req.ENTITY_TYPE = c_CORPORATION then
on_ofac_list:=trade_compliance.is_corp_on_ofac_list(req.NAME_SCREENED, search_results);
else
----dbms_output.put_line ( 'IMO' );
if on_ofac_list = 'N' then on_ofac_list:=trade_compliance.is_imo_number_on_ofac_list(req.NAME_SCREENED); end if;
----dbms_output.put_line ( 'Vessel Name' );
if on_ofac_list = 'N' then on_ofac_list:=trade_compliance.is_vssl_name_on_ofac_list(req.NAME_SCREENED); end if;
----dbms_output.put_line ( 'Name' );
if on_ofac_list = 'N' then on_ofac_list:=trade_compliance.is_person_on_ofac_list(req.NAME_SCREENED, search_results); end if;
----dbms_output.put_line ( 'Corp' );
if on_ofac_list = 'N' then on_ofac_list:=trade_compliance.is_corp_on_ofac_list(req.NAME_SCREENED, search_results); end if;
end if;

----dbms_output.put_line ( 'Insert screening request' );
INSERT INTO VSSL.WC_SCREENING_REQUEST (
   WC_SCREENING_REQUEST_ID, NAME_IDENTIFIER, XML_RESPONSE,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY,
   LAST_UPDATE_DATE, LAST_UPDATE_LOGIN, NAME_SCREENED,
   DATE_OF_BIRTH, SEX, PASSPORT_NUMBER,
   ENTITY_TYPE, STATUS, PASSPORT_ISSUING_COUNTRY_CODE,OFAC_LIST_EDOC_ID,OFAC_LIST_IS_ENTY_ON_LIST,
   CORP_RESIDENCE_COUNTRY_CODE,CITIZENSHIP_COUNTRY_CODE,RESIDENCE_COUNTRY_CODE,NOTIFY_USER_UPON_APPROVAL,TYPE_ID,CITY_NAME,WC_CITY_LIST_ID,imo_number)
VALUES ( req.WC_SCREENING_REQUEST_ID /* WC_SCREENING_REQUEST_ID */,
 req.name_identifier /* NAME_IDENTIFIER */,
  l_response_xml /* XML_RESPONSE.GetClobVal() as XML_RESPONSE */,
 user_id /* CREATED_BY */,
sysdate /* CREATION_DATE */,
user_id /* LAST_UPDATED_BY */,
sysdate  /* LAST_UPDATED_DATE */,
login_id /* LAST_UPDATE_LOGIN */,
req.NAME_SCREENED  /* NAME_SCREENED */,
req.DATE_OF_BIRTH /* DATE_OF_BIRTH */,
 req.SEX /* SEX */,
 req.PASSPORT_NUMBER/* PASSPORT_NUMBER */,
 req.ENTITY_TYPE /* ENTITY_TYPE */,
 req.STATUS /* STATUS */,
 req.PASSPORT_ISSUING_COUNTRY_CODE/* PASSPORT_ISSUING_COUNTRY_CODE */ ,
 trade_compliance.get_latest_ofac_edoc_id,
 on_ofac_list,
 req.CORP_RESIDENCE_COUNTRY_CODE,
req.CITIZENSHIP_COUNTRY_CODE,
req.RESIDENCE_COUNTRY_CODE,
req.NOTIFY_USER_UPON_APPROVAL,
req.TYPE_ID,
req.city_name,
req.WC_CITY_LIST_ID,
req.imo_number);

COMMIT;

if  xref.SOURCE_TABLE is not null and
    xref.SOURCE_TABLE_ID  is not null and
     xref.SOURCE_TABLE_COLUMN  is not null then

xref.WC_SCREENING_REQUEST_ID :=req.WC_SCREENING_REQUEST_ID;
SELECT WORLDCHECK_EXTERNAL_XREF_SEQ.NEXTVAL INTO xref.WORLDCHECK_EXTERNAL_XREF_ID FROM dual;

INSERT INTO VSSL.WORLDCHECK_EXTERNAL_XREF (
   WORLDCHECK_EXTERNAL_XREF_ID, WC_SCREENING_REQUEST_ID, SOURCE_TABLE,
   SOURCE_TABLE_ID, SOURCE_TABLE_COLUMN, SOURCE_TABLE_STATUS_COLUMN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY,
   LAST_UPDATE_DATE, LAST_UPDATE_LOGIN)
VALUES ( xref.WORLDCHECK_EXTERNAL_XREF_ID/* WORLDCHECK_EXTERNAL_XREF_ID */,
 req.WC_SCREENING_REQUEST_ID /* WC_SCREENING_REQUEST_ID */,
 xref.SOURCE_TABLE/* SOURCE_TABLE */,
 xref.SOURCE_TABLE_ID/* SOURCE_TABLE_ID */,
 xref.SOURCE_TABLE_COLUMN /* SOURCE_TABLE_COLUMN */,
 xref.SOURCE_TABLE_STATUS_COLUMN /* SOURCE_TABLE_STATUS_COLUMN */,
 user_id /* CREATED_BY */,
 sysdate /* CREATION_DATE */,
 user_id/* LAST_UPDATED_BY */,
 sysdate /* LAST_UPDATE_DATE */,
 login_id /* LAST_UPDATE_LOGIN */ );
 commit;
end if;
end if;
--exception
--when others then
--rollback;
--return_code:=-100;
--return_message:=sub_message||' '||sqlerrm;
--return;
end;

PROCEDURE create_new_xref (
   xref             IN OUT   world_check_iface.wc_external_xref_rec,
   return_code      OUT      NUMBER,
   return_message   OUT      VARCHAR2
)
IS
   user_id    NUMBER;
   login_id   NUMBER;
BEGIN
   user_id := get_userid;
   login_id := get_loginid;

   --
   -- SAURABH 12-JUN-2019 T20170328.0029 
   -- If Xref already exists do not insert duplicate
   -- update existing xref fow who columns
   -- If Xref do not exists then create new
   --

   UPDATE vssl.worldcheck_external_xref
   SET    last_update_date = SYSDATE,
          last_updated_by = user_id,
          last_update_login = login_id
   WHERE  1=1
   AND    source_table = xref.source_table
   AND    source_table_column = xref.source_table_column
   AND    source_table_id = xref.source_table_id
   AND    wc_screening_request_id = xref.wc_screening_request_id;

   IF SQL%ROWCOUNT = 0 THEN

   SELECT worldcheck_external_xref_seq.NEXTVAL
     INTO xref.worldcheck_external_xref_id
     FROM DUAL;

   return_code := 0;
   return_message := 'OK';

   BEGIN
      INSERT INTO vssl.worldcheck_external_xref
                  (worldcheck_external_xref_id,
                   wc_screening_request_id,
                   source_table,
                   source_table_id,
                   source_table_column,
                   source_table_status_column,
                   created_by, creation_date,
                   last_updated_by,
                   last_update_date,
                   last_update_login
                  )
           VALUES (xref.worldcheck_external_xref_id /* WORLDCHECK_EXTERNAL_XREF_ID */,
                   xref.wc_screening_request_id /* WC_SCREENING_REQUEST_ID */,
                   xref.source_table /* SOURCE_TABLE */,
                   xref.source_table_id /* SOURCE_TABLE_ID */,
                   xref.source_table_column /* SOURCE_TABLE_COLUMN */,
                   xref.source_table_status_column /* SOURCE_TABLE_STATUS_COLUMN */,
                   user_id /* CREATED_BY */, SYSDATE /* CREATION_DATE */,
                   user_id /* LAST_UPDATED_BY */,
                   SYSDATE /* LAST_UPDATE_DATE */,
                   login_id /* LAST_UPDATE_LOGIN */
                  );
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         return_code := SQLCODE;
         return_message := SQLERRM;
         RETURN;
   END;

   END IF;

/*
begin
update VSSL.WC_SCREENING_REQUEST
set status='Pending'
where WC_SCREENING_REQUEST_ID= xref.WC_SCREENING_REQUEST_ID ;
exception when others then
rollback;
return_code:=sqlcode;
return_message:=sqlerrm;
return;
end;
*/
   COMMIT;
END;


procedure push_status_to_creator(P_WC_SCREENING_REQUEST_ID in number, return_code out number, return_message out varchar2) is

cursor get_request_info is
select * from WC_SCREENING_REQUEST where WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID;

req get_request_info%rowtype;

cursor get_xref is
select * from VSSL.WORLDCHECK_EXTERNAL_XREF where
WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID
order by creation_date desc;
xref  get_xref%rowtype;

v_sql varchar2(4000) := null;

begin

open  get_request_info;
fetch  get_request_info into req;
close get_request_info;

open get_xref;
fetch get_xref into xref;
close get_xref;

if  xref.SOURCE_TABLE is not null and
xref.SOURCE_TABLE_STATUS_COLUMN is not null and
xref.SOURCE_TABLE_ID is not null then

v_sql:= 'update '||xref.SOURCE_TABLE||' set '||xref.SOURCE_TABLE_STATUS_COLUMN||' = :1 where '||xref.SOURCE_TABLE_COLUMN||' = :2';

begin
 EXECUTE IMMEDIATE v_sql
 using
req.STATUS,
xref.SOURCE_TABLE_ID;

 exception when others then
 return_code:= SQLCODE;
 return_message := 'push_status_to_creator '||SQLERRM;
 rollback;
 return;
 end;

commit;
else
return_code:=0;
return_message:='Normal';
end if;

end;


FUNCTION wc_locked (p_wc_screening_request_id IN NUMBER)
   RETURN VARCHAR2
IS
/* this function checks to see it the is an active row lock on
a specific world check */
   CURSOR find_lock
   IS
      SELECT     'xx'
            FROM wc_screening_request
           WHERE wc_screening_request_id = p_wc_screening_request_id
      FOR UPDATE NOWAIT;

   CURSOR get_matches
   IS
      SELECT     'x'
            FROM wc_matches
           WHERE wc_screening_request_id = p_wc_screening_request_id
      FOR UPDATE NOWAIT;

   CURSOR get_content
   IS
      SELECT     'x'
            FROM wc_content
           WHERE wc_matches_id IN (
                    SELECT wc_matches_id
                      FROM wc_matches
                     WHERE wc_screening_request_id =
                                                    p_wc_screening_request_id)
      FOR UPDATE NOWAIT;

   e_resource_busy   EXCEPTION;
   PRAGMA EXCEPTION_INIT (e_resource_busy, -54);
   retval            VARCHAR2 (1) := 'N';
BEGIN
   BEGIN
      OPEN find_lock;

      CLOSE find_lock;
   --T20190208.0022 SAURABH 27 FEB 2019
   --rollback;
   EXCEPTION
      WHEN e_resource_busy
      THEN
         retval := 'Y';
   END;

   IF retval = 'N'
   THEN
      BEGIN
         OPEN get_matches;

         CLOSE get_matches;
      --T20190208.0022 SAURABH 27 FEB 2019
      --rollback;
      EXCEPTION
         WHEN e_resource_busy
         THEN
            retval := 'Y';
      END;
   END IF;

   IF retval = 'N'
   THEN
      BEGIN
         OPEN get_content;

         CLOSE get_content;
      --T20190208.0022 SAURABH 27 FEB 2019
      --rollback;
      EXCEPTION
         WHEN e_resource_busy
         THEN
            retval := 'Y';
      END;
   END IF;

--T20190208.0022 SAURABH 27 FEB 2019
   COMMIT;
   RETURN (retval);
END;

--SAURABH 03-JUL-18 T20180619.0034
-- New function to check if all matches are false or not for new vettings   
FUNCTION can_vetting_be_autoapproved (p_wc_screening_request_id IN NUMBER)
   RETURN VARCHAR2
IS
   CURSOR get_content
   IS
      SELECT wc.*
        FROM wc_content_v wc, wc_matches_v wv
       WHERE wv.wc_screening_request_id = p_wc_screening_request_id
         AND wc.wc_matches_id = wv.wc_matches_id;

   auto_approve   BOOLEAN := TRUE;
BEGIN
   FOR x IN get_content
   LOOP
      IF x.matchstatus != c_false_match
      THEN
         auto_approve := FALSE;
         EXIT;
      END IF;
   END LOOP;

   IF auto_approve
   THEN
      RETURN 'Y';
   END IF;

   RETURN 'N';
END can_vetting_be_autoapproved;


procedure create_wc_seafarer_id(p_seafarer_id in number, p_return_code out varchar, p_ret_msg out varchar2) is

/* create a world check vetting based on a seafarer id */
/* p_return_code  =
SUCCESS,
ERROR_CREATING_WC
SEAFARER_NOT_FOUND
SQLERROR

*/

xref world_check_iface.WC_EXTERNAL_XREF_REC;
req world_check_iface.WC_SCREENING_REQUEST_REC;

return_code  number;
return_message varchar2(250);

cursor get_seafarer_info is
select ss.*, sc.country_name from sicd_seafarers ss, sicd_countries sc
where ss.seafarer_id = p_seafarer_id
and sc.country_code=ss.nationality;

seaf get_seafarer_info%rowtype;

cursor get_request_info(p_WC_SCREENING_REQUEST_ID in number) is
select * from WC_SCREENING_REQUEST where WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID;

scrrqst get_request_info%rowtype;

cursor get_WC_MATCHES(p_WC_SCREENING_REQUEST_ID in number) is
select * from WC_MATCHES where WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID;

mtch get_WC_MATCHES%rowtype;


begin

----dbms_output.put_line ( 'start');

 p_ret_msg:='Normal';
p_return_code := 'SUCCESS';

open get_seafarer_info;
fetch get_seafarer_info into seaf;
close get_seafarer_info;

if (seaf.seafarer_id is null) or (seaf.last_name is null ) then
p_return_code:= 'SEAFARER_NOT_FOUND';
 p_ret_msg := 'Seafarer record not found';
 return;
end if;

req.WC_SCREENING_REQUEST_ID:=null;
req.STATUS:='Pending';
req.NAME_SCREENED:=seaf.first_name||' '||seaf.last_name;
req.DATE_OF_BIRTH:=seaf.BIRTH_DATE;
req.SEX :=seaf.GENDER;
req.NAME_IDENTIFIER :=null;
req.PASSPORT_NUMBER :=null;
req.ENTITY_TYPE := 'INDIVIDUAL';
req.PASSPORT_ISSUING_COUNTRY_CODE := seaf.NATIONALITY;
req.CORP_RESIDENCE_COUNTRY_CODE:=null;
req.RESIDENCE_COUNTRY_CODE:=null;
req.CITIZENSHIP_COUNTRY_CODE := seaf.NATIONALITY;
req.NOTIFY_USER_UPON_APPROVAL:='N';
xref.source_table := 'SICD_SEAFARERS';
xref.source_table_column  :='SEAFARER_ID';
xref.source_table_id :=seaf.seafarer_id;
xref.source_table_status_column:=null;
xref.WORLDCHECK_EXTERNAL_XREF_ID :=null;
xref.wc_screening_request_id:= req.WC_SCREENING_REQUEST_ID;


initiate_wc_screening(xref , req,'Seafarer_ID', to_char(seaf.seafarer_id), return_code,  p_ret_msg);
----dbms_output.put_line ( 'initiate_wc_screening ' ||to_char(return_code) || p_ret_msg);
if return_code = 200 then
open get_request_info(req.WC_SCREENING_REQUEST_ID);
fetch get_request_info into scrrqst;
close get_request_info;

process_name_matches(scrrqst.name_identifier, req.WC_SCREENING_REQUEST_ID ,return_code, p_ret_msg);
----dbms_output.put_line ( 'process_name_matches ' ||to_char(return_code) || p_ret_msg);
if return_code = 200 then
----dbms_output.put_line ('1');
open get_WC_MATCHES(req.WC_SCREENING_REQUEST_ID);
----dbms_output.put_line ('2');
fetch get_WC_MATCHES into mtch;
----dbms_output.put_line ('3');
close get_WC_MATCHES;

--raise_application_error(-20000,'xxxx'); /* delete this line */
----dbms_output.put_line ('#'||to_char(mtch.NUMBER_OF_MATCHES));
if mtch.NUMBER_OF_MATCHES >0 then
----dbms_output.put_line ('4');

for x in  get_WC_MATCHES(req.WC_SCREENING_REQUEST_ID) loop
populate_match_details( x.WC_MATCHES_ID , mtch.WC_MATCHES_ID,return_code, p_ret_msg);
end loop;

UPDATE_WC_MATCH_STATUS ( req.WC_SCREENING_REQUEST_ID, return_code,  p_ret_msg );

----dbms_output.put_line ( 'populate_match_details ' ||to_char(return_code) || p_ret_msg);
/* double check to see if any matches still exist if not then approve the world check request */
--open get_WC_MATCHES(req.WC_SCREENING_REQUEST_ID);
--fetch get_WC_MATCHES into mtch;
--close get_WC_MATCHES;

IF mtch.NUMBER_OF_MATCHES =0 then
----dbms_output.put_line ( 'push_status_to_creator -1' );
  req.STATUS:='Approved';
  approve_screening_request(req.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
  push_status_to_creator(req.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
  ----dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);

--SAURABH 03-JUL-18 T20180619.0034
-- If all matches are marked false, approve request
ELSIF can_vetting_be_autoapproved(req.WC_SCREENING_REQUEST_ID) = 'Y' then
  approve_screening_request(req.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
  push_status_to_creator(req.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
END IF;

else
----dbms_output.put_line ('5');
req.STATUS:='Approved';
approve_screening_request(req.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
----dbms_output.put_line ('6');
push_status_to_creator(req.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
----dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
end if;
end if;
else
p_return_code := 'ERROR_CREATING_WC';
end if;
----dbms_output.put_line ( 'end');
exception
when others then
p_return_code := 'SQLERROR';
p_ret_msg :=sqlerrm;

 if get_seafarer_info%ISOPEN then
 close get_seafarer_info;
end if;

if get_request_info%ISOPEN then
 close get_request_info ;
end if;
if get_WC_MATCHES%ISOPEN then
 close get_WC_MATCHES;
 end if;

end;




procedure create_wc_generic(xref in out world_check_iface.WC_EXTERNAL_XREF_REC, req in out world_check_iface.WC_SCREENING_REQUEST_REC, p_custom_id1 in varchar2, p_custom_id2 in varchar2,p_return_code out varchar, p_ret_msg out varchar2) is


/* p_return_code  =
SUCCESS,
ERROR_CREATING_WC
SEAFARER_NOT_FOUND
SQLERROR

*/

return_code  number;
return_message varchar2(500);
location_msg varchar2(100):='create_wc_generic:';
sub_msg varchar2(500);


cursor get_request_info(p_WC_SCREENING_REQUEST_ID in number) is
select * from WC_SCREENING_REQUEST where WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID;

scrrqst get_request_info%rowtype;

cursor get_WC_MATCHES(p_WC_SCREENING_REQUEST_ID in number) is
select * from WC_MATCHES where WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID;

mtch get_WC_MATCHES%rowtype;



begin

sub_msg:= 'start';
 p_ret_msg:='Normal';
p_return_code := 'SUCCESS';
sub_msg:= 'before nitiate_wc_screening :'||p_ret_msg;
initiate_wc_screening(xref , req,p_custom_id1,p_custom_id2, return_code,  p_ret_msg);
sub_msg:= 'after initiate_wc_screening :'||p_ret_msg;
if return_code = 200 then
open get_request_info(req.WC_SCREENING_REQUEST_ID);
fetch get_request_info into scrrqst;
close get_request_info;
process_name_matches(scrrqst.name_identifier, req.WC_SCREENING_REQUEST_ID ,return_code, p_ret_msg);
sub_msg:= 'process_name_matches ';
if return_code = 200 then
----dbms_output.put_line ('1');
open get_WC_MATCHES(req.WC_SCREENING_REQUEST_ID);
----dbms_output.put_line ('2');
fetch get_WC_MATCHES into mtch;
----dbms_output.put_line ('3');
close get_WC_MATCHES;
----dbms_output.put_line ('#'||to_char(mtch.NUMBER_OF_MATCHES));
if mtch.NUMBER_OF_MATCHES >0 then
----dbms_output.put_line ('4');
for x in  get_WC_MATCHES(req.WC_SCREENING_REQUEST_ID) loop

populate_match_details( x.WC_MATCHES_ID , mtch.WC_MATCHES_ID,return_code, p_ret_msg);
end loop;

sub_msg:= 'populate_match_details ' ;
/* double check to see if any matches still exist if not then approve the world check request */
open get_WC_MATCHES(req.WC_SCREENING_REQUEST_ID);
fetch get_WC_MATCHES into mtch;
close get_WC_MATCHES;

IF mtch.NUMBER_OF_MATCHES =0 then
  sub_msg:='push_status_to_creator -1' ;
  approve_screening_request(req.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
  push_status_to_creator(req.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
  ----dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);

  --SAURABH 31-MAY-2019 T20170714.0024
  POST_SAVEFORONGOINGSCREENING (req.NAME_IDENTIFIER, return_code, p_ret_msg );

--SAURABH 03-JUL-18 T20180619.0034
-- If all matches are marked false, approve request
ELSIF can_vetting_be_autoapproved(req.WC_SCREENING_REQUEST_ID) = 'Y' then
  sub_msg:='push_status_to_creator -1.1' ;
  approve_screening_request(req.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
  push_status_to_creator(req.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);

  --SAURABH 31-MAY-2019 T20170714.0024
  POST_SAVEFORONGOINGSCREENING (req.NAME_IDENTIFIER, return_code, p_ret_msg );

END IF;

ELSE
----dbms_output.put_line ('5');
approve_screening_request(req.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
----dbms_output.put_line ('6');
push_status_to_creator(req.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
----dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);

--SAURABH 31-MAY-2019 T20170714.0024
  POST_SAVEFORONGOINGSCREENING (req.NAME_IDENTIFIER, return_code, p_ret_msg );

end if;
end if;
else
p_return_code := 'ERROR_CREATING_WC';
end if;
----dbms_output.put_line ( 'end');
exception
when others then
p_return_code := 'SQLERROR';
p_ret_msg :=sqlerrm||' '||location_msg||sub_msg;

if get_request_info%ISOPEN then
 close get_request_info ;
end if;
if get_WC_MATCHES%ISOPEN then
 close get_WC_MATCHES;
 end if;

end;

FUNCTION get_wc_status (
   p_xref   IN OUT   world_check_iface.wc_external_xref_rec,
   p_req    IN OUT   world_check_iface.wc_screening_request_rec
)
   RETURN VARCHAR2
IS
/* return values: APPROVED, REJECTED, PENDING, NO RECORD, PENDING PROVISIONAL, PROVISIONAL */

   /* if a general entity search is done: SOURCE_TABLE, SOURCE_TABLE_COLUMN, SOURCE_TABLE_ID are filled in
   then the order of status returned will be the following:
   if a rejected recored exists then the overall status will be REJECTED
   if a pending record exists then the overall status will be PENDING.
   if no data exists then the overalll status will be NO_RECORD
   if all records are approved then the status will be APPROVED

   if the WC_SCREENING_REQUEST_ID is passed in then the returned value will be for that specific record
   and if you are not doing a search having the WC_SCREENING_REQUEST_ID parameter then the p_req return
   value is meaningless it's just the last record read */
   CURSOR get_xref (p_status IN VARCHAR2)
   IS
      SELECT COUNT (*)
        FROM vssl.worldcheck_external_xref xref, wc_screening_request req
       WHERE xref.source_table = NVL (p_xref.source_table, xref.source_table)
         AND xref.source_table_column =
                    NVL (p_xref.source_table_column, xref.source_table_column)
         AND xref.source_table_id =
                            NVL (p_xref.source_table_id, xref.source_table_id)
         AND xref.wc_screening_request_id =
                NVL (p_xref.wc_screening_request_id,
                     xref.wc_screening_request_id
                    )
         AND req.wc_screening_request_id = xref.wc_screening_request_id
         AND req.status LIKE p_status
         AND req.status != 'Delete';


   CURSOR get_req
   IS
      SELECT   req.*
          FROM vssl.worldcheck_external_xref xref, wc_screening_request req
         WHERE xref.source_table =
                                  NVL (p_xref.source_table, xref.source_table)
           AND xref.source_table_column =
                    NVL (p_xref.source_table_column, xref.source_table_column)
           AND xref.source_table_id =
                            NVL (p_xref.source_table_id, xref.source_table_id)
           AND xref.wc_screening_request_id =
                  NVL (p_xref.wc_screening_request_id,
                       xref.wc_screening_request_id
                      )
           AND req.wc_screening_request_id = xref.wc_screening_request_id
      ORDER BY status_date DESC;

   CURSOR get_req_ows 
   IS
--      SELECT   req.*
--          FROM xwrl_requests req
--         WHERE req.source_table = p_xref.source_table
--           AND req.source_id = p_xref.source_table_id
--      ORDER BY last_update_date DESC;      
      SELECT   req.*
          FROM vssl.worldcheck_external_xref xref, xwrl_requests req
         WHERE xref.source_table =
                                  NVL (p_xref.source_table, xref.source_table)
           AND xref.source_table_column =
                    NVL (p_xref.source_table_column, xref.source_table_column)
           AND xref.source_table_id =
                            NVL (p_xref.source_table_id, xref.source_table_id)
           AND xref.wc_screening_request_id =
                  NVL (p_xref.wc_screening_request_id,
                       xref.wc_screening_request_id
                      )
           AND req.id = xref.wc_screening_request_id
           AND req.case_status != 'C'
      ORDER BY req.last_update_date DESC;


      CURSOR get_xref_ows (p_status IN VARCHAR2)
   IS
      SELECT COUNT (*)
        FROM vssl.worldcheck_external_xref xref, xwrl_requests req
       WHERE xref.source_table = NVL (p_xref.source_table, xref.source_table)
         AND xref.source_table_column =
                    NVL (p_xref.source_table_column, xref.source_table_column)
         AND xref.source_table_id =
                            NVL (p_xref.source_table_id, xref.source_table_id)
         AND xref.wc_screening_request_id =
                NVL (p_xref.wc_screening_request_id,
                     xref.wc_screening_request_id
                    )
         AND req.id = xref.wc_screening_request_id
         AND rmi_ows_common_util.case_wf_status(req.case_workflow) LIKE p_status
         AND req.case_status != 'C';

   req_record          get_req%ROWTYPE;
   req_record_ows      get_req_ows%ROWTYPE;
   total_count         NUMBER                := 0;
   pending_count       NUMBER                := 0;
   approved_count      NUMBER                := 0;
   provisional_count   NUMBER                := 0;
   rejected_count      NUMBER                := 0;

BEGIN
   -- SAURABH OWS  09-OCT-2019
   --
   IF rmi_ows_common_util.is_ows_user = 'Y'
   THEN

   OPEN get_xref_ows ('%');

      FETCH get_xref_ows
       INTO total_count;

      CLOSE get_xref_ows;

      dbms_output.put_line('total_count'||total_count);

      IF total_count = 0
      THEN
         RETURN ('NO_RECORD');
      END IF;

      OPEN get_req_ows;

      FETCH get_req_ows
       INTO req_record_ows;

      CLOSE get_req_ows;

      p_req.status_date := req_record_ows.last_update_date;
      p_req.last_updated_date := req_record_ows.last_update_date;
      p_req.wc_screening_request_id := req_record_ows.id;

      OPEN get_xref_ows ('Approved');

      FETCH get_xref_ows
       INTO approved_count;

      CLOSE get_xref_ows;

      IF approved_count = total_count
      THEN
         RETURN ('Approved');
      END IF;

      OPEN get_xref_ows ('Provisional');

      FETCH get_xref_ows
       INTO provisional_count;

      CLOSE get_xref_ows;

      IF provisional_count + approved_count = total_count
      THEN
         RETURN ('Provisional');
      END IF;

      OPEN get_xref_ows ('Pending Provisional');

      FETCH get_xref_ows
       INTO provisional_count;

      CLOSE get_xref_ows;

      IF provisional_count = total_count
      THEN
         RETURN ('Pending Provisional');
      END IF;

      OPEN get_xref_ows ('Rejected');

      FETCH get_xref_ows
       INTO rejected_count;

      CLOSE get_xref_ows;

      IF rejected_count > 0
      THEN
         RETURN ('Rejected');
      END IF;

      OPEN get_xref_ows ('Inactive');

      FETCH get_xref_ows
       INTO rejected_count;

      CLOSE get_xref_ows;

      IF rejected_count > 0
      THEN
         RETURN ('Inactive');
      END IF;

      RETURN ('Pending');

--      OPEN get_req_ows ;

--      FETCH get_req_ows
--       INTO req_record_ows;

--      CLOSE get_req_ows;

--      IF req_record_ows.id IS NULL
--      THEN 
--         RETURN ('NO_RECORD');
--      END IF;


--      p_req.status_date := TRUNC (req_record_ows.last_update_date);
--      p_req.last_updated_date := req_record_ows.last_update_date;
--      p_req.wc_screening_request_id := req_record_ows.ID;
--      
--      RETURN rmi_ows_common_util.case_wf_status_dsp (req_record_ows.case_workflow);


   ELSE
      OPEN get_xref ('%');

      FETCH get_xref
       INTO total_count;

      CLOSE get_xref;

      IF total_count = 0
      THEN
         RETURN ('NO_RECORD');
      END IF;

      OPEN get_req;

      FETCH get_req
       INTO req_record;

      CLOSE get_req;

      p_req.status_date := req_record.status_date;
      p_req.last_updated_date := req_record.last_update_date;
--SAURABH T20180620.0018 13-SEP-2018
      p_req.wc_screening_request_id := req_record.wc_screening_request_id;

      OPEN get_xref ('Approved');

      FETCH get_xref
       INTO approved_count;

      CLOSE get_xref;

      IF approved_count = total_count
      THEN
         RETURN ('Approved');
      END IF;

      OPEN get_xref ('Provisional');

      FETCH get_xref
       INTO provisional_count;

      CLOSE get_xref;

      IF provisional_count + approved_count = total_count
      THEN
         RETURN ('Provisional');
      END IF;

      OPEN get_xref ('Pending Provisional');

      FETCH get_xref
       INTO provisional_count;

      CLOSE get_xref;

      IF provisional_count = total_count
      THEN
         RETURN ('Pending Provisional');
      END IF;

      OPEN get_xref ('Rejected');

      FETCH get_xref
       INTO rejected_count;

      CLOSE get_xref;

      IF rejected_count > 0
      THEN
         RETURN ('Rejected');
      END IF;

      OPEN get_xref ('Inactive');

      FETCH get_xref
       INTO rejected_count;

      CLOSE get_xref;

      IF rejected_count > 0
      THEN
         RETURN ('Inactive');
      END IF;

      RETURN ('Pending');
   END IF;
END get_wc_status;

/* return values: APPROVED, REJECTED, PENDING, NO RECORD, PENDING PROVISIONAL, PROVISIONAL */

/* if a general entity search is done: SOURCE_TABLE, SOURCE_TABLE_COLUMN, SOURCE_TABLE_ID are filled in
then the order of status returned will be the following:
if a rejected recored exists then the overall status will be REJECTED
if a pending record exists then the overall status will be PENDING.
if no data exists then the overalll status will be NO_RECORD
if all records are approved then the status will be APPROVED

if the WC_SCREENING_REQUEST_ID is passed in then the returned value will be for that specific record
and if you are not doing a search having the WC_SCREENING_REQUEST_ID parameter then the p_req return
value is meaningless it's just the last record read */

/*
cursor get_xref is
select * from VSSL.WORLDCHECK_EXTERNAL_XREF where
SOURCE_TABLE=nvl(p_xref.SOURCE_TABLE, SOURCE_TABLE)  and
SOURCE_TABLE_COLUMN= nvl(p_xref.SOURCE_TABLE_COLUMN,SOURCE_TABLE_COLUMN)   and
SOURCE_TABLE_ID= nvl(p_xref. SOURCE_TABLE_ID,SOURCE_TABLE_ID) and
WC_SCREENING_REQUEST_ID = nvl(p_xref.WC_SCREENING_REQUEST_ID,WC_SCREENING_REQUEST_ID)
order by creation_date desc;

xref  get_xref%rowtype;

cursor get_screening_req (P_WC_SCREENING_REQUEST_ID in number)  is
select * from VSSL.WC_SCREENING_REQUEST where WC_SCREENING_REQUEST_ID=p_WC_SCREENING_REQUEST_ID;

req get_screening_req%rowtype;

ret_status VSSL.WC_SCREENING_REQUEST.status%type;

begin

ret_status:= 'NO_RECORD';

for xref in get_xref loop

p_req.WC_SCREENING_REQUEST_ID:=null;
p_req.STATUS:=null;
p_req.NAME_SCREENED:=null;
p_req.DATE_OF_BIRTH:=null;
p_req.SEX :=null;
p_req.NAME_IDENTIFIER :=null;
p_req.PASSPORT_NUMBER:=null;
p_req.ENTITY_TYPE:=null;
p_req.PASSPORT_ISSUING_COUNTRY_CODE:=null;
p_req.STATUS_UPDATED_BY:=null;
p_req.STATUS_DATE:=null;

p_xref.WC_SCREENING_REQUEST_ID := xref.WC_SCREENING_REQUEST_ID;
p_xref.WORLDCHECK_EXTERNAL_XREF_ID := xref.WORLDCHECK_EXTERNAL_XREF_ID;

open get_screening_req (xref.WC_SCREENING_REQUEST_ID);
fetch get_screening_req into req;
close get_screening_req;

if req.status in ( 'Pending', 'Legal Review','Sr. Legal Review') and upper(ret_status) in ('NO_RECORD', 'APPROVED','INACTIVE') then
ret_status:='Pending';
elsif req.status in ( 'Pending Provisional') and upper(ret_status) in ('NO_RECORD', 'APPROVED','INACTIVE') then
ret_status:='Pending Provisional';
elsif req.status = 'Rejected' and upper(ret_status) in ('NO_RECORD', 'APPROVED','PENDING')  then
ret_status:='Rejected';
elsif req.status = 'Approved' and upper(ret_status) in ('NO_RECORD', 'INACTIVE')  then
ret_status:='Approved';
elsif req.status = 'Inactive' and upper(ret_status) in ('NO_RECORD', 'INACTIVE')  then
ret_status:='Inactive';
elsif req.status = 'Provisional' and upper(ret_status) in ('NO_RECORD', 'INACTIVE')  then
ret_status:='Provisional';
ELSE
ret_status:='Pending';
end if;

p_req.WC_SCREENING_REQUEST_ID:=req.WC_SCREENING_REQUEST_ID;
p_req.STATUS:=req.STATUS;
p_req.NAME_SCREENED:=req.NAME_SCREENED;
p_req.DATE_OF_BIRTH:=req.DATE_OF_BIRTH;
p_req.SEX :=req.SEX;
p_req.NAME_IDENTIFIER :=req.NAME_IDENTIFIER;
p_req.PASSPORT_NUMBER:=req.PASSPORT_NUMBER;
p_req.ENTITY_TYPE:=req.ENTITY_TYPE;
p_req.PASSPORT_ISSUING_COUNTRY_CODE:=req.PASSPORT_ISSUING_COUNTRY_CODE;
p_req.STATUS_UPDATED_BY:=req.STATUS_UPDATED_BY;
p_req.STATUS_DATE:=req.STATUS_DATE;
-----dbms_output.put_line(ret_status||'  '||p_req.STATUS);
end loop;

return(ret_status);

end;
*/

function get_seafarer_wc_status(p_seafarer_id in number) return varchar2 is
p_xref world_check_iface.WC_EXTERNAL_XREF_REC;
p_req  world_check_iface.WC_SCREENING_REQUEST_REC;

status varchar2(30):='Pending';

begin


p_xref.SOURCE_TABLE:='SICD_SEAFARERS';
p_xref.SOURCE_TABLE_COLUMN:='SEAFARER_ID';
p_xref.SOURCE_TABLE_ID:=p_seafarer_id;

status:=world_check_iface.get_wc_status(p_xref,  p_req );
return(status);

end;



procedure query_cross_reference(p_source_table in varchar2, p_source_column in varchar2,  p_source_id in number, t_data in out screening_tab) is

cursor get_unattached is
SELECT
*
  FROM WC_SCREENING_REQUEST r
 WHERE   not exists(select 'x' from WORLDCHECK_EXTERNAL_XREF xr where  r.WC_SCREENING_REQUEST_ID = xr.WC_SCREENING_REQUEST_ID)
 order by creation_date desc;

screening_rec2  get_unattached%rowtype;

CURSOR get_screening IS
SELECT
r.*
  FROM WORLDCHECK_EXTERNAL_XREF xr, WC_SCREENING_REQUEST r
 WHERE     r.WC_SCREENING_REQUEST_ID = xr.WC_SCREENING_REQUEST_ID
       AND SOURCE_TABLE = p_source_table
       AND SOURCE_TABLE_COLUMN = p_source_column
       AND SOURCE_TABLE_ID = p_source_id
  order by r.creation_date desc;


--screening_rec get_screening%rowtype;

cursor get_alias (P_WC_SCREENING_REQUEST_ID in number) is
select NAME_SCREENED from WC_SCREENING_REQUEST where WC_SCREENING_REQUEST_ID = p_WC_SCREENING_REQUEST_ID;

alias_name VSSL.WC_SCREENING_REQUEST.NAME_SCREENED%type;
ALIAS_WC_SCREENING_REQUEST_ID VSSL.WC_SCREENING_REQUEST.ALIAS_WC_SCREENING_REQUEST_ID%type;


ii   NUMBER := 1;
name_addition VARCHAR2(315);  --T20190425.0015 VARCHAR2(100); Updated to fit large screened name plus 15 characters for text string ZK 04/25/2019

BEGIN


name_addition := null;

--dbms_output.put_line(p_source_table||' '||p_source_column||' '||to_char(p_source_id));

if p_source_id is not null then

/*   OPEN get_screening;

   LOOP
     FETCH get_screening
      INTO  screening_rec;*/

--dbms_output.put_line('before loop');

for screening_rec in  get_screening loop

--dbms_output.put_line('screen_rec loop');

ALIAS_WC_SCREENING_REQUEST_ID :=screening_rec.ALIAS_WC_SCREENING_REQUEST_ID;
t_data(ii).CITIZENSHIP_COUNTRY_CODE :=screening_rec.CITIZENSHIP_COUNTRY_CODE;
t_data(ii).CORP_RESIDENCE_COUNTRY_CODE :=screening_rec.CORP_RESIDENCE_COUNTRY_CODE;
t_data(ii).CREATED_BY :=screening_rec.CREATED_BY;
t_data(ii).CREATION_DATE :=screening_rec.CREATION_DATE;
t_data(ii).DATE_OF_BIRTH :=screening_rec.DATE_OF_BIRTH;
t_data(ii).ENTITY_TYPE :=screening_rec.ENTITY_TYPE;
t_data(ii).LAST_UPDATED_BY :=screening_rec.LAST_UPDATED_BY;
t_data(ii).LAST_UPDATED_DATE :=screening_rec.LAST_UPDATE_DATE;
t_data(ii).LAST_UPDATE_LOGIN :=screening_rec.LAST_UPDATE_LOGIN;
t_data(ii).NAME_IDENTIFIER :=screening_rec.NAME_IDENTIFIER ;
if screening_rec.ALIAS_WC_SCREENING_REQUEST_ID is null then
  name_addition:=null;
else
   alias_name:=null;
  open get_alias(screening_rec.ALIAS_WC_SCREENING_REQUEST_ID);
  fetch get_alias into alias_name;
  close get_alias;
  name_addition:='    (Alias for '||alias_name||')';
end if;

t_data(ii).NAME_SCREENED:=screening_rec.NAME_SCREENED || name_addition;
t_data(ii).NOTES:=screening_rec.NOTES;
t_data(ii).NOTIFY_USER_UPON_APPROVAL:=screening_rec.NOTIFY_USER_UPON_APPROVAL;
t_data(ii).OFAC_LIST_EDOC_ID:=screening_rec.OFAC_LIST_EDOC_ID;
t_data(ii).OFAC_LIST_IS_ENTY_ON_LIST:=screening_rec.OFAC_LIST_IS_ENTY_ON_LIST;
t_data(ii).PASSPORT_ISSUING_COUNTRY_CODE:=screening_rec.PASSPORT_ISSUING_COUNTRY_CODE;
t_data(ii).PASSPORT_NUMBER:=screening_rec.PASSPORT_NUMBER;
t_data(ii).SENT_TO_LEGAL_DATE:=screening_rec.SENT_TO_LEGAL_DATE;
t_data(ii).SEX:=screening_rec.SEX;
t_data(ii).STATUS :=screening_rec.STATUS;
t_data(ii).STATUS_DATE:=screening_rec.STATUS_DATE;
t_data(ii).STATUS_UPDATED_BY:=screening_rec.STATUS_UPDATED_BY;
t_data(ii).WC_SCREENING_REQUEST_ID:=screening_rec.WC_SCREENING_REQUEST_ID;

      ---EXIT WHEN get_screening%NOTFOUND;
      ii := ii + 1;
   END LOOP;

  ---CLOSE get_screening;
else
   OPEN get_unattached;

   LOOP
     FETCH get_unattached
      INTO screening_rec2 ;

ALIAS_WC_SCREENING_REQUEST_ID :=screening_rec2.ALIAS_WC_SCREENING_REQUEST_ID;
t_data(ii).CITIZENSHIP_COUNTRY_CODE :=screening_rec2.CITIZENSHIP_COUNTRY_CODE;
t_data(ii).CORP_RESIDENCE_COUNTRY_CODE :=screening_rec2.CORP_RESIDENCE_COUNTRY_CODE;
t_data(ii).CREATED_BY :=screening_rec2.CREATED_BY;
t_data(ii).CREATION_DATE :=screening_rec2.CREATION_DATE;
t_data(ii).DATE_OF_BIRTH :=screening_rec2.DATE_OF_BIRTH;
t_data(ii).ENTITY_TYPE :=screening_rec2.ENTITY_TYPE;
t_data(ii).LAST_UPDATED_BY :=screening_rec2.LAST_UPDATED_BY;
t_data(ii).LAST_UPDATED_DATE :=screening_rec2.LAST_UPDATE_DATE;
t_data(ii).LAST_UPDATE_LOGIN :=screening_rec2.LAST_UPDATE_LOGIN;
t_data(ii).NAME_IDENTIFIER :=screening_rec2.NAME_IDENTIFIER ;
if screening_rec2.ALIAS_WC_SCREENING_REQUEST_ID is null then
  name_addition:=null;
else
  alias_name:=null;
  open get_alias(screening_rec2.ALIAS_WC_SCREENING_REQUEST_ID);
  fetch get_alias into alias_name;
  close get_alias;
  name_addition:='    (Alias for '||alias_name||')';
end if;
t_data(ii).NAME_SCREENED:=screening_rec2.NAME_SCREENED || name_addition;
t_data(ii).NOTES:=screening_rec2.NOTES;
t_data(ii).NOTIFY_USER_UPON_APPROVAL:=screening_rec2.NOTIFY_USER_UPON_APPROVAL;
t_data(ii).OFAC_LIST_EDOC_ID:=screening_rec2.OFAC_LIST_EDOC_ID;
t_data(ii).OFAC_LIST_IS_ENTY_ON_LIST:=screening_rec2.OFAC_LIST_IS_ENTY_ON_LIST;
t_data(ii).PASSPORT_ISSUING_COUNTRY_CODE:=screening_rec2.PASSPORT_ISSUING_COUNTRY_CODE;
t_data(ii).PASSPORT_NUMBER:=screening_rec2.PASSPORT_NUMBER;
t_data(ii).SENT_TO_LEGAL_DATE:=screening_rec2.SENT_TO_LEGAL_DATE;
t_data(ii).SEX:=screening_rec2.SEX;
t_data(ii).STATUS :=screening_rec2.STATUS;
t_data(ii).STATUS_DATE:=screening_rec2.STATUS_DATE;
t_data(ii).STATUS_UPDATED_BY:=screening_rec2.STATUS_UPDATED_BY;
t_data(ii).WC_SCREENING_REQUEST_ID:=screening_rec2.WC_SCREENING_REQUEST_ID;

      EXIT WHEN get_unattached%NOTFOUND;
      ii := ii + 1;
   END LOOP;

   CLOSE get_unattached;
end if;
END;


procedure get_custom_tag_info(p_xref in world_check_iface.WC_EXTERNAL_XREF_REC, p_custom_id1 in out varchar2, p_custom_id2 in out varchar2) is

cursor get_corp_number is
select corp_number||' '||corp_name1 from corp_main where
corp_id= p_xref.source_table_id;

cursor get_official_number is
select to_char(official_number)||' '||name from vssl_vessels where vessel_pk=p_xref.source_table_id
order by status;

cursor get_account_info is
select account_number||' - '||party_name from hz_cust_accounts ca, hz_parties pty
where ca.cust_account_id=p_xref.source_table_id
and pty.party_id=ca.party_id;

cursor get_seafarer is
select  ss.seafarer_id||' - '||ss.first_name||' '||ss.last_name||' -  '||nvl(sc.country_name, 'Not Specified')
from sicd_seafarers ss, sicd_countries sc
where ss.seafarer_id=p_xref.source_table_id
and sc.country_code(+)=ss.nationality
union
select  ss.seafarer_id||' - '||ss.first_name||' '||ss.last_name||' -  '||nvl(sc.country_name, 'Not Specified')
from exsicd_seafarers_iface ss, sicd_countries sc
where ss.seafarer_id=p_xref.source_table_id
and sc.country_code(+)=ss.nationality;

cursor get_vetting is
select reg_name||'  Vetting ID '||to_char(rh.REG11_HEADER_ID) rec_name from reg11_header rh,  REG11_WORLD_CHECK rwc
where rh.REG11_HEADER_ID=rwc.REG11_HEADER_ID and
rwc.REG11_WORLD_CHECK_ID = p_xref.source_table_id;

cursor get_contacts is
select to_char(official_number)||' '||name from vssl_contacts_v
where contact_id=p_xref.source_table_id
order by status;


cursor get_nrmi is
select to_char( NRMI_CERTIFICATES_ID) req_number
from NRMI_CERTIFICATES
where NRMI_CERTIFICATES_ID = p_xref.source_table_id;

cursor get_nrmi_kp is
select to_char( NRMI_CERTIFICATES_ID) req_number
from NRMI_KNOWN_PARTIES c
where NRMI_KP_ID = p_xref.source_table_id ;

corp_number varchar2(10);

custom_str varchar2(300);
begin
if p_xref.source_table = 'CORP_MAIN' then
p_custom_id1:='Corp Number';
open get_corp_number;
fetch get_corp_number into  p_custom_id2;
close get_corp_number;
elsif p_xref.source_table = 'SICD_SEAFARERS' then
p_custom_id1:='Seafarer ID';
open get_seafarer;
fetch get_seafarer into custom_str;
p_custom_id2:=substr(custom_str,1,100);
close get_seafarer;
elsif p_xref.source_table ='VSSL_VESSELS' then
p_custom_id1:='Official Number';
open get_official_number;
fetch get_official_number into  p_custom_id2;
close get_official_number;
elsif p_xref.source_table = 'VSSL_CONTACTS_V'  then
p_custom_id1:='Contact for Official Number';
open get_contacts;
fetch get_contacts into  p_custom_id2;
close get_contacts;
elsif p_xref.source_table = 'AR_CUSTOMERS' then
p_custom_id1:='Customer Account';
open get_account_info;
fetch get_account_info into  custom_str;
p_custom_id2:=substr(custom_str,1,100);
close get_account_info;
elsif p_xref.source_table = 'REG11_WORLD_CHECK' then
p_custom_id1:='Vessel Vetting';
open get_vetting;
fetch get_vetting into  p_custom_id2;
close get_vetting;
elsif instr(p_xref.source_table, 'NRMI_CERTIFICATES') >0  then
--p_custom_id1:='NRMI Cert';                                             --     T20180103.0033  commented by SHIVI dated: 26062018
p_custom_id1:='NRMI Request';                                           --     T20180103.0033  Added by SHIVI dated: 26062018
open get_nrmi;
fetch get_nrmi into  p_custom_id2;
close get_nrmi;
elsif instr(p_xref.source_table, 'NRMI_VESSELS_KNOWN_PARTY') >0  then
p_custom_id1:='NRMI Cert - Known Party ';
open get_nrmi_KP;
fetch get_nrmi_KP into  p_custom_id2;
close get_nrmi_KP;
else
p_custom_id1:=p_xref.source_table;
p_custom_id2:=to_char( p_xref.source_table_id);
end if;
end;

procedure post_match_note(p_match_identifier in varchar2, p_note in varchar2 , p_return_code out number, p_return_message out varchar2 ) is


   l_string_request    VARCHAR2 (4000);
   l_http_request UTL_HTTP.req;
    l_response_xml xmltype;
   l_request_id number:= null;
      return_code number;
   return_message varchar2(1000);
   user_id number;
   login_id number;

   p_match_count varchar2(20);
   match_count number;
begin
   user_id:= get_userid;
   login_id := get_loginid;
l_string_request :=soap_envelope_start;
l_string_request := l_string_request || soap_header;
l_string_request := l_string_request || add_match_note(p_match_identifier, p_note);
l_string_request := l_string_request ||soap_envelope_end;
------dbms_output.put_line(l_string_request);
------dbms_output.put_line(get_world_check_matches_url);
send_request (get_world_check_matches_url  , l_string_request, l_http_request);
read_response(l_http_request, l_response_xml,return_code,  return_message) ;

p_return_code :=return_code;
p_return_message:=return_message;
end;

procedure post_match_status(p_match_identifier in varchar2,  p_status  in varchar2 ,p_note in varchar2, p_matchrisk in varchar2, p_return_code out number, p_return_message out varchar2 ) is

   l_string_request    VARCHAR2 (24000);
   l_http_request UTL_HTTP.req;
    l_response_xml xmltype;
   l_request_id number:= null;
      return_code number;
   return_message varchar2(1000);
   user_id number;
   login_id number;

   p_match_count varchar2(20);
   match_count number;



begin
   user_id:= get_userid;
   login_id := get_loginid;



if p_status not in ( c_initial_screen, c_false_match, c_possible_match, c_positive_match, c_new,c_unspecified_match) then
p_return_code :=-1;
p_return_message:='Invalid Status Code';
return;
end if;

if p_matchrisk not in ('HIGH','LOW','MEDIUM','UNKNOWN') then
p_return_code :=-1;
p_return_message:='Invalid Match Risk';
return;
end if;


l_string_request :=soap_envelope_start;
l_string_request := l_string_request || soap_header;
l_string_request := l_string_request || add_match_status(p_match_identifier,  p_status, p_note||' ('||get_username_propername(get_userid)||')',  p_matchrisk);
l_string_request := l_string_request ||soap_envelope_end;
------dbms_output.put_line(l_string_request);
------dbms_output.put_line(get_world_check_matches_url);
send_request (get_world_check_matches_url  , l_string_request, l_http_request);
------dbms_output.put_line('after send request');
read_response(l_http_request, l_response_xml,return_code,  return_message) ;
------dbms_output.put_line('after read response');
p_return_code :=return_code;
p_return_message:='world_check_iface.post_match_status '||return_message;

end;


procedure post_saveForOngoingScreening(p_name_identifier in varchar2, p_return_code out number, p_return_message out varchar2 ) is

   l_string_request    VARCHAR2 (4000);
   l_http_request UTL_HTTP.req;
    l_response_xml xmltype;
   l_request_id number:= null;
      return_code number;
   return_message varchar2(1000);
   user_id number;
   login_id number;

   p_match_count varchar2(20);
   match_count number;



begin
   user_id:= get_userid;
   login_id := get_loginid;
l_string_request :=soap_envelope_start;
l_string_request := l_string_request || soap_header;
l_string_request := l_string_request || saveForOngoingScreening(p_name_identifier );
l_string_request := l_string_request ||soap_envelope_end;
------dbms_output.put_line(l_string_request);
------dbms_output.put_line(get_world_check_matches_url);
send_request (get_world_check_name_url  , l_string_request, l_http_request);
read_response(l_http_request, l_response_xml,return_code,  return_message) ;

p_return_code :=return_code;
p_return_message:=return_message;
end;

function has_name_been_checked_before(p_name_identifier in varchar2, t_data in out world_check_iface.screening_tab ) return varchar2 is
retval varchar2(1) :='N';

cursor find_screening_requests is
SELECT
CREATED_BY,
CREATION_DATE,
DATE_OF_BIRTH,
ENTITY_TYPE,
LAST_UPDATED_BY,
LAST_UPDATE_DATE,
LAST_UPDATE_LOGIN,
NAME_IDENTIFIER,
NAME_SCREENED,
NOTES,
OFAC_LIST_EDOC_ID,
OFAC_LIST_IS_ENTY_ON_LIST,
PASSPORT_ISSUING_COUNTRY_CODE,
PASSPORT_NUMBER,
SEX,
STATUS,
STATUS_DATE,
STATUS_UPDATED_BY,
WC_SCREENING_REQUEST_ID
FROM APPS.WC_SCREENING_REQUEST_V
where utl_match.jaro_winkler_similarity(NAME_SCREENED,p_name_identifier)>trade_compliance.match_threshold
order by utl_match.jaro_winkler_similarity(NAME_SCREENED,p_name_identifier) desc;

ii   NUMBER := 1;

BEGIN

if t_data.count>0 then
  t_data.delete;
 end if;

 OPEN find_screening_requests;

   LOOP
     FETCH find_screening_requests
      INTO
t_data(ii).CREATED_BY,
t_data(ii).CREATION_DATE,
t_data(ii).DATE_OF_BIRTH,
t_data(ii).ENTITY_TYPE,
t_data(ii).LAST_UPDATED_BY,
t_data(ii).LAST_UPDATED_DATE,
t_data(ii).LAST_UPDATE_LOGIN,
t_data(ii).NAME_IDENTIFIER,
t_data(ii).NAME_SCREENED,
t_data(ii).NOTES,
t_data(ii).OFAC_LIST_EDOC_ID,
t_data(ii).OFAC_LIST_IS_ENTY_ON_LIST,
t_data(ii).PASSPORT_ISSUING_COUNTRY_CODE,
t_data(ii).PASSPORT_NUMBER,
t_data(ii).SEX,
t_data(ii).STATUS,
t_data(ii).STATUS_DATE,
t_data(ii).STATUS_UPDATED_BY,
t_data(ii).WC_SCREENING_REQUEST_ID;

      EXIT WHEN find_screening_requests%NOTFOUND;
      ii := ii + 1;
   END LOOP;

   CLOSE find_screening_requests;

if t_data.count=0 then
  retval:='N';
  else
  retval :='Y';
 end if;

return retval;
END;

procedure get_context(p_wc_screening_request_id in number, xrefs in out world_check_iface.xref_tab) is

cursor get_xrefs is
SELECT
WORLDCHECK_EXTERNAL_XREF_ID, WC_SCREENING_REQUEST_ID, SOURCE_TABLE,
   SOURCE_TABLE_ID, SOURCE_TABLE_COLUMN, SOURCE_TABLE_STATUS_COLUMN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY,
   LAST_UPDATE_DATE, LAST_UPDATE_LOGIN
FROM VSSL.WORLDCHECK_EXTERNAL_XREF where
WC_SCREENING_REQUEST_ID = p_wc_screening_request_id
order by  SOURCE_TABLE;

ii   NUMBER := 1;

BEGIN

/*
 OPEN get_xrefs;

   LOOP
     FETCH get_xrefs
      INTO
          xrefs(ii).WORLDCHECK_EXTERNAL_XREF_ID,
          xrefs(ii).WC_SCREENING_REQUEST_ID,
          xrefs(ii).SOURCE_TABLE,
          xrefs(ii).SOURCE_TABLE_ID,
          xrefs(ii).SOURCE_TABLE_COLUMN,
          xrefs(ii).SOURCE_TABLE_STATUS_COLUMN,
          xrefs(ii).CREATED_BY,
          xrefs(ii).CREATION_DATE,
          xrefs(ii).LAST_UPDATED_BY,
          xrefs(ii).LAST_UPDATE_DATE,
          xrefs(ii).LAST_UPDATE_LOGIN;

      EXIT WHEN get_xrefs%NOTFOUND;

   END LOOP;

   CLOSE get_xrefs;


   */

   for x in get_xrefs loop
          xrefs(ii).WORLDCHECK_EXTERNAL_XREF_ID:=X.WORLDCHECK_EXTERNAL_XREF_ID ;
          xrefs(ii).WC_SCREENING_REQUEST_ID:=X.WORLDCHECK_EXTERNAL_XREF_ID ;
          xrefs(ii).SOURCE_TABLE:=X.SOURCE_TABLE ;
          xrefs(ii).SOURCE_TABLE_ID:=X.SOURCE_TABLE_ID ;
          xrefs(ii).SOURCE_TABLE_COLUMN:=X.SOURCE_TABLE_COLUMN ;
          xrefs(ii).SOURCE_TABLE_STATUS_COLUMN:=X.SOURCE_TABLE_STATUS_COLUMN ;
          xrefs(ii).CREATED_BY:=X.CREATED_BY ;
          xrefs(ii).CREATION_DATE:=X.CREATION_DATE ;
          xrefs(ii).LAST_UPDATED_BY:=X.LAST_UPDATED_BY ;
          xrefs(ii).LAST_UPDATE_DATE:=X.LAST_UPDATE_DATE ;
          xrefs(ii).LAST_UPDATE_LOGIN:=X.LAST_UPDATE_LOGIN ;
   ii := ii + 1;
   end loop;

END;

procedure create_tree_table (P_NAME_SCREENED in varchar2,  tree_rec in out xref_tree_tab) is
  RetVal VARCHAR2(32767);
  P_NAME_IDENTIFIER VARCHAR2(32767);
  T_DATA WORLD_CHECK_IFACE.screening_tab;
  x_ref_data WORLD_CHECK_IFACE.xref_tab;
  comment1 varchar2(100);
  comment2 varchar2(100);
  node_id number:=0;
  parent_node number;

  passport_ref varchar2(100);

BEGIN
if  tree_rec.count>0 then
   tree_rec.delete;
 end if;

  RetVal := HAS_NAME_BEEN_CHECKED_BEFORE ( P_NAME_SCREENED, T_DATA );
  if RetVal != 'N' then

  for x in 1..t_data.count loop

    node_id:=node_id+1;

    --- Added By Gopi Vella For Help Desk Ticket T20171012.0020 on 12-OCT-2017
    x_ref_data.delete;
    --- End Code Change

    ------dbms_output.put_line('Node_id ='||to_char(node_id)||' '||T_DATA(x).NAME_SCREENED);
    tree_rec(node_id).WC_SCREENING_REQUEST_ID:=T_DATA(x).WC_SCREENING_REQUEST_ID;
    tree_rec(node_id).MATCH_SCORE:=utl_match.jaro_winkler_similarity(T_DATA(x).NAME_SCREENED,P_NAME_SCREENED);
    if T_DATA(x).ENTITY_TYPE = c_INDIVIDUAL then
    if T_DATA(x).PASSPORT_NUMBER is not null then
    passport_ref :=' ID Number: '||T_DATA(x).PASSPORT_NUMBER;
    else
    passport_ref := null;
    end if;

    tree_rec(node_id).NAME_SCREENED:=T_DATA(x).NAME_SCREENED||' ('||to_char(tree_rec(node_id).MATCH_SCORE)||'%)'||' DOB - '||to_char(T_DATA(x).DATE_OF_BIRTH,'DD-MON-RR')||passport_ref;
    else
    tree_rec(node_id).NAME_SCREENED:=T_DATA(x).NAME_SCREENED||' ('||to_char(tree_rec(node_id).MATCH_SCORE)||'%)';
    end if;
    tree_rec(node_id).PARENT_NODE_ID:=1;
    tree_rec(node_id).NODE_ID:=node_id;
    --parent_node:=tree_rec(node_id).NODE_ID;
    parent_node:=2;
    tree_rec(node_id).REFERENCE_DESCRIPTION:=null;
    tree_rec(node_id).WORLDCHECK_EXTERNAL_XREF_ID:=null;
    get_context(T_DATA(x).WC_SCREENING_REQUEST_ID, x_ref_data);
    if x_ref_data.count > 0 then
    for y in 1..x_ref_data.count loop
    node_id:=node_id+1;
    get_custom_tag_info(x_ref_data(y), comment1, comment2);
    tree_rec(node_id).WC_SCREENING_REQUEST_ID:=T_DATA(x).WC_SCREENING_REQUEST_ID;
    tree_rec(node_id).NAME_SCREENED:=null;
    tree_rec(node_id).MATCH_SCORE:=null;
    tree_rec(node_id).PARENT_NODE_ID:=parent_node;
    tree_rec(node_id).NODE_ID:=node_id;
    tree_rec(node_id).REFERENCE_DESCRIPTION:=Comment1||' '||comment2;
    tree_rec(node_id).WORLDCHECK_EXTERNAL_XREF_ID:=x_ref_data(Y).WORLDCHECK_EXTERNAL_XREF_ID;
    end loop;
   else
   node_id:=node_id+1;
    tree_rec(node_id).WC_SCREENING_REQUEST_ID:=T_DATA(x).WC_SCREENING_REQUEST_ID;
    tree_rec(node_id).NAME_SCREENED:=null;
    tree_rec(node_id).MATCH_SCORE:=null;
    tree_rec(node_id).PARENT_NODE_ID:=parent_node;
    tree_rec(node_id).NODE_ID:=node_id;
    tree_rec(node_id).REFERENCE_DESCRIPTION:='This name is not referenced';
    tree_rec(node_id).WORLDCHECK_EXTERNAL_XREF_ID:=0;
   end if;
  end loop;
  end if;
   END;

procedure create_xref_tree_table (P_WC_SCREENING_REQUEST_ID in number,  tree_rec in out xref_tree_tab) is
  RetVal VARCHAR2(32767);
  P_NAME_IDENTIFIER VARCHAR2(32767);
  x_ref_data WORLD_CHECK_IFACE.xref_tab;
  comment1 varchar2(100):=null;
  comment2 varchar2(100):=null;
  node_id number:=0;
  parent_node number;

BEGIN
   parent_node:=1;
   if  tree_rec.count>0 then
   tree_rec.delete;
   end if;
    get_context(P_WC_SCREENING_REQUEST_ID, x_ref_data);
    for y in 1..x_ref_data.count loop
    comment1:=null;
    comment2:=null;
    node_id:=node_id+1;
    get_custom_tag_info(x_ref_data(y), comment1, comment2);
    tree_rec(node_id).WC_SCREENING_REQUEST_ID:=x_ref_data(Y).WC_SCREENING_REQUEST_ID;
    tree_rec(node_id).NAME_SCREENED:=null;
    tree_rec(node_id).MATCH_SCORE:=null;
    tree_rec(node_id).PARENT_NODE_ID:=parent_node;
    tree_rec(node_id).NODE_ID:=node_id;
    tree_rec(node_id).REFERENCE_DESCRIPTION:=Comment1||' '||comment2;
    tree_rec(node_id).WORLDCHECK_EXTERNAL_XREF_ID:=x_ref_data(Y).WORLDCHECK_EXTERNAL_XREF_ID;
    end loop;
end;

function get_requesting_department(P_WC_SCREENING_REQUEST_ID in number) return varchar2 is

cursor get_xref is
select * from WORLDCHECK_EXTERNAL_XREF
where WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID
order by CREATION_DATE desc ;

cursor get_cra(p_seafarer_id in number) is
select count(*) from sicd_documents where seafarer_id = p_seafarer_id
and nvl(certificate_type,'xx') in ('CRA','UA') and status='Pending';

cursor get_external_cra(p_seafarer_id in number) is
select count(*) from exsicd_seafarers_iface s, exsicd_seafarer_docs_iface esd
where esd.esi_id=s.esi_id and esd.cra_required='Y' and esd.CRA_APPROVED_DATE is not null and esd.grading_status !='Rejected' and
not exists(select 'x' from sicd_documents sd where sd.grade_id=esd.grade_id and sd.creation_date >= esd.CRA_APPROVED_DATE and nvl(sd.certificate_type,'xx') in ('CRA','UA') and seafarer_id=s.seafarer_id)
and s.seafarer_id=p_seafarer_id;

cursor get_inspector(p_inspector_id in number) is
select Name from insp_inspectors
where inspector_id=p_inspector_id;


cursor get_nrmi is
select to_char(source_table_id) req_number
from NRMI_CERTIFICATES, WORLDCHECK_EXTERNAL_XREF x
where NRMI_CERTIFICATES_ID = x.source_table_id
and x.source_table =  'NRMI_CERTIFICATES'
and x.WC_SCREENING_REQUEST_ID =  P_WC_SCREENING_REQUEST_ID;


insp_name varchar2(240);

nof_doc number:=0;

p_xref get_xref%rowtype;
dept varchar2(50);

/* Formatted on 7/7/2014 10:39:17 AM (QP5 v5.163.1008.3004) */
BEGIN
   OPEN get_xref;

   FETCH get_xref INTO p_xref;

   CLOSE get_xref;

   IF p_xref.source_table = 'CORP_MAIN'
   THEN
      dept := 'Corporate';
   ELSIF p_xref.source_table = 'SICD_SEAFARERS'
   THEN
      OPEN get_cra (p_xref.SOURCE_TABLE_ID);

      FETCH get_cra INTO nof_doc;

      CLOSE get_cra;

      IF nof_doc > 0
      THEN
         dept :=
               'Seafarers (CRA/UA) Paper (FIN: '
            || TO_CHAR (p_xref.SOURCE_TABLE_ID)
            || ')';
      ELSE
         OPEN get_external_cra (p_xref.SOURCE_TABLE_ID);

         FETCH get_external_cra INTO nof_doc;

         CLOSE get_external_cra;

         IF nof_doc > 0
         THEN
            dept :=
                  'Seafarers (CRA/UA) Online (FIN: '
               || TO_CHAR (p_xref.SOURCE_TABLE_ID)
               || ')';
         ELSE
            dept :=
               'Seafarers (FIN: ' || TO_CHAR (p_xref.SOURCE_TABLE_ID) || ')';
         END IF;
      END IF;
   ELSIF p_xref.source_table = 'VSSL_VESSELS'
   THEN
      dept := 'Vessel';
   ELSIF p_xref.source_table = 'VSSL_CONTACTS_V'
   THEN
      dept := 'Vessel';
   ELSIF p_xref.source_table = 'REG11_HEADER'
   THEN
      dept := 'Vessel Reg.';
   ELSIF p_xref.source_table = 'AR_CUSTOMERS'
   THEN
      dept := 'Customer';
   ELSIF p_xref.source_table = 'INSP_INSPECTORS'
   THEN
      open get_inspector(p_xref.SOURCE_TABLE_ID);
      fetch get_inspector into insp_name;
      close get_inspector;
       dept := substr('Inspectors '||insp_name,1,50);
   elsif  instr(p_xref.source_table, 'NRMI') >0 then
          --  dept := 'Non-RMI Cert';                                    -- T20180103.0033  commented by SHIVI dated: 26062018
          dept := 'Non-RMI Request';                                 -- T20180103.0033  Added by SHIVI dated: 26062018
 open get_nrmi;
fetch get_nrmi into  insp_name;
close get_nrmi;
  --dept := 'Non-RMI Cert - '||insp_name;                      --T20180103.0033  commented by SHIVI dated: 26062018
  dept := 'Non-RMI Request - '||insp_name;                   -- T20180103.0033  Added by SHIVI dated: 26062018

   ELSE
      --dept:=p_xref.source_table;
      dept := 'Unknown';
   END IF;

   RETURN dept;
END;


procedure refresh_wc_matches(p_WC_SCREENING_REQUEST_ID in number,p_return_code out varchar, p_ret_msg out varchar2) is


/* p_return_code  =
SUCCESS,
ERROR_CREATING_WC
SEAFARER_NOT_FOUND
SQLERROR

*/

return_code  number;
return_message varchar2(250);


cursor get_request_info(p_WC_SCREENING_REQUEST_ID in number) is
select * from WC_SCREENING_REQUEST where WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID;

scrrqst get_request_info%rowtype;

cursor get_WC_MATCHES(p_WC_SCREENING_REQUEST_ID in number) is
select * from WC_MATCHES where WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID;

mtch get_WC_MATCHES%rowtype;
old_number_of_matches number:=0;
new_number_of_matches number:=0;
location_msg varchar2(100):=' refresh_wc_matches:';
msg varchar2(100);
auto_approved boolean :=false;
-- T20180410.0005 SAURABH 25-APR-2018
l_status VARCHAR2(30) := 'Pending';

begin
------dbms_output.put_line ( 'start');
 p_ret_msg:='Normal';
p_return_code := 'SUCCESS';

open get_request_info(p_WC_SCREENING_REQUEST_ID);
fetch get_request_info into scrrqst;
close get_request_info;

/******* lwan temp change back 10/11/2016
----/* mt 10/8/16 */

----if scrrqst.status='Approved' /* is the current tc approved */
----and (sysdate - scrrqst.status_date) <4 /* was it approved in the last 4 days */
------and iri_security.authorize_UID('WORLD_CHECK_APPROVERS',get_userid)='Y' /* was it approved by a memeber of trade */
----then

----null; /* do nothing */

----else /* revet it */
----***********/

open get_WC_MATCHES(scrrqst.WC_SCREENING_REQUEST_ID);
fetch get_WC_MATCHES into mtch;
close get_WC_MATCHES;

old_number_of_matches:=mtch.NUMBER_OF_MATCHES;

delete from wc_matches where WC_SCREENING_REQUEST_ID = p_WC_SCREENING_REQUEST_ID;
commit;

INSERT INTO VSSL.WC_REQUEST_APPROVAL_HISTORY (
   WC_REQUEST_APPROVAL_HISTORY_ID, WC_SCREENING_REQUEST_ID, STATUS,
   STATUS_DATE, STATUS_UPDATED_BY, CREATED_BY,
   CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
   LAST_UPDATE_LOGIN)
VALUES ( null /* WC_REQUEST_APPROVAL_HISTORY_ID */,
scrrqst.WC_SCREENING_REQUEST_ID /* WC_SCREENING_REQUEST_ID */,
'Re-Vetted' /* STATUS */,
sysdate /* STATUS_DATE */,
get_userid/* STATUS_UPDATED_BY */,
get_userid /* CREATED_BY */,
sysdate /* CREATION_DATE */,
get_userid /* LAST_UPDATED_BY */,
sysdate/* LAST_UPDATE_DATE */,
get_loginid /* LAST_UPDATE_LOGIN */ );


process_name_matches(scrrqst.name_identifier,scrrqst.WC_SCREENING_REQUEST_ID ,return_code, p_ret_msg);
msg:= 'process_name_matches ';

dbms_output.put_line ('Return Code: '||return_code);
if return_code = 200 then
   ----dbms_output.put_line ('1');
   open get_WC_MATCHES(scrrqst.WC_SCREENING_REQUEST_ID);
   ----dbms_output.put_line ('2');
   fetch get_WC_MATCHES into mtch;
   ----dbms_output.put_line ('3');
   close get_WC_MATCHES;
   msg:='--# of matches = '||to_char(mtch.NUMBER_OF_MATCHES);
   --dbms_output.put_line (msg);
   if mtch.NUMBER_OF_MATCHES >0 
   then
      new_number_of_matches:=mtch.NUMBER_OF_MATCHES;
      ----dbms_output.put_line ('4');


      for x in  get_WC_MATCHES(scrrqst.WC_SCREENING_REQUEST_ID) 
      loop
         populate_match_details( x.WC_MATCHES_ID , mtch.WC_MATCHES_ID,return_code, p_ret_msg);
      end loop;

      msg:= 'populate_match_details * ' ||to_char(return_code) || p_ret_msg;
      --dbms_output.put_line (msg);
      /* double check to see if any matches still exist if not then approve the world check request */
      open get_WC_MATCHES(scrrqst.WC_SCREENING_REQUEST_ID);
      fetch get_WC_MATCHES into mtch;
      close get_WC_MATCHES;

     if mtch.NUMBER_OF_MATCHES =0 
     then /* number of matches just queried */
        ----dbms_output.put_line ( 'mtch.NUMBER_OF_MATCHES '  ||to_char(mtch.NUMBER_OF_MATCHES));
        -- T20180410.0005 SAURABH 25-APR-2018
        --approve_screening_request(scrrqst.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
        auto_approved := approve_screening_request(scrrqst.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
        world_check_iface.push_status_to_creator(scrrqst.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
        -- T20180410.0005 SAURABH 25-APR-2018
        --auto_approved:=TRUE;
        l_status := 'Legal Review';
        ----dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
     elsif world_check_iface.can_revetting_be_autoapproved(scrrqst.WC_SCREENING_REQUEST_ID) = 'Y' then
        ----dbms_output.put_line ( 'mtch.NUMBER_OF_MATCHES '  ||to_char(mtch.NUMBER_OF_MATCHES));
        -- T20180410.0005 SAURABH 25-APR-2018
        --approve_screening_request(scrrqst.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
        auto_approved := approve_screening_request(scrrqst.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
        world_check_iface.push_status_to_creator(scrrqst.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
        -- T20180410.0005 SAURABH 25-APR-2018
        --auto_approved:=TRUE;
        l_status := 'Legal Review';
     end if;
     ----dbms_output.put_line ( 'can_revetting_be_autoapproved'  ||world_check_iface.can_revetting_be_autoapproved(scrrqst.WC_SCREENING_REQUEST_ID));


   else
      ----dbms_output.put_line ('5');
      -- T20180410.0005 SAURABH 25-APR-2018
      --approve_screening_request(scrrqst.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
      auto_approved :=approve_screening_request(scrrqst.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
      ----dbms_output.put_line ('6');
      push_status_to_creator(scrrqst.WC_SCREENING_REQUEST_ID,return_code, p_ret_msg);
      -- T20180410.0005 SAURABH 25-APR-2018
        --auto_approved:=TRUE;
        l_status := 'Legal Review';
      ----dbms_output.put_line ( 'push_status_to_creator ' ||to_char(return_code) || p_ret_msg);
   end if;

else
   INSERT INTO VSSL.WORLD_CHECK_COMM_ERROR_LOG (
      ERROR_LOG_ID, MATCH_IDENTIFIER, WEBSERVICE_IDENTIFIER,
      ERROR_DATE_TIME, ERROR_CODE, ERROR_MESSAGE)
   VALUES ( null /* ERROR_LOG_ID */,
   'Process Name Matches - WC_MATCHES_ID =' /* MATCH_IDENTIFIER */,
   'Matches' /* WEBSERVICE_IDENTIFIER */,
    sysdate /* ERROR_DATE_TIME */,
    to_char(return_code)  /* ERROR_CODE */,
    p_ret_msg /* ERROR_MESSAGE */ );
    commit;
end if;
----dbms_output.put_line ( ' old_number_of_matches ='||to_char( old_number_of_matches )|| '  '||'new_number_of_matches ='||to_char(new_number_of_matches));
--if old_number_of_matches  <> new_number_of_matches then


if not auto_approved then  /* if we were not able to auto approve it then be sure it is pending */
----dbms_output.put_line ('setting it back to pending');
update  WC_SCREENING_REQUEST
-- T20180410.0005 SAURABH 25-APR-2018
--set status ='Pending',
set status =l_status,
last_update_date = sysdate,
--STATUS_DATE = null,
-- T20180410.0005 SAURABH 25-APR-2018
STATUS_DATE = decode(l_status,'Pending',null, sysdate),
last_updated_by =get_userid
where WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID;
commit;
end if;
--end if;
----dbms_output.put_line ( 'end');

-----end if;

exception
when others then
p_return_code := 'SQLERROR';
p_ret_msg :=sqlerrm||location_msg||msg;

if get_request_info%ISOPEN then
 close get_request_info ;
end if;
if get_WC_MATCHES%ISOPEN then
 close get_WC_MATCHES;
 end if;



end;


procedure refresh_all_related_tc(xref in world_check_iface.WC_EXTERNAL_XREF_REC, p_return_code out varchar, p_ret_msg out varchar2) is

cursor get_related_recs is
select * from WORLDCHECK_EXTERNAL_XREF where
SOURCE_TABLE = xref.SOURCE_TABLE
and SOURCE_TABLE_COLUMN = xref.SOURCE_TABLE_COLUMN
and SOURCE_TABLE_ID = xref.SOURCE_TABLE_ID;

begin

----dbms_output.put_line(xref.SOURCE_TABLE||' '|| xref.SOURCE_TABLE||' '||to_char(xref.SOURCE_TABLE_ID));

for x in get_related_recs loop
----dbms_output.put_line(to_char(x.WC_SCREENING_REQUEST_ID));
WORLD_CHECK_IFACE.REFRESH_WC_MATCHES ( x.WC_SCREENING_REQUEST_ID, P_RETURN_CODE, P_RET_MSG );
if P_RETURN_CODE != 'SUCCESS' then
 p_return_code :='ERROR';
 p_ret_msg := 'Error Refreshing Match contents';
 exit;
end if;
end loop;

end;


procedure rerun_populate_match_details(p_WC_SCREENING_REQUEST_ID in number,p_return_code out varchar, p_ret_msg out varchar2) is


/* p_return_code  =
SUCCESS,
ERROR_CREATING_WC
SEAFARER_NOT_FOUND
SQLERROR

*/

return_code  number;
return_message varchar2(250);


cursor get_request_info(p_WC_SCREENING_REQUEST_ID in number) is
select * from WC_SCREENING_REQUEST where WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID;

scrrqst get_request_info%rowtype;

cursor get_WC_MATCHES(p_WC_SCREENING_REQUEST_ID in number) is
select * from WC_MATCHES where WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID;

mtch get_WC_MATCHES%rowtype;
old_number_of_matches number:=0;
new_number_of_matches number:=0;
location_msg varchar2(100):=' refresh_wc_matches:';
msg varchar2(100);

begin

------dbms_output.put_line ( 'start');
 p_ret_msg:='Normal';
p_return_code := 'SUCCESS';

open get_request_info(p_WC_SCREENING_REQUEST_ID);
fetch get_request_info into scrrqst;
close get_request_info;

open get_WC_MATCHES(scrrqst.WC_SCREENING_REQUEST_ID);
fetch get_WC_MATCHES into mtch;
close get_WC_MATCHES;

old_number_of_matches:=mtch.NUMBER_OF_MATCHES;

msg:= 'process_name_matches ';
----dbms_output.put_line ('1');
open get_WC_MATCHES(scrrqst.WC_SCREENING_REQUEST_ID);
----dbms_output.put_line ('2');
fetch get_WC_MATCHES into mtch;
----dbms_output.put_line ('3');
close get_WC_MATCHES;
msg:='# of matches = '||to_char(mtch.NUMBER_OF_MATCHES);
if mtch.NUMBER_OF_MATCHES >0 then
new_number_of_matches:=mtch.NUMBER_OF_MATCHES;
----dbms_output.put_line ('4');
end if;


for x in  get_WC_MATCHES(scrrqst.WC_SCREENING_REQUEST_ID) loop

populate_match_details( x.WC_MATCHES_ID , mtch.WC_MATCHES_ID,return_code, p_ret_msg);
end loop;
msg:= 'populate_match_details ' ||to_char(return_code) || p_ret_msg;
/* double check to see if any matches still exist if not then approve the world check request */
----dbms_output.put_line ( 'end');
exception
when others then
p_return_code := 'SQLERROR';
p_ret_msg :=sqlerrm||location_msg||msg;

if get_request_info%ISOPEN then
 close get_request_info ;
end if;
if get_WC_MATCHES%ISOPEN then
 close get_WC_MATCHES;
 end if;




end;

procedure delete_screening_request(p_screening_request_id in number, return_code out number, return_message out varchar2) is

cursor get_matches(p_screening_request_id in number)
is select * from WC_MATCHES_v where wc_screening_request_id = p_screening_request_id;

cursor get_screening_request is
select name_identifier from WC_SCREENING_REQUEST where WC_SCREENING_REQUEST_ID=p_screening_request_id;

p_name_identifier WC_SCREENING_REQUEST.NAME_IDENTIFIER%type;

begin
open get_screening_request;
fetch get_screening_request into p_name_identifier;
close get_screening_request;

if p_name_identifier is not null then
process_delete_screening(p_name_identifier, return_code, return_message);
if return_code = 200 then
begin
for x in get_matches(p_screening_request_id)  loop
delete from WC_CONTENT where wc_matches_id=x.wc_matches_id;
end loop;
delete from WC_MATCHES where wc_screening_request_id = p_screening_request_id;
delete from WC_REQUEST_DOCUMENTS WHERE   WC_SCREENING_REQUEST_ID = p_screening_request_id;
delete from WC_REQUEST_APPROVAL_HISTORY where  WC_SCREENING_REQUEST_ID = p_screening_request_id;
delete from WC_SCREENING_REQUEST where wc_screening_request_id =p_screening_request_id;
commit;
exception when others then
raise_application_error(-20030,'Unable to delete Screening '||sqlerrm);
end;
end if;
end if;
end;

procedure synchronize_alias_matches(p_screening_request_id in number, return_code out number, return_message out varchar2) is
/* this procedure will synchronize the matches between aliases if the match has been set to false */

cursor get_related_reqs(P_WC_SCREENING_REQUEST_ID in number) is
select p.WC_SCREENING_REQUEST_ID from  WC_SCREENING_REQUEST p
where p.WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID
union
select a.WC_SCREENING_REQUEST_ID from WC_SCREENING_REQUEST p, WC_SCREENING_REQUEST a
where p.WC_SCREENING_REQUEST_ID(+) = a.ALIAS_WC_SCREENING_REQUEST_ID
and a.ALIAS_WC_SCREENING_REQUEST_ID =  P_WC_SCREENING_REQUEST_ID
union
select p.WC_SCREENING_REQUEST_ID from WC_SCREENING_REQUEST p, WC_SCREENING_REQUEST a, WC_SCREENING_REQUEST s
where s.WC_SCREENING_REQUEST_ID(+) = a.ALIAS_WC_SCREENING_REQUEST_ID
and s.WC_SCREENING_REQUEST_ID =  p.ALIAS_WC_SCREENING_REQUEST_ID
and a.WC_SCREENING_REQUEST_ID =  P_WC_SCREENING_REQUEST_ID
union
select s.WC_SCREENING_REQUEST_ID from WC_SCREENING_REQUEST p, WC_SCREENING_REQUEST a, WC_SCREENING_REQUEST s
where s.WC_SCREENING_REQUEST_ID(+) = a.ALIAS_WC_SCREENING_REQUEST_ID
and s.WC_SCREENING_REQUEST_ID =  p.ALIAS_WC_SCREENING_REQUEST_ID
and a.WC_SCREENING_REQUEST_ID =  P_WC_SCREENING_REQUEST_ID;

cursor get_contents_source (P_WC_SCREENING_REQUEST_ID in number, P_MATCHSTATUS in varchar2) is
select distinct  MATCHENTITYIDENTIFIER,MATCHSTATUS,notes, last_updated_by, last_update_date,NM_NAME  ,
NM_DOB_AGE,
NM_SEX,
NM_DEAD  ,
NM_VISUAL ,
NM_FATHER_NAME,
NM_IMO_NUMBER, NM_CNNM from WC_CONTENT
where WC_MATCHES_ID in (
select WC_MATCHES_ID from wc_matches_v where WC_SCREENING_REQUEST_ID in (
select WC_SCREENING_REQUEST_ID from WC_SCREENING_REQUEST p
where p.WC_SCREENING_REQUEST_ID in (select p.WC_SCREENING_REQUEST_ID from  WC_SCREENING_REQUEST p
where p.WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID
union
select a.WC_SCREENING_REQUEST_ID from WC_SCREENING_REQUEST p, WC_SCREENING_REQUEST a
where p.WC_SCREENING_REQUEST_ID(+) = a.ALIAS_WC_SCREENING_REQUEST_ID
and a.ALIAS_WC_SCREENING_REQUEST_ID =  P_WC_SCREENING_REQUEST_ID
union
select p.WC_SCREENING_REQUEST_ID from WC_SCREENING_REQUEST p, WC_SCREENING_REQUEST a, WC_SCREENING_REQUEST s
where s.WC_SCREENING_REQUEST_ID(+) = a.ALIAS_WC_SCREENING_REQUEST_ID
and s.WC_SCREENING_REQUEST_ID =  p.ALIAS_WC_SCREENING_REQUEST_ID
and a.WC_SCREENING_REQUEST_ID =  P_WC_SCREENING_REQUEST_ID
union
select s.WC_SCREENING_REQUEST_ID from WC_SCREENING_REQUEST p, WC_SCREENING_REQUEST a, WC_SCREENING_REQUEST s
where s.WC_SCREENING_REQUEST_ID(+) = a.ALIAS_WC_SCREENING_REQUEST_ID
and s.WC_SCREENING_REQUEST_ID =  p.ALIAS_WC_SCREENING_REQUEST_ID
and a.WC_SCREENING_REQUEST_ID =  P_WC_SCREENING_REQUEST_ID)))
and MATCHSTATUS = P_MATCHSTATUS
--and notes is not null
order by MATCHENTITYIDENTIFIER;

cursor get_contents_dest_not_false (P_WC_SCREENING_REQUEST_ID in number) is
select wc_content_id,  MATCHENTITYIDENTIFIER,MATCHSTATUS,notes, last_updated_by, last_update_date from WC_CONTENT
where WC_MATCHES_ID in (
select WC_MATCHES_ID from wc_matches_v where WC_SCREENING_REQUEST_ID in (
select WC_SCREENING_REQUEST_ID from WC_SCREENING_REQUEST p
where p.WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID or ALIAS_WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID))
and MATCHSTATUS in (world_check_iface.c_positive_match,
world_check_iface.c_possible_match,
world_check_iface.c_initial_screen,
world_check_iface.c_new,
world_check_iface.c_unspecified_match)
for update;

cursor get_contents_dest_not_posit (P_WC_SCREENING_REQUEST_ID in number) is
select wc_content_id,  MATCHENTITYIDENTIFIER,MATCHSTATUS,notes, last_updated_by, last_update_date from WC_CONTENT
where WC_MATCHES_ID in (
select WC_MATCHES_ID from wc_matches_v where WC_SCREENING_REQUEST_ID in (
select WC_SCREENING_REQUEST_ID from WC_SCREENING_REQUEST p
where p.WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID or ALIAS_WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID))
and MATCHSTATUS in (world_check_iface.c_possible_match,
world_check_iface.c_initial_screen,
world_check_iface.c_new,
world_check_iface.c_unspecified_match)
for update;

cursor get_contents_dest_not_possib (P_WC_SCREENING_REQUEST_ID in number) is
select wc_content_id,  MATCHENTITYIDENTIFIER,MATCHSTATUS,notes, last_updated_by, last_update_date from WC_CONTENT
where WC_MATCHES_ID in (
select WC_MATCHES_ID from wc_matches_v where WC_SCREENING_REQUEST_ID in (
select WC_SCREENING_REQUEST_ID from WC_SCREENING_REQUEST p
where p.WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID or ALIAS_WC_SCREENING_REQUEST_ID = P_WC_SCREENING_REQUEST_ID))
and MATCHSTATUS in (world_check_iface.c_initial_screen,
world_check_iface.c_new,
world_check_iface.c_unspecified_match)
for update;



cursor get_updates(P_WC_SCREENING_REQUEST_ID in number,P_MATCHENTITYIDENTIFIER in varchar2) is
select * from WC_ALIAS_SYNCH_WORKING
where WC_SCREENING_REQUEST_ID = p_screening_request_id
and MATCHENTITYIDENTIFIER =P_MATCHENTITYIDENTIFIER ;

updates_rec get_updates%rowtype;
rc number;
rm varchar2(300);

begin

return_code:=200;
return_message:='Success';
----dbms_output.put_line('start');

begin
open get_related_reqs(p_screening_request_id);
close get_related_reqs;
exception when others then
raise_application_error(-20006,'Error querying related records '||sqlerrm);
end;


for y in get_related_reqs(p_screening_request_id) loop /* synchronize uploaded docments between aliases */

begin
if y.WC_SCREENING_REQUEST_ID != p_screening_request_id then
world_check_iface.synchronize_documents(p_screening_request_id, y.WC_SCREENING_REQUEST_ID,rc, rm);
end if;
exception when others then
raise_application_error(-20000,'Error updating documents '||sqlerrm);
end;

end loop;

/*  update false matches */
----dbms_output.put_line('update false matches ');
begin

for x in get_contents_source(p_screening_request_id,world_check_iface.c_false_match) loop

/* find all the records that are marked as false */

begin
INSERT INTO VSSL.WC_ALIAS_SYNCH_WORKING (
   WC_ALIAS_SYNCH_WORKING_ID, WC_SCREENING_REQUEST_ID, MATCHENTITYIDENTIFIER,
   MATCHSTATUS, NOTES, LAST_UPDATED_BY,
   LAST_UPDATE_DATE,NM_NAME  ,
NM_DOB_AGE,
NM_SEX,
NM_DEAD  ,
NM_VISUAL ,
NM_FATHER_NAME,
NM_IMO_NUMBER,
NM_CNNM)
VALUES ( null /* WC_ALIAS_SYNCH_WORKING_ID */,
 p_screening_request_id /* WC_SCREENING_REQUEST_ID */,
 x.MATCHENTITYIDENTIFIER /* MATCHENTITYIDENTIFIER */,
 x.MATCHSTATUS /* MATCHSTATUS */,
 x.NOTES /* NOTES */,
 x.LAST_UPDATED_BY /* LAST_UPDATED_BY */,
 x.LAST_UPDATE_DATE ,/* LAST_UPDATE_DATE */
 x. NM_NAME    ,
 x.NM_DOB_AGE,
 x.NM_SEX,
 x.NM_DEAD  ,
 x.NM_VISUAL ,
 x.NM_FATHER_NAME    ,
 x.NM_IMO_NUMBER,
 x.NM_CNNM);

exception
when others then
raise_application_error(-20000,'Error inserting into WC_ALIAS_SYNCH_WORKING '||sqlerrm);
end;

end loop;
commit;

-----dbms_output.put_line('after insert into WC_ALIAS_SYNCH_WORKING ');
for x in get_contents_dest_not_false(p_screening_request_id) loop
/* update all records that are not false */

updates_rec.WC_ALIAS_SYNCH_WORKING_ID:=null;
updates_rec.WC_SCREENING_REQUEST_ID:=null;
updates_rec.MATCHENTITYIDENTIFIER:=null;
updates_rec.MATCHSTATUS:=null;
updates_rec.NOTES:=null;
updates_rec.LAST_UPDATED_BY:=null;
updates_rec.LAST_UPDATE_DATE:=null;
updates_rec.NM_NAME :=null;
updates_rec.NM_DOB_AGE:=null;
updates_rec.NM_SEX:=null;
updates_rec.NM_DEAD:=null;
updates_rec.NM_VISUAL  :=null;
updates_rec.NM_FATHER_NAME      :=null;
updates_rec.NM_IMO_NUMBER:=null;
updates_rec.NM_CNNM:=null;


----dbms_output.put_line('get updates ');
open get_updates(p_screening_request_id, x.MATCHENTITYIDENTIFIER);
fetch get_updates into updates_rec;
close get_updates;

if updates_rec.WC_ALIAS_SYNCH_WORKING_ID is not null then

----dbms_output.put_line('pre updates ');
begin
UPDATE VSSL.WC_CONTENT
SET   LAST_UPDATED_BY       = updates_rec.LAST_UPDATED_BY,
       LAST_UPDATE_DATE      = updates_rec.LAST_UPDATE_DATE,
       MATCHSTATUS           = updates_rec.MATCHSTATUS,
       NOTES                 = nvl(updates_rec.NOTES,substr(notes,1,300)),
       NM_NAME    =   updates_rec.NM_NAME ,
NM_DOB_AGE =   updates_rec.NM_DOB_AGE,
NM_SEX =   updates_rec.NM_SEX,
NM_DEAD    =   updates_rec.NM_DEAD,
NM_VISUAL      =   updates_rec. NM_VISUAL,
NM_FATHER_NAME  =   updates_rec.NM_FATHER_NAME,
NM_IMO_NUMBER =   updates_rec.NM_IMO_NUMBER,
NM_CNNM = updates_rec.NM_CNNM
WHERE  current of get_contents_dest_not_false;
exception when others then
----dbms_output.put_line(to_char(updates_rec.LAST_UPDATED_BY));
----dbms_output.put_line(to_char(updates_rec.LAST_UPDATE_DATE, 'dd-mon-rrrr'));
----dbms_output.put_line(updates_rec.MATCHSTATUS);
----dbms_output.put_line(updates_rec.NOTES);
----dbms_output.put_line(updates_rec.NM_NAME);
----dbms_output.put_line(updates_rec.NM_DOB_AGE);

raise_application_error(-20000,'Error updating content '||sqlerrm);
end;
----dbms_output.put_line('post updates ');
end if;
end loop;
commit;

exception when others then
raise_application_error(-20001,'Error updating false matches '||sqlerrm);
end;

delete from  WC_ALIAS_SYNCH_WORKING
where WC_SCREENING_REQUEST_ID = p_screening_request_id;
commit;


----dbms_output.put_line('update positive matches ');
begin

/* get all the records that are a positive match */
for x in get_contents_source(p_screening_request_id,world_check_iface.c_positive_match) loop

INSERT INTO VSSL.WC_ALIAS_SYNCH_WORKING (
   WC_ALIAS_SYNCH_WORKING_ID, WC_SCREENING_REQUEST_ID, MATCHENTITYIDENTIFIER,
   MATCHSTATUS, NOTES, LAST_UPDATED_BY,
   LAST_UPDATE_DATE,NM_NAME  ,
NM_DOB_AGE,
NM_SEX,
NM_DEAD  ,
NM_VISUAL ,
NM_FATHER_NAME,
NM_IMO_NUMBER,
NM_CNNM)
VALUES ( null /* WC_ALIAS_SYNCH_WORKING_ID */,
 p_screening_request_id /* WC_SCREENING_REQUEST_ID */,
 x.MATCHENTITYIDENTIFIER /* MATCHENTITYIDENTIFIER */,
 x.MATCHSTATUS /* MATCHSTATUS */,
 x.NOTES /* NOTES */,
 x.LAST_UPDATED_BY /* LAST_UPDATED_BY */,
 x.LAST_UPDATE_DATE, /* LAST_UPDATE_DATE */
  x. NM_NAME    ,
 x.NM_DOB_AGE,
 x.NM_SEX,
 x.NM_DEAD  ,
 x.NM_VISUAL ,
 x.NM_FATHER_NAME    ,
 x.NM_IMO_NUMBER,
 x.NM_CNNM
 );
end loop;
commit;

for x in get_contents_dest_not_posit(p_screening_request_id) loop
/* update all the records that are not positive or false */

updates_rec.WC_ALIAS_SYNCH_WORKING_ID:=null;
updates_rec.WC_SCREENING_REQUEST_ID:=null;
updates_rec.MATCHENTITYIDENTIFIER:=null;
updates_rec.MATCHSTATUS:=null;
updates_rec.NOTES:=null;
updates_rec.LAST_UPDATED_BY:=null;
updates_rec.LAST_UPDATE_DATE:=null;
updates_rec.NM_NAME :=null;
updates_rec.NM_DOB_AGE:=null;
updates_rec.NM_SEX:=null;
updates_rec.NM_DEAD:=null;
updates_rec.NM_VISUAL  :=null;
updates_rec.NM_FATHER_NAME      :=null;
updates_rec.NM_IMO_NUMBER:=null;
updates_rec.NM_CNNM:=null;

open get_updates(p_screening_request_id, x.MATCHENTITYIDENTIFIER);
fetch get_updates into updates_rec;
close get_updates;

if updates_rec.WC_ALIAS_SYNCH_WORKING_ID is not null then

UPDATE VSSL.WC_CONTENT
SET   LAST_UPDATED_BY       = updates_rec.LAST_UPDATED_BY,
       LAST_UPDATE_DATE      = updates_rec.LAST_UPDATE_DATE,
       MATCHSTATUS           = updates_rec.MATCHSTATUS,
       NOTES                 = nvl(updates_rec.NOTES,notes),
       NM_NAME    =   updates_rec.NM_NAME ,
NM_DOB_AGE =   updates_rec.NM_DOB_AGE,
NM_SEX =   updates_rec.NM_SEX,
NM_DEAD    =   updates_rec.NM_DEAD,
NM_VISUAL      =   updates_rec. NM_VISUAL,
NM_FATHER_NAME  =   updates_rec.NM_FATHER_NAME,
NM_IMO_NUMBER =   updates_rec.NM_IMO_NUMBER,
NM_CNNM = updates_rec.NM_CNNM
WHERE  current of get_contents_dest_not_posit;

end if;
end loop;
commit;
exception when others then
raise_application_error(-20001,'Error updating positive matches '||sqlerrm);
end;
delete from  WC_ALIAS_SYNCH_WORKING
where WC_SCREENING_REQUEST_ID = p_screening_request_id;
commit;
----dbms_output.put_line('update possible matches ');
begin
for x in get_contents_source(p_screening_request_id,world_check_iface.c_possible_match) loop

/*get all of the records that are possible */

INSERT INTO VSSL.WC_ALIAS_SYNCH_WORKING (
   WC_ALIAS_SYNCH_WORKING_ID, WC_SCREENING_REQUEST_ID, MATCHENTITYIDENTIFIER,
   MATCHSTATUS, NOTES, LAST_UPDATED_BY,
   LAST_UPDATE_DATE,NM_NAME  ,
NM_DOB_AGE,
NM_SEX,
NM_DEAD  ,
NM_VISUAL ,
NM_FATHER_NAME,
NM_IMO_NUMBER,
NM_CNNM)
VALUES ( null /* WC_ALIAS_SYNCH_WORKING_ID */,
 p_screening_request_id /* WC_SCREENING_REQUEST_ID */,
 x.MATCHENTITYIDENTIFIER /* MATCHENTITYIDENTIFIER */,
 x.MATCHSTATUS /* MATCHSTATUS */,
 x.NOTES /* NOTES */,
 x.LAST_UPDATED_BY /* LAST_UPDATED_BY */,
 x.LAST_UPDATE_DATE /* LAST_UPDATE_DATE */,
   x. NM_NAME    ,
 x.NM_DOB_AGE,
 x.NM_SEX,
 x.NM_DEAD  ,
 x.NM_VISUAL ,
 x.NM_FATHER_NAME    ,
 x.NM_IMO_NUMBER,
 x.NM_CNNM  );
end loop;
commit;

for x in get_contents_dest_not_possib(p_screening_request_id) loop

/* update all the records that are not possible */
updates_rec.WC_ALIAS_SYNCH_WORKING_ID:=null;
updates_rec.WC_SCREENING_REQUEST_ID:=null;
updates_rec.MATCHENTITYIDENTIFIER:=null;
updates_rec.MATCHSTATUS:=null;
updates_rec.NOTES:=null;
updates_rec.LAST_UPDATED_BY:=null;
updates_rec.LAST_UPDATE_DATE:=null;
updates_rec.NM_NAME :=null;
updates_rec.NM_DOB_AGE:=null;
updates_rec.NM_SEX:=null;
updates_rec.NM_DEAD:=null;
updates_rec.NM_VISUAL  :=null;
updates_rec.NM_FATHER_NAME      :=null;
updates_rec.NM_IMO_NUMBER:=null;
updates_rec.NM_CNNM:=null;


open get_updates(p_screening_request_id, x.MATCHENTITYIDENTIFIER);
fetch get_updates into updates_rec;
close get_updates;

if updates_rec.WC_ALIAS_SYNCH_WORKING_ID is not null then

UPDATE VSSL.WC_CONTENT
SET   LAST_UPDATED_BY       = updates_rec.LAST_UPDATED_BY,
       LAST_UPDATE_DATE      = updates_rec.LAST_UPDATE_DATE,
       MATCHSTATUS           = updates_rec.MATCHSTATUS,
      NOTES                 = nvl(updates_rec.NOTES,notes),
       NM_NAME    =   updates_rec.NM_NAME ,
NM_DOB_AGE =   updates_rec.NM_DOB_AGE,
NM_SEX =   updates_rec.NM_SEX,
NM_DEAD    =   updates_rec.NM_DEAD,
NM_VISUAL      =   updates_rec. NM_VISUAL,
NM_FATHER_NAME  =   updates_rec.NM_FATHER_NAME,
NM_IMO_NUMBER =   updates_rec.NM_IMO_NUMBER,
NM_CNNM = updates_rec.NM_CNNM
WHERE  current of get_contents_dest_not_possib;

end if;
end loop;
commit;
exception when others then
raise_application_error(-20001,'Error updating possible matches '||sqlerrm);
end;
delete from  WC_ALIAS_SYNCH_WORKING
where WC_SCREENING_REQUEST_ID = p_screening_request_id;
commit;

exception
when others then raise_application_error(-20002,'Alias synchronization completed with an error '||sqlerrm);

end;

procedure synchronize_documents(from_screening_request_id in number, to_screening_request_id in number, p_return_code out number, p_return_message out varchar2) is

cursor get_document (p_wc_screening_request_id in number) is select * from WC_REQUEST_DOCUMENTS where wc_screening_request_id = p_wc_screening_request_id;

cursor get_target_documents (p_wc_screening_request_id in number)  is
select count(*) from WC_REQUEST_DOCUMENTS
where  wc_screening_request_id = p_wc_screening_request_id;

to_nof_docs number :=0;
from_nof_docs number :=0;

begin


for x in get_document( from_screening_request_id) loop
begin
INSERT INTO VSSL.WC_REQUEST_DOCUMENTS (
   CREATED_BY, CREATION_DATE, DOC_DESCRIPTION,
   EDOCS_ID, LAST_UPDATE_DATE, LAST_UPDATE_LOGIN,
   LAST_UPDATED_BY, WC_REQUEST_DOCUMENTS_ID, WC_SCREENING_REQUEST_ID)
VALUES ( X.CREATED_BY /* CREATED_BY */,
 x.CREATION_DATE /* CREATION_DATE */,
 x.DOC_DESCRIPTION/* DOC_DESCRIPTION */,
 x.EDOCS_ID /* EDOCS_ID */,
 x.LAST_UPDATE_DATE /* LAST_UPDATE_DATE */,
 x.LAST_UPDATE_LOGIN  /* LAST_UPDATE_LOGIN */,
 x. LAST_UPDATED_BY /* LAST_UPDATED_BY */,
 null /* WC_REQUEST_DOCUMENTS_ID */,
 to_screening_request_id /* WC_SCREENING_REQUEST_ID */ );
exception when dup_val_on_index then
null;
when others then
 raise_application_error(-20001,'Error Inserting document reference');
end;
end loop;
commit;

for x in get_document(to_screening_request_id) loop
begin
INSERT INTO VSSL.WC_REQUEST_DOCUMENTS (
   CREATED_BY, CREATION_DATE, DOC_DESCRIPTION,
   EDOCS_ID, LAST_UPDATE_DATE, LAST_UPDATE_LOGIN,
   LAST_UPDATED_BY, WC_REQUEST_DOCUMENTS_ID, WC_SCREENING_REQUEST_ID)
VALUES ( X.CREATED_BY /* CREATED_BY */,
 x.CREATION_DATE /* CREATION_DATE */,
 x.DOC_DESCRIPTION/* DOC_DESCRIPTION */,
 x.EDOCS_ID /* EDOCS_ID */,
 x.LAST_UPDATE_DATE /* LAST_UPDATE_DATE */,
 x.LAST_UPDATE_LOGIN  /* LAST_UPDATE_LOGIN */,
 x. LAST_UPDATED_BY /* LAST_UPDATED_BY */,
 null /* WC_REQUEST_DOCUMENTS_ID */,
 from_screening_request_id /* WC_SCREENING_REQUEST_ID */ );
 exception when dup_val_on_index then
null;
when others then
 raise_application_error(-20001,'Error Inserting document reference');
end;
end loop;
commit;
end;

procedure send_notice(p_screening_request_id in number, p_return_code out number, p_return_message out varchar2) is

CURSOR get_screening_request(screening_request_id in number) IS

  SELECT   r.SENT_TO_LEGAL_BY, r.STATUS
               , r.name_screened
  FROM   WC_SCREENING_REQUEST r
  WHERE   r.wc_screening_request_id = p_screening_request_id;

  request_rec get_screening_request%rowtype;

  conn utl_smtp.connection;

  email_text varchar2(5000);
  header_line varchar2(300);
  detail_line varchar2(300);
  sender_email_address varchar2(300);
  destination_email_address varchar2(300);
  cc varchar2(300);
  x_ref_data WORLD_CHECK_IFACE.xref_tab;
  comment1 varchar2(100);
  comment2 varchar2(100);


email_message_full varchar2(4000);
email_message_line varchar2(4000);
 error_message varchar2(400):='Success';

BEGIN

  p_return_code := 0;
  p_return_message := 'Successful';

  OPEN  get_screening_request(p_screening_request_id);
  FETCH  get_screening_request INTO request_rec;
  CLOSE  get_screening_request;

  sender_email_address := '#IRI-Trade@register-iri.com';
  destination_email_address := get_user_email_address(request_rec.SENT_TO_LEGAL_BY);

  IF instr(get_requesting_department(p_screening_request_id),'Seafarers') > 0 THEN

    --- Removed the Individual Seafarers and added TCSeafarers@register-iri.comas per Help Desk Ticket T20190328.0005
    --cc := 'chickman@register-iri.com,pfeild@Register-IRI.com,jvannuys@register-iri.com,jnotay@register-iri.com,jpatsios@Register-IRI.com' ; --T20180905.0012 Added Nancy and Jasmeet to match distribution from Send Notice From Trigger  ; T20180910.0010 ZK Added Nancy F and then removed : Gopi T20181030.0032  Removed Ryan Gibson fromt the cc list;T20181205.0025 -  Added Jordan and removed Natalie

    cc := 'chickman@register-iri.com,pfeild@Register-IRI.com,TCSeafarers@register-iri.com';--,jvannuys@register-iri.com,jnotay@register-iri.com,jpatsios@Register-IRI.com';    

  ELSE

    cc := get_user_CC_email_address(request_rec.SENT_TO_LEGAL_BY);


  END IF;

  detail_line := 'Trade Compliance for '||request_rec.NAME_SCREENED||' has been '||request_rec.STATUS||'.';

  conn := Demo_Mail.begin_mail(
  sender     => sender_email_address,
  recipients => destination_email_address,
  cc=> cc,
  subject    => detail_line,
  mime_type  => 'text/html');

email_message_line := 'Dear '||get_username_propername(request_rec.SENT_TO_LEGAL_BY)||': <BR><BR>'||detail_line||'<BR><BR>';

email_message_full:=email_message_full||email_message_line;

  Demo_Mail.write_text(
    conn    => conn,
    message => email_message_line);




  WORLD_CHECK_IFACE.get_context(p_screening_request_id, x_ref_data);

  if x_ref_data.count > 0 then

    for y in 1..x_ref_data.count loop
    WORLD_CHECK_IFACE.get_custom_tag_info(x_ref_data(y), comment1, comment2);

    email_message_line := comment1||' '||comment2||'<BR>';
email_message_full:=email_message_full||email_message_line;

    Demo_Mail.write_text(
    conn    => conn,
    message =>email_message_line);
    end loop;

   end if;


    email_message_line :=  '<BR><BR><BR><BR><BR><BR><BR><center>This is an automated e-mail message. </center>';
email_message_full:=email_message_full||email_message_line;

  Demo_Mail.write_text(
    conn    => conn,
    message => email_message_line);

  Demo_Mail.end_mail( conn => conn );

INSERT INTO VSSL.WC_EMAIL_LOG (
   WC_EMAIL_LOG_ID, WC_SCREENING_REQUEST_ID, EMAIL_TO,
   EMAIL_CC, MESSAGE, ERROR_MESSAGE,
   CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE,
   LAST_UPDATE_BY, LAST_UPDATE_LOGIN)
VALUES (  null /* WC_EMAIL_LOG_ID */,
p_screening_request_id  /* WC_SCREENING_REQUEST_ID */,
destination_email_address  /* EMAIL_TO */,
 cc /* EMAIL_CC */,
 email_message_full /* MESSAGE */,
error_message  /* ERROR_MESSAGE */,
 sysdate /* CREATION_DATE */,
 get_userid /* CREATED_BY */,
 sysdate /* LAST_UPDATE_DATE */,
 get_userid /* LAST_UPDATE_BY */,
 get_loginid /* LAST_UPDATE_LOGIN */ );

exception when others then
error_message := sqlerrm;
--raise_application_error(-20001,'World_check_iface.send_notice '||sqlerrm);

END  send_notice;

--SAURABH 16-NOV-2018 T20181115.0015
FUNCTION is_user_internal (p_user_id IN NUMBER)
   RETURN BOOLEAN
IS
   l_return          BOOLEAN       := TRUE;
   l_internal_user   VARCHAR2 (10);
BEGIN
   BEGIN
      SELECT p.profile_value
        INTO l_internal_user
        FROM exsicd_user u, exsicd_user_profiles p, exsicd_profiles e
       WHERE 1 = 1
         AND u.user_id = p_user_id
         AND u.exsicd_user_id = p.exsicd_user_id
         AND e.profile_id = p.profile_id
         AND e.profile_name = 'INTERNAL_USER';
   EXCEPTION
      WHEN OTHERS
      THEN
         l_internal_user := NULL;
   END;

   IF l_internal_user = 'No'
   THEN
      l_return := FALSE;
   END IF;

   RETURN l_return;
END is_user_internal;



PROCEDURE send_notice_from_trigger (
   p_screening_request_id   IN       NUMBER,
   p_created_by             IN       NUMBER,
   p_name_screened          IN       VARCHAR2,
   p_status                 IN       VARCHAR2,
   p_notes                  IN       VARCHAR2,
   p_return_code            OUT      NUMBER,
   p_return_message         OUT      VARCHAR2
)
IS
   conn                        UTL_SMTP.connection;
   email_text                  VARCHAR2 (5000);
   header_line                 VARCHAR2 (300);
   detail_line                 VARCHAR2 (4000);
   v_subject_line              VARCHAR2 (4000); -- ZK 06082018 T20180607.0017
   sender_email_address        VARCHAR2 (300);
   destination_email_address   VARCHAR2 (300);
   x_ref_data                  world_check_iface.xref_tab;
   comment1                    VARCHAR2 (100);
   comment2                    VARCHAR2 (100);
   email_message_full          VARCHAR2 (4000);
   email_message_line          VARCHAR2 (4000);
   error_message               VARCHAR2 (400)             := 'Success';
   cc                          VARCHAR2 (300);
   cc2                         VARCHAR2 (300);
   -- 29-MAR-2019 SAURABH T20190328.0004
   l_fin_no                    VARCHAR2 (100);
BEGIN
   --APPS.mt_log_error(p_NAME_SCREENED||' BEGIN' ||' '||SYSDATE); -- ZK 06072018
   p_return_code := 0;
   p_return_message := 'Successful';
   sender_email_address := '#IRI-Trade@register-iri.com';

   --SAURABH 16-NOV-2018 T20181115.0015
   --destination_email_address := get_user_email_address(p_created_by);
   IF is_user_internal (p_created_by)
   THEN
      destination_email_address := get_user_email_address (p_created_by);
   END IF;

   -- 29-MAR-2019 SAURABH T20190328.0004
   IF world_check_iface.get_requesting_department (p_screening_request_id) LIKE
                                                                   'Seafarer%'
   THEN
      BEGIN
         SELECT 'FIN: ' || MAX (xr.source_table_id)||' '
           INTO l_fin_no
           FROM worldcheck_external_xref xr
          WHERE 1=1
            AND xr.wc_screening_request_id = p_screening_request_id
            AND source_table = 'SICD_SEAFARERS'
            AND source_table_column = 'SEAFARER_ID';
      EXCEPTION
         WHEN OTHERS
         THEN
            l_fin_no := NULL;
      END;
   --
   END IF;
   --


   --APPS.mt_log_error(p_NAME_SCREENED||' '||destination_email_address ||' '||SYSDATE); -- ZK 06072018
   IF p_status IN ('Approved', 'Rejected')
   THEN
      v_subject_line :=
            'Trade Compliance for '
         -- 29-MAR-2019 SAURABH T20190328.0004
         || l_fin_no
         --
         || p_name_screened
         || ' has been '
         || p_status
         || '.';                                 -- ZK 06082018 T20180607.0017
      detail_line :=
            'Trade Compliance for '
         || p_name_screened
         || ' has been '
         || p_status
         || '.';
   ELSIF p_status = 'Pending'
   THEN
      -- Changed Subject Line to match other cases ZK 06082018 T20180607.0017
      v_subject_line :=
            'Trade Compliance for '
         -- 29-MAR-2019 SAURABH T20190328.0004
         || l_fin_no
         --
         || p_name_screened
         || ' has been set to Pending.';
      detail_line :=
            'Trade Compliance for '
         || p_name_screened
         || ' has been set to Pending. <BR> <BR>Please address the following comments: <BR><BR>'
         || REPLACE (p_notes, CHR (10), '<BR>')
         || '<BR><BR><BR>These comments can be viewed in the TC screen by pressing the Enter/View Notes button in the upper right section of the screen.';
   -- APPS.mt_log_error(p_NAME_SCREENED||' '||'Detail Line '||SYSDATE); -- ZK 06072018

   --SAURABH T20181107.0012 14-NOV-2018
   --START
   ELSIF p_status = 'Provisional'
   THEN
      v_subject_line :=
            'Trade Compliance for '
         -- 29-MAR-2019 SAURABH T20190328.0004
         || l_fin_no
         --
         || p_name_screened
         || ' has been set to Provisional.';
      detail_line :=
            'Trade Compliance for '
         || p_name_screened
         || ' has been set to Provisional. <BR> <BR>Please address the following comments: <BR><BR>'
         || REPLACE (p_notes, CHR (10), '<BR>')
         || '<BR><BR><BR>These comments can be viewed in the TC screen by pressing the Enter/View Notes button in the upper right section of the screen.';
   --SAURABH T20181107.0012 14-NOV-2018
   --END
   ELSE
      v_subject_line :=
                    'Please contact Legal /IT this message went out in error';
      detail_line :=
          'Please contact Legal /IT this message went out in error!!<BR><BR>';
   END IF;

   IF INSTR (get_requesting_department (p_screening_request_id), 'Seafarers') >
                                                                             0
   THEN
      --- Added Nancy's email as per Help Desk ticket T20180910.0010
      --- Removed the Individual Seafarers and added TCSeafarers@register-iri.comas per Help Desk Ticket T20190328.0005 
      --cc := 'chickman@register-iri.com,pfeild@register-iri.com,jvannuys@register-iri.com,jnotay@register-iri.com,jpatsios@Register-IRI.com'; -- T20181205.0025 - Added Jordan and removed Natalie
      cc := 'chickman@register-iri.com,pfeild@register-iri.com,TCSeafarers@register-iri.com';--,jvannuys@register-iri.com,jnotay@register-iri.com,jpatsios@Register-IRI.com'; 
      --, zkhan@Register-IRI.com'; T20180910.0010 ZK  Added and then removed Nancy F.; T20181030.0032 ZK 11012018 removed Ryan
      --- APPS.mt_log_error(p_NAME_SCREENED||' cc: '||cc||' '||SYSDATE); -- ZK 06072018
   ELSE
      cc := 'chickman@register-iri.com,pfeild@Register-IRI.com';
          --, zkhan@Register-IRI.com';T20181030.0032 ZK 11012018 removed Ryan
      cc2 := get_user_cc_email_address (p_created_by);

      IF cc2 IS NOT NULL
      THEN
         cc := cc || ',' || cc2;
      END IF;
   -- APPS.mt_log_error(p_NAME_SCREENED||' cc:'||cc||' second cc '||SYSDATE); -- ZK 06072018
   END IF;

   email_message_full := detail_line;
   conn :=
      demo_mail.begin_mail
         (sender          => sender_email_address,
          cc              => cc,
          recipients      => destination_email_address,
          subject         => v_subject_line,
                                 --    detail_line  ZK 06082018 T20180607.0017
          mime_type       => 'text/html'
         );
   email_message_line :=
         'Dear '
      || get_username_propername (p_created_by)
      || ': <BR><BR>'
      || detail_line
      || '<BR><BR>';
   email_message_full := email_message_full || email_message_line;
   demo_mail.write_text (conn => conn, MESSAGE => email_message_line);
   --APPS.mt_log_error(p_NAME_SCREENED||' '||'Before Get Context '||SYSDATE); -- ZK 06072018
   world_check_iface.get_context (p_screening_request_id, x_ref_data);

   --APPS.mt_log_error(p_NAME_SCREENED||' '||'After Get Context '||SYSDATE); -- ZK 06072018
   IF x_ref_data.COUNT > 0
   THEN
      FOR y IN 1 .. x_ref_data.COUNT
      LOOP
         world_check_iface.get_custom_tag_info (x_ref_data (y),
                                                comment1,
                                                comment2
                                               );
         email_message_line := comment1 || ' ' || comment2 || '<BR>';
         email_message_full := email_message_full || email_message_line;
         -- APPS.mt_log_error(p_NAME_SCREENED||' '||email_message_full||' After Email Message Full '||SYSDATE); -- ZK 06072018
         demo_mail.write_text (conn => conn, MESSAGE => email_message_line);
      END LOOP;
   END IF;

   --APPS.mt_log_error(p_NAME_SCREENED||' '||' After Loop '||SYSDATE); -- ZK 06072018
   email_message_line :=
      '<BR><BR><BR><BR><BR><BR><BR><center>This is an automated e-mail message. </center>';
   email_message_full := email_message_full || email_message_line;
   --APPS.mt_log_error(p_NAME_SCREENED||' '||'Before second write text '||SYSDATE); -- ZK 06072018
   demo_mail.write_text (conn => conn, MESSAGE => email_message_line);
-- APPS.mt_log_error(p_NAME_SCREENED||' '||'After second write text '||SYSDATE); -- ZK 06072018
   demo_mail.end_mail (conn => conn);

--APPS.mt_log_error(p_NAME_SCREENED||' '||'Before Insert '||SYSDATE); -- ZK 06072018
   INSERT INTO vssl.wc_email_log
               (wc_email_log_id,
                wc_screening_request_id,
                email_to, email_cc,
                MESSAGE,
                error_message, creation_date,
                created_by, last_update_date,
                last_update_by,
                last_update_login
               )
        VALUES (NULL /* WC_EMAIL_LOG_ID */,
                p_screening_request_id /* WC_SCREENING_REQUEST_ID */,
                destination_email_address /* EMAIL_TO */, cc /* EMAIL_CC */,
                email_message_full /* MESSAGE */,
                error_message /* ERROR_MESSAGE */, SYSDATE /* CREATION_DATE */,
                get_userid /* CREATED_BY */, SYSDATE /* LAST_UPDATE_DATE */,
                get_userid /* LAST_UPDATE_BY */,
                get_loginid /* LAST_UPDATE_LOGIN */
               );
--APPS.mt_log_error(p_NAME_SCREENED||' '||'After Insert '||SYSDATE); -- ZK 06072018
EXCEPTION
   WHEN OTHERS
   THEN
      error_message := SQLERRM;
--APPS.mt_log_error(p_NAME_SCREENED||' '||error_message||': Exception Send Notice From Trigger '||SYSDATE); -- ZK 06072018

--raise_application_error(-20001,'World_check_iface.send_notice '||sqlerrm);
END send_notice_from_trigger;

procedure TC_violation_from_trigger(p_screening_request_id in number,
p_created_by in number,
p_name_screened in varchar2,
p_status in varchar2,
p_PSP_ISSUING_COUNTRY_CODE  in varchar2,
p_CITIZENSHIP_COUNTRY_CODE  in varchar2,
p_RESIDENCE_COUNTRY_CODE  in varchar2,
p_CORP_RESIDENCE_COUNTRY_CODE  in varchar2,
p_message in varchar2,
p_return_code out number,
p_return_message out varchar2) is

conn utl_smtp.connection;

email_text varchar2(5000);
header_line varchar2(300);
detail_line varchar2(300);
sender_email_address varchar2(300);
destination_email_address varchar2(300);
  x_ref_data WORLD_CHECK_IFACE.xref_tab;
  comment1 varchar2(100);
  comment2 varchar2(100);


begin
 p_return_code:=0;
 p_return_message:='Successful';


sender_email_address:=get_user_email_address( p_created_by);
--destination_email_address:='legal@register-iri.com';

destination_email_address:='cgaughf@register-iri.com';

/*
sender_email_address:=get_user_email_address( p_created_by);
destination_email_address:='mtimmons@register-iri.com';
*/
detail_line:='Trade Compliance Violation Alert for '||p_name_screened||'.';

conn := Demo_Mail.begin_mail(
   sender     => sender_email_address,
  recipients => destination_email_address,
    subject    => detail_line,
    mime_type  => 'text/html');

Demo_Mail.write_text(
    conn    => conn,
    message =>get_username_propername( p_created_by)||' has created a trade compliace vetting for a prohibited country.  <BR><BR>');


if  p_message is not null then
Demo_Mail.write_text(
    conn    => conn,
    message =>p_message||' <BR><BR>');
end if;

 WORLD_CHECK_IFACE.get_context(p_screening_request_id, x_ref_data);

    if x_ref_data.count > 0 then
    for y in 1..x_ref_data.count loop
    WORLD_CHECK_IFACE.get_custom_tag_info(x_ref_data(y), comment1, comment2);
    Demo_Mail.write_text(
    conn    => conn,
    message =>comment1||' '||comment2||'<BR>');
    end loop;
   end if;

if p_PSP_ISSUING_COUNTRY_CODE is not null then
Demo_Mail.write_text(
    conn    => conn,
    message =>'Passport issuing country: '||get_sicd_country_name (p_PSP_ISSUING_COUNTRY_CODE)||'<BR>');
end if;

if p_CITIZENSHIP_COUNTRY_CODE is not null then
Demo_Mail.write_text(
    conn    => conn,
    message =>'Country of citizenship: '||get_sicd_country_name (p_CITIZENSHIP_COUNTRY_CODE)||'<BR>');
end if;

if p_RESIDENCE_COUNTRY_CODE is not null then
Demo_Mail.write_text(
    conn    => conn,
    message =>'Country of residence: '||get_sicd_country_name (p_RESIDENCE_COUNTRY_CODE)||'<BR>');
end if;

if p_CORP_RESIDENCE_COUNTRY_CODE is not null then
Demo_Mail.write_text(
    conn    => conn,
    message =>'Corporation country of residence: '||get_sicd_country_name (p_CORP_RESIDENCE_COUNTRY_CODE)||'<BR>');
end if;

Demo_Mail.write_text(
    conn    => conn,
    message => '<BR><BR><BR><BR><BR><BR><BR><center>This is an automated e-mail message. </center>');
Demo_Mail.end_mail( conn => conn );
--exception when others then
--raise_application_error(-20001,'World_check_iface.send_notice '||sqlerrm);
end TC_violation_from_trigger;

function get_sanction_status (p_country_code in varchar2) return varchar2 is
cursor get_status is
select sanction_status from sicd_countries where country_code=p_country_code;

/* sanction status =  PROHIBITED, WARN, CONDITIONAL, NONE */

p_sanction_status varchar2(80) :='NONE';
begin
open get_status;
fetch get_status into p_sanction_status;
close get_status;
return p_sanction_status;
end;

function is_city_required(p_country_code in varchar2) return boolean is

cursor get_city is
select count(*) from WC_CITY_LIST where country_code = p_country_code;

nof_cities number:=0;

begin
open get_city;
fetch get_city into nof_cities;
close get_city;

if nof_cities > 0 then
return true;
end if;
return false;
end;

FUNCTION get_city_tc_status (p_wc_city_list_id IN NUMBER)
   RETURN VARCHAR2
IS
   CURSOR get_city
   IS
      SELECT status
        FROM wc_city_list
       WHERE wc_city_list_id = p_wc_city_list_id;

   stat_code   VARCHAR2 (30) := 'TC_OK';
BEGIN
   --SAURABH 14-SEP-2018 T20170529.0013
   /*OPEN get_city;

   FETCH get_city
    INTO stat_code;

   CLOSE get_city;*/
   --
   IF p_wc_city_list_id IS NULL
   THEN
      stat_code := 'TC_VERIFY';
   ELSE
      OPEN get_city;

      FETCH get_city
       INTO stat_code;

      CLOSE get_city;
   END IF;

   RETURN (stat_code);
END;

function auto_approve_country(p_country_code in varchar2) return boolean is
begin
if get_sanction_status(p_country_code) = 'NONE' then
return TRUE;
end if;

return FALSE;
end;


procedure update_wc_match_status(p_screening_request_id in number, p_return_code out number, p_return_message out varchar2) is

cursor get_screening_request(screening_request_id in number) is select * from wc_screening_request where wc_screening_request_id=p_screening_request_id;

cursor get_matches(screening_request_id in number) is
select * from wc_matches_v where wc_screening_request_id = screening_request_id;

cursor get_content(p_wc_matches_id in number) is
select * from wc_content_v where wc_matches_id = p_wc_matches_id and matchstatus != c_initial_screen;


begin
for x in get_matches(p_screening_request_id) loop
for y in get_content(x.wc_matches_id) loop
----dbms_output.put_line(y.surname||' '||y.given_name);
post_match_status(y.MATCHIDENTIFIER, y.MATCHSTATUS,upper(y.NOTES),'UNKNOWN', p_return_code , p_return_message );
if p_return_code != 200 then
 raise_application_error(-20001, 'update_wc_match_status : '|| p_return_message);
 end if;
end loop;
end loop;
p_return_code:=200;
p_return_message:='Success';
end;

procedure create_screening_wrapper_org(search_name in varchar2, p_source_table in varchar2, p_source_table_column in varchar2,p_source_table_id in number  ) is

p_request_id number;
p_return_code number;
p_return_message varchar2(4000);

xref  world_check_iface.WC_EXTERNAL_XREF_REC;
req  world_check_iface.WC_SCREENING_REQUEST_REC;
p_custom_id1 varchar2(50);
p_custom_id2  varchar2(50);


begin

req.WC_SCREENING_REQUEST_ID:=null;
req.STATUS:='Pending';
req.NAME_SCREENED:=search_name;
req.DATE_OF_BIRTH:=null;
req.SEX :=null;
req.NAME_IDENTIFIER :=null;
req.PASSPORT_NUMBER :=null;
req.ENTITY_TYPE := c_CORPORATION;
req.PASSPORT_ISSUING_COUNTRY_CODE := null;
req.CORP_RESIDENCE_COUNTRY_CODE:=null;
req.RESIDENCE_COUNTRY_CODE:=null;
req.CITIZENSHIP_COUNTRY_CODE := null;
req.NOTIFY_USER_UPON_APPROVAL:='N';

xref.source_table := p_source_table;
xref.source_table_column  :=p_source_table_column;
xref.source_table_id :=p_source_table_id;
xref.source_table_status_column:=null;
xref.WORLDCHECK_EXTERNAL_XREF_ID :=null;
xref.wc_screening_request_id:= req.WC_SCREENING_REQUEST_ID;

world_check_iface.get_custom_tag_info(xref, p_custom_id1,p_custom_id2);

world_check_iface.create_wc_generic(xref, req, p_custom_id1, p_custom_id2,p_return_code, p_return_message);

end;

procedure create_org_tc_request_dbms_job(search_name in varchar2, p_source_table in varchar2, p_source_table_column in varchar2,p_source_table_id in number  )
IS
     INT_JOB_ID NUMBER := NULL;
BEGIN

     DBMS_JOB.SUBMIT (
         job => INT_JOB_ID,
          what => 'world_check_iface.create_screening_wrapper_org('||''''||search_name||''''||','||''''||p_source_table||''''||','||''''||p_source_table_column||''''||','||to_char(p_source_table_id)||');',  -- What to run
          next_date => SYSDATE, -- Start right away
          interval => NULL -- Run only once
     );
     COMMIT;
----dbms_output.put_line('world_check_iface.create_screening_wrapper('||''''||search_name||''''||','||''''||p_source_table||''''||','||''''||p_source_table_column||''''||','||to_char(p_source_table_id)||');');  -- What to run
END;

function does_wc_exist(p_xref in  world_check_iface.WC_EXTERNAL_XREF_REC,  p_req in  world_check_iface.WC_SCREENING_REQUEST_REC) return boolean is


cursor get_xref is
select count(*) from VSSL.WORLDCHECK_EXTERNAL_XREF xref, VSSL.WC_SCREENING_REQUEST req where
xref.SOURCE_TABLE=p_xref.SOURCE_TABLE  and
xref.SOURCE_TABLE_COLUMN=p_xref.SOURCE_TABLE_COLUMN   and
xref.SOURCE_TABLE_ID= p_xref. SOURCE_TABLE_ID and
xref.WC_SCREENING_REQUEST_ID = req.WC_SCREENING_REQUEST_ID
and req.NAME_SCREENED = p_req.NAME_SCREENED;

rec_count number:=0;

ret_status boolean;

begin

ret_status:=FALSE;

open get_xref;
fetch get_xref into rec_count;
close get_xref;

if rec_count >0 then
ret_status := TRUE;
else
ret_status:=FALSE;
end if;

return(ret_status);

end;

function is_match_sanctioned(p_wc_content_id in number) return varchar2 is

is_sanctioned boolean := false;

cursor get_content is
select * from WC_CONTENT where wc_content_id = p_wc_content_id;

content_rec get_content%rowtype;

cursor get_sanction_count (p_xml_var in xmltype) is
select count(*) from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/details/detail' passing p_xml_var
                                                 columns
                                                  title varchar2(200)  path 'title',
                                                  txt clob  path 'text'

                                                 ) x
where instr(x.title,'SANCTION') >0;

cursor get_sanction(p_xml_var in xmltype) is
select * from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/details/detail' passing p_xml_var
                                                 columns
                                                  title varchar2(200)  path 'title',
                                                  txt clob  path 'text'

                                                 ) x
where instr(x.title,'SANCTION') >0;

sanction_title varchar2(200);
sanction_txt clob;
sanction_match varchar2(1):='N';
sanction_count number;

begin

open get_content;
fetch get_content into content_rec;
close get_content;

open get_sanction_count(content_rec.XML_RESPONSE);
fetch get_sanction_count into sanction_count;
close get_sanction_count;

if sanction_count>0 then


for x in get_sanction(content_rec.XML_RESPONSE) loop
sanction_title := x.title;
if instr(x.title,'USA SANCTIONS') >0 then
is_sanctioned := true;
end if;
if instr(x.title,'EU SANCTIONS') >0 then
is_sanctioned := true;
end if;
if instr(x.title,'UK SANCTIONS') >0 then
is_sanctioned := true;
end if;
if instr(x.title,'UN SANCTIONS') >0 then
is_sanctioned := true;
end if;
if instr(x.title,'HONG KONG SANCTIONS') >0 then
is_sanctioned := true;
end if;


if is_sanctioned then exit; end if;

end loop;

end if;

if is_sanctioned then return 'Y'; end if;
return 'N';

end;


function is_request_sanctioned(p_WC_SCREENING_REQUEST_ID in number) return varchar2 is

is_sanctioned boolean := false;

cursor get_content is
select * from WC_CONTENT where WC_SCREENING_REQUEST_ID = p_WC_SCREENING_REQUEST_ID;

content_rec get_content%rowtype;

cursor get_sanction_count (p_xml_var in xmltype) is
select count(*) from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/details/detail' passing p_xml_var
                                                 columns
                                                  title varchar2(200)  path 'title',
                                                  txt clob  path 'text'

                                                 ) x
where instr(x.title,'SANCTION') >0;

cursor get_sanction(p_xml_var in xmltype) is
select * from xmltable(
                                                 XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/details/detail' passing p_xml_var
                                                 columns
                                                  title varchar2(200)  path 'title',
                                                  txt clob  path 'text'

                                                 ) x
where instr(x.title,'SANCTION') >0;

sanction_title varchar2(200);
sanction_txt clob;
sanction_match varchar2(1):='N';
sanction_count number;

begin

open get_content;
fetch get_content into content_rec;
close get_content;

open get_sanction_count(content_rec.XML_RESPONSE);
fetch get_sanction_count into sanction_count;
close get_sanction_count;

if sanction_count>0 then


for x in get_sanction(content_rec.XML_RESPONSE) loop
if instr(x.title,'USA SANCTIONS') >0 then
is_sanctioned := true;
end if;
if instr(x.title,'EU SANCTIONS') >0 then
is_sanctioned := true;
end if;
if instr(x.title,'UK SANCTIONS') >0 then
is_sanctioned := true;
end if;
if instr(x.title,'UN SANCTIONS') >0 then
is_sanctioned := true;
end if;
if instr(x.title,'HONG KONG SANCTIONS') >0 then
is_sanctioned := true;
end if;
if is_sanctioned then exit; end if;
end loop;

end if;


if is_sanctioned then return 'Y'; end if;
return 'N';

end;

function update_comment(p_name in varchar2, p_dob in varchar2,p_sex in varchar2 ,p_dead in varchar2,p_visual in varchar2, p_fathers_name in varchar2, p_imo_number in varchar2,p_NM_CNNM in varchar2, p_notes in varchar2) return varchar2 is
new_comment varchar2(300):=null;
original_comment varchar2(300);
delimiter varchar2(2):=null;
begin
if p_fathers_name='Y' then /* dob/age match is yes */
if instr(nvl(p_notes,'x'),world_check_iface.USER_FATHER_NAME_MATCH) = 0  then
new_comment:=new_comment||delimiter||world_check_iface.USER_FATHER_NAME_MATCH;
delimiter := world_check_iface.DELIMITER;
end if;
else /*dob/age match is no */
if  instr(nvl(p_notes,'x'),world_check_iface.USER_FATHER_NAME_MATCH||',') > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_FATHER_NAME_MATCH||',','');
elsif instr(nvl(p_notes,'x'),world_check_iface.USER_FATHER_NAME_MATCH) > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_FATHER_NAME_MATCH,'');
end if;
end if;
original_comment:=p_notes;

if p_name='Y' then /* name match is yes */
if instr(nvl(p_notes,'x'),world_check_iface.COMP_NAME_NOT_MATCH) = 0 and instr(nvl(p_notes,'xx'),world_check_iface.USER_NAME_NOT_MATCH) = 0  then
new_comment:=world_check_iface.USER_NAME_NOT_MATCH;
delimiter := world_check_iface.DELIMITER;
end if;
else /* name match is no */
if instr(nvl(p_notes,'x'),world_check_iface.COMP_NAME_NOT_MATCH||',') > 0 then
/* remove name comment if it exists */
original_comment:=replace(original_comment,world_check_iface.COMP_NAME_NOT_MATCH||',','');

elsif instr(nvl(p_notes,'x'),world_check_iface.COMP_NAME_NOT_MATCH) > 0 then
/* remove name comment if it exists */
original_comment:=replace(original_comment,world_check_iface.COMP_NAME_NOT_MATCH,'');

elsif instr(nvl(p_notes,'x'),world_check_iface.USER_NAME_NOT_MATCH||',') > 0 then
/* remove name comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_NAME_NOT_MATCH||',','');

elsif instr(nvl(p_notes,'x'),world_check_iface.USER_NAME_NOT_MATCH) > 0 then
/* remove name comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_NAME_NOT_MATCH,'');
end if;
end if;


if p_dob='Y' then /* dob/age match is yes */
if instr(nvl(p_notes,'x'),world_check_iface.COMP_DOB_AGE_MATCH) = 0 and instr(nvl(p_notes,'xx'),world_check_iface.USER_DOB_AGE_MATCH) = 0  then
new_comment:=new_comment||delimiter||world_check_iface.USER_DOB_AGE_MATCH;
delimiter := world_check_iface.DELIMITER;
end if;
else /*dob/age match is no */
if instr(nvl(p_notes,'x'),world_check_iface.COMP_DOB_AGE_MATCH||',') > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.COMP_DOB_AGE_MATCH||',','');
elsif instr(nvl(p_notes,'x'),world_check_iface.COMP_DOB_AGE_MATCH) > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.COMP_DOB_AGE_MATCH,'');
elsif instr(nvl(p_notes,'x'),world_check_iface.USER_DOB_AGE_MATCH||',') > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_DOB_AGE_MATCH||',','');
elsif instr(nvl(p_notes,'x'),world_check_iface.USER_DOB_AGE_MATCH) > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_DOB_AGE_MATCH,'');
end if;

end if;

if p_sex='Y' then /* dob/age match is yes */
if instr(nvl(p_notes,'x'),world_check_iface.COMP_SEX_MATCH) = 0 and instr(nvl(p_notes,'x'),world_check_iface.USER_SEX_MATCH) = 0  then
new_comment:=new_comment||delimiter||world_check_iface.USER_SEX_MATCH;
delimiter := world_check_iface.DELIMITER;
end if;
else /*dob/age match is no */

if instr(nvl(p_notes,'x'),world_check_iface.COMP_SEX_MATCH||',') > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.COMP_SEX_MATCH||',','');
elsif instr(nvl(p_notes,'x'),world_check_iface.COMP_SEX_MATCH) > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.COMP_SEX_MATCH,'');
elsif instr(nvl(p_notes,'x'),world_check_iface.USER_SEX_MATCH||',') > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_SEX_MATCH||',','');
elsif instr(nvl(p_notes,'x'),world_check_iface.USER_SEX_MATCH) > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_SEX_MATCH,'');
end if;
end if;


if p_dead='Y' then /* dob/age match is yes */
if instr(nvl(p_notes,'x'),world_check_iface.COMP_DECEASED_MATCH) = 0 and instr(nvl(p_notes,'x'),world_check_iface.USER_DECEASED_MATCH) = 0  then
new_comment:=new_comment||delimiter||world_check_iface.USER_DECEASED_MATCH;
delimiter := world_check_iface.DELIMITER;
end if;
else /*dob/age match is no */
if instr(nvl(p_notes,'x'),world_check_iface.COMP_DECEASED_MATCH||',') > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.COMP_DECEASED_MATCH||',','');
elsif instr(nvl(p_notes,'x'),world_check_iface.COMP_DECEASED_MATCH) > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.COMP_DECEASED_MATCH,'');
elsif instr(nvl(p_notes,'x'),world_check_iface.USER_DECEASED_MATCH||',') > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_DECEASED_MATCH||',','');
elsif instr(nvl(p_notes,'x'),world_check_iface.USER_DECEASED_MATCH) > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_DECEASED_MATCH,'');
end if;
end if;

if P_NM_CNNM='Y' then /* dob/age match is yes */
if instr(nvl(p_notes,'x'),world_check_iface.USER_NM_CNNM) = 0  then
new_comment:=new_comment||delimiter||world_check_iface.USER_NM_CNNM;
delimiter := world_check_iface.DELIMITER;
end if;
else /*dob/age match is no */
if  instr(nvl(p_notes,'x'),world_check_iface.USER_NM_CNNM||',') > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_NM_CNNM||',','');
elsif instr(nvl(p_notes,'x'),world_check_iface.USER_NM_CNNM) > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_NM_CNNM,'');
end if;
end if;



if p_visual='Y' then /* dob/age match is yes */
if instr(nvl(p_notes,'x'),world_check_iface.USER_VISUAL_MATCH) = 0 then
new_comment:=new_comment||delimiter||world_check_iface.USER_VISUAL_MATCH;
delimiter := world_check_iface.DELIMITER;
end if;
else /*dob/age match is no */
if instr(nvl(p_notes,'x'),world_check_iface.USER_VISUAL_MATCH||',') > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_VISUAL_MATCH||',','');
elsif instr(nvl(p_notes,'x'),world_check_iface.USER_VISUAL_MATCH) > 0 then
/* remove dob/age comment if it exists */
original_comment:=replace(original_comment,world_check_iface.USER_VISUAL_MATCH,'');
end if;
end if;


delimiter := world_check_iface.DELIMITER;

original_comment:=ltrim(rtrim(original_comment));

if length(original_comment) = 0 then
delimiter := null;

end if;

if length(nvl(new_comment,'x')) < 10 then
delimiter := null;
new_comment:=null;

end if;


return rtrim(rtrim(original_comment||delimiter||new_comment,','));
end;


function build_comment(p_name in varchar2, p_dob in varchar2,p_sex in varchar2 ,p_dead in varchar2,p_visual in varchar2, p_address in varchar2, p_country in varchar, p_NM_CNNM in varchar2 ) return varchar2 is
new_comment varchar2(300):=null;
original_comment varchar2(300);
delimiter varchar2(2):=null;
begin
if p_name='Y' then /* name match is yes */
new_comment:=world_check_iface.COMP_NAME_NOT_MATCH;
delimiter := world_check_iface.DELIMITER;
end if;

if p_dob='Y' then /* dob/age match is yes */
new_comment:=new_comment||delimiter||world_check_iface.COMP_DOB_AGE_MATCH;
delimiter := world_check_iface.DELIMITER;
end if;

if p_sex='Y' then /* dob/age match is yes */
new_comment:=new_comment||delimiter||world_check_iface.COMP_SEX_MATCH;
delimiter := world_check_iface.DELIMITER;
end if;

if p_dead='Y' then /* dob/age match is yes */
new_comment:=new_comment||delimiter||world_check_iface.COMP_DECEASED_MATCH;
delimiter := world_check_iface.DELIMITER;
end if;

if p_address='Y' then /* dob/age match is yes */
new_comment:=new_comment||delimiter||world_check_iface.COMP_ADDRESS;
delimiter := world_check_iface.DELIMITER;
end if;

if p_country='Y' then /* dob/age match is yes */
new_comment:=new_comment||delimiter||world_check_iface.COMP_COUNTRY;
delimiter := world_check_iface.DELIMITER;
end if;

return new_comment;
end;




function can_revetting_be_autoapproved(p_WC_SCREENING_REQUEST_ID in number) return varchar2 is

cursor get_content is
select wc.* from WC_CONTENT_V wc, wc_matches_v wv where wv.WC_SCREENING_REQUEST_ID = p_WC_SCREENING_REQUEST_ID
and wc.WC_MATCHES_ID = wv.WC_MATCHES_ID;

auto_approve boolean := true;

cursor get_approval_history is select count(*) from WC_REQUEST_APPROVAL_HISTORY
where WC_SCREENING_REQUEST_ID = p_WC_SCREENING_REQUEST_ID
and status='Approved';

nof_approvals number:=0;



begin
/* lets check to see if the vetting has ever been approved */
open get_approval_history;
fetch get_approval_history into nof_approvals;
close get_approval_history;

/* if it has then continue with the check */

if nof_approvals > 0 then

for x in get_content loop
if x.MATCHSTATUS != c_false_match then
auto_approve:=false;
exit;
end if;
end loop;

if auto_approve then
return 'Y';
end if;

end if;

return 'N';

end;

function get_pick_implementation_date return date is
/* this function return the date when the pick critera option was implemented
this is used in the world_check_xref from */

date_var date := to_date('04-MAR-2016','DD-MON-RRRR');
begin
return(date_var);
end;


FUNCTION is_entity_crimean (
   xref            IN       world_check_iface.wc_external_xref_rec,
   p_return_code   OUT      VARCHAR,
   p_ret_msg       OUT      VARCHAR2
)
   RETURN VARCHAR2
IS
   CURSOR get_related_recs
   IS
      SELECT *
        FROM worldcheck_external_xref
       WHERE source_table = xref.source_table
         AND source_table_column = xref.source_table_column
         AND source_table_id = xref.source_table_id;

   CURSOR get_request_info (p_wc_screening_request_id IN NUMBER)
   IS
      SELECT COUNT (*)
        FROM wc_screening_request req, wc_city_list city
       WHERE wc_screening_request_id = p_wc_screening_request_id
         AND city.wc_city_list_id = req.wc_city_list_id
         AND city.status = 'TC_VERIFY'
         AND country_code IN ('UKRA', 'RUSS');

   nof_recs     NUMBER;
   req          get_request_info%ROWTYPE;
   is_crimean   VARCHAR2 (1)               := 'N';
   --OWS
   l_ows_req    xwrl_requests%ROWTYPE;

   CURSOR cur_req_details (p_id IN NUMBER)
   IS
      SELECT value city
        FROM xwrl_request_rows a
       WHERE request_id = p_id
       AND   key = 'City';

   l_ows_data   cur_req_details%ROWTYPE;

   CURSOR cur_city_check (p_city_id IN NUMBER)
   IS
      SELECT 'Y'
        FROM wc_city_list city
       WHERE wc_city_list_id = p_city_id
         AND city.status = 'TC_VERIFY'
         AND country_code IN ('UKRA', 'RUSS');
BEGIN
   p_return_code := 'OK';
   p_ret_msg := 'Success';

   IF rmi_ows_common_util.is_ows_user = 'N'
   THEN
      FOR x IN get_related_recs
      LOOP
         nof_recs := 0;

         OPEN get_request_info (x.wc_screening_request_id);

         FETCH get_request_info
          INTO nof_recs;

         CLOSE get_request_info;

         IF nof_recs > 0 AND is_crimean = 'N'
         THEN
            is_crimean := 'Y';
            EXIT;
         END IF;
      END LOOP;
   ELSE
      l_ows_req :=
         rmi_ows_common_util.get_open_case (xref.source_table,
                                            xref.source_table_id
                                           );

      OPEN cur_req_details (l_ows_req.ID);

      FETCH cur_req_details
       INTO l_ows_data;

      CLOSE cur_req_details;

      IF l_ows_data.city IS NOT NULL
      THEN
         OPEN cur_city_check (rmi_ows_common_util.get_city_list_id (l_ows_data.city));

         FETCH cur_city_check
          INTO is_crimean;

         CLOSE cur_city_check;
      END IF;
   END IF;

   RETURN (is_crimean);
END;

procedure provisional_approval_process(p_screening_request_id in number, p_return_code out number, p_return_message out varchar2) is

cursor get_request is select * from WC_SCREENING_REQUEST
where WC_SCREENING_REQUEST_ID = p_screening_request_id;

cursor get_contents is
select wc.* from wc_content_v wc, wc_matches_v wm
where wc.wc_matches_id=wm.wc_matches_id
and wm.WC_SCREENING_REQUEST_ID = p_screening_request_id;

p_req   get_request%rowtype;
tc_status varchar2(30);

pending_status varchar2(30);

provisional_approval boolean:=false;

v_sql varchar2(4000);

begin
open get_request;
fetch get_request into p_req;
close get_request;

--dbms_output.PUT_LINE ( 'p_req = ' || p_req.name_screened );

if world_check_iface.get_sanction_status(p_req.CITIZENSHIP_COUNTRY_CODE)='NONE' and
world_check_iface.get_sanction_status(p_req.PASSPORT_ISSUING_COUNTRY_CODE)='NONE' and
world_check_iface.get_sanction_status(p_req.RESIDENCE_COUNTRY_CODE)='NONE'  then
provisional_approval := true;
elsif
world_check_iface.get_sanction_status(p_req.CITIZENSHIP_COUNTRY_CODE)='PROHIBITED' or
world_check_iface.get_sanction_status(p_req.PASSPORT_ISSUING_COUNTRY_CODE)='PROHIBITED' or
world_check_iface.get_sanction_status(p_req.RESIDENCE_COUNTRY_CODE)='PROHIBITED' then
provisional_approval := false;
elsif
world_check_iface.get_sanction_status(p_req.CITIZENSHIP_COUNTRY_CODE)='CONDITIONAL' or
world_check_iface.get_sanction_status(p_req.PASSPORT_ISSUING_COUNTRY_CODE)='CONDITIONAL' or
world_check_iface.get_sanction_status(p_req.RESIDENCE_COUNTRY_CODE)='CONDITIONAL' then

if world_check_iface.is_city_required(p_req.CITIZENSHIP_COUNTRY_CODE) or
world_check_iface.is_city_required(p_req.PASSPORT_ISSUING_COUNTRY_CODE) or
world_check_iface.is_city_required(p_req.RESIDENCE_COUNTRY_CODE)
then
if p_req.WC_CITY_LIST_ID is null then provisional_approval := false;
elsif world_check_iface.get_city_tc_status(p_req.WC_CITY_LIST_ID)  IN ('TC_OK','TC_PROVISIONAL') then /* check ciity sanction status */
provisional_approval := true;
else
provisional_approval := false;
end if;
end if;
end if;

if provisional_approval then
dbms_output.PUT_LINE ( ' provisional_approval = TRUE' );
else
dbms_output.PUT_LINE ( ' provisional_approval = FALSE' );
end if;


if provisional_approval = true then /* lets check sanction status for each match */

for x in get_contents loop
----dbms_output.put_line('world_check_iface.is_match_sanctioned(x.wc_content_id) '||world_check_iface.is_match_sanctioned(x.wc_content_id));

if world_check_iface.is_match_sanctioned(x.wc_content_id) = 'Y' then
provisional_approval := false;
end if;
end loop;

end if;

if p_req.status = 'Pending' then
if provisional_approval then
pending_status:='Provisional';
else
pending_status:='Pending Provisional';
end if;

v_sql:= 'UPDATE VSSL.WC_SCREENING_REQUEST
SET    STATUS = :1,
       STATUS_UPDATED_BY = :2,
       STATUS_DATE= :3
WHERE  WC_SCREENING_REQUEST_ID = :4 '
;
begin
 EXECUTE IMMEDIATE v_sql
 using
pending_status,
world_check_iface.c_automatic_approval_UID,   --WORLDCHECK_AUTOMATIC_APPROVAL
sysdate,
 p_req.WC_SCREENING_REQUEST_ID;

 exception when others then
 p_return_code:= -1;
 p_return_message := 'Create provisional TC error: '||SQLERRM;
 rollback;
 return;
 end;

commit;
end if;



end;

--
--SAURABH T20190307.0013 19-MAR-2019
FUNCTION is_trade_legal_user (p_user_id IN NUMBER)
   RETURN VARCHAR2
IS
   l_return   VARCHAR2 (1) := 'N';
BEGIN
   SELECT 'Y'
     INTO l_return
     FROM apps.fnd_lookup_values_vl flv, fnd_user fu
    WHERE lookup_type = 'RMI_TRADE_LEGAL_USERS'
      AND lookup_code = fu.user_name
      AND flv.enabled_flag = 'Y'
      AND TRUNC (SYSDATE) BETWEEN TRUNC (NVL (start_date_active, SYSDATE))
                              AND TRUNC (NVL (end_date_active, SYSDATE))
      AND fu.user_id = p_user_id;

   RETURN l_return;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN 'N';
END is_trade_legal_user;

-- T20190801.0023 - SAURABH 02-AUG-2019
FUNCTION name_in_blocklist (p_name_screened IN VARCHAR2, x_message OUT VARCHAR2)
   RETURN VARCHAR2
IS
   l_return   VARCHAR2 (1) := 'N';

BEGIN

   SELECT 'Y', block_message
     INTO l_return, x_message
     FROM VSSL.RMI_TC_ENTITIES_ON_BLOCKLIST
    WHERE TRIM(UPPER(entity_name)) = TRIM(UPPER(p_name_screened)) AND enabled_flag = 'Y';

   RETURN l_return;

EXCEPTION

   WHEN OTHERS
   THEN
      RETURN 'N';

END name_in_blocklist;

-- T20190801.0023 - SAURABH 02-AUG-2019
PROCEDURE send_notice_to_legal (p_name_screened IN VARCHAR2,x_message IN VARCHAR2)
IS
   conn                        UTL_SMTP.connection;
   email_text                  VARCHAR2 (5000);
   header_line                 VARCHAR2 (300);
   detail_line                 VARCHAR2 (4000);
   v_subject_line              VARCHAR2 (4000); -- ZK 06082018 T20180607.0017
   sender_email_address        VARCHAR2 (300);
   destination_email_address   VARCHAR2 (300);
   x_ref_data                  world_check_iface.xref_tab;
   comment1                    VARCHAR2 (100);
   comment2                    VARCHAR2 (100);
   email_message_full          VARCHAR2 (4000);
   email_message_line          VARCHAR2 (4000);
   error_message               VARCHAR2 (400)             := 'Success';
   cc                          VARCHAR2 (300);
BEGIN
   --
   sender_email_address := '#IRI-Trade@register-iri.com';
   destination_email_address :=
                          'Legal@register-iri.com,IRI-Trade@Register-IRI.com';
   v_subject_line :=
         'Trade Compliance for blocked entity '
      --
      || p_name_screened
      || ' has been initiated.'
      || '.';                                    -- ZK 06082018 T20180607.0017
   detail_line :=
      'Trade Compliance for blocked entity ' || p_name_screened || ' has been initiated.'
      ||'<BR><BR>'
      --||'See Nonpaper on U.S. Sanctions Targeting Iran''s Enrichment-Related Procurement Activities July 2019'
      || x_message;

   --cc := 'zkhan@register-iri.com,saurabh.agarwal@qspear.com';

   email_message_full := detail_line;
   conn :=
      demo_mail.begin_mail (sender          => sender_email_address,
                            cc              => cc,
                            recipients      => destination_email_address,
                            subject         => v_subject_line,
                            mime_type       => 'text/html'
                           );
   email_message_line := '<BR><BR>' || detail_line || '<BR><BR>';
   email_message_full := email_message_full || email_message_line;
   demo_mail.write_text (conn => conn, MESSAGE => email_message_line);
   email_message_line :=
      '<BR><BR><BR><BR><BR><BR><BR><center>This is an automated e-mail message. </center>';
   email_message_full := email_message_full || email_message_line;
   demo_mail.write_text (conn => conn, MESSAGE => email_message_line);
   demo_mail.end_mail (conn => conn);

EXCEPTION

   WHEN OTHERS
   THEN
      error_message := SQLERRM;

END send_notice_to_legal;

END  world_check_iface;
/


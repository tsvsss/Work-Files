DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://www.datanomic.com/ws">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:request>
         <ws:FullName></ws:FullName>
         <ws:Gender></ws:Gender>
         <ws:DateOfBirth></ws:DateOfBirth>
         <ws:YearOfBirth></ws:YearOfBirth>
      </ws:request>
   </soapenv:Body>
</soapenv:Envelope>'
   );
/*
   insert into xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'REQUEST_INDIVIDUAL'
      , v_xml
   );
*/
   
   UPDATE xwrl_parameters
   SET value_xml = v_xml
   where id = 'XML'
   and key = 'REQUEST_INDIVIDUAL_COMPRESSED';
   
   commit;

END;
/


DECLARE
   v_xml XMLTYPE;

BEGIN

 v_xml := xmltype ('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://www.datanomic.com/ws">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:request>
         <ws:EntityName></ws:EntityName>
      </ws:request>
   </soapenv:Body>
</soapenv:Envelope>'
   );



/*
   insert  into xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'REQUEST_ENTITY'
      , v_xml
   );
*/

   UPDATE xwrl_parameters
   SET value_xml = v_xml
   where id = 'XML'
   and key = 'REQUEST_ENTITY_COMPRESSED';
   
   commit;

END;
/

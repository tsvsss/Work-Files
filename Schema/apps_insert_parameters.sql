/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_insert_parameters.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                         $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : apps_insert_parameters.sql                                                                  *
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
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I      Remove Open from   CASE_ALERT_STATE_UI            *
* 19-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I      Update load balancer for Prod        *
*                                                                                                                   *
********************************************************************************************************************/

/* APPS */

truncate table xwrl.xwrl_parameters
;

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'POC'
   , 'http://129.150.84.227:8001'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIPRODOWS-PRI'
   , 'http://10.134.147.153:8001'
);
insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIPRODOWS-SEC'
   , 'http://10.134.147.154:8001'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIDROWS-PRI'
   , 'http://10.161.147.149:8001'
);
insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIDROWS-SEC'
   , 'http://10.161.147.150:8001'
);


insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'CONSOLE'
   , 'IRIPRODOWS-PRI'
   , 'http://10.134.147.153:7001'
);
insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'CONSOLE'
   , 'IRIPRODOWS-SEC'
   , 'http://10.134.147.154:7001'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'CONSOLE'
   , 'IRIDROWS-PRI'
   , 'http://10.161.147.149:7001'
);
insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'CONSOLE'
   , 'IRIDROWS-SEC'
   , 'http://10.161.147.150:7001'
);


insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIPRODOWS'
   , 'http://iriprodows.register-iri.com'
);
insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SERVER'
   , 'IRIDROWS'
   , 'http://iridrows.register-iri.com'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PATH'
   , 'INDIVIDUAL'
   , '/edq/webservices/Watchlist%20Screening:IndividualScreen'
);
insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PATH'
   , 'ENTITY'
   , '/edq/webservices/Watchlist%20Screening:EntityScreen'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PATH'
   , 'EDQ'
   , '/edq'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PATH'
   , 'CONSOLE'
   , '/console'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCER'
   , 'MAX_JOBS'
   , '70'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCER'
   , 'RATIO'
   , '5'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCE_SERVER'
   , 'IRIPROD'
   , 'IRIPRODOWS'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCE_SERVER'
   , 'IRITEST'
   , 'IRIDROWS'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCE_SERVER'
   , 'IRIDEV'
   , 'IRIDROWS'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'LOADBALANCE_SERVER'
   ,'IRIDR'
   , 'IRIDROWS'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PRIMARY_SERVER'
   , 'IRIPROD'
   , 'IRIPRODOWS-PRI'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PRIMARY_SERVER'
   , 'IRITEST'
   , 'IRIDROWS-PRI'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PRIMARY_SERVER'
   , 'IRIDEV'
   , 'IRIDROWS-PRI'
);


insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'PRIMARY_SERVER'
   , 'IRIDR'
   , 'IRIDROWS-PRI'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SECONDARY_SERVER'
   , 'IRIPROD'
   , 'IRIPRODOWS-SEC'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SECONDARY_SERVER'
   , 'IRITEST'
   , 'IRIDROWS-SEC'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SECONDARY_SERVER'
   , 'IRIDEV'
   , 'IRIDROWS-SEC'
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'SECONDARY_SERVER'
   , 'IRIDR'
   , 'IRIDROWS-SEC'
);




insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'MAX_JOBS'
   , 'IRIPRODOWS'
   ,250
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'MAX_JOBS'
   , 'IRIPRODOWS-PRI'
   , 25
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'MAX_JOBS'
   , 'IRIPRODOWS-SEC'
   ,7
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'MAX_JOBS'
   , 'IRIDROWS'
   ,25
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'MAX_JOBS'
   , 'IRIDROWS-PRI'
   ,25
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'MAX_JOBS'
   , 'IRIDROWS-SEC'
   , 7
);



insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'MAX_PAUSE'
   , 'IRIPRODOWS'
   ,0
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'MAX_PAUSE'
   , 'IRIPRODOWS-PRI'
   , 0
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'MAX_PAUSE'
   , 'IRIPRODOWS-SEC'
   ,0
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'MAX_PAUSE'
   , 'IRIDROWS'
   ,0
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'MAX_PAUSE'
   , 'IRIDROWS-PRI'
   ,0
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'MAX_PAUSE'
   , 'IRIDROWS-SEC'
   , 0
);




insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'FREQUENCY'
   , 'IRIPROD'
   , 5
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'FREQUENCY'
   , 'IRITEST'
   , 5
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'FREQUENCY'
   , 'IRIDEV'
   , 5
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'FREQUENCY'
   , 'IRIDR'
   , 5
);

DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://www.datanomic.com/ws">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:request>
         <ws:ListSubKey></ws:ListSubKey>
         <ws:ListRecordType></ws:ListRecordType>
         <ws:ListRecordOrigin></ws:ListRecordOrigin>
         <ws:CustId></ws:CustId>
         <ws:CustSubId></ws:CustSubId>
         <ws:PassportNumber></ws:PassportNumber>
         <ws:NationalId></ws:NationalId>
         <ws:Title></ws:Title>
         <ws:FullName></ws:FullName>
         <ws:GivenNames></ws:GivenNames>
         <ws:FamilyName></ws:FamilyName>
         <ws:NameType></ws:NameType>
         <ws:NameQuality></ws:NameQuality>
         <ws:PrimaryName></ws:PrimaryName>
         <ws:OriginalScriptName></ws:OriginalScriptName>
         <ws:Gender></ws:Gender>
         <ws:DateOfBirth></ws:DateOfBirth>
         <ws:YearOfBirth></ws:YearOfBirth>
         <ws:Occupation></ws:Occupation>
         <ws:Address1></ws:Address1>
         <ws:Address2></ws:Address2>
         <ws:Address3></ws:Address3>
         <ws:Address4></ws:Address4>
         <ws:City></ws:City>
         <ws:State></ws:State>
         <ws:PostalCode></ws:PostalCode>
         <ws:AddressCountryCode></ws:AddressCountryCode>
         <ws:ResidencyCountryCode></ws:ResidencyCountryCode>
         <ws:CountryOfBirthCode></ws:CountryOfBirthCode>
         <ws:NationalityCountryCodes></ws:NationalityCountryCodes>
         <ws:ProfileHyperlink></ws:ProfileHyperlink>
         <ws:RiskScore></ws:RiskScore>
         <ws:DataConfidenceScore></ws:DataConfidenceScore>
         <ws:DataConfidenceComment></ws:DataConfidenceComment>
         <ws:CustomString1></ws:CustomString1>
         <ws:CustomString2></ws:CustomString2>
         <ws:CustomString3></ws:CustomString3>
         <ws:CustomString4></ws:CustomString4>
         <ws:CustomString5></ws:CustomString5>
         <ws:CustomString6></ws:CustomString6>
         <ws:CustomString7></ws:CustomString7>
         <ws:CustomString8></ws:CustomString8>
         <ws:CustomString9></ws:CustomString9>
         <ws:CustomString10></ws:CustomString10>
         <ws:CustomString11></ws:CustomString11>
         <ws:CustomString12></ws:CustomString12>
         <ws:CustomString13></ws:CustomString13>
         <ws:CustomString14></ws:CustomString14>
         <ws:CustomString15></ws:CustomString15>
         <ws:CustomString16></ws:CustomString16>
         <ws:CustomString17></ws:CustomString17>
         <ws:CustomString18></ws:CustomString18>
         <ws:CustomString19></ws:CustomString19>
         <ws:CustomString20></ws:CustomString20>
         <ws:CustomString21></ws:CustomString21>
         <ws:CustomString22></ws:CustomString22>
         <ws:CustomString23></ws:CustomString23>
         <ws:CustomString24></ws:CustomString24>
         <ws:CustomString25></ws:CustomString25>
         <ws:CustomString26></ws:CustomString26>
         <ws:CustomString27></ws:CustomString27>
         <ws:CustomString28></ws:CustomString28>
         <ws:CustomString29></ws:CustomString29>
         <ws:CustomString30></ws:CustomString30>
         <ws:CustomString31></ws:CustomString31>
         <ws:CustomString32></ws:CustomString32>
         <ws:CustomString33></ws:CustomString33>
         <ws:CustomString34></ws:CustomString34>
         <ws:CustomString35></ws:CustomString35>
         <ws:CustomString36></ws:CustomString36>
         <ws:CustomString37></ws:CustomString37>
         <ws:CustomString38></ws:CustomString38>
         <ws:CustomString39></ws:CustomString39>
         <ws:CustomString40></ws:CustomString40>
         <ws:CustomDate1></ws:CustomDate1>
         <ws:CustomDate2></ws:CustomDate2>
         <ws:CustomDate3></ws:CustomDate3>
         <ws:CustomDate4></ws:CustomDate4>
         <ws:CustomDate5></ws:CustomDate5>
         <ws:CustomNumber1></ws:CustomNumber1>
         <ws:CustomNumber2></ws:CustomNumber2>
         <ws:CustomNumber3></ws:CustomNumber3>
         <ws:CustomNumber4></ws:CustomNumber4>
         <ws:CustomNumber5></ws:CustomNumber5>
      </ws:request>
   </soapenv:Body>
</soapenv:Envelope>'
   );

   insert /*+ append */ into xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'REQUEST_INDIVIDUAL'
      , v_xml
   );

END;
/

DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://www.datanomic.com/ws">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:request>
         <ws:FullName></ws:FullName>
         <ws:DateOfBirth></ws:DateOfBirth>
      </ws:request>
   </soapenv:Body>
</soapenv:Envelope>'
   );

   insert /*+ append */ into xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'REQUEST_INDIVIDUAL_COMPRESSED'
      , v_xml
   );

END;
/

DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://www.datanomic.com/ws">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:request>
         <ws:ListSubKey></ws:ListSubKey>
         <ws:ListRecordType></ws:ListRecordType>
         <ws:ListRecordOrigin></ws:ListRecordOrigin>
         <ws:CustId></ws:CustId>
         <ws:CustSubId></ws:CustSubId>
         <ws:RegistrationNumber></ws:RegistrationNumber>
         <ws:EntityName></ws:EntityName>
         <ws:NameType></ws:NameType>
         <ws:NameQuality></ws:NameQuality>
         <ws:PrimaryName></ws:PrimaryName>
         <ws:OriginalScriptName></ws:OriginalScriptName>
         <ws:AliasIsAcronym></ws:AliasIsAcronym>
         <ws:Address1></ws:Address1>
         <ws:Address2></ws:Address2>
         <ws:Address3></ws:Address3>
         <ws:Address4></ws:Address4>
         <ws:City></ws:City>
         <ws:State></ws:State>
         <ws:PostalCode></ws:PostalCode>
         <ws:AddressCountryCode></ws:AddressCountryCode>
         <ws:RegistrationCountryCode></ws:RegistrationCountryCode>
         <ws:OperatingCountryCodes></ws:OperatingCountryCodes>
         <ws:ProfileHyperlink></ws:ProfileHyperlink>
         <ws:RiskScore></ws:RiskScore>
         <ws:DataConfidenceScore></ws:DataConfidenceScore>
         <ws:DataConfidenceComment></ws:DataConfidenceComment>
         <ws:CustomString1></ws:CustomString1>
         <ws:CustomString2></ws:CustomString2>
         <ws:CustomString3></ws:CustomString3>
         <ws:CustomString4></ws:CustomString4>
         <ws:CustomString5></ws:CustomString5>
         <ws:CustomString6></ws:CustomString6>
         <ws:CustomString7></ws:CustomString7>
         <ws:CustomString8></ws:CustomString8>
         <ws:CustomString9></ws:CustomString9>
         <ws:CustomString10></ws:CustomString10>
         <ws:CustomString11></ws:CustomString11>
         <ws:CustomString12></ws:CustomString12>
         <ws:CustomString13></ws:CustomString13>
         <ws:CustomString14></ws:CustomString14>
         <ws:CustomString15></ws:CustomString15>
         <ws:CustomString16></ws:CustomString16>
         <ws:CustomString17></ws:CustomString17>
         <ws:CustomString18></ws:CustomString18>
         <ws:CustomString19></ws:CustomString19>
         <ws:CustomString20></ws:CustomString20>
         <ws:CustomString21></ws:CustomString21>
         <ws:CustomString22></ws:CustomString22>
         <ws:CustomString23></ws:CustomString23>
         <ws:CustomString24></ws:CustomString24>
         <ws:CustomString25></ws:CustomString25>
         <ws:CustomString26></ws:CustomString26>
         <ws:CustomString27></ws:CustomString27>
         <ws:CustomString28></ws:CustomString28>
         <ws:CustomString29></ws:CustomString29>
         <ws:CustomString30></ws:CustomString30>
         <ws:CustomString31></ws:CustomString31>
         <ws:CustomString32></ws:CustomString32>
         <ws:CustomString33></ws:CustomString33>
         <ws:CustomString34></ws:CustomString34>
         <ws:CustomString35></ws:CustomString35>
         <ws:CustomString36></ws:CustomString36>
         <ws:CustomString37></ws:CustomString37>
         <ws:CustomString38></ws:CustomString38>
         <ws:CustomString39></ws:CustomString39>
         <ws:CustomString40></ws:CustomString40>
         <ws:CustomDate1></ws:CustomDate1>
         <ws:CustomDate2></ws:CustomDate2>
         <ws:CustomDate3></ws:CustomDate3>
         <ws:CustomDate4></ws:CustomDate4>
         <ws:CustomDate5></ws:CustomDate5>
         <ws:CustomNumber1></ws:CustomNumber1>
         <ws:CustomNumber2></ws:CustomNumber2>
         <ws:CustomNumber3></ws:CustomNumber3>
         <ws:CustomNumber4></ws:CustomNumber4>
         <ws:CustomNumber5></ws:CustomNumber5>
      </ws:request>
   </soapenv:Body>
</soapenv:Envelope>'
   );

   insert /*+ append */ into xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'REQUEST_ENTITY'
      , v_xml
   );

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
</soapenv:Envelope>	
'
   );

   insert /*+ append */ into xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'REQUEST_ENTITY_COMPRESSED'
      , v_xml
   );

END;
/


DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:dn="http://www.datanomic.com/ws">
  <env:Header/>
  <env:Body>
    <dn:response>
      <dn:record>
        <dn:ListKey></dn:ListKey>
         <dn:ListSubKey></dn:ListSubKey>
         <dn:ListRecordType></dn:ListRecordType>
         <dn:ListRecordOrigin></dn:ListRecordOrigin>
         <dn:ListId></dn:ListId>
         <dn:ListGivenNames></dn:ListGivenNames>
         <dn:ListFamilyName></dn:ListFamilyName>
         <dn:ListFullName></dn:ListFullName>
         <dn:ListNameType></dn:ListNameType>
        <dn:ListPrimaryName></dn:ListPrimaryName>
        <dn:ListOriginalScriptName></dn:ListOriginalScriptName>
        <dn:ListDOB></dn:ListDOB>
        <dn:ListCity></dn:ListCity>
        <dn:ListCountry></dn:ListCountry>
        <dn:ListCountryOfBirth></dn:ListCountryOfBirth>
        <dn:ListNationality></dn:ListNationality>
        <dn:MatchRule></dn:MatchRule>
        <dn:MatchScore></dn:MatchScore>
        <dn:CaseKey></dn:CaseKey>
        <dn:AlertId></dn:AlertId>
        <dn:RiskScore></dn:RiskScore>
        <dn:RiskScorePEP></dn:RiskScorePEP>
        <dn:Category></dn:Category>
            <dn:dnPassportNumber></dn:dnPassportNumber>
            <dn:dnNationalId></dn:dnNationalId>
            <dn:dnTitle></dn:dnTitle>
            <dn:dnYOB></dn:dnYOB>
            <dn:dnGender></dn:dnGender>
            <dn:DeceasedFlag></dn:DeceasedFlag>
            <dn:DeceasedDate></dn:DeceasedDate>
            <dn:dnOccupation></dn:dnOccupation>
            <dn:dnAddress></dn:dnAddress>
            <dn:dnCity></dn:dnCity>
            <dn:dnState></dn:dnState>
            <dn:dnPostalCode></dn:dnPostalCode>
            <dn:dnAddressCountryCode></dn:dnAddressCountryCode>
            <dn:dnResidencyCountryCode></dn:dnResidencyCountryCode>
            <dn:dnCountryOfBirthCode></dn:dnCountryOfBirthCode>
            <dn:dnNationalityCountryCodes></dn:dnNationalityCountryCodes>
            <dn:ExternalSources></dn:ExternalSources>
            <dn:CachedExtSources></dn:CachedExtSources>
            <dn:dnAddedDate></dn:dnAddedDate>
            <dn:dnLastUpdatedDate></dn:dnLastUpdatedDate>
             <dn:AdditionalInformation></dn:AdditionalInformation>
             <dn:dnAddressCountry></dn:dnAddressCountry>
             <dn:dnResidencyCountry></dn:dnResidencyCountry>
             <dn:dnCountryOfBirthCountry></dn:dnCountryOfBirthCountry>
             <dn:dnNationalitiesCountries></dn:dnNationalitiesCountries>
             <dn:dnAllCountries></dn:dnAllCountries>            
      </dn:record>	
    </dn:response>
  </env:Body>
</env:Envelope>      
'
   );

   insert /*+ append */ into xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'RESPONSE_INDIVIDUAL'
      , v_xml
   );

END;
/

DECLARE
   v_xml XMLTYPE;

BEGIN

   v_xml := xmltype ('<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:dn="http://www.datanomic.com/ws">
  <env:Header/>
  <env:Body>
    <dn:response>
      <dn:record>
        <dn:ListKey></dn:ListKey>
        <dn:ListSubKey></dn:ListSubKey>
        <dn:ListRecordType></dn:ListRecordType>
        <dn:ListRecordOrigin></dn:ListRecordOrigin>
        <dn:ListId></dn:ListId>
        <dn:ListEntityName></dn:ListEntityName>
        <dn:ListPrimaryName></dn:ListPrimaryName>
        <dn:ListOriginalScriptName></dn:ListOriginalScriptName>
        <dn:ListNameType></dn:ListNameType>
        <dn:ListCity></dn:ListCity>
        <dn:ListCountry></dn:ListCountry>
        <dn:ListOperatingCountries></dn:ListOperatingCountries>
        <dn:ListRegistrationCountries></dn:ListRegistrationCountries>
        <dn:MatchRule></dn:MatchRule>
        <dn:MatchScore></dn:MatchScore>
        <dn:CaseKey></dn:CaseKey>
        <dn:AlertId></dn:AlertId>
        <dn:RiskScore></dn:RiskScore>
        <dn:RiskScorePEP></dn:RiskScorePEP>  
        			<dn:Category></dn:Category>
            <dn:dnRegistrationNumber></dn:dnRegistrationNumber>
            <dn:dnOriginalEntityName></dn:dnOriginalEntityName>
            <dn:dnEntityName></dn:dnEntityName>
            <dn:dnNameType></dn:dnNameType>
            <dn:dnNameQuality></dn:dnNameQuality>
            <dn:dnPrimaryName></dn:dnPrimaryName>
            <dn:dnVesselIndicator></dn:dnVesselIndicator>
            <dn:dnVesselInfo></dn:dnVesselInfo>
            <dn:dnAddress></dn:dnAddress>
            <dn:dnCity></dn:dnCity>
            <dn:dnState></dn:dnState>
            <dn:dnPostalCode></dn:dnPostalCode>
            <dn:dnAddressCountryCode></dn:dnAddressCountryCode>
            <dn:dnRegistrationCountryCode></dn:dnRegistrationCountryCode>
            <dn:dnOperatingCountryCodes></dn:dnOperatingCountryCodes>
            <dn:dnPEPClassification></dn:dnPEPClassification>
            <dn:dnAllCountryCodes></dn:dnAllCountryCodes>
            <dn:ExternalSources></dn:ExternalSources>
            <dn:CachedExtSources></dn:CachedExtSources>
            <dn:dnInactiveFlag></dn:dnInactiveFlag>
            <dn:dnInactiveSinceDate></dn:dnInactiveSinceDate>
            <dn:dnAddedDate></dn:dnAddedDate>
            <dn:dnLastUpdatedDate></dn:dnLastUpdatedDate>            
            <dn:AdditionalInformation></dn:AdditionalInformation>
            <dn:dnAddressCountry></dn:dnAddressCountry>
            <dn:dnRegistrationCounty></dn:dnRegistrationCounty>
            <dn:dnOperatingCountries></dn:dnOperatingCountries>
            <dn:dnAllCountries></dn:dnAllCountries>
      </dn:record>	
    </dn:response>
  </env:Body>
</env:Envelope>      
'
   );

   insert /*+ append */ into xwrl_parameters (
      id
      , key
      , value_xml
   ) VALUES (
      'XML'
      , 'RESPONSE_ENTITY'
      , v_xml
   );

END;
/
insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_STATUS'
   , 'O'   
   , 'Open'
   , 1
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_STATUS'
   , 'C'   
   , 'Closed'
   , 2
);



insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_STATE'
   , 'N'
   , 'New'   
   , 1
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_STATE'
   , 'ACT'
   , 'Active'   
   , 2
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_STATE'
      , 'A'
   , 'Approved'
   , 3
);
insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_STATE'
   , 'R'
   , 'Rejected'   
   , 4
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_STATE'
, 'I'   
   , 'Inactive'
   , 5
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_STATE'
, 'M'   
   , 'Merge'
   , 6
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_STATE'
, 'D'   
   , 'Delete'
   , 7
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_STATE'
, 'E'   
   , 'Error'
   , 8
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_WORK_FLOW'
   , 'P'   
   , 'Pending'
   , 1
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_WORK_FLOW'
   , 'L'   
   , 'Legal Review'
   , 2
);
insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_WORK_FLOW'
      , 'SL'
   , 'Senior Legal Review'
   , 3
);

insert /*+ append */ into xwrl.xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_WORK_FLOW'
   , 'A'   
   , 'Approved'
   , 4
);

insert /*+ append */ into xwrl.xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_WORK_FLOW'
      , 'PR'
   , 'Provisional'
   , 5
);

insert /*+ append */ into xwrl.xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_WORK_FLOW'
      , 'PP'
   , 'Pending Provisional'
   , 6
);

insert /*+ append */ into xwrl.xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_WORK_FLOW'
      , 'H'
   , 'On Hold'
   ,7
);

insert /*+ append */ into xwrl.xwrl_parameters (
   id
   , key
   , value_string
   , sort_order
) VALUES (
   'CASE_WORK_FLOW'
      , 'R'
   , 'Rejected'
   ,8
);

insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING) VALUES ('WIP_DEPARTMENT_NAMES', 'Corporate', 'Corporate');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING) VALUES ('WIP_DEPARTMENT_NAMES', 'Seafarers', 'Seafarers');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING) VALUES ('WIP_DEPARTMENT_NAMES', 'Vessel', 'Vessel');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING) VALUES ('WIP_DEPARTMENT_NAMES', 'Vessel Vetting', 'VesselVetting');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING) VALUES ('WIP_DEPARTMENT_NAMES', 'All', 'All');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING) VALUES ('WIP_DEPARTMENT_NAMES', 'Unknown', 'Unknown');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING) VALUES ('WIP_DEPARTMENT_NAMES', 'Inspectors', 'Inspectors');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING) VALUES ('WIP_DEPARTMENT_NAMES', 'Customer', 'Customer');
     
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER) VALUES ('WIP_PENDING_TC_OPTIONS', 'Created by Me', 'ME',1);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER) VALUES ('WIP_PENDING_TC_OPTIONS', 'My Location', 'location',2);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER) VALUES ('WIP_PENDING_TC_OPTIONS', 'All', 'All',3);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER) VALUES ('WIP_PENDING_TC_OPTIONS', 'Backlog', 'Backlog',4);

insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','AlertId','Alert Id','N',10);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','CachedExtSources','Cached Links','Y',21);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','CaseKey','Case Number','N',30);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','Category','Category','Y',40);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','DeceasedDate','Date of Death','Y',9);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','DeceasedFlag','Deceased','Y',8);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnAddedDate','Date Added','N',310);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnAddress','Address','N',320);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnAddressCountryCode','Address Country','N',330);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnAllCountryCodes','All Country Codes','N',340);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnCity','City','N',350);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnCountryOfBirthCode','Country of Birth','N',360);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnEntityName','Name','N',370);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnGender','Gender','Y',7);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnInactiveFlag','Inactive Flag','N',390);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnInactiveSinceDate','Inactive Since Date','N',400);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnLastUpdatedDate','Date Updated','Y',24);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnNameQuality','paQuality','N',420);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnNameType','Name Type','N',430);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnNationalId','ID Number','Y',19);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnNationalityCountryCodes','Nationality Countries','N',450);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnOccupation','Occupation','N',460);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnOperatingCountryCodes','Operating Countries','N',470);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnOriginalEntityName','Original Name','N',480);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnPassportNumber','Passport Number','Y',18);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnPEPClassification','PEP Classification','N',490);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnPostalCode','Postal Code','N',510);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnPrimaryName','Primary Name','N',520);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnRegistrationCountryCode','Registration Country','N',530);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnRegistrationNumber','Registration Number','N',540);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnResidencyCountryCode','Country of Residence','N',10);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnState','State','Y',14);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnTitle','Title','N',570);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnVesselIndicator','Vessel Y/N','N',580);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnVesselInfo','Vessel Name','N',590);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnYOB','YOB','Y',6);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ExternalSources','Links','Y',21);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListCity','City','Y',13);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListCountry','Country','N',12);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListCountryOfBirth','Country of Birth','N',15);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListDOB','DOB','Y',5);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListEntityName','Name','N',120);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListFamilyName','Family Name','Y',3);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListFullName','Full Name','Y',1);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListGivenNames','Given Name','Y',4);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListId','UID','Y',26);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListKey','Source','Y',27);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListNameType','Name Type','Y',2);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListNationality','Nationality','N',11);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListOperatingCountries','Operating Countries','N',200);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListOriginalScriptName','Original Script Name','N',210);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListPrimaryName','Primary Name','N',220);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListRecordOrigin','Record Origin','N',230);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListRecordType','Record Type','N',240);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListRegistrationCountries','Registration Countries','N',250);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','ListSubKey','Sub Key','N',260);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','MatchRule','Match Rule','N',270);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','MatchScore','Match Score','Y',25);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','RiskScore','Risk Score','N',290);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','RiskScorePEP','Risk Score PEP','N',300);

UPDATE XWRL_PARAMETERS
SET SORT_ORDER = SORT_ORDER * 10
WHERE ID = 'RESPONSE_ROWS';

UPDATE XWRL_PARAMETERS
SET SORT_ORDER = 15
,DISPLAY_FLAG = 'Y'
WHERE ID = 'RESPONSE_ROWS'
AND KEY = 'ListEntityName';

UPDATE XWRL_PARAMETERS
SET SORT_ORDER = 17
,DISPLAY_FLAG = 'Y'
WHERE ID = 'RESPONSE_ROWS'
AND KEY = 'ListPrimaryName';

UPDATE XWRL_PARAMETERS
SET SORT_ORDER = 122
,DISPLAY_FLAG = 'Y'
,VALUE_STRING = 'Operating Office Country'
WHERE ID = 'RESPONSE_ROWS'
AND KEY = 'ListOperatingCountries';

UPDATE XWRL_PARAMETERS
SET SORT_ORDER = 125
,DISPLAY_FLAG = 'Y'
,VALUE_STRING = 'Country of Domiciliation'
WHERE ID = 'RESPONSE_ROWS'
AND KEY = 'ListOperatingCountries';

UPDATE XWRL_PARAMETERS
SET SORT_ORDER = 192
,DISPLAY_FLAG = 'Y'
WHERE ID = 'RESPONSE_ROWS'
AND KEY = 'dnVesselIndicator';

UPDATE XWRL_PARAMETERS
SET SORT_ORDER = 195
,DISPLAY_FLAG = 'Y'
WHERE ID = 'RESPONSE_ROWS'
AND KEY = 'dnVesselInfo';

update XWRL_PARAMETERS
set display_flag = 'N'
WHERE ID = 'RESPONSE_ROWS'
and VALUE_STRING like '%Count%';

insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','AdditionalInformation','Summary','Y',92);
--  insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnAddressCountry','Country of Address','Y',93);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnResidencyCountry','Country of Residency','Y',94);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnNationalitiesCountries','Countries of Nationality','Y',95);
-- insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnCountryOfBirthCountry','Country of Birth','Y',95);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnRegistrationCounty','Country of Domiciliation','Y',97);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnOperatingCountries','Countries of Operation','Y',98);
insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING,DISPLAY_FLAG,SORT_ORDER) VALUES ('RESPONSE_ROWS','dnAllCountries','All Countries','Y',99);

UPDATE XWRL_PARAMETERS
SET SORT_ORDER = 93
,DISPLAY_FLAG = 'Y'
WHERE ID = 'RESPONSE_ROWS'
AND KEY = 'dnAddressCountry';

UPDATE XWRL_PARAMETERS
SET SORT_ORDER = 95
,DISPLAY_FLAG = 'Y'
WHERE ID = 'RESPONSE_ROWS'
AND KEY = 'dnCountryOfBirthCountry';

update xwrl_parameters
set display_flag = 'Y'
,sort_order = 185
where id = 'RESPONSE_ROWS'
and key = 'Category';



insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING) values
('TRADE_URL','IRIDEV','http://iriadf-dev.register-iri.com/TradeCompliance/faces/Request');

insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING) values
('TRADE_URL','IRITEST','http://iriadf-dev.register-iri.com/TradeCompliance/faces/Request');

insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING) values
('TRADE_URL','IRIDR','https://iriadf-dr.register-iri.com/TradeCompliance/faces/Request');

insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING) values
('TRADE_URL','IRIPROD','http://iriadf-ows-m1.register-iri.com/TradeCompliance/faces/Request');

insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING) values
('STATUSBOARD_URL','IRIDEV','http://iriadf-dev.register-iri.com/TradeCompliance/faces/Statusboard');

insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING) values
('STATUSBOARD_URL','IRITEST','http://iriadf-dev.register-iri.com/TradeCompliance/faces/Statusboard');

insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING) values
('STATUSBOARD_URL','IRIDR','https://iriadf-dr.register-iri.com/TradeCompliance/faces/Statusboard');

insert /*+ append */ into XWRL.XWRL_PARAMETERS (ID, KEY, VALUE_STRING) values
('STATUSBOARD_URL','IRIPROD','http://iriadf-ows-m1.register-iri.com/TradeCompliance/faces/Statusboard');


insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER) VALUES ('CASE_PRIORITY',1,'High',1);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER) VALUES ('CASE_PRIORITY',2,'Medium',2);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER) VALUES ('CASE_PRIORITY',3,'Low',3);

insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER) VALUES ('CASE_RISK',3,'High',1);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER) VALUES ('CASE_RISK',2,'Medium',2);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER) VALUES ('CASE_RISK',1,'Low',3);

insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','INSP','INSPECTIONS',null);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','INSPO','INSPECTIONS-OFFSHORE',null);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','TECH','TECHNICAL',null);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','SICD','SEAFARERS','Y');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','INV','INVESTIGATIONS',null);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','RAD','RADIO',null);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','RA','REGULATORY AFFAIRS',null);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','SS','SHIP SECURITY',null);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','VESDOC','VESSEL DOCUMENTATION','Y');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','VESREG','VESSEL REGISTRATION','Y');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','Y','YACHTS',null);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','YT','YACHT TECHNICAL',null);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','CORP','CORPORATE','Y');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','ACCT','ACCOUNTING',null);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','MAR','MARITIME',null);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','YC','YACHT CREW',null);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,DISPLAY_FLAG)  VALUES ('CASE_DEPARTMENTS','YINSP','YACHT INSPECTIONS',null);

insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_REJECTION','SAN','Sanctioned',1);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_REJECTION','BLKLST','Blacklisted',2);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_REJECTION','BLOCK','Blocked',3);

insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_DOCUMENTS','CRAINT','CRA - Internal',10);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_DOCUMENTS','CRAEXT','CRA - External',20);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_DOCUMENTS','UAINT','UA - Internal',30);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_DOCUMENTS','UAEXT','UA - External',40);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_DOCUMENTS','ACK','Acknowledgement',50);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_DOCUMENTS','KYC','Know Your Client',60);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_DOCUMENTS','LGL','Legalization',70);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_DOCUMENTS','CIN','Certificate of Incumbency',80);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_DOCUMENTS','DIS','Dissolution',90);

insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_TYPE','INDIVIDUAL','Individual',1);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_TYPE','ENTITY','Entity',2);

insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_RESTRICTED_COUNTRIES','RUSS','Russian Federation',1);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_RESTRICTED_COUNTRIES','UKRA','Ukraine',2);

insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',1156,'TSUAZO');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',4119,'ZKHAN');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',9180,'GVELLA');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',5460,'LWAN');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',7388,'VTONDAPU');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',10429,'TCIGARSKI');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',9406,'EENGEBRITSON');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',6245,'PFEILD');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',3268,'CHICKMAN');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',6435,'EGOLDMAN');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',3182,'MKIRBY');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',8594,'FSHIN');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',3169,'AWILSON');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',10648,'AWITTIG');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_ASSIGNMENT',10566,'LZHANG');


insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','SANFALSE','SAN - False Positive',1);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','EDDFALSE','EDD - False Positive',4);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','PEPFALSE','PEP - False Positive',7);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','SANPOS','SAN - Positive',10);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','EDDPOS','EDD - Positive',13);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','PEPPOS','PEP - Positive',16);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','SANPBL','SAN - Possible',19);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','EDDPBL','EDD - Possible',22);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','PEPPBL','PEP - Possible',25);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','SANOPEN','SAN - Open',28);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','EDDOPEN','EDD - Open',30);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','PEPOPEN','PEP - Open',33);

insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','SANCLOSE','SAN - Closed',34);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','EDDCLOSE','EDD - Closed',35);
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES ('CASE_ALERT_STATE','PEPCLOSE','PEP - Closed',36);

insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_RESTRICTIONS','TERR','TERRORISM');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_RESTRICTIONS','BLKLST','BLACKLISTED');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_RESTRICTIONS','CRTERR','CRIME - TERROR');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_RESTRICTIONS','NONCVTTERR','NONCONVICTION TERROR');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_RESTRICTIONS','CNAR','CRIME - NARCOTICS');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_RESTRICTIONS','CORG','CRIME - ORGANIZED');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_RESTRICTIONS','COTHER','CRIME - OTHER');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_RESTRICTIONS','CWAR','CRIME - WAR');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_RESTRICTIONS','MIL','MILITARY');
insert /*+ append */ into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING)  VALUES ('CASE_RESTRICTIONS','POLIND','POLITICAL INDIVIDUAL');



UPDATE XWRL_PARAMETERS
SET SORT_ORDER = SORT_ORDER * 10
where id = 'CASE_ALERT_STATE';


UPDATE XWRL_PARAMETERS
SET VALUE_STRING = initcap(value_string)
where id = 'CASE_DEPARTMENTS';


--  INSERT INTO XWRL_PARAMETERS(ID, KEY, VALUE_STRING,SORT_ORDER) VALUES('CASE_ALERT_STATE_UI','OPEN','Open',100); -- Should not be on the list
  INSERT INTO XWRL_PARAMETERS (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES('CASE_ALERT_STATE_UI','POS','Positive',200);
  INSERT INTO XWRL_PARAMETERS (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES('CASE_ALERT_STATE_UI','PBL','Possible',300);
  INSERT INTO XWRL_PARAMETERS (ID, KEY, VALUE_STRING,SORT_ORDER)  VALUES('CASE_ALERT_STATE_UI','FALSE','False Positive',400);
  
  
  select *
  from xwrl_parameters
  ;
  

INSERT INTO XWRL_PARAMETERS(ID, KEY, VALUE_STRING) VALUES ('CASE_REJECTION','OTHR','Other');


insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'EBS_PAUSE'
   , 'IRIPRODOWS'
   ,0
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'EBS_PAUSE'
   , 'IRIPRODOWS-PRI'
   , 0
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'EBS_PAUSE'
   , 'IRIPRODOWS-SEC'
   ,0
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'EBS_PAUSE'
   , 'IRIDROWS'
   ,0
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'EBS_PAUSE'
   , 'IRIDROWS-PRI'
   ,1
);

insert /*+ append */ into xwrl_parameters (
   id
   , key
   , value_string
) VALUES (
   'EBS_PAUSE'
   , 'IRIDROWS-SEC'
   , 0
);


/* Note: tsuazo Testing new OWS filters on 150.  Need to point the requests to 149 10-OCT-2019 */

declare

v_instance varchar2(10);

BEGIN

select instance_name into v_instance from v$instance;

if v_instance <> 'IRIPROD' then


update xwrl_parameters
set value_string = 'IRIDROWS-PRI'
where id = 'LOADBALANCE_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIDROWS-PRI'
where id = 'PRIMARY_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIDROWS-PRI'
where id = 'SECONDARY_SERVER'
and key =  (select instance_name from v$instance);


end if;



END;
/

COMMIT;

   insert  into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING) VALUES ('XML', 'COMPRESSED_XML', 'FALSE');

SELECT * 
FROM XWRL_PARAMETERS
WHERE ID = 'XML'
AND key = 'COMPRESSED_XML'
;

UPDATE XWRL_PARAMETERS
SET VALUE_STRING = 'TRUE'
WHERE ID = 'XML'
AND key = 'COMPRESSED_XML';

UPDATE XWRL_PARAMETERS
SET VALUE_STRING = 'FALSE'
WHERE ID = 'XML'
AND key = 'COMPRESSED_XML';


select *
from xwrl_parameters
;

insert  into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING, creation_date, last_update_date, created_by, last_updated_by) VALUES ('REQUEST_SOURCE', 'SICD_EXTERNAL', 'Filing Agent',sysdate,sysdate,1156,1156);
insert  into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING, creation_date, last_update_date, created_by, last_updated_by) VALUES ('REQUEST_SOURCE', 'CORP_EXTERNAL', 'ESR',sysdate,sysdate,1156,1156);
insert  into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING, creation_date, last_update_date, created_by, last_updated_by) VALUES ('REQUEST_SOURCE', 'VSSL_EXTERNAL', 'ERB',sysdate,sysdate,1156,1156);

SELECT
    id,
    key,
    value_string
FROM
    xwrl_parameters
WHERE
    id = 'REQUEST_SOURCE'
ORDER BY
    value_string
;

alter table xwrl.xwrl_requests 
add (external_source varchar2(30));
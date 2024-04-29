/* APPS */

select *
from v$tablespace;

select *
from database_properties
where property_name like 'DEFAULT%TABLESPACE';


create user xwrl identified by xwrl;

alter user xwrl
DEFAULT TABLESPACE APPS_TS_TX_DATA
TEMPORARY TABLESPACE TEMP;

grant connect, resource to xwrl;

grant create session to xwrl;

grant unlimited tablespace to xwrl;

grant execute on utl_http  to xwrl;
grant execute on dbms_lock to xwrl;

create synonym xwrl_keywords for xwrl.xwrl_keywords;

create synonym xwrl_location_types for xwrl.xwrl_location_types;

create synonym xwrl_parameters for xwrl.xwrl_parameters;

create synonym xwrl_requests for xwrl.xwrl_requests;

create synonym xwrl_requests_seq for xwrl.xwrl_requests_seq;


/* XWRL */

DROP SEQUENCE xwrl_requests_seq;

DROP TABLE xwrl_keywords CASCADE CONSTRAINTS;

DROP TABLE xwrl_location_types CASCADE CONSTRAINTS;

DROP TABLE xwrl_parameters CASCADE CONSTRAINTS;

DROP TABLE xwrl_requests  CASCADE CONSTRAINTS;

CREATE SEQUENCE xwrl_requests_seq START WITH 1000 NOCACHE;

CREATE TABLE xwrl_keywords (
    keyword_abbreviation   VARCHAR2(30) NOT NULL,
    full_name_of_source    VARCHAR2(500) NOT NULL,
    country_of_authority   VARCHAR2(100),
    type                   VARCHAR2(50),
    explanation            VARCHAR2(3000) NOT NULL,
    last_update_date       DATE,
    last_updated_by        NUMBER(15),
    creation_date          DATE,
    created_by             NUMBER(15),
    last_update_login      NUMBER(15)
)
LOGGING;

ALTER TABLE xwrl_keywords ADD CONSTRAINT xwrl_keywords_pk PRIMARY KEY ( keyword_abbreviation );

CREATE TABLE xwrl_location_types (
    loc_type            VARCHAR2(30) NOT NULL,
    country             VARCHAR2(100) NOT NULL,
    full_name           VARCHAR2(500) NOT NULL,
    last_update_date    DATE,
    last_updated_by     NUMBER(15),
    creation_date       DATE,
    created_by          NUMBER(15),
    last_update_login   NUMBER(15)
)
LOGGING;

ALTER TABLE xwrl_location_types ADD CONSTRAINT xwrl_location_types_pk PRIMARY KEY ( loc_type );

CREATE TABLE xwrl_parameters (
    id                  VARCHAR2(100) NOT NULL,
    key                 VARCHAR2(500) NOT NULL,
    value_string        VARCHAR2(500),
    value_date          DATE,
    value_xml           XMLTYPE,
    value_clob          CLOB,
    last_update_date    DATE,
    last_updated_by     NUMBER(15),
    creation_date       DATE,
    created_by          NUMBER(15),
    last_update_login   NUMBER(15)
)
LOGGING XMLTYPE COLUMN value_xml STORE AS BINARY XML (
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 BUFFER_POOL DEFAULT )
    RETENTION
    ENABLE STORAGE IN ROW
    NOCACHE
);

ALTER TABLE xwrl_parameters ADD CONSTRAINT xwrl_parameters_pk PRIMARY KEY ( id,
key );

CREATE TABLE xwrl_requests (
    id                  INTEGER NOT NULL,
    resubmit_id integer,
    server              VARCHAR2(100),
    path                VARCHAR2(100),
    request             XMLTYPE,
    response            XMLTYPE,
    status              VARCHAR2(30),
    error_code          VARCHAR2(100),
    error_message       VARCHAR2(1000),
    last_update_date    DATE,
    last_updated_by     NUMBER(15),
    creation_date       DATE,
    created_by          NUMBER(15),
    last_update_login   NUMBER(15)
)
LOGGING XMLTYPE COLUMN request STORE AS BINARY XML (
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 BUFFER_POOL DEFAULT )
    RETENTION
    ENABLE STORAGE IN ROW
    NOCACHE
) XMLTYPE COLUMN response STORE AS BINARY XML (
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 BUFFER_POOL DEFAULT )
    RETENTION
    ENABLE STORAGE IN ROW
    NOCACHE
);

ALTER TABLE xwrl_requests ADD CONSTRAINT xwrl_requests_pk PRIMARY KEY ( id );

CREATE OR REPLACE TRIGGER XWRL_REQUESTS 
    BEFORE INSERT ON XWRL_REQUESTS 
    FOR EACH ROW 
begin

if (:new.id is null) then
:new.id := xwrl_requests_seq.nextval;
end if;

end; 
/


create table xwrl_request_individual_columns
(id                  INTEGER NOT NULL,
rec integer not null,
ListSubKey varchar2(2700), 
ListRecordType varchar2(2700), 
ListRecordOrigin varchar2(2700), 
CustId varchar2(2700), 
CustSubId varchar2(2700), 
PassportNumber varchar2(2700), 
NationalId varchar2(2700), 
Title varchar2(2700), 
FullName varchar2(2700), 
GivenNames varchar2(2700), 
FamilyName varchar2(2700), 
NameType varchar2(2700), 
NameQuality varchar2(2700), 
PrimaryName varchar2(2700), 
OriginalScriptName varchar2(2700), 
Gender varchar2(2700), 
DateOfBirth varchar2(2700), 
YearOfBirth varchar2(2700), 
Occupation varchar2(2700), 
Address1 varchar2(2700), 
Address2 varchar2(2700), 
Address3 varchar2(2700), 
Address4 varchar2(2700), 
City varchar2(2700), 
State varchar2(2700), 
PostalCode varchar2(2700), 
AddressCountryCode varchar2(2700), 
ResidencyCountryCode varchar2(2700), 
CountryOfBirthCode varchar2(2700), 
NationalityCountryCodes varchar2(2700), 
ProfileHyperlink varchar2(2700), 
RiskScore varchar2(2700), 
DataConfidenceScore varchar2(2700), 
DataConfidenceComment varchar2(2700), 
CustomString1 varchar2(2700), 
CustomString2 varchar2(2700), 
CustomString3 varchar2(2700), 
CustomString4 varchar2(2700), 
CustomString5 varchar2(2700), 
CustomString6 varchar2(2700), 
CustomString7 varchar2(2700), 
CustomString8 varchar2(2700), 
CustomString9 varchar2(2700), 
CustomString10 varchar2(2700), 
CustomString11 varchar2(2700), 
CustomString12 varchar2(2700), 
CustomString13 varchar2(2700), 
CustomString14 varchar2(2700), 
CustomString15 varchar2(2700), 
CustomString16 varchar2(2700), 
CustomString17 varchar2(2700), 
CustomString18 varchar2(2700), 
CustomString19 varchar2(2700), 
CustomString20 varchar2(2700), 
CustomString21 varchar2(2700), 
CustomString22 varchar2(2700), 
CustomString23 varchar2(2700), 
CustomString24 varchar2(2700), 
CustomString25 varchar2(2700), 
CustomString26 varchar2(2700), 
CustomString27 varchar2(2700), 
CustomString28 varchar2(2700), 
CustomString29 varchar2(2700), 
CustomString30 varchar2(2700), 
CustomString31 varchar2(2700), 
CustomString32 varchar2(2700), 
CustomString33 varchar2(2700), 
CustomString34 varchar2(2700), 
CustomString35 varchar2(2700), 
CustomString36 varchar2(2700), 
CustomString37 varchar2(2700), 
CustomString38 varchar2(2700), 
CustomString39 varchar2(2700), 
CustomString40 varchar2(2700), 
CustomDate1 varchar2(2700), 
CustomDate2 varchar2(2700), 
CustomDate3 varchar2(2700), 
CustomDate4 varchar2(2700), 
CustomDate5 varchar2(2700), 
CustomNumber1 varchar2(2700), 
CustomNumber2 varchar2(2700), 
CustomNumber3 varchar2(2700), 
CustomNumber4 varchar2(2700), 
CustomNumber5 varchar2(2700), 
    last_update_date    DATE,
    last_updated_by     NUMBER(15),
    creation_date       DATE,
    created_by          NUMBER(15),
    last_update_login   NUMBER(15)
)
LOGGING;

create table xwrl_request_entity_columns
(id                  INTEGER NOT NULL,
rec integer not null,
ListSubKey varchar2(2700), 
ListRecordType varchar2(2700), 
ListRecordOrigin varchar2(2700), 
CustId varchar2(2700), 
CustSubId varchar2(2700), 
RegistrationNumber varchar2(2700), 
EntityName varchar2(2700), 
NameType varchar2(2700), 
NameQuality varchar2(2700), 
PrimaryName varchar2(2700), 
OriginalScriptName varchar2(2700), 
AliasIsAcronym varchar2(2700), 
Address1 varchar2(2700), 
Address2 varchar2(2700), 
Address3 varchar2(2700), 
Address4 varchar2(2700), 
City varchar2(2700), 
State varchar2(2700), 
PostalCode varchar2(2700), 
AddressCountryCode varchar2(2700), 
RegistrationCountryCode varchar2(2700), 
OperatingCountryCodes varchar2(2700), 
ProfileHyperlink varchar2(2700), 
RiskScore varchar2(2700), 
DataConfidenceScore varchar2(2700), 
DataConfidenceComment varchar2(2700), 
CustomString1 varchar2(2700), 
CustomString2 varchar2(2700), 
CustomString3 varchar2(2700), 
CustomString4 varchar2(2700), 
CustomString5 varchar2(2700), 
CustomString6 varchar2(2700), 
CustomString7 varchar2(2700), 
CustomString8 varchar2(2700), 
CustomString9 varchar2(2700), 
CustomString10 varchar2(2700), 
CustomString11 varchar2(2700), 
CustomString12 varchar2(2700), 
CustomString13 varchar2(2700), 
CustomString14 varchar2(2700), 
CustomString15 varchar2(2700), 
CustomString16 varchar2(2700), 
CustomString17 varchar2(2700), 
CustomString18 varchar2(2700), 
CustomString19 varchar2(2700), 
CustomString20 varchar2(2700), 
CustomString21 varchar2(2700), 
CustomString22 varchar2(2700), 
CustomString23 varchar2(2700), 
CustomString24 varchar2(2700), 
CustomString25 varchar2(2700), 
CustomString26 varchar2(2700), 
CustomString27 varchar2(2700), 
CustomString28 varchar2(2700), 
CustomString29 varchar2(2700), 
CustomString30 varchar2(2700), 
CustomString31 varchar2(2700), 
CustomString32 varchar2(2700), 
CustomString33 varchar2(2700), 
CustomString34 varchar2(2700), 
CustomString35 varchar2(2700), 
CustomString36 varchar2(2700), 
CustomString37 varchar2(2700), 
CustomString38 varchar2(2700), 
CustomString39 varchar2(2700), 
CustomString40 varchar2(2700), 
CustomDate1 varchar2(2700), 
CustomDate2 varchar2(2700), 
CustomDate3 varchar2(2700), 
CustomDate4 varchar2(2700), 
CustomDate5 varchar2(2700), 
CustomNumber1 varchar2(2700), 
CustomNumber2 varchar2(2700), 
CustomNumber3 varchar2(2700), 
CustomNumber4 varchar2(2700), 
CustomNumber5 varchar2(2700), 
    last_update_date    DATE,
    last_updated_by     NUMBER(15),
    creation_date       DATE,
    created_by          NUMBER(15),
    last_update_login   NUMBER(15)
)
LOGGING;


create table xwrl_request_rows
(id integer not null,
path varchar2(50),
rw integer,
key varchar2(100),
value varchar2(2700),
    last_update_date    DATE,
    last_updated_by     NUMBER(15),
    creation_date       DATE,
    created_by          NUMBER(15),
    last_update_login   NUMBER(15)
)
LOGGING;

create table xwrl_response_individual_columns
(id                  INTEGER NOT NULL,
rec integer not null,
ListKey varchar2(2700), 
ListSubKey varchar2(2700), 
ListRecordType varchar2(2700), 
ListRecordOrigin varchar2(2700), 
ListId varchar2(2700), 
ListGivenNames varchar2(2700), 
ListFamilyName varchar2(2700), 
ListFullName varchar2(2700), 
ListNameType varchar2(2700), 
ListPrimaryName varchar2(2700), 
ListOriginalScriptName varchar2(2700), 
ListDOB varchar2(2700), 
ListCity varchar2(2700), 
ListCountry varchar2(2700), 
ListCountryOfBirth varchar2(2700), 
ListNationality varchar2(2700), 
MatchRule varchar2(2700), 
MatchScore varchar2(2700), 
CaseKey varchar2(2700), 
AlertId varchar2(2700), 
RiskScore varchar2(2700), 
RiskScorePEP varchar2(2700), 
    last_update_date    DATE,
    last_updated_by     NUMBER(15),
    creation_date       DATE,
    created_by          NUMBER(15),
    last_update_login   NUMBER(15)
)
LOGGING;

create table xwrl_response_entity_columns
(id                  INTEGER NOT NULL,
rec integer not null,
ListKey varchar2(2700), 
ListSubKey varchar2(2700), 
ListRecordType varchar2(2700), 
ListRecordOrigin varchar2(2700), 
ListId varchar2(2700), 
ListEntityName varchar2(2700), 
ListPrimaryName varchar2(2700), 
ListOriginalScriptName varchar2(2700), 
ListNameType varchar2(2700), 
ListCity varchar2(2700), 
ListCountry varchar2(2700), 
ListOperatingCountries varchar2(2700), 
ListRegistrationCountries varchar2(2700), 
MatchRule varchar2(2700), 
MatchScore varchar2(2700), 
CaseKey varchar2(2700), 
AlertId varchar2(2700), 
RiskScore varchar2(2700), 
RiskScorePEP varchar2(2700), 
    last_update_date    DATE,
    last_updated_by     NUMBER(15),
    creation_date       DATE,
    created_by          NUMBER(15),
    last_update_login   NUMBER(15)
)
LOGGING;

create table xwrl_response_rows
(id integer not null,
path varchar2(50),
ows_id varchar2(500),
rec_row integer,
det_row integer,
key varchar2(100),
value varchar2(2700),
    last_update_date    DATE,
    last_updated_by     NUMBER(15),
    creation_date       DATE,
    created_by          NUMBER(15),
    last_update_login   NUMBER(15)
)
LOGGING;

grant all on xwrl_keywords to apps;

grant all on xwrl_location_types to apps;

grant all on xwrl_parameters to apps;

grant all on xwrl_requests_seq to apps;

grant all on xwrl_requests to apps;

insert into xwrl_parameters (id, key, value_string) values ('SERVER','POC','http://129.150.84.227:8001');
insert into xwrl_parameters (id, key, value_string) values ('SERVER','IRIDROWS-PRI','http://10.161.147.149:8001');
insert into xwrl_parameters (id, key, value_string) values ('SERVER','IRIDROWS-SEC','http://10.161.147.150:8001');
insert into xwrl_parameters (id, key, value_string) values ('SERVER','IRIPRODOWS','http://iriprodows.register-iri.com');
insert into xwrl_parameters (id, key, value_string) values ('SERVER','IRIDROWS','http://iridrows.register-iri.com');

insert into xwrl_parameters (id, key, value_string) values ('PATH','INDIVIDUAL','/edq/webservices/Watchlist%20Screening:IndividualScreen');
insert into xwrl_parameters (id, key, value_string) values ('PATH','ENTITY','/edq/webservices/Watchlist%20Screening:EntityScreen');

insert into xwrl_parameters (id, key, value_string) values ('PATH','TEST','/edq');

declare
v_xml xmltype;

begin

v_xml := xmltype('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://www.datanomic.com/ws">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:request>
         <!--Optional:-->
         <ws:ListSubKey>?</ws:ListSubKey>
         <!--Optional:-->
         <ws:ListRecordType>?</ws:ListRecordType>
         <!--Optional:-->
         <ws:ListRecordOrigin>?</ws:ListRecordOrigin>
         <!--Optional:-->
         <ws:CustId>?</ws:CustId>
         <!--Optional:-->
         <ws:CustSubId>?</ws:CustSubId>
         <!--Optional:-->
         <ws:PassportNumber>?</ws:PassportNumber>
         <!--Optional:-->
         <ws:NationalId>?</ws:NationalId>
         <!--Optional:-->
         <ws:Title>?</ws:Title>
         <!--Optional:-->
         <ws:FullName>?</ws:FullName>
         <!--Optional:-->
         <ws:GivenNames>?</ws:GivenNames>
         <!--Optional:-->
         <ws:FamilyName>?</ws:FamilyName>
         <!--Optional:-->
         <ws:NameType>?</ws:NameType>
         <!--Optional:-->
         <ws:NameQuality>?</ws:NameQuality>
         <!--Optional:-->
         <ws:PrimaryName>?</ws:PrimaryName>
         <!--Optional:-->
         <ws:OriginalScriptName>?</ws:OriginalScriptName>
         <!--Optional:-->
         <ws:Gender>?</ws:Gender>
         <!--Optional:-->
         <ws:DateOfBirth>?</ws:DateOfBirth>
         <!--Optional:-->
         <ws:YearOfBirth>?</ws:YearOfBirth>
         <!--Optional:-->
         <ws:Occupation>?</ws:Occupation>
         <!--Optional:-->
         <ws:Address1>?</ws:Address1>
         <!--Optional:-->
         <ws:Address2>?</ws:Address2>
         <!--Optional:-->
         <ws:Address3>?</ws:Address3>
         <!--Optional:-->
         <ws:Address4>?</ws:Address4>
         <!--Optional:-->
         <ws:City>?</ws:City>
         <!--Optional:-->
         <ws:State>?</ws:State>
         <!--Optional:-->
         <ws:PostalCode>?</ws:PostalCode>
         <!--Optional:-->
         <ws:AddressCountryCode>?</ws:AddressCountryCode>
         <!--Optional:-->
         <ws:ResidencyCountryCode>?</ws:ResidencyCountryCode>
         <!--Optional:-->
         <ws:CountryOfBirthCode>?</ws:CountryOfBirthCode>
         <!--Optional:-->
         <ws:NationalityCountryCodes>?</ws:NationalityCountryCodes>
         <!--Optional:-->
         <ws:ProfileHyperlink>?</ws:ProfileHyperlink>
         <!--Optional:-->
         <ws:RiskScore>?</ws:RiskScore>
         <!--Optional:-->
         <ws:DataConfidenceScore>?</ws:DataConfidenceScore>
         <!--Optional:-->
         <ws:DataConfidenceComment>?</ws:DataConfidenceComment>
         <!--Optional:-->
         <ws:CustomString1>?</ws:CustomString1>
         <!--Optional:-->
         <ws:CustomString2>?</ws:CustomString2>
         <!--Optional:-->
         <ws:CustomString3>?</ws:CustomString3>
         <!--Optional:-->
         <ws:CustomString4>?</ws:CustomString4>
         <!--Optional:-->
         <ws:CustomString5>?</ws:CustomString5>
         <!--Optional:-->
         <ws:CustomString6>?</ws:CustomString6>
         <!--Optional:-->
         <ws:CustomString7>?</ws:CustomString7>
         <!--Optional:-->
         <ws:CustomString8>?</ws:CustomString8>
         <!--Optional:-->
         <ws:CustomString9>?</ws:CustomString9>
         <!--Optional:-->
         <ws:CustomString10>?</ws:CustomString10>
         <!--Optional:-->
         <ws:CustomString11>?</ws:CustomString11>
         <!--Optional:-->
         <ws:CustomString12>?</ws:CustomString12>
         <!--Optional:-->
         <ws:CustomString13>?</ws:CustomString13>
         <!--Optional:-->
         <ws:CustomString14>?</ws:CustomString14>
         <!--Optional:-->
         <ws:CustomString15>?</ws:CustomString15>
         <!--Optional:-->
         <ws:CustomString16>?</ws:CustomString16>
         <!--Optional:-->
         <ws:CustomString17>?</ws:CustomString17>
         <!--Optional:-->
         <ws:CustomString18>?</ws:CustomString18>
         <!--Optional:-->
         <ws:CustomString19>?</ws:CustomString19>
         <!--Optional:-->
         <ws:CustomString20>?</ws:CustomString20>
         <!--Optional:-->
         <ws:CustomString21>?</ws:CustomString21>
         <!--Optional:-->
         <ws:CustomString22>?</ws:CustomString22>
         <!--Optional:-->
         <ws:CustomString23>?</ws:CustomString23>
         <!--Optional:-->
         <ws:CustomString24>?</ws:CustomString24>
         <!--Optional:-->
         <ws:CustomString25>?</ws:CustomString25>
         <!--Optional:-->
         <ws:CustomString26>?</ws:CustomString26>
         <!--Optional:-->
         <ws:CustomString27>?</ws:CustomString27>
         <!--Optional:-->
         <ws:CustomString28>?</ws:CustomString28>
         <!--Optional:-->
         <ws:CustomString29>?</ws:CustomString29>
         <!--Optional:-->
         <ws:CustomString30>?</ws:CustomString30>
         <!--Optional:-->
         <ws:CustomString31>?</ws:CustomString31>
         <!--Optional:-->
         <ws:CustomString32>?</ws:CustomString32>
         <!--Optional:-->
         <ws:CustomString33>?</ws:CustomString33>
         <!--Optional:-->
         <ws:CustomString34>?</ws:CustomString34>
         <!--Optional:-->
         <ws:CustomString35>?</ws:CustomString35>
         <!--Optional:-->
         <ws:CustomString36>?</ws:CustomString36>
         <!--Optional:-->
         <ws:CustomString37>?</ws:CustomString37>
         <!--Optional:-->
         <ws:CustomString38>?</ws:CustomString38>
         <!--Optional:-->
         <ws:CustomString39>?</ws:CustomString39>
         <!--Optional:-->
         <ws:CustomString40>?</ws:CustomString40>
         <!--Optional:-->
         <ws:CustomDate1>?</ws:CustomDate1>
         <!--Optional:-->
         <ws:CustomDate2>?</ws:CustomDate2>
         <!--Optional:-->
         <ws:CustomDate3>?</ws:CustomDate3>
         <!--Optional:-->
         <ws:CustomDate4>?</ws:CustomDate4>
         <!--Optional:-->
         <ws:CustomDate5>?</ws:CustomDate5>
         <!--Optional:-->
         <ws:CustomNumber1>?</ws:CustomNumber1>
         <!--Optional:-->
         <ws:CustomNumber2>?</ws:CustomNumber2>
         <!--Optional:-->
         <ws:CustomNumber3>?</ws:CustomNumber3>
         <!--Optional:-->
         <ws:CustomNumber4>?</ws:CustomNumber4>
         <!--Optional:-->
         <ws:CustomNumber5>?</ws:CustomNumber5>
      </ws:request>
   </soapenv:Body>
</soapenv:Envelope>'
		);

insert into xwrl_parameters (id, key, value_xml) values ('XML','REQUEST_INDIVIDUAL',v_xml);
		
end;		
/

declare
v_xml xmltype;

begin

v_xml := xmltype('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://www.datanomic.com/ws">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:request>
         <!--Optional:-->
         <ws:ListSubKey>?</ws:ListSubKey>
         <!--Optional:-->
         <ws:ListRecordType>?</ws:ListRecordType>
         <!--Optional:-->
         <ws:ListRecordOrigin>?</ws:ListRecordOrigin>
         <!--Optional:-->
         <ws:CustId>?</ws:CustId>
         <!--Optional:-->
         <ws:CustSubId>?</ws:CustSubId>
         <!--Optional:-->
         <ws:RegistrationNumber>?</ws:RegistrationNumber>
         <!--Optional:-->
         <ws:EntityName>?</ws:EntityName>
         <!--Optional:-->
         <ws:NameType>?</ws:NameType>
         <!--Optional:-->
         <ws:NameQuality>?</ws:NameQuality>
         <!--Optional:-->
         <ws:PrimaryName>?</ws:PrimaryName>
         <!--Optional:-->
         <ws:OriginalScriptName>?</ws:OriginalScriptName>
         <!--Optional:-->
         <ws:AliasIsAcronym>?</ws:AliasIsAcronym>
         <!--Optional:-->
         <ws:Address1>?</ws:Address1>
         <!--Optional:-->
         <ws:Address2>?</ws:Address2>
         <!--Optional:-->
         <ws:Address3>?</ws:Address3>
         <!--Optional:-->
         <ws:Address4>?</ws:Address4>
         <!--Optional:-->
         <ws:City>?</ws:City>
         <!--Optional:-->
         <ws:State>?</ws:State>
         <!--Optional:-->
         <ws:PostalCode>?</ws:PostalCode>
         <!--Optional:-->
         <ws:AddressCountryCode>?</ws:AddressCountryCode>
         <!--Optional:-->
         <ws:RegistrationCountryCode>?</ws:RegistrationCountryCode>
         <!--Optional:-->
         <ws:OperatingCountryCodes>?</ws:OperatingCountryCodes>
         <!--Optional:-->
         <ws:ProfileHyperlink>?</ws:ProfileHyperlink>
         <!--Optional:-->
         <ws:RiskScore>?</ws:RiskScore>
         <!--Optional:-->
         <ws:DataConfidenceScore>?</ws:DataConfidenceScore>
         <!--Optional:-->
         <ws:DataConfidenceComment>?</ws:DataConfidenceComment>
         <!--Optional:-->
         <ws:CustomString1>?</ws:CustomString1>
         <!--Optional:-->
         <ws:CustomString2>?</ws:CustomString2>
         <!--Optional:-->
         <ws:CustomString3>?</ws:CustomString3>
         <!--Optional:-->
         <ws:CustomString4>?</ws:CustomString4>
         <!--Optional:-->
         <ws:CustomString5>?</ws:CustomString5>
         <!--Optional:-->
         <ws:CustomString6>?</ws:CustomString6>
         <!--Optional:-->
         <ws:CustomString7>?</ws:CustomString7>
         <!--Optional:-->
         <ws:CustomString8>?</ws:CustomString8>
         <!--Optional:-->
         <ws:CustomString9>?</ws:CustomString9>
         <!--Optional:-->
         <ws:CustomString10>?</ws:CustomString10>
         <!--Optional:-->
         <ws:CustomString11>?</ws:CustomString11>
         <!--Optional:-->
         <ws:CustomString12>?</ws:CustomString12>
         <!--Optional:-->
         <ws:CustomString13>?</ws:CustomString13>
         <!--Optional:-->
         <ws:CustomString14>?</ws:CustomString14>
         <!--Optional:-->
         <ws:CustomString15>?</ws:CustomString15>
         <!--Optional:-->
         <ws:CustomString16>?</ws:CustomString16>
         <!--Optional:-->
         <ws:CustomString17>?</ws:CustomString17>
         <!--Optional:-->
         <ws:CustomString18>?</ws:CustomString18>
         <!--Optional:-->
         <ws:CustomString19>?</ws:CustomString19>
         <!--Optional:-->
         <ws:CustomString20>?</ws:CustomString20>
         <!--Optional:-->
         <ws:CustomString21>?</ws:CustomString21>
         <!--Optional:-->
         <ws:CustomString22>?</ws:CustomString22>
         <!--Optional:-->
         <ws:CustomString23>?</ws:CustomString23>
         <!--Optional:-->
         <ws:CustomString24>?</ws:CustomString24>
         <!--Optional:-->
         <ws:CustomString25>?</ws:CustomString25>
         <!--Optional:-->
         <ws:CustomString26>?</ws:CustomString26>
         <!--Optional:-->
         <ws:CustomString27>?</ws:CustomString27>
         <!--Optional:-->
         <ws:CustomString28>?</ws:CustomString28>
         <!--Optional:-->
         <ws:CustomString29>?</ws:CustomString29>
         <!--Optional:-->
         <ws:CustomString30>?</ws:CustomString30>
         <!--Optional:-->
         <ws:CustomString31>?</ws:CustomString31>
         <!--Optional:-->
         <ws:CustomString32>?</ws:CustomString32>
         <!--Optional:-->
         <ws:CustomString33>?</ws:CustomString33>
         <!--Optional:-->
         <ws:CustomString34>?</ws:CustomString34>
         <!--Optional:-->
         <ws:CustomString35>?</ws:CustomString35>
         <!--Optional:-->
         <ws:CustomString36>?</ws:CustomString36>
         <!--Optional:-->
         <ws:CustomString37>?</ws:CustomString37>
         <!--Optional:-->
         <ws:CustomString38>?</ws:CustomString38>
         <!--Optional:-->
         <ws:CustomString39>?</ws:CustomString39>
         <!--Optional:-->
         <ws:CustomString40>?</ws:CustomString40>
         <!--Optional:-->
         <ws:CustomDate1>?</ws:CustomDate1>
         <!--Optional:-->
         <ws:CustomDate2>?</ws:CustomDate2>
         <!--Optional:-->
         <ws:CustomDate3>?</ws:CustomDate3>
         <!--Optional:-->
         <ws:CustomDate4>?</ws:CustomDate4>
         <!--Optional:-->
         <ws:CustomDate5>?</ws:CustomDate5>
         <!--Optional:-->
         <ws:CustomNumber1>?</ws:CustomNumber1>
         <!--Optional:-->
         <ws:CustomNumber2>?</ws:CustomNumber2>
         <!--Optional:-->
         <ws:CustomNumber3>?</ws:CustomNumber3>
         <!--Optional:-->
         <ws:CustomNumber4>?</ws:CustomNumber4>
         <!--Optional:-->
         <ws:CustomNumber5>?</ws:CustomNumber5>
      </ws:request>
   </soapenv:Body>
</soapenv:Envelope>	
'
		);

insert into xwrl_parameters (id, key, value_xml) values ('XML','REQUEST_ENTITY',v_xml);
		
end;		
/

declare
v_xml xmltype;

begin

v_xml := xmltype('<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:dn="http://www.datanomic.com/ws">
  <env:Header/>
  <env:Body>
    <dn:response>
      <dn:record>
        <dn:ListKey>?</dn:ListKey>
         <dn:ListSubKey>?</dn:ListSubKey>
         <dn:ListRecordType>?</dn:ListRecordType>
         <dn:ListRecordOrigin>?</dn:ListRecordOrigin>
         <dn:ListId>?</dn:ListId>
         <dn:ListGivenNames>?</dn:ListGivenNames>
         <dn:ListFamilyName>?</dn:ListFamilyName>
         <dn:ListFullName>?</dn:ListFullName>
         <dn:ListNameType>?</dn:ListNameType>
        <dn:ListPrimaryName>?</dn:ListPrimaryName>
        <dn:ListOriginalScriptName>?</dn:ListOriginalScriptName>
        <dn:ListDOB>?</dn:ListDOB>
        <dn:ListCity>?</dn:ListCity>
        <dn:ListCountry>?</dn:ListCountry>
        <dn:ListCountryOfBirth>?</dn:ListCountryOfBirth>
        <dn:ListNationality>?</dn:ListNationality>
        <dn:MatchRule>?</dn:MatchRule>
        <dn:MatchScore>?</dn:MatchScore>
        <dn:CaseKey>?</dn:CaseKey>
        <dn:AlertId>?</dn:AlertId>
        <dn:RiskScore>?</dn:RiskScore>
        <dn:RiskScorePEP>?</dn:RiskScorePEP>
      </dn:record>	
    </dn:response>
  </env:Body>
</env:Envelope>      
'
);

insert into xwrl_parameters (id, key, value_xml) values ('XML','RESPONSE_INDIVIDUAL',v_xml);
		
end;		
/

declare
v_xml xmltype;

begin

v_xml := xmltype('<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:dn="http://www.datanomic.com/ws">
  <env:Header/>
  <env:Body>
    <dn:response>
      <dn:record>
        <dn:ListKey>?</dn:ListKey>
        <dn:ListSubKey>?</dn:ListSubKey>
        <dn:ListRecordType>?</dn:ListRecordType>
        <dn:ListRecordOrigin>?</dn:ListRecordOrigin>
        <dn:ListId>?</dn:ListId>
        <dn:ListEntityName>?</dn:ListEntityName>
        <dn:ListPrimaryName>?</dn:ListPrimaryName>
        <dn:ListOriginalScriptName>?</dn:ListOriginalScriptName>
        <dn:ListNameType>?</dn:ListNameType>
        <dn:ListCity>?</dn:ListCity>
        <dn:ListCountry>?</dn:ListCountry>
        <dn:ListOperatingCountries>?</dn:ListOperatingCountries>
        <dn:ListRegistrationCountries>?</dn:ListRegistrationCountries>
        <dn:MatchRule>?</dn:MatchRule>
        <dn:MatchScore>?</dn:MatchScore>
        <dn:CaseKey>?</dn:CaseKey>
        <dn:AlertId>?</dn:AlertId>
        <dn:RiskScore>?</dn:RiskScore>
        <dn:RiskScorePEP>?</dn:RiskScorePEP>  
      </dn:record>	
    </dn:response>
  </env:Body>
</env:Envelope>      
'
);

insert into xwrl_parameters (id, key, value_xml) values ('XML','RESPONSE_ENTITY',v_xml);
		
end;		
/

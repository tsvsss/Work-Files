/* Individual */

DECLARE

   v_program_name VARCHAR2 (1000);

BEGIN

   v_program_name := 'OWS_INDIVIDUAL_SCREENING_PRG';

   dbms_scheduler.drop_program (program_name => v_program_name);

   dbms_scheduler.create_program (program_name => v_program_name, program_type => 'STORED_PROCEDURE', program_action => 'XWRL_UTILS.OWS_INDIVIDUAL_SCREENING', number_of_arguments => 92, enabled => false, comments => 'Oracle OWS Individual Screening');

   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Debug', argument_position => 1, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ShowRequest', argument_position => 2, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ShowResponse', argument_position => 3, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Server', argument_position => 4, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'SourceTable', argument_position => 5, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'SourceId', argument_position => 6, argument_type => 'NUMBER', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'WcScreeningRequestId', argument_position => 7, argument_type => 'NUMBER', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'JobId', argument_position => 8, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ListSubKey', argument_position => 9, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ListRecordType', argument_position => 10, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ListRecordOrigin', argument_position => 11, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustId', argument_position => 12, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustSubId', argument_position => 13, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'PassportNumber', argument_position => 14, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'NationalId', argument_position => 15, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Title', argument_position => 16, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'FullName', argument_position => 17, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'GivenNames', argument_position => 18, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'FamilyName', argument_position => 19, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'NameType', argument_position => 20, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'NameQuality', argument_position => 21, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'PrimaryName', argument_position => 22, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'OriginalScriptName', argument_position => 23, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Gender', argument_position => 24, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'DateOfBirth', argument_position => 25, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'YearOfBirth', argument_position => 26, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Occupation', argument_position => 27, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Address1', argument_position => 28, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Address2', argument_position => 29, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Address3', argument_position => 30, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Address4', argument_position => 31, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'City', argument_position => 32, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'State', argument_position => 33, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'PostalCode', argument_position => 34, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'AddressCountryCode', argument_position => 35, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ResidencyCountryCode', argument_position => 36, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CountryOfBirthCode', argument_position => 37, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'NationalityCountryCodes', argument_position => 38, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ProfileHyperlink', argument_position => 39, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'RiskScore', argument_position => 40, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'DataConfidenceScore', argument_position => 41, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'DataConfidenceComment', argument_position => 42, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString1', argument_position => 43, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString2', argument_position => 44, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString3', argument_position => 45, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString4', argument_position => 46, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString5', argument_position => 47, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString6', argument_position => 48, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString7', argument_position => 49, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString8', argument_position => 50, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString9', argument_position => 51, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString10', argument_position => 52, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString11', argument_position => 53, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString12', argument_position => 54, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString13', argument_position => 55, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString14', argument_position => 56, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString15', argument_position => 57, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString16', argument_position => 58, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString17', argument_position => 59, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString18', argument_position => 60, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString19', argument_position => 61, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString20', argument_position => 62, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString21', argument_position => 63, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString22', argument_position => 64, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString23', argument_position => 65, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString24', argument_position => 66, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString25', argument_position => 67, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString26', argument_position => 68, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString27', argument_position => 69, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString28', argument_position => 70, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString29', argument_position => 71, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString30', argument_position => 72, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString31', argument_position => 73, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString32', argument_position => 74, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString33', argument_position => 75, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString34', argument_position => 76, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString35', argument_position => 77, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString36', argument_position => 78, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString37', argument_position => 79, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString38', argument_position => 80, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString39', argument_position => 81, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString40', argument_position => 82, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomDate1', argument_position => 83, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomDate2', argument_position => 84, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomDate3', argument_position => 85, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomDate4', argument_position => 86, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomDate5', argument_position => 87, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomNumber1', argument_position => 88, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomNumber2', argument_position => 89, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomNumber3', argument_position => 90, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomNumber4', argument_position => 91, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomNumber5', argument_position => 92, argument_type => 'VARCHAR2', default_value => '');

   dbms_scheduler.enable (name => v_program_name);

END;
/


/* Entity */

DECLARE

   v_program_name VARCHAR2 (1000);

BEGIN

   v_program_name := 'OWS_ENTITY_SCREENING_PRG';

   dbms_scheduler.drop_program (program_name => v_program_name);

   dbms_scheduler.create_program (program_name => v_program_name, program_type => 'STORED_PROCEDURE', program_action => 'XWRL_UTILS.OWS_ENTITY_SCREENING', number_of_arguments => 84, enabled => false, comments => 'Oracle OWS Entity Screening');

   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Debug', argument_position => 1, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ShowRequest', argument_position => 2, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ShowResponse', argument_position => 3, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Server', argument_position => 4, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'SourceTable', argument_position => 5, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'SourceId', argument_position => 6, argument_type => 'NUMBER', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'WcScreeningRequestId', argument_position => 7, argument_type => 'NUMBER', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'JobId', argument_position => 8, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ListSubKey', argument_position => 9, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ListRecordType', argument_position => 10, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ListRecordOrigin', argument_position => 11, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustId', argument_position => 12, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustSubId', argument_position => 13, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'RegistrationNumber', argument_position => 14, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'EntityName', argument_position => 15, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'NameType', argument_position => 16, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'NameQuality', argument_position => 17, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'PrimaryName', argument_position => 18, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'OriginalScriptName', argument_position => 19, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'AliasIsAcronym', argument_position => 20, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Address1', argument_position => 21, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Address2', argument_position => 22, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Address3', argument_position => 23, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Address4', argument_position => 24, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'City', argument_position => 25, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'State', argument_position => 26, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'PostalCode', argument_position => 27, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'AddressCountryCode', argument_position => 28, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'RegistrationCountryCode', argument_position => 29, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'OperatingCountryCodes', argument_position => 30, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ProfileHyperlink', argument_position => 31, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'RiskScore', argument_position => 32, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'DataConfidenceScore', argument_position => 33, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'DataConfidenceComment', argument_position => 34, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString1', argument_position => 35, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString2', argument_position => 36, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString3', argument_position => 37, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString4', argument_position => 38, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString5', argument_position => 39, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString6', argument_position => 40, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString7', argument_position => 41, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString8', argument_position => 42, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString9', argument_position => 43, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString10', argument_position => 44, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString11', argument_position => 45, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString12', argument_position => 46, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString13', argument_position => 47, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString14', argument_position => 48, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString15', argument_position => 49, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString16', argument_position => 50, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString17', argument_position => 51, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString18', argument_position => 52, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString19', argument_position => 53, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString20', argument_position => 54, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString21', argument_position => 55, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString22', argument_position => 56, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString23', argument_position => 57, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString24', argument_position => 58, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString25', argument_position => 59, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString26', argument_position => 60, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString27', argument_position => 61, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString28', argument_position => 62, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString29', argument_position => 63, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString30', argument_position => 64, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString31', argument_position => 65, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString32', argument_position => 66, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString33', argument_position => 67, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString34', argument_position => 68, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString35', argument_position => 69, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString36', argument_position => 70, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString37', argument_position => 71, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString38', argument_position => 72, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString39', argument_position => 73, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomString40', argument_position => 74, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomDate1', argument_position => 75, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomDate2', argument_position => 76, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomDate3', argument_position => 77, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomDate4', argument_position => 78, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomDate5', argument_position => 79, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomNumber1', argument_position => 80, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomNumber2', argument_position => 81, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomNumber3', argument_position => 82, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomNumber4', argument_position => 83, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'CustomNumber5', argument_position => 84, argument_type => 'VARCHAR2', default_value => '');

   dbms_scheduler.enable (name => v_program_name);

END;
/

/* Resubmit */

DECLARE

   v_program_name VARCHAR2 (1000);

BEGIN

   v_program_name := 'OWS_RESUBMIT_SCREENING_PRG';

   dbms_scheduler.drop_program (program_name => v_program_name);

   dbms_scheduler.create_program (program_name => v_program_name, program_type => 'STORED_PROCEDURE', program_action => 'XWRL_UTILS.OWS_RESUBMIT_SCREENING', number_of_arguments => 9, enabled => false, comments => 'Oracle OWS Resubmit Screening');

   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Debug', argument_position => 1, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ShowRequest', argument_position => 2, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'ShowResponse', argument_position => 3, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Server', argument_position => 4, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'SourceTable', argument_position => 5, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'SourceId', argument_position => 6, argument_type => 'NUMBER', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'WcScreeningRequestId', argument_position => 7, argument_type => 'NUMBER', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'JobId', argument_position => 8, argument_type => 'VARCHAR2', default_value => '');
   dbms_scheduler.define_program_argument (program_name => v_program_name, argument_name => 'Id', argument_position => 9, argument_type => 'NUMBER', default_value => '');

   dbms_scheduler.enable (name => v_program_name);

END;
/



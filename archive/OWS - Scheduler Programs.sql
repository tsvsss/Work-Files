declare

v_program_name   VARCHAR2 (1000);

begin

v_program_name := 'OWS_INDIVIDUAL_SCREENING';

DBMS_SCHEDULER.DROP_PROGRAM(program_name => v_program_name);

DBMS_SCHEDULER.CREATE_PROGRAM (
program_name => v_program_name,
program_type => 'STORED_PROCEDURE',
program_action => 'XWRL_UTILS.OWS_INDIVIDUAL_SCREENING',
number_of_arguments => 88,
enabled => FALSE,
comments => 'Oracle OWS Individual Screening');

dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'Debug', argument_position => 1, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'ShowRequest', argument_position => 2, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'ShowResponse', argument_position => 3, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'Server', argument_position => 4, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'ListSubKey', argument_position => 5, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'ListRecordType', argument_position => 6, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'ListRecordOrigin', argument_position => 7, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustId', argument_position => 8, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustSubId', argument_position => 9, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'PassportNumber', argument_position => 10, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'NationalId', argument_position => 11, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'Title', argument_position => 12, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'FullName', argument_position => 13, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'GivenNames', argument_position => 14, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'FamilyName', argument_position => 15, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'NameType', argument_position => 16, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'NameQuality', argument_position => 17, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'PrimaryName', argument_position => 18, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'OriginalScriptName', argument_position => 19, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'Gender', argument_position => 20, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'DateOfBirth', argument_position => 21, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'YearOfBirth', argument_position => 22, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'Occupation', argument_position => 23, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'Address1', argument_position => 24, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'Address2', argument_position => 25, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'Address3', argument_position => 26, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'Address4', argument_position => 27, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'City', argument_position => 28, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'State', argument_position => 29, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'PostalCode', argument_position => 30, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'AddressCountryCode', argument_position => 31, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'ResidencyCountryCode', argument_position => 32, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CountryOfBirthCode', argument_position => 33, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'NationalityCountryCodes', argument_position => 34, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'ProfileHyperlink', argument_position => 35, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'RiskScore', argument_position => 36, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'DataConfidenceScore', argument_position => 37, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'DataConfidenceComment', argument_position => 38, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString1', argument_position => 39, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString2', argument_position => 40, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString3', argument_position => 41, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString4', argument_position => 42, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString5', argument_position => 43, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString6', argument_position => 44, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString7', argument_position => 45, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString8', argument_position => 46, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString9', argument_position => 47, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString10', argument_position => 48, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString11', argument_position => 49, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString12', argument_position => 50, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString13', argument_position => 51, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString14', argument_position => 52, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString15', argument_position => 53, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString16', argument_position => 54, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString17', argument_position => 55, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString18', argument_position => 56, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString19', argument_position => 57, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString20', argument_position => 58, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString21', argument_position => 59, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString22', argument_position => 60, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString23', argument_position => 61, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString24', argument_position => 62, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString25', argument_position => 63, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString26', argument_position => 64, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString27', argument_position => 65, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString28', argument_position => 66, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString29', argument_position => 67, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString30', argument_position => 68, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString31', argument_position => 69, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString32', argument_position => 70, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString33', argument_position => 71, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString34', argument_position => 72, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString35', argument_position => 73, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString36', argument_position => 74, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString37', argument_position => 75, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString38', argument_position => 76, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString39', argument_position => 77, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomString40', argument_position => 78, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomDate1', argument_position => 79, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomDate2', argument_position => 80, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomDate3', argument_position => 81, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomDate4', argument_position => 82, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomDate5', argument_position => 83, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomNumber1', argument_position => 84, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomNumber2', argument_position => 85, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomNumber3', argument_position => 86, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomNumber4', argument_position => 87, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');
dbms_scheduler.DEFINE_PROGRAM_ARGUMENT(program_name => v_program_name, argument_name => 'CustomNumber5', argument_position => 88, argument_type => 'VARCHAR2',DEFAULT_VALUE => '');

      dbms_scheduler.enable (name => v_program_name);

END;
/

DECLARE

   CURSOR c1 IS
   SELECT
      name_screened
      , TO_CHAR (date_of_birth, 'YYYYMMDDHH24MI') date_of_birth
   FROM
      wc_screening_request
   WHERE
      entity_type = 'INDIVIDUAL'
      AND trunc (creation_date) >= trunc (SYSDATE) - 30
      --AND ROWNUM < 2
      ;

   v_count      INTEGER;
   v_error      INTEGER;
   v_server     VARCHAR2 (50);
   v_job_name   VARCHAR2 (1000);

BEGIN




   --v_server := 'POC';
   --v_server := 'IRIDROWS-SEC';
   --v_server := 'IRIDROWS-PRI';
   v_server := 'IRIDROWS';
   --v_server := 'IRIPRODOWS';

   v_count := 0;
   v_error := 0;

   utl_http.set_response_error_check (true);
   utl_http.set_detailed_excp_support (true);

   FOR c1rec IN c1 LOOP

      v_count := v_count + 1;

      v_job_name := 'OWS_I_' || to_char(sysdate,'YYYYMMDDSS')||'_'||v_count||'_JOB';


      dbms_scheduler.create_job (job_name => v_job_name, job_type => 'STORED_PROCEDURE', job_action => 'XWRL_UTILS.OWS_INDIVIDUAL_SCREENING', number_of_arguments => 88, start_date => SYSDATE, end_date => NULL, enabled => false, comments => 'Oracle OWS Individual Screening');

      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 1, argument_value => 'FALSE'); -- Debug
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 2, argument_value => 'FALSE'); -- ShowRequest
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 3, argument_value => 'FALSE'); -- ShowResponse
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 4, argument_value => v_server); -- Server
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 5, argument_value => NULL); -- ListSubKey
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 6, argument_value => NULL); -- ListRecordType
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 7, argument_value => NULL); -- ListRecordOrigin
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 8, argument_value => NULL); -- CustId
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 9, argument_value => NULL); -- CustSubId
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 10, argument_value => NULL); -- PassportNumber
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 11, argument_value => NULL); -- NationalId
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 12, argument_value => NULL); -- Title
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 13, argument_value => c1rec.name_screened); -- FullName
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 14, argument_value => NULL); -- GivenNames
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 15, argument_value => NULL); -- FamilyName
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 16, argument_value => NULL); -- NameType
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 17, argument_value => NULL); -- NameQuality
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 18, argument_value => NULL); -- PrimaryName
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 19, argument_value => NULL); -- OriginalScriptName
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 20, argument_value => NULL); -- Gender
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 21, argument_value => c1rec.date_of_birth); -- DateOfBirth
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 22, argument_value => NULL); -- YearOfBirth
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 23, argument_value => NULL); -- Occupation
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 24, argument_value => NULL); -- Address1
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 25, argument_value => NULL); -- Address2
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 26, argument_value => NULL); -- Address3
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 27, argument_value => NULL); -- Address4
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 28, argument_value => NULL); -- City
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 29, argument_value => NULL); -- State
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 30, argument_value => NULL); -- PostalCode
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 31, argument_value => NULL); -- AddressCountryCode
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 32, argument_value => NULL); -- ResidencyCountryCode
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 33, argument_value => NULL); -- CountryOfBirthCode
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 34, argument_value => NULL); -- NationalityCountryCodes
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 35, argument_value => NULL); -- ProfileHyperlink
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 36, argument_value => NULL); -- RiskScore
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 37, argument_value => NULL); -- DataConfidenceScore
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 38, argument_value => NULL); -- DataConfidenceComment
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 39, argument_value => NULL); -- CustomString1
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 40, argument_value => NULL); -- CustomString2
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 41, argument_value => NULL); -- CustomString3
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 42, argument_value => NULL); -- CustomString4
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 43, argument_value => NULL); -- CustomString5
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 44, argument_value => NULL); -- CustomString6
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 45, argument_value => NULL); -- CustomString7
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 46, argument_value => NULL); -- CustomString8
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 47, argument_value => NULL); -- CustomString9
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 48, argument_value => NULL); -- CustomString10
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 49, argument_value => NULL); -- CustomString11
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 50, argument_value => NULL); -- CustomString12
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 51, argument_value => NULL); -- CustomString13
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 52, argument_value => NULL); -- CustomString14
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 53, argument_value => NULL); -- CustomString15
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 54, argument_value => NULL); -- CustomString16
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 55, argument_value => NULL); -- CustomString17
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 56, argument_value => NULL); -- CustomString18
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 57, argument_value => NULL); -- CustomString19
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 58, argument_value => NULL); -- CustomString20
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 59, argument_value => NULL); -- CustomString21
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 60, argument_value => NULL); -- CustomString22
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 61, argument_value => NULL); -- CustomString23
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 62, argument_value => NULL); -- CustomString24
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 63, argument_value => NULL); -- CustomString25
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 64, argument_value => NULL); -- CustomString26
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 65, argument_value => NULL); -- CustomString27
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 66, argument_value => NULL); -- CustomString28
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 67, argument_value => NULL); -- CustomString29
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 68, argument_value => NULL); -- CustomString30
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 69, argument_value => NULL); -- CustomString31
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 70, argument_value => NULL); -- CustomString32
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 71, argument_value => NULL); -- CustomString33
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 72, argument_value => NULL); -- CustomString34
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 73, argument_value => NULL); -- CustomString35
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 74, argument_value => NULL); -- CustomString36
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 75, argument_value => NULL); -- CustomString37
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 76, argument_value => NULL); -- CustomString38
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 77, argument_value => NULL); -- CustomString39
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 78, argument_value => NULL); -- CustomString40
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 79, argument_value => NULL); -- CustomDate1
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 80, argument_value => NULL); -- CustomDate2
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 81, argument_value => NULL); -- CustomDate3
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 82, argument_value => NULL); -- CustomDate4
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 83, argument_value => NULL); -- CustomDate5
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 84, argument_value => NULL); -- CustomNumber1
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 85, argument_value => NULL); -- CustomNumber2
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 86, argument_value => NULL); -- CustomNumber3
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 87, argument_value => NULL); -- CustomNumber4
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_position => 88, argument_value => NULL); -- CustomNumber5

      dbms_scheduler.enable (name => v_job_name);

   END LOOP;

END;
/



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



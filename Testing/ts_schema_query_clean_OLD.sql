/* WC Application */

select * from WC_SCREENING_REQUEST;
select * from wc_matches;
select * from wc_content;
select * from WORLDCHECK_EXTERNAL_XREF;

select * from wc_city_list;
select * from sicd_countries where sanction_status is not null and sanction_status <> 'NONE';   

/* SANCTION TITLE
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
*/

/* CATEGORY
if upper(a.category_type) ='TERRORISM'  and (p_user_clearable='Y' or computer_clearable='Y')
then
p_user_clearable:='N';
computer_clearable:='N';
elsif upper(a.category_type) ='BLACKLISTED'  and (p_user_clearable='Y' or computer_clearable='Y')
then
p_user_clearable:='Y';
computer_clearable:='Y';
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
*/

/*   AGE
if birth_date_str is not null then
begin
approx_birth_date:=to_date(birth_date_str,'RRRR-MM-DD');
exception
when others then
 begin  -- sometimes they only give the year so let's assume Jan-1 as the day 
 birth_date_str:=substr(birth_date_str,1,4);
 approx_birth_date:=to_date(birth_date_str||'-01-01','RRRR-MM-DD');
 exception when others then
  error_converting:='Y';
 end;
end;
if error_converting = 'N' then
if abs(request_rec.DATE_OF_BIRTH-approx_birth_date) > 730 then  -- if age  difference > 2 years 
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
if abs(request_rec.DATE_OF_BIRTH-approx_birth_date) > 730 then  -- if age  difference > 2 years 
age_match:='N';
p_NM_DOB_AGE:='Y';
n_of_criteria_that_dont_match:=3;
end if;
end if;
end if;
*/


/* REFERENCE */
select * from xwrl_keywords; -- Not used
select * from xwrl_location_types; -- Not used
select * from xwrl_parameters;

/* MASTER */
select * from xwrl_requests order by id desc;

/* DETAIL - REQUEST */
select * from xwrl_request_ind_columns order by id desc;
select * from xwrl_request_entity_columns order by id desc;
select * from xwrl_request_rows order by id desc;

/* DETAIL - REQUEST */
select * from xwrl_response_ind_columns order by id desc;
select * from xwrl_response_entity_columns order by id desc;
select * from xwrl_response_rows order by id desc ;
select * from xwrl_response_rows where request_id = 13623 and rec_row = 1935 order by det_row ;

/* NOTES */
select * from xwrl_note_templates;
select * from xwrl_case_notes;
select * from xwrl_alert_notes order by id desc;

/* DOCUMENTS */
select * from xwrl_alert_documents;
select * from xwrl_case_documents;

/* LEGACY ANALYSIS */
select * from xwrl_wc_contents;

/* OWS */
select * from iridr_edqconfig.dn_case@ebstoows2.coresys.com order by id desc;
select * from iridr_edqconfig.dn_casecomment@ebstoows2.coresys.com;
select * from iridr_edqconfig.dn_usergraveyard@ebstoows2.coresys.com;
select * from iridr_edqconfig.DN_IDENTITY@ebstoows2.coresys.com;
select * from iridr_edqconfig.dn_casehistory@ebstoows2.coresys.com;
select * from iridr_edqconfig.DN_CASETRANSITIONS@ebstoows2.coresys.com;

select * from iridr2_edqconfig.dn_case@ebstoows2.coresys.com;
select * from iridr2_edqconfig.dn_casecomment@ebstoows2.coresys.com;
select * from iridr2_edqconfig.dn_usergraveyard@ebstoows2.coresys.com;
select * from iridr2_edqconfig.DN_IDENTITY@ebstoows2.coresys.com;
select * from iridr2_edqconfig.dn_casehistory@ebstoows2.coresys.com;
select * from iridr2_edqconfig.DN_CASETRANSITIONS@ebstoows2.coresys.com;

/* OWS Custom Tables */
select * from XXIRI_ALERT_VALIDATION;
select * from XXIRI_ALERT_LOG;

/* Tempoerary OWS logging tables */
select * from tmp_xwrl_alerts;
select * from tmp_xwrl_alert_results order by p_alert_id desc;

/* OWS xref table */
select * from xwrl_alert_clearing_xref order by id desc;


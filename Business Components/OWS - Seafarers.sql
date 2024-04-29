with office as (SELECT  get_salesrep_name(profile_option_value) office_name, level_value user_id
FROM    FND_PROFILE_OPTION_VALUES
WHERE   PROFILE_OPTION_ID = 7674)
select 'SICD_SEAFARERS' table_name
,s.seafarer_id --pk
,s.last_name
,s.first_name
,s.middle_initial
,s.birth_date
,c.iso_numeric_code
,s.nationality
,c.country_name
,s.status
,s.gender
--,s.created_by
,u.user_id
,u.user_name
,office.office_name
from sicd_seafarers s
,fnd_user u
,office
,sicd_countries c
where s.status = 'Active'
and s.created_by = u.user_id
and u.user_id = office.user_id (+)
and s.nationality = c.country_code (+)
order by s.last_name, s.first_name
;
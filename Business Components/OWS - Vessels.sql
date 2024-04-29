with office as (SELECT  get_salesrep_name(profile_option_value) office_name, level_value user_id
FROM    FND_PROFILE_OPTION_VALUES
WHERE   PROFILE_OPTION_ID = 7674)
select DISTINCT 'VSSL_VESSELS' table_name,
 v.vessel_pk --pk
,v.official_number
,v.name -- Submitted to WC
,c.country_code -- Submitted to WC
,v.former_name
,v.imo_number
,v.registration_date
,v.reregistration_date
,u.user_name
,office.office_name
from vssl_vessels v
,fnd_user u
,office
,sicd_countries  c
where v.status = 'A'
and v.created_by = u.user_id (+)
and u.user_id = office.user_id (+)
and c.ISO_ALPHA2_CODE(+) = v.init_ofic_code
order by v.name
;
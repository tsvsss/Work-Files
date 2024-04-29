with office as (SELECT  get_salesrep_name(profile_option_value) office_name, level_value user_id
FROM    FND_PROFILE_OPTION_VALUES
WHERE   PROFILE_OPTION_ID = 7674)
,company as (select upper(name) company_name, owner_imo_number company_imo_number
from vssl_owner_members
where proportion = 100
and owner_imo_number is not null
group by upper(name), owner_imo_number)
select 'CORP_MAIN' table_name
,cm.corp_id --pk
,cm.corp_number
,cm.corp_name1 corp_name
/*
,ct.description corp_type
,cm.corp_type
,cm.existence_date
,'MH' country_code
,584 country_iso_code
,cm.fme_existence_date
,cm.fme_country_code
,terr.territory_short_name fme_country_name
,terr.iso_numeric_code fme_country_iso_code
*/
,decode(cm.corp_type,'F',cm.fme_existence_date,cm.existence_date) corp_existance_date
,decode(cm.corp_type,'F',cm.fme_country_code,'MH') corp_country_code
,decode(cm.corp_type,'F',terr.territory_short_name,'Marshall Islands') corp_country_name
,decode(cm.corp_type,'F',terr.iso_numeric_code,584) corp_country_iso_code
,company.company_imo_number
,cs.status_description status
,u.user_name
,office.office_name
,co.office_desc selling_office
FROM corp_main cm
,corp_types ct
,corp_status_types cs
,corp_admin_office co
,Fnd_Territories_Vl terr
,fnd_user u
,office
,company
WHERE cm.stat_status_code = 'A'
--and cm.corp_type = 'F'
and cm.created_by = u.user_id
and cm.corp_type = ct.code (+) -- Corp Type
AND cm.stat_status_code = cs.status_code (+) -- Corp Status
AND cm.off_office_code = co.office_code  (+)  -- Selling Office
and cm.fme_country_code = terr.territory_code (+)
and u.user_id = office.user_id (+)
and upper(cm.corp_name1) = company.company_name (+) -- Vessel Company
ORDER BY cm.corp_name1
;
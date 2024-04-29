SELECT   'VSSL_CONTACTS' table_name,
         acv.contact_id||'.'||acv.vessel_id contact_primary_key,  --Primary Key
         acv.title,
         acv.first_name,-- Submitted to WC
         acv.last_name,-- Submitted to WC
         decode(upper(acv.title),'MR.','MALE','MRS.','FEMALE','UNKNOWN') SEX,-- Submitted to WC
         acv.email_address,
         acv.customer_number, 
         acv.customer_name,
         acv.contact_key, 
         acv.official_number,
         acv.name,
         acv.company_imo_number,
         acv.owner_name,
         acv.address1,
         acv.address2,
         acv.address3,
         acv.city,
         acv.state,
         acv.postal_code,
         acv.province,
         substr(ft.nls_territory,1,4) country,-- Submitted to WC
         u.user_name, 
         ofc.office_name
    FROM VSSL_CONTACTS_V acv,
         fnd_user u,
         (SELECT get_salesrep_name (profile_option_value) office_name,
                 level_value user_id
            FROM fnd_profile_option_values
           WHERE profile_option_id = 7674) ofc,
           fnd_territories ft
   WHERE 1=1--acv.status = 'A'
     AND acv.last_updated_by = u.user_id
     AND u.user_id = ofc.user_id(+)
     AND ft.territory_code (+) = acv.country
ORDER BY  acv.customer_name
;

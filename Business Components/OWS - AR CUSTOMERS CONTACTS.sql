SELECT   'AR_CONTACTS' table_name,
         acv.contact_id,  --pk
         acv.title,
         acv.first_name,-- Submitted to WC
         acv.last_name,-- Submitted to WC
         decode(upper(acv.title),'MR.','MALE','MRS.','FEMALE','UNKNOWN') SEX,-- Submitted to WC
         acv.email_address,
         hca.account_number customer_number, 
         hpcust.party_name customer_name,
         acv.contact_key, 
         hp.address1,
         hp.address2,
         hp.address3,
         hp.city,
         hp.state,
         hp.postal_code,
         hp.province,
         substr(ft.nls_territory,1,4) country,-- Submitted to WC
         u.user_name, 
         ofc.office_name
    FROM AR_CONTACTS_V acv,
         fnd_user u,
         (SELECT get_salesrep_name (profile_option_value) office_name,
                 level_value user_id
            FROM fnd_profile_option_values
           WHERE profile_option_id = 7674) ofc,
           fnd_territories ft, hz_parties hp,
           hz_parties hpcust,
           hz_cust_accounts hca
   WHERE acv.status = 'A'
     AND acv.last_updated_by = u.user_id
     AND u.user_id = ofc.user_id(+)
     AND ft.territory_code (+) = hp.country
     and hp.party_id = acv.contact_party_id
     AND hpcust.party_id = hca.party_id
     AND hca.cust_account_id = acv.customer_id
ORDER BY last_name, first_name
;
SELECT   'AR_CUSTOMERS' table_name,
         ac.customer_id,  --PK
         ac.customer_number, 
         ac.customer_name,-- Submitted to WC
         ac.customer_key, 
         hca.account_name, 
         hp.party_type,
         ct.meaning customer_type,
         hp.address1,
         hp.address2,
         hp.address3,
         hp.city,
         hp.state,
         hp.postal_code,
         hp.province,
         hp.county,
         u.user_name, 
         ofc.office_name
    FROM ar_customers ac,
         fnd_lookup_values_vl ct,
         hz_cust_accounts hca,
         hz_parties hp,
         fnd_user u,
         (SELECT get_salesrep_name (profile_option_value) office_name,
                 level_value user_id
            FROM fnd_profile_option_values
           WHERE profile_option_id = 7674) ofc
   WHERE ac.status = 'A'
     AND ct.lookup_code(+) = ac.customer_type
     AND ct.lookup_type(+) = 'CUSTOMER_TYPE'
     AND ac.created_by = u.user_id
     AND hca.cust_account_id = ac.customer_id
     AND hp.party_id = hca.party_id
     AND u.user_id = ofc.user_id(+)
ORDER BY customer_name
;
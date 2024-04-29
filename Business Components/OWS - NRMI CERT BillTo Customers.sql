WITH office AS
     (SELECT get_salesrep_name (profile_option_value) office_name,
             level_value user_id
        FROM fnd_profile_option_values
       WHERE profile_option_id = 7674)
SELECT   DISTINCT 'NRMI_CERTIFICATES' table_name, 
         s.nrmi_certificates_id, --pk
         s.bt_customer_name, -- Submitted to WC
         bt_email_address, 
         bt_address1,
         bt_address2,
         bt_city,
         bt_province,
         bt_postal_code,
         s.bt_country,
--         bt_telephone,
         c.territory_short_name rq_country_name,  
         s.status, 
         u.user_id,
         u.user_name, office.office_name
    FROM nrmi_certificates s,
         fnd_user u,
         office,
         fnd_territories_vl c
   WHERE 1 = 1               
   AND bt_customer_name is not null
     AND s.created_by = u.user_id
     AND u.user_id = office.user_id(+)
     AND s.rq_country = c.territory_code(+)
ORDER BY s.bt_customer_name
;

WITH office AS
     (SELECT get_salesrep_name (profile_option_value) office_name,
             level_value user_id
        FROM fnd_profile_option_values
       WHERE profile_option_id = 7674)
SELECT   DISTINCT 'NRMI_CERTIFICATES' table_name, 
         s.nrmi_certificates_id, --pk
         s.rq_name, -- Submitted to WC
         rq_email_address, 
         rq_address1,
         rq_address2,
         rq_city,
         rq_province,
         rq_postal_code,
         s.rq_country,
         rq_telephone,
         c.territory_short_name rq_country_name,  
         s.status, 
         u.user_id,
         u.user_name, office.office_name
    FROM nrmi_certificates s,
         fnd_user u,
         office,
         fnd_territories_vl c
   WHERE 1 = 1               
   AND rq_name is not null
     AND s.created_by = u.user_id
     AND u.user_id = office.user_id(+)
     AND s.rq_country = c.territory_code(+)
ORDER BY s.rq_name
;
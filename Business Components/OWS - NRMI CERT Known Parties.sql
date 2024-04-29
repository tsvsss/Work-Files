-- INDIVIDUAL
WITH office AS
     (SELECT get_salesrep_name (profile_option_value) office_name,
             level_value user_id
        FROM fnd_profile_option_values
       WHERE profile_option_id = 7674)
SELECT   'NRMI_KNOWN_PARTIES' table_name, 
         s.nrmi_kp_id, --pk
         n.nrmi_certificates_id, 
		 s.kp_name, -- Submitted to WC
		 NULL birth_date, 
		 NULL nationality,
         NULL country_name, 
		 u.user_id, 
		 u.user_name, 
		 office.office_name
    FROM nrmi_known_parties s, nrmi_certificates n, fnd_user u, office
   WHERE 1 = 1                                           --s.status = 'Active'
     AND s.created_by = u.user_id
     AND u.user_id = office.user_id(+)
     AND s.nrmi_certificates_id = n.nrmi_certificates_id
ORDER BY s.kp_name
;
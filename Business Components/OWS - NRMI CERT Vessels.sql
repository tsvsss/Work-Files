WITH office AS
     (SELECT get_salesrep_name (profile_option_value) office_name,
             level_value user_id
        FROM fnd_profile_option_values
       WHERE profile_option_id = 7674)
SELECT   'NRMI_CERTIFICATES' table_name, 
         v.NRMI_CERTIFICATES_ID, --pk
         v.vessel_name,        -- Submitted to WC
         v.VESSEL_IMO_NUMBER,
         v.official_number,
         v.REGISTERED_OWNER_NAME,
         PORT_OF_REGISTRY,
         ADDRESS_REG_OWN, 
         u.user_id,
         u.user_name, office.office_name
    FROM nrmi_certificates s,
    NRMI_VESSELS v,
         fnd_user u,
         office
   WHERE 1 = 1               
   and v.status = 'A'
   and s.NRMI_CERTIFICATES_ID = v.NRMI_CERTIFICATES_ID
     AND s.created_by = u.user_id
     AND u.user_id = office.user_id(+)
ORDER BY v.VESSEL_NAME 
;
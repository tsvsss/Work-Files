SELECT 'INSP_INSPECTORS' table_name, 
       ins.inspector_id||'.'||inspector_contact_id pk, --pk 
       ins.given_NAME, -- Submitted to WC
       ins.surname  , -- Submitted to WC
       NULL vendor,
       ins.sex, -- Submitted to WC
       ins.birth_date,-- Submitted to WC
       ins.CITIZENSHIP ,-- Submitted to WC
       addr.address1, 
       addr.address2, 
       address3,
       addr.province country, 
       addr.postal_code, 
       addr.territory_code,
       c.territory_short_name, 
       NULL vendor_number,
       contract_effective_date, 
       contract_expires_date, 
       u.user_name,
       ofc.office_name
  FROM INSP_INSPECTOR_CONTACTS ins,
       insp_inspectors insp,
       insp_addresses addr,
       fnd_user u,
       fnd_territories_vl c,
       (SELECT get_salesrep_name (profile_option_value) office_name,
               level_value user_id
          FROM fnd_profile_option_values
         WHERE profile_option_id = 7674) ofc
 WHERE 1 = 1
   AND ins.enabled = 'Y'
   AND ins.inspector_id = insp.inspector_id
   AND u.user_id = ofc.user_id(+)
   AND ins.last_updated_by = u.user_id(+)
   AND addr.inspector_id(+) = ins.inspector_id
   AND addr.territory_code = c.territory_code(+)
UNION ALL
SELECT 'INSP_INSPECTORS' table_name, 
       to_char(ins.inspector_id), --pk
       ins.NAME , -- Submitted to WC
       NULL last_name, -- Submitted to WC
       pv.vendor_name, 
       NULL sex, -- Submitted to WC
       null birth_date,-- Submitted to WC
       NULL CITIZENSHIP ,-- Submitted to WC
       addr.address1, 
       addr.address2, 
       address3,
       addr.province country, 
       addr.postal_code, 
       addr.territory_code,
       c.territory_short_name, 
       pv.segment1 vendor_number,
       contract_effective_date, 
       contract_expires_date, 
       u.user_name,
       ofc.office_name
  FROM insp_inspectors ins,
       insp_addresses addr,
       po_vendors pv,
       fnd_user u,
       fnd_territories_vl c,
       (SELECT get_salesrep_name (profile_option_value) office_name,
               level_value user_id
          FROM fnd_profile_option_values
         WHERE profile_option_id = 7674) ofc
 WHERE 1 = 1
   AND enabled = 'Y'
   AND pv.vendor_id(+) = ins.vendor_id
   AND u.user_id = ofc.user_id(+)
   AND ins.last_updated_by = u.user_id(+)
   AND addr.inspector_id(+) = ins.inspector_id
   AND addr.territory_code = c.territory_code(+)
Order by surname, given_name
;
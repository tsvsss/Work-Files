SELECT 'REG11_HEADER' table_name, 
reg11_header_id,  --pk
imo_number, 
current_name,
reg_name, 
registered_owner_name, 
beneficial_owner_name, 
bo_address,
transaction_type, 
registration_type, 
world_check_approval_status,
status, 
u.user_name,
ofc.office_name
  FROM reg11_header reg11,
       fnd_user u,
       (SELECT get_salesrep_name (profile_option_value) office_name,
               level_value user_id
          FROM fnd_profile_option_values
         WHERE profile_option_id = 7674) ofc
 WHERE 1 = 1 AND u.user_id = ofc.user_id(+) AND reg11.created_by = u.user_id(+)
 order by current_name
 ;
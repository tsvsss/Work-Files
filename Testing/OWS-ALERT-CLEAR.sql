SELECT
                   'IRIDR2_EDQCONFIG'
                 , ID
                 , CURRENT_STATE
                 , PARENT_ID
                 , KEY_LABEL -- tsuazo 20190829

            FROM
                   iridr2_edqconfig.dn_case
            WHERE
                   CASE_TYPE       = 'issue';
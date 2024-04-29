update xwrl_response_ind_columns
set x_state =  'PEP - Possible'
where id = 643135;


update xwrl_response_ind_columns
set x_state =  'PEP - False Positive'
where id = 620737;


update xwrl_response_ind_columns
set x_state =  'EDD - Possible'
where id = 643145
;

update xwrl_response_ind_columns
set x_state =  'EDD - False Positive'
where id = 259689;


update xwrl_response_ind_columns
set x_state =  'SAN - False Positive'
where id = 257515;

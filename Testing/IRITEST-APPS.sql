CREATE INDEX xwrl_request_ind_columns_idx1 on xwrl_request_ind_columns(request_id desc)
;

CREATE INDEX xwrl_request_entity_cols_idx1 on xwrl_request_entity_columns(request_id desc)
;

CREATE INDEX xwrl_request_rows_idx1 on xwrl_request_rows(request_id desc)
;

CREATE INDEX xwrl_response_ind_cols_idx1 on xwrl_response_ind_columns(request_id desc)
;

CREATE INDEX xwrl_response_entity_cols_idx1 on xwrl_response_entity_columns(request_id desc)
;

CREATE INDEX xwrl_response_rows_idx1 on xwrl_response_rows(request_id desc)
;

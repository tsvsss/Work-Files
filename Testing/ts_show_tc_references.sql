declare

      entity_data                 rmi_ows_common_util.screening_tab;
      l_req                       rmi_ows_common_util.xwrl_xref_rec;
      
      v_source_table     VARCHAR2(50);
      v_source_column   VARCHAR2(50);
      v_source_id        NUMBER;

begin

v_source_table := 'SICD_SEAFARERS';
v_source_column := 'SEAFARER_ID';
v_source_id := 1137666;

delete from tmp_xwrl_xref_rec; 
commit;

rmi_ows_common_util.query_cross_reference(v_source_table,v_source_column,v_source_id,entity_data);

FOR i IN 1 .. entity_data.COUNT  LOOP

      l_req.created_by := entity_data (i).created_by;
      l_req.creation_date := entity_data (i).creation_date;
      l_req.last_updated_by := entity_data (i).last_updated_by;
      l_req.last_update_date := entity_data (i).last_update_date;
      l_req.last_update_login := entity_data (i).last_update_login;     
      l_req.relationship_type := entity_data (i).relationship_type;
      l_req.entity_type := entity_data (i).entity_type;
      l_req.state := entity_data (i).state;
      l_req.status := entity_data (i).status;      
      l_req.source_table := entity_data (i).source_table;
      l_req.source_table_column := entity_data (i).source_table_column;
      l_req.source_id := entity_data (i).source_id;
      l_req.full_name := entity_data (i).full_name;
      l_req.batch_id := entity_data (i).batch_id;
      l_req.start_date := entity_data (i).start_date;
      l_req.end_date := entity_data (i).end_date;
      l_req.date_of_birth := entity_data (i).date_of_birth;
      l_req.family_name := entity_data (i).family_name;
      l_req.given_name := entity_data (i).given_name;
      l_req.sex := entity_data (i).sex;
      l_req.passport_number := entity_data (i).passport_number;
      l_req.citizenship_country_code :=  entity_data (i).citizenship_country_code;            
      l_req.passport_issuing_country_code := entity_data (i).passport_issuing_country_code;
     l_req.country_of_residence := entity_data (i).country_of_residence;
     l_req.city_of_residence_id := entity_data (i).city_of_residence_id;
      l_req.imo_number := entity_data (i).imo_number;
      l_req.tc_excluded := entity_data (i).tc_excluded;
      l_req.master_id := entity_data (i).master_id;
      l_req.alias_id := entity_data (i).alias_id;
      l_req.xref_id := entity_data (i).xref_id;
      l_req.wc_screening_request_id := entity_data (i).wc_screening_request_id;

      insert into tmp_xwrl_xref_rec values l_req;
      		  
end loop;
      
commit;

end;
/	

select *
from tmp_xwrl_xref_rec
;

select *
from fnd_user
where user_id = 11026;

create table tmp_ows_request_rec (
      entity_type                     VARCHAR2 (100),
      source_table                    VARCHAR2 (100),
      source_id                       VARCHAR2 (100),
      source_table_column             VARCHAR2 (100),
      ID                              NUMBER,
      status                          VARCHAR2 (100),
      full_name                       VARCHAR2 (100),
      first_name                      VARCHAR2 (100),
      last_name                       VARCHAR2 (100),
      title                           VARCHAR2 (100),
      entity_name                     VARCHAR2 (100),
      date_of_birth                   DATE,
      gender                          VARCHAR2 (100),
      passport_number                 VARCHAR2 (100),
      registrationnumber              VARCHAR2 (100),
      city                            VARCHAR2 (100),
      nationality                     VARCHAR2 (100),
      passport_issuing_country_code   VARCHAR2 (100),
      residence_country_code          VARCHAR2 (100),
      vessel_indicator                VARCHAR2 (10),
      created_by                      NUMBER,
      creation_date                   DATE,
      last_updated_by                 NUMBER,
      last_updated_date               DATE,
      last_update_login               NUMBER,
      name_screened                   VARCHAR2 (200),
      batch_id                        NUMBER,
      city_id                         NUMBER,
      master_id                       NUMBER,
      alias_id                        NUMBER,
      xref_id                         NUMBER,
      wc_screening_request_id         NUMBER,
      department                      VARCHAR2 (100),
      priority                        VARCHAR2 (100),
      document_type                   VARCHAR2 (100)
      );
      
create table tmp_xwrl_xref_rec (master_id                       NUMBER,
      relationship_type               VARCHAR (50),
      entity_type                     VARCHAR (100),
      state                           VARCHAR (100),
      status                          VARCHAR (100),
      source_table                    VARCHAR (50),
      source_table_column             VARCHAR (50),
      source_id                       NUMBER,
      full_name                       VARCHAR (300),
      batch_id                        NUMBER,
      start_date                      DATE,
      end_date                        DATE,
      creation_date                   DATE,
      created_by                      NUMBER,
      last_update_date                DATE,
      last_updated_by                 NUMBER,
      last_update_login               NUMBER,
      date_of_birth                   DATE,
      family_name                     VARCHAR (100),
      given_name                      VARCHAR (100),
      --sex                             VARCHAR2 (10),
      sex                             VARCHAR2 (20),
      passport_number                 VARCHAR2 (30),
      citizenship_country_code        VARCHAR2 (30),
      passport_issuing_country_code   VARCHAR2 (30),
      country_of_residence            VARCHAR2 (30),
      city_of_residence_id            NUMBER,
      imo_number                      VARCHAR2 (50),
      tc_excluded                     VARCHAR2 (1),
      alias_id                        NUMBER,
      xref_id                         NUMBER,
      wc_screening_request_id         NUMBER,
      department                      VARCHAR2 (100),
      priority                        VARCHAR2 (100),
      document_type                   VARCHAR2 (100))
      ;
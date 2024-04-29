SELECT DISTINCT role, PRIVILEGE AS "Database Link Privileges"
FROM ROLE_SYS_PRIVS
WHERE PRIVILEGE IN ( 'CREATE SESSION','CREATE DATABASE LINK',
                     'CREATE PUBLIC DATABASE LINK')
;

select *
from ROLE_SYS_PRIVS;

SELECT
  *
FROM
  DBA_SYS_PRIVS
  where grantee = 'APPS'
AND PRIVILEGE IN ( 'CREATE SESSION','CREATE DATABASE LINK',
                     'CREATE PUBLIC DATABASE LINK')
  ORDER BY 2;

select *
from WC_SCREENING_REQUEST
--where WC_SCREENING_REQUEST_ID = :WC_SCREENING_REQUEST_ID
order by wc_screening_request_id desc
;

select *
from wc_matches
where WC_SCREENING_REQUEST_ID = :WC_SCREENING_REQUEST_ID
order by wc_screening_request_id desc
;

select *
from wc_content
where wc_content_id = :wc_content_id
;

--SELECT x.key, x.value
--select ',String '||x.key
--select '",:'||x.key||'" +'
--select 'st.setObject("'||x.key||'", '||x.key||');'
--select 'oracle.apps.xwrl.model.view.XwrlRequestIndColumnsViewEx.var'||initcap(x.key)||'_LABEL='||initcap(x.key)
--select '<Variable Name="var'||initcap(x.key)||'" Kind="viewcriteria" Type="java.lang.String"><Properties><SchemaBasedProperties><DISPLAYWIDTH Value="10"/><LABEL  ResId="oracle.apps.xwrl.model.view.XwrlRequestIndColumnsViewEx.var'||initcap(x.key)||'_LABEL"/> </SchemaBasedProperties></Properties></Variable>'
--select '<NamedData NDName="'||x.key||'" NDValue="#{bindings.ExecuteWithParams_var'||initcap(x.key)||'}" NDType="java.lang.String"/>'
--select '<Variable Name="var'||initcap(x.key)||'" Kind="viewcriteria" Type="java.lang.String"/>'
--select '<ViewCriteriaItem Name="XwrlRequestIndColumnsViewExCriteria_XwrlRequestIndColumnsViewExCriteria_row_0_'||initcap(x.key)||'"  ViewAttribute="'||initcap(x.key)||'" Operator="="  Conjunction="AND"  Value=":var'||initcap(x.key)||'" IsBindVarValue="true" Required="Optional"/>'
--select 'ADFUtils.setBoundAttributeValue("var'||initcap(x.key)||'", null);'
--select 'pageFlowScope.put("var'||initcap(x.key)||'",(String) r.getAttribute("'||initcap(x.key)||'"));'
select 'pageFlowScope.put("var'||initcap(x.key)||'",null);'
--select 'ADFUtils.setBoundAttributeValue("var'||initcap(x.key)||'", pageFlowScope.get("var'||initcap(x.key)||'"));'
      FROM
         xwrl_parameters t,
         XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS key varchar2(2700) PATH 'name()'
         , value varchar2(2700) PATH 'text()'
       ) x
      WHERE
         t.id = 'XML'
         AND t.key = 'REQUEST_INDIVIDUAL'
         and x.key <> 'request'
         ; 

--SELECT x.key, x.value
--select ',String '||x.key
--select '",:'||x.key||'" +'
--select 'st.setObject("'||x.key||'", '||x.key||');'
--select 'oracle.apps.xwrl.model.view.XwrlRequestEntityColumnsViewEx.var'||initcap(x.key)||'_LABEL='||initcap(x.key)
--select '<NamedData NDName="'||x.key||'" NDValue="#{bindings.ExecuteWithParams_var'||initcap(x.key)||'}" NDType="java.lang.String"/>'
--select '<Variable Name="var'||initcap(x.key)||'" Kind="viewcriteria" Type="java.lang.String"><Properties><SchemaBasedProperties><DISPLAYWIDTH Value="10"/><LABEL  ResId="oracle.apps.xwrl.model.view.XwrlRequestEntityColumnsViewEx.var'||initcap(x.key)||'_LABEL"/> </SchemaBasedProperties></Properties></Variable>'
--select '<Variable Name="var'||initcap(x.key)||'" Kind="viewcriteria" Type="java.lang.String"/>'
--select '<ViewCriteriaItem Name="XwrlRequestEntityColumnsViewCriteria_XwrlRequestEntityColumnsViewCriteria_row_0_'||initcap(x.key)||'"  ViewAttribute="'||initcap(x.key)||'" Operator="="  Conjunction="AND"  Value=":var'||initcap(x.key)||'" IsBindVarValue="true" Required="Optional"/>'
--select 'ADFUtils.setBoundAttributeValue("var'||initcap(x.key)||'", null);'
--select 'pageFlowScope.put("var'||initcap(x.key)||'",(String) r.getAttribute("'||initcap(x.key)||'"));'
select 'pageFlowScope.put("var'||initcap(x.key)||'",null);'
--select 'ADFUtils.setBoundAttributeValue("var'||initcap(x.key)||'", pageFlowScope.get("var'||initcap(x.key)||'"));'
      FROM
         xwrl_parameters t,
         XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
         '//ws:*'
         PASSING t.value_xml
         COLUMNS key varchar2(2700) PATH 'name()'
         , value varchar2(2700) PATH 'text()'
       ) x
      WHERE
         t.id = 'XML'
         AND t.key = 'REQUEST_ENTITY'
         and x.key <> 'request'
         ; 


select x.* 
from wc_content c
,xmltable( XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/*/names/name'  passing c.xml_response
                                                 columns
                                                  fullname varchar2(200)  path 'fullName',
                                                  nametype varchar(200) path '@type',
                                                  givenname varchar2(200)  path 'givenName',
                                                  lastname varchar2(200) path 'lastName'
                                                 ) x 
where c.WC_SCREENING_REQUEST_ID = :WC_SCREENING_REQUEST_ID
and c.wc_content_id = :wc_content_id
;

select x.* 
from wc_content c
,xmltable( XMLNamespaces(
                                                 'http://schemas.xmlsoap.org/soap/envelope/' as "soap",
                                                 'http://screening.complinet.com/' as "ns2"),
                                                  'soap:Envelope/soap:Body/ns2:getDetailsResponse/return/entitySet/entities/individual' passing c.xml_response
                                                 columns
                                                  sex varchar2(200)  path 'gender',
                                                  age varchar2(200) path 'age',
                                                  as_of varchar2(200) path 'ageAsOfDate'
                                                 ) x 
where c.WC_SCREENING_REQUEST_ID = :WC_SCREENING_REQUEST_ID
and c.wc_content_id = :wc_content_id
;


select c.WC_SCREENING_REQUEST_ID
,c.wc_matches_id
,c.wc_content_id
from wc_content c
,xwrl_requests r
where c.WC_SCREENING_REQUEST_ID = r.WC_SCREENING_REQUEST_ID
;

select count(*)
from xwrl_requests
;

select count(*)
from wc_content c
;

select count(*)
from xwrl_response_rows
;

select count(*)
from wc_content c
,xwrl_requests r
where c.WC_SCREENING_REQUEST_ID = r.WC_SCREENING_REQUEST_ID
and c.wc_screening_request_id = :wc_screening_request_id
;


select c.WC_SCREENING_REQUEST_ID
,c.wc_matches_id
,c.wc_content_id
,xc.wc_content_id id
from wc_content c
,xwrl_requests r
,xwrl_wc_contents xc
where c.WC_SCREENING_REQUEST_ID = r.WC_SCREENING_REQUEST_ID
and c.wc_content_id = xc.wc_content_id (+)
--and c.WC_SCREENING_REQUEST_ID = 848005
and xc.content_id is null
order by c.WC_SCREENING_REQUEST_ID desc
;


select *
from xwrl_wc_contents;

/**********************************************/

declare

cursor c1 is select c.WC_SCREENING_REQUEST_ID
,c.wc_matches_id
,c.wc_content_id
,xc.wc_content_id wc_id
from wc_content c
,xwrl_requests r
,xwrl_wc_contents xc
where c.WC_SCREENING_REQUEST_ID = r.WC_SCREENING_REQUEST_ID
and c.wc_content_id = xc.wc_content_id (+)
--and c.WC_SCREENING_REQUEST_ID = 848005
and xc.wc_content_id is null
order by c.WC_SCREENING_REQUEST_ID desc
;

tRec xwrl_wc_contents%rowtype;

vTab world_check_iface.display_details_tab;
vRec world_check_iface.display_details_rec;
vEmpty world_check_iface.display_details_tab;

idx pls_integer;

begin

for c1rec  in c1 loop

   vTab := vEmpty;
   world_check_iface.display_details(c1rec.wc_content_id,vTab);

   for idx in 1..vTab.count loop
   
       vRec := vTab(idx);
      
      tRec.WC_SCREENING_REQUEST_ID :=  c1rec.WC_SCREENING_REQUEST_ID;
      tRec.wc_matches_id :=  c1rec.wc_matches_id;
      tRec.wc_content_id :=  c1rec.wc_content_id;
      tRec.heading := vRec.heading;
      tRec.data_type := vRec.data_type;
      tRec.display_data := vRec.display_data;
      
      insert  into xwrl_wc_contents values tRec;
      
      commit;
   
   end loop;

end loop;

end;
/



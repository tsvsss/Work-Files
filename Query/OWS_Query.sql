/* OWS PROD from IRIPROD */
select * from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com order by id desc;
select * from IRIP1_EDQCONFIG.dn_casecomment@ebstoows2.coresys.com;
select * from IRIP1_EDQCONFIG.dn_usergraveyard@ebstoows2.coresys.com;
select * from IRIP1_EDQCONFIG.DN_IDENTITY@ebstoows2.coresys.com;
select * from IRIP1_EDQCONFIG.dn_casehistory@ebstoows2.coresys.com;
select * from IRIP1_EDQCONFIG.DN_CASETRANSITIONS@ebstoows2.coresys.com;

select * from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com;
select * from IRIP2_EDQCONFIG.dn_casecomment@ebstoows2.coresys.com;
select * from IRIP2_EDQCONFIG.dn_usergraveyard@ebstoows2.coresys.com;
select * from IRIP2_EDQCONFIG.DN_IDENTITY@ebstoows2.coresys.com;
select * from IRIP2_EDQCONFIG.dn_casehistory@ebstoows2.coresys.com;
select * from IRIP2_EDQCONFIG.DN_CASETRANSITIONS@ebstoows2.coresys.com;

/* OWS TEST from IRIDEV */
select 1 from dual@ebstoows2.coresys.com;
select * from iridr_edqconfig.dn_case@ebstoows2.coresys.com order by id desc;
select * from iridr_edqconfig.dn_casecomment@ebstoows2.coresys.com;
select * from iridr_edqconfig.dn_usergraveyard@ebstoows2.coresys.com;
select * from iridr_edqconfig.DN_IDENTITY@ebstoows2.coresys.com;
select * from iridr_edqconfig.dn_casehistory@ebstoows2.coresys.com;
select * from iridr_edqconfig.DN_CASETRANSITIONS@ebstoows2.coresys.com;

select * from iridr2_edqconfig.dn_case@ebstoows2.coresys.com;
select * from iridr2_edqconfig.dn_casecomment@ebstoows2.coresys.com;
select * from iridr2_edqconfig.dn_usergraveyard@ebstoows2.coresys.com;
select * from iridr2_edqconfig.DN_IDENTITY@ebstoows2.coresys.com;
select * from iridr2_edqconfig.dn_casehistory@ebstoows2.coresys.com;
select * from iridr2_edqconfig.DN_CASETRANSITIONS@ebstoows2.coresys.com;
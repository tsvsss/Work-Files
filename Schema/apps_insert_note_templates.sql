/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_insert_note_templates.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                     $*/
/********************************************************************************************************************
* Object Type         : Scripts                                                                                     *
* Name                :                                                                                             *
* Script Name         : apps_insert_note_templates.sql                                                              *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                      *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    :                                                                                             *
* Last Reviewed Date  :                                                                                             *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO          15-NOV-2019  I      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/


/* APPS */

truncate table xwrl.xwrl_note_templates
;

insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (10,'CASE','INDIVIDUAL','Dear [IRI employee who submitted the vetting],  In order to clear the remaining possible match(es), I will need you to provide the following:  Information on the seafarer'||''''||'s whereabouts for the following date(s).  Information may be provided through sea time, school records/trainings, or other employment.  Please use the following link to find the standard language for the request: F:\DATA\Trade Compliance Thank you, [Your name] [Day-Month-Year] ');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (20,'CASE','INDIVIDUAL','Dear [IRI employee who submitted the vetting],  In order to clear the remaining possible match(es), I will need you to provide the following:  A police clearance certificate.  Please use the following link to find the standard language for the request: F:\DATA\Trade Compliance Thank you, [Your name] [Day-Month-Year] ');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (30,'CASE','INDIVIDUAL','Dear [IRI employee who submitted the vetting],  Unfortunately, the affidavit for XXXXXXXXXXX  must be redone.  The only persons authorized to sign as witness on the MI-274 are a Notary Public, the Master of the vessel (who must have Marshall Islands credentials as Master), or an authorized Marshall Islands filing agent.  I have been informed that  is not an authorized signatory therefore cannot witness and sign the MI-274 affidavit.  Can you please request a new affidavit witnessed by an authorized party: a Notary Public, the Master of the vessel (with Marshall Islands credentials as Master), or an authorized Marshall Islands filing agent?  Please use the following link to find the standard language for the request: F:\DATA\Trade Compliance Thank you, [Your name] [Day-Month-Year] ');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (40,'CASE','INDIVIDUAL','Dear [IRI employee who submitted the vetting],  Please note that the affidavit for XXXXXXXXXXXXX  has not been completed in its entirety and therefore must be redone.  Can you please request a new affidavit completed in entirety and witnessed by an authorized party: a Notary Public, the Master of the vessel (with Marshall Islands credentials as Master), or an authorized Marshall Islands filing agent?  Please use the following link to find the standard language for the request: F:\DATA\Trade Compliance Thank you, [Your name] [Day-Month-Year] ');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (50,'CASE','INDIVIDUAL','Dear XXXX, Please identify whether the individual being vetted is the/is related to the Qualified Intermediary, or if they are related to formed company, or if they are related to company seeking formation.  Thank you,  [Your name] [Day-Month-Year] ');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (60,'CASE','INDIVIDUAL','Please note that we will need a full copy of the individual'||''''||'s internal passport showing the current permanent residence address, with a full translation provided by a certified translator in order to proceed forward.  Please note that any missing pages will result in the vetting being returned. ');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (70,'CASE','INDIVIDUAL','Please note that we will need a full copy of the individual'||''''||'s civil passport showing the current permanent residence address, with a full translation provided by a certified translator in order to proceed forward.  Please note that any missing pages will result in the vetting being returned. ');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (80,'CASE','INDIVIDUAL','Please provide a government issued ID for this individual. ');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (90,'CASE','INDIVIDUAL','Please provide the documents for this seafarer. ');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key,note_type,  note_category, note) values (100,'CASE','INDIVIDUAL','Please upload documents upon revetting ');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key,note_type,  note_category, note) values (110,'CASE','INDIVIDUAL','Please upload documents for this seafarer upon revetting. ');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key,note_type,  note_category, note) values (120,'CASE','INDIVIDUAL','Please upload documents for this seafarer upon revetting. ');

insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (10,'CASE','ENTITY','Please  upload documents for this entity.');

insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (10,'ALERT','ENTITY','Name is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (20,'ALERT','ENTITY','Location is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (30,'ALERT','ENTITY','Company was dissolved.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (40,'ALERT','ENTITY','Legal Review.');

insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (10,'ALERT','INDIVIDUAL','Name is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (15,'ALERT','INDIVIDUAL','Fathers Name is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (20,'ALERT','INDIVIDUAL','Date of Birth / Age not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (30,'ALERT','INDIVIDUAL','Sex is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (40,'ALERT','INDIVIDUAL','Individual is deceased.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (50,'ALERT','INDIVIDUAL','Visual Identification is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (60,'ALERT','INDIVIDUAL','Chinese Name is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (70,'ALERT','INDIVIDUAL','User Review.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (75,'ALERT','INDIVIDUAL','Legal Review.');

insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (10,'CLEAR','INDIVIDUAL','Name is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (15,'CLEAR','INDIVIDUAL','Fathers Name is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (20,'CLEAR','INDIVIDUAL','Date of Birth / Age not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (30,'CLEAR','INDIVIDUAL','Sex is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (40,'CLEAR','INDIVIDUAL','Individual is deceased.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (50,'CLEAR','INDIVIDUAL','Visual Identification is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (60,'CLEAR','INDIVIDUAL','Chinese Name is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (70,'CLEAR','INDIVIDUAL','User Review.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (75,'CLEAR','INDIVIDUAL','Legal Review.');


insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (10,'CLEAR','ENTITY','Name is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (20,'CLEAR','ENTITY','Location is not a match.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (30,'CLEAR','ENTITY','Company was dissolved.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (40,'CLEAR','ENTITY','Legal Review.');



insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (80,'CLEAR','INDIVIDUAL','Full vetting to be completed upon the next transaction.');
insert /*+ append */ into xwrl.xwrl_note_templates (sort_key, note_type, note_category, note) values (50,'CLEAR','ENTITY','Full vetting to be completed upon the next transaction.');

commit;


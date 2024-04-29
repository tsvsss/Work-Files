/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_data_fix_scripts2.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                         $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : apps_data_fix_scripts2.sql                                                                  *
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

/* Backfill XWRL_PARTY_ALIAS */

declare

cursor c1 is
select id
,DATE_OF_BIRTH
,SEX
,IMO_NUMBER
,VESSEL_INDICATOR
,PASSPORT_NUMBER
,PASSPORT_ISSUING_COUNTRY_CODE
,CITIZENSHIP_COUNTRY_CODE
,COUNTRY_OF_RESIDENCE
,CITY_OF_RESIDENCE_ID
,DATE_OF_BIRTH||SEX||IMO_NUMBER||VESSEL_INDICATOR||PASSPORT_NUMBER||PASSPORT_ISSUING_COUNTRY_CODE||CITIZENSHIP_COUNTRY_CODE||COUNTRY_OF_RESIDENCE||CITY_OF_RESIDENCE_ID rec_key
from xwrl_party_master
order by id desc;

cursor c2 (p_master_id in integer) is
select  id
,DATE_OF_BIRTH
,SEX
,IMO_NUMBER
,VESSEL_INDICATOR
,PASSPORT_NUMBER
,PASSPORT_ISSUING_COUNTRY_CODE
,CITIZENSHIP_COUNTRY_CODE
,COUNTRY_OF_RESIDENCE
,CITY_OF_RESIDENCE_ID
,DATE_OF_BIRTH||SEX||IMO_NUMBER||VESSEL_INDICATOR||PASSPORT_NUMBER||PASSPORT_ISSUING_COUNTRY_CODE||CITIZENSHIP_COUNTRY_CODE||COUNTRY_OF_RESIDENCE||CITY_OF_RESIDENCE_ID rec_key
from xwrl_party_alias
where master_id = p_master_id
and last_update_login is null
;

v_count integer;

begin

for c1rec in c1 loop

for c2rec in c2 (c1rec.id) loop

   v_count := v_count + 1;
   
   if c1rec.rec_key <> c2rec.rec_key then

   update xwrl_party_alias
   set  DATE_OF_BIRTH = NVL(DATE_OF_BIRTH,c1rec.DATE_OF_BIRTH)
         ,SEX = NVL(SEX,c1rec.SEX)
         ,IMO_NUMBER = NVL(IMO_NUMBER,c1rec.IMO_NUMBER)
         ,VESSEL_INDICATOR = NVL(VESSEL_INDICATOR,c1rec.VESSEL_INDICATOR)
         ,PASSPORT_NUMBER = NVL(PASSPORT_NUMBER,c1rec.PASSPORT_NUMBER)
         ,PASSPORT_ISSUING_COUNTRY_CODE = NVL(PASSPORT_ISSUING_COUNTRY_CODE,c1rec.PASSPORT_ISSUING_COUNTRY_CODE)
         ,CITIZENSHIP_COUNTRY_CODE = NVL(CITIZENSHIP_COUNTRY_CODE,c1rec.CITIZENSHIP_COUNTRY_CODE)
         ,COUNTRY_OF_RESIDENCE = NVL(COUNTRY_OF_RESIDENCE,c1rec.COUNTRY_OF_RESIDENCE)
         ,CITY_OF_RESIDENCE_ID = NVL(CITY_OF_RESIDENCE_ID,c1rec.CITY_OF_RESIDENCE_ID)
         ,last_update_login = 100
where id = c2rec.id
and last_update_login is null
;

end if;

end loop;

      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/




/* Backfill XWRL_PARTY_MASTER */

declare

cursor c1 is
select id
,master_id
,DATE_OF_BIRTH
,SEX
,IMO_NUMBER
,VESSEL_INDICATOR
,PASSPORT_NUMBER
,PASSPORT_ISSUING_COUNTRY_CODE
,CITIZENSHIP_COUNTRY_CODE
,COUNTRY_OF_RESIDENCE
,CITY_OF_RESIDENCE_ID
,DATE_OF_BIRTH||SEX||IMO_NUMBER||VESSEL_INDICATOR||PASSPORT_NUMBER||PASSPORT_ISSUING_COUNTRY_CODE||CITIZENSHIP_COUNTRY_CODE||COUNTRY_OF_RESIDENCE||CITY_OF_RESIDENCE_ID rec_key
from xwrl_party_alias
order by id desc;

cursor c2 (p_master_id in integer) is
select  id
,DATE_OF_BIRTH
,SEX
,IMO_NUMBER
,VESSEL_INDICATOR
,PASSPORT_NUMBER
,PASSPORT_ISSUING_COUNTRY_CODE
,CITIZENSHIP_COUNTRY_CODE
,COUNTRY_OF_RESIDENCE
,CITY_OF_RESIDENCE_ID
,DATE_OF_BIRTH||SEX||IMO_NUMBER||VESSEL_INDICATOR||PASSPORT_NUMBER||PASSPORT_ISSUING_COUNTRY_CODE||CITIZENSHIP_COUNTRY_CODE||COUNTRY_OF_RESIDENCE||CITY_OF_RESIDENCE_ID rec_key
from xwrl_party_master
where id = p_master_id
and last_update_login is null
;

v_count integer;

begin

for c1rec in c1 loop

for c2rec in c2 (c1rec.master_id) loop

   v_count := v_count + 1;
   
   if c1rec.rec_key <> c2rec.rec_key then

   update xwrl_party_alias
   set  DATE_OF_BIRTH = NVL(DATE_OF_BIRTH,c1rec.DATE_OF_BIRTH)
         ,SEX = NVL(SEX,c1rec.SEX)
         ,IMO_NUMBER = NVL(IMO_NUMBER,c1rec.IMO_NUMBER)
         ,VESSEL_INDICATOR = NVL(VESSEL_INDICATOR,c1rec.VESSEL_INDICATOR)
         ,PASSPORT_NUMBER = NVL(PASSPORT_NUMBER,c1rec.PASSPORT_NUMBER)
         ,PASSPORT_ISSUING_COUNTRY_CODE = NVL(PASSPORT_ISSUING_COUNTRY_CODE,c1rec.PASSPORT_ISSUING_COUNTRY_CODE)
         ,CITIZENSHIP_COUNTRY_CODE = NVL(CITIZENSHIP_COUNTRY_CODE,c1rec.CITIZENSHIP_COUNTRY_CODE)
         ,COUNTRY_OF_RESIDENCE = NVL(COUNTRY_OF_RESIDENCE,c1rec.COUNTRY_OF_RESIDENCE)
         ,CITY_OF_RESIDENCE_ID = NVL(CITY_OF_RESIDENCE_ID,c1rec.CITY_OF_RESIDENCE_ID)
         ,last_update_login = 100
where id = c2rec.id
and last_update_login is null
;

end if;

end loop;

      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/




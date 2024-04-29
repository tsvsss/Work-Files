create or replace package apps.xwrl_name_utils as

   FUNCTION cleanse_name (
   p_name varchar2
   ) return varchar2;

   FUNCTION same_name (
   p_name1 varchar2
   ,p_name2 varchar2
   ) return varchar2;
   
end xwrl_name_utils;
/

create or replace package body apps.xwrl_name_utils as

   FUNCTION cleanse_name (
   p_name varchar2
   ) return varchar2 as 

   v_name varchar2(1000);

   begin

   --v_name := p_name;
   --v_name := replace (v_name, '&', chr (38) || 'amp;'); -- replace ampersand for XML processing
   --v_name := replace (v_name, '"');  -- replace double quotes for XML processing
   -- tsuazo 11/17/2019  strip special characters
   v_name := REGEXP_REPLACE(UPPER(p_name), '[^0-9A-Za-z ]',' ');

   return v_name;

   end cleanse_name;
   
   FUNCTION same_name (
   p_name1 varchar2
   ,p_name2 varchar2
   ) return varchar2 as 

   v_name1 varchar2(1000);
   v_name2 varchar2(1000);
   
   v_return varchar2(1);

   begin

   v_return := 'N';

   --v_name := p_name;
   --v_name := replace (v_name, '&', chr (38) || 'amp;'); -- replace ampersand for XML processing
   --v_name := replace (v_name, '"');  -- replace double quotes for XML processing
   -- tsuazo 11/17/2019  strip special characters
   v_name1 := REGEXP_REPLACE(UPPER(p_name1), '[^0-9A-Za-z ]',' ');
   v_name2 := REGEXP_REPLACE(UPPER(p_name2), '[^0-9A-Za-z ]',' ');
   
   if v_name1 = v_name2 then
       v_return := 'Y';
   end if;

   return v_return;

   end same_name;   
   
end xwrl_name_utils;
/
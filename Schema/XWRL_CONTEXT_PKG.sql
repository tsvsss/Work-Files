select *
from all_context
;

xwrl_requests;

xwrl_utils;


drop context xwrl_ctx;
create context xwrl_ctx using xwrl_trg_ctx;


create or replace PACKAGE  apps.xwrl_trg_ctx IS

procedure disable_trg_ctx;

procedure enable_trg_ctx;

END xwrl_trg_ctx;
/

create or replace PACKAGE BODY   apps.xwrl_trg_ctx IS

procedure disable_trg_ctx IS

begin

DBMS_SESSION.SET_CONTEXT(
       'xwrl_ctx',
       'disable_trigger',
       'TRUE');
		
end disable_trg_ctx;

procedure enable_trg_ctx is

begin

DBMS_SESSION.CLEAR_CONTEXT('xwrl_ctx');

end enable_trg_ctx;

END xwrl_trg_ctx;
/

SELECT SYS_CONTEXT('xwrl_ctx', 'disable_trigger') FROM dual;


begin
xwrl_trg_ctx.disable_trg_ctx;
end;
/

begin
xwrl_trg_ctx.enable_trg_ctx;
end;
/

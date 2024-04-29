create  or replace type emp_type as object (
employee_id number(6),
first_name varchar2(20),
last_name varchar2(25));
/

create or replace type emp_type_t as table of emp_type;
/

create or replace package hr_pkg as
procedure p_get_employees (in_deptid in number, out_employees_rc out sys_refcursor);
procedure p_upd_employees(in_emps in emp_type_t, out_emps out emp_type_t);
end hr_pkg;
/

create or replace package body hr_pkg as
procedure p_get_employees (in_deptid in number, out_employees_rc out sys_refcursor) is
begin
open out_employees_rc for
select employee_id, first_name, last_name, email, salary
from employees
where department_id = decode(in_deptid, -1, department_id, in_deptid);
end p_get_employees;

procedure p_upd_employees(in_emps in emp_type_t, out_emps out emp_type_t) is
counter pls_integer := 1;
begin 
out_emps := emp_type_t();
for i in in_emps.first .. in_emps.last loop
out_emps.extend;
out_emps(counter) := emp_type(in_emps(i).employee_id + 5, in_emps(i).first_name || ' A', in_emps(i).last_name || ' B');
counter := counter +1;
end loop;
end p_upd_employees;
end hr_pkg;
/

SELECT *
FROm all_types
where  type_name = 'EMP_TYPE'
--and typecode = 'OBJECT'
;

SELECT *
FROm all_types
where  type_name = 'EMP_TYPE_T'
--and typecode = 'OBJECT'
;
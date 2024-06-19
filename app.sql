-- Clear Substitution Variables
UNDEFINE first
UNDEFINE last
UNDEFINE email
UNDEFINE phone
UNDEFINE date
UNDEFINE job_id
UNDEFINE salary
UNDEFINE commission
UNDEFINE mang_id
UNDEFINE dept_id
-- add user
DECLARE
    v_first employees.first_name%type := '&first';
    v_last employees.last_name%type := '&last';
    v_email employees.email%type := '&email';
    v_phone_number employees.phone_number%type := '&phone';
    v_hire_date employees.hire_date%type := '&date';
    v_job_id employees.job_id%type := '&job_id';
    v_salary employees.salary%type := '&salary';
    v_commission employees.commission_pct%type := '&commission';
    v_manager_id employees.manager_id%type := '&mang_id';
    v_department_id employees.department_id%type := '&dept_id';
BEGIN
    employee_pkg.add_emp(
        p_first => v_first,
        p_last => v_last,
        p_email => v_email,
        p_phone_number => v_phone_number,
        p_hire_date => v_hire_date,
        p_job_id => v_job_id,
        p_salary => v_salary,
        p_commission => v_commission,
        p_manager_id => v_manager_id,
        p_department_id => v_department_id
    );
    dbms_output.put_line('Added employee!');
end;
/
select * from employees where employee_id = 207;

-- update user
DECLARE
    v_emp_id employees.employee_id%type := '&emp_id';
    v_email2 employees.email%type := '&email2';
    v_job_id2 employees.job_id%type := '&job_id2';
    v_salary2 employees.salary%type := '&salary2';
    v_department_id2 employees.department_id%type := '&dept_id2';
BEGIN
    employee_pkg.update_emp(
        p_emp_id => v_emp_id,
        p_email => v_email2,
        p_job_id => v_job_id2,
        p_salary => v_salary2,
        p_department_id => v_department_id2
    );
    dbms_output.put_line('Updated employee!');
end;
/
select * from employees where employee_id = 207;
-- delete user
DECLARE
    v_emp_id employees.employee_id%type := '&emp_id2';
BEGIN
    employee_pkg.remove_emp(
        p_emp_id => v_emp_id
    );
    dbms_output.put_line('Removed employee!');
end;
/
select * from employees where employee_id = 207;
-- view all employees
select * from employees;
-- sort by department
-- ascending 
select * from employees order by department_id;
-- descending
select * from employees order by department_id desc;

-- sort by job
-- ascending 
select * from employees order by job_id;
-- descending
select * from employees order by job_id desc;

-- show highest earners in each department
select e1.first_name || ' ' || e1.last_name as "Name", e.salary as "Max salary", d.department_name
from employees e 
join (select department_id, max(salary) as max_salary
        from employees
        group by department_id
    ) max_salaries
on e.department_id = max_salaries.department_id and e.salary = max_salaries.max_salary
join employees e1 
on e1.employee_id = e.employee_id
join departments d
on d.department_id = e.department_id;

-- show count in each department
select d.department_name, count(*) as "Total employees"
    from employees e join departments d
    on d.department_id = e.department_id
    group by d.department_id, d.department_name
    order by "Total employees" desc;

-- show highest earners in each job
select e1.first_name || ' ' || e1.last_name as "Name", e.salary as "Max salary", e.job_id
from employees e 
join (select job_id, max(salary) as max_salary
        from employees
        group by job_id
    ) max_salaries
on e.job_id = max_salaries.job_id and e.salary = max_salaries.max_salary
join employees e1 
on e1.employee_id = e.employee_id;

-- show count in each job
select job_id, count(*) as "Total employees"
    from employees
    group by job_id
    order by count(*) desc;

create or replace package employee_pkg is 
    procedure add_emp(
        p_first in employees.first_name%type,
        p_last in employees.last_name%type,
        p_email in employees.email%type,
        p_phone_number in employees.phone_number%type,
        p_hire_date in employees.hire_date%type default sysdate,
        p_job_id in employees.job_id%type,
        p_salary in employees.salary%type default 0,
        p_commission in employees.commission_pct%type,
        p_manager_id in employees.manager_id%type,
        p_department_id in employees.department_id%type
    );

    procedure update_emp(
        p_emp_id in employees.employee_id%type,
        p_email in employees.email%type,
        p_job_id in employees.job_id%type,
        p_salary in employees.salary%type,
        p_department_id in employees.department_id%type
    );

    procedure remove_emp(
        p_emp_id in employees.employee_id%type
    );

end employee_pkg;
/
create or replace package body employee_pkg IS
    -- add emp to table
    procedure add_emp(
        p_first in employees.first_name%type,
        p_last in employees.last_name%type,
        p_email in employees.email%type,
        p_phone_number in employees.phone_number%type,
        p_hire_date in employees.hire_date%type default sysdate,
        p_job_id in employees.job_id%type,
        p_salary in employees.salary%type default 0,
        p_commission in employees.commission_pct%type,
        p_manager_id in employees.manager_id%type,
        p_department_id in employees.department_id%type
    ) IS
        v_emp_id employees.employee_id%type;
    begin
        if p_last is null or p_last = '' then 
            raise_application_error(-20001, 'Error: Last name cannot be null or empty');
        end if;
        
        if p_department_id is null then 
            raise_application_error(-20001, 'Error: Must belong to a department');
        end if;
        
        if p_job_id is null or p_job_id = '' then 
            raise_application_error(-20001, 'Error: Must have a job');
        end if;
        
        savepoint start_trans;
        
        -- find the next max emp id to insert into
        select nvl(max(employee_id), 0) + 1 into v_emp_id from employees;
        
        insert into employees(
            employee_id,
            first_name,
            last_name,
            email,
            phone_number,
            hire_date,
            job_id,
            salary,
            commission_pct,
            manager_id,
            department_id
        )
        values(
            v_emp_id, 
            p_first, 
            p_last,
            p_email,
            p_phone_number,
            p_hire_date,
            p_job_id,
            p_salary,
            p_commission,
            p_manager_id,
            p_department_id
        );
        
    exception
        when others then 
            rollback to start_trans;
            raise_application_error(-20003, 'Error: Failed to add employee');
    end add_emp;

    -- update emp info on emp_id
    procedure update_emp(
        p_emp_id in employees.employee_id%type,
        p_email in employees.email%type,
        p_job_id in employees.job_id%type,
        p_salary in employees.salary%type,
        p_department_id in employees.department_id%type
    ) is
    begin
        if p_department_id is null then 
            raise_application_error(-20001, 'Error: Must belong to a department');
        end if;
        
        if p_job_id is null or p_job_id = '' then 
            raise_application_error(-20001, 'Error: Must have a job');
        end if;
        
        savepoint start_trans;
        update employees
        set email = p_email, 
            job_id = p_job_id, 
            salary = p_salary, 
            department_id = p_department_id
        where employee_id = p_emp_id;
        
    exception
        when others then 
            rollback to start_trans;
            raise_application_error(-20003, 'Error: Failed to update employee');
    end update_emp;

    -- remove employee from table
    procedure remove_emp(
        p_emp_id in employees.employee_id%type
    ) is
    begin
        if p_emp_id is null then 
            raise_application_error(-20001, 'Error: Enter employee');
        end if;
        
        delete from employees
        where employee_id = p_emp_id;
    end remove_emp;

end employee_pkg;
/

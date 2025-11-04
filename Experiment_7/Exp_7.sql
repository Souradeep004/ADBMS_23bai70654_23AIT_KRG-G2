----------------EXPERIMENT 07----------------------------------

----------------------MEDIUM LEVEL PROBLEM----------------------------
--REQUIREMENTS: DESIGN A TRIGGER WHICH:
--1. WHENEVER THERE IS A INSERTION ON STUDENT TABLE THEN, THE CURRENTLY INSERTED OR DELETED 
--ROW SHOULD BE PRINTED AS IT AS ON THE OUTPUT CONSOLE WINDOW.


create table student(
	Name varchar(20),
	Uid smallint Primary Key,
	course char(4)
);



SET client_min_messages TO 'NOTICE';
SHOW client_min_messages;




delete from student;

insert into student values('Souradeep', 132, 'AIML'), 
						  ('Sukhi', 231, 'AIML'),
						  ('Palash', 332, 'WEBD'),
						  ('Aadhitya', 425, 'DATA'),
						  ('Aayush', 556, 'DATA');

select * from student;

create or replace function insert_del_statement()
returns trigger
language plpgsql
as
$$
	begin
		if TG_OP = 'INSERT' then
			raise notice 'Inserted rows:- %, %, %', new.Name, new.Uid, new.course;
			return new;
		elseif TG_OP = 'DELETE' then
			raise notice 'Deleted rows:- %, %, %', old.Name, old.Uid, old.course;
			return old;
		end if;

		return null;
	end;
$$
	
create or replace trigger trg_student
after insert or delete
on
student
for each row
execute function insert_del_statement();

insert into student values('Arka', 442, 'AIML'), ('Rohit', 390, 'WEBD');
delete from student where Uid = 442 or Uid = 390;
delete from student where Uid = 556;




----------------------HARD LEVEL PROBLEM----------------------------

/*
Requirements: DESIGN A PORSTGRESQL TRIGGERS THAT: 

Whenever a new employee is inserted in tbl_employee, a record should be added to tbl_employee_audit like:
"Employee name <emp_name> has been added at <current_time>"

Whenever an employee is deleted from tbl_employee, a record should be added to tbl_employee_audit like:
"Employee name <emp_name> has been deleted at <current_time>"

The solution must use PostgreSQL triggers.
*/



create table tbl_employee(
	emp_id int primary key,
	empName varchar(20),
	salary numeric
);


create table tbl_employee_audit(
	S_no serial primary key,
	logging text
);




SET client_min_messages TO 'NOTICE';




create or replace function func_employee()
returns trigger
language plpgsql
as
$$
	begin
		if TG_OP = 'DELETE' then
			insert into tbl_employee_audit(logging) values('Employee name ' || old.empName || 'has been deleted at ' || now());
			return old;
		elseif TG_OP = 'INSERT' then
			insert into tbl_employee_audit(logging) values('Employee name ' || new.empName || 'has been deleted at ' || now());
			return new; 
		end if;

		return null;
	end;
$$;

create or replace trigger trg_func_employee
after insert or delete
on tbl_employee
for each row
execute function func_employee();



insert into tbl_employee values(123, 'Souradeep', 120000.23),
							   (321, 'Sukhi', 2311123.00),
							   (424, 'Palash', 9800010);

delete from tbl_employee where emp_id = 123;


select * from tbl_employee_audit;























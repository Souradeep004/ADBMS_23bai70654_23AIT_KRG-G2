create database MyDbo;
go
use MyDbo;
go

/*
	MAIN OPERATORS:- QUERY-CONNECTORS
	1. =, >, <, <> / !=
	2. IN
	3. NOT IN
	4. ANY
	5. ALL

	TYPES OF SUB-QUERY:-
	1. SCALER SQ : Returns single value
				OP : =, <, >, <>/!=
	2. MULTI-VALUED SQ : Returns multiple rows
				OP : IN, NOT IN, ANY(OR), ALL(AND)
	3. SELF-CONTAINED SQ : SQ has no dependency on the Main/Outter Query.
	4. CO-RELATED SQ : SQ will be dependent on the Main/Outter Query.
					-- Use Alias with Co-Related SQ.
					-- Not much used due to overhead generation.

	SET OPERATIONS : UNIQUE ELEMENTS
	OPERATIONS:
		1. UNION : UNIQUE VALUES
		2. UNION ALL : UNIQUE + DUPLICATE
		3. INTERSECT (INNER JOIN)
		4. (A-B) : EXPECT (A BUT NOT B)



*/

select * from INFORMATION_SCHEMA.TABLES;


----------------------------[EMPLOYEES & DEPARTMENT]----------------------------------
CREATE TABLE department (
    id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Create Employee Table
CREATE TABLE employee (
    id INT,
    name VARCHAR(50),
    salary INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES department(id)
);
go

-- Insert into Department Table
INSERT INTO department (id, dept_name) VALUES
(1, 'IT'),
(2, 'SALES');
go

-- Insert into Employee Table
INSERT INTO employee (id, name, salary, department_id) VALUES
(1, 'JOE', 70000, 1),
(2, 'JIM', 90000, 1),
(3, 'HENRY', 80000, 2),
(4, 'SAM', 60000, 2),
(5, 'MAX', 90000, 1);
go


select d.dept_name, e.name, e.salary
	from employee e INNER JOIN department d on e.department_id = d.id
	where salary in 
	(
		select max(e2.salary)
			from employee e2 where e2.department_id = e.department_id
	) 
	order by d.dept_name;


select d.dept_name, e.name, e.salary
	from employee e INNER JOIN department d on e.department_id = d.id
	where salary in 
	(
		select max(e2.salary)
			from employee e2 group by e2.department_id
	) 
	order by d.dept_name;

-----------------------------------------------[ TAB_A & TAB_B]----------------------------------------

create table tab_a(
	EmpID int primary key,
	Ename varchar(5),
	Salary int
);
go

create table tab_b(
	EmpID int primary key,
	Ename varchar(5),
	Salary int
);
go

insert into tab_a values(1, 'AA', 1000), (2, 'BB', 300);
go

insert into tab_b values(2, 'BB', 400), (3, 'CC', 100);
go

/*
	SET OP with CTE
	columns with duplicate values similar to other columns, 
	have to be used together in the group-by or with aggregated functions.
*/

with res_set as 
(	select a.* from tab_a a
	UNION ALL
	select b.* from tab_b b
)
select EmpID, Ename, min(Salary) as Salary from res_set r
	group by EmpID, Ename;

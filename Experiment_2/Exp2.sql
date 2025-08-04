use Arka;

select * from INFORMATION_SCHEMA.TABLES;

/*
	TYPES OF JOIN :--
		1.INNER JOIN
		2.LEFT OUTTER JOIN
		3.RIGHT OUTTER JOIN
		4.SELF JOIN
		5.FULL OUTTER JOIN
		6.LEFT EXCLUSIVE JOIN
		7.RIGHT EXCLUSIVE JOIN

	ALIAS : TEMP NOMENCLATURE
	VIRTUAL TABLE OF 2 TABLES : CARTESIAN PRODUCT
*/


create table emp(
	empID int primary key,
	ename varchar(12),
	dept varchar(12),
	managerID int
)

insert into emp values(1, 'Alice', 'HR', NULL),
					   (2, 'Bob', 'Finance', 1),
					   (3, 'Charlie', 'IT', 1),
					   (4, 'David', 'Finance', 2),
					   (5, 'Eve', 'IT', 3),
					   (6, 'Frank', 'HR', 1);

-- SELF JOIN
select A.ename as EmployeeName, A.dept as EmployeeDept, E.ename as 'Manager Name', E.dept as ManagerDept
		from emp as A LEFT JOIN emp as E on E.empID = A.managerID;

-------------------------------------------------------------------------------------------------------------------

create table year_tbl(
	ID int,
	YEAR int,
	NPV int
)

create table queries_tbl(
	ID int,
	YEAR int
)

insert into year_tbl values(1, 2018, 100), (7, 2020, 30), (13, 2019, 40),
						   (1, 2019, 113), (2, 2008, 121), (3, 2009, 12),
						   (11, 2020, 99), (7, 2019, 0);

insert into queries_tbl values(1, 2019), (2, 2008), (3, 2009),
							  (7, 2018), (7, 2019), (7, 2020),
							  (13, 2019);

-- LEFT JOIN where missing replaced by 0
select Q.ID as ID, Q.YEAR as YEAR, ISNULL(Y.NPV,0) as NPV 
	from queries_tbl as Q LEFT OUTER JOIN year_tbl as Y on 
		Q.YEAR=Y.YEAR AND Q.ID = Y.ID;
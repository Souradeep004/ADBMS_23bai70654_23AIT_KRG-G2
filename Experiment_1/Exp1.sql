-- Creating a Database
create database db_data
alter database db_data modify name = db_personal
exec sp_renamedb db_books, Arka;
use Arka;

SELECT name, database_id, create_date
FROM sys.databases;
GO

-- Table author & book_table
create table author(
	AUTHOR_ID int primary key,
	AUTHOR_NAME varchar(20)
)
alter table author add COUNTRY varchar(20);

create table book_table(
	BOOK_ID int primary key identity(200,2),
	BOOK_NAME varchar(20),
	AUTHO_ID int
	foreign key(AUTHO_ID) references author(AUTHOR_ID)
)

/*
	Rename Table Name : exec sp_rename book_table, books;
	Rename Database : alter database db_data modify name = data_personal
	Rename columns : exec sp_rename 'book_table.BOOK_ID', 'book_table.ID', 'column';
*/


-- Operation into author
insert into author values(120, 'Ruskin Bond'), (130, 'Robert Greene'), (145, 'Dale Carnegie');
insert into author values(250, 'Robert Frost');
update author set COUNTRY = 'India' where AUTHOR_ID = 120;
update author set COUNTRY = 'USA' where AUTHOR_ID in (130, 145, 250);
select A.AUTHOR_ID as [Author Id], A.AUTHOR_NAME as 'Author Name', A.COUNTRY as 'Country' from author as A;
select * from author;
exec sp_help author;

-- Operation on book_table
insert into book_table(BOOK_NAME, AUTHO_ID) values('Influence', 145), ('Room on the Roof', 120), ('Blue Umbrella', 120), ('Human Nature', 130);
select B.BOOK_ID as [ID], B.BOOK_NAME as [Name], B.AUTHO_ID as [Author Id] from book_table as B


select B.BOOK_NAME as [Book Name], A.AUTHOR_NAME as [Author Name], A.COUNTRY as 'Country' 
	   from book_table as B INNER JOIN author as A 
	   on A.AUTHOR_ID = B.AUTHO_ID;

-- List of tables created
select * from sysobjects;
select * from sysobjects where type = 'U';
select name, id, crdate, refdate from sysobjects where xtype = 'U';
select * from INFORMATION_SCHEMA.TABLES;
select * from INFORMATION_SCHEMA.TABLES where TABLE_TYPE = 'BASE TABLE';


----------------------------------------------------------------------------------------------------------

create table dept(
	Dept_Id smallint PRIMARY KEY identity(201,3),
	Dept_Name varchar(12)
)

create table course(
	Dept smallint FOREIGN KEY references dept(Dept_Id),
	Course varchar(12)
)

exec sp_help course;

insert into dept(Dept_Name) values('AI&ML'), ('CSE'), ('Bio-Tech'), ('Finance'), ('Psychology');
select * from dept;

insert into course values(201, 'Data Science'), (201, 'Neural Net'), 
						 (207, 'Biology'), 
						 (204, 'Full Stacks'),
						 (210, 'Economics'), (210, 'Socio-Psycho'),
						 (213, 'Socio-Psycho'), (213, 'Psychology');
select * from course;

select C.Dept, C.Course, D.Dept_Name as [Department Name] from course as C FULL JOIN dept as D ON C.Dept = D.Dept_Id;

-- Count of Courses offered by various Dept
select D.Dept_Name as Department, D.Dept_Id, C.COUNT as 'COUNT' from dept as D INNER JOIN
	(select Dept, COUNT(Dept) as 'COUNT' from course group by Dept) as C on D.Dept_Id = C.Dept;

select D.Dept_Name as Department, D.Dept_Id from dept as D INNER JOIN
	(select Dept, COUNT(Dept) as 'COUNT' from course group by Dept) as C on D.Dept_Id = C.Dept
	where C.COUNT >= 2;


-- GRANT DCL Command
create login tt_login with password = '1234';
GO

create user tt_user for login tt_login;
GO

GRANT select on dbo.course to tt_user;
GO
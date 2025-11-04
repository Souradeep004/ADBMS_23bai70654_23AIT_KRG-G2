------------------------------Experiment 08-------------------------------
---------------------Hard Level Problem-----------------------------
/*
Design a robust PostgreSQL transaction system for the students table where multiple student 
records are inserted in a single transaction. 

If any insert fails due to invalid data, only that insert should be rolled back while preserving the 
previous successful inserts using savepoints. 

The system should provide clear messages for both successful and failed insertions, ensuring data integrity 
and controlled error handling.

HINT: YOU HAVE TO USE SAVEPOINTS
*/


select * from student;

select * from INFORMATION_SCHEMA.TABLES where table_name = 'student';




--to list the triggers associated with the table
SELECT 
    trigger_name,
    event_manipulation AS event,
    action_timing AS timing,
    action_statement AS trigger_function
FROM information_schema.triggers
WHERE event_object_table = 'student';

select * from INFORMATION_SCHEMA.TRIGGERS WHERE event_object_table = 'student';

drop trigger if exists trg_student on student;



select * from student;

begin transaction;
DO $$
	begin
		insert into student values('Aadi', 444, 'WEBD'),
								   ('Mahesh', 545, 'CYBE'),
								   ('Rohan', 090, 'CYBE');

		raise notice 'Insertion successful';

	exception 
		when others then
			raise notice 'Unhandled Exception : SQLSTATE % --- %', SQLSTATE, SQLERRM;

			raise;
	end;
$$

select * from student;

commit;




begin transaction;
DO $$
	begin
		insert into student values('Sambhav', 404, 'WEBD'),
								   ('Mahesh', 545, 'CYBE'), 	--Wrong insertion
								   ('Mahendra', 190, 'CYBE');

		raise notice 'Insertion successful';

	exception 
		when others then
			raise notice 'Unhandled Exception : SQLSTATE % --- %', SQLSTATE, SQLERRM;

			raise;
	end;
$$

rollback;

select * from student;

commit;




BEGIN TRANSACTION;

DO $$
DECLARE
    -- Define a record type to hold each row
    rec RECORD;
BEGIN
    -- Define the data you want to insert (can come from anywhere)
    FOR rec IN
        SELECT * FROM (VALUES
            ('Sambhav', 404, 'WEBD'),
            ('Mahesh', 545, 'CYBE'),   -- Duplicate row, will fail
            ('Mahendra', 190, 'CYBE')
        ) AS t(name, id, dept)
    LOOP
        BEGIN
            INSERT INTO student VALUES (rec.name, rec.id, rec.dept);
            RAISE NOTICE 'Inserted: % (% , %)', rec.name, rec.id, rec.dept;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Error inserting % (%): SQLSTATE % --- %',
                    rec.name, rec.id, SQLSTATE, SQLERRM;
                -- Skip this record, continue with the next one
        END;
    END LOOP;

    RAISE NOTICE 'All records processed.';
END;
$$;

COMMIT;

-- Check results
SELECT * FROM student;

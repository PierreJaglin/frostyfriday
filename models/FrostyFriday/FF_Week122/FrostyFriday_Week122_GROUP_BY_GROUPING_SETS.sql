use schema pjaglin_dwh.frostyfriday;
use role sysadmin;

CREATE TABLE student_enroll_info (
    student_id INT PRIMARY KEY,
    course VARCHAR(50),
    duration VARCHAR(50)
);

-- Step 2: Insert data into the table
INSERT INTO student_enroll_info (student_id, course, duration) VALUES
(1, 'CSE', 'Four Years'),
(2, 'EEE', 'Three Years'),
(3, 'CSE', 'Four Years'),
(4, 'MSC', 'Three Years'),
(5, 'BSC', 'Three Years'),
(6, 'Mech', 'Four Years');


-- How do you count the total number of students grouped by each course and duration separately?

SELECT 
    count(*)
    , course
    , duration
FROM
    student_enroll_info
GROUP BY GROUPING SETS (course, duration)
;

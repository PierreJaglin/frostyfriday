-- Set the database and schema
use role SYSADMIN;
use schema pjaglin_dwh.frostyfriday;

create or replace file format ff_csv_format
    type = CSV
    comment = 'csv_frosty_friday_format';

-- Create the stage that points at the data.
create stage week_11_frosty_stage
    url = 's3://frostyfridaychallenges/challenge_11/'
    file_format = ff_csv_format;

-- Create the table as a CTAS statement.
create or replace table frostyfriday.week11 as
select m.$1 as milking_datetime,
        m.$2 as cow_number,
        m.$3 as fat_percentage,
        m.$4 as farm_code,
        m.$5 as centrifuge_start_time,
        m.$6 as centrifuge_end_time,
        m.$7 as centrifuge_kwph,
        m.$8 as centrifuge_electricity_used,
        m.$9 as centrifuge_processing_time,
        m.$10 as task_used
from @week_11_frosty_stage (file_format => 'ff_csv_format', pattern => '.*milk_data.*[.]csv') m;

-- Test table create
SELECT * FROM week11;


-- TASK 1: Remove all the centrifuge dates and centrifuge kwph and replace them with NULLs WHERE fat = 3. 
-- Add note to task_used.
create or replace task whole_milk_updates
    schedule = '1400 minutes'
as
    UPDATE week11
    SET
        centrifuge_start_time = NULL
        ,centrifuge_end_time = NULL
        ,centrifuge_kwph = NULL
        , task_used = concat(
            SYSTEM$CURRENT_USER_TASK_NAME()
            , 'at '
            , CURRENT_TIMESTAMP::STRING
        )
    WHERE fat_percentage = 3
;
    


-- TASK 2: Calculate centrifuge processing time (difference between start and end time) WHERE fat != 3. 
-- Add note to task_used.
create or replace task skim_milk_updates
    after whole_milk_updates
as
    update week11
    set
        centrifuge_processing_time = TIMESTAMPDIFF(
            minute
            , centrifuge_start_time
            , centrifuge_end_time
        )
        , task_used = concat(
            SYSTEM$CURRENT_USER_TASK_NAME()
            , 'at '
            , CURRENT_TIMESTAMP::STRING
        )
    where fat_percentage = 3
;

-- Enable all tasks
select system$task_dependents_enable('WHOLE_MILK_UPDATES');

-- Manually execute the task.
execute task WHOLE_MILK_UPDATES;

-- Check that the data looks as it should.
select * from week11;

-- Check that the numbers are correct.
select task_used, count(*) as row_count from week11 group by task_used;

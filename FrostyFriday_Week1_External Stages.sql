-- Set SYSADMIN role
use role SYSADMIN

-- Define warehouse, database, schema
create or replace warehouse PJAGLIN_WH AUTO_SUSPEND=1;
create or replace database PJAGLIN_DWH;
create or replace schema PJAGLIN_DWH.FF_WEEK1;

-- Create S3 External Stage
CREATE STAGE PJAGLIN_DWH.FF_WEEK1.ff_week1_s3
    URL = 's3://frostyfridaychallenges/challenge_1/'
;


list @ff_week1_s3;

-- File format CSV
create or replace file format ff_week1_ff_csv
    type = csv
    skip_header = 1
    null_if = ('NULL', 'totally_empty')
    skip_blank_lines = true
;

--SELECT $1, metadata$filename, metadata$file_row_number FROM @ff_week1_s3 (file_format=>'ff_week1_ff_csv');

-- create destination table of S3 stage
create or replace table ff_week1_csv(
    result varchar,
    filename varchar,
    file_row_number int,
    loaded_at timestamp_ltz
);

-- Copy file using file format
copy into ff_week1_csv from(
    select 
        $1,
        metadata$filename,
        metadata$file_row_number, 
        metadata$start_scan_time
    from @ff_week1_s3)
    file_format = (format_name ='ff_week1_ff_csv');

-- delete the NULL row
delete from ff_week1_csv where result is null;

-- Final result

SELECT * FROM ff_week1_csv order by filename, file_row_number;

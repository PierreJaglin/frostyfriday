-- Set SYSADMIN role
use role SYSADMIN;

-- SET WH / Database / Schema /
use warehouse PJAGLIN_WH;
use database PJAGLIN_DWH;
create or replace schema PJAGLIN_DWH.FF_WEEK3;

-- Create External Stage : S3
create or replace stage ff_week3_s3
    URL = 's3://frostyfridaychallenges/challenge_3/'
;

list @ff_week3_s3;

-- Create File Format
create or replace file format ff_week3_ff
    TYPE = csv
    SKIP_HEADER = 1
;


-- Create table with only the file whom need to be tracked
create or replace table ff_week3_csv_tracked as
    SELECT 
        metadata$filename,
        count(metadata$file_row_number) as NUMBER_OF_ROWS
    FROM 
        @ff_week3_s3 main
    WHERE
        EXISTS(
            SELECT 1 
            FROM @ff_week3_s3/keywords.csv (file_format => 'ff_week3_ff') AS sub
            WHERE CONTAINS(SPLIT_PART(SPLIT_PART(main.metadata$filename, '/', -1), '.', 1), sub.$1)
        )
    GROUP BY 
        metadata$filename
;


select * from ff_week3_csv_tracked;

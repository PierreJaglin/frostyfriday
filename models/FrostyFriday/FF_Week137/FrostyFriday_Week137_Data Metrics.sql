--Set Environnement

use role sysadmin;
use schema PJAGLIN_DWH.FROSTYFRIDAY;

create or replace stage week137_stage
    url='s3://frostyfridaychallenges/challenge_137/';

create or replace file format frosty_csv
    type = csv
    skip_header = 1
;

create or replace table week137 as
select 
    $1::int AS sale_id,
    $2 AS customer_name,
    $3 AS product,
    $4::int AS quantity,
    $5::float AS unit_price,
    date($6::string, 'DD/MM/YYYY') AS sale_date,
    $7::float AS total_amount
from 
    @week137_stage (file_format=>frosty_csv)
;


--NULL_COUNT ON SALE_ID
SELECT SNOWFLAKE.CORE.NULL_COUNT(
    SELECT 
        SALE_ID
    FROM week137
)   as TEST;

CREATE OR REPLACE DATA METRIC FUNCTION total_amount_check (
    week137 TABLE(
        total_amount FLOAT,
        quantity INT,
        unit_price FLOAT
    )
)
RETURNS NUMBER
AS 
$$
    SELECT 
        COUNT(*)
    FROM
        week137
    WHERE 
        total_amount <> quantity * unit_price
$$;

SELECT total_amount_check(
    SELECT total_amount,quantity,unit_price
    FROM week137
) as BAD_MATHS;

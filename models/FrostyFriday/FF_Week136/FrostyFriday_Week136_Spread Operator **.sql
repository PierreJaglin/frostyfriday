-- Param Env
use schema pjaglin_dwh.frostyfriday;
use role SYSADMIN;

-- Setup Script
-- Step 1: Create the seeds table 🌸🌿
CREATE OR REPLACE TABLE seed_packs (
    gardener STRING,
    seeds ARRAY
);

-- Step 2: Insert your spring options🌼🌼
INSERT INTO seed_packs 
SELECT 'Luna', ARRAY_CONSTRUCT(5, 10, 15)
UNION ALL
SELECT 'Sol', ARRAY_CONSTRUCT(7, 8, 9)
UNION ALL
SELECT 'Anna', ARRAY_CONSTRUCT(4, 12, 18)
UNION ALL
SELECT 'Daniel', ARRAY_CONSTRUCT(6, 8, 2);


-- Compute the total weight of ther custom mixes. 
-- Using the spread operator ** to pass array values directly into a function🌿

-- With Flatten
SELECT 
    GARDENER,
    SUM(value::NUMBER) as total_weight
FROM 
    seed_packs,
LATERAL FLATTEN(input => seeds)
GROUP BY GARDENER;



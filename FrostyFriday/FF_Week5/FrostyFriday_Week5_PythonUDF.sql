-- Create simple table value

create or replace table ff_week5 (
    value int
);

-- Insert value into 
insert into ff_week5 values (5);

-- check the insert
select * from ff_week5;

-- create the function timesthree
/*
    Take a number en multiply those number by 3

    Args:
        number: Number which is gonna be multiply

    Return:
        The number multiply by 3
    
*/
create or replace function timesthree(value int)
    returns int
    language python
    runtime_version = '3.11'
    handler = 'timesthree'
AS $$
def timesthree(value):
    return value*3
$$;

SELECT 
    timesthree(value),
    value
FROM
    ff_week5
;

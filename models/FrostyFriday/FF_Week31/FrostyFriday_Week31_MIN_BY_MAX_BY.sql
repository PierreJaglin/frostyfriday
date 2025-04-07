-- Set env
use schema pjaglin_dwh.frostyfriday;
use role sysadmin;

-- Init Code
create or replace table w31(id int, hero_name string, villains_defeated number);

insert into w31 values
  (1, 'Pigman', 5),
  (2, 'The OX', 10),
  (3, 'Zaranine', 4),
  (4, 'Frostus', 8),
  (5, 'Fridayus', 1),
  (6, 'SheFrost', 13),
  (7, 'Dezzin', 2.3),
  (8, 'Orn', 7),   
  (9, 'Killder', 6),   
  (10, 'PolarBeast', 11)
  ;

--Frosty Friday’s super academy wants to know who their best and worst super heroes are, and the only metric that matters is villains defeated. Using MIN_BY and MAX_BY, tell us which super hero is the best, and which is the worst.

SELECT 
    MAX_BY(hero_name,villains_defeated)   AS BEST_HERO,
    MIN_BY(hero_name,villains_defeated)   as WORST_HERO 
FROM w31;

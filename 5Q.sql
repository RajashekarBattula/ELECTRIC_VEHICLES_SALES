/* HOW DO THE EV SALES AND PENETRATION RATES IN DELHI COMPARE TO KARNATAKA FOR 2024? */
select * from sales_by_makers ;
select * from sales_by_states;

select STATE, ELECTRIC_VEHICLES_SOLD, concat(round((ELECTRIC_VEHICLES_SOLD/TOTAL_VEHICLES_SOLD)*100,2),"%") as PENETRATION_RATE 
from (
select STATE, sum(ELECTRIC_VEHICLES_SOLD) as ELECTRIC_VEHICLES_SOLD, sum(TOTAL_VEHICLES_SOLD) as TOTAL_VEHICLES_SOLD
from SALES_BY_STATES 
where STATE = "DELHI" ) t1
union
select STATE, ELECTRIC_VEHICLES_SOLD, concat(round((ELECTRIC_VEHICLES_SOLD/TOTAL_VEHICLES_SOLD)*100,2),"%") as PENETRATION_RATE
from (
select STATE , SUM(ELECTRIC_VEHICLES_SOLD) as ELECTRIC_VEHICLES_SOLD, sum(TOTAL_VEHICLES_SOLD) as TOTAL_VEHICLES_SOLD
from SALES_BY_STATES
where state = "Karnataka") t1;




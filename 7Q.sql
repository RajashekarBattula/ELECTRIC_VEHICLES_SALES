/* LIST DOWN THE TOP 10 STATES THAT HAD THE HIGHEST COMPOUNDED ANNUAL GROWTH RATE (CAGR) FROM 2022 TO 2024 IN TOTAL VEHICLES SOLD.*/ 
select * from sales_by_states;

with sales_2022 as (
select STATE, SUM(TOTAL_VEHICLES_SOLD) as TOTAL_VEHICLES_SOLD 
from sales_by_states 
where year(dates) = 2022
group by STATE
),

sales_2024 as (
select STATE, SUM(TOTAL_VEHICLES_SOLD) as TOTAL_VEHICLES_SOLD 
from sales_by_states 
where year(dates) = 2024
group by STATE
)
select s2.STATE, concat(round(power((s4.TOTAL_VEHICLES_SOLD/s2.TOTAL_VEHICLES_SOLD),1/2),2),"%") CAGR 
from sales_2022 as s2 inner join sales_2024 as s4 on s2.STATE = s4.STATE 
order by CAGR desc limit 10;

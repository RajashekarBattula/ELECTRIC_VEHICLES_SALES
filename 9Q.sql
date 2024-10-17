/* What is the projected number of EV sales (including 2-wheelers and 4
wheelers) for the top 10 states by penetration rate in 2030 */
select * from SALES_BY_STATES;

select state, (Ev_sales*(round((Ev_sales/Total_sales)*100,0))*5) as PROJECTED_SALES, 
concat(round((Ev_sales/Total_sales)*100,2),"%") as PENETRATION_RATE
from (
select state ,sum(ELECTRIC_VEHICLES_SOLD) Ev_sales, sum(TOTAL_VEHICLES_SOLD) Total_sales 
from SALES_BY_STATES
group by state
) t1 
order by PENETRATION_RATE 
desc 
limit 10;


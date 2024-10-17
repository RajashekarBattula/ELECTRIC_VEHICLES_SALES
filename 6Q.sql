/* LIST DOWN THE COMPOUNDED ANNUAL GROWTH RATE (CAGR) IN 4-WHEELER UNITS FOR THE TOP 5 MAKERS FROM 2022 TO 2024 */
select * from sales_by_makers ;
select * from sales_by_states;
with SALES_2022 as (
select MAKER,sum(VEHICLE_SOLD) AS TOTAL_VEHICLE_SOLD 
from SALES_BY_MAKERS 
where Vehicle_Category = '4-Wheelers' and year(dates) = 2022
GROUP BY MAKER order by TOTAL_VEHICLE_SOLD desc limit 5
),
 Sales_2024 as (
select MAKER, sum(VEHICLE_SOLD) as TOTAL_VEHICLE_SOLD 
from SALES_BY_MAKERS
where VEHICLE_CATEGORY = '4-Wheelers' and year(dates) = 2024
group by MAKER order by TOTAL_VEHICLE_SOLD desc limit 5
)
select s2.MAKER, concat(round(power((s4.TOTAL_VEHICLE_SOLD/s2.TOTAL_VEHICLE_SOLD),1/2)-1,2),"%") as CAGR 
from sales_2022 as s2 inner join sales_2024 s4 on s2.MAKER = s4.MAKER
order by CAGR desc ;

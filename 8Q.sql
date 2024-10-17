 /* WHAT ARE THE PEAK AND LOW SEASON MONTHS FOR EV SALES BASED ON THE DATA FROM 2022 TO 2024? */
select * from sales_by_states;

select case 
when months = "June" then "Low_Sale" 
else "High_sale" end as STATUS, Months, Ev_sales from (
select Months,Ev_sales from (
select *,dense_rank() over(order by Ev_sales ) rnk 
from (
select monthname(dates) as Months,sum(ELECTRIC_VEHICLES_SOLD) as Ev_sales
from  sales_by_states
group by Months ) t1
) t2 
where rnk = 1 
union
select Months,Ev_sales from (
select *,dense_rank() over(order by Ev_sales desc) rnk from (
select monthname(dates) as Months,sum(ELECTRIC_VEHICLES_SOLD) as Ev_sales from  sales_by_states
group by Months ) t1
) t2 
where rnk = 1
) t3;


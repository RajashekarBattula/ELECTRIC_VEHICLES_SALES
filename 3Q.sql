use ev_motors;
/*  LIST THE STATES WITH NEGATIVE PENETRATION (DECLINE) IN EV SALES FROM 2022 TO 2024?  */

select * from sales_by_makers;
select * from sales_by_states;
select * from dim_dates;

WITH sales_2022 AS (
SELECT state, CONCAT(ROUND((ev_sales_2022/total_sales_2022)*100,2),"%") AS penetrate_rate_2022 FROM (
SELECT state,sum(electric_vehicles_sold) as ev_sales_2022, SUM(total_vehicles_sold) AS total_sales_2022 from sales_by_states
WHERE YEAR(DATES) = 2022
GROUP BY state) T
),
sales_2024 AS (
SELECT state, CONCAT(ROUND((ev_sales_2024/total_sales_2024)*100,2),"%") AS penetrate_rate_2024 FROM (
SELECT state, sum(electric_vehicles_sold) as ev_sales_2024,SUM(total_vehicles_sold) AS total_sales_2024  from sales_by_states
WHERE YEAR(dates) = 2024
GROUP BY state ) T
)
SELECT T1.state , T1.penetrate_rate_2022  FROM sales_2022 T1 INNER JOIN sales_2024 T2 
ON  T1.state = T2.state  AND T1.penetrate_rate_2022 > T2.penetrate_rate_2024;
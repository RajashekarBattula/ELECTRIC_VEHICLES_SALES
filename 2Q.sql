/* IDENTIFY THE TOP 5 STATES WITH THE HIGHEST PENETRATION RATE IN 2-WHEELER AND 4-WHEELER EV SALES IN FY 2024. */
select * from sales_by_makers;
select * from sales_by_states;
select * from dim_dates;

WITH sales AS (
SELECT DISTINCT state,sum(electric_vehicles_sold) AS electric_vehicles_sold ,SUM(total_vehicles_sold) AS total_vehicles_sold
FROM sales_by_states
WHERE vehicle_category = "2-wheelers" AND YEAR(dates) = 2024
GROUP BY state order by total_vehicles_sold DESC ),
rate as (
SELECT state,concat(round((electric_vehicles_sold/total_vehicles_sold)*100,2),"%") AS penetration_rate 
FROM sales  
ORDER BY penetration_rate DESC
)
SELECT * FROM rate ORDER BY penetration_rate DESC LIMIT 5;


WITH sales as (
SELECT DISTINCT state, sum(electric_vehicles_sold) AS electric_vehicles_sold, sum(total_vehicles_sold) AS total_vehicles_sold
FROM sales_by_states
WHERE vehicle_category = "4-wheelers" AND YEAR(DATES) = 2024
GROUP BY STATE 
),
rate AS (
SELECT state,concat(round((electric_vehicles_sold/total_vehicles_sold)*100,2),"%") AS penetration_rate,DENSE_RANK() OVER(ORDER BY
concat(round((electric_vehicles_sold/total_vehicles_sold)*100,2),"%")DESC ) RNK 
FROM SALES 
)
SELECT state,penetration_rate FROM rate
WHERE rnk IN (1,2,3,4,5);

-- (1Q) LIST THE TOP 3 AND BOTTOM 3 MAKERS FOR THE FISCAL YEARS 2023 AND 2024 IN TERMS OF THE NUMBER OF 2-WHEELERS SOLD. 
select * from sales_by_makers;
select * from sales_by_states;

SELECT DISTINCT maker ,SUM(vehicle_sold) AS total_vehicles_sold 
FROM sales_by_makers 
WHERE Vehicle_Category = "2-Wheelers" AND YEAR(DATES) = 2024
GROUP BY maker 
ORDER BY total_vehicles_sold DESC LIMIT 3;

SELECT DISTINCT maker, sum(vehicle_sold) as total_vehicles_sold 
FROM sales_by_makers 
WHERE Vehicle_Category = "2-wheelers" AND YEAR(dates) = 2024
GROUP BY maker ORDER BY total_vehicles_sold LIMIT 3;


SELECT maker,total_vehicle_sold FROM (
SELECT DISTINCT maker, sum(vehicle_sold) as total_vehicle_sold, DENSE_RANK() OVER(ORDER BY sum(vehicle_sold) DESC ) as RNK
FROM sales_by_makers
WHERE Vehicle_Category = "2-wheelers"  AND YEAR(DATES) = 2023
GROUP BY maker ) T1
WHERE RNK IN (1,2,3);

SELECT maker,total_vehicle_sold 
FROM (
SELECT DISTINCT maker,sum(vehicle_sold) AS total_vehicle_sold  ,DENSE_RANK() OVER(ORDER BY sum(vehicle_sold) ) AS RNK
FROM sales_by_makers
WHERE Vehicle_Category = "2-wheelers" AND YEAR(dates) = 2023
GROUP BY maker
) T1
WHERE RNK IN (1,2,3);



-- (2Q) IDENTIFY THE TOP 5 STATES WITH THE HIGHEST PENETRATION RATE IN 2-WHEELER AND 4-WHEELER EV SALES IN FY 2024.
select * from sales_by_states;
select * from sales_by_makers;

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


-- (3Q) LIST THE STATES WITH NEGATIVE PENETRATION (DECLINE) IN EV SALES FROM 2022 TO 2024?  
select * from sales_by_makers;
select * from sales_by_states;
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
SELECT T1.state , T1.penetrate_rate_2022 AS penetrate_rate  FROM sales_2022 T1 INNER JOIN sales_2024 T2 
ON  T1.state = T2.state  AND T1.penetrate_rate_2022 > T2.penetrate_rate_2024;



-- (4Q) WHAT ARE THE QUARTERLY TRENDS BASED ON SALES VOLUME FOR THE TOP 5 EV MAKERS (4-WHEELERS) FROM 2022 TO 2024?
select * from sales_by_makers ;
select * from sales_by_states;

WITH quartely_trend AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY QT_2022 ORDER BY Ev_vehicle_sold DESC)  AS top_5 FROM (
SELECT CONCAT("Q",quarter(dates)) AS QT_2022, maker, SUM(vehicle_sold) AS Ev_vehicle_sold
FROM sales_by_makers
WHERE YEAR(dates) = 2022 AND Vehicle_Category = '4-Wheelers'
GROUP BY QT_2022, maker
ORDER BY QT_2022, Ev_vehicle_sold DESC 
) T1)
SELECT Maker, QT_2022, Ev_vehicle_sold FROM quartely_trend WHERE top_5 IN (1,2,3,4,5);

WITH quartely_trend AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY QT_2024 ORDER BY Ev_vehicle_sold DESC ) RNK FROM (
SELECT CONCAT("Q",QUARTER(dates)) AS Qt_2024, Maker,sum(vehicle_sold) as Ev_vehicle_sold
FROM sales_by_makers 
WHERE YEAR(dates)= 2024 AND vehicle_category = '4-Wheelers'
GROUP BY Qt_2024,Maker ) T1 )
SELECT Maker,Qt_2024,Ev_vehicle_sold FROM quartely_trend WHERE RNK IN (1,2,3,4,5);


-- (5Q) HOW DO THE EV SALES AND PENETRATION RATES IN DELHI COMPARE TO KARNATAKA FOR 2024? 
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


-- (6Q) LIST DOWN THE COMPOUNDED ANNUAL GROWTH RATE (CAGR) IN 4-WHEELER UNITS FOR THE TOP 5 MAKERS FROM 2022 TO 2024 
select * from sales_by_makers ;

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


-- (7Q) LIST DOWN THE TOP 10 STATES THAT HAD THE HIGHEST COMPOUNDED ANNUAL GROWTH RATE (CAGR) FROM 2022 TO 2024 IN TOTAL VEHICLES SOLD? 
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


 -- (8Q) WHAT ARE THE PEAK AND LOW SEASON MONTHS FOR EV SALES BASED ON THE DATA FROM 2022 TO 2024?
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


-- (9Q) What is the projected number of EV sales(including 2-wheelers and 4-wheelers) for top 10 states by penetration rate in 2030
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


-- (10Q) TOTAL EV_SALES 
select * from sales_by_states;
select sum(ELECTRIC_VEHICLES_SOLD) as  EV_SALES from sales_by_states;


-- (11Q) TOTALS_VEHICLES_SOLD 
select * from sales_by_states;

select sum(TOTAL_VEHICLES_SOLD) AS TOTALS_VEHICLES_SOLD from SALES_BY_STATES;


-- (12Q)  YEAR WISE SALES OF EV-VEHICLES (2-WHEELER, 4-WHEELERS ) 
select * from sales_by_states;

WITH Wheelers_2 AS (
SELECT YEAR(DATES) AS YEARS, SUM(ELECTRIC_VEHICLES_SOLD) Wheelers_2_SALES
FROM SALES_BY_STATES 
WHERE VEHICLE_CATEGORY = "2-Wheelers"
GROUP BY YEARS 
),
Wheelers_4 AS (
SELECT YEAR(DATES) AS YEARS, SUM(ELECTRIC_VEHICLES_SOLD) Wheelers_4_SALES 
FROM SALES_BY_STATES 
WHERE VEHICLE_CATEGORY = "4-Wheelers"
GROUP BY YEARS
)
SELECT W2.YEARS, W2.Wheelers_2_SALES, W4.Wheelers_4_SALES 
FROM Wheelers_2 W2 INNER JOIN Wheelers_4 W4
ON W2.YEARS = W4.YEARS;

-- (13Q) TOTAL SALES OF 2 WHEELERS AND 4 WHEELERS */

SELECT * FROM sales_by_states;
select * from sales_by_makers;

SELECT SUM(ELECTRIC_VEHICLES_SOLD) AS TOTAL_EV_SALES_IN_2_WHEELER FROM SALES_BY_STATES 
WHERE VEHICLE_CATEGORY = '2-Wheelers';

SELECT SUM(ELECTRIC_VEHICLES_SOLD) AS TOTAL_EV_SALES_IN_4_WHEELER FROM SALES_BY_STATES 
WHERE VEHICLE_CATEGORY = '4-Wheelers';





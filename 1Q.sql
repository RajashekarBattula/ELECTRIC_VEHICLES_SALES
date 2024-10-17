/* LIST THE TOP 3 AND BOTTOM 3 MAKERS FOR THE FISCAL YEARS 2023 AND 2024 IN TERMS OF THE NUMBER OF 2-WHEELERS SOLD. */
select * from sales_by_makers;
select * from sales_by_states;
select * from dim_dates;

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



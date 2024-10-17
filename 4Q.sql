/* WHAT ARE THE QUARTERLY TRENDS BASED ON SALES VOLUME FOR THE TOP 5 EV MAKERS (4-WHEELERS) FROM 2022 TO 2024? */

select * from sales_by_makers ;
select * from sales_by_states;
select * from dim_dates;

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

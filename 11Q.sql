/* TOTALS_VEHICLES_SOLD */

select * from sales_by_states;
select sum(TOTAL_VEHICLES_SOLD) AS TOTALS_VEHICLES_SOLD from SALES_BY_STATES;
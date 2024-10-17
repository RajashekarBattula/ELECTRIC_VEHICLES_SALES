/* TOTAL EV_SALES */
select * from sales_by_states;

select sum( ELECTRIC_VEHICLES_SOLD) as  EV_SALES from sales_by_states;

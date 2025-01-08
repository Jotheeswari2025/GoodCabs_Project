with cte as (SELECT city_name, monthname(month) as month_name, sum(repeat_passengers) as RepeatPassengers, sum(total_passengers) as TotalPassengers, 
concat(round(sum(repeat_passengers)/sum(total_passengers)*100,2), "%") as monthly_repeat_passenger_rate FROM trips_db.fact_passenger_summary ps
join dim_city c ON c.city_id = ps.city_id
group by city_name, month_name),
citywise as (select city_name,
concat(round(sum(Repeatpassengers)/sum(TotalPassengers)*100,2),"%") as city_repeat_passenger_rate FROM cte
group by city_name)
SELECT ce.city_name, ce.month_name, ce.TotalPassengers, ce.RepeatPassengers, ce.monthly_repeat_passenger_rate, ct.city_repeat_passenger_rate FROM cte ce
join citywise ct ON ce.city_name = ct.city_name

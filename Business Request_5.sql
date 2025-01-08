with cte as (SELECT ft.city_id,  city_name, sum(fare_amount) as Revenue_per_city FROM trips_db.fact_trips ft
join dim_city c ON c.city_id = ft.city_id
group by ft.city_id,  city_name),
Revenue_city_month as (select ft.city_id, city_name, monthname(date) as month_name, sum(fare_amount) as Revenue_per_month FROM trips_db.fact_trips ft
join dim_city c ON c.city_id = ft.city_id
group by ft.city_id,  city_name, month_name),
rank_month as (select city_name, month_name, 
max(revenue_per_month) OVER(partition by city_name, month_name) as Revenue, 
RANK() OVER( partition by city_name order by Revenue_per_month desc) as rank_mon FROM Revenue_city_month)
SELECT cte.city_name, month_name, Revenue, concat(round(Revenue/Revenue_per_city*100,2),"%") as percentage_contribution FROM rank_month
join cte on cte.city_name = rank_month.city_name
where rank_mon = 1

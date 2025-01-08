with newpassengers as (SELECT city_name, SUM(new_passengers) as total_new_passengers FROM trips_db.fact_passenger_summary ps
join dim_city c ON c.city_id = ps.city_id
group by city_name),
Rnk as (
SELECT *, dense_rank() OVER(order by total_new_passengers asc) as bottom,
	dense_rank() OVER(order by total_new_passengers desc) as Top From newpassengers)
    SELECT city_name, total_new_passengers, concat("bottom city",bottom) as city_category from Rnk
    Where bottom <=3
    Union all
        SELECT city_name, total_new_passengers, concat("Top city", top) as city_category from Rnk
    Where Top <=3
    order by city_category

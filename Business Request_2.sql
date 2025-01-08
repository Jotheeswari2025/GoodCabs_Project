with Actual_Trips as (
SELECT f.city_id, city_name, monthname(date) as month_name, count(trip_id) as ActualTrips FROM trips_db.fact_trips f
join dim_city c ON c.city_id = f.city_id
GROUP BY f.city_id, c.city_name, month_name),
Target_Trip as 
	(SELECT city_name, 
    month_name, 
    ActualTrips, 
    total_target_trips as TargetTrips FROM Actual_Trips atp
	join targets_db.monthly_target_trips mtp ON mtp.city_id = atp.city_id
and monthname(mtp.month) = atp.month_name)
SELECT city_name, month_name, ActualTrips, TargetTrips,
case
WHEN ActualTrips > TargetTrips THEN "Above Target"
WHEN ActualTrips <= TargetTrips THEN "Below Target"
END as performance_status,
 concat(round(((ActualTrips-TargetTrips)/TargetTrips)*100,2), "%") as percentage_difference
 FROM Target_Trip
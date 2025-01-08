with cte as (SELECT city_name, month, dr.city_id, trip_count,
SUM(repeat_passenger_count) OVER(partition by city_name) as total_repeat_passenger_by_city,
SUM(repeat_passenger_count) OVER(partition by trip_count, month, dr.city_id) as trips
FROM trips_db.dim_repeat_trip_distribution dr
JOIN dim_city c ON c.city_id = dr.city_id),
Repeatfrequency as(
select city_name, trip_count, total_repeat_passenger_by_city, sum(trips) OVER(partition by trip_count, city_name) as repeat_passengers FROM cte),
FrequencyTrips as(
select city_name, trip_count, concat(round(repeat_passengers/total_repeat_passenger_by_city*100,2), "%") as frequency FROM repeatfrequency)
SELECT 
		city_name,
		MAX(CASE WHEN trip_count = 2 THEN frequency END) AS "2-Trips",
		MAX(CASE WHEN trip_count = 3 THEN frequency END) AS "3-Trips",
		MAX(CASE WHEN trip_count = 4 THEN frequency END) AS "4-Trips",
		MAX(CASE WHEN trip_count = 5 THEN frequency END) AS "5-Trips",
		MAX(CASE WHEN trip_count = 6 THEN frequency END) AS "6-Trips",
		MAX(CASE WHEN trip_count = 7 THEN frequency END) AS "7-Trips",
		MAX(CASE WHEN trip_count = 8 THEN frequency END) AS "8-Trips",
		MAX(CASE WHEN trip_count = 9 THEN frequency END) AS "9-Trips",
		MAX(CASE WHEN trip_count = 10 THEN frequency END) AS "10-Trips"
		FROM 
		FrequencyTrips
		GROUP BY 
		city_name
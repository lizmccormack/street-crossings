# Street Crossings

This exercise was intended to use SQL database queries to determine which side of the street a ride-sharing car is on and if the passenger meeting the car would need to cross the street. The queries correspond to the following questions: 

The city planner is interested in what side of the street drivers are on when they pick passengers up.
Using the fields in the tables provided below, write a SQL query that creates a new table with the
following fields:
a. ride_id
b. picked_up_at
c. pickup_lat
d. pickup_lng
e. pickup_heading (approximation of degrees relative to true north the vehicle is facing during
pickup)

Next, build a table in SQL that uses your new `pickup_heading` metric to create another metric,
‘side_of_street’, that describes the side of the street the driver is on. The output on this field should
have eight possible values: ‘N’, ‘NE’, ‘E’, ‘SE’, ‘S’, ‘SW’, ‘W’, ‘NW’. For the sake of this exercise we will
assume all streets are two-way streets and that drivers are driving straight into their pickups and not
backing in or turning perpendicular to the road.

Next, we want to guess at whether a passenger had to cross a street in order to get picked up.
Use the available tables to write a query that contains the boolean field `crossed_street` that
describes whether you think the passenger needed to cross the street in order to be picked up.


## Tables
_public.fact_driver_locations_
* driver_id BIGINT, Unique identifier for a driver
* driver_lat DOUBLE, Latitude of driver location
* driver_lng DOUBLE, Longitude of driver location
* occurred_at_10s TIMESTAMP, UTC timestamp that increases in 10 second increments.


_public.fact_ride_pickups_
* driver_id BIGINT, Unique identifier for the driver
* passenger_id BIGINT, Unique identifier for the requesting passenger
* ride_id BIGINT, Unique identifier for a ride that was completed by the driver
* wait_time DOUBLE, Seconds between picked_up_at and requested_at
* ride_type STRING, Ride mode, eg standard, line, plus, etc
* request_lat DOUBLE, Latitude of passenger at time of ride request
* request_lng DOUBLE, Longitude of passenger at time of ride request
* requested_at TIMESTAMP, UTC Timestamp at time of ride request
* pickup_lat DOUBLE, Latitude of driver location at time of pickup event
* pickup_lng DOUBLE, Longitude of driver location at time of pickup event
* picked_up_at TIMESTAMP, UTC Timestamp of pickup event

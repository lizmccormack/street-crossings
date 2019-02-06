CREATE TABLE pickup_info
    SELECT
    ride_id,
    picked_up_at,
    pickup_lat,
    pickup_lng,
    (
        SELECT ((ATAN2((SIN(rp.pickup_lng - dl.driver_lng ) * COS(rp.pickup_lat)),
            (COS(dl.driver_lat)*SIN(rp.pickup_lat) -
            SIN(dl.driver_lat) * COS(rp.pickup_lat)*COS(rp.pickup_lng - dl.driver_lng))) * 180/PI) + 360) % 360
        FROM fact_ride_pickups rp
        JOIN fact_driver_locations dl ON rp.driver_id = dl.driver_id
    ) AS pickup_heading
    FROM fact_ride_pickups


CREATE TABLE driver_passenger_location
   SELECT
   pickup_heading,
   CASE pickup_heading
      WHEN 22.5 <= pickup_heading < 67.5 THEN 'NE'
      WHEN 67.5 <= pickup_heading < 112.5 THEN 'E'
      WHEN 112.5 <= pickup_heading < 157.5 THEN 'SE'
      WHEN 157.5 <= pickup_heading < 202.5 THEN 'S'
      WHEN 202.5 <= pickup_heading < 247.5 THEN 'SW'
      WHEN 247.5 <= pickup_heading < 292.5 THEN 'W'
      WHEN 292.5 <= pickup_heading < 337.5 THEN 'NW'
      ELSE 'N'
   END AS side_of_street
   FROM pickup_info

ALTER TABLE driver_passenger_location
ADD passenger_heading double,
    passenger_side_of_street string,
    crossed_steet boolean;

INSERT INTO driver_passenger_location
SELECT ((ATAN2((SIN(pickup_lng - request_lng ) * COS(pickup_lat)),
      (COS(request_lng)*SIN(pickup_lat) - SIN(request_lng) * COS(pickup_lat)*COS(pickup_lng - request_lng))) * 180/PI) + 360) % 360
      AS passenger_heading,
      CASE passenger_heading
        WHEN 22.5 <= passenger_heading < 67.5 THEN 'NE'
        WHEN 67.5 <= passenger_heading < 112.5 THEN 'E'
        WHEN 112.5 <= passenger_heading < 157.5 THEN 'SE'
        WHEN 157.5 <= passenger_heading < 202.5 THEN 'S'
        WHEN 202.5 <= passenger_heading < 247.5 THEN 'SW'
        WHEN 247.5 <= passenger_heading < 292.5 THEN 'W'
        WHEN 292.5 <= passenger_heading < 337.5 THEN 'NW'
        ELSE 'N'
      END AS passenger_side_of_street
      FROM fact_ride_pickups

INSERT INTO driver_passenger_location
CASE
  WHEN pickup_heading = passenger_heading THEN FALSE
  WHEN pickup_heading = 'N' AND passenger_heading = 'S' THEN FALSE
  WHEN pickup_heading = 'N' AND passenger_heading IN ('W', 'E') THEN TRUE
  WHEN passenger_heading = 'N' AND pickup_heading = 'S' THEN FALSE
  WHEN passenger_heading = 'N' AND pickup_heading IN ('W', 'E') THEN TRUE
  WHEN pickup_heading = 'S' AND passenger_heading = 'N' THEN FALSE
  WHEN pickup_heading = 'S' AND passenger_heading IN ('W', 'E') THEN TRUE
  WHEN passenger_heading = 'S' AND pickup_heading = 'N' THEN FALSE
  WHEN passenger_heading = 'S' AND pickup_heading IN ('W','E') THEN TRUE
  WHEN pickup_heading = 'E' AND passenger_heading = 'W' THEN FALSE
  WHEN pickup_heading = 'E' AND passenger_heading IN ('N', 'S') THEN TRUE
  WHEN passenger_heading = 'E' AND pickup_heading = 'W' THEN FALSE
  WHEN passenger_heading = 'E' AND pickup_heading IN ('N', 'S') THEN TRUE
  WHEN pickup_heading = 'W' AND passenger_heading = 'E' THEN FALSE
  WHEN pickup_heading = 'W' AND passenger_heading IN ('N','S') THEN TRUE
  WHEN passenger_heading = 'W' AND pickup_heading = 'E' THEN FALSE
  WHEN passenger_heading = 'W' AND pickup_heading IN ('N', 'S') THEN TRUE
  WHEN pickup_heading = 'NE' AND passenger_heading = 'SW' THEN FALSE
  WHEN pickup_heading = 'NE' AND passenger_heading IN ('SE', 'NW') THEN TRUE
  WHEN passenger_heading = 'NE' AND pickup_heading = 'SW' THEN FALSE
  WHEN passenger_heading = 'NE' AND pickup_heading IN ('SE', 'NW') THEN TRUE
  WHEN pickup_heading = 'NW' AND passenger_heading = 'SE' THEN FALSE
  WHEN pickup_heading = 'NW' AND passenger_heading IN ('NW','NE') THEN TRUE
  WHEN pickup_heading = 'NW' AND passenger_heading = 'SE' THEN FALSE
  WHEN passenger_heading = 'NW' AND pickup_heading IN ('NW','NE') THEN TRUE
  WHEN pickup_heading = 'SW' AND passenger_heading = 'NE' THEN FALSE
  WHEN pickup_heading = 'SW' AND passenger_heading IN ('SE','NW') THEN TRUE
  WHEN passenger_heading = 'SW' AND pickup_heading = 'NE' THEN FALSE
  WHEN passenger_heading = 'SW' AND pickup_heading IN ('SE','NW') THEN TRUE
  WHEN pickup_heading = 'SE' AND passenger_heading = 'NW' THEN FALSE
  WHEN pickup_heading = 'SE' AND passenger_heading IN ('SW', 'NE') THEN TRUE
  WHEN passenger_heading = 'SE' AND pickup_heading = 'NW' THEN FALSE
  WHEN passenger_heading = 'SE' AND pickup_heading IN ('SW', 'NE') THEN TRUE
  ELSE NULL
  END AS crossed_street
FROM driver_passenger_location

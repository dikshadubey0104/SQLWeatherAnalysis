CREATE DATABASE SK__04;

USE SK__04;

#1 Create a table STATION.

CREATE TABLE STATION
(ID numeric primary key,
CITY char(20),
STATE char(2),
LAT_N numeric,
LONG_W numeric
);

#2 Insert values into table.

INSERT INTO STATION VALUES
(13, 'PHOENIX', 'AZ', 33, 112),
(44, 'DENVER', 'CO', 40, 105),
(66, 'CARIBOU', 'ME', 47, 68);

#3 Look at table station in undefined order.

SELECT * FROM STATION
ORDER BY rand();

#4 Select northern stations where northern latitude is more than 39.7

SELECT * FROM STATION
WHERE LAT_N > 39.7;

#5 Create another table STATS 

CREATE TABLE STATS (
  ID NUMERIC NOT NULL,
  MONTH_NUM ENUM ("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"),
  TEMP_F float CHECK (TEMP_F BETWEEN -80 AND 150),
  RAIN_I float CHECK (RAIN_I BETWEEN 0 AND 100),
  FOREIGN KEY (ID) REFERENCES STATION(ID)
);

#6 Store the values in STATS table.

INSERT INTO STATS VALUES
(13, 1, 57.4, .31),
(13, 7, 91.7, 5.15),
(44, 1, 27.3, .18),
(44, 7, 74.8, 2.11),
(66, 1, 6.7, 2.1),
(66, 7, 65.8, 4.52);

SELECT * FROM STATS;

#7 Display temperature(from stats table),id and each city(from station table).

SELECT s.ID, st.TEMP_F, s.CITY 
FROM STATION s
JOIN STATS st
 ON s.ID= st.ID;


#8 look at table STATS, ordered by Month and greatest rainfall, with corresponding cities.

SELECT  s.ID, st.MONTH_NUM, st.RAIN_I, st.TEMP_F, s.CITY 
FROM STATION s
JOIN STATS st
 ON s.ID= st.ID
ORDER BY RAIN_I DESC, MONTH_NUM;

#9 Look at temperatures for July from STATS table, lowest temperature first, picking up city name and latitude.

SELECT s.ID, st.MONTH_NUM, st.TEMP_F, s.CITY, s.LAT_N
FROM STATION s
JOIN STATS st
 ON s.ID= st.ID
WHERE MONTH_NUM =7
ORDER BY TEMP_F;

#10 Show max and min temperatures as well as average rainfall for each city.

SELECT s.CITY, MAX(st.TEMP_F) AS max_temperature, MIN(st.TEMP_F) AS min_temperature, AVG(st.RAIN_I) AS average_rainfall
FROM STATION s
JOIN STATS st ON s.ID = st.ID
GROUP BY s.CITY;

#11 Display each city's monthly temperature in Celcius and rainfall in centimeters.

#UPDATE TEMP INTO CELCIUS AND RAINFALL INTO CENTIMETERS IN STATS TABLE
START TRANSACTION;
UPDATE STATS
SET TEMP_F = ((TEMP_F - 32) * 5 / 9);

UPDATE STATS
SET RAIN_I = (RAIN_I*2.54);

SELECT MONTH_NUM, TEMP_F AS TEMP_C, RAIN_I AS RAIN_C
FROM STATS;
ROLLBACK;

SELECT * FROM STATS;

#12 Update all rows of table stats to compensate for faulty rain gauges known to read 0.01 inches low.

UPDATE STATS
SET RAIN_I =RAIN_I+0.01;
SELECT * FROM STATS;

#13 Update denver's july temperature reading as 74.9

UPDATE STATS
SET TEMP_F=74.9
WHERE ID=44 AND MONTH_NUM= 7;
SELECT * FROM STATS;

## BY MISTAKE I PERFORMED QUERY NUMBER 13 BEFORE QUERY NUMBER 12, SO IN THE RESULT SCREENSHOT IT MIGHT SHOW TEMP_F UPDATED IN QUERY 12.




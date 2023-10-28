-- Looking at the table with everything --

SELECT *
FROM IndiaFlights.dbo.flights


-- Replacing slashes with dashes, whilst converting it into date format --

SELECT Date_of_Journey, 
       CONVERT(DATE, REPLACE(Date_of_Journey, '/', '-'), 105) AS DateFormatted
FROM IndiaFlights.dbo.flights;

-- Creating new column for the date --
ALTER TABLE IndiaFlights.dbo.flights
ADD DateFormatted date;

Update IndiaFlights.dbo.flights
SET DateFormatted = CONVERT(DATE, REPLACE(Date_of_Journey, '/', '-'), 105)




-- Separating arrival time from arrival date --


SELECT
    Arrival_Time, DateFormatted,
    CASE
        WHEN CHARINDEX(' ', Arrival_Time) > 0 THEN RIGHT(Arrival_Time, CHARINDEX(' ', Arrival_Time) - 1)
        ELSE NULL
    END AS ArrivalDate,
    CASE
        WHEN CHARINDEX(' ', Arrival_Time) > 0 THEN CONVERT(TIME, LEFT(Arrival_Time, LEN(Arrival_Time) - CHARINDEX(' ', Arrival_Time)))
        ELSE CONVERT(TIME, Arrival_Time)
    END AS ArrivalTime
FROM IndiaFlights.dbo.flights;



-- Creating new columns for arrival time and arrival date -- 

ALTER TABLE IndiaFlights.dbo.flights
ADD ArrivalTimeFormatted time;

ALTER TABLE IndiaFlights.dbo.flights
ADD ArrivalDate Varchar(255);

-- Adding the time in --
UPDATE IndiaFlights.dbo.flights
SET ArrivalTimeFormatted = 
    CASE
        WHEN CHARINDEX(' ', Arrival_Time) > 0 THEN CONVERT(TIME, LEFT(Arrival_Time, CHARINDEX(' ', Arrival_Time) - 1))
        ELSE CONVERT(TIME, Arrival_Time)
    END;

-- Adding the date in --
UPDATE IndiaFlights.dbo.flights
SET ArrivalDate = CASE
    WHEN CHARINDEX(' ', Arrival_Time) > 0 THEN RIGHT(Arrival_Time, LEN(Arrival_Time) - CHARINDEX(' ', Arrival_Time))
    ELSE NULL
    END;


-- Changing the date format --

SELECT DateFormatted, ArrivalDate,
    CASE 
        WHEN ArrivalDate IS NOT NULL THEN
            '2019-' + 
                CASE 
                    WHEN CHARINDEX(' Jan', ArrivalDate) > 0 THEN '01-' + LEFT(ArrivalDate, CHARINDEX(' Jan', ArrivalDate) - 1)
                    WHEN CHARINDEX(' Feb', ArrivalDate) > 0 THEN '02-' + LEFT(ArrivalDate, CHARINDEX(' Feb', ArrivalDate) - 1)
                    WHEN CHARINDEX(' Mar', ArrivalDate) > 0 THEN '03-' + LEFT(ArrivalDate, CHARINDEX(' Mar', ArrivalDate) - 1)
                    WHEN CHARINDEX(' Apr', ArrivalDate) > 0 THEN '04-' + LEFT(ArrivalDate, CHARINDEX(' Apr', ArrivalDate) - 1)
                    WHEN CHARINDEX(' May', ArrivalDate) > 0 THEN '05-' + LEFT(ArrivalDate, CHARINDEX(' May', ArrivalDate) - 1)
                    WHEN CHARINDEX(' Jun', ArrivalDate) > 0 THEN '06-' + LEFT(ArrivalDate, CHARINDEX(' Jun', ArrivalDate) - 1)
                    WHEN CHARINDEX(' Jul', ArrivalDate) > 0 THEN '07-' + LEFT(ArrivalDate, CHARINDEX(' Jul', ArrivalDate) - 1)
                    WHEN CHARINDEX(' Aug', ArrivalDate) > 0 THEN '08-' + LEFT(ArrivalDate, CHARINDEX(' Aug', ArrivalDate) - 1)
                    WHEN CHARINDEX(' Sep', ArrivalDate) > 0 THEN '09-' + LEFT(ArrivalDate, CHARINDEX(' Sep', ArrivalDate) - 1)
                    WHEN CHARINDEX(' Oct', ArrivalDate) > 0 THEN '10-' + LEFT(ArrivalDate, CHARINDEX(' Oct', ArrivalDate) - 1)
                    WHEN CHARINDEX(' Nov', ArrivalDate) > 0 THEN '11-' + LEFT(ArrivalDate, CHARINDEX(' Nov', ArrivalDate) - 1)
                    WHEN CHARINDEX(' Dec', ArrivalDate) > 0 THEN '12-' + LEFT(ArrivalDate, CHARINDEX(' Dec', ArrivalDate) - 1)
                END
        ELSE NULL
    END AS ArrivalDateFormatted
FROM IndiaFlights.dbo.flights;

-- Updating the arrival date table --

UPDATE IndiaFlights.dbo.flights
SET ArrivalDate = 
    CASE 
        WHEN CHARINDEX(' Jan', ArrivalDate) > 0 THEN '2019-01-' + LEFT(ArrivalDate, CHARINDEX(' Jan', ArrivalDate) - 1)
        WHEN CHARINDEX(' Feb', ArrivalDate) > 0 THEN '2019-02-' + LEFT(ArrivalDate, CHARINDEX(' Feb', ArrivalDate) - 1)
        WHEN CHARINDEX(' Mar', ArrivalDate) > 0 THEN '2019-03-' + LEFT(ArrivalDate, CHARINDEX(' Mar', ArrivalDate) - 1)
        WHEN CHARINDEX(' Apr', ArrivalDate) > 0 THEN '2019-04-' + LEFT(ArrivalDate, CHARINDEX(' Apr', ArrivalDate) - 1)
        WHEN CHARINDEX(' May', ArrivalDate) > 0 THEN '2019-05-' + LEFT(ArrivalDate, CHARINDEX(' May', ArrivalDate) - 1)
        WHEN CHARINDEX(' Jun', ArrivalDate) > 0 THEN '2019-06-' + LEFT(ArrivalDate, CHARINDEX(' Jun', ArrivalDate) - 1)
        WHEN CHARINDEX(' Jul', ArrivalDate) > 0 THEN '2019-07-' + LEFT(ArrivalDate, CHARINDEX(' Jul', ArrivalDate) - 1)
        WHEN CHARINDEX(' Aug', ArrivalDate) > 0 THEN '2019-08-' + LEFT(ArrivalDate, CHARINDEX(' Aug', ArrivalDate) - 1)
        WHEN CHARINDEX(' Sep', ArrivalDate) > 0 THEN '2019-09-' + LEFT(ArrivalDate, CHARINDEX(' Sep', ArrivalDate) - 1)
        WHEN CHARINDEX(' Oct', ArrivalDate) > 0 THEN '2019-10-' + LEFT(ArrivalDate, CHARINDEX(' Oct', ArrivalDate) - 1)
        WHEN CHARINDEX(' Nov', ArrivalDate) > 0 THEN '2019-11-' + LEFT(ArrivalDate, CHARINDEX(' Nov', ArrivalDate) - 1)
        WHEN CHARINDEX(' Dec', ArrivalDate) > 0 THEN '2019-12-' + LEFT(ArrivalDate, CHARINDEX(' Dec', ArrivalDate) - 1)
        ELSE NULL
    END;


-- Populating the nulls with date of journey --


UPDATE IndiaFlights.dbo.flights
SET ArrivalDate = DateFormatted
WHERE ArrivalDate IS NULL;


-- Converting to date format --

UPDATE IndiaFlights.dbo.flights
SET ArrivalDate = CONVERT(DATE, ArrivalDate)



-- Changing the duration to only have minutes --

SELECT
    Duration,
    CASE
        WHEN CHARINDEX('h', Duration) > 0 AND CHARINDEX('m', Duration) > 0 THEN
            CAST(LEFT(Duration, CHARINDEX('h', Duration) - 1) AS INT) * 60 + CAST(SUBSTRING(Duration, CHARINDEX('h', Duration) + 1, CHARINDEX('m', Duration) - CHARINDEX('h', Duration) - 1) AS INT)
        WHEN CHARINDEX('h', Duration) > 0 THEN
            CAST(LEFT(Duration, CHARINDEX('h', Duration) - 1) AS INT) * 60
        WHEN CHARINDEX('m', Duration) > 0 THEN
            CAST(LEFT(Duration, CHARINDEX('m', Duration) - 1) AS INT)
        ELSE 0
    END AS DurationInMinutes
FROM IndiaFlights.dbo.flights;

-- Creating new column for duration in minutes --
ALTER TABLE IndiaFlights.dbo.flights
ADD DurationMinutes int

UPDATE IndiaFlights.dbo.flights
SET DurationMinutes = CASE
        WHEN CHARINDEX('h', Duration) > 0 AND CHARINDEX('m', Duration) > 0 THEN
            CAST(LEFT(Duration, CHARINDEX('h', Duration) - 1) AS INT) * 60 + CAST(SUBSTRING(Duration, CHARINDEX('h', Duration) + 1, CHARINDEX('m', Duration) - CHARINDEX('h', Duration) - 1) AS INT)
        WHEN CHARINDEX('h', Duration) > 0 THEN
            CAST(LEFT(Duration, CHARINDEX('h', Duration) - 1) AS INT) * 60
        WHEN CHARINDEX('m', Duration) > 0 THEN
            CAST(LEFT(Duration, CHARINDEX('m', Duration) - 1) AS INT)
        ELSE 0
    END

-- Counting the number of planes from each airline and checking for possible errors -- 

SELECT Airline, COUNT(Airline) as planecount
FROM IndiaFlights.dbo.flights
Group by Airline


-- Removing premium and business from the airlines --

SELECT 
    REPLACE(REPLACE(Airline, ' Premium Economy', ''), ' Business', '') AS Airline, 
	COUNT(Airline) as planecount
FROM IndiaFlights.dbo.flights
GROUP BY Airline


-- Creating new column for airlines with premium and business removed --
ALTER TABLE IndiaFlights.dbo.flights
ADD  AirlineFormatted NVARCHAR(255);


-- Adding details of airlines to the column --
UPDATE IndiaFlights.dbo.flights
SET AirlineFormatted = REPLACE(REPLACE(Airline, ' Premium Economy', ''), ' Business', '')


-- Checking --

SELECT AirlineFormatted, COUNT(AirlineFormatted) as planecount
FROM IndiaFlights.dbo.flights
Group by AirlineFormatted


-- Counting the source and destination, as well as checking for errors --
SELECT Source, COUNT(Source) as Sourcecount
FROM IndiaFlights.dbo.flights
Group by Source

SELECT Destination, COUNT(Destination) as Destinationcount
FROM IndiaFlights.dbo.flights
Group by Destination


-- Changing the total stops to only numbers --

SELECT Total_Stops,
    CASE
        WHEN Total_Stops = 'non-stop' THEN 0
        WHEN CHARINDEX(' ', Total_Stops) > 0 THEN LEFT(Total_Stops, CHARINDEX(' ', Total_Stops) - 1)
        ELSE NULL
    END AS LayoverNumber
FROM IndiaFlights.dbo.flights;


-- Creating new column for layover number --

ALTER TABLE IndiaFlights.dbo.flights
ADD LayoverNumber int;

-- Adding the layover numbers into the new column --

UPDATE IndiaFlights.dbo.flights
SET LayoverNumber = 
    CASE
        WHEN Total_Stops = 'non-stop' THEN 0
        WHEN CHARINDEX(' ', Total_Stops) > 0 THEN 
            CAST(LEFT(Total_Stops, CHARINDEX(' ', Total_Stops) - 1) AS INT)
        ELSE NULL
    END;


-- Changing departure time into time format --

SELECT Dep_Time, CONVERT(TIME, Dep_Time)
FROM IndiaFlights.dbo.flights


-- Updating the departure time -- 
UPDATE IndiaFlights.dbo.flights
SET Dep_Time = CONVERT(TIME, Dep_Time)


-- Looking at the data so far --
SELECT AirlineFormatted, 
	   Source,
	   Destination,
	   Dep_Time as Departure_Time,
	   ArrivalTimeFormatted as Arrival_Time,
	   DateFormatted as Departure_Date,
	   ArrivalDate as Arrival_Date,   
	   DurationMinutes as Duration,
	   LayoverNumber as Layover,
	   Price,
	   Additional_Info as Exta_Info
FROM IndiaFlights.dbo.flights


-- FIXING THE DATES OF DEPARTURE AND ARRIVAL --
-- Creating CTE to see errors in date of departure and arrival

WITH FlightData AS (
    SELECT AirlineFormatted, DateFormatted, ArrivalDate, Dep_Time, ArrivalTimeFormatted, Duration, DurationMinutes, Route, 
	CASE
           WHEN ArrivalDate < DateFormatted THEN NULL
           ELSE ArrivalDate
       END AS Checker
    FROM IndiaFlights.dbo.flights
)
SELECT *,
CASE	
	WHEN Checker IS NULL THEN DateFormatted = ArrivalDate AND ArrivalDate = DateFormatted
	ELSE NULL
	END
FROM FlightData
WHERE Checker is NULL
ORDER BY DurationMinutes DESC




-- Swapping the specific dates between departure and arrival --
WITH FlightData AS (
    SELECT 
        AirlineFormatted, 
        DateFormatted, 
        ArrivalDate, 
        Dep_Time, 
        ArrivalTimeFormatted, 
        Duration, 
        DurationMinutes, 
        Route, 
        CASE
            WHEN ArrivalDate < DateFormatted THEN NULL
            ELSE ArrivalDate
        END AS Checker
    FROM IndiaFlights.dbo.flights
)
SELECT 
    AirlineFormatted, 
    CASE 
        WHEN Checker IS NULL THEN ArrivalDate
        ELSE DateFormatted
    END AS DateFormatted,
    CASE 
        WHEN Checker IS NULL THEN DateFormatted
        ELSE ArrivalDate
    END AS ArrivalDate,
    Dep_Time, 
    ArrivalTimeFormatted, 
    Duration, 
    DurationMinutes, 
    Route
FROM FlightData
WHERE Checker IS NULL
ORDER BY DurationMinutes DESC;


-- Updating the departure and arrival dates by swapping --

UPDATE IndiaFlights.dbo.flights
SET DateFormatted = CASE
    WHEN ArrivalDate < DateFormatted THEN ArrivalDate
    ELSE DateFormatted
END,
ArrivalDate = CASE
    WHEN ArrivalDate < DateFormatted THEN DateFormatted
    ELSE ArrivalDate
END
WHERE ArrivalDate < DateFormatted;


SELECT DateFormatted, Dep_Time, ArrivalTimeFormatted, ArrivalDate, *
FROM IndiaFlights.dbo.flights

















-- Changing the duration to time -- 


WITH DurationCTE AS (
SELECT Duration, 
       CASE
           WHEN CHARINDEX('h', Duration) > 0 AND CHARINDEX('m', Duration) > 0 THEN
               CAST(
                   RIGHT('0' + LEFT(Duration, CHARINDEX('h', Duration) - 1), 2) + ':' + 
                   SUBSTRING(Duration, CHARINDEX('h', Duration) + 2, CHARINDEX('m', Duration) - CHARINDEX('h', Duration) - 2)
                   AS NVARCHAR(8)
               )
           WHEN CHARINDEX('h', Duration) > 0 THEN
               CAST(
                   RIGHT('0' + LEFT(Duration, CHARINDEX('h', Duration) - 1), 2) + ':00' 
                   AS NVARCHAR(8)
               )
           ELSE NULL
       END AS DurationTime
FROM IndiaFlights.dbo.flights)

Select *,
       CASE
           WHEN LEN(DurationTime) = 4 AND SUBSTRING(DurationTime, 4, 1) != '0' THEN
               LEFT(DurationTime, 3) + '0' + RIGHT(DurationTime, 1)
           ELSE DurationTime
       END AS UpdatedDurationTime
FROM DurationCTE
ORDER BY Duration



-- Creating new table for duration, showing the hours and minutes --

ALTER TABLE IndiaFlights.dbo.flights
ADD NewDurationTime NVARCHAR(8);


-- Adding the values into the new duration time column --


UPDATE IndiaFlights.dbo.flights
SET NewDurationTime = (
    CASE
        WHEN CHARINDEX('h', Duration) > 0 AND CHARINDEX('m', Duration) > 0 THEN
            CAST(
                RIGHT('0' + LEFT(Duration, CHARINDEX('h', Duration) - 1), 2) + ':' + 
                RIGHT('0' + SUBSTRING(Duration, CHARINDEX('h', Duration) + 2, CHARINDEX('m', Duration) - CHARINDEX('h', Duration) - 2), 2)
                AS NVARCHAR(8)
            )
        WHEN CHARINDEX('h', Duration) > 0 THEN
            CAST(
                RIGHT('0' + LEFT(Duration, CHARINDEX('h', Duration) - 1), 2) + ':00' 
                AS NVARCHAR(8)
            )
        ELSE NULL
    END
);





-- Changing the duration format into dd:hh:mm --

SELECT
    AirlineFormatted,
    DateFormatted AS DepartureDate,
    ArrivalDate,
    Dep_Time AS DepartureTime,
    ArrivalTimeFormatted AS ArrivalTime,
    CAST(DurationMinutes / 1440 AS NVARCHAR(2)) + ':' + 
    RIGHT('0' + CAST((DurationMinutes / 60) % 24 AS NVARCHAR(2)), 2) + ':' + 
    RIGHT('0' + CAST(DurationMinutes % 60 AS NVARCHAR(2)), 2) AS DurationInDHM,
	Duration
FROM IndiaFlights.dbo.flights;


-- Testing adding duration to the date and time of departure --

WITH DATEs AS (
SELECT
	DateFormatted,
	Dep_Time,
    ArrivalDate,
    ArrivalTimeFormatted,
    DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', CAST(Dep_Time AS TIME)), CAST(DateFormatted AS DATETIME)) AS DepartureDateTime,
    DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', CAST(ArrivalTimeFormatted AS TIME)), CAST(ArrivalDate AS DATETIME)) AS ArrivalDateTime,
	DATEADD(MINUTE, DurationMinutes, DepartureDateTime) as ArrivalTimeFormatted,
	DurationMinutes
FROM IndiaFlights.dbo.flights)

SELECT *, DATEDIFF(MINUTE, DepartureDateTime, ArrivalDateTime), DATEADD(MINUTE, DurationMinutes, DepartureDateTime) as ArrivalTimeFormatted
FROM DATEs
ORDER BY DurationMinutes DESC


-- Creating new column for date and time combined for departure and arrival --

ALTER TABLE IndiaFlights.dbo.flights
ADD DepartureDateTime DATETIME

ALTER TABLE IndiaFlights.dbo.flights
ADD ArrivalDateTime DATETIME


-- Adding the departure date and time into new column --

UPDATE IndiaFlights.dbo.flights
SET DepartureDateTime =
DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', CAST(Dep_Time AS TIME)), CAST(DateFormatted AS DATETIME))


-- Adding the arrival date and time into new column --

UPDATE IndiaFlights.dbo.flights
SET ArrivalDateTime =
DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', CAST(ArrivalTimeFormatted AS TIME)), CAST(DateFormatted AS DATETIME))


-- Checking to see if there are unequal arrival date and time when comparing with duration time added to departure time--
-- Calculating the percentage of mismatch --

WITH ArrivalCTE AS (
    SELECT
        DepartureDateTime,
        ArrivalDateTime,
        DurationMinutes,
        DATEADD(MINUTE, DurationMinutes, DepartureDateTime) AS ArrivalDateTimeFormatted
    FROM IndiaFlights.dbo.flights
)

SELECT
    COUNT(*) AS TotalCount,
    SUM(CASE WHEN ArrivalDateTime != ArrivalDateTimeFormatted THEN 1 ELSE 0 END) AS MismatchCount,
    (SUM(CASE WHEN ArrivalDateTime != ArrivalDateTimeFormatted THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS PercentageMismatch
FROM ArrivalCTE;


-- Adding new column with the arrival time calculated by adding duration time to departure time --

ALTER TABLE IndiaFlights.dbo.flights
ADD ArrivalDateTimeCorrected DATETIME

UPDATE IndiaFlights.dbo.flights
SET ArrivalDateTimeCorrected = DATEADD(MINUTE, DurationMinutes, DepartureDateTime);


-- FINAL TABLE --

SELECT AirlineFormatted as Airline,
	   Source,
	   Destination,
	   Price,
	   DepartureDateTime as Departure,
	   ArrivalDateTimeCorrected as Arrival,
	   DurationMinutes as Duration,
	   LayoverNumber as Layovers,
	   Additional_Info as Extra_Info
FROM IndiaFlights.dbo.flights
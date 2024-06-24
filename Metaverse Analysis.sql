SELECT *
FROM[dbo].[metaverse]

--Date Cleaning
--Checking for NULLvalues
SELECT SUM(CASE WHEN [anomaly] IS NULL THEN 1 ELSE 0 END)
AS missing_count
FROM [dbo].[metaverse]

--Categorizing time_of_day 
--To add time_of_day column
UPDATE [dbo].[metaverse]
SET time_of_day = 
    CASE
        WHEN [hour_of_day] BETWEEN 0 AND 11 THEN 'Morning'
        WHEN [hour_of_day] BETWEEN 12 AND 16 THEN 'Afternoon'
        ELSE 'Evening'
    END;

-- To group timestamp by month
ALTER TABLE [dbo].[metaverse]
ADD month_of_year VARCHAR(20)

UPDATE [dbo].[metaverse]
SET month_of_year =
CASE 
        WHEN MONTH([timestamp]) = 1 THEN 'January'
        WHEN MONTH([timestamp]) = 2 THEN 'February'
        WHEN MONTH([timestamp]) = 3 THEN 'March'
        WHEN MONTH([timestamp]) = 4 THEN 'April'
        WHEN MONTH([timestamp]) = 5 THEN 'May'
        WHEN MONTH([timestamp]) = 6 THEN 'June'
        WHEN MONTH([timestamp]) = 7 THEN 'July'
        WHEN MONTH([timestamp]) = 8 THEN 'August'
        WHEN MONTH([timestamp]) = 9 THEN 'September'
        WHEN MONTH([timestamp]) = 10 THEN 'October'
        WHEN MONTH([timestamp]) = 11 THEN 'November'
        ELSE 'December'
		END

--To group timestamp by season
ALTER TABLE [dbo].[metaverse]
ADD season VARCHAR(10)

UPDATE [dbo].[metaverse]
SET season = 
CASE 
WHEN MONTH([timestamp]) IN (12,1,2) THEN 'Winter'
WHEN MONTH([timestamp]) IN (3,4,5) THEN 'Spring'
WHEN MONTH([timestamp]) IN (6,7,8) THEN 'Summer'
ELSE 'Autumn'
END 



--Regional Analysis
--How does the average transaction amount vary across different regions?
SELECT [location_region], ROUND(AVG([amount]),0) AS avg_amount
FROM [dbo].[metaverse]
GROUP BY [location_region]
ORDER BY avg_amount DESC

--What are the peak transaction times during the day, and how do they vary by region?
SELECT [time_of_day], [location_region], COUNT(*)AS total_count
FROM [dbo].[metaverse]
GROUP BY [location_region], [time_of_day]
ORDER BY  [location_region],total_count DESC

--Which regions have the highest average transaction values?
SELECT [location_region], ROUND(AVG([amount]), 0) AS avg_amount
FROM [dbo].[metaverse]
GROUP BY [location_region]
ORDER  BY avg_amount DESC

--How do risk score vary across different payment methods and regions?
SELECT [transaction_type], [location_region], ROUND(AVG([risk_score]),0) AS avg_risk
FROM [dbo].[metaverse]
GROUP BY [transaction_type], location_region 
ORDER BY [location_region], avg_risk DESC

--Temporal Analysis
--What is the trend of transaction volumes over the past year on a monthly basis?
SELECT ROUND(SUM([amount]),0) AS avg_amount, [month_of_year]
FROM [dbo].[metaverse]
GROUP BY [month_of_year]
ORDER BY  avg_amount DESC

--How do seasonal trends affect transaction volumes and amounts?
SELECT ROUND(SUM([amount]),0) AS total_amount, [season]
FROM [dbo].[metaverse]
GROUP BY [season]
ORDER BY total_amount DESC

--Customer Analysis
--What is the correlation between customer age and their average transaction amount?
SELECT ROUND(AVG([amount]),0) AS avg_amount, [age_group]
FROM [dbo].[metaverse]
GROUP BY [age_group]
ORDER BY avg_amount DESC

--What is the average session duration between customer age groups?
SELECT AVG([session_duration]) AS avg_duration, [age_group]
FROM [dbo].[metaverse]
GROUP BY [age_group]
ORDER BY avg_duration

--What customer age group has the highest login frequency?
SELECT SUM([login_frequency]) AS total_frequency, [age_group]
FROM [dbo].[metaverse]
GROUP BY [age_group]
ORDER BY total_frequency

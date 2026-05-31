-- Create the Blood Pressure table
CREATE TABLE blood_pressure (
    country VARCHAR(255),
    sex VARCHAR(50),
    year INT,
    prevalence NUMERIC
);

-- Create the Obesity table
CREATE TABLE obesity (
    country VARCHAR(255),
    sex VARCHAR(50),
    year INT,
    prevalence NUMERIC
);

-- Create the Diabetes table
CREATE TABLE diabetes (
    country VARCHAR(255),
    sex VARCHAR(50),
    year INT,
    prevalence NUMERIC
);

-- Create the Cholesterol table
CREATE TABLE cholesterol (
    country VARCHAR(255),
    sex VARCHAR(50),
    year INT,
    cholesterol_level NUMERIC
);


SELECT 'Blood Pressure' AS dataset, COUNT(*) AS total_rows FROM blood_pressure
UNION ALL
SELECT 'Obesity', COUNT(*) FROM obesity
UNION ALL
SELECT 'Diabetes', COUNT(*) FROM diabetes
UNION ALL
SELECT 'Cholesterol', COUNT(*) FROM cholesterol
ORDER BY total_rows DESC;


SELECT 'Blood Pressure' AS dataset, MIN(year) AS start_year, MAX(year) AS end_year FROM blood_pressure
UNION ALL
SELECT 'Obesity', MIN(year), MAX(year) FROM obesity
UNION ALL
SELECT 'Diabetes', MIN(year), MAX(year) FROM diabetes
UNION ALL
SELECT 'Cholesterol', MIN(year), MAX(year) FROM cholesterol;


SELECT 'Blood Pressure' AS dataset, COUNT(DISTINCT country) AS total_unique_countries FROM blood_pressure
UNION ALL
SELECT 'Obesity', COUNT(DISTINCT country) FROM obesity
UNION ALL
SELECT 'Diabetes', COUNT(DISTINCT country) FROM diabetes
UNION ALL
SELECT 'Cholesterol', COUNT(DISTINCT country) FROM cholesterol;


CREATE OR REPLACE VIEW master_health_data AS
SELECT 
    bp.country,
    bp.sex,
    bp.year,
    ROUND((bp.prevalence * 100), 2) AS blood_pressure_pct,
    ROUND((ob.prevalence * 100), 2) AS obesity_pct,
    ROUND((db.prevalence * 100), 2) AS diabetes_pct,
    ch.cholesterol_level
FROM blood_pressure bp
INNER JOIN obesity ob 
    ON bp.country = ob.country AND bp.sex = ob.sex AND bp.year = ob.year
INNER JOIN diabetes db 
    ON bp.country = db.country AND bp.sex = db.sex AND bp.year = db.year
INNER JOIN cholesterol ch 
    ON bp.country = ch.country AND bp.sex = ch.sex AND bp.year = ch.year
WHERE bp.year BETWEEN 1980 AND 2014 AND bp.country NOT IN ('Global', 'Central Africa', 'High-income Western countries');
  
 
SELECT COUNT(DISTINCT country) AS total_countries
FROM master_health_data;

SELECT * FROM master_health_data 
LIMIT 100;

-- Analysis 1: What were the top 10 countries with the highest obesity percentage for Men in the year 2014?
select country, obesity_pct 
from master_health_data
where sex = 'Men' and year = '2014'
order by obesity_pct desc
limit 10

-- Analysis 2: Which countries had a blood pressure percentage lower than 15% for Women in the year 1990?
select country, blood_pressure_pct
from master_health_data
where year = 1990 and sex = 'Women' and blood_pressure_pct < 15.0
order by blood_pressure_pct desc


-- Analysis 3: List the cholesterol level, obesity percentage, and diabetes percentage for the 'United Arab Emirates' for Men in the year 2000.
select country, cholesterol_level, obesity_pct, diabetes_pct
from master_health_data
where country = 'United Arab Emirates' and sex = 'Men' and year = 2000


-- Analysis 4: What is the average global cholesterol level for Men versus Women across the entire dataset?

select sex, round(avg(cholesterol_level),2) as avg_chol_lvl
from master_health_data
group by sex


-- Analysis 5: Which specific year had the highest average global diabetes percentage for Women?
select year, round(avg(diabetes_pct),2) as avg_diabetes
from master_health_data
where sex = 'Women'
group by year
order by avg_diabetes desc
limit 1


-- Analysis 6: Calculate the average obesity percentage for 'Japan' over the entire 35-year period, broken down by Sex.
select  sex, round(avg(obesity_pct),2) as avg_obesity
from master_health_data
where country = 'Japan'
group by sex


-- Analysis 7: In the year 2014, exactly how many countries had a female cholesterol level strictly greater than 5.0?
select count(country) as num_country
from master_health_data
where year = 2014 and cholesterol_level > 5.0 and sex = 'Women'


-- Analysis 8: What are the countries where the female obesity percentage in 2014 was strictly higher than the
-- global average female obesity percentage in that exact same year.
select country, obesity_pct
from master_health_data
where year = 2014 and sex = 'Women' 
and obesity_pct > (
	select round(avg(obesity_pct),2)
	from master_health_data
	where year = 2014 and sex = 'Women'
)
order by obesity_pct desc;


-- Analysis 9: Create a risk categorization for Men in the year 2010 based on their blood pressure. 
--If the percentage is over 30%, label it 'High Risk'. If it is between 20% and 30%, label it 'Medium Risk'. 
--If it is strictly below 20%, label it 'Low Risk'. 
--Finally, count exactly how many countries fall into each of these three risk buckets.
select case
	when blood_pressure_pct > 30.0 then 'High Risk'
	when blood_pressure_pct between 20.0 and 30.0 then 'Medium Risk'
	else 'Low Risk'
	end as risk_category,
	count(country) as country_count
from master_health_data
where year = 2010 and sex = 'Men'
Group by risk_category


-- Analysis 10: Which 5 countries recorded the absolute lowest cholesterol levels for Men in the year 2000?
select country, cholesterol_level
from  master_health_data
where sex = 'Men' and year = 2000
order by cholesterol_level asc
limit 5



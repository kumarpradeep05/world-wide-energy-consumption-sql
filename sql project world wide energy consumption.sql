CREATE DATABASE ENERGYDB2;

USE ENERGYDB2;

show tables;

select * from country_3;

select * from emission_3;

select * from consum_3;

select * from gdp_3;

select * from population_3;

select * from production_3;


select * from emission_3;

# What is the total emission per country for the most recent year available?


select country , sum(emission) as total_emission from emission_3 where year=(select max(year) from emission_3)  group by country order by total_emission desc;

#What are the top 5 countries by GDP in the most recent year?

select * from gdp_3;




select  country,max(value) as gdp from gdp_3 where year=(select max(year) from gdp_3) group by country    order by gdp  desc limit 5;



#Compare energy production and consumption by country and year. 


select * from production_3;

select * from consum_3;

SELECT 
    p.country,
    p.year,
    SUM(p.production) AS total_production,
    SUM(c.consumption) AS total_consumption
FROM production_3 p
JOIN consum_3 c 
    ON p.country = c.country 
   AND p.year = c.year 
   AND p.energy = c.energy
GROUP BY p.country, p.year
ORDER BY p.year DESC, p.country;


#Which energy types contribute most to emissions across all countries?

select * from emission_3;




SELECT 
    `energy type`,
    SUM(emission) AS total_emission
FROM emission_3
WHERE year = (SELECT MAX(year) FROM emission_3)
GROUP BY `energy type`
ORDER BY total_emission DESC;



#-------------------------------Trend Analysis Over Time-------------------------------------------------------

#How have global emissions changed year over year?
 
 
 select * from emission_3;
 
 
 select  year,sum(emission) as total_emission from emission_3 group by  year;


#What is the trend in GDP for each country over the given years?

select * from gdp_3;

select country,year,value as gdp from gdp_3 order by country,year;


#How has population growth affected total emissions in each country?

select * from population_3;

select * from emission_3;

SELECT 
    e.country,
    e.year,
    SUM(e.emission) AS total_emission,
    p.Value AS population,
    ROUND(SUM(e.emission) / p.Value, 4) AS emission_per_capita
FROM emission_3 e
JOIN population_3 p 
    ON e.country = p.countries 
   AND e.year = p.year
GROUP BY e.country, e.year, p.Value
ORDER BY e.year DESC, total_emission DESC;



#Has energy consumption increased or decreased over the years for major economies?

select * from consum_3;

select distinct(country) from consum_3;



SELECT 
    country,
    year,
    SUM(consumption) AS total_consumption
FROM consum_3

GROUP BY country, year
ORDER BY country, year;

SELECT 
    country,
    year,
    value AS gdp
FROM gdp_3
WHERE year = (SELECT MAX(year) FROM gdp_3)
ORDER BY gdp DESC
LIMIT 10;

SELECT 
    c.country,
    c.year,
    SUM(c.consumption) AS total_consumption
FROM consum_3 c
JOIN (
    SELECT country
    FROM gdp_3
    WHERE year = (SELECT MAX(year) FROM gdp_3)
    ORDER BY value DESC
    LIMIT 5
) g ON c.country = g.country
GROUP BY c.country, c.year
ORDER BY c.country, c.year;



#What is the average yearly change in emissions per capita for each country?

WITH per_capita AS (
    SELECT 
        e.country,
        e.year,
        SUM(e.emission) / p.Value AS emission_per_capita
    FROM emission_3 e
    JOIN population_3 p 
        ON e.country = p.countries 
       AND e.year = p.year
    GROUP BY e.country, e.year, p.Value
),
yoy_change AS (
    SELECT 
        country,
        year,
        emission_per_capita,
        emission_per_capita - LAG(emission_per_capita) 
            OVER (PARTITION BY country ORDER BY year) AS yearly_change
    FROM per_capita
)
SELECT 
    country,
    ROUND(AVG(yearly_change), 4) AS avg_yoy_change
FROM yoy_change
WHERE yearly_change IS NOT NULL
GROUP BY country
ORDER BY avg_yoy_change DESC;


#--------------------------------Ratio & Per Capita Analysis------------------------------------- 

#What is the emission-to-GDP ratio for each country by year?

select * from gdp_3;
select * from emission_3;

SELECT 
    e.country,
    e.year,
    SUM(e.emission) AS total_emission,
    g.value AS gdp,
    ROUND(SUM(e.emission) / g.value, 6) AS emission_to_gdp_ratio
FROM emission_3 e
JOIN gdp_3 g 
    ON e.country = g.country 
   AND e.year = g.year
GROUP BY e.country, e.year, g.value
ORDER BY e.year, emission_to_gdp_ratio DESC;


#What is the energy consumption per capita for each country over the last decade?

SELECT 
    c.country,
    c.year,
    SUM(c.consumption) AS total_consumption,
    p.Value AS population,
    ROUND(SUM(c.consumption) / p.Value, 4) AS consumption_per_capita
FROM consum_3 c
JOIN population_3 p 
    ON c.country = p.countries 
   AND c.year = p.year
WHERE c.year >= YEAR(CURDATE()) - 10
GROUP BY c.country, c.year, p.Value
ORDER BY c.country, c.year;

#How does energy production per capita vary across countries?

SELECT 
    p.country,
    p.year,
    SUM(p.production) AS total_production,
    pop.Value AS population,
    ROUND(SUM(p.production) / pop.Value, 4) AS production_per_capita
FROM production_3 p
JOIN population_3 pop 
    ON p.country = pop.countries 
   AND p.year = pop.year
GROUP BY p.country, p.year, pop.Value
ORDER BY p.country, p.year;



#Which countries have the highest energy consumption relative to GDP?

SELECT 
    c.country,
    c.year,
    SUM(c.consumption) AS total_consumption,
    g.value AS gdp,
    ROUND(SUM(c.consumption) / g.value, 6) AS consumption_to_gdp_ratio
FROM consum_3 c
JOIN gdp_3 g 
    ON c.country = g.country 
   AND c.year = g.year
GROUP BY c.country, c.year, g.value
ORDER BY c.year, consumption_to_gdp_ratio DESC;


#What is the correlation between GDP growth and energy production growth?


WITH gdp_growth AS (
    SELECT 
        country,
        year,
        value AS gdp,
        (value - LAG(value) OVER (PARTITION BY country ORDER BY year)) / 
        LAG(value) OVER (PARTITION BY country ORDER BY year) AS gdp_growth_rate
    FROM gdp_3
),
production_growth AS (
    SELECT 
        country,
        year,
        SUM(production) AS total_production,
        (SUM(production) - LAG(SUM(production)) OVER (PARTITION BY country ORDER BY year)) / 
        LAG(SUM(production)) OVER (PARTITION BY country ORDER BY year) AS production_growth_rate
    FROM production_3
    GROUP BY country, year
)
SELECT 
    g.country,
    g.year,
    g.gdp_growth_rate,
    p.production_growth_rate
FROM gdp_growth g
JOIN production_growth p 
    ON g.country = p.country 
   AND g.year = p.year
WHERE g.gdp_growth_rate IS NOT NULL 
  AND p.production_growth_rate IS NOT NULL
ORDER BY g.country, g.year;



#------------------------- Global Comparisons----------------------

#What are the top 10 countries by population and how do their emissions compare?

WITH top_population AS (
    SELECT 
        countries AS country,
        year,
        Value AS population
    FROM population_3
    WHERE year = (SELECT MAX(year) FROM population_3)
    ORDER BY population DESC
    LIMIT 10
)
SELECT 
    e.country,
    e.year,
    SUM(e.emission) AS total_emission,
    p.population,
    ROUND(SUM(e.emission) / p.population, 4) AS emission_per_capita
FROM emission_3 e
JOIN top_population p 
    ON e.country = p.country 
   AND e.year = p.year
GROUP BY e.country, e.year, p.population
ORDER BY total_emission DESC;



#Which countries have improved (reduced) their per capita emissions the most over the last decade?

WITH per_capita AS (
    SELECT 
        e.country,
        e.year,
        SUM(e.emission) / p.Value AS emission_per_capita
    FROM emission_3 e
    JOIN population_3 p 
        ON e.country = p.countries 
       AND e.year = p.year
    GROUP BY e.country, e.year, p.Value
),
decade_change AS (
    SELECT 
        country,
        MAX(year) AS latest_year,
        MIN(year) AS earliest_year,
        MAX(emission_per_capita) AS latest_per_capita,
        MIN(emission_per_capita) AS earliest_per_capita,
        (MAX(emission_per_capita) - MIN(emission_per_capita)) AS change_in_per_capita
    FROM per_capita
    WHERE year >= YEAR(CURDATE()) - 10
    GROUP BY country
)
SELECT 
    country,
    earliest_year,
    earliest_per_capita,
    latest_year,
    latest_per_capita,
    ROUND(change_in_per_capita, 4) AS per_capita_change
FROM decade_change
ORDER BY per_capita_change ASC
LIMIT 10;



#What is the global share (%) of emissions by country?


WITH country_emissions AS (
    SELECT 
        country,
        year,
        SUM(emission) AS total_emission
    FROM emission_3
    GROUP BY country, year
),
global_emissions AS (
    SELECT 
        year,
        SUM(total_emission) AS global_total
    FROM country_emissions
    GROUP BY year
)
SELECT 
    c.country,
    c.year,
    c.total_emission,
    g.global_total,
    ROUND((c.total_emission / g.global_total) * 100, 2) AS global_share_percent
FROM country_emissions c
JOIN global_emissions g 
    ON c.year = g.year
ORDER BY c.year, global_share_percent DESC;

#What is the global average GDP, emission, and population by year?

WITH yearly_totals AS (
    SELECT 
        g.year,
        AVG(g.value) AS avg_gdp,
        AVG(e.total_emission) AS avg_emission,
        AVG(p.Value) AS avg_population
    FROM gdp_3 g
    JOIN (
        SELECT country, year, SUM(emission) AS total_emission
        FROM emission_3
        GROUP BY country, year
    ) e ON g.country = e.country AND g.year = e.year
    JOIN population_3 p 
        ON g.country = p.countries AND g.year = p.year
    GROUP BY g.year
)
SELECT 
    year,
    ROUND(avg_gdp, 2) AS global_avg_gdp,
    ROUND(avg_emission, 2) AS global_avg_emission,
    ROUND(avg_population, 2) AS global_avg_population
FROM yearly_totals
ORDER BY year;

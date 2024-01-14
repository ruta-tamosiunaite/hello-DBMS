/* JOB 9 */

ALTER TABLE world RENAME TO world_original;

CREATE TABLE world (
    Country VARCHAR(255),
    Region VARCHAR(255),
    Population INTEGER,
    Area INTEGER,
    PopDensity FLOAT,
    Coastline FLOAT,
    NetMigration FLOAT,
    InfantMortality FLOAT,
    GDP INTEGER,
    Literacy FLOAT,
    Phones FLOAT,
    Arable FLOAT,
    Crops FLOAT,
    Other FLOAT,
    Climate INTEGER,
    Birthrate FLOAT,
    Deathrate FLOAT,
    Agriculture FLOAT,
    Industry FLOAT,
    Service FLOAT
);

INSERT INTO world (
    Country,
    Region,
    Population,
    Area,
    PopDensity,
    Coastline,
    NetMigration,
    InfantMortality,
    GDP,
    Literacy,
    Phones,
    Arable,
    Crops,
    Other,
    Climate,
    Birthrate,
    Deathrate,
    Agriculture,
    Industry,
    Service
)
SELECT
    TRIM(Country),
    TRIM(Region),
    CAST(NULLIF(TRIM(Population), '') AS INTEGER),
    CAST(NULLIF(TRIM("Area (sq. mi.)"), '') AS INTEGER),
    CAST(REPLACE(NULLIF(TRIM("Pop. Density (per sq. mi.)"), ''), ',', '.') AS FLOAT),
    CAST(REPLACE(NULLIF(TRIM("Coastline (coast/area ratio)"), ''), ',', '.') AS FLOAT),
    CAST(REPLACE(NULLIF(TRIM("Net migration"), ''), ',', '.') AS FLOAT),
    CAST(REPLACE(NULLIF(TRIM("Infant mortality (per 1000 births)"), ''), ',', '.') AS FLOAT),
    CAST(NULLIF(TRIM("GDP ($ per capita)"), '') AS INTEGER),
    CAST(REPLACE(NULLIF(TRIM("Literacy (%)"), ''), ',', '.') AS FLOAT),
    CAST(REPLACE(NULLIF(TRIM("Phones (per 1000)"), ''), ',', '.') AS FLOAT),
    CAST(REPLACE(NULLIF(TRIM("Arable (%)"), ''), ',', '.') AS FLOAT),
    CAST(REPLACE(NULLIF(TRIM("Crops (%)"), ''), ',', '.') AS FLOAT),
    CAST(REPLACE(NULLIF(TRIM("Other (%)"), ''), ',', '.') AS FLOAT),
    CAST(NULLIF(TRIM(Climate), '') AS INTEGER),
    CAST(REPLACE(NULLIF(TRIM(Birthrate), ''), ',', '.') AS FLOAT),
    CAST(REPLACE(NULLIF(TRIM(Deathrate), ''), ',', '.') AS FLOAT),
    CAST(REPLACE(NULLIF(TRIM(Agriculture), ''), ',', '.') AS FLOAT),
    CAST(REPLACE(NULLIF(TRIM(Industry), ''), ',', '.') AS FLOAT),
    CAST(REPLACE(NULLIF(TRIM(Service), ''), ',', '.') AS FLOAT)
FROM world_original;

DROP TABLE world_original;


SELECT * FROM world;

-- 20 richest countries in the world. 
-- Only 2 of them are from 'LATIN AMER. & CARIB' region: 
-- Cayman Islands (Tax haven - no personal & corporate income tax) and
-- Aruba (Tourism Service contributes to > 60% of country's GDP)
SELECT Country, GDP, Region
FROM world
WHERE GDP <> ''
ORDER BY GDP DESC
LIMIT 20;


-- More dense regions may have higher GDP per capita. With exception of Baltics and Near East Asia.
SELECT 
    Region,
    CAST (AVG(PopDensity) AS INT) AS Avg_Density,
    CAST(AVG(GDP) AS INT) AS Avg_GDP
FROM world
WHERE GDP <> ''
GROUP BY Region
ORDER BY AVG(GDP) DESC;


-- Least literal regions and countries
SELECT 
	Region, 
	COUNT(Country) AS 'Countries < 50% literal', 
	MIN(Literacy) AS min_literacy, Country
FROM world
WHERE Literacy > 0
AND Literacy  < 50
GROUP BY Region
ORDER BY Literacy ;


-- Larger range of literacy rates within the region may indicate a lower overall literacy level in the region
SELECT 
    Region,
    MIN(Literacy) AS min_literacy,
    MAX(Literacy) AS max_literacy,
    (MAX(Literacy) - MIN(Literacy)) AS literacy_range,
    CAST(AVG(Literacy) AS INT) AS avg_literacy
FROM world
WHERE Literacy > 0
GROUP BY Region
ORDER BY avg_literacy;


-- Populations of Europe and America are decreasing. Populations of Africa, East, Oceania and Asia are growing.
SELECT 
    Region,
    CAST(AVG(Birthrate) AS INT) AS avg_birthrate,
    CAST(AVG(Deathrate) AS INT) AS avg_deathrate,
    (CAST(AVG(Birthrate) AS INT) - CAST(AVG(Deathrate) AS INT)) AS natural_population_change
FROM world
WHERE Birthrate > 0 AND Deathrate > 0
GROUP BY Region
ORDER BY natural_population_change DESC;


-- Asia region is much denser then all other regions
SELECT 
    Region,
    CAST (AVG(PopDensity) AS INT) AS Avg_Density,
    CAST(AVG(GDP) AS INT) AS Avg_GDP_Per_Capita,
    COUNT(*) AS Number_of_Countries
FROM world
WHERE GDP > 0 AND PopDensity > 0
GROUP BY Region
HAVING Number_of_Countries > 5 -- considering only regions with more than 5 countries for a more reliable average
ORDER BY Avg_GDP_Per_Capita DESC;


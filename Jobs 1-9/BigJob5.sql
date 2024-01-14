/* BIG JOB 5 5*/

CREATE TABLE emissions (
    Source VARCHAR(100),
    Min_gCO2_per_kWh FLOAT,
    Median_gCO2_per_kWh FLOAT,
    Max_gCO2_per_kWh FLOAT
);

INSERT INTO emissions (Source, Min_gCO2_per_kWh, Median_gCO2_per_kWh, Max_gCO2_per_kWh) 
VALUES 
    ('Charbon', 740, 820, 910),
    ('Gaze naturel', 410, 490, 650),
    ('Pétrole', 620, 740, 890),
    ('Hydro', 1, 24, 2200),
    ('Renouvelable (Solaire)', 26, 41, 60),
    ('Nucléaire', 3.7, 12, 110);
    
---
WITH EmissionsBySource AS (
    SELECT 
        SUM(CASE WHEN e.Source = 'Charbon' THEN c.Coal / 100 * e.Median_gCO2_per_kWh ELSE 0 END) AS CharbonEmissions,
        SUM(CASE WHEN e.Source = 'Gaze naturel' THEN c.Gas / 100 * e.Median_gCO2_per_kWh ELSE 0 END) AS GasEmissions,
        SUM(CASE WHEN e.Source = 'Pétrole' THEN c.Oil / 100 * e.Median_gCO2_per_kWh ELSE 0 END) AS OilEmissions,
        SUM(CASE WHEN e.Source = 'Hydro' THEN c.Hydro / 100 * e.Median_gCO2_per_kWh ELSE 0 END) AS HydroEmissions,
        SUM(CASE WHEN e.Source = 'Renouvelable (Solaire)' THEN c.Renewable / 100 * e.Median_gCO2_per_kWh ELSE 0 END) AS RenewableEmissions,
        SUM(CASE WHEN e.Source = 'Nucléaire' THEN c.Nuclear / 100 * e.Median_gCO2_per_kWh ELSE 0 END) AS NuclearEmissions
    FROM 
        country c
    JOIN 
        emissions e ON e.Source IN ('Charbon', 'Gaze naturel', 'Pétrole', 'Hydro', 'Renouvelable (Solaire)', 'Nucléaire')
),
TotalEmissions AS (
    SELECT 
        (CharbonEmissions + GasEmissions + OilEmissions + HydroEmissions + RenewableEmissions + NuclearEmissions) AS GrandTotal
    FROM 
        EmissionsBySource
)
SELECT 
    ROUND((SELECT CharbonEmissions FROM EmissionsBySource) / (SELECT GrandTotal FROM TotalEmissions) * 100, 2) AS CharbonPercentage,
    ROUND((SELECT GasEmissions FROM EmissionsBySource) / (SELECT GrandTotal FROM TotalEmissions) * 100, 2) AS GasPercentage,
    ROUND((SELECT OilEmissions FROM EmissionsBySource) / (SELECT GrandTotal FROM TotalEmissions) * 100, 2) AS OilPercentage,
    ROUND((SELECT HydroEmissions FROM EmissionsBySource) / (SELECT GrandTotal FROM TotalEmissions) * 100, 2) AS HydroPercentage,
    ROUND((SELECT RenewableEmissions FROM EmissionsBySource) / (SELECT GrandTotal FROM TotalEmissions) * 100, 2) AS RenewablePercentage,
    ROUND((SELECT NuclearEmissions FROM EmissionsBySource) / (SELECT GrandTotal FROM TotalEmissions) * 100, 2) AS NuclearPercentage
FROM 
    TotalEmissions;

   
----
   
DROP VIEW CountryEmissionsView;

CREATE VIEW CountryEmissionsView AS
SELECT 
    combined.Country,
    e.Source,
    CASE 
        WHEN e.Source = 'Charbon' THEN combined.Coal
        WHEN e.Source = 'Gaze naturel' THEN combined.Gas
        WHEN e.Source = 'Pétrole' THEN combined.Oil
        WHEN e.Source = 'Hydro' THEN combined.Hydro
        WHEN e.Source = 'Renouvelable (Solaire)' THEN combined.Renewable
        WHEN e.Source = 'Nucléaire' THEN combined.Nuclear
        ELSE 0
    END AS UsagePercentage,
    e.Median_gCO2_per_kWh AS MedianEmission,
    (CASE 
        WHEN e.Source = 'Charbon' THEN combined.Coal
        WHEN e.Source = 'Gaze naturel' THEN combined.Gas
        WHEN e.Source = 'Pétrole' THEN combined.Oil
        WHEN e.Source = 'Hydro' THEN combined.Hydro
        WHEN e.Source = 'Renouvelable (Solaire)' THEN combined.Renewable
        WHEN e.Source = 'Nucléaire' THEN combined.Nuclear
        ELSE 0
    END / 100) * e.Median_gCO2_per_kWh AS Contribution,
    e.Min_gCO2_per_kWh AS MinEmission,
    (CASE 
        WHEN e.Source = 'Charbon' THEN combined.Coal
        WHEN e.Source = 'Gaze naturel' THEN combined.Gas
        WHEN e.Source = 'Pétrole' THEN combined.Oil
        WHEN e.Source = 'Hydro' THEN combined.Hydro
        WHEN e.Source = 'Renouvelable (Solaire)' THEN combined.Renewable
        WHEN e.Source = 'Nucléaire' THEN combined.Nuclear
        ELSE 0
    END / 100) * e.Min_gCO2_per_kWh AS MinContribution,
    e.Max_gCO2_per_kWh AS MaxEmission,
    (CASE 
        WHEN e.Source = 'Charbon' THEN combined.Coal
        WHEN e.Source = 'Gaze naturel' THEN combined.Gas
        WHEN e.Source = 'Pétrole' THEN combined.Oil
        WHEN e.Source = 'Hydro' THEN combined.Hydro
        WHEN e.Source = 'Renouvelable (Solaire)' THEN combined.Renewable
        WHEN e.Source = 'Nucléaire' THEN combined.Nuclear
        ELSE 0
    END / 100) * e.Max_gCO2_per_kWh AS MaxContribution
FROM 
    (SELECT Country, Coal, Gas, Oil, Hydro, Renewable, Nuclear FROM country
     UNION
     SELECT Country, Coal, Gas, Oil, Hydro, Renewable, Nuclear FROM world) combined
JOIN 
    emissions e ON e.Source IN ('Charbon', 'Gaze naturel', 'Pétrole', 'Hydro', 'Renouvelable (Solaire)', 'Nucléaire')
WHERE
    (e.Source = 'Charbon' AND combined.Coal IS NOT NULL
     OR e.Source = 'Gaze naturel' AND combined.Gas IS NOT NULL
     OR e.Source = 'Pétrole' AND combined.Oil IS NOT NULL
     OR e.Source = 'Hydro' AND combined.Hydro IS NOT NULL
     OR e.Source = 'Renouvelable (Solaire)' AND combined.Renewable IS NOT NULL
     OR e.Source = 'Nucléaire' AND combined.Nuclear IS NOT NULL);

--
    
DROP VIEW TotalCountryEmissionsView;
    
CREATE VIEW TotalCountryEmissionsView AS
SELECT 
	Country, 
	ROUND(SUM(Contribution), 2) AS Total_Contribution,
	ROUND(SUM(MinContribution), 2) AS Total_Min_Contribution,
	ROUND(SUM(MaxContribution), 2) AS Total_Max_Contribution
FROM CountryEmissionsView GROUP BY Country ORDER BY Total_Contribution;

----

SELECT *
FROM TotalCountryEmissionsView ORDER BY Total_Max_Contribution DESC;

SELECT MIN(Total_Min_Contribution) FROM TotalCountryEmissionsView;
SELECT MAX(Total_Max_Contribution) FROM TotalCountryEmissionsView;


SELECT * FROM TotalCountryEmissionsView WHERE Total_Contribution = (SELECT MIN(Total_Contribution) FROM TotalCountryEmissionsView);


SELECT MIN(tcev.Total_Contribution)
FROM TotalCountryEmissionsView tcev
INNER JOIN country c ON tcev.Country = c.Country;
-- All Countries		World-world			Total Median
-- AVG MIN = 344		MIN = 417.27		MIN = 23.48
-- AVG MED = 406		MED = 477.54		MED = 
-- AVG MAX = 1100		MAX = 918.92		MAX = 816.64


SELECT ROUND(SUM(Contribution), 2) AS Total_Contribution FROM CountryEmissionsView WHERE Country = 'Switzerland';

SELECT "Source", UsagePercentage, MedianEmission, ROUND(Contribution, 2) AS Contribution FROM CountryEmissionsView WHERE Country = 'Switzerland';



SELECT tcev.Country, tcev.Total_Contribution
FROM TotalCountryEmissionsView tcev
INNER JOIN world w ON tcev.Country = w.Country;

SELECT cev.* FROM CountryEmissionsView cev INNER JOIN world w ON cev.Country = w.Country;

SELECT cev.* FROM TotalCountryEmissionsView cev INNER JOIN world w ON cev.Country = w.Country;

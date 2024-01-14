/* BIG JOB 2, 3*/
CREATE TABLE world (
    Country VARCHAR(255),
    Coal FLOAT,
    Gas	FLOAT,
    Oil	FLOAT,
    Hydro FLOAT,
    Renewable FLOAT,
    Nuclear FLOAT
);

CREATE TABLE country (
    Country VARCHAR(255),
    Coal FLOAT,
    Gas	FLOAT,
    Oil	FLOAT,
    Hydro FLOAT,
    Renewable FLOAT,
    Nuclear FLOAT
);

-- Number of countries using various energy sources.
SELECT 
	(SELECT COUNT(Country) FROM country WHERE Nuclear > 0) AS nuclear,
	(SELECT COUNT(Country) FROM country WHERE Coal > 0) AS coal,
	(SELECT COUNT(Country) FROM country WHERE Renewable > 0) AS renew,
	(SELECT COUNT(Country) FROM country WHERE Gas > 0) AS gas,
	(SELECT COUNT(Country) FROM country WHERE Hydro > 0) AS hydro,
	(SELECT COUNT(Country) FROM country WHERE Oil > 0) AS oil,
	(SELECT COUNT(Country) FROM country) AS Total_Countries
FROM country
LIMIT 1;

-- Countries using all other energy sources except Coal
SELECT * 
FROM country 
WHERE 
	Coal = 0 AND 
	Gas > 0 AND 
	Oil > 0 AND 
	Hydro > 0 AND 
	Renewable > 0 AND 
	Nuclear > 0 
ORDER BY Coal DESC;

-- Countries using all other energy sources except Gas
SELECT * 
FROM country 
WHERE 
	Coal > 0 AND 
	Gas = 0 AND 
	Oil > 0 AND 
	Hydro > 0 AND 
	Renewable > 0 AND 
	Nuclear > 0 
ORDER BY Gas DESC;

-- Countries using all other energy sources except Oil
SELECT * FROM country WHERE Coal > 0 AND Gas > 0 AND Oil = 0 AND Hydro > 0 AND Renewable > 0 AND Nuclear > 0 ORDER BY Gas DESC;

SELECT Count(Country) AS 'Countries not using renewable and hydro energy'
FROM country 
WHERE 
	Hydro = 0 AND 
	Renewable = 0;
-- 100 % of countries that are not using renewable and hydro energy, are also not using Nuclear energy. 


SELECT COUNT(Country)
FROM country 
WHERE 
	Hydro = 0 AND 
	Renewable = 0 AND 
	Coal = 0;

SELECT COUNT(Country)
FROM country 
WHERE 
	Hydro = 0 AND 
	Renewable = 0 AND 
	Coal > 0;

SELECT *
FROM country 
WHERE Coal > 80
ORDER BY Coal DESC;

-- Countries powered only by Gas
SELECT * FROM country WHERE Gas == 100;

-- Countries mostly powered by Oil
SELECT * FROM country WHERE Oil > 99 ORDER BY Oil DESC;

-- Countries 100% powered with Hydro energy
SELECT * FROM country WHERE Hydro == 100;

-- Countries consuming more than half of energy needs from Renewable sources
SELECT *
FROM country 
WHERE Renewable > 50;

-- Countries consuming more than half of energy needs from Nuclear sources
SELECT *
FROM country 
WHERE Nuclear > 50
ORDER BY Nuclear DESC;

SELECT *
FROM country 
WHERE
	Renewable > 30 AND
	Hydro > 30;

-- Countries mostly consuming energy produced from Hydro or Renewable sources
SELECT *
FROM country 
WHERE
	(Renewable + Hydro) > 99
ORDER BY Hydro;

SELECT 'Country' as Source, Country FROM country UNION ALL SELECT 'World' as Source, Country FROM world ORDER BY Source DESC, Country;



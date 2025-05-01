-- Create Database

.open moorea-LTER.db

-- Reset tables
DROP TABLE Abundance;
DROP TABLE Water_temp;

-- Create Abundance table
CREATE TABLE Abundance (
  year INT NOT NULL,
  site VARCHAR NOT NULL,
  habitat VARCHAR NOT NULL,
  transect INT NOT NULL,
  UNIQUE (year, site, habitat, transect),
  a_planci_counts INT NOT NULL
);

COPY Abundance FROM 'clean-data/ac_abundance_cleaned.csv' (header TRUE);

-- Create Water_temp table
CREATE TABLE Water_temp (
  site VARCHAR NOT NULL,
  time_local DATE NOT NULL,
  reef_type_code VARCHAR NOT NULL,
  sensor_type VARCHAR NOT NULL,
  sensor_depth_m INT NOT NULL,
  temperature_c REAL NOT NULL,
  year INT NOT NULL
);

COPY Water_temp FROM 'clean-data/benthic_water_temp_cleaned.csv' (header TRUE);

-- Look at data
SELECT * FROM Abundance;
SELECT * FROM Water_temp;

-- Answer questions
--- How does benthic water temperature relate to crown of thorn abundance? By habitat type?

-- Sum abundance by year and site
CREATE TABLE sum_abundance AS (
  SELECT year, site, SUM(a_planci_counts) AS abundance
  FROM Abundance
  GROUP BY year, site
);

-- Average water temp by year and site
CREATE TABLE avg_temp AS (
  SELECT year, site, AVG(temperature_c) AS avg_temp
  FROM Water_temp
  GROUP BY year, site
);

CREATE TABLE temp_abundance AS (
  SELECT site, year, avg_temp, abundance 
  FROM avg_temp 
  JOIN sum_abundance USING (site, year)
  GROUP BY site, year, avg_temp, abundance
);

-- Group by site over all years
SELECT site, AVG(avg_temp) AS avg_temp, SUM(abundance) AS abundance
  FROM temp_abundance
  GROUP BY site;

-- Look at LTER01 site over all years
SELECT site, year, avg_temp, SUM(abundance) AS abundance
FROM temp_abundance
WHERE site = 'LTER01'
GROUP BY site, year, avg_temp
ORDER BY year DESC;

CREATE TABLE Final_table AS(
SELECT site, year, avg_temp, SUM(abundance) AS abundance
FROM temp_abundance
GROUP BY site, year, avg_temp
ORDER BY year DESC
);

-- by habitat type
--- Sum abundance by year and habitat
CREATE TEMP TABLE sum_abundance_habitat AS (
  SELECT year, habitat, SUM(a_planci_counts) AS abundance
  FROM Abundance
  GROUP BY year, habitat
);

SELECT * FROM sum_abundance_habitat;

-- average water temp by year and habitat
CREATE TEMP TABLE avg_temp_habitat AS (
  SELECT year, reef_type_code, AVG(temperature_c) AS avg_temp
  FROM Water_temp
  GROUP BY year, reef_type_code
);

-------------------------------------------------------

CREATE TABLE temp_abundance AS (
  SELECT site, year, avg_temp, abundance 
  FROM avg_temp 
  JOIN sum_abundance USING (site, year)
  GROUP BY site, year, avg_temp, abundance
);

-- group by site over all years
SELECT site, AVG(avg_temp) AS avg_temp, SUM(abundance) AS abundance
  FROM temp_abundance
  GROUP BY site;

-- look at LTER01 site over all years
SELECT site, year, avg_temp, SUM(abundance) AS abundance
FROM temp_abundance
WHERE site = 'LTER01'
GROUP BY site, year, avg_temp
ORDER BY year DESC;

CREATE TABLE Final_table AS(
SELECT site, year, avg_temp, SUM(abundance) AS abundance
FROM temp_abundance
GROUP BY site, year, avg_temp
ORDER BY year DESC
);

-- Create Database

.open moorea-LTER.db

DROP TABLE Abundance;
DROP TABLE Water_temp;

CREATE TABLE Abundance (
  year INT NOT NULL,
  site VARCHAR NOT NULL,
  habitat VARCHAR NOT NULL,
  transect INT NOT NULL,
  UNIQUE (year, site, habitat, transect),
  a_planci_counts INT NOT NULL
);

COPY Abundance FROM 'clean-data/ac_abundance_cleaned.csv' (header TRUE);

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

-- look at data
SELECT * FROM Abundance;
SELECT * FROM Water_temp;

-- answer questions
--- How does benthic water temperature relate to crown of thorn abundance? By habitat type?

-- Sum abundance by year and site
CREATE TABLE sum_abundance AS (
  SELECT year, site, SUM(a_planci_counts) AS abundance
  FROM Abundance
  GROUP BY year, site
);

-- average water temp by year and site
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


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
--- Does benthic water temperature correlate with crown of thorns abundance?

CREATE TABLE final_year AS (
  SELECT 
  at.year,
  at.site, 
  AVG(at.avg_temp) AS avg_temp, 
  SUM(sa.abundance) AS abundance
FROM (
  SELECT site, year, AVG(temperature_c) AS avg_temp
  FROM Water_temp
  GROUP BY site, year
) at
JOIN (
  SELECT site, year, SUM(a_planci_counts) AS abundance
  FROM Abundance
  GROUP BY site, year
) sa USING (site, year)
GROUP BY at.site, at.year
);

-- check
SELECT * FROM final_year;


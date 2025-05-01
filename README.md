# Moorea LTER SQL Analysis

### Authors

Carmen Hoyt [@ceh58](https://github.com/ceh58)

## About 

This repository hosts the code for creating a SQL database for Moorea LTER data, specifically benthic water temperature and Acanthaster planci abundance counts, and the resulting analysis.

## Data

Data was downloaded as .csv files from the [Moorea LTER catalog](https://mcr.lternet.edu/data).

Two time series were selected:

1. [Benthic water temperature](https://portal.edirepository.org/nis/metadataviewer?packageid=knb-lter-mcr.1035.16):
  - 2005-2023
  - temp (C)
  - sites 1-6 (each as individual .csv files)

2. [Population Dynamics of Acanthaster planci (crown of thorns starfish)](https://portal.edirepository.org/nis/metadataviewer?packageid=knb-lter-mcr.1039.11):
  - 2005-2022
  - counts
  - sites 1-6 (one .csv file)

Data was housed in a moorea-LTER-data/ folder, cleaned in R, and loaded in to moorea_LTER.db using DuckDB. 

## Repository Structure

```
├── .gitignore
├── moorea_LTER-data/ # data not pushed to github due to size
|    ├── benthic-water-temp/
|    |    ├── MCR_LTER01_BottomMountThermistors_20230323.csv
|    |    ├── MCR_LTER02_BottomMountThermistors_20230323.csv
|    |    ├── MCR_LTER03_BottomMountThermistors_20230323.csv
|    |    ├── MCR_LTER04_BottomMountThermistors_20230323.csv
|    |    ├── MCR_LTER05_BottomMountThermistors_20230323.csv
|    |    └── MCR_LTER06_BottomMountThermistors_20230323.csv
|    ├── MCR_LTER_COTS_abundance_2005-2022_20220503.csv
|    ├── ac_abundance_cleaned.csv
|    └── benthic_water_temp_cleaned.csv
├── moorea_LTER.db # database not pushed to github due to size
|    ├── Abundance
|    ├── Water_temp
|    └── Water_abundance_combined
├── eds-213-discussion.Rproj
├── moorea-LTER.qmd
└── moorea_LTER.sql
```

<img src="starfish.png" alt="starfish" style="width:50%;">

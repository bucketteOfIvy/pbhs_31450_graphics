library(tidycensus)
library(sf)
library(tmap)
library(tigris)
library(dplyr)
library(stringr)

# all tracts in this file intersect with dolton
dolton_tractce <- read.csv('../data/2000_dolton_industry.csv') |> 
  select(Geo_STATE, Geo_COUNTY, Geo_CT) |>
  mutate(GEOID = paste0(
    str_pad(Geo_STATE, 2, 'left', '0'),
    str_pad(Geo_COUNTY, 3, 'left', '0'),
    str_pad(Geo_CT, 6, 'left', '0')))

tigris::tracts(state='il', county='cook', year=2010) |>
  filter(GEOID10 %in% dolton_tractce$GEOID) |>
  st_write('../data/shapes/dolton_tracts.shp')
  

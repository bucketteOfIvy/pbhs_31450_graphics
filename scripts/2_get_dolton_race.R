library(oepsData)
library(sf)
library(dplyr)
library(stringr)

dolton_shapes <- st_read('../data/shapes/dolton_tracts.shp')

dolton_race_2010 <- oepsData::load_oeps('tract', 2010, 'social', 'il', 'cook') |>
  select('GEOID', "TotPop10"='TotPop', "WhiteP10"='WhiteP', "BlackP10"='BlackP') |>
  filter(as.character(GEOID) %in% dolton_shapes$GEOID10)

dolton_race_2000 <- oepsData::load_oeps('tract', 2000, 'social', 'il', 'cook') |>
  select('GEOID', "TotPop00"='TotPop', "WhiteP00"='WhiteP', "BlackP00"='BlackP')|>
  filter(as.character(GEOID) %in% dolton_shapes$GEOID10)

dolton_race_1990 <- oepsData::load_oeps('tract', 1990, 'social', 'il', 'cook') |>
  select('GEOID', "TotPop90"='TotPop', "WhiteP90"='WhiteP', "BlackP90"='BlackP')|>
  filter(as.character(GEOID) %in% dolton_shapes$GEOID10)

dolton_race_1980 <- oepsData::load_oeps('tract', 1980, 'social', 'il', 'cook') |>
  select('GEOID', "TotPop80"='TotPop', "WhiteP80"='WhiteP', "BlackP80"='BlackP')|>
  filter(as.character(GEOID) %in% dolton_shapes$GEOID10)

dolton_race_2018 <- oepsData::load_oeps('tract', 2018, 'social', 'il', 'cook') |>
  select('GEOID', "TotPop18"='TotPop', "WhiteP18"='WhiteP', "BlackP18"='BlackP')|>
  filter(as.character(GEOID) %in% dolton_shapes$GEOID10)

dolton_race <- merge(dolton_race_1980, dolton_race_1990, by='GEOID') |>
  merge(dolton_race_2000, by='GEOID') |>
  merge(dolton_race_2010, by='GEOID') |>
  merge(dolton_race_2018, by='GEOID')

dolton_race |> write.csv('../data/dolton_blackwhite_longitudinal.csv', row.names=F)


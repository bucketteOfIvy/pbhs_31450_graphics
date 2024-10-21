library(dplyr)
library(tidyr)

dolton1980 <- read.csv('../data/1980_dolton_industry.csv') |>
  mutate(GEOID = paste0(
    str_pad(Geo_STATE, 2, 'left', '0'),
    str_pad(Geo_COUNTY, 3, 'left', '0'),
    str_pad(Geo_CT, 6, 'left', '0'))) |>
  select(GEOID, WorkingPop80=SE_T050_001, 
         Manufacturing80=SE_T050_004)

dolton1990 <- read.csv('../data/1990_dolton_industry.csv') |>
  mutate(GEOID = paste0(
    str_pad(Geo_STATE, 2, 'left', '0'),
    str_pad(Geo_COUNTY, 3, 'left', '0'),
    str_pad(Geo_CT, 6, 'left', '0')),
    Manufacturing90=SE_T038_005 + SE_T038_006) |>
  select(GEOID, WorkingPop90=SE_T038_001,
         Manufacturing90)

dolton2000 <- read.csv('../data/2000_dolton_industry.csv') |>
  mutate(GEOID = paste0(
    str_pad(Geo_STATE, 2, 'left', '0'),
    str_pad(Geo_COUNTY, 3, 'left', '0'),
    str_pad(Geo_CT, 6, 'left', '0'))) |>
  select(GEOID, WorkingPop00=SE_T083_001,
         Manufacturing00=SE_T083_006)

dolton2010 <- tidycensus::get_acs('tract',
                                  year=2012,
                                  variables=c('WorkingPop10'="C24050_001",
                                              "Manufacturing10"="C24050_004"),
                                  state="illinois",
                                  county='cook',
                                  tidy=F) |>
  filter(GEOID %in% dolton2000$GEOID) |>
  select(-'moe') |>
  pivot_wider(names_from='variable', values_from='estimate')  |>
  select('GEOID', 'WorkingPop10', 'Manufacturing10')

dolton2018 <- tidycensus::get_acs('tract', 
                                  year=2020,
                                  variables=c('WorkingPop18'="C24050_001",
                                              "Manufacturing18"="C24050_004"),
                                  state="illinois",
                                  county='cook',
                                  tidy=F) |>
  filter(GEOID %in% dolton2000$GEOID) |>
  select(-'moe') |>
  pivot_wider(names_from='variable', values_from='estimate') |>
  select('GEOID', 'WorkingPop18', 'Manufacturing18')

doltonIndustry <- merge(dolton1980, dolton1990, by='GEOID') |>
  merge(dolton2000, by='GEOID') |>
  merge(dolton2010, by='GEOID') |>
  merge(dolton2018, by='GEOID') 

write.csv(doltonIndustry, '../data/doltonIndustry.csv', row.names=F)

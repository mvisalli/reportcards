install.packages('devtools')
library(tidyverse)
library(devtools)
#devtools::install_github("mvisalli/shipr")
library(shipr)
library(leaflet)
library(sf)
library(dplyr)
library(lubridate)
library(readr)


data(sbais)

sbais_clipped <- sbais %>% 
  filter(lon >= -121.025050 & lon <= -117.499967,
         lat >= 33.301100 & lat <= 34.573833,
         speed <=50) %>% 
  group_by(mmsi)%>% 
  arrange(datetime, .by_group = TRUE) %>%
  filter(!duplicated(round_date(datetime, unit="minute"))) %>% 
  st_as_sf(coords=c("lon","lat"), crs = 4326) %>%
  ungroup()

pal <- colorNumeric(
  palette = colorRampPalette(c('green', 'red'))(sbais_clipped$speed), 
  domain = sbais_clipped$speed)


#Pacific Kindness data
sbais_pk <- sbais %>% 
  filter(lon >= -121.025050 & lon <= -117.499967,
         lat >= 33.301100 & lat <= 34.573833,
         speed <=50,
         name == 'PACIFIC KINDNESS') %>% 
  st_as_sf(coords=c("lon","lat"), crs = 4326)

#Pacific Kindness map
bins_pk <- c(0,10,15)

pal_pk_pts <- colorBin( c('green', 'red'),
                    domain= sbais_pk$speed,
                    bins = bins_pk,
                    na.color = 'black')

map_pk <- leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data=sbais_pk,
                   radius = 0.5,
                   label = ~sprintf("%f knots - %s",speed,name),
                   color=~pal_pk_pts(speed))
map_pk

segs_pk <- get_ship_segments(sbais, "PACIFIC KINDNESS", dir_data="data")
segs_pk_rds<-read_rds('data/ship/PACIFIC KINDNESS_segments.rds')

segs_pk_rds<- mutate(segs_pk_rds,
       seg_kts = seg_kmhr*0.539957)

bins_pk <- c(0,10,15)

pal_pk_lns <- colorBin( c('green', 'red'),
                        domain= segs_pk_rds$seg_kts,
                        bins = bins_pk,
                        na.color = 'black')

map_pk2 <- leaflet() %>%
  addTiles() %>%
  addPolygons(data=segs_pk_rds,
                   label = ~sprintf("%f knots - %s",seg_kts,name),
                   color=~pal_pk_lns(seg_kts))%>%
  addCircleMarkers(data=sbais_pk,
                   radius = 2,
                   label = ~sprintf("%f knots - %s",speed,name),
                   color=~pal_pk_pts(speed))

map_pk2

sbais_pk_full <- filter(sbais, name=="PACIFIC KINDNESS")

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


sbais_ci<-readRDS("data/sbais_ci.RDS") %>% 
  arrange(datetime) %>%
  filter(!duplicated(round_date(datetime, unit="minute"))) %>% 
  st_as_sf(coords=c("lon","lat"), crs = 4326)

bins_ci <- c(0,10,11,12,15,20)

pal_ci <- colorBin( "YlOrRd",
                    domain= sbais_ci$speed,
                    bins = bins_ci,
                    na.color = 'black')

map_ci <- leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data=sbais_ci,
                   radius = 0.5,
                   label = ~sprintf("%f knots - %s",speed,datetime),
                   color=~pal_ci(speed))
map_ci

#######

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

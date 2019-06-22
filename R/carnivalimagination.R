#install.packages('devtools')
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





sbais062019<-readRDS("data/sbais062019.RDS") %>% 
  filter(lon >= -118.795374 & lon <= -117.707252,
         lat >= 33.080975 & lat <= 33.680974)%>%
  arrange(datetime) %>%
  st_as_sf(coords=c("lon","lat"), crs = 4326)

bins_ci <- c(0,10,11,12,15,20)

pal_sbais062019 <- colorBin( "YlOrRd",
                    domain= sbais062019$speed,
                    bins = bins_ci,
                    na.color = 'black')

map_sbais062019 <- leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data=sbais062019,
                   radius = 0.5,
                   label = ~sprintf("%f knots - %s %s",speed,datetime,name),
                   color=~pal_sbais062019(speed))
map_sbais062019

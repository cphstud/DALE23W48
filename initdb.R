library(jsonlite)
library(mongolite)
library(dplyr)
library(stringr)
library(DBI)
library(RMariaDB)

condb <- dbConnect(MariaDB(),
                   db="dalbilbasen",
                   host="localhost",
                   port=3306,
                   user="root",
                   password=Sys.getenv("MYPW"))

args <- commandArgs(trailingOnly = TRUE)
sf = args[1]
newcars = read.csv(sf)
head(newcars)


mycars <- newcars %>% select(-price)
dbWriteTable(condb,"cars",mycars)

#pricehistory
pricehist <- newcars %>% select(car_id,price) %>% mutate(sold=F,scrapedate=as.Date('2023-11-11'))
dbWriteTable(condb,"pricehistory",pricehist, overwrite=T)

dbDisconnect(condb)


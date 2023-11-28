library(jsonlite)
library(mongolite)
library(dplyr)
library(stringr)
library(DBI)
library(RMariaDB)
library(lubridate)

condb <- dbConnect(MariaDB(),
                   db="dalbilbasen",
                   host="localhost",
                   port=3306,
                   user="root",
                   password=Sys.getenv("MYPW"))

args <- commandArgs(trailingOnly = TRUE)
sf = args[1]
mycars = read.csv(sf)
#mycars <- newcars %>% select(-price)

# get oldones
q='select * from getlatest'	
lastrun = dbGetQuery(condb,q)
oldcomp = lastrun %>% select(-c(scrapedate,sold))

# fundet de nye
sold = anti_join(oldcomp,mycars,by="car_id")
# fundet de solgte
new = anti_join(mycars,oldcomp,by="car_id")
head(sold, n=2)
print("---")
head(new, n=2)

#dbDisconnect(condb)
#stop("done")
# mulige prisændringer
identicforpricecompare = inner_join(oldcomp,mycars,by="car_id")
head(identicforpricecompare, n=2)
#dbDisconnect(condb)
#stop("done")
pricech= identicforpricecompare %>% select(car_id,price.x,price.y)

#Prepare update database
#nye biler stamdata i cars og prisinfo i pricehistory
newsd <- new %>% select(-price)
dbWriteTable(condb,"cars",newsd,append=T)
#newph <- new %>% select(c(car_id,price)) %>% mutate(sold=F,scrapedate=as.Date('2023-11-12'))
newph <- new %>% select(c(car_id,price)) %>% mutate(sold=F,scrapedate=as.Date('2023-11-12'))
dbWriteTable(condb,"pricehistory",newph,append=T)

#solgte biler prisinfo sættes med sold=T og scraptedate
soldph <- sold %>% select(car_id) %>% mutate(sold=T,scrapedate=as.Date('2023-11-12'))
dbWriteTable(condb,"pricehistory",soldph,append=T)

# ændrede priser?
priceph <- pricech %>% filter(price.x!=price.y) %>%
  mutate(sold=F,scrapedate=as.Date('2023-11-12'),price=price.y) %>%
  select(-c(price.x,price.y))
dbWriteTable(condb,"pricehistory",priceph,append=T)


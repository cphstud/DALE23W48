library(rvest)
library(dplyr)
library(DBI)
library(RMariaDB)
library(httr)

# connect
cd <- dbConnect(MariaDB(),
                host="localhost",
                db="deauto",
                user="root",
                password="root123"
)

baseurl <- "https://www.autoscout24.de/lst/bmw/3er-(alle)?adage=1&atype=C&cy=D&damaged_listing=exclude&desc=0&ocs_listing=include&powertype=kw&priceto=20000&search_id=1r2b3eom0vv&sort=standard&source=listpage_pagination&page="
myA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'

mtag=""
totdf = data.frame()

# ONE TIME RUN FOR TEST
testpage = GET(url, add_headers('User-Agent'= myA), config(verbose = TRUE))
dftestpage <- testpage %>% content(as="text")


# LOOP
#for (i in 1:7) {
# url <- paste0(baseurl,i)
# lpage = GET()
# sleep
# dfall <- lpage %>% content(as="text")
# allcars <- read_html(dfall) 
# brtlist = list()
# for (i in (1:length(allcars))) {
#   brutlist[[i]] <- allInfo
# }
# dataframe <- do.call(rbind, brutlist)
# totdf <- rbind(totdf,dataframe)
#
# prep for compare
dfdb <- totdf[,c(1,5,6,7,10,11,14,17,18,19,20,21)]
cnames=c("car_id","customer_id","type","pricelabel","price","make","sellertype","zip","milage","fueltype","model","reg")
colnames(dfdb)=cnames

# get latest stuff
query <- "select * from getlatestde"
latestdf <- dbGetQuery(cd,query)

#prep diff
newcars <- anti_join()
soldcars <- anti_join()
changedcars <- inner_join() %>% 
  filter()

#prep db writ
chn=c("price","pricelabel","car_id","scrapedate","sold")
colnames(dfpricehistchg)=chn


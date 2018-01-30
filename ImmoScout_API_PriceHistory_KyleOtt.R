## June 22, 2016
## Author: Kyle Ott
## Adopted from Python code for ImmobilienScout24 RestAPI
## Using the PriceHistory API, but could easily work for other APIs offered by ImmoScout
## Price History API: https://api.immobilienscout24.de/our-apis/valuation/pricehistory-api.html
## This script will guide you how to get normalized price housing price histories for a location's given neighborhood and/or municipality in Germany
## You must geocode your addresses before using this API

library('httr')
library('jsonlite')
library('base64enc')
library('tidyr')
library('reshape2')
library('foreign')

options(httr_oauth_cache = TRUE)

options(scipen=999)

# Keys, but it's better to set up 
# environment variables via 'Sys.setenv'
# To get an API key, visit: https://api.immobilienscout24.de/get-started.html
consumerKey    <- '[insert your key]'
consumerSecret <- '[insert your secret]'
tokenGenerated <- '[insert token generated]'
tokenSecret    <- '[insert token secret]'


# start authorization process for the app
myapp <- oauth_app("app", key = consumerKey, secret = consumerSecret)

# Deprecated. Instead create a config object directly using config(token = my_token). 
sig <- sign_oauth1.0(myapp, token = tokenGenerated, token_secret = tokenSecret)


## For this example, I am only looking at addresses in Bonn, here's an example of determining how ImmoScout codes cities and neighborhoods

region <- 'https://rest.sandbox-immobilienscout24.de/restapi/api/marketdata/v1.0/pricehistory/region/10/city'

# requesting all ranges of prices, if you don't request 10 different URLs, you will not get the full dataset of housing prices
url8 <- read.csv("[CSV file with all of the API links you want]", header=T)



B_geo_df1 <- data.frame()


for (i in url8$url8) {
  URL <- paste0(i)
  message(URL)
  y  <- GET(URL, sig)
  possibleError <- tryCatch(
    y1 <- fromJSON(rawToChar(y$content))$averagePricePerSqm,
    error=function(e) e
  )
  if(!inherits(possibleError, "error")){
    #REAL WORK
    y1 <- fromJSON(rawToChar(y$content))$averagePricePerSqm
    B_geo_df1 <- rbind(B_geo_df1, y1)
    #names(B_geo_df1)[1] <- "price"
    z1 <- URL
    B_geo_df1 <- rbind(B_geo_df1, z1)
    Sys.sleep(2)
  }
}


write.csv(B_geo_df1, file = "FILENAME.csv")




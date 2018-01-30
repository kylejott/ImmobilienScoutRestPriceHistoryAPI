# A basic script in R for how to pull data from ImmobilienScout24's Rest Price History API
ImmobilienScout24 is Germany's largest real estate website (akin to Zillow). Their API documentation hasn't been updated in ages and does not have formal support for those who wish to access it via R. There are some examples in Python, but since I am not familiar with that and I needed to access their data, I went ahead and figured out how to obtain data using R.

# Geocode addresses ahead of time

It's complicated to geocode addresses using ImmobilienScout's API -- so I used Google and/or the Data Science Kit (which is essentially the Open Street Map) to geocode my list of addresses (for this project that was about 5,000 unique addresses).

# Fun w/ ImmoScout

The final script I wrote in R to scrape the Immo data is called:
ImmoScout_API_PriceHistory_KyleOtt.R

## First, you have to go to the ImmoScout “Playground”
https://playground.immobilienscout24.de/rest/playground

Here, you enter our own consumer key and secret and select “live”:
consumerKey    <- 'SECRET KEY'
consumerSecret <- 'SUPER SECRET KEY'

Then scroll down to see oAuth-Frame* and click request token. The tokens should generate in the empty boxes. Next, click “authorize” below and you should be taken to a log in page. You can use any ImmoScout log-in (it's easy to generate a log-in). Authorize and it will take you back to the playground. Now, click the last orange box called “access token”, this will give you the access token and token secret which is needed to preform the O-auth in R Studio (you just copy and paste these two strings). You can test API URLS in the URL box on the playground now and if you enter a correct URL, it will give you actual output. Always select JSON and GET as options (no idea why, but based on the forums I've read, this is how you should go about things).

## ImmoScout’s Reference API 

Use this API to get current housing price data. Their “codebook” of how to use the Reference API and what kind of output you can get is here:

http://api.immobilienscout24.de/our-apis/valuation/reference-price-api.html

The documentation is sparse and not very helpful and they have incomplete information for the kinds of URLS you should request Important things to know:

•	The housing data is based on rental apartments
•	The assumed living area is 100 square meters
•	The price is the price per square meter in a given neighborhood
•	ImmoScout does not specify, but this should be 2016 data. When I was looking into manually getting the data, by looking up an address and scrolling down to “historical information,” the most current date they have housing data is for March 2016, so I assume that our data is current as of March 2016 (your old data is from 2011, just FYI)
•	ImmoScout now only lists price information by one decimal (previously it was two)

With this, I ran a R script, ImmoScout_API_PriceHistory_JUNE_LAB, overnight in the computer lab at Hertie. It’s a simple script that logs into our API key and gets access and authorization to get “live” data from ImmoScout. Then, I import a csv file which has the universe of our geocoded addresses (I eliminated duplicates). In this file there are 10 unique API URL links per geocode/patient address. The reason for this is because ImmoScout requires you specify an approximate rental price when requesting data. If you guess too low, you won’t get any data. The short of the long story is that it doesn’t matter for our variable of interest since it is average neighborhood price, BUT – ImmoScout returns no data/error if you specific a price that has no match. Hence, I have a loop that runs 10 test prices for each address in order to collect the data we need. I checked and the average neighborhood price is always the same for a given address no matter what price is specified.

The raw data from the R scrape is then saved as: labdata_jun22.csv (I also have it in R format: labdata_jun22.RData)

library(dplyr)
library(reshape2)

download_data <- function(url, filename){
  download.file(url = url, destfile = paste0(filename, ".csv"))
}

url_listings <- "http://data.insideairbnb.com/portugal/lisbon/lisbon/2021-12-08/visualisations/listings.csv"
url_reviews <- "http://data.insideairbnb.com/portugal/lisbon/lisbon/2021-12-08/visualisations/reviews.csv"

download_data(url_reviews, "reviews")
download_data(url_listings, "listings")

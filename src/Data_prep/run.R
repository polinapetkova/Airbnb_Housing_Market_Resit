library(dplyr)
library(reshape2)

######################
### DOWNLOAD DATA ####
######################

download_data <- function(url, filename){
  download.file(url = url, destfile = paste0(filename, ".csv"))
}

url_listings <- "http://data.insideairbnb.com/portugal/lisbon/lisbon/2021-12-08/visualisations/listings.csv"
url_reviews <- "http://data.insideairbnb.com/portugal/lisbon/lisbon/2021-12-08/visualisations/reviews.csv"

download_data(url_reviews, "reviews")
download_data(url_listings, "listings")

######################
#### CLEAN DATA ######
######################

listings <- read.csv("listings.csv")
reviews <- read.csv("reviews.csv")

# convert date column
reviews$date <- as.Date(reviews$date)

# filter for reviews published since...
reviews_filtered <- reviews %>% filter(date > "2015-01-01")

# filter for `listings` that have received at least ... reviews.
listings_filtered <- listings %>% filter(number_of_reviews > 1)

# merge the `reviews` and `listings` dataframes on a common columns (the type of join doesn't really matter since we already filtered out listings without any reviews)
df_merged <- reviews_filtered %>% 
  inner_join(listings_filtered, by = c("listing_id" = "id"))

# group the number of reviews by month and neighborhood.
df_grouped <- df_merged %>%
  mutate(month = format(date, "%m"), year = format(date, "%Y")) %>%
  group_by(year, month, neighbourhood) %>%
  summarise(num_reviews = n())

# create date column
df_grouped$date <- as.Date(paste0(df_grouped$year, "-", df_grouped$month, "-01"))

######################
# CREATE PIVOT TABLE #
######################

# create pivot table
df_pivot <- df_grouped %>% dcast(date ~ neighbourhood, fun.aggregate = sum, value.var = "num_reviews")


##############
### PLOT  ####
##############

# convert the `date` column into date format.
df_pivot$date <- as.Date(df_pivot$date)

pdf("plot.pdf")
plot(x = df_pivot$date, 
     y = df_pivot$`Santa Maria Maior`, 
     col = "red", 
     type = "l", 
     xlab = "",
     ylab = "Total number of reviews", 
     main = "Effect of COVID-19 pandemic\non Airbnb review count")

lines(df_pivot$date, df_pivot$`Santo Antnio`, col="blue")
lines(df_pivot$date, df_pivot$`Estrela`, col="green")

legend("topleft", c("Santa Maria Maior", "Santo Antnio", "Estrela"), fill=c("red", "blue", "green"))
dev.off()


######################
##### PLOT ALL #######
######################

# import the data from `gen/data-preparation/aggregated_df.csv`
df <- df_grouped

# convert the `date` column into date format.
df$date <- as.Date(df$date)

# group by date and calculate the sum of all reviews across neighbourhoods.
df_groupby <- df %>% group_by(date) %>% summarise(num_reviews = sum(num_reviews))

# plot the chart and store the visualisation.
pdf("plot_all.pdf")
plot(x = df_groupby$date, 
     y = df_groupby$num_reviews, 
     type = "l", 
     xlab = "",
     ylab = "Total number of reviews", 
     main = "Effect of COVID-19 pandemic\non Airbnb review count")
dev.off()

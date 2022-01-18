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

# create pivot table
df_pivot <- df_grouped %>% dcast(date ~ neighbourhood, fun.aggregate = sum, value.var = "num_reviews")

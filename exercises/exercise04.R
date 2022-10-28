# ### Exercise 4 - investigate trip durations of two months
# use data_aug and data_sept and compare the duration medians of the two months
# for the trip where start station is Lakkegata and end station is Sukkerbiten. 
# Do they differ much?

# implement library(lubridate)
# use the data dataframe,
# filter for the trip given above
# mutate a new column called month by month = lubridate::month(started_at), 
# group each dataframe by start_station_name
# and end_station_name,
# summarise the duration with median, and view

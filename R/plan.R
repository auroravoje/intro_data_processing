# %%
library(tidyverse)
library(readxl)

# important commands:
# pipe operator: ctrl + shift + m (pipe means "then" -  do this, then do that)
# run by line windows: shift + enter 
# run by line mac: command + enter)
# indent code mac: command + I 
# code multiple lines: shift + command + c
# clear your space: rm(list = ls())

#get and set working directory
getwd()
setwd("/Users/avoje001/Documents/customers/FFI/intro_data_processing")
data_path = paste(getwd(),"/data/",sep="")

# read data with read_excel():
read_excel(paste(data_path,"kap1.xlsx",sep=""))
# read data, specify excel sheet:
read_excel(paste(data_path,"kap1.xlsx",sep=""), sheet="1.2") 

# inspect dataframe by piping into a View: (If you want, you can also name the View)
read_excel(paste(data_path,"kap1.xlsx",sep="")) %>% View("sheet1")

read_excel(paste(data_path,"kap1.xlsx",sep=""), sheet="1.2") %>% View("sheet2")


# ### Inspect the summary of the data frames
read_excel(paste(getwd(),"/data/kap1.xlsx",sep="")) %>% 
  summary() %>% 
  View()


# inspect dataframe summary by sheet
read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), sheet="1.2") %>% 
  summary() %>% 
  View()

# add header parameters to read Excel data properly
read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), sheet="1.2", skip=4) %>% 
  View()


# save your data into a dataframe object
budget <- read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), 
                     sheet="1.2", skip=4)

# look at the budget summary
budget %>% 
  summary() %>% 
  View("budget summary")


# extract first row: 
#baseR:
budget[1,]

#dplyr:
budget %>% 
  head(1) %>% View()

# extract all rows belonging to Norway 
budget %>% 
  rename(Land = 1) %>% 
  filter(Land =="Norge") %>% 
  View()

# select columns the dplyr way
budget %>% 
  select(Budsjettiltak) %>% 
  View()

# if you have special characters or space
budget %>% 
  select("Lån og garantier") %>% 
  View()

# good to know: select columns the base-R way
budget$Budsjettiltak
budget$`Lån og garantier`

# build a pipe on read in more cleaned up dataframe:
budget <- read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), sheet="1.2", skip=4) %>% 
          rename(land = 1,
                 tiltak = Budsjettiltak, 
                 lån = `Lån og garantier`)
  
   
# ### Exercise 1 - read in data: 
# Exercise 1
#
# Read data from the file ..\data\driftsinntekter-2021.xls with R.
# Which parameters do you need to specify?
#
# Use the readxl documentation to look up available parameters.
#
# https://readxl.tidyverse.org/


# Solution
read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""), skip=1) %>% View()


# ## Tidy Data
# ### Observations and variables
# A DataFrame is tidy if:
# - Each variable is a column
# - Each observation is a row
# - Each DataFrame contains one observational unit
# Note that tidy data principles are closely tied to normalization of relational databases.

# read in income, adjust for header and rename the "Category" column
income <- read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""), skip=1) %>% 
          rename(category=Category)

# Is the `income` data frame tidy?
# > No, _2019_, _2020_, and _2021_ are not variables. They are values of a _year_ variable

# ### Gather messy datasets to tidy them with tidyr gather

# read in data, rename Category column, gather, view
read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
  rename(category=Category) %>% 
  gather() %>% View()

# read in data, rename Category column, gather by category, view
read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
  rename(category=Category) %>% 
  gather(category) %>% View()

# read in data, rename Category column, gather by year, income, year interval, view
read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
  rename(category=Category) %>% 
  gather(year,income,"2019":"2021") %>% View()

# save data to income dataframe
income <- read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
          rename(category=Category) %>% 
          gather(year, income, "2019":"2021")


# ### Exercise - 2 
#
# Tidy the following tv-program data frame with gather():

#Data frame creation from scratch is done by column-wise:
hour <- c(19, 20, 21, 22)
NRK1 <- c("Dagsrevyen", "Beat for beat", "Nytt på nytt", "Lindmo")
TV2 <- c("Kjære landsmenn", "Forræder", "21-nyhetene", "Farfar")
TVNorge <- c("The Big Bang Theory", "Alltid beredt", "Kongen befaler", "Praktisk info")

#Add columns to the dataframe:
schedule <-data.frame(hour,NRK1,TV2,TVNorge)


#Gather the dataframe so you have columns: hour, channel, program,
# Solution:
schedule <- schedule %>% 
  gather(channel, program, "NRK1":"TVNorge") %>% View()

# ## Process Data

#Handle missing values

# do summary on your income dataframe: 
income %>% summary()

# tidy the income so it has colums: category, year, income, inspect it
read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
  rename(category=Category) %>% 
  gather(year, income, "2019":"2021") %>% 
  mutate(year = as.factor(year)) %>% 
  View()
  
#summary()



# Difficulty of casting missing values - get warnings

read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
  rename(category=Category) %>% 
  gather(year, income, "2019":"2021") %>% 
  mutate(year = as.factor(year),
         income = as.numeric(income)
         ) %>% 
  summary() 


# Fix this by adjusting NA-encoding on read-in: 

read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""), skip=1, na="-") %>% 
  rename(category=Category) %>% 
  gather(year, income, "2019":"2021") %>% 
  mutate(year = as.factor(year),
         income = as.numeric(income)
  ) %>% 
  summary()


# read into income dataframe
income <- read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""), skip=1, na="-") %>% 
  rename(category=Category) %>% 
  gather(year, income, "2019":"2021") %>% 
  mutate(year = as.factor(year),
         income = as.numeric(income)) 

# drop na:
income %>% 
  drop_na() %>% 
  View()

# replace na:
income %>% 
  replace_na(list(income=0)) %>% 
  View()


# ### Select variables and observations

budget <- read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), 
                     sheet="1.2", skip=4, na="-") %>% 
  rename(land = 1,
         tiltak = Budsjettiltak, 
         lån = `Lån og garantier`) %>% 
  replace_na(list(lån=0)) 



#view a column:
#baseR:
budget$tiltak
budget["tiltak"]

#dplyr syntax: in budget dataframe select columns land and tiltak: 
budget %>% select(land,tiltak)

# filter all columns that have land Norway: 
budget %>% filter(land=="Norge")

# filter all columns that have land Norge, Sverige
budget %>% filter(land == "Norge" |  land=="Sverige") 

#filter all Nordic countries: Norge, Sverige, Danmark, Finland: 
budget %>% filter(land=="Norge" | land == "Sverige" | land=="Danmark" | land == "Finland")
 
# filter all nordic countries and select the column lån
budget %>% filter(land=="Norge" | land == "Sverige" | 
                    land=="Danmark" | land == "Finland") %>% 
  select(lån)

# Filtering by row index

#baseR
budget[5,]

#dplyr:
budget %>% slice(5)

# specify specific rows 
#baseR:
budget[5:9,]
#dplyr:
budget %>% slice(5:9)

# get rows 5 to 9, and then select columns land and tiltak
budget %>% slice(5:9) %>% select(land, tiltak)

# filter by row (Norge) and then select by column (tiltak)
budget %>% filter(land=="Norge") %>% 
  select(tiltak)

# filter by row, select the third column
budget %>% filter(land=="Norge") %>% select(3)

# ### Combine variables

#base R:
budget$tiltak + budget$lån

# dplyr: add a column named total = tiltak + lån
budget %>% 
  mutate(total = tiltak + lån)

# ### Filter observations (conditional filtering)

#filter budget by rows where tiltak > 6
budget %>% 
  filter(tiltak > 6)

# filter budget by rows where lån < 3
budget %>% 
  filter(lån < 3)

# filter budget by rows where tiltak >= lån
budget %>% filter(tiltak >= lån)

# ### Sort (arrange) observations

# arrange budget by lån-column
budget %>% arrange(lån)

# arrange budget by descending lån-column
budget %>% arrange(desc(lån))

# arrange budget by lån and tiltak
budget %>% arrange(lån, tiltak)

# ### Exercise 3

# re-use the income code we built and arrange the dataframe by 
# descending year and income columns:

income <- read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1,na="-") %>% 
  rename(category=Category) %>% 
  gather(year, income, "2019":"2021") %>% 
  mutate(year = as.factor(year),
         income = as.numeric(income)
  ) %>% 
  drop_na() 
  # add code here:
  



# %>% 
  # arrange(desc(year),desc(income))

# ## Aggregate Data

# ### Bigger datasets

# read csv
trips = read_csv(paste(data_path,"/09.csv",sep=""))

#inspect information of the dataframe:

#with summary:
trips %>% summary()

#with column specification (spec())
trips %>% spec()

# ### Date columns: read_csv recongnises dates!!

# ### Group by common values

# View grouped dataframe in console:

trips %>% group_by(start_station_name)

# %% - group sizes
trips %>% 
  group_by(start_station_name) %>% 
  tally() %>% 
  View()

# %%group by size and arrange by descending
trips %>% 
  group_by(start_station_name) %>% 
  tally() %>% 
  arrange(desc(n)) %>%  
  View()

# rename the n-variable tally() creates

# by rename():
num_trips = trips %>% 
  group_by(start_station_name) %>% 
  tally() %>% 
  rename(num_trips=n) %>% 
  arrange(desc(num_trips)) 

#by passing name into tally():
trips %>% 
  group_by(start_station_name) %>% 
  tally(name="num_trips") %>% 
  arrange(desc(num_trips)) %>%  
  View()


# %% ######## Aggregations with summarize()

#group trips by start station name, 
#calculate median bike travel duration of each group
#get the station name description 

trips %>% 
  group_by(start_station_name) %>% 
  summarise(median_duration = median(duration),
            description = first(start_station_description)) %>% 
  View()


# Custom function - sometimes you have to build one!
# Want to find the mode of each group.
# Mode: The most frequent number—that is, 
# the number that occurs the highest number of times. 
# Example: The mode of {4 , 2, 4, 3, 2, 2} is 2.
# Will this work?
trips %>% 
  group_by(start_station_name) %>%
  summarise(median_duration = median(duration),
            description = first(start_station_name),
            common_end_station = mode(end_station_name)) %>% 
  View()
 
# ?mode tells you what this function does in R
# the built-in mode does something else
# need to make a custom function
# x represents the column name
mode <- function(x) { 
  names(which.max(table(x))) 
  }

trips %>%
  group_by(start_station_name) %>%
  summarise(median_duration = median(duration),
            description = first(start_station_name),
            common_end_station = mode(end_station_name)) %>% 
  View()



# group by multiple variables:

# group by start station and end station,
# summarise with median trip duration
trips %>% 
  group_by(start_station_name, end_station_name) %>% 
  summarise(duration_median=median(duration)) %>%  
  View()

# add the station start and end station description of the groups,
# by picking the first description of each group

trips %>% group_by(start_station_name, end_station_name) %>% 
  summarise(median_duration = median(duration),
            start_station_description = first(start_station_description),
            end_station_description = first(end_station_description)) %>% 
  View()




# ## Combine Data Tables

# We have two files with the same kinds of data: `08.csv` with data for August  
# and `09.csv` with data for September. 
# How can we combine them into one DataFrame?

# read in files individually with readr-package:
data_aug = read_csv(paste(data_path,"08.csv",sep=""))
data_sept = read_csv(paste(data_path,"09.csv",sep=""))

# Append tables with similar data
# one dataframe under the other

data_aug %>% 
  bind_rows(data_sept) %>% 
  View()

#When many files, individual read in can be automatized:
# read in multiple files:
list_of_files <- list.files(path = data_path,
                            recursive = TRUE,
                            pattern = "\\.csv$",
                            full.names = TRUE)

data <- read_csv(list_of_files)#, id = "file_name") #<- adds a column with filename


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

# Solution:
data %>% 
  filter(start_station_name == "Lakkegata" & end_station_name=="Sukkerbiten") %>% 
  mutate(month = month(started_at)) %>% 
  group_by(month, start_station_name, end_station_name) %>% 
  summarise(duration_median = median(duration)) %>% 
  View()



# ### Join tables with common variables

num_trips

# create trip_lengths dataframe:
# group by start station name, 
# find median duration of each group
# arrange by descending duration median

trip_lengths <- trips %>% 
  group_by(start_station_name) %>% 
  summarise(duration_median = median(duration)) %>% 
  arrange(desc(duration_median))

trip_lengths


# https://github.com/gadenbuie/tidyexplain#mutating-joins

# left join trips and lengths on the station name:
# it recognizes the same name!
num_trips %>% inner_join(trip_lengths) 

# create dataframe num_trips_from
# group by start station name, tally num_trips and arrange by num_trips

num_trips_from <- trips %>% 
  group_by(start_station_name) %>% 
  tally() %>% 
  rename(num_trips = n) %>% 
  arrange(num_trips)

num_trips_from

# create dataframe num_trips_to
# group by end_station_name, tally num_trips, arrange by num_trips

num_trips_to <- trips %>% 
  group_by(end_station_name) %>% 
  tally(name="num_trips") %>% 
  arrange(num_trips)

num_trips_to


# inner join num_trips_from and num_trips_to:
num_trips_from %>% inner_join(num_trips_to) 


# What if the join column names are different?
# left join num_trips_from to num trips to

num_trips_from %>% 
  left_join(num_trips_to, by = c("start_station_name"="end_station_name")) %>% 
  View()


# create popular from and pupular to dataframes
# get top 10 rows from each dataframe
popular_from <- num_trips_from %>% top_n(10, num_trips)
popular_to <-  num_trips_to %>% top_n(10, num_trips)

# inner join popular from and popular to 
# by start station name and end station name
popular_from %>% 
  inner_join(popular_to, by = c("start_station_name"="end_station_name")) %>% 
  View()


# left join popular from and popular to 
# by start station name and end station name
popular_from %>% 
  left_join(popular_to, by = c("start_station_name"="end_station_name")) %>% 
  View()


# right join popular from and popular to 
# by start station name and end station name

popular_from %>% 
  right_join(popular_to, by = c("start_station_name"="end_station_name")) %>% 
  View()


# right join popular from and popular to 
# by start station name and end station name

popular_from %>% 
  full_join(popular_to, by = c("start_station_name"="end_station_name")) %>% 
  View()


# ### Exercise  5 
# anti join popular from and popular to 
# by start station name and end station name
# what does the result mean?



#Solution:
popular_from %>% 
  anti_join(popular_to, by = c("start_station_name"="end_station_name")) %>% 
  View()


# ## Sharing Insights
# ### Visualizations with ggplot2

# simple visualizations:
# recall our income and budget dataframes:

#pipe income dataframe into ggplot, specify x and y in the aesthetic 
income %>%
  ggplot() +
  geom_point(aes(x=year,y=income))


# budget dataframe arrange by descending "lån"
budget %>%
  arrange(-desc(lån)) %>%
  ggplot() +
  geom_point(aes(x=land,y=lån))

# mutate the "land" variable to factor and plot
budget %>%
  arrange(-desc(lån)) %>%
  mutate(land = factor(land, levels=land)) %>% 
  ggplot() +
  geom_point(aes(x=land,y=lån))



# barplot
# reuse the code above and try the geom_col()
budget %>%
  arrange(-desc(tiltak)) %>% 
  mutate(land = factor(land, levels=land)) %>% 
  ggplot() +
  geom_col(aes(tiltak,land))


# ### Mess up data for presentation

# create from_to dataframe
# group trips by start station name and end station name
# tally with num_trips, arrange by num_trips
from_to <- trips %>% 
  group_by(start_station_name, end_station_name) %>% 
  tally(name="num_trips") %>% 
  arrange(num_trips)

# use from_to, filter start station name which is in popular_from dataframe and
# end station name which is in popular_to dataframe
# create a pivot table with names from end_station_name and values from num_trips
from_to %>% 
  filter((start_station_name %in% popular_from$start_station_name) & (end_station_name %in% popular_to$end_station_name)) %>% 
  pivot_wider(names_from=end_station_name, values_from=num_trips) %>% View()


# Exercize 6 - finalize cleanup: 
# Inspect the code, what is left to clean?
# Process the last step.



# Solution:
#specific quick fix
from_to %>% 
  filter((start_station_name %in% popular_from$start_station_name) & 
           (end_station_name %in% popular_to$end_station_name)) %>% 
  pivot_wider(names_from=end_station_name, values_from=num_trips) %>%
  replace_na(list(Tjuvholmen=0))

# more general solution:
from_to %>% 
  filter((start_station_name %in% popular_from$start_station_name) & (end_station_name %in% popular_to$end_station_name)) %>% 
  pivot_wider(names_from=end_station_name, values_from=num_trips) %>%
  replace(is.na(.),0)


# ### More visualizations
# create a map colored by latitude and longitude ratio
# 
num_trips_to <- trips %>% 
  group_by(end_station_name) %>% 
  summarise(num_trips = length(end_station_name),
            lat = first(end_station_latitude),
            lon = first(end_station_longitude)) %>% 
  arrange(num_trips) 

#
num_trips_from %>% 
  inner_join(num_trips_to, by = c("start_station_name"="end_station_name")) %>%
  mutate(from_to = log(num_trips.x/num_trips.y)) %>% 
  ggplot() +
  geom_point(aes(x=lat,y=lon, color=from_to)) 
  

# ### Save to Excel - self study, as we probably don't have time! :-) 

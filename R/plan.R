# %%
library(tidyverse)
library(readxl)
# %%
#important commands:
#pipe operator: ctrl + shift + m
#run by line windows: shift + enter 
#run by line mac: command + enter)
# indent code mac: command + I 
# code multiple lines: shift + command + c

#set working directory
setwd("/Users/avoje001/Documents/customers/FFI/intro_data_processing")
data_path = paste(getwd(),"/data/",sep="")
#read data:
#pd.read_excel("../data/kap1.xlsx")
read_excel(paste(getwd(),"/data/kap1.xlsx",sep="")) %>% View()

#pd.read_excel("../data/kap1.xlsx", sheet_name="1.2")
read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), sheet="1.2") %>% View()

# inspect dataframe:
# read_excel(paste(getwd(),"/data/kap1.xlsx",sep="")) %>% View()
# inspect dataframe by sheet
# read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), sheet="1.2") %>% View()

# ### Inspect information of the data frames
summary(read_excel(paste(getwd(),"/data/kap1.xlsx",sep="")))
summary(read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), sheet="1.2"))
# %%

# %% [markdown]
# ### Add parameters to read Excel data properly
# %%
#pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=5)
df_sheet <- read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), sheet="1.2", skip=5) %>% 
  View()

# %%
# pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4)
read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), sheet="1.2", skip=4) %>% 
  View()


# %%
#budget = pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4)
budget <- read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), 
                     sheet="1.2", skip=4)

# %%
#budget.info()
summary(budget)

# %% extract first row: 
#budget.loc[0]
budget_columns <- colnames(budget)
budget[1,]
budget %>% head(1) %>% View()

# %% extract 
#budget.loc["Norge"]
budget %>% 
  rename(Land = 1) %>% 
  filter(Land =="Norge") %>% View()

# %% - this is handled automatically in read-in:
#pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4, index_col=0)

# %%
#budget = pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4, index_col=0)

# %%
#budget.info()

# %%
#budget.describe()

# %%
#budget.loc["Norge"]

# %%
#budget.loc[0]

# %%
#budget.iloc[0]

# %% - select columns the dplyr way
budget %>% select(Budsjettiltak) %>% View()

# %%
budget %>% select("Lån og garantier") %>% View()

# %% select columns the base-R way
budget$`Lån og garantier`


# %% build a pipe on read in:
#pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4, index_col=0).rename(columns={"Budsjettiltak": "tiltak", "Lån og garantier": "lån"})
budget <- read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), sheet="1.2", skip=4) %>% 
          rename(land = 1,
                 tiltak = Budsjettiltak, 
                 lån = `Lån og garantier`)
  
   

# %% [markdown]
# ### Exercise
#
# Read data from the file `\data\driftsinntekter-2021.xls" with read_excel() 
# Which parameters do you need to specify? 
# Use the [`readxl` documentation](https://readxl.tidyverse.org/) 
# to look up available parameters. 

# %% Solution
# pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1)
read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""), skip=1) %>% View()


# %% [markdown]
# ## Tidy Data
#
# ### Observations and variables
#
# Hadley Wickham introduced the term **tidy data** (<https://tidyr.tidyverse.org/articles/tidy-data.html>). Data tidying is a way to **structure DataFrames to facilitate analysis**.
#
# A DataFrame is tidy if:
#
# - Each variable is a column
# - Each observation is a row
# - Each DataFrame contains one observational unit
#
# Note that tidy data principles are closely tied to normalization of relational databases.

# %%
# income = (
#   pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1)
#   .rename(columns={"Category": "category"})
# )

income <- read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
          rename(category=Category)

# %% [markdown]
# Is the `income` data frame tidy?
#
# > No, _2019_, _2020_, and _2021_ are not variables. They are values of a _year_ variable

# %% [markdown]
# ### Gather messy datasets to tidy them with tidyr gather

# %%
#income.melt()

read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
  rename(category=Category) %>% 
  gather() %>% View()

# %%
#income.melt(id_vars=["category"])
#income.melt(id_vars=["category"], var_name="year")
#income.melt(id_vars=["category"], var_name="year", value_name="income")

read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
  rename(category=Category) %>% 
  gather(category) %>% View()

read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
  rename(category=Category) %>% 
  gather(year,income,"2019":"2021") %>% View()

# %%
#income = (
#  pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1)
#  .rename(columns={"Category": "category"})
#  .melt(id_vars=["category"], var_name="year", value_name="income")
#)

income <- read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
          rename(category=Category) %>% 
          gather(year, income, "2019":"2021")



# %% [markdown]
# ### Visualizations

# %%
#income.plot()
#need to specify x and y 
income %>%
  ggplot() +
  geom_point(aes(x=year,y=amount))


# %%
#budget.plot()
budget %>%
  arrange(-desc(lån)) %>%
  mutate(land = factor(land, levels=land)) %>% 
  ggplot() +
  geom_point(aes(x=land,y=lån))

# %% histogram
#budget.plot.barh()
budget %>%
  arrange(-desc(tiltak)) %>% 
  mutate(land = factor(land, levels=land)) %>% 
  ggplot() +
  geom_col(aes(tiltak,land))

# %% [markdown]
# ### Exercise
#
# Tidy the following data frame:

# %%
# schedule = pd.DataFrame(
#   {
#     "hour": [19, 20, 21, 22],
#     "NRK1": ["Dagsrevyen", "Beat for beat", "Nytt på nytt", "Lindmo"],
#     "TV2": ["Kjære landsmenn", "Forræder", "21-nyhetene", "Farfar"],
#     "TVNorge": ["The Big Bang Theory", "Alltid beredt", "Kongen befaler", "Praktisk info"],
#   }
# )
#columns with rows:
hour <- c(19, 20, 21, 22)
NRK1 <- c("Dagsrevyen", "Beat for beat", "Nytt på nytt", "Lindmo")
TV2 <- c("Kjære landsmenn", "Forræder", "21-nyhetene", "Farfar")
TVNorge <- c("The Big Bang Theory", "Alltid beredt", "Kongen befaler", "Praktisk info")

#dataframe:
schedule <-data.frame(hour,NRK1,TV2,TVNorge)

# %%
#schedule.melt(id_vars=["hour"], var_name="channel", value_name="program")

schedule <- schedule %>% 
  gather(channel, program, "NRK1":"TVNorge") %>% View()

# %% [markdown]
# ## Process Data

# %% [markdown]
# ### Handle missing values

# %%
#income.info()
summary(income)
# %% specifying the column types:
# (
#   pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1)
#   .rename(columns={"Category": "category"})
#   .melt(id_vars=["category"], var_name="year", value_name="income")
#   .astype({"year": "int"})
# ).info()

read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
  rename(category=Category) %>% 
  gather(year, income, "2019":"2021") %>% 
  mutate(year = as.factor(year)) %>% 
  summary()



# %% Difficulty of casting missing values
# (
#   pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1)
#   .rename(columns={"Category": "category"})
#   .melt(id_vars=["category"], var_name="year", value_name="income")
#   .astype({"year": "int", "income": "float"})
# ).info()

read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
  rename(category=Category) %>% 
  gather(year, income, "2019":"2021") %>% 
  mutate(year = as.factor(year),
         income = as.numeric(income)
         ) %>% 
  summary()


# %% Fix this by ddjusting NA-encoding on read-in: 
# (
#   pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1, na_values="-")
#   .rename(columns={"Category": "category"})
#   .melt(id_vars=["category"], var_name="year", value_name="income")
#   .astype({"year": "int", "income": "float"})
# ).info()
read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1,na="-") %>% 
  rename(category=Category) %>% 
  gather(year, income, "2019":"2021") %>% 
  mutate(year = as.factor(year),
         income = as.numeric(income)
  ) %>% 
  summary()




# %%
# income = (
#   pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1, na_values="-")
#   .rename(columns={"Category": "category"})
#   .melt(id_vars=["category"], var_name="year", value_name="income")
#   .astype({"year": "int", "income": "float"})
# )

# %%
#income.dropna()

income <- read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1,na="-") %>% 
  rename(category=Category) %>% 
  gather(year, income, "2019":"2021") %>% 
  mutate(year = as.factor(year),
         income = as.numeric(income)
  ) 


income %>% 
  drop_na() %>% 
  View()

# %%
#income.fillna(0)
#replace NA with anything you want, but specify which column
income %>% 
  replace_na(list(income=0)) %>% 
  View()


# %% [markdown]
# ### Select variables and observations

# %%
# budget = (
#   pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4, index_col=0, na_values="-")
#   .rename(columns={"Budsjettiltak": "tiltak", "Lån og garantier": "lån"})
#   .fillna(0)
# )
# %%
#budget

budget <- read_excel(paste(getwd(),"/data/kap1.xlsx",sep=""), 
                     sheet="1.2", skip=4, na="-") %>% 
  rename(land = 1,
         tiltak = Budsjettiltak, 
         lån = `Lån og garantier`) %>% 
  replace_na(list(lån=0)) 



# %% view a column:
#baseR:
budget$tiltak
budget["tiltak"]

# %% dplyr pipe syntax
budget %>% select(land,tiltak)

# %% 
# budget.loc["Norge"]
budget %>% filter(land=="Norge")
# # %%
# budget.loc["Sverige":"Norge"]

budget %>% filter(land == "Norge" |  land=="Sverige") 
# # %%
budget %>% filter(land=="Norge" | land == "Sverige" | land=="Danmark" | land == "Finland")
# 
# # %%
# budget.loc[["Norge", "Sverige", "Danmark", "Finland"], "lån"]
budget %>% filter(land=="Norge" | land == "Sverige" | 
                    land=="Danmark" | land == "Finland") %>% 
  select(lån)

# # %%
# budget.loc[["Norge", "Sverige", "Danmark", "Finland"], ["lån", "tiltak"]]

budget %>% filter(land=="Norge" | land == "Sverige" | 
                    land=="Danmark" | land == "Finland")

# %% Filtering by row index
# budget.iloc[4]
#baseR
budget[5,]

#dplyr:
budget %>% slice(5)

# 
# # %%
# budget.iloc[4:9]
budget[5:9,]
budget %>% slice(5:9)

# # %%
# budget.iloc[5:8, 0]
budget %>% slice(5:9) %>% select(land, tiltak)
# %%
#budget.loc["Norge", "tiltak"]
budget %>% filter(land=="Norge") %>% 
  select(tiltak)


# %% filter by row, select by column index
#budget.loc["Norge", budget.columns[1]]
budget %>% filter(land=="Norge") %>% select(3)
# %% [markdown]
# ### Combine variables

# %%
#budget.tiltak + budget.lån
budget$tiltak + budget$lån
# %%
#budget.assign(total=budget.tiltak + budget.lån)
budget %>% 
  mutate(total = tiltak + lån)

# %% [markdown]
# ### Filter observations (conditional filtering)

# %%
#budget.query("tiltak > 6")
budget %>% 
  filter(tiltak > 6)
# %%
#budget.query("lån < 3")
budget %>% 
  filter(lån < 3)

# %%
#budget.query("tiltak >= lån")
budget %>% filter(tiltak >= lån)

# %% [markdown]
# ### Sort (arrange) observations

# %%
#budget.sort_values(by="lån")
budget %>% arrange(desc(lån))
# %%
#budget.sort_values(by=["lån", "tiltak"])
budget %>% arrange(lån, tiltak)
# %%
#budget.sort_index()
#this is the closest we get sort_index()
budget %>% arrange(land)
# %% [markdown]
# ### Exercise
#
# Something something driftsinntekter

# %% [markdown]
# ## Aggregate Data

# %% [markdown]
# ### Bigger datasets

# %%
pd.read_csv("../data/09.csv")

# %%
trips = pd.read_csv()
trips = read_csv(paste(data_path,"/09.csv",sep=""))
# %%
#trips.info()
spec(trips)
# %% [markdown]
# ### Date columns

# %% - høre med GA
#trips = pd.read_csv("../data/09.csv", parse_dates=["started_at", "ended_at"])
#trips.info()

# %% [markdown]
# ### Group by common values

# %% View grouped dataframe:
#trips.groupby("start_station_name")
trips %>% group_by(start_station_name)

# %% - group sizes
#trips.groupby("start_station_name").size()
trips %>% group_by(start_station_name) %>% tally() %>% View()

# %%group by size and arrange
#trips.groupby("start_station_name").size().sort_values()
trips %>% group_by(start_station_name) %>% tally() %>% arrange(desc(n)) %>%  View()

# %% arrange by group size - no need to think about this in dplyr
#trips.groupby("start_station_name").size().reset_index()
# %%
#trips.groupby("start_station_name").size().reset_index().rename(columns={0: "num_trips"})

# %%
# (
#   trips
#   .groupby("start_station_name").size()
#   .reset_index()
#   .rename(columns={0: "num_trips"})
#   .sort_values(by="num_trips")
# )

trips %>% 
  group_by(start_station_name) %>% 
  tally() %>% 
  rename(num_trips=n) %>%
  arrange(desc(num_trips)) %>%  
  View()

# num_trips = (
#   trips.groupby("start_station_name")
#   .size()
#   .reset_index()
#   .rename(columns={0: "num_trips"})
#   .sort_values(by="num_trips")
# )

num_trips = trips %>% 
  group_by(start_station_name) %>% 
  tally() %>% 
  rename(num_trips=n) %>% 
  arrange(desc(num_trips)) 


# %% ######## Aggregations - summarize ############
# %%
#trips.groupby("start_station_name").median()
# group by station, summarise with median, get the name of the station 
# (with extraction first entry of the name of group, 
# the names will be the same per group)

trips %>% 
  group_by(start_station_name) %>% 
  summarise(median_duration = median(duration),
            description = first(start_station_description)) %>% 
  View()


# custom function - not sure this is necessary?
#Mode: The most frequent number—that is, 
#the number that occurs the highest number of times. 
#Example: The mode of {4 , 2, 4, 3, 2, 2} is 2
# will this work?
trips %>% 
  group_by(start_station_name) %>%
  summarise(median_duration = median(duration),
            description = first(start_station_name),
            common_end_station = mode(end_station_name)) %>% 
  View()
 
# ? mode tells you what this function does in R
# need to make a custom function
mode <- function(x) { 
  names(which.max(table(x))) 
  }

trips %>%
  group_by(start_station_name) %>%
  summarise(median_duration = median(duration),
            description = first(start_station_name),
            common_end_station = mode(end_station_name)) %>% 
  View()



# %% group by multiple variables:
#trips.groupby(["start_station_name", "end_station_name"]).median()

# %% summarise()
#trips.groupby(["start_station_name", "end_station_name"]).agg({"duration": "median"})
trips %>% 
  group_by(start_station_name, end_station_name) %>% 
  summarise(duration_median=median(duration)) %>%  
  View()

# %% get 
trips %>% group_by(start_station_name, end_station_name) %>% 
  summarise(median_duration = median(duration),
            start_station_description = first(start_station_description),
            end_station_description = first(end_station_description)) %>% 
  View()




# %% [markdown]
# ## Combine Data Tables
#
# We have two files with the same kinds of data: `08.csv` with data for August and `09.csv` with data for September. How can we combine them into one DataFrame?

# %%
#data_aug = pd.read_csv("../data/08.csv", parse_dates=["started_at", "ended_at"])
data_aug = read_csv(paste(data_path,"08.csv",sep=""))
#data_sep = pd.read_csv("../data/09.csv", parse_dates=["started_at", "ended_at"])
data_sept = read_csv(paste(data_path,"09.csv",sep=""))


# %% [markdown]
# ### Append tables with similar data
data_aug %>% bind_rows(data_sept) %>% View()
# %%
#pd.concat([data_aug, data_sep])
#pd.concat([data_aug, data_sep]).reset_index()
#pd.concat([data_aug, data_sep]).reset_index(drop=True)

# %% read in multiple files:
list_of_files <- list.files(path = data_path,
                            recursive = TRUE,
                            pattern = "\\.csv$",
                            full.names = TRUE)

data <- readr::read_csv(list_of_files)#, id = "file_name")


# %% [markdown]
# ### Exercise

# %% [markdown]
# ### Join tables with common variables

# %%
num_trips

# %%
# trip_lengths = (
#   trips.groupby("start_station_name")
#   .agg({"duration": "median"})
#   .reset_index()
#   .sort_values(by="duration")
# )
# trip_lengths

trip_lengths <- trips %>% 
  group_by(start_station_name) %>% 
  summarise(duration_median = median(duration)) %>% 
  arrange(desc(duration_median))

trip_lengths



# %% join trips and lengths on the station name:
#pd.merge(num_trips, trip_lengths)
# it recognizes the same name!
num_trips %>% left_join(trip_lengths) 


# %%
# num_trips_from = (
#   trips.groupby("start_station_name")
#   .agg(num_trips=("start_station_name", "size"))
#   .sort_values(by="num_trips")
#   .reset_index()
# )
# num_trips_from

num_trips_from <- trips %>% 
  group_by(start_station_name) %>% 
  tally() %>% 
  rename(num_trips = n) %>% 
  arrange(num_trips)

num_trips_from

# %%
# num_trips_to = (
#   trips.groupby("end_station_name")
#   .agg(num_trips=("end_station_name", "size"))
#   .sort_values(by="num_trips")
#   .reset_index()
# )
# num_trips_to

num_trips_to <- trips %>% 
  group_by(end_station_name) %>% 
  tally() %>% 
  rename(num_trips = n) %>% 
  arrange(num_trips)

num_trips_to


# %% 
#pd.merge(num_trips_from, num_trips_to)
num_trips_from %>% inner_join(num_trips_to) 



# %%
# pd.merge(
#   num_trips_from,
#   num_trips_to,
#   left_on="start_station_name",
#   right_on="end_station_name",
# )

num_trips_from %>% 
  left_join(num_trips_to, by = c("start_station_name"="end_station_name")) %>% 
  View()


# %%
#popular_from = num_trips_from.nlargest(10, "num_trips")
#popular_to = num_trips_to.nlargest(10, "num_trips")
popular_from = num_trips_from %>% top_n(10, num_trips)
popular_to = num_trips_to %>% top_n(10, num_trips)


# %%
# pd.merge(
#   popular_from, popular_to, left_on="start_station_name", right_on="end_station_name"
# )
popular_from %>% 
  inner_join(popular_to, by = c("start_station_name"="end_station_name")) %>% 
  View()


# %%
# pd.merge(
#   popular_from,
#   popular_to,
#   how="left",
#   left_on="start_station_name",
#   right_on="end_station_name",
# )
popular_from %>% 
  left_join(popular_to, by = c("start_station_name"="end_station_name")) %>% 
  View()


# %%
# pd.merge(
#   popular_from,
#   popular_to,
#   how="right",
#   left_on="start_station_name",
#   right_on="end_station_name",
# )
popular_from %>% 
  right_join(popular_to, by = c("start_station_name"="end_station_name")) %>% 
  View()



# %%
# pd.merge(
#   popular_from,
#   popular_to,
#   how="outer",
#   left_on="start_station_name",
#   right_on="end_station_name",
# )
popular_from %>% 
  full_join(popular_to, by = c("start_station_name"="end_station_name")) %>% 
  View()



# %% [markdown]
# ### Exercise

# %% [markdown]
# ## Sharing Insights

# %% [markdown]
# ### Mess up data for presentation

# %%
# from_to = (
#   trips.groupby(["start_station_name", "end_station_name"])
#   .agg(num_trips=("start_station_name", "size"))
#   .reset_index()
#   .sort_values(by="num_trips")
# )
from_to <- trips %>% 
  group_by(start_station_name, end_station_name) %>% 
  tally() %>% 
  rename(num_trips=n) %>% 
  arrange(num_trips)

# %%
from_to.query(
  "start_station_name.isin(@popular_from.start_station_name) and end_station_name.isin(@popular_to.end_station_name)"
).pivot_table(
  index="start_station_name", columns="end_station_name", values="num_trips"
)

from_to %>% 
  filter((start_station_name %in% popular_from$start_station_name) &
         (end_station_name %in% popular_to$end_station_name)) %>% 
  pivot_wider(names_from=end_station_name, values_from=num_trips) %>% 
  View()

# Exercize: Fill NA?
#HERE: .py line 698
# %% [markdown]
# ### Save to Excel

# %% [markdown]
# ### More visualizations

# %%
#from_to

# %%
# num_trips_to = (
#   trips.groupby("end_station_name")
#   .agg(num_trips=("end_station_name", "size"), lat=("end_station_latitude", "first"), lon=("end_station_longitude", "first"))
#   .sort_values(by="num_trips")
#   .reset_index()
# )
# 
# # %%
# import numpy as np
# pd.merge(
#   num_trips_from,
#   num_trips_to,
#   left_on="start_station_name",
#   right_on="end_station_name",
#   suffixes=("_from", "_to")
# ).assign(from_over_to=lambda df: np.log(df.num_trips_from/df.num_trips_to)).plot.scatter(x="lon", y="lat", c="from_over_to")
# 
# # %%

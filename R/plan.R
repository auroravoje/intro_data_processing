library(tidyverse)
library(readxl)
#pipe operator: ctrl + shift + m


#set working directory
setwd("/Users/avoje001/Documents/customers/FFI/intro_data_processing")

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
                 lån = `Lån og garantier`) %>% 
          View()
  
   

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
income = (
  pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1)
  .rename(columns={"Category": "category"})
)

income <- read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
          rename(category=Category)

# %% [markdown]
# Is the `income` data frame tidy?
#
# > No, _2019_, _2020_, and _2021_ are not variables. They are values of a _year_ variable

# %% [markdown]
# ### Melt messy datasets to tidy them

#tidyr gather
income <- read_excel(paste(getwd(),"/data/driftsinntekter-2021.xlsx",sep=""),skip=1) %>% 
          rename(category=Category) %>% 
          gather(year, amount, "2019":"2021")

# %%
#income.melt()

# %%
#income.melt(id_vars=["category"])

# %%
#income.melt(id_vars=["category"], var_name="year")

# %%
#income.melt(id_vars=["category"], var_name="year", value_name="income")

# %%
#income = (
#  pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1)
#  .rename(columns={"Category": "category"})
#  .melt(id_vars=["category"], var_name="year", value_name="income")
#)

# %% [markdown]
# ### Visualizations

# %%
income.plot()

# %%
budget.plot()

# %%
budget.plot.barh()

# %% [markdown]
# ### Exercise
#
# Tidy the following data frame:

# %%
schedule = pd.DataFrame(
  {
    "hour": [19, 20, 21, 22],
    "NRK1": ["Dagsrevyen", "Beat for beat", "Nytt på nytt", "Lindmo"],
    "TV2": ["Kjære landsmenn", "Forræder", "21-nyhetene", "Farfar"],
    "TVNorge": ["The Big Bang Theory", "Alltid beredt", "Kongen befaler", "Praktisk info"],
  }
)

# %%
schedule.melt(id_vars=["hour"], var_name="channel", value_name="program")

# %% [markdown]
# ## Process Data

# %% [markdown]
# ### Handle missing values

# %%
income.info()

# %%
(
  pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1)
  .rename(columns={"Category": "category"})
  .melt(id_vars=["category"], var_name="year", value_name="income")
  .astype({"year": "int"})
).info()

# %%
(
  pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1)
  .rename(columns={"Category": "category"})
  .melt(id_vars=["category"], var_name="year", value_name="income")
  .astype({"year": "int", "income": "float"})
).info()

# %%
(
  pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1, na_values="-")
  .rename(columns={"Category": "category"})
  .melt(id_vars=["category"], var_name="year", value_name="income")
  .astype({"year": "int", "income": "float"})
).info()

# %%
income = (
  pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1, na_values="-")
  .rename(columns={"Category": "category"})
  .melt(id_vars=["category"], var_name="year", value_name="income")
  .astype({"year": "int", "income": "float"})
)

# %%
income.dropna()

# %%
income.fillna(0)

# %% [markdown]
# ### Select variables and observations

# %%
budget = (
  pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4, index_col=0, na_values="-")
  .rename(columns={"Budsjettiltak": "tiltak", "Lån og garantier": "lån"})
  .fillna(0)
)

# %%
budget

# %%
budget.tiltak

# %%
budget["tiltak"]

# %%
budget.loc[:, "tiltak"]

# %%
budget.loc["Norge"]

# %%
budget.loc["Sverige":"Norge"]

# %%
budget.loc[["Norge", "Sverige", "Danmark", "Finland"]]

# %%
budget.loc[["Norge", "Sverige", "Danmark", "Finland"], "lån"]

# %%
budget.loc[["Norge", "Sverige", "Danmark", "Finland"], ["lån", "tiltak"]]

# %%
budget.iloc[4]

# %%
budget.iloc[4:9]

# %%
budget.iloc[5:8, 0]

# %%
budget.loc["Norge", "tiltak"]

# %%
budget.loc["Norge", budget.columns[1]]

# %% [markdown]
# ### Combine variables

# %%
budget.tiltak + budget.lån

# %%
budget.assign(total=budget.tiltak + budget.lån)

# %% [markdown]
# ### Filter observations

# %%
budget.query("tiltak > 6")

# %%
budget.query("lån < 3")

# %%
budget.query("tiltak >= lån")

# %% [markdown]
# ### Sort observations

# %%
budget.sort_values(by="lån")

# %%
budget.sort_values(by=["lån", "tiltak"])

# %%
budget.sort_index()

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
trips = pd.read_csv("../data/09.csv")

# %%
trips.info()

# %% [markdown]
# ### Date columns

# %%
trips = pd.read_csv("../data/09.csv", parse_dates=["started_at", "ended_at"])
trips.info()

# %% [markdown]
# ### Group by common values

# %%
trips.groupby("start_station_name")

# %%
trips.groupby("start_station_name").size()

# %%
trips.groupby("start_station_name").size().sort_values()

# %%
trips.groupby("start_station_name").size().reset_index()

# %%
trips.groupby("start_station_name").size().reset_index().rename(columns={0: "num_trips"})

# %%
(
  trips
  .groupby("start_station_name").size()
  .reset_index()
  .rename(columns={0: "num_trips"})
  .sort_values(by="num_trips")
)

# %%
trips.groupby(["start_station_name", "end_station_name"]).median()

# %%
trips.groupby(["start_station_name", "end_station_name"]).agg({"duration": "median"})

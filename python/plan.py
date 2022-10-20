# ---
# jupyter:
#   jupytext:
#     formats: ipynb,py:percent
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.14.1
#   kernelspec:
#     display_name: Python 3.10.7 64-bit ('kurs_ffi')
#     language: python
#     name: python3
# ---

# %% [markdown]
# # Introduction to Data Processing With Python 
#
#

# %% [markdown]
# - Introduction
# - Spyder
# - Read Excel Data
#     - Import `pandas`
#     - Read Excel data with `pandas`
#     - Inspect a `pandas` data frame
#     - Add parameters to read Excel data properly
#     - Rename columns/variables
#     - Exercise
# - Tidy Data
#     - Obervations and variables
#     - Melt messy data to create tidy data
#     - Visualizations
#     - Exercise
# - Process Data
#     - Handle missing values 
#     - Select variables
#     - Combine variables
#     - Filter observations
#     - Sort observations
#     - Exercise
# - Aggregate Data
#     - Bigger datasets
#     - Date columns
#     - Group by common values
#     - Aggregations: sum, mean, first, median, count
#     - Exercise
# - Combine Data Tables
#     - Append tables of similar data
#     - Exercise
#     - Join tables with common variables
#     - Exercise
# - Sharing Insights
#     - Mess up data for presentation with pivot
#     - Save to Excel (and other formats)
#     - More visualizations

# %% [markdown]
# ## Read Excel Data

# %% [markdown]
# ### Importing packages

# %%
import pandas as pd
# %%
import matplotlib.pyplot as plt

# %% [markdown]
# ### Read Excel data with pandas

# %%
pd.read_excel("../data/kap1.xlsx")

# %%
pd.read_excel("../data/kap1.xlsx", sheet_name="1.2")

# %% [markdown]
# ### Inspect pandas data frames

# %%
pd.read_excel("../data/kap1.xlsx", sheet_name="1.2").info()



# %% [markdown]
# ### Add parameters to read Excel data properly

# %%
pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=5)

# %%
pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4)

# %%
budget = pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4)

# %%
budget.info()

# %%
budget.loc[0]

# %%
budget.loc["Norge"]

# %%
pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4, index_col=0)


# %%
budget = pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4, index_col=0)

# %%
budget.info()

# %%
budget.describe()

# %%
budget.loc["Norge"]

# %%
budget.loc[0]

# %%
budget.iloc[0]

# %%
budget.Budsjettiltak

# %%
budget.Lån og garantier

# %%
budget["Lån og garantier"]

# %%
budget.loc[:, "Lån og garantier"]

# %%
pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4, index_col=0).rename(columns={"Budsjettiltak": "tiltak", "Lån og garantier": "lån"})

# %%
budget = (
    pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4, index_col=0)
    .rename(columns={"Budsjettiltak": "tiltak", "Lån og garantier": "lån"})
)

# %% [markdown]
# ### Exercise
#
# Read data from the file `r"..\data\driftsinntekter-2021.xls"` with `pandas`. Which parameters do you need to specify? Use the [`pandas` documentation](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_excel.html) to look up available parameters. 

# %%
pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1)

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

# %% [markdown]
# Is the `income` data frame tidy?
#
# > No, _2019_, _2020_, and _2021_ are not variables. They are values of a _year_ variable

# %% [markdown]
# ### Melt messy datasets to tidy them

# %%
income.melt()

# %%
income.melt(id_vars=["category"])

# %%
income.melt(id_vars=["category"], var_name="year")


# %%
income.melt(id_vars=["category"], var_name="year", value_name="income")

# %%
income = (
    pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1)
    .rename(columns={"Category": "category"})
    .melt(id_vars=["category"], var_name="year", value_name="income")
)

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

# %% [markdown]
# ### Aggregations: sum, mean, median, first, count, ...

# %% [markdown]
# ### Exercise

# %% [markdown]
# ## Combine Data Tables

# %% [markdown]
# ### Append tables with similar data

# %% [markdown]
# ### Exercise

# %% [markdown]
# ### Join tables with common variables

# %% [markdown]
# ### Exercise

# %% [markdown]
# ## Sharing Insights

# %% [markdown]
# ### Mess up data for presentation

# %% [markdown]
# ### Save to Excel

# %% [markdown]
# ### More visualizations

# %% [markdown]
#

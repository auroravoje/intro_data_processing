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
#     display_name: Python 3 (ipykernel)
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
pd.read_excel("../data/kap1.xlsx", sheet_name="1.2", header=4, index_col=0).rename(
    columns={"Budsjettiltak": "tiltak", "Lån og garantier": "lån"}
)

# %%
budget = pd.read_excel(
    "../data/kap1.xlsx", sheet_name="1.2", header=4, index_col=0
).rename(columns={"Budsjettiltak": "tiltak", "Lån og garantier": "lån"})

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
income = pd.read_excel("../data/driftsinntekter-2021.xlsx", header=1).rename(
    columns={"Category": "category"}
)
income

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
        "TVNorge": [
            "The Big Bang Theory",
            "Alltid beredt",
            "Kongen befaler",
            "Praktisk info",
        ],
    }
)
schedule

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
    pd.read_excel(
        "../data/kap1.xlsx", sheet_name="1.2", header=4, index_col=0, na_values="-"
    )
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
(
    trips.groupby("start_station_name")
    .size()
    .reset_index()
    .rename(columns={0: "num_trips"})
)

# %%
(
    trips.groupby("start_station_name")
    .size()
    .reset_index()
    .rename(columns={0: "num_trips"})
    .sort_values(by="num_trips")
)

# %%
(
    trips.groupby("end_station_name")
    .size()
    .reset_index()
    .rename(columns={0: "num_trips"})
    .sort_values(by="num_trips")
)

# %%
num_trips = (
    trips.groupby("start_station_name")
    .size()
    .reset_index()
    .rename(columns={0: "num_trips"})
    .sort_values(by="num_trips")
)

# %% [markdown]
# ### Aggregations: sum, mean, median, first, count, ...

# %%
trips.groupby("start_station_name").median()

# %%
trips.groupby("start_station_name").agg(median_duration=("duration", "median"))

# %%
# Sidenote, we could do the size example as follows
trips.groupby("start_station_name").agg(
    num_trips=("start_station_name", "size")
).reset_index().sort_values(by="num_trips")

# %%
trips.groupby("start_station_name").agg(
    median_duration=("duration", "median"),
    description=("start_station_description", "first"),
)


# %%
def most_common(column):
    return column.mode().iloc[0]


trips.groupby("start_station_name").agg(
    median_duration=("duration", "median"),
    description=("start_station_description", "first"),
    common_end_station=("end_station_name", most_common),
)

# %%
trips.groupby(["start_station_name", "end_station_name"]).agg(
    median_duration=("duration", "median")
)

# %%
trips.groupby(["start_station_name", "end_station_name"]).agg(
    median_duration=("duration", "median"),
    start_station_description=("start_station_description", "first"),
    end_station_description=("end_station_description", "first"),
)

# %%
trips.groupby(["start_station_name", "end_station_name"]).agg(
    median_duration=("duration", "median"),
    start_station_description=("start_station_description", "first"),
    end_station_description=("end_station_description", "first"),
).reset_index()

# %% [markdown]
# ### Exercise

# %% [markdown]
# ## Combine Data Tables
#
# We have two files with the same kinds of data: `08.csv` with data for August and `09.csv` with data for September. How can we combine them into one DataFrame?

# %%
trips_aug = pd.read_csv("../data/08.csv", parse_dates=["started_at", "ended_at"])
trips_sep = pd.read_csv("../data/09.csv", parse_dates=["started_at", "ended_at"])

# %% [markdown]
# ### Append tables with similar data

# %%
pd.concat([trips_aug, trips_sep])

# %%
pd.concat([trips_aug, trips_sep]).reset_index()

# %%
pd.concat([trips_aug, trips_sep]).reset_index(drop=True)

# %%
for filnavn in ["../data/08.csv", "../data/09.csv"]:
    print(filnavn)

# %%
for filnavn in ["../data/08.csv", "../data/09.csv"]:
    print(filnavn)
    trips = pd.read_csv(filnavn, parse_dates=["started_at", "ended_at"])

# %%
trips.started_at

# %%
months = []
for filnavn in ["../data/08.csv", "../data/09.csv"]:
    print(filnavn)
    months.append(pd.read_csv(filnavn, parse_dates=["started_at", "ended_at"]))

# %%
months

# %%
months = []
for filnavn in ["../data/08.csv", "../data/09.csv"]:
    print(filnavn)
    months.append(pd.read_csv(filnavn, parse_dates=["started_at", "ended_at"]))
trips = pd.concat(months).reset_index(drop=True)

# %%
data

# %%
import pathlib

pathlib.Path.cwd().parent / "data"

# %%
(pathlib.Path.cwd().parent / "data").glob("*.csv")

# %%
list((pathlib.Path.cwd().parent / "data").glob("*.csv"))

# %%
months = []
for filnavn in ["../data/08.csv", "../data/09.csv"]:
    print(filnavn)
    months.append(pd.read_csv(filnavn, parse_dates=["started_at", "ended_at"]))
trips = pd.concat(months).reset_index(drop=True)

# %% [markdown]
# ### Exercise

# %% [markdown]
# ### Join tables with common variables

# %%
num_trips

# %%
trip_lengths = (
    trips.groupby("start_station_name")
    .agg(median_duration=("duration", "median"))
    .reset_index()
    .sort_values(by="median_duration")
)
trip_lengths

# %%
pd.merge(num_trips, trip_lengths)

# %%
num_trips_from = (
    trips.groupby("start_station_name")
    .agg(num_trips=("start_station_name", "size"))
    .sort_values(by="num_trips")
    .reset_index()
)
num_trips_from

# %%
num_trips_to = (
    trips.groupby("end_station_name")
    .agg(num_trips=("end_station_name", "size"))
    .sort_values(by="num_trips")
    .reset_index()
)
num_trips_to

# %%
pd.merge(num_trips_from, num_trips_to)

# %%
pd.merge(
    num_trips_from,
    num_trips_to,
    left_on="start_station_name",
    right_on="end_station_name",
)

# %%
popular_from = num_trips_from.nlargest(10, "num_trips")
popular_to = num_trips_to.nlargest(10, "num_trips")

# %%
pd.merge(
    popular_from, popular_to, left_on="start_station_name", right_on="end_station_name"
)

# %%
pd.merge(
    popular_from,
    popular_to,
    how="inner",
    left_on="start_station_name",
    right_on="end_station_name",
)

# %%
pd.merge(
    popular_from,
    popular_to,
    how="left",
    left_on="start_station_name",
    right_on="end_station_name",
)

# %%
pd.merge(
    popular_from,
    popular_to,
    how="right",
    left_on="start_station_name",
    right_on="end_station_name",
)

# %%
pd.merge(
    popular_from,
    popular_to,
    how="outer",
    left_on="start_station_name",
    right_on="end_station_name",
)

# %% [markdown]
# ### Exercise

# %% [markdown]
# ## Sharing Insights

# %% [markdown]
# ### Mess up data for presentation

# %%
from_to = (
    trips.groupby(["start_station_name", "end_station_name"])
    .agg(num_trips=("start_station_name", "size"))
    .reset_index()
    .sort_values(by="num_trips")
)

# %%
from_to.query(
    "start_station_name.isin(@popular_from.start_station_name) and end_station_name.isin(@popular_to.end_station_name)"
).pivot_table(
    index="start_station_name", columns="end_station_name", values="num_trips"
)

# %% [markdown]
# ### Save to Excel

# %% [markdown]
# ### More visualizations

# %%
from_to

# %%
num_trips_to = (
    trips.groupby("end_station_name")
    .agg(num_trips=("end_station_name", "size"), lat=("end_station_latitude", "first"), lon=("end_station_longitude", "first"))
    .sort_values(by="num_trips")
    .reset_index()
)

# %%
import numpy as np
pd.merge(
    num_trips_from,
    num_trips_to,
    left_on="start_station_name",
    right_on="end_station_name",
    suffixes=("_from", "_to")
).assign(from_over_to=lambda df: np.log(df.num_trips_from/df.num_trips_to)).plot.scatter(x="lon", y="lat", c="from_over_to")

# %%

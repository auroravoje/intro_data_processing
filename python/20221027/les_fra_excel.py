# %% Importer pakker
import pandas as pd

# %% Les inn budsjettdata fra Excel
budget = pd.read_excel(
    "kap1.xlsx", sheet_name="1.2", header=4, usecols="A:C", na_values="-"
).rename(columns={" ": "land", "Lån og garantier": "lån", "Budsjettiltak": "tiltak"})

# %% Les inn årsrapportdata fra Excel
inntekter = (
    pd.read_excel("driftsinntekter-2021.xlsx", header=1, na_values="-")
    .melt(id_vars=["Category"], var_name="year", value_name="income")
    .rename(columns={"Category": "category"})
    .astype({"year": "int"})
)

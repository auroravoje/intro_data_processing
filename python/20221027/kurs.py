# %%
# Introduksjon til pandas
#
import pandas as pd

pd.__version__

pd.read_excel
pd.read_excel()  # Feil: trenger et filnavn
pd.read_excel("kap1.xlsx")
pd.read_excel("kap1.xlsx", sheet_name="1.2")
budget = pd.read_excel("kap1.xlsx", sheet_name="1.2")
budget = pd.read_excel("kap1.xlsx", sheet_name="1.2", header=5)
budget = pd.read_excel("kap1.xlsx", sheet_name="1.2", header=4)
budget = pd.read_excel("kap1.xlsx", sheet_name="1.2", header=4, usecols="A:F")
budget = pd.read_excel("kap1.xlsx", sheet_name="1.2", header=4, usecols="A:C")

# %%
# Quick aside: funksjoner - og bruk av innrykk
def heisann(navn):
    store_bokstaver = navn.upper()
    return f"Hei {store_bokstaver}"


heisann("Geir Arne")


def heisann(navn):
    store_bokstaver = navn.upper()


def heisann(navn):
    store_bokstaver = navn.upper()


"Heisann"

# %%
# Quick aside: tupler, lister, og dictionaries
tall = [1, 2, 3]
tall
tall.append(4)
tall

tuppel = (2, 3, 4)
tuppel.append(5)  # Feil: tupler kan ikke endres etter at de er laget
{"navn": "Geir Arne", "by": "Oslo"}

# %%
# Docstring i funksjoner brukes aktivt som hjelpetekst
def heisann(navn):
    """Lag en hilsen"""
    store_bokstaver = navn.upper()
    return f"Hei {store_bokstaver}"


heisann("GA")
help(heisann)


def heisann(navn):
    """Lag en hilsen

    navn: tekst
    """
    store_bokstaver = navn.upper()
    return f"Hei {store_bokstaver}"


# %%
# Oversikt over en dataframe
budget.info()
budget.describe()
budget.Budsjettiltak
# budget.Lån og garantier  # Feil, kan ikke bruke . hvis kolonnenavnene inneholder mellomrom
budget["Budsjettiltak"]
budget["Lån og garantier"]
budget.rename(columns={"Lån og garantier": "lån"})
budget.rename(columns={"Lån og garantier": "lån", "Budsjettiltak": "tiltak"})
budget = pd.read_excel("kap1.xlsx", sheet_name="1.2", header=4, usecols="A:C").rename(
    columns={"Lån og garantier": "lån", "Budsjettiltak": "tiltak"}
)
budget.tiltak
budget.Norge

# %%
# index: radnavn
budget.index
budget.set_index(" ")
budget.set_index(budget.columns[0])
budget = pd.read_excel(
    "kap1.xlsx", sheet_name="1.2", header=4, usecols="A:C", index_col=0
).rename(columns={"Lån og garantier": "lån", "Budsjettiltak": "tiltak"})
budget.loc["Norge"]
budget.info()
budget.index.name

# %%
# Hent rader og kolonner
budget.loc["Norge"]
budget.iloc[5]
budget.iloc[0]
budget.loc["Norge", "tiltak"]
budget.loc[["Norge", "Sverige", "Danmark"]]
budget.iloc[2:5]
budget.loc["Finland":"Norge"]
budget.loc["Norge":"Finland"]
budget.loc["Norge":"Finland":-1]

# %%
# Tidy data
inntekter = pd.read_excel("driftsinntekter-2021.xlsx", header=1)
inntekter
inntekter.melt()
inntekter.melt(id_vars=["Category"])
inntekter.melt(id_vars=["Category"], var_name="pannekake")
inntekter.melt(id_vars=["Category"], var_name="year")
inntekter.melt(id_vars=["Category"], var_name="year", value_name="income")
inntekter.melt(id_vars=["Category"], var_name="year", value_name="income").rename(
    columns={"Category": "category"}
)

# %%
# Oppgave 2
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
# LUNSJPAUSE
schedule
schedule.melt()
schedule.melt(id_vars=["hour"])
schedule.melt(id_vars=["hour"], value_vars=["NRK1", "TV2"])
schedule.melt(id_vars=["hour"], value_vars=["NRK1", "TV2", "TVNorge"])
schedule.melt(
    id_vars=["hour"], value_vars=["NRK1", "TV2", "TVNorge"], var_name="channel"
)
schedule.melt(
    id_vars=["hour"],
    value_vars=["NRK1", "TV2", "TVNorge"],
    var_name="channel",
    value_name="program",
)
schedule.melt(
    id_vars=["hour", "NRK1"],
    value_vars=["TV2", "TVNorge"],
    var_name="channel",
    value_name="program",
)
schedule.melt(
    id_vars=["NRK1"],
    value_vars=["TV2", "TVNorge"],
    var_name="channel",
    value_name="program",
)

inntekter = (
    pd.read_excel("driftsinntekter-2021.xlsx", header=1)
    .melt(id_vars=["Category"], var_name="year", value_name="income")
    .rename(columns={"Category": "category"})
)
inntekter.info()
inntekter.astype("int")  # Feil: hele dataframe'n kan ikke gjøres om til heltall
inntekter.astype({"year": "int"})
inntekter.astype({"year": "int"}).info()
inntekter.astype({"year": "int", "income": "float"}).info()
inntekter = (
    pd.read_excel("driftsinntekter-2021.xlsx", header=1, na_values="-")
    .melt(id_vars=["Category"], var_name="year", value_name="income")
    .rename(columns={"Category": "category"})
    .astype({"year": "int"})
)
inntekter.info()

# %%
# Manglende data
inntekter.dropna()
inntekter.fillna()
inntekter.fillna(0)
inntekter.fillna(method="ffill")
inntekter.sort_values(by="category").fillna(method="ffill")
inntekter.sort_values(by=["category", "year"]).fillna(method="ffill")

# %%
# Manipulasjon av data
budget = pd.read_excel(
    "kap1.xlsx", sheet_name="1.2", header=4, usecols="A:C", na_values="-"
).rename(columns={" ": "land", "Lån og garantier": "lån", "Budsjettiltak": "tiltak"})

budget.tiltak
budget["tiltak"]
budget.tiltak * 2
budget.tiltak * 2 + 1
budget.tiltak + budget.lån
budget
budget.dropna()

# %%
# Filtrering av data
budget.lån > 20
budget.loc[budget.lån > 20]
budget.query("lån > 20")
budget.tiltak + budget.lån
budget.assign(total=budget.tiltak + budget.lån)
budget.assign(total=budget.tiltak + budget.lån).query("total < 10")
budget.assign(total=budget.tiltak + budget.lån).loc[
    budget.total < 10
]  # Feil, total finnes ikke på budget
budget_w_total = budget.assign(total=budget.tiltak + budget.lån)
budget_w_total.loc[budget_w_total.total < 10]

budget = budget.assign(total=budget.tiltak + budget.lån)
budget.loc[budget.total < 10]

# %%
# Sortering av data
budget.sort_values()
budget.sort_values(by="total")
budget.sort_values(by="total", na_position="first")
budget.sort_values(by="total", na_position="first", ascending=False)
budget.sort_values(by="lån")
budget.sort_values(by=["lån", "tiltak"])
budget.sort_values(by=["lån", "tiltak"]).reset_index()
budget.sort_values(by=["lån", "tiltak"]).reset_index(drop=True)

# PAUSE TIL 13:15
# %%
# Bysykkeldata - innlesing av CSV
pd.read_csv("09.csv")
data = pd.read_csv("09.csv")
data.info()
data = pd.read_csv("09.csv", parse_dates=["started_at", "ended_at"])
data.info()
data.ended_at - data.started_at

# %%
# Aggregering av data
data.groupby("start_station_name")
data.groupby("start_station_name").size()
data.groupby("start_station_name").size().sort_values()
data.groupby("end_station_name").size().sort_values()

data.groupby("start_station_name").median()
data.groupby("start_station_name").agg({"duration": "median"})
data.groupby("start_station_name").agg(
    {"duration": "median", "end_station_name": "first"}
)
data.groupby("start_station_name").agg(
    {
        "duration": "median",
        "end_station_name": "mode",
    }  # Feil: mode er ikke en kjent funksjon
)

# %%
# Lag en egen aggregeringsfunksjon
data.end_station_name.mode()


def most_common(end_stations):
    print(end_stations)


data.groupby("start_station_name").agg(
    {"duration": "median", "end_station_name": most_common}
)


def most_common(end_stations):
    return end_stations.mode().iloc[0]


data.groupby("start_station_name").agg(
    {"duration": "median", "end_station_name": most_common}
)

# %%
# Bedre syntax for aggregering
data.groupby("start_station_name").agg(median_duration=("duration", "median"))
data.groupby("start_station_name").agg(
    median_duration=("duration", "median"),
    common_end_station=("end_station_name", most_common),
)
data.groupby(["start_station_name", "end_station_name"]).agg(
    median_duration=("duration", "median")
)
data.groupby(["start_station_name", "end_station_name"]).agg(
    median_duration=("duration", "median"), num_trips=("duration", "size")
)
data.groupby(["start_station_name", "end_station_name"]).agg(
    median_duration=("duration", "median"), num_trips=("duration", "size")
).reset_index()
data.groupby(["start_station_name", "end_station_name"]).agg(
    median_duration=("duration", "median"), num_trips=("duration", "size")
).reset_index().sort_values(by="num_trips")

# %%
# Slå sammen flere datasett
data_sep = pd.read_csv("09.csv")
data_aug = pd.read_csv("08.csv")
pd.concat([data_aug, data_sep])

data_aug.append(data_sep)  # Snart feil: .append() er en utdatert versjon av .concat()


# %%
# Slå sammen data "sidelengs" (database joins)
start_aug = (
    data_aug.groupby("start_station_name")
    .agg(duration=("duration", "median"), num_trips=("duration", "size"))
    .reset_index()
)
start_sep = (
    data_sep.groupby("start_station_name")
    .agg(duration=("duration", "median"), num_trips=("duration", "size"))
    .reset_index()
)
start_aug
start_sep

pd.merge(start_aug, start_sep)
pd.merge(start_aug, start_sep, on="start_station_name")
pd.merge(start_aug, start_sep, on="start_station_name", suffixes=("_aug", "_sep"))
pd.merge(
    start_aug,
    start_sep,
    how="outer",
    on="start_station_name",
    suffixes=("_aug", "_sep"),
)
pd.merge(
    start_aug, start_sep, how="left", on="start_station_name", suffixes=("_aug", "_sep")
)

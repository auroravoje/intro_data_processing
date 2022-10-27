import pandas as pd

data = pd.read_csv("09.csv", parse_dates=["started_at", "ended_at"])


def most_common(stations):
    return stations.mode().iloc[0]


trips = data.groupby("start_station_name").agg(
    {"duration": "median", "end_station_name": most_common}
)

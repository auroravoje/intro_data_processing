# Exercize 6 - finalize cleanup: 
# Inspect the code, what is left to clean?
# Process the last step.

from_to %>% 
  filter((start_station_name %in% popular_from$start_station_name) & (end_station_name %in% popular_to$end_station_name)) %>% 
  pivot_wider(names_from=end_station_name, values_from=num_trips) %>% View()
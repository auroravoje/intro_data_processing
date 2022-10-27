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

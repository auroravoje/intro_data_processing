# Tidy the following tv-program data frame with gather():

#Data frame creation from scratch is done by column-wise:
hour <- c(19, 20, 21, 22)
NRK1 <- c("Dagsrevyen", "Beat for beat", "Nytt på nytt", "Lindmo")
TV2 <- c("Kjære landsmenn", "Forræder", "21-nyhetene", "Farfar")
TVNorge <- c("The Big Bang Theory", "Alltid beredt", "Kongen befaler", "Praktisk info")

#Add columns to the dataframe:
schedule <-data.frame(hour,NRK1,TV2,TVNorge)

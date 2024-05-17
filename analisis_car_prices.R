library(tidyverse)
library(modelr)

df = read_csv("car_prices.csv")

# Exploracion de df
nas = summary(df)
nas

# Chequeo de errores estructurales
glimpse(df)
# year: dbl --> int
# condition: dbl --> int
# odometer: dbl --> int
# mmr: dbl --> int
# sellingprice: dbl --> int

df = df %>%
  mutate(year = as.integer(year), 
         condition = as.integer(condition),
         odometer = as.integer(odometer),
         mmr = as.integer(mmr),
         sellingprice = as.integer(sellingprice))

# comentario
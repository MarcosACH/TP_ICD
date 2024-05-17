library(tidyverse)
library(modelr)

df = read_csv("car_prices.csv")

### Exploracion de df
nas = summary(df)
nas

  # Cuantos NA hay en cada variable 

# "year" = 0
df %>%
  summarise(cant_cars = n(),
            na.year = sum(is.na(year)))

# "make" = 10301
df %>%
  summarise(cant_cars = n(),
            na.make = sum(is.na(make)))

# "model" = 10399
df %>%
  summarise(cant_cars = n(),
            na.model = sum(is.na(model)))

# "trim" = 10651
df %>%
  summarise(cant_cars = n(),
            na.trim = sum(is.na(trim)))

# "body" = 13195
df %>%
  summarise(cant_cars = n(),
            na.body = sum(is.na(body)))

# "transmission" = 65352
df %>%
  summarise(cant_cars = n(),
            na.transmission = sum(is.na(transmission)))

# "vin" = 4
df %>%
  summarise(cant_cars = n(),
            na.vin = sum(is.na(vin)))

# "state" = 0
df %>%
  summarise(cant_cars = n(),
            na.state = sum(is.na(state)))

# "condition" = 11820
df %>%
  summarise(cant_cars = n(),
            na.condition = sum(is.na(condition)))

# "odometer" = 94
df %>%
  summarise(cant_cars = n(),
            na.odometer = sum(is.na(odometer)))

# "color" = 749
df %>%
  summarise(cant_cars = n(),
            na.color = sum(is.na(color)))

# "interior" = 749
df %>%
  summarise(cant_cars = n(),
            na.interior = sum(is.na(interior)))

# "seller" = 0
df %>%
  summarise(cant_cars = n(),
            na.seller = sum(is.na(seller)))

# "mmr" = 38
df %>%
  summarise(cant_cars = n(),
            na.mmr = sum(is.na(mmr)))

# "sellingprice" = 12
df %>%
  summarise(cant_cars = n(),
            na.sellingprice = sum(is.na(sellingprice)))

# "saledate" = 12
df %>%
  summarise(cant_cars = n(),
            na.saledate = sum(is.na(saledate)))







### Chequeo de errores estructurales
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


# Eliminando las filas con km outliers

df <- df %>%
  filter(!(year >= 2013 & odometer == 999999))

# Eliminando las filas con "make" == NA y "model" = NA

df <- df %>%
  filter(!(is.na(model) & is.na(make)))

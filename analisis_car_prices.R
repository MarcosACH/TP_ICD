install.packages("gridExtra")
library(tidyverse)
library(modelr)
library(ggplot2)
library(gridExtra)

### Importacion del .csv

df = read_csv("car_prices.csv")





### Limpieza de datos
# Exploracion del data frame

summary(df)  # summary() solo nos informa los NA's de las variables numericas.
glimpse(df)
str(df)



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



# Cantidad de NA's en cada variable

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



# Chequeo de outliers

df %>%
  summarise(rango_year = range(year, na.rm = T), 
            rango_condition = range(condition, na.rm = T),
            rango_odometer = range(odometer, na.rm = T),
            rango_mmr = range(mmr, na.rm = T),
            rango_sellingprice = range(sellingprice, na.rm = T))


p1 = ggplot(data = df) + 
  geom_boxplot(mapping = aes(x = factor(1), y = year)) +
  labs(title = "Year", x = NULL, y = NULL) +
  theme(plot.title = element_text(hjust = 0.5))

p2 = ggplot(data = df) + 
  geom_boxplot(mapping = aes(x = factor(1), y = condition)) +
  labs(title = "Condition", x = NULL, y = NULL) +
  theme(plot.title = element_text(hjust = 0.5))

p3 = ggplot(data = df) + 
  geom_boxplot(mapping = aes(x = factor(1), y = odometer)) +
  labs(title = "Odometer", x = NULL, y = NULL) +
  theme(plot.title = element_text(hjust = 0.5))

p4 = ggplot(data = df) + 
  geom_boxplot(mapping = aes(x = factor(1), y = mmr)) +
  labs(title = "MMR", x = NULL, y = NULL) +
  theme(plot.title = element_text(hjust = 0.5))

p5 = ggplot(data = df) + 
  geom_boxplot(mapping = aes(x = factor(1), y = sellingprice)) +
  labs(title = "Selling Price", x = NULL, y = NULL) +
  theme(plot.title = element_text(hjust = 0.5))

grid.arrange(p1, p2, p3, p4, p5, ncol = 2)



# Chequeo de irregularidades en las variables de tipo "chr"

unique_make = summarise(df, unique_make = unique(make))
unique_model = summarise(df, unique_model = unique(model))
unique_trim = summarise(df, unique_trim = unique(trim))
unique_body = summarise(df, unique_body = unique(body))
unique_transmission = summarise(df, unique_transmission = unique(transmission))
unique_vin = summarise(df, unique_vin = unique(vin))
unique_state = summarise(df, unique_state = unique(state))
unique_color = summarise(df, unique_color = unique(color))
unique_interior = summarise(df, unique_interior = unique(interior))
unique_seller = summarise(df, unique_seller = unique(seller))



# Eliminando las filas con km outliers

df = df %>%
  filter(!(year >= 2013 & odometer == 999999))

# Eliminando las filas con "make" == NA y "model" = NA

df = df %>%
  filter(!(is.na(model) & is.na(make)))

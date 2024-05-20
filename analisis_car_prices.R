install.packages("gridExtra")
library(tidyverse)
library(modelr)
library(ggplot2)
library(gridExtra)

### Importacion del .csv.

df = read_csv("car_prices.csv")


# -------------------------------------------------------------------------------------------------------------------


### Limpieza de datos.
# Exploracion del data frame.

summary(df)  # summary() solo nos informa los NA's de las variables numericas.
glimpse(df)
str(df)



# Chequeo de errores estructurales.

glimpse(df)
# Pasar:
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



# Cantidad de NA's en cada variable.

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



# Chequeo de outliers en las variables numericas.

# Paneo general.
df %>%
  summarise(rango_year = range(year, na.rm = T), 
            rango_condition = range(condition, na.rm = T),
            rango_odometer = range(odometer, na.rm = T),
            rango_mmr = range(mmr, na.rm = T),
            rango_sellingprice = range(sellingprice, na.rm = T))



# Boxplots de las variables numericas.
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



# Chequeo de irregularidades en las variables de tipo "chr".

exclude_columns = c("vin", "saledate")  # Columnas que no corresponde cambiarlas a tipo "chr"

df = df %>%
  mutate(across(where(is.character) & !all_of(exclude_columns), tolower))  # Paso las columnas a minuscula



# Observacion de valores unicos en cada columna.

unique_make = summarise(df, unique_make = unique(make))
unique_model = summarise(df, unique_model = unique(model))
unique_trim = summarise(df, unique_trim = unique(trim))
unique_body = summarise(df, unique_body = unique(body))
unique_transmission = summarise(df, unique_transmission = unique(transmission))
unique_vin = summarise(df, unique_vin = unique(vin))  # A revisar
unique_state = summarise(df, unique_state = unique(state))
unique_color = summarise(df, unique_color = unique(color))
unique_interior = summarise(df, unique_interior = unique(interior))
unique_seller = summarise(df, unique_seller = unique(seller))
  


# Unifico formato de la columna "make".

df = df %>%
  mutate(make = if_else(grepl("mercedes", make), "mercedes benz", make),
         make = if_else(grepl("land", make) | make == "landrover", "land rover", make),
         make = if_else(grepl("gmc", make), "gmc", make),
         make = if_else(grepl("dodge", make), "dodge", make),
         make = if_else(grepl("rolls", make), "rolls royce", make),
         make = if_else(grepl("mazda", make), "mazda", make),
         make = if_else(grepl("hyundai", make), "hyundai", make),
         make = if_else(make == "vw", "volkswagen", make),
         make = if_else(grepl("chev", make), "chevrolet", make),
         make = if_else(grepl("ford", make), "ford", make))



# Unifico formato de la columna "body".

df = df %>%
  mutate(body = if_else(grepl("coupe", body), "coupe", body),
         body = if_else(grepl("koup", body), "coupe", body),
         body = if_else(grepl("wagon", body), "wagon", body),
         body = if_else(grepl("convertible", body), "convertible", body),
         body = if_else(grepl("regular-cab", body), "regular cab", body),
         body = if_else(("ram van" == body) | ("transit van" == body) | ("promaster cargo van" == body),
                        "van", body),
         body = if_else(grepl("cab plus", body), "cab plus", body))

# print(count(df, body), n = 46)

# Elimino los valores "sedan" de la columna "transmission" ya que son incorrectos.

df_sedan = df %>%  # Observo solo las filas "sedan"
  filter(transmission == "sedan")

df = subset(df, !(transmission == "sedan" & !is.na(transmission)))  # Elimino las filas "sedan"


# En la columna "vin" hay valores repetidos, cuando se supone que deberian ser todos valores unicos.
# ¿Que hacemos?

df_vin = df %>%
  filter(!grepl("[0-9]$", vin))  # Observo si hay filas en "vin" que no terminen con un numero


# Cambio los valores "—" de la columna "color" a NA.

df = df %>%
  mutate(color = if_else(color == "—", NA, color))


# Cambio los valores "—" de la columna "interior" a NA.

df = df %>%
  mutate(interior = if_else(interior == "—", NA, interior))



# Elimino las filas con km outliers.

df = df %>%
  filter(!(year >= 2013 & odometer == 999999))

# Elimino las filas con "make" == NA y "model" = NA.

df = df %>%
  filter(!(is.na(model) & is.na(make)))


# -------------------------------------------------------------------------------------------------------------------


### Graficos.

#odo_vs_year = ggplot(data = df) +
#  geom_point(mapping = aes(x = year, y = odometer)) + 
#  labs(x = "Años", y = "Kilometraje [km]") + 
#  labs(title = "Kilometraje vs Años")

#odo_vs_year



sellingp_vs_transmission = ggplot(data = df) + 
  geom_jitter(mapping = aes(x = transmission, y = sellingprice),
              alpha = 0.2) + 
  geom_boxplot(mapping = aes(x = transmission, y = sellingprice), fill = "grey") +
  labs(x = "Transmision del auto", y = "Precio de Venta [USD]") + 
  labs(title = "Precio de venta en base a la transmision")

sellingp_vs_transmission



sellingp_vs_mmr = ggplot(data = df) + 
  geom_point(mapping=aes(x = mmr, y = sellingprice)) + 
  geom_abline(mapping=aes(slope = 1, intercept = 0), colour = "red") +
  labs(x = "Precio estimado de venta [USD]", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta respecto al precio de venta estimado")

sellingp_vs_mmr



sellingp_vs_odometer = ggplot(data=df) + 
  geom_point(mapping=aes(x = odometer, y = sellingprice)) +
  labs(x = "Kilometraje [km]", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base al kilometraje")

sellingp_vs_odometer



# podriamos agrupar cada 5 años en otro data frame y hacer un boxplot
sellingp_vs_year = ggplot(data=df) + 
  geom_boxplot(mapping=aes(x = factor(year), y = sellingprice)) + 
  labs(x = "Año del vehiculo", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base al año del auto") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

sellingp_vs_year



sellingp_vs_body = ggplot(data=df) + 
  geom_boxplot(mapping=aes(x = body, y = sellingprice)) + 
  labs(x = "Tipo de vehiculo", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base al tipo de auto") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

sellingp_vs_body



sellingp_vs_make = ggplot(data=df) + 
  geom_boxplot(mapping=aes(x = make, y = sellingprice)) + 
  labs(x = "Marca del vehiculo", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base a la marca del auto") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

sellingp_vs_make



sellingp_vs_state = ggplot(data=df) + 
  geom_boxpplot(mapping=aes(x = state, y = sellingprice)) + 
  labs(x = "Ubicacion de consecionaria", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base a la ubicacion de la consecionaria") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

sellingp_vs_state



sellingp_vs_condition = ggplot(data=df) + 
  geom_boxplot(mapping=aes(x = factor(condition), y = sellingprice),  alpha=0.4) +
  labs(x = "Condicion del vehiculo", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base a la condicion del auto") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

sellingp_vs_condition



condition_vs_year <- ggplot(data=df) + 
  geom_boxplot(mapping=aes(y= condition, x = factor(year)),  alpha=0.4) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

condition_vs_year



mayor_a_50000_menor_a_6_condition <- filter(df,condition<6 & sellingprice>50000)
print(count(mayor_a_50000_menor_a_6_condition, make, year),n=400)



menor_a_50000_condition_6_a_18 <- filter(df,condition>5 & condition<19 & sellingprice<50000)
print(count(menor_a_50000_condition_6_a_18, make, year),n=400)



ggplot(menor_a_6_condition)+
  geom_boxplot(aes(x=factor(year), y=sellingprice))


ggplot(menor_a_50000_condition_6_a_18)+
  geom_boxplot(aes(x=factor(year), y=sellingprice))


mayor_a__condition <- filter(df,condition>6)
print(mayor_a_6_condition)
print(count(mayor_a_6_condition, year),n=52)

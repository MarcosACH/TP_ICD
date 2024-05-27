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
problems(df)



# Chequeo de errores estructurales.

glimpse(df)
# Type casting:
# year: dbl --> int
# condition: dbl --> int
# odometer: dbl --> int
# mmr: dbl --> int
# sellingprice: dbl --> int

df_cleaned = df %>%
  mutate(across(where(is.double), as.integer))



# Analizamos patrones en la columna "condition".

ggplot(data = df_cleaned) +
  geom_point(mapping = aes(x=condition, y=sellingprice))  # Posiblemente se trate de una escala del 1.0 - 5.0 (no hay valores en los multiplos de 10)

# Modificamos los valores de la columna "condition".

df_cleaned = df_cleaned %>%
  mutate(condition = if_else(condition <= 5, condition * 10, condition))  # Multiplico * 10 los valores <= 5



# Cantidad de NaN's en cada variable.

for (colname in colnames(df_cleaned)) {
  nan_count = sum(is.nan(df_cleaned[[colname]]))
  cat("NaN's de", colname, ":", nan_count, "\n")
}



# Cantidad de NA's en cada variable.

for (colname in colnames(df_cleaned)) {
  na_count = sum(is.na(df_cleaned[[colname]]))
  cat("Na's de", colname, ":", na_count, "\n")
}



# Chequeo de irregularidades en las variables de tipo "chr".

exclude_columns = c("vin", "saledate")  # Columnas que no corresponde cambiarlas a tipo "chr"

df_cleaned = df_cleaned %>%
  mutate(across(where(is.character) & !all_of(exclude_columns), tolower))  # Paso las columnas a minuscula



# Observacion de valores unicos en cada columna.

unique_make = count(df_cleaned, make, name = "count")
unique_model = count(df_cleaned, model, name = "count")
unique_trim = count(df_cleaned, trim, name = "count")
unique_body = count(df_cleaned, body, name = "count")
unique_transmission = count(df_cleaned, transmission, name = "count")
unique_vin = count(df_cleaned, vin, name = "count")
unique_state = count(df_cleaned, state, name = "count")
unique_color = count(df_cleaned, color, name = "count")
unique_interior = count(df_cleaned, interior, name = "count")
unique_seller = count(df_cleaned, seller, name = "count")
  


# Unificamos formato de la columna "make".

df_cleaned = df_cleaned %>%
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



# Unificamos formato de la columna "model".

df_cleaned = df_cleaned %>%
  mutate(model = if_else(model == "mazdaspeed mazda3" | model == "mazdaspeed3" | model == "mazdaspeed 3", "mazda3", model),
         model = if_else(model == "mazdaspeed mazda6", "mazda6", model),
         model = if_else(model == "mazdaspeed mx-5 miata", "mazda5", model))



# Unificamos formato de la columna "body".

df_cleaned = df_cleaned %>%
  mutate(body = if_else(grepl("coupe", body) | grepl("koup", body), "coupe", body),
         body = if_else(grepl("wagon", body), "wagon", body),
         body = if_else(grepl("convertible", body), "convertible", body),
         body = if_else(grepl("regular-cab", body), "regular cab", body),
         body = if_else(("ram van" == body) | ("transit van" == body) | ("promaster cargo van" == body),
                        "van", body),
         body = if_else(grepl("cab plus", body), "cab plus", body))



# Eliminamos los valores "sedan" de la columna "transmission" ya que son incorrectos.

df_sedan = df_cleaned %>%  # Observamos solo las filas "sedan"
  filter(transmission == "sedan")

df_cleaned = df_cleaned %>%
  filter(!(transmission == "sedan" & !is.na(transmission)))  # Eliminamos las filas "sedan"



# En la columna "vin" hay valores repetidos, cuando se supone que deberian ser todos valores unicos.
# ¿Que hacemos? En este caso no nos influye porque no vamos a utilizar esta columna en nuestro analisis.

df_vin = df_cleaned %>%
  filter(!grepl("[0-9]$", vin))  # Observamos si hay filas en "vin" que no terminen con un numero



# Cambiamos los valores "—" de la columna "color" a NA.

df_cleaned = df_cleaned %>%
  mutate(color = if_else(color == "—", NA, color))



# Cambiamos los valores "—" de la columna "interior" a NA.

df_cleaned = df_cleaned %>%
  mutate(interior = if_else(interior == "—", NA, interior))



# Analizamos las columnas "make" y "model" que son NA.

df_na_make_or_model = df_cleaned %>%
  filter(is.na(make) | is.na(model))  # Aproximadamente un 2% del df_cleaned cumplen esta condicion

# Eliminamos las filas con "make" == NA o "model" = NA.

df_cleaned = df_cleaned %>%
  filter(!(is.na(make) | is.na(model)))



# Chequeo de outliers en las variables numericas.

# Paneo general.

for (colname in colnames(df_cleaned)) {
  if (is.numeric(df_cleaned[[colname]])) {
    rango = range(df_cleaned[[colname]], na.rm = TRUE)
    cat("Rango", colname, ":", min(rango), "-", max(rango), "\n")
  }
}



# Boxplots de las variables numericas.

p1 = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x = factor(1), y = year)) +
  labs(title = "Year", x = NULL, y = NULL) +
  theme(plot.title = element_text(hjust = 0.5))

p2 = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x = factor(1), y = condition)) +
  labs(title = "Condition", x = NULL, y = NULL) +
  theme(plot.title = element_text(hjust = 0.5))

p3 = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x = factor(1), y = odometer)) +
  labs(title = "Odometer", x = NULL, y = NULL) +
  theme(plot.title = element_text(hjust = 0.5))

p4 = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x = factor(1), y = mmr)) +
  labs(title = "MMR", x = NULL, y = NULL) +
  theme(plot.title = element_text(hjust = 0.5))

p5 = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x = factor(1), y = sellingprice)) +
  labs(title = "Selling Price", x = NULL, y = NULL) +
  theme(plot.title = element_text(hjust = 0.5))

grid.arrange(p1, p2, p3, p4, p5, ncol = 2)



# Chequeo de outliers en las variables numericas.

# Analizamos las filas que tienen "odometer" == max(odometer) (supuestos outliers superiores).

df_odometer_max = df_cleaned %>%
  filter(year > 2005 & odometer == max(odometer, na.rm = TRUE))

# Eliminamos las filas con km outliers superiores con "year" > 2005.

df_cleaned = df_cleaned %>%
  filter(!(year > 2005 & odometer == max(odometer, na.rm = TRUE) & !is.na(odometer)))



# Analizamos las filas que tienen "odometer" == min(odometer) (supuestos outliers inferiores).

df_odometer_min = df_cleaned %>%
  filter(odometer == min(odometer, na.rm = TRUE) & year < 2014)

ggplot(data = df_odometer_min) +
  geom_density(mapping = aes(x=condition))

ggplot(data = df_odometer_min) +
  geom_point(mapping = aes(x=condition, y=sellingprice))

# Eliminamos las filas con km outliers inferiores con "odometer" == 1 y "year" < 2014

df_cleaned = df_cleaned %>%
  filter(!(year < 2014 & odometer == min(odometer, na.rm = TRUE) & !is.na(odometer)))



# Eliminamos un 0 la fila que tiene "sellingprice" = 230000 con "mmr" = 22800.

df_cleaned = df_cleaned %>%
  mutate(sellingprice = if_else(sellingprice == 230000, 23000, sellingprice))

# Analizamos las filas que tienen "sellingprice" < 300.

df_sellingp_low = df_cleaned %>%
  filter(sellingprice < 300)

df_sellingp_low = df_sellingp_low %>%
  group_by(year) %>%
  summarise(count = n())

# Eliminamos las filas con "year" > 2006 y "sellingprice" < 300, o "sellingprice" == 1.

df_cleaned = df_cleaned %>%
  filter(!((year > 2006 & sellingprice < 300 | sellingprice == 1) & !is.na(sellingprice)))



# Agrupamos por "make" y "model", y en base a la proporcion de "automatic" y "manual" en "transmission" 
# calculamos la cantidad de NA's reemplazados por "automatic" o por "manual".

df_transmission = df_cleaned %>%
  group_by(make, model) %>%
  summarise(count_automatic = sum(transmission == "automatic", na.rm = T),
            count_manual = sum(transmission == "manual", na.rm = T),
            count_nas = sum(is.na(transmission)),
            count_automatic_manual = count_automatic + count_manual,
            percent_automatic = count_automatic / count_automatic_manual,
            percent_manual = count_manual / count_automatic_manual,
            add_automatic = if_else(is.nan(percent_automatic), count_nas, floor(count_nas * percent_automatic)),
            add_manual = if_else(is.nan(percent_automatic), 0, ceiling(count_nas * percent_manual)))

# Funcion que convierte a todos los NA's de "transmission" a "automatic" o "manual" respecto a la dicha proporcion.

update_transmissions = function(df_cleaned, df_transmission) {
  for (i in seq_len(nrow(df_transmission))) {
    row = df_transmission[i, ]
    
    if (row$add_automatic > 0) {
      na_indices = which(df_cleaned$make == row$make & df_cleaned$model == row$model & is.na(df_cleaned$transmission))
      if (length(na_indices) > 0) {
        update_indices = na_indices[1:min(length(na_indices), row$add_automatic)]
        df_cleaned$transmission[update_indices] = "automatic"
      }
    }
    
    if (row$add_manual > 0) {
      na_indices = which(df_cleaned$make == row$make & df_cleaned$model == row$model & is.na(df_cleaned$transmission))
      if (length(na_indices) > 0) {
        update_indices = na_indices[1:min(length(na_indices), row$add_manual)]
        df_cleaned$transmission[update_indices] = "manual"
      }
    }
  }
  return(df_cleaned)
}

# Actualizacion de "df_cleaned".

df_cleaned = update_transmissions(df_cleaned, df_transmission)


# -------------------------------------------------------------------------------------------------------------------


# Fin de limpieza de datos.
# Guardado del data frame en un archivo .RData.

save(df_cleaned, file = "df_cleaned.RData")
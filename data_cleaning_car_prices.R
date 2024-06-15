library(tidyverse)
library(modelr)
library(gridExtra)


### Importacion del ".csv".

df = read_csv("car_prices.csv")


# -------------------------------------------------------------------------------------------------------------------


### Limpieza de datos.
# Exploracion del Data Frame.

summary(df)  # summary() solo nos informa los NA's de las variables numericas
glimpse(df)
str(df)
problems(df)



# Chequeo de errores estructurales.

# Type casting:
# year: dbl --> int
# condition: dbl --> int
# odometer: dbl --> int
# mmr: dbl --> int
# sellingprice: dbl --> int

df_cleaned = df %>%
  mutate(across(where(is.double), as.integer))



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



# Analizamos patrones en la columna "condition".

ggplot(data = df_cleaned) +
  geom_point(mapping = aes(x=condition, y=sellingprice))  # Posiblemente se trate de una escala del 1.0 al 5.0 o del 10 al 50 (no hay valores en los multiplos de 10)


# Modificamos los valores de la columna "condition" para que sean valores del 10 - 50.

df_cleaned = df_cleaned %>%
  mutate(condition = if_else(condition <= 5, condition * 10, condition))  # Multiplico * 10  a los valores <= 5



# Chequeo de irregularidades en las variables de tipo "chr".

exclude_columns = c("vin", "saledate")  # Columnas que no corresponde cambiarlas a minuscula

df_cleaned = df_cleaned %>%
  mutate(across(where(is.character) & !all_of(exclude_columns), tolower))  # Paso las columnas de tipo "chr" a minuscula



# Observacion de valores unicos en cada columna categorica.

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
  filter(!(transmission == "sedan" & !is.na(transmission)))  # Eliminamos las filas de "transmission" = sedan"



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



# Analizamos las observaciones de "make" y "model" que son NA.

df_na_make_or_model = df_cleaned %>%
  filter(is.na(make) | is.na(model))  # Aproximadamente un 2% del Data Frame cumple con esta condicion

# Eliminamos las observaciones con "make" == NA o "model" = NA.

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



# Analizamos las observaciones que tienen "odometer" == max(odometer), supuestos outliers superiores.

df_odometer_max = df_cleaned %>%
  filter(year > 2005 & odometer == max(odometer, na.rm = TRUE))

# Eliminamos las observaciones con kilometros outliers superiores con "year" > 2005.

df_cleaned = df_cleaned %>%
  filter(!(year > 2005 & odometer == max(odometer, na.rm = TRUE) & !is.na(odometer)))



# Eliminamos los autos que tienen "odometer" <= 100 (nos enfocamos en autos usados).

df_cleaned = df_cleaned %>%
  filter(!(odometer <= 100 & !is.na(odometer)))



# Eliminamos un 0 a la observacion que tiene "sellingprice" = 230000 con "mmr" = 22800 (claro error).

df_cleaned = df_cleaned %>%
  mutate(sellingprice = if_else(sellingprice == 230000, 23000, sellingprice))


# Analizamos las observaciones que tienen "sellingprice" < 300.

df_sellingp_low = df_cleaned %>%
  filter(sellingprice < 300)

df_sellingp_low = df_sellingp_low %>%
  group_by(year) %>%
  summarise(count = n())

# Eliminamos las observaciones con "sellingprice" < 300.

df_cleaned = df_cleaned %>%
  filter(!(sellingprice < 300 & !is.na(sellingprice)))



# Eliminamos los NA's de "odometer", "sellingprice", "saledate", "body" y "color" (variables significativas para el modelado, pocos valores NA).

df_cleaned = df_cleaned %>%
  filter(!(is.na(odometer) | is.na(sellingprice) | is.na(saledate) | is.na(body) | is.na(color)))



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


# Actualizamos la columna "transmission" de "df_cleaned".

df_cleaned = update_transmissions(df_cleaned, df_transmission)



# Reemplazamos los NA's de "condition" con el promedio de cada año.

df_cleaned = df_cleaned %>%
  group_by(year) %>%
  mutate(condition = if_else(is.na(condition), floor(mean(condition, na.rm = TRUE)), condition)) %>%
  ungroup()



# Convertimos la columna "saledate" a tipo "DateTime" y extraemos el día de la semana, día del mes, mes y año.

df_cleaned = df_cleaned %>%
  filter(!(grepl("^\\d", saledate) | is.na(saledate))) %>%  # Eliminamos todas las fechas NA y todas las mal ingresadas
  mutate(saledate = str_replace(saledate, "\\s\\d{2}:\\d{2}:\\d{2} GMT[+-]\\d{4} \\(.*\\)$", ""),  # Eliminamos la hora y zona horaria de la fecha
         saledate = strptime(saledate, format="%a %b %d %Y"),
         sale_day_of_week = format(saledate, "%a"),
         sale_day_of_month = format(saledate, "%d"),
         sale_month = format(saledate, "%m"),
         sale_year = format(saledate, "%Y"))



# Hacemos un type casting para terminar de establecer correctamente los tipos de dato de las variables numericas.

df_cleaned = df_cleaned %>%
  mutate(across(where(is.double), as.integer),
         sale_day_of_month = as.integer(sale_day_of_month),
         sale_month = as.integer(sale_month),
         sale_year = as.integer(sale_year))



# Observamos las concesionarias que hayan vendido al menos 200 vehiculos.

df_cleaned_sellers = df_cleaned %>%
  group_by(seller) %>%
  summarise(count = n()) %>%
  filter(count >= 200) %>%
  select(seller)


# Observamos los modelos de vehiculos que tengan al menos 200 ventas.

df_cleaned_model = df_cleaned %>%
  group_by(model) %>%
  summarise(count = n()) %>%
  filter(count >= 200) %>%
  select(model)


# Observamos los submodelos de vehiculos que tengan al menos 200 ventas.

df_cleaned_trim = df_cleaned %>%
  group_by(trim) %>%
  summarise(count = n()) %>%
  filter(count >= 200) %>%
  select(trim)


# Nos quedamos solo con las concesionarias, los modelos y submodelos de vehiculos que aparecen al menos 200 veces.

df_cleaned = df_cleaned %>%
  inner_join(df_cleaned_sellers, by = "seller") %>%
  inner_join(df_cleaned_model, by = "model") %>%
  inner_join(df_cleaned_trim, by = "trim")


# -------------------------------------------------------------------------------------------------------------------


# Fin de limpieza de datos.
# Guardado del Data Frame en un archivo ".RData".

save(df_cleaned, file = "df_cleaned.RData")

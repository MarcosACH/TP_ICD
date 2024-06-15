library(tidyverse)
library(modelr)


### Importacion de "df_cleaned".

load("df_cleaned.RData")


# -------------------------------------------------------------------------------------------------------------------


### Modelos.

mod1 = lm(df_cleaned, formula = sellingprice  ~ odometer * condition + factor(year) + make + body + seller + model + trim - 1)  # RSE: 2495, MRS: 0.9774
summary(mod1)

# Grafico de residuos vs predicciones.
plot(mod1, which=1)

mod2 = lm(df_cleaned, formula = sellingprice  ~ odometer * condition + factor(year) + make + body + seller + model + trim + color - 1)  # RSE: 2494, MRS: 0.9774
summary(mod2)

# Grafico de residuos vs predicciones.
plot(mod2, which=1)

mod3 = lm(df_cleaned, formula = sellingprice  ~ odometer * condition + factor(year) + make + body + seller + model + trim + color + state - 1)  # RSE: 2488, MRS: 0.9775
summary(mod3)

# Grafico de residuos vs predicciones.
plot(mod3, which=1)

mod4 = lm(df_cleaned, formula = sellingprice  ~ odometer * condition + factor(year) + make + body + seller + model + trim + color + state + transmission - 1)  # RSE: 2488, MRS: 0.9775
summary(mod4)

# Grafico de residuos vs predicciones.
plot(mod4, which=1)



# Comparacion de modelos con tabla ANOVA.

anova(mod1, mod2, mod3, mod4)



# Agregamos predicciones y residuos del modelo 9 al Data Frame original.

df_cleaned = df_cleaned %>%
  add_predictions(model = mod3) %>%
  add_residuals(model = mod3)



# Buscamos la concesionaria con el mayor coeficiente segun el fabricante del vehiculo.

mejor_coeficiente_concesionaria_por_fabricante = function(mod, make, data) {
  
  coefficients = coef(mod)
  
  seller_list = list()
  
  for (i in seq_len(nrow(data))) {
    if (data$make[i] == tolower(make)) {
      seller = data$seller[i]
      if (!(seller %in% seller_list)) {
        seller_list = append(seller_list, seller)
      }
    }
  }
  
  seller_coeff_names = sapply(seller_list, function(seller) {
    seller_coef_name = paste0("seller", seller)
    return(seller_coef_name)
  })

  seller_coeffs = coefficients[seller_coeff_names]
  
  highest_coef_index = which.max(seller_coeffs)
  highest_coef = seller_coeffs[highest_coef_index]
  seller_name = sub("^seller", "", names(highest_coef))
  
  return(data.frame(seller = seller_name, coefficient = highest_coef))
}

# Guardamos la mejor concesionaria que venda un determinado fabricante de vehiculos.

mejor_concesionaria = mejor_coeficiente_concesionaria_por_fabricante(mod3, "bmw", df_cleaned)



# Analizamos las ventas de la mejor concesionaria.

ventas_mejor_concesionaria = filter(df_cleaned, seller == seller_name)

ventas_mejor_concesionaria = ventas_mejor_concesionaria %>%
  mutate(Rendimiento_de_Venta = if_else(sellingprice > pred, "Encima de predicción", "Debajo de predicción"))



# Proporción del rendimiento de las ventas de vehículos de la mejor concesionaria.

ggplot(data = ventas_mejor_concesionaria) +
  geom_bar(mapping = aes(x=seller, fill=Rendimiento_de_Venta), position="fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Concesionaria", y = "Proporción del rendimiento", title = "Proporción del rendimiento de las ventas de vehículos") +
  scale_fill_discrete(name = "Rendimiento de Ventas") +
  scale_x_discrete(labels = str_to_title(seller_name))


# -------------------------------------------------------------------------------------------------------------------


# Fin del modelado.
# Guardado del Data Frame en un archivo ".RData".

save(df_cleaned, file = "df_cleaned.RData")
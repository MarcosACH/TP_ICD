library(tidyverse)
library(modelr)


### Importacion de "df_cleaned" y de "rendimiento_concesionarias".

load("df_cleaned.RData")


# -------------------------------------------------------------------------------------------------------------------


mod17 = lm(df_cleaned_prueba_definitoria, formula = sellingprice  ~ odometer + seller - 1)  # RSE: 6312, MRS: 0.8684
summary(mod17)

# Grafico de residuos vs predicciones.
plot(mod17, which=1)

mod18 = lm(df_cleaned_prueba_definitoria, formula = sellingprice  ~ odometer * condition + factor(year) + make + body + seller - 1)  # RSE: 4630, MRS: 0.9292
summary(mod18)

# Grafico de residuos vs predicciones.
plot(mod18, which=1)

mod1 = lm(df_cleaned, formula = sellingprice  ~ odometer - 1)  # RSE: 7812, MRS: 0.3493
summary(mod1)

# Grafico de residuos vs predicciones.
plot(mod1, which=1)


mod2 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) - 1)  # RSE: 7526, MRS: 0.7997
summary(mod2)

# Grafico de residuos vs predicciones.
plot(mod2, which=1)


mod3 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + transmission - 1)  # RSE: 7526, MRS: 0.7997
summary(mod3)

# Grafico de residuos vs predicciones.
plot(mod3, which=1)


mod4 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + body - 1)  # RSE: 6705, MRS: 0.841
summary(mod4)

# Grafico de residuos vs predicciones.
plot(mod4, which=1)


mod5 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + make - 1)  # RSE: 6129, MRS: 0.8672
summary(mod5)

# Grafico de residuos vs predicciones.
plot(mod5, which=1)


mod6 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + make + body - 1)  # RSE: 5294, MRS: 0.9009
summary(mod6)

# Grafico de residuos vs predicciones.
plot(mod6, which=1)


mod7 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + condition - 1)  # RSE: 7239, MRS: 0.8147
summary(mod7)

# Grafico de residuos vs predicciones.
plot(mod7, which=1)


mod8 = lm(df_cleaned, formula = sellingprice  ~ odometer + condition + factor(year) + make + body - 1)  # RSE: 5159, MRS: 0.9059
summary(mod8)

# Grafico de residuos vs predicciones.
plot(mod8, which=1)


mod9 = lm(df_cleaned, formula = sellingprice  ~ odometer * condition + factor(year) + make + body - 1) # RSE: 5159, MRS: 0.909
summary(mod9)

# Grafico de residuos vs predicciones.
plot(mod9, which=1)


mod10 = lm(df_cleaned, formula = sellingprice  ~ odometer * condition + factor(year) + make + body + transmission - 1)  # RSE: 5159, MRS: 0.909
summary(mod10)

# Grafico de residuos vs predicciones.
plot(mod10, which=1)


mod11 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + poly(condition, 2, raw=TRUE) - 1)  # RSE: 7226, MRS: 0.8153
summary(mod11)

# Grafico de residuos vs predicciones.
plot(mod11, which=1)


mod12 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) * poly(condition, 2, raw=TRUE) - 1)  # RSE: 7208, MRS: 0.8163
summary(mod12)

# Grafico de residuos vs predicciones.
plot(mod12, which=1)


mod13 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) * poly(condition, 2, raw=TRUE) + make - 1)  # RSE: 5880, MRS: 0.8777
summary(mod13)

# Grafico de residuos vs predicciones.
plot(mod13, which=1)


# Modelo muy pesado
mod14 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) * poly(condition, 2, raw=TRUE) + make + model - 1)
summary(mod14)

# Grafico de residuos vs predicciones.
plot(mod14, which=1)


# Modelo muy pesado
mod15 = lm(df_cleaned, formula= sellingprice ~ poly(year, 2, raw=TRUE) + condition * odometer + make + model + transmission + state + color + body - 1)
summary(mod15)

# Grafico de residuos vs predicciones.
plot(mod15, which=1)


mod16 = lm(df_cleaned, formula = sellingprice ~ odometer + factor(year) + condition + sale_day_of_week - 1)  # RSE: 7224, MRS: 0.8154
summary(mod16)

# Grafico de residuos vs predicciones.
plot(mod16, which=1)



# Comparacion de modelos con tabla ANOVA.

anova(mod2, mod5, mod6, mod8, mod9)



# Agregamos predicciones y residuos del modelo 9 al Data Frame original.

df_cleaned = df_cleaned %>%
  add_predictions(model = mod9) %>%
  add_residuals(model = mod9)



# Generamos rendimiento de las concesionarias.

rendimiento_concesionarias = df_cleaned %>%
  filter(pred>0) %>%
  group_by(seller) %>%
  summarise(cantidad_ventas = n(), monto_ventas = sum(sellingprice),
            monto_predicciones= sum(pred), rendimiento = (monto_ventas - monto_predicciones)) %>%
  slice_max(rendimiento, n=10)



# Relacion del rendimiento de cada concesionaria.

rendimiento_por_concesionaria = ggplot(data = rendimiento_concesionarias) + 
  geom_bar(mapping = aes(x=reorder(seller, desc(rendimiento)), y=rendimiento), stat = "identity", fill="#5d9b9b") +
  scale_y_continuous(label = scales:: label_dollar()) +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5), 
        axis.text.x = element_text(angle=45, hjust=1)) +
  labs(x = "Concesionaria", y = "Rendimiento [USD]", title = "Rendimiento obtenido por concesionaria")
rendimiento_por_concesionaria



# Analizamos las ventas de la mejor concesionaria.

ventas_financial = filter(df_cleaned, seller == "financial services remarketing (lease)")

ventas_financial = ventas_financial %>%
  mutate(Rendimiento_de_Venta = if_else(sellingprice > pred, "Encima de predicción", "Debajo de predicción"))



# Proporción del rendimiento de las ventas de vehículos de la mejor concesionaria.

ggplot(data = ventas_financial) +
  geom_bar(mapping = aes(x=seller, fill=Rendimiento_de_Venta), position="fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Concesionaria", y = "Proporción del rendimiento", title = "Proporción del rendimiento de las ventas de vehículos") +
  scale_fill_discrete(name = "Rendimiento de Ventas") +
  scale_x_discrete(labels = "Financial Services Remarketing (lease)")


# -------------------------------------------------------------------------------------------------------------------


# Fin del modelado.
# Guardado de los Data Frame en un archivo ".RData".

save(df_cleaned, file = "df_cleaned.RData")
save(rendimiento_concesionarias, file = "rendimiento_concesionarias.RData")



# -------------------------------------------------------------------------------------------------------------------
# Pruebas:

df_cleaned_prueba = df_cleaned %>%
  group_by(seller) %>%
  summarise(count = n()) %>%
  filter(count >= 200) %>%
  select(seller)

df_cleaned_prueba_definitoria = df_cleaned %>%
  inner_join(df_cleaned_prueba, by = "seller")

coefficients = coef(mod18)
coeff_names = names(coefficients)

seller_coeff_names = coeff_names[grep("^seller", coeff_names)]

seller_coeffs = coefficients[seller_coeff_names]

highest_coef = which.max(seller_coeffs)

seller_name = names(seller_coeffs)[highest_coef]

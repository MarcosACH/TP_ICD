library(tidyverse)
library(modelr)


load("df_cleaned.RData")



### Graficos.

sellingp_vs_odometer = ggplot(data=df_cleaned) + 
  geom_point(mapping=aes(x = odometer, y = sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title= element_text(size=14),
        plot.title= element_text(size=18)) +
  labs(x = "Kilometraje [KM]", y = "Precio de venta [USD]", title = "Precio de venta del vehiculo segun su kilometraje")
sellingp_vs_odometer



sellingp_vs_condition = ggplot(data=df_cleaned) + 
  geom_boxplot(mapping=aes(x = factor(condition), y = sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title= element_text(size=14),
        plot.title= element_text(size=18),
        axis.text.x = element_text(size=6)) +
  labs(x = "Condicion", y = "Precio de venta [USD]", title = "Precio de venta del vehiculo segun su condicion")
sellingp_vs_condition



sellingp_vs_sale_day_of_week = ggplot(data = df_cleaned) +
  geom_boxplot(mapping = aes(x = sale_day_of_week, y = sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title= element_text(size=14),
        plot.title= element_text(size=18),
        axis.text.x = element_text(size=10)) +
  labs(x = "Dia de la venta", y = "Precio de venta [USD]", title = "Precio de venta del vehiculo segun el dia de la semana")
sellingp_vs_sale_day_of_week



sellingp_freq = ggplot(df_cleaned, aes(x = sellingprice)) +
  geom_histogram(binwidth = 1000, fill = "#5d9b9b", color = "black", alpha = 0.6) +
  scale_x_continuous(breaks = seq(0, max(df_cleaned$sellingprice, na.rm = TRUE), by = 5000)) +
  labs(x = "Precio de venta [USD]", y = "Frecuencia", title = "Distribucion de los precios de venta") +
  theme(axis.line = element_line(color="black"), 
        axis.title= element_text(size=14),
        plot.title= element_text(size=18),
        axis.text.x = element_text(size=9, angle = 90, hjust = 1))

sellingp_freq


#odo_vs_year = ggplot(data = df_cleaned) +
#  geom_point(mapping = aes(x = year, y = odometer)) + 
#  labs(x = "Años", y = "Kilometraje [km]") + 
#  labs(title = "Kilometraje vs Años")

#odo_vs_year



sellingp_vs_transmission = ggplot(data = df_cleaned) + 
  geom_jitter(mapping = aes(x = transmission, y = sellingprice),
              alpha = 0.2) + 
  geom_boxplot(mapping = aes(x = transmission, y = sellingprice), fill = "grey") +
  labs(x = "Transmision del auto", y = "Precio de Venta [USD]") + 
  labs(title = "Precio de venta en base a la transmision")

sellingp_vs_transmission



sellingp_vs_mmr = ggplot(data = df_cleaned) + 
  geom_point(mapping=aes(x = mmr, y = sellingprice)) + 
  geom_abline(mapping=aes(slope = 1, intercept = 0), colour = "red") +
  labs(x = "Precio estimado de venta [USD]", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta respecto al precio de venta estimado")

sellingp_vs_mmr



sellingp_vs_odometer = ggplot(data=df_cleaned) + 
  geom_point(mapping=aes(x = odometer, y = sellingprice)) +
  labs(x = "Kilometraje [km]", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base al kilometraje")

sellingp_vs_odometer



# podriamos agrupar cada 5 años en otro data frame y hacer un boxplot
sellingp_vs_year = ggplot(data=df_cleaned) + 
  geom_boxplot(mapping=aes(x = factor(year), y = sellingprice)) + 
  labs(x = "Año del vehiculo", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base al año del auto") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

sellingp_vs_year



sellingp_vs_body = ggplot(data=df_cleaned) + 
  geom_boxplot(mapping=aes(x = body, y = sellingprice)) + 
  labs(x = "Tipo de vehiculo", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base al tipo de auto") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

sellingp_vs_body



sellingp_vs_make = ggplot(data=df_cleaned) + 
  geom_boxplot(mapping=aes(x = make, y = sellingprice)) + 
  labs(x = "Marca del vehiculo", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base a la marca del auto") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

sellingp_vs_make



sellingp_vs_state = ggplot(data=df_cleaned) + 
  geom_boxpplot(mapping=aes(x = state, y = sellingprice)) + 
  labs(x = "Ubicacion de consecionaria", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base a la ubicacion de la consecionaria") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

sellingp_vs_state



sellingp_vs_condition = ggplot(data=df_cleaned) + 
  geom_boxplot(mapping=aes(x = factor(condition), y = sellingprice),  alpha=0.4) +
  labs(x = "Condicion del vehiculo", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base a la condicion del auto") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

sellingp_vs_condition



condition_vs_year <- ggplot(data=df_cleaned) + 
  geom_boxplot(mapping=aes(y= condition, x = factor(year)),  alpha=0.4) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

condition_vs_year



mayor_a_50000_menor_a_6_condition <- filter(df_cleaned,condition<6 & sellingprice>50000)
print(count(mayor_a_50000_menor_a_6_condition, make, year),n=400)



menor_a_50000_condition_6_a_18 <- filter(df_cleaned,condition>5 & condition<19 & sellingprice<50000)
print(count(menor_a_50000_condition_6_a_18, make, year),n=400)



ggplot(menor_a_6_condition)+
  geom_boxplot(aes(x=factor(year), y=sellingprice))


ggplot(menor_a_50000_condition_6_a_18)+
  geom_boxplot(aes(x=factor(year), y=sellingprice))


mayor_a__condition <- filter(df_cleaned,condition>6)
print(mayor_a_6_condition)
print(count(mayor_a_6_condition, year),n=52)



### Modelos.

mod1 = lm(df_cleaned, formula = sellingprice  ~ odometer)  # RSE: 7812, MRS: 0.3493
summary(mod1)


mod2 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year))  # RSE: 7526, MRS: 0.396
summary(mod2)


mod3 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + transmission)  # RSE: 7526, MRS: 0.3961
summary(mod3)


mod4 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + condition - 1)  # RSE: 7239, MRS: 0.8147
summary(mod4)


mod5 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + poly(condition, 2, raw=TRUE) - 1)  # RSE: 7226, MRS: 0.8153
summary(mod5)


mod6 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) * poly(condition, 2, raw=TRUE) - 1)  # RSE: 7208, MRS: 0.8163
summary(mod6)


mod7 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) * poly(condition, 2, raw=TRUE) + make - 1)  # RSE: 5880, MRS: 0.8777
summary(mod7)


# Modelo muy pesado
mod8 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) * poly(condition, 2, raw=TRUE) + make + model - 1)
summary(mod8)


# Modelo muy pesado
mod9 = lm(df_cleaned, formula= sellingprice ~ poly(year, 2, raw=TRUE) + condition * odometer + make + model + transmission + state + color + body)
summary(mod9)


mod10 = lm(df_cleaned, formula = sellingprice ~ odometer + factor(year) + condition + sale_day_of_week - 1)  # RSE: 7224, MRS: 0.8154
summary(mod10)

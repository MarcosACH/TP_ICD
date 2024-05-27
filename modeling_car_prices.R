library(tidyverse)


load("df_cleaned.RData")

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
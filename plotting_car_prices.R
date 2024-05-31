library(tidyverse)
library(modelr)


load("df_cleaned.RData")




sellingp_vs_odometer = ggplot(data = df_cleaned) + 
  geom_point(mapping = aes(x=odometer, y=sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  scale_y_continuous(breaks = seq(0, 150000, 50000)) +
  labs(x = "Kilometraje [KM]", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su kilometraje")
sellingp_vs_odometer



sellingp_vs_condition = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x=factor(condition), y=sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  scale_x_discrete(breaks = seq(10, 50, 5)) +
  labs(x = "Condición", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su condición")
sellingp_vs_condition



sellingp_vs_sale_day_of_week = ggplot(data = df_cleaned) +
  geom_boxplot(mapping = aes(x=factor(sale_day_of_week, levels=c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")), y=sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Día de la venta", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según el día de la semana")
sellingp_vs_sale_day_of_week



sale_day_of_week_quantity = ggplot(data = df_cleaned) +
  geom_bar(mapping = aes(x=factor(sale_day_of_week, levels=c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))), fill="#5d9b9b") +
  geom_text(mapping = aes(x=sale_day_of_week, label=..count..), stat="count", vjust=-0.5, size=3.5, color="grey30") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Día de la venta", y = "Cantidad", title = "Cantidad de ventas totales según el día de la semana") +
  coord_cartesian(ylim = c(0, 180000))
sale_day_of_week_quantity



sellingp_freq = ggplot(data = df_cleaned) +
  geom_histogram(mapping = aes(x=sellingprice), binwidth=1000, fill="#5d9b9b", color="grey30", alpha=0.6) +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  scale_x_continuous(breaks = seq(0, 150000, 50000)) +
  labs(x = "Precio de venta [USD]", y = "Frecuencia", title = "Distribución de los precios de venta")
sellingp_freq



sellingp_density = ggplot(data = df_cleaned) +
  geom_density(mapping = aes(x=sellingprice), bw=1000, fill="#5d9b9b", color="grey30", alpha=0.6) +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  scale_x_continuous(breaks = seq(0, 150000, 50000)) +
  labs(x = "Precio de venta [USD]", y = "Frecuencia", title = "Distribución de los precios de venta")
sellingp_density



median_sellingp_by_transmission = df_cleaned %>%
  group_by(transmission) %>%
  summarise(median = median(sellingprice))

sellingp_vs_transmission_box = ggplot(data = df_cleaned, mapping = aes(x=transmission, y=sellingprice)) + 
  geom_jitter(color="#5d9b9b", alpha=0.2) + 
  geom_boxplot(color="#5d9b9b") +
  geom_text(data = median_sellingp_by_transmission, mapping = aes(x=transmission, y=median, label=median), vjust=-0.45, size=3, color="grey30") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Transmisión del auto", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su transmisión")
sellingp_vs_transmission_box



sellingp_vs_transmission_violin = ggplot(data = df_cleaned, mapping = aes(x=transmission, y=sellingprice)) + 
  geom_jitter(color="#5d9b9b", alpha=0.2) + 
  geom_violin(draw_quantiles=c(0.25, 0.5, 0.75), color="#5d9b9b") +
  geom_text(data = median_sellingp_by_transmission, mapping = aes(x=transmission, y=median, label=median), vjust=-0.45, size=3, color="grey30") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Transmisión del auto", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su transmisión")
sellingp_vs_transmission_violin



sellingp_vs_body = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping=aes(x = body, y = sellingprice)) + 
  labs(x = "Tipo de vehiculo", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base al tipo de auto") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

sellingp_vs_body



# podriamos agrupar cada 5 años en otro data frame y hacer un boxplot
sellingp_vs_year = ggplot(data=df_cleaned) + 
  geom_boxplot(mapping=aes(x = factor(year), y = sellingprice)) + 
  labs(x = "Año del vehiculo", y = "Precio de venta [USD]") + 
  labs(title = "Precio de venta en base al año del auto") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

sellingp_vs_year



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



condition_vs_year <- ggplot(data=df_cleaned) + 
  geom_boxplot(mapping=aes(y= condition, x = factor(year)),  alpha=0.4) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

condition_vs_year
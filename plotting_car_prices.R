library(tidyverse)
library(modelr)
library(ggrepel)
library(cowplot)
library(magick)
library(ggimage)
library(tools)


### Importacion de "df_cleaned".

load("df_cleaned.RData")


# -------------------------------------------------------------------------------------------------------------------


### Analisis de graficos.

# Relacion entre el precio de venta del vehículo y su kilometraje.

sellingp_vs_odometer = ggplot(data = df_cleaned) + 
  geom_point(mapping = aes(x=odometer, y=sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  scale_y_continuous(breaks = seq(0, 150000, 50000)) +
  labs(x = "Kilometraje [KM]", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su kilometraje")
sellingp_vs_odometer



# Distribucion y comparacion del precio de venta del vehículo por su unidad de condicion.

sellingp_vs_condition = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x=factor(condition), y=sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  scale_x_discrete(breaks = seq(10, 50, 5)) +
  labs(x = "Condición", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su condición")
sellingp_vs_condition



# Distribucion y comparacion del precio de venta del vehículo por dia de la semana de la venta.

sellingp_vs_sale_day_of_week = ggplot(data = df_cleaned) +
  geom_boxplot(mapping = aes(x=factor(sale_day_of_week, levels=c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")), y=sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Día de la venta", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según el día de la semana")
sellingp_vs_sale_day_of_week



# Comparacion de las cantidades de ventas de vehículos totales por dia de la semana de la venta.

sale_day_of_week_quantity = ggplot(data = df_cleaned) +
  geom_bar(mapping = aes(x=factor(sale_day_of_week, levels=c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))), fill="#5d9b9b") +
  geom_text(mapping = aes(x=sale_day_of_week, label=..count..), stat="count", vjust=-0.5, size=3.5, color="grey30") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Día de la venta", y = "Cantidad", title = "Cantidad de ventas totales según el día de la semana") +
  coord_cartesian(ylim = c(0, 180000))
sale_day_of_week_quantity



# Distribucion del precio de venta del vehículo.

sellingp_freq = ggplot(data = df_cleaned) +
  geom_histogram(mapping = aes(x=sellingprice), binwidth=1000, fill="#5d9b9b", color="grey30", alpha=0.6) +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  scale_x_continuous(breaks = seq(0, 150000, 50000)) +
  labs(x = "Precio de venta [USD]", y = "Frecuencia", title = "Distribución de los precios de venta de los vehículos")
sellingp_freq



# Distribucion (densidad) del precio de venta del vehículo.

sellingp_density = ggplot(data = df_cleaned) +
  geom_density(mapping = aes(x=sellingprice), bw=1000, fill="#5d9b9b", color="grey30", alpha=0.6) +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  scale_x_continuous(breaks = seq(0, 150000, 10000)) +
  labs(x = "Precio de venta [USD]", y = "Frecuencia", title = "Distribución de los precios de venta de los vehículos")
sellingp_density



# Distribucion y comparacion del precio de venta del vehículo por su transmision.

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
  labs(x = "Transmisión del vehículo", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su transmisión")
sellingp_vs_transmission_box



# Distribucion y comparacion del precio de venta del vehículo por su transmision.

sellingp_vs_transmission_violin = ggplot(data = df_cleaned, mapping = aes(x=transmission, y=sellingprice)) + 
  geom_jitter(color="#5d9b9b", alpha=0.2) + 
  geom_violin(draw_quantiles=c(0.25, 0.5, 0.75), color="#5d9b9b") +
  geom_text(data = median_sellingp_by_transmission, mapping = aes(x=transmission, y=median, label=median), vjust=-0.45, size=3, color="grey30") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Transmisión del vehículo", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su transmisión")
sellingp_vs_transmission_violin



# Distribucion y comparacion del precio de venta del vehículo por su tipo.

sellingp_vs_body = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x=body, y=sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.text.x = element_text(size=11, angle=45, hjust=1)) +
  labs(x = "Tipo de vehículo", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su tipo")
sellingp_vs_body



# Distribucion y comparacion del precio de venta del vehículo por su año de fabricacion.

sellingp_vs_year = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x=factor(year), y=sellingprice), color="#5d9b9b") + 
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.text.x = element_text(angle=45, hjust=1)) +
  labs(x = "Año del vehículo", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su año de fabricación")
sellingp_vs_year



# Distribucion y comparacion del precio de venta del vehículo por su fabricante

sellingp_vs_make = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x=make, y=sellingprice), color="#5d9b9b") + 
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.text.x = element_text(size=11, angle=90, hjust=1)) +
  labs(x = "Fabricante del vehículo", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su fabricante")
sellingp_vs_make



# Composicion de los fabricantes de los vehículos.

marcas_frecuentes = sort(table(df_cleaned$make), decreasing = TRUE)
df_nueve_marcas_frecuentes = as.data.frame(head(marcas_frecuentes, 9))
colnames(df_nueve_marcas_frecuentes) = c("Marca", "Ventas")

df_sin_top9 = df_cleaned %>%
  filter(!(df_cleaned$make %in% df_nueve_marcas_frecuentes$Marca))

n_sin_top9 = count(df_sin_top9)

df_otras = data.frame(Marca="Otras", Ventas=n_sin_top9$n)
df_nueve_marcas_frecuentes = rbind(df_nueve_marcas_frecuentes, df_otras)
df_nueve_marcas_frecuentes = df_nueve_marcas_frecuentes %>%
  mutate(porcentaje = (Ventas/sum(Ventas))*100) %>%
  arrange(desc(Marca)) %>%
  mutate(ypos = cumsum(Ventas) - 0.5 * Ventas) %>%
  mutate(Marca = as.character(Marca)) %>%
  mutate(Marca = toTitleCase(Marca))


circular_make = ggplot(df_nueve_marcas_frecuentes, aes(x="", y=Ventas, fill=porcentaje))+
  geom_bar(width=1, stat="identity", color="white")+
  coord_polar("y", start=0)+
  theme_void()+
  geom_label_repel(aes(y=ypos, label=sprintf("%s (%.1f%%)", Marca, porcentaje)),
                   color="black", size=4, show.legend=FALSE,
                   nudge_x=1, nudge_y=0.5, box.padding=0.3, point.padding=0.3,
                   segment.color='grey50', segment.size=0.5)+
  scale_fill_gradient(low="#5d9b9b", high="lightblue")+
  labs(title = "Distribución de las marcas con mayor cantidad de ventas")+
  theme(legend.position = "none", 
        plot.title = element_text(size=20, hjust=0.5),
        panel.background = element_rect(fill="white", color=NA),
        plot.background = element_rect(fill="white", color=NA))
circular_make



# Relacion entre las predicciones del modelo de "sellingprice" y el precio de venta del vehículo.

pred_vs_sellingp = ggplot(data = df_cleaned) +
  geom_point(mapping = aes(x=sellingprice, y=pred), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Precio de venta [USD]", y = "Predicciones del modelo", title = "Predicciones del modelo de 'sellingprice' según el precio de venta del vehículo")
pred_vs_sellingp



# Relacion entre los residuos del modelo de "sellingprice" y el precio de venta del vehículo.

resid_vs_sellingp = ggplot(data = df_cleaned) +
  geom_point(mapping = aes(x=sellingprice, y=resid), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Precio de venta [USD]", y = "Residuos del modelo", title = "Residuos del modelo de 'sellingprice' según el precio de venta del vehículo")
resid_vs_sellingp



# Distribucion y comparacion del precio de venta del vehículo por su color.

sellingp_vs_color = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x=color, y=sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Color", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su color")
sellingp_vs_color



# Distribucion y comparacion del precio de venta del vehículo por la localidad de venta.

sellingp_vs_state = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x=state, y=sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.text.x = element_text(size=11, angle=45, hjust=1)) +
  labs(x = "Color", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según la localidad de venta")
sellingp_vs_state



# Relacion entre la condicion del vehiculo y su kilometraje.

condition_vs_odometer = ggplot(data = df_cleaned) +
  geom_point(mapping = aes(x=odometer, y=condition), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Kilometraje [KM]", y = "Condición", title = "Condición del vehículo según su kilometraje")
condition_vs_odometer


# -------------------------------------------------------------------------------------------------------------------


# Fin del analisis de graficos.

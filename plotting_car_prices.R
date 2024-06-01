library(tidyverse)
library(modelr)
library(ggrepel)
library(cowplot)
library(magick)
library(ggimage)
library(tools)


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
  labs(x = "Precio de venta [USD]", y = "Frecuencia", title = "Distribución de los precios de venta de los vehículos")
sellingp_freq



sellingp_density = ggplot(data = df_cleaned) +
  geom_density(mapping = aes(x=sellingprice), bw=1000, fill="#5d9b9b", color="grey30", alpha=0.6) +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  scale_x_continuous(breaks = seq(0, 150000, 50000)) +
  labs(x = "Precio de venta [USD]", y = "Frecuencia", title = "Distribución de los precios de venta de los vehículos")
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
  labs(x = "Transmisión del vehículo", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su transmisión")
sellingp_vs_transmission_box



sellingp_vs_transmission_violin = ggplot(data = df_cleaned, mapping = aes(x=transmission, y=sellingprice)) + 
  geom_jitter(color="#5d9b9b", alpha=0.2) + 
  geom_violin(draw_quantiles=c(0.25, 0.5, 0.75), color="#5d9b9b") +
  geom_text(data = median_sellingp_by_transmission, mapping = aes(x=transmission, y=median, label=median), vjust=-0.45, size=3, color="grey30") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5)) +
  labs(x = "Transmisión del vehículo", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su transmisión")
sellingp_vs_transmission_violin



sellingp_vs_body = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x=body, y=sellingprice), color="#5d9b9b") +
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.text.x = element_text(size=11, angle=45, hjust=1)) +
  labs(x = "Tipo de vehículo", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su tipo")
sellingp_vs_body



sellingp_vs_year = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x=factor(year), y=sellingprice), color="#5d9b9b") + 
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.text.x = element_text(angle=45, hjust=1)) +
  labs(x = "Año del vehículo", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su año de fabricación")
sellingp_vs_year



sellingp_vs_make = ggplot(data = df_cleaned) + 
  geom_boxplot(mapping = aes(x=make, y=sellingprice), color="#5d9b9b") + 
  theme(axis.line = element_line(color="black"), 
        axis.title = element_text(size=14),
        plot.title = element_text(size=18, hjust=0.5),
        axis.text.x = element_text(size=11, angle=90, hjust=1)) +
  labs(x = "Marca del vehículo", y = "Precio de venta [USD]", title = "Precio de venta del vehículo según su marca")
sellingp_vs_make


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

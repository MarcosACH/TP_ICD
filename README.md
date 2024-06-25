# **<p align="center"> Documentación TP Final </p>**

## _<p align="center"> Introducción a la Ciencia de Datos, ECyT UNSAM </p>_

**Autores:** Marcos Achaval, Federico Menicillo, Lucas Golchtein.

## Introducción
Para comenzar con nuestro proyecto, queremos introducir al tema de estudio con una pregunta cuya respuesta la vamos a ir desarrollando a lo largo de todo el proyecto y
finalmente vamos a responderla basandonos en nuestras conclusiones y análisis. <br> 
Nos preguntamos: **¿A qué precio y en qué concesionaria vendo mi vehículo?**

#### Objetivo
_El objetivo de este proyecto es modelar el precio de venta de un determinado vehículo y encontrar la concesionaria que mayor impacta en el precio del mismo. Vale aclarar
que cuando queremos encontrar esa concesionaria, nos referimos a la que más logra aumentar el precio de venta del vehículo. Más adelante explicaremos nuestro criterio
para llevar a cabo esta decisión, pero por el momento vamos a comenzar analizando el dataset en el que se basa nuestro estudio._

## Dataset
El dataset que estudiamos proviene de [Kaggle](https://www.kaggle.com/datasets/syedanwarafridi/vehicle-sales-data), una página web que contiene datasets
públicos y libres para su utilización. El mismo está compuesto originalmente (sin llevar a cabo ninguna limpieza ni modificaciones) por 558.837 observaciones y 16
columnas. Este dataset nos brinda información sobre transacciones de ventas de vehículos entre el año 2014 y 2015 en Estados Unidos. Sus variables son las siguientes:
- `year`: año de fabricacion del vehículo.
- `make`: fabricante del vehículo.
- `model`: modelo del vehículo.
- `trim`: submodelo del vehículo.
- `body`: tipo de vehículo (_sedan_, _SUV_, _convertible_, etc).
- `transmission`: transmisión del vehículo (_automatico_ o _manual_).
- `vin`: código único de identificación de la venta.
- `state`: localidad en donde se llevó a cabo la venta.
- `condition`: condición del vehículo en una escala del 10 al 50 (10 siendo una condición muy mala y 50 una muy buena).
- `odometer`: kilometraje del vehículo.
- `color`: color del exterior del vehículo.
- `interior`: color del interior del vehículo.
- `seller`: concesionaria que llevó a cabo la venta.
- `mmr`: precio estimado del vehículo.
- `sellingprice`: precio de venta del vehículo.
- `saledate`: fecha de la venta. <br>

Debido a que el mismo contiene irregularidades en los datos (outliers, datos mal ingresados, datos faltantes, etc) y
errores estructurales (tipos de datos no convenientes para el posterior análisis) decidimos hacer una limpieza de datos del dataset.

## Limpieza de datos
En esta etapa llevamos a cabo varios ajustes en el dataset original y nos quedamos con lo más relevante y con una estructura de datos conveniente para desarrollar nuestro análisis.

#### Errores estructurales
Comenzamos chequeando por errores estructurales, identificamos algunas columnas de tipo de dato `dbl` que contenian números enteros. A pesar de ser un error
estructural leve, decidimos cambiar su tipo de dato a `int`. No había más errores de este tipo, así que seguimos con el chequeo de irregularidades en los datos.

#### Irregularidades
Acá vimos que la columna `condition` no tenía valores en los múltiplos de 10. En otras palabras, del 1 al 5 había valores, del 6 al 10 no había valores y del 11 al 50 había valores
excepto en 20, 30, 40 y 50. Esto nos dio el indicio que esta variable se trataba de una escala del 1.0 al 5.0 o del 10 al 50. Es por esto que decidimos multiplicar por 10 a todos
los valores menores o iguales que 5 para ubicarlos en los espacios libres que había en todos los múltiplos de 10 y obtener una escala del 10 al 50. <br>
Luego convertimos todas las columnas de tipo de dato `chr`, excepto `vin` y `saledate` que contenían datos únicos, a minúscula ya que tenían irregularidades en
su formato. Además unificamos el formato de estas columnas porque había valores diferentes que referian al mismo significado, entonces pasamos todos esos valores a minúscula. <br>
El dataset también tenía muchos datos faltantes. Decidimos eliminar a todas aquellas observaciones que su valor de `make`, `model`, `odometer`, `sellingprice`,
`saledate`, `body` o `color` era `NA` ya que no queríamos tener vehículos sin esos datos tan relevantes para el modelado de su precio de venta. Vale aclarar que todas
estas variables tenían muy pocos datos `NA`, por eso decidimos tomar esta decisión. Posteriormente nos fijamos si había datos “_outliers_” o mal ingresados. Para esto
generamos algunos gráficos que nos ayudaron a identificar posibles casos. El kilometraje más alto de los vehículos de este dataset es de 999.999 kilómetros. Había
vehículos de años bastante actuales y con esta cantidad de kilómetros, algo raro. Por eso eliminamos todos aquellos que eran mayores al año 2005 y que tengan 999.999
kilómetros. Además eliminamos todos los vehículos que tengan menos de 100 kilómetros para enfocarnos únicamente en autos usados. <br>
Como dato mal ingresado encontramos solo a uno en donde `sellingprice` era de 230.000 dólares y el precio de venta estimado del vehículo (`mmr`) era de 22.800
dólares. Claramente este dato estaba mal ingresado ya que además las características del vehículo no justificaban a ese precio, o por lo menos eso es lo que supusimos.
Entonces dividimos el valor por 10 para quitarle un 0. Luego eliminamos todos los vehículos que su precio de venta haya sido menor a 300 dólares. No nos pareció lógico
quedarnos con autos extremadamente baratos o directamente con precios mal ingresados. <br>
La columna `transmission` tenía varios valores `NA` y no correspondía eliminarlos (era una cantidad significativa). Es por esto que decidimos agrupar a los datos por marca y
modelo, y en base a la proporción de vehículos automáticos y manuales que tenía cada agrupación, calculamos la cantidad de `NA's` que debían ser reemplazados por
"_automatic_" o por "_manual_". Por ejemplo, si una agrupación tenía un 70% de los vehículos automáticos, entonces el 70% de los datos faltantes se reemplazó por
“_automatic_” y el 30% restante por “_manual_”. <br>
Los datos faltantes de `condition` los reemplazamos por el promedio de cada año de fabricación de los vehículos. <br>
Además, la columna `saledate` contenía al día, mes, año y zona horaria de la fecha de la venta, una estructura no conveniente para un posterior estudio. Entonces decidimos
separar esos datos en columnas diferentes, obteniendo una columna que contenga el dia de la semana (“_Mon_”, “_Tue_”, “_Wed_”, etc), otra el día del mes, otra el número de
mes, otra el año y la original (`saledate`) la fecha completa en formato "_yyyy-mm-dd_" y con tipo de dato `dttm`. <br>
Finalmente, por una cuestión de poder computacional y poder modelar adecuadamente, decidimos quedarnos únicamente con las concesionarias, modelos y
submodelos de vehículos que tengan al menos 200 ventas. Si no hubiéramos hecho este paso, nuestro modelo tendría que tener muchísimos coeficientes para cada una de
estas variables, y consecuentemente no podríamos generar ninguno. <br>
Una vez finalizada la limpieza, el dataset quedó compuesto por 322.391 observaciones y 20 columnas.

## Exploración del Dataset
En esta etapa, ya con el dataset preparado para un estudio adecuado, generamos algunos gráficos y los analizamos para identificar posibles patrones. <br>
Para comenzar, en el siguiente gráfico de dispersión podemos ver la relación entre el precio de venta de un vehículo y su kilometraje. Se nota claramente que a medida que
el kilometraje aumenta, el precio de venta disminuye. Es decir que hay una relación inversa entre estas dos variables. Esto era de esperar y podemos afirmar que el
kilometraje impacta fuertemente en el precio de venta del vehículo. <br> <br> <p align="center"> ![sellingp_vs_odometer](https://github.com/MarcosACH/tp-icd/blob/main/sellingp_vs_odometer.png) </p>

A continuación podemos ver un gráfico de cajas (boxplot) que representa la distribución del precio de venta de un vehículo por cada unidad de condición del
mismo. Este también nos permite comparar dichas distribuciones y deja en claro que a medida que aumenta la condición de un vehículo (mejora su estado) también lo hace
su precio de venta. Entonces podemos afirmar que existe una relación directa entre ambas variables. También se ve claramente como la mediana de cada unidad de
condición va aumentando y hay una gran variabilidad en los precios dentro de cada nivel. 
Otro claro factor que afecta al precio de venta de un vehículo. <br> <br> <p align="center"> ![sellingp_vs_condition](https://github.com/MarcosACH/tp-icd/blob/main/sellingp_vs_condition.png) </p>

Por otro lado, a continuación vemos otro gráfico de cajas que muestra la distribución de los precios de venta de los vehículos por cada año de fabricación de los mismos. 
De vuelta, podemos ver de manera clara como el precio de venta aumenta a medida que el año también lo hace. Podemos afirmar que el año de fabricación de un vehículo juega
un rol importante en el precio del mismo. <br> <br> <p align="center"> ![sellingp_vs_year](https://github.com/MarcosACH/tp-icd/blob/main/sellingp_vs_year.png) </p>

Por último, debajo vemos un gráfico de densidad que representa la distribución de los precios de venta de los diferentes vehículos. La mayor densidad de precios está entre
los 10.000 y 15.000 dólares. También se nota una densidad muy baja para los precios mayores a 50.000 dólares. Algo que también podemos destacar es que no hay
múltiples picos de densidad, solo hay uno que está sobre el rango previamente mencionado. <br> <br> <p align="center"> ![sellingp_density](https://github.com/MarcosACH/tp-icd/blob/main/sellingp_density.png) </p>

## Modelado
Para el modelado de nuestra variable target, `sellingprice`, decidimos primero realizar cuatro modelos diferentes de **regresión lineal múltiple** y compararlos con una tabla **ANOVA**. <br>
Todos los modelos que construimos están compuestos por una interacción entre dos variables, `odometer` y `condition`, ya que creemos que el kilometraje y la condición
de un vehículo están fuertemente relacionados. Más allá de que no sabemos si el efecto de `odometer` sobre la variable dependiente varía en función del nivel de
`condition`, vale aclarar que además decidimos sumar esta interacción ya que el modelo logró obtener un ajuste mejor al que obtuvo uno sin esta interacción. Por
último, todos los modelos están formados por dos variables continuas (las de interacción) y el resto son categóricas. <br>
El primer modelo tiene en total 8 variables y su fórmula matemática es: $$W1 ⋅ odometer + W2 ⋅ condition + W3 ⋅ (odometer ⋅ condition) + year + make + body + seller + model + trim$$ 
Su error estándar residual ($RSE$) es de 2.495, lo que representa la desviación estándar de los residuos. Esto significa que, en promedio, el modelo se desvía del
precio real del vehículo en 2.495 dólares. Su R-cuadrado múltiple ($R²$) es de 0.9774, lo que significa que el modelo logra explicar aproximadamente el 97% de la variabilidad
de la variable dependiente (precio del vehículo) con las variables independientes incluidas en este modelo. <br>
Al segundo modelo le añadimos una variable categórica, `color`, teniendo un total de 9 variables y la siguiente fórmula matemática: $$W1 ⋅ odometer + W2 ⋅ condition + W3 ⋅
(odometer ⋅ condition) + year + make + body + seller + model + trim + color$$ Su error estándar residual es de 2.494 y su R-cuadrado múltiple es de 0,9774.
Al tercer modelo le agregamos otra variable categórica, `state`, que como ya mencionamos anteriormente representa el estado (localidad) en donde se efectuó la
venta del vehículo. Este modelo suma un total de 10 variables y su fórmula matemática es: $$W1 ⋅ odometer + W2 ⋅ condition + W3 ⋅ (odometer ⋅ condition) + year + make + body +
seller + model + trim + color + state$$ Su error estándar residual dio 2.488 y su R-cuadrado múltiple es de 0,9775. <br>
Finalmente, al cuarto y último modelo, le añadimos otra variable categórica, `transmission`, quedando así la fórmula matemática: $$W1 ⋅ odometer + W2 ⋅ condition +
W3 ⋅ (odometer ⋅ condition) + year + make + body + seller + model + trim + color + state + transmission$$ Su error estándar residual y su R-cuadrado múltiple son iguales a los del tercer modelo. <br>
Luego de generar estos cuatro modelos y analizar los resultados de cada uno, los comparamos con una tabla de análisis de varianza (**ANOVA**). Como podrán ver, los
cuatro modelos van aumentando en complejidad. Para los primeros tres modelos, el p-valor resultó ser muy bajo, $<2 ⋅ 10^{16}$ , y se indicaron con tres asteriscos de
significancia (**\*\*\***). En otras palabras, esto indica que la probabilidad de que la mejora en el ajuste del modelo al agregar nuevas variables haya ocurrido por casualidad es
extremadamente baja. También podemos decir que los modelos más complejos proporcionan un ajuste significativamente mejor que el modelo más simple (modelo 1). 
Sin embargo, el cuarto y último modelo obtuvo un p-valor bastante elevado, 0,4331, y lógicamente ningún asterisco de significancia. En este caso, la
probabilidad de que la mejora en el ajuste del modelo al agregar nuevas variables haya ocurrido por casualidad es muy elevada, casi de 0.5. Esto claramente no es bueno, sin
embargo vale la pena aclarar que aproximadamente un 97% de la variable `transmission` (variable agregada) está compuesta por valores de vehículos
automáticos, entonces no presenta gran variabilidad. Quizás esta es la razón por la cual el cuarto modelo obtuvo un p-valor muy elevado. <br>
Después de analizar la tabla de análisis de varianza realizamos un gráfico de residuos versus las predicciones de la variable dependiente del tercer modelo, el cual hasta
ahora creemos que es el mejor para estudiar a la variable target. A continuación podemos ver el gráfico. <br> <br> <p align="center"> ![residuals_vs_fitted](https://github.com/MarcosACH/tp-icd/blob/main/residuals_vs_fitted.png) </p>

Lo primero y lo que más nos llamó la atención cuando analizamos este gráfico fue que hay predicciones negativas. Nos preguntamos, ¿cómo es posible que haya precios de
vehículos negativos? Lamentablemente no supimos responder esta pregunta y nos hizo replantearnos varios aspectos del proyecto y desviarnos bastante. De hecho
probamos hacer un modelo como los que ya hicimos pero aplicando logaritmo a la variable target. Con eso obtuvimos un modelo mucho mejor pero realmente no
podíamos justificar la mejora y decidimos quedarnos con modelos sin logaritmo como los que veníamos haciendo. <br>
Por otro lado vemos que hay un claro patrón del lado izquierdo del gráfico en donde se puede ver un límite marcado que los residuos no pueden pasar. Esto no es bueno ya
que es probable que el modelo no esté capturando adecuadamente la relación entre las variables independientes y la variable dependiente. <br>
Por último podemos afirmar que la línea roja, que es una suavización de los residuos, no está alineada con la línea horizontal en 0 (el modelo). Esto nos explica que los
residuos no están distribuidos simétricamente con las predicciones del modelo. Por lo tanto podemos observar que para predicciones bajas y también elevadas, el modelo
está mayormente subestimando el precio del vehículo mientras que en el centro (de 15.000 a 25.000 dólares aproximadamente), el modelo se comporta muy bien y logra
predecir adecuadamente el precio del vehículo. <br>
Teniendo todos estos resultados en cuenta, decidimos basar nuestra conclusión y respuesta a la pregunta de estudio en el tercer modelo, ya que fue el último y más
complejo en obtener un p-valor muy pequeño en la tabla **ANOVA** y los mejores valores de $RSE$ y $R²$. Pero antes de pasar a la conclusión queda aclarar los coeficientes de las
variables continuas de este modelo. <br>
Por cada kilómetro que recorre el vehículo, su precio de venta disminuye aproximadamente 0,0051 dólares. Y por cada unidad de condición que aumenta, su
precio aumenta aproximadamente 170 dólares. <br>
Y ahora, _¿en que concesionaria vendo mi vehículo?_ Hay que tener en cuenta que la respuesta de esta pregunta depende del fabricante de tu vehículo, ya que no todas las
concesionarias venden cualquier marca. Entonces para responder la pregunta, buscamos a la concesionaria que obtuvo el mayor coeficiente en nuestro modelo y que además vende
vehículos del fabricante del vehículo de estudio. Para esto buscamos a todas las concesionarias que hayan vendido autos de aquel fabricante, buscamos todos los
coeficientes de esas concesionarias y nos quedamos con el mayor. De esta manera podemos publicar nuestro vehículo en la concesionaria que más aumenta su precio de venta.

## Conclusión
Luego de finalizar con el análisis podemos afirmar que hay muchos factores que afectan al precio de un vehículo, como todos los que incluye nuestro modelo.
Para concluir este trabajo práctico decidimos mostrar un ejemplo práctico en donde aplicamos el modelo que creamos y respondemos a una pregunta específica.

#### Ejemplo práctico
Supongamos que queremos vender al mejor precio posible en el estado de New Jersey (NJ) un vehículo SUV, fabricado por BMW, modelo X1, submodelo XDrive 28i, año
2014, con 8.400 kilómetros, condición de 49 puntos y color gris. _¿A qué precio y en qué concesionaria vendo este vehículo?_ <br>
La mejor concesionaria para vender este vehículo se llama **"Bmw na Manheim New Jersey"** y tiene un coeficiente de 12.185, es decir que en esta concesionaria el precio del
vehículo aumenta 12.185 dólares. <br>
Para terminar de definir el precio de venta debemos utilizar nuestro modelo y hacer el siguiente cálculo:
$$W1 ⋅ odometer + W2 ⋅ condition + W3 ⋅ (odometer ⋅ condition) + year + make + body + seller + model + trim + color + state = sellingprice$$
$$-0,005062 · 8.400 + 170,8 · 49 - 0,0014 · (8.400 · 49) + 30.693 - 5.516 - 7810 + 12.185 - 1429 + 1098 + 17 - 2015 ≃ 34.973$$
Entonces si queremos vender un vehículo con estas características, según nuestro modelo lo podemos publicar a 34.974 dólares en la concesionaria **"Bmw na Manheim New Jersey"**.

## Codigo fuente
Este repositorio además contiene todo el código fuente elaborado para llevar a cabo este proyecto final. Para visualizar el código de la [limpieza de datos](#limpieza-de-datos), entrar [aquí](https://github.com/MarcosACH/tp-icd/blob/main/data_cleaning_car_prices.R).
Para visualizar el código de la [exploración del dataset](#exploración-del-dataset), entrar [aquí](https://github.com/MarcosACH/tp-icd/blob/main/plotting_car_prices.R). 
Por último, para visualizar el código del [modelado](#modelado), entrar [aquí](https://github.com/MarcosACH/tp-icd/blob/main/modeling_car_prices.R).
> [!IMPORTANT]
> Para un correcto uso del código fuente, por favor respetar el orden de ejecución (desde la parte superior del archivo hasta la parte inferior),
> de lo contrario obtendrán resultados erróneos.


# Unidad 2, asignación 1: Análisis exploratorio de datos

Dentro de las opciones de `knitr`, en el encabezado de este archivo, es
probable que encuentres el argumento `eval = F`. Antes de tejer debes
cambiarlo a `eval = T`, para que evalúe los bloques de código según tus
cambios.

El objetivo de esta asignación es que te familiarices con técnicas
visuales y estadísticas de análisis exploratorio de datos espaciales,
usando como referencia la capa de provincias dominicanas y los
resultados de la Encuesta Nacional de Hogares de Propósitos Múltiples de
2017 (ENHOGAR-2017, descripción
[aquí](https://www.one.gob.do/encuestas/enhogar), datos fuente
[aquí](http://redatam.one.gob.do/cgibin/RpWebEngine.exe/PortalAction?&MODE=MAIN&BASE=ENH2017&MAIN=WebServerMain.inl))

## Provincia asignada

Toma nota del código de tu provincia asignada aleatoriamente. Los
códigos fueron tomados desde el campo `ENLACE` de la capa
`PROVCenso2010` del archivo `data/divisionRD.gpkg`

``` r
 # abreviatura         ENLACE
 #       acade           0405
 #       agrie           0319
 #       aleir           0320
 #       arqco           0517
 #       cindy           0415
 #       franc           0707
 #       geora           0314
 #       hoyod           0616
 #       ingan           0306
 #       ingdi           0603
 #       itac9           0502
 #       ivanv           0808
 #       lbine           0930
 #       leona           0722
 #       magda           0604
 #       maryj           0118
 #       masue           0811
 #       mmvol           0426
 #       naui2           0929
 #       rober           0812
 #       wilne           0228
 #       yoenn           0610
```

## Pregunta asignada

Toma nota de tu pregunta asignada aleatoriamente. Cada pregunta tiene
varias posibles respuestas, todas excluyentes entre sí. Por ejemplo, la
pregunta: `A qué cree que se debe la delincuencia en el país: ¿A la
falta de lugares para practicar deportes?` tiene las posibles respuestas
`Si` (número de hogares que respondieron `Sí`) y `No` (número de hogares
que respondieron `No`). Nótese que otras preguntas tienen diferentes
posibles respuestas; por ejemplo, `Sexo del jefe(a) del hogar` tiene
como posibles respuestas `Hombre`, `Mujer`, `Sin información`.
Finalmente, nótese que cada hogar sólo podía responder una de las
alternativas.

``` r
#  [1] "acade, Grupo Socio-Económico"                                                                                                                                                            
#  [2] "agrie, Principales problemas de su barrio o comunidad: ¿La educación?"                                                                                                                   
#  [3] "aleir, Principales problemas de su barrio o comunidad: ¿La salud?"                                                                                                                       
#  [4] "arqco, Principales problemas de su barrio o comunidad: ¿La acumulación de basura?"                                                                                                       
#  [5] "cindy, Principales problemas de su barrio o comunidad: ¿La corrupción?"                                                                                                                  
#  [6] "franc, A qué cree que se debe la delincuencia en el país: ¿A la falta de lugares para practicar deportes?"                                                                               
#  [7] "geora, A qué cree que se debe la delincuencia en el país: ¿Otra causa?"                                                                                                                  
#  [8] "hoyod, Principales problemas de su barrio o comunidad: ¿Otro problema?"                                                                                                                  
#  [9] "ingan, A qué cree usted que se debe la delincuencia en su barrio o comunidad: ¿Otra causa?"                                                                                              
# [10] "ingdi, Principales problemas de su barrio o comunidad: ¿El costo de la vida?"                                                                                                            
# [11] "itac9, Sexo del jefe(a) del hogar"                                                                                                                                                       
# [12] "ivanv, Principales problemas de su barrio o comunidad: ¿La delincuencia?"                                                                                                                
# [13] "lbine, Desde noviembre del año pasado hasta la fecha, ¿Alguna de las personas de este hogar tuvo un accidente de tránsito mientra conducía un vehículo, motor o bicicleta?"              
# [14] "leona, Principales problemas de su barrio o comunidad: ¿Calles, aceras y contenes en mal estado?"                                                                                        
# [15] "magda, Desde noviembre del año pasado a la fecha ¿Alguna de las personas de este hogar fue atropellada por un vehículo, motor o bicicleta mientras caminaba o estaba parada en un lugar?"
# [16] "maryj, Principales problemas de su barrio o comunidad: ¿No hay problemas en el barrio o comunidad?"                                                                                      
# [17] "masue, A qué cree usted que se debe la delincuencia en su barrio o comunidad: ¿Educación familiar/falta de valores?"                                                                     
# [18] "mmvol, Principales problemas de su barrio o comunidad: ¿La venta de drogas?"                                                                                                             
# [19] "naui2, A qué cree usted que se debe la delincuencia en su barrio o comunidad: ¿A la falta de oportunidades para estudiar?"                                                               
# [20] "rober, A qué cree usted que se debe la delincuencia en el país: ¿A la venta de drogas?"                                                                                                  
# [21] "wilne, A qué cree que se debe la delincuencia en el país: ¿A la falta de oportunidades para estudiar?"                                                                                   
# [22] "yoenn, A qué cree que se debe la delincuencia en el país: ¿Al consumo de drogas?"
```

## Paquetes

  - Carga el paquete `sf` y la colección `tidyverse`.

<!-- end list -->

``` r
library(...)
library(...)
```

## Datos y unión

El objetivo de esta sección es que puedas unir dos fuentes: el objeto
espacial con los límites de las provincias, y el objeto de atributos de
“ENHOGAR 2017”.

  - Carga el conjunto de datos de “ENHOGAR 2017”, asignándolo al objeto
    `en17`. Este conjunto de datos está guardado como archivo `.csv` en
    la carpeta `data` (único de su tipo en la carpeta).

<!-- end list -->

``` r
... <- read.csv('...', check.names = F)
```

> El argumento `check.names = F` hace que la función `read.csv` respete
> los espacios y caracteres especiales en los nombres de columnas.

  - Carga la capa de provincias con la función `st_read`, asignándola al
    objeto `prov`.

<!-- end list -->

``` r
... <- st_read(dsn = '...', layer = '...')
```

  - Imprime los nombres de columnas de `en17` (recuerda, el nombre de un
    objeto en R no se rodea de comillas; las comillas sólo se usan para
    cadenas de caracteres)

<!-- end list -->

``` r
colnames(...)
```

  - Imprime los nombres de columnas de `prov`

<!-- end list -->

``` r
colnames(...)
```

  - Las columnas a través de las cuales se pueden unir ambos conjuntos
    son `en17$Código` y `prov$ENLACE`. Sin embargo, al igual que ocurría
    con los datos del censo en el material de apoyo, la columna
    `en17$Código` no conserva los ceros a la izquierda. En este caso,
    dicha omisión ocurre en los códigos con 3 caracteres (los que tienen
    4 caracteres están correctos). Visualiza ambas columnas para que
    notes la discrepancia.

<!-- end list -->

``` r
en17$...
prov$...
```

  - Si intentaras hacer una unión, no daría resultados apropiados. Para
    comprobarlo que dicha unión fallaría, utiliza la función `match`.

<!-- end list -->

``` r
match(en17$... , prov$...)
```

  - Para resolver esta discrepancia, crea una columna en el objeto
    `en17`, mediante la cual unirás este objeto con `prov`. Es
    preferible que las columnas con las que se realizará la unión tengan
    el mismo nombre. El objeto `prov` ya tiene una columna `ENLACE` con
    códigos correctos, razón por la cual crearás una columna denominada
    `ENLACE` en `en17`, corrigiendo al mismo tiempo los ceros a la
    izquierda faltantes. Una forma de las formas más cómodas de
    resolverlo es con la función `mutate`, creando una columna nueva a
    partir de la columna `Código`. Para que la nueva columna contenga
    los ceros a la izquierda faltantes, utiliza la función de condición
    `ifelse`. Utiliza el material de apoyo como
referencia.

<!-- end list -->

``` r
... <- ... %>% mutate(... = ifelse(nchar(...)==3, paste0('0', ...), ...))
```

  - Imprime en pantalla la columna `ENLACE` creada en `en17`, e intenta
    ahora el `match` entre ambas columnas `ENLACE` de los dos objetos,
    `en17` y `prov`. Si tras ejecutar el `match` no aparecen `NA`,
    entonces la unión puede realizarse sin problemas.

<!-- end list -->

``` r
en17$...
match(en17$... , prov$...)
```

  - Ahora haz la unión entre los conjuntos de datos `en17` y `prov`
    mediante la función `inner_join` usando el campo `ENLACE`, el cual
    existe en ambos objetos de manera consistente, siempre que hayas
    ejecutado bien los códigos anteriores. Asigna el resultado al objeto
    `proven17`, e imprímelo en pantalla.

<!-- end list -->

``` r
... <- ... %>% inner_join(..., by = '...')
...
```

  - Genera un mapa con los resultados de tu pregunta para todo el país,
    usando la función `plot`.

> Un ejemplo ilustra cómo hacerlo. Supongamos el caso del estudiante
> ficticio `hoyod`. Para extraer su pregunta, el `hoyod` utiliza el
> operador `%>%`, la función `dplyr::select` y la función `contains`.
> Nota que este bloque de código de ejemplo, y los siguientes del alumno
> ficticio, están marcados como `eval=F`, para así evitar que generen
> resultados.

``` r
proven17 %>%
  dplyr::select(contains('Principales problemas de su barrio o comunidad: ¿Otro problema?')) %>%
  plot(breaks = 'jenks')
```

**Tu turno**

``` r
... %>%
  dplyr::select(contains('...')) %>%
  plot(breaks = 'jenks')
```

  - Genera un mapa con los resultados de tu pregunta para todo el país,
    usando la función `geom_sf` del paquete `ggplot2`, colocando como
    rótulos los valores de cada provincia. Genera otro mapa colocando
    los nombres de las provincias.

> El ejemplo del estudiante `hoyod` ilustra cómo hacerlo. Observa tres
> detalles:

>   - La paleta utilizada es `brewer.pal` del paquete `RColorBrewer`,
>     define gradientes apropiados para la representación. Si escribe en
>     la consola `RColorBrewer::display.brewer.all()`, se desplegarán
>     todas las posibles paletas del paquete.
>   - Puedes definir el tamaño de la letra de los mapas. En el ejemplo,
>     verás que se configuran dos tipos de letra mediante `size`: 1) La
>     letra de los títulos de cada gráfico y la leyenda, en `theme(text
>     = element_text(size = X))`; 2) Los rótulos de mapa en
>     `geom_sf_text(..., size = X)`.
>   - La tabla de visulización de colores para el relleno usa escala
>     logarítmica, y la define el argumento `trans = 'log10'`. Puedes
>     “jugar” quitando dicho argumento, y notarás que los patrones se
>     esconden, o que las provincias que destacan son sólo aquellas con
>     valores extremos.

``` r
#Rótulos: valor de la variable
proven17 %>%
  dplyr::select(contains('Principales problemas de su barrio o comunidad: ¿Otro problema?')) %>%
  gather(variable, valor, -geom) %>% 
  ggplot() + aes(fill = valor) + geom_sf(lwd = 0.2) +
  facet_wrap(~variable) + theme(text = element_text(size = 10)) +
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(9, name = 'Reds'), trans = 'log10') +
  geom_sf_text(aes(label=valor), check_overlap = T, size = 3)

#Rótulos: nombres de las provincias
proven17 %>%
  dplyr::select(contains('Principales problemas de su barrio o comunidad: ¿Otro problema?'), TOPONIMIA) %>%
  gather(variable, valor, -geom, -TOPONIMIA) %>% 
  ggplot() + aes(fill = valor) + geom_sf(lwd = 0.2) +
  facet_wrap(~variable) + theme(text = element_text(size = 10)) +
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(9, name = 'Reds'), trans = 'log10') +
  geom_sf_text(aes(label=TOPONIMIA), check_overlap = T, size = 3)
```

**Tu turno**

``` r
#Rótulos: valor de la variable
... %>%
  dplyr::select(contains('...')) %>%
  gather(variable, valor, -geom) %>% 
  ggplot() + aes(fill = valor) + geom_sf(lwd = 0.2) +
  facet_wrap(~variable) + theme(text = element_text(size = 10)) +
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(9, name = 'Reds'), trans = 'log10') +
  geom_sf_text(aes(label=valor), check_overlap = T, size = 3)

#Rótulos: nombres de las provincias
... %>%
  dplyr::select(contains('...'), TOPONIMIA) %>%
  gather(variable, valor, -geom, -TOPONIMIA) %>% 
  ggplot() + aes(fill = valor) + geom_sf(lwd = 0.2) +
  facet_wrap(~variable) + theme(text = element_text(size = 10)) +
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(9, name = 'Reds'), trans = 'log10') +
  geom_sf_text(aes(label=TOPONIMIA), check_overlap = T, size = 3)
```

  - Imprime una tabla, sin columna geométrica, mostrando las respuestas
    a tu pregunta para todo el país, incluyendo la columna `TOPONIMIA`.

> Un ejemplo ilustra el caso del estudiante `hoyod`:

``` r
proven17 %>% st_drop_geometry() %>%
  dplyr::select(TOPONIMIA, contains('Principales problemas de su barrio o comunidad: ¿Otro problema?'))
```

**Tu turno**

``` r
... %>% st_drop_geometry() %>%
  dplyr::select(TOPONIMIA, contains('...'))
```

  - Imprime una tabla, sin columna geométrica, mostrando los porcentajes
    de cada respuesta a tu pregunta para todo el país, incluyendo la
    columna `TOPONIMIA` y relativizando las respuestas para cada
    provincia.

> Un ejemplo ilustra el caso del estudiante `hoyod`. Tres operaciones
> son clave en este proceso: 1) `gather` que reúne sólo las columnas
> numéricas, sin la de nombres de provincias (por eso verás
> `-TOPONIMIA`). 2) Las funciones `mutate` y `spread`, la primera genera
> el porcentaje por provincias, y la segunda distribuye los datos por
> columnas. 3) La función `kable`, del paquete `kableExtra`, genera una
> tabla en formato HTML, más organizada y legible que el resultado que
> devuelve la consola.

``` r
proven17 %>% st_drop_geometry() %>%
  dplyr::select(TOPONIMIA, contains('Principales problemas de su barrio o comunidad: ¿Otro problema?')) %>% 
  gather(variable, valor, -TOPONIMIA) %>% group_by(TOPONIMIA) %>%
  mutate(pct=round(valor/sum(valor)*100,2)) %>% dplyr::select(-valor) %>%
  spread(variable, pct) %>% kableExtra::kable()
```

**Tu turno**

``` r
... %>% st_drop_geometry() %>%
  dplyr::select(TOPONIMIA, contains('...')) %>% 
  gather(variable, valor, -TOPONIMIA) %>% group_by(TOPONIMIA) %>%
  mutate(pct=round(valor/sum(valor)*100,2)) %>% dplyr::select(-valor) %>%
  spread(variable, pct) %>% kableExtra::kable()
```

  - Genera un mapa con los porcentajes de respuestas de tu pregunta para
    todo el país, usando la función `geom_sf` del paquete `ggplot2`;
    coloca como rótulos los porcentajes para cada provincia.

> Ejemplo del estudiante `hoyod`:

``` r
proven17 %>%
  dplyr::select(contains('Principales problemas de su barrio o comunidad: ¿Otro problema?'), TOPONIMIA) %>%
  gather(variable, valor, -geom, -TOPONIMIA) %>% 
  group_by(TOPONIMIA) %>% 
  mutate(pct=round(valor/sum(valor)*100,2)) %>% dplyr::select(-valor) %>% 
  ggplot() + aes(fill = pct) + geom_sf(lwd = 0.2) +
  facet_wrap(~variable) + theme(text = element_text(size = 10)) +
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(9, name = 'Reds')) +
  geom_sf_text(aes(label=pct), check_overlap = T, size = 3)
```

**Tu turno**

``` r
... %>%
  dplyr::select(contains('...'), TOPONIMIA) %>%
  gather(variable, valor, -geom, -TOPONIMIA) %>% 
  group_by(TOPONIMIA) %>% 
  mutate(pct=round(valor/sum(valor)*100,2)) %>% dplyr::select(-valor) %>% 
  ggplot() + aes(fill = pct) + geom_sf(lwd = 0.2) +
  facet_wrap(~variable) + theme(text = element_text(size = 10)) +
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(9, name = 'Reds')) +
  geom_sf_text(aes(label=pct), check_overlap = T, size = 3)
```

  - Repite el mandato anterior, pero usando sólo una de las posibles
    respuestas de tu pregunta. Elige una, la que prefieras.

> Un ejemplo ilustra mejor. En el caso del estudiante ficticio, las
> respuestas de la encuesta eran ‘Sí’ y ‘No’, por lo tanto, el
> estudiante ficticio disponde de las columnas `Principales problemas de
> su barrio o comunidad: ¿Otro problema?: Si` y `Principales problemas
> de su barrio o comunidad: ¿Otro problema?: No`. Elijamos la segunda
> opción (el truco está en la función `filter`):

``` r
proven17 %>%
  dplyr::select(contains('Principales problemas de su barrio o comunidad: ¿Otro problema?'), TOPONIMIA) %>%
  gather(variable, valor, -geom, -TOPONIMIA) %>% 
  group_by(TOPONIMIA) %>% 
  mutate(pct=round(valor/sum(valor)*100,2)) %>% dplyr::select(-valor) %>% 
  filter(variable %in% 'Principales problemas de su barrio o comunidad: ¿Otro problema?: No') %>% 
  ggplot() + aes(fill = pct) + geom_sf(lwd = 0.2) +
  facet_wrap(~variable) + theme(text = element_text(size = 10)) +
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(9, name = 'Reds')) +
  geom_sf_text(aes(label=pct), check_overlap = T, size = 3)
```

**Tu turno**

``` r
... %>%
  dplyr::select(contains('...'), TOPONIMIA) %>%
  gather(variable, valor, -geom, -TOPONIMIA) %>% 
  group_by(TOPONIMIA) %>% 
  mutate(pct=round(valor/sum(valor)*100,2)) %>% dplyr::select(-valor) %>% 
  filter(variable %in% '...') %>% 
  ggplot() + aes(fill = pct) + geom_sf(lwd = 0.2) +
  facet_wrap(~variable) + theme(text = element_text(size = 10)) +
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(9, name = 'Reds')) +
  geom_sf_text(aes(label=pct), check_overlap = T, size = 3)
```

  - Imprime un resumen estadístico (mínimo, primer cuartil, mediana,
    media, tercer cuartil, máximo) de las respuestas a tu pregunta para
    todo el país.

> Un ejemplo ilustra el caso del estudiante `hoyod`:

``` r
proven17 %>% st_drop_geometry() %>%
  dplyr::select(contains('Principales problemas de su barrio o comunidad: ¿Otro problema?')) %>% 
  summary
```

**Tu turno**

``` r
... %>% st_drop_geometry() %>%
  dplyr::select(contains('...')) %>% 
  summary
```

  - Genera un histograma para cada respuesta posible de tu pregunta:

> Ejemplo de `hoyod` (la clave aquí es el `facet_grid`):

``` r
proven17 %>% st_drop_geometry() %>%
  dplyr::select(contains('Principales problemas de su barrio o comunidad: ¿Otro problema?')) %>%
  select_if(is.numeric) %>% gather(variable, valor) %>%
  ggplot + aes(x=valor) %>% geom_histogram(bins=5) +
  facet_grid(~variable)
```

**Tu turno** (Tip: edita el argumento `bins` dentro de la función
`geom_histogram` para adaptarlo a tus datos)

``` r
... %>% st_drop_geometry() %>%
  dplyr::select(contains('...')) %>%
  select_if(is.numeric) %>%  gather(variable, valor) %>%
  ggplot + aes(x=valor) %>% geom_histogram(bins=10) +
  scale_x_continuous(trans = 'log1p') + facet_grid(~variable)
```

  - Genera un histograma con escala logarítmica para cada respuesta
    posible de tu pregunta:

> Ejemplo de `hoyod`:

``` r
proven17 %>% st_drop_geometry() %>%
  dplyr::select(contains('Principales problemas de su barrio o comunidad: ¿Otro problema?')) %>%
  select_if(is.numeric) %>% gather(variable, valor) %>%
  ggplot + aes(x=valor) %>% geom_histogram(bins=10) +
  scale_x_continuous(trans = 'log1p') + facet_grid(~variable)
```

**Tu turno** (Tip: edita el argumento `bins` dentro de la función
`geom_histogram` para adaptarlo a tus datos)

``` r
... %>% st_drop_geometry() %>%
  dplyr::select(contains('...')) %>%
  select_if(is.numeric) %>%  gather(variable, valor) %>%
  ggplot + aes(x=valor) %>% geom_histogram(bins=10) +
  scale_x_continuous(trans = 'log1p') + facet_grid(~variable)
```

  - Genera un gráfico de barras en modo *dodge*, es decir, barras una al
    lado de la otra, y barras apiladas

> Ejemplo de `hoyod`:

``` r
#Barras una al lado de la otra (position = 'dodge')
proven17 %>%
  st_drop_geometry() %>%
  dplyr::select(contains('Principales problemas de su barrio o comunidad: ¿Otro problema?'), TOPONIMIA) %>%
  gather(variable, valor, -TOPONIMIA) %>%
  ggplot() + aes(x = TOPONIMIA, y = valor, fill = variable, group = variable) +
  geom_col(position = 'dodge') + scale_y_continuous() +
  theme(axis.text.x = element_text(angle = 90), text = element_text(size = 12)) + coord_flip()

#Barras apiladas (position = 'fill')
proven17 %>%
  st_drop_geometry() %>%
  dplyr::select(contains('Principales problemas de su barrio o comunidad: ¿Otro problema?'), TOPONIMIA) %>%
  gather(variable, valor, -TOPONIMIA) %>%
  ggplot() + aes(x = TOPONIMIA, y = valor, fill = variable, group = variable) +
  geom_col(position = 'fill') + scale_y_continuous() +
  theme(axis.text.x = element_text(angle = 90), text = element_text(size = 12)) + coord_flip()
```

**Tu turno**

``` r
#Barras una al lado de la otra (position = 'dodge')
... %>%
  st_drop_geometry() %>%
  dplyr::select(contains('...'), TOPONIMIA) %>%
  gather(variable, valor, -TOPONIMIA) %>%
  ggplot() + aes(x = TOPONIMIA, y = valor, fill = variable, group = variable) +
  geom_col(position = 'dodge') + scale_y_continuous() +
  theme(axis.text.x = element_text(angle = 90), text = element_text(size = 12))  + coord_flip()

#Barras apiladas (position = 'fill')
... %>%
  st_drop_geometry() %>%
  dplyr::select(contains('...'), TOPONIMIA) %>%
  gather(variable, valor, -TOPONIMIA) %>%
  ggplot() + aes(x = TOPONIMIA, y = valor, fill = variable, group = variable) +
  geom_col(position = 'fill') + scale_y_continuous() +
  theme(axis.text.x = element_text(angle = 90), text = element_text(size = 12))  + coord_flip()
```

  - Ahora genera una tabla que muestre las respuestas a tu pregunta en
    tu provincia asignada:

> El ejemplo del alumno `hoyod` sería tal que esto:

``` r
proven17 %>% st_drop_geometry() %>% filter(ENLACE=='0616') %>% 
  dplyr::select(contains('Principales problemas de su barrio o comunidad: ¿Otro problema?'))
```

**Tu turno**

``` r
... %>% st_drop_geometry() %>% filter(ENLACE=='...') %>% 
  dplyr::select(contains('...'))
```

library(sf)
library(tidyverse)
library(spdep)
library(lmtest)
library(tmap)
library(RColorBrewer)

en17 <- read.csv('data/enhogar_2017.csv', check.names = F)
prov <- st_read(dsn = 'data/divisionRD.gpkg', layer = 'PROVCenso2010')
en17 <- en17 %>% mutate(ENLACE = ifelse(nchar(Código)==3, paste0('0', Código),Código))
match(prov$ENLACE, en17$ENLACE)
proven17 <- prov %>% inner_join(en17, by = 'ENLACE')


proven17
proven17 %>%
  dplyr::select(contains('Principales problemas de su barrio o comunidad: ¿Otro problema?')) %>%
  plot(breaks = 'jenks')

proven17.sp <- as_Spatial(proven17)
colnames(proven17.sp@data)[1:20]
colnames(proven17.sp@data) <- proven17 %>% st_drop_geometry() %>% colnames
colnames(proven17.sp@data)[1:20]

row.names(proven17.sp) <- as.character(proven17.sp$TOPONIMIA)

proven17.nb <- poly2nb(proven17.sp, queen=TRUE)
summary(proven17.nb)

sapply(proven17.nb, function(x) x)


plot(proven17.sp, border="grey", lwd=0.5)
plot(proven17.nb, coordinates(proven17.sp), add=T)

is.symmetric.nb(proven17.nb)


coords <- coordinates(proven17.sp)
ident <- row.names(proven17.sp)
proven17.nb.k1 <- knn2nb(knearneigh(coords, k = 1), row.names = ident)
summary(proven17.nb.k1)

card(proven17.nb.k1)

sapply(proven17.nb.k1, function(x) x)

plot(proven17.sp, border="grey", lwd=0.5)
plot(proven17.nb.k1, coordinates(proven17.sp), add=T)

is.symmetric.nb(proven17.nb.k1)

dist <- unlist(nbdists(proven17.nb.k1, coords))
summary(dist)
hist(dist)

(distmin <- min(dist)) 
(distmax <- max(dist))
indicemin <- which(dist==distmin)
ident[indicemin]
indicemax <- which(dist==distmax)
ident[indicemax]

ident[order(dist)]

proven17.w.W <- nb2listw(proven17.nb)
proven17.w.B <- nb2listw(proven17.nb, style = 'B')

mivariable <- 'Principales problemas de su barrio o comunidad: ¿Otro problema?: Si'
proven17_mivar <- proven17 %>%
  st_centroid() %>% 
  select(ENLACE, mivariable=contains(mivariable), muestra) %>% 
  mutate('mivariable_pct' = mivariable/muestra*100,
         'mivariable_pct_log' = log1p(mivariable/muestra*100),
         x=unlist(map(geom,1)),
         y=unlist(map(geom,2))) %>%
  select(-muestra) %>% 
  st_drop_geometry()
proven17_mivar_sf <- proven17 %>%
  inner_join(proven17_mivar, by = 'ENLACE') %>% 
  dplyr::select(muestra, contains('mivariable'), x, y, ENLACE, TOPONIMIA)
proven17_mivar_sf

#Masivo
# saveRDS(variables, 'variables.RDS')
variables <- readRDS('variables.RDS')
mivarsf <- function(variable = NULL) {
  proven17_mivar <- proven17 %>%
    st_centroid() %>% 
    select(ENLACE, mivariable=variable, muestra) %>% 
    mutate('mivariable_pct' = mivariable/muestra*100,
           'mivariable_pct_log' = log1p(mivariable/muestra*100),
           x=unlist(map(geom,1)),
           y=unlist(map(geom,2))) %>%
    select(-muestra) %>% 
    st_drop_geometry()
  proven17_mivar_sf <- proven17 %>%
    inner_join(proven17_mivar, by = 'ENLACE') %>% 
    dplyr::select(muestra, contains('mivariable'), x, y, ENLACE, TOPONIMIA)
  return(proven17_mivar_sf)
}
allsf <- sapply(variables, mivarsf, simplify = F)
sapply(names(allsf), function(x) shapiro.test(allsf[[x]]$mivariable_pct))
sapply(names(allsf), function(x) shapiro.test(allsf[[x]]$mivariable_pct_log))
sapply(names(allsf), function(x) qqnorm(allsf[[x]]$mivariable_pct, main = x))
sapply(names(allsf), function(x) qqnorm(allsf[[x]]$mivariable_pct_log, main = x))

p1 <- tm_shape(proven17_mivar_sf) +
  tm_fill(col = "mivariable_pct", style = 'jenks',
          palette = brewer.pal(9, name = 'Reds'), title = mivariable) +
  tm_borders(lwd = 0.5)
p2 <- tm_shape(proven17_mivar_sf) +
  tm_fill(col = "mivariable_pct_log", style = 'jenks',
          palette = brewer.pal(9, name = 'Reds'), midpoint = NA, title = mivariable) +
  tm_borders(lwd = 0.5)
tmap_arrange(p1, p2)

qqnorm(proven17_mivar_sf$mivariable_pct) #Versión original de la variable
shapiro.test(proven17_mivar_sf$mivariable_pct) #Versión original de la variable
qqnorm(proven17_mivar_sf$mivariable_pct_log) #Versión transformada de la variable (log)
shapiro.test(proven17_mivar_sf$mivariable_pct_log) #Versión transformada de la variable (log)

proven17_mivar_sf %>% lm(mivariable_pct ~ x, .) %>% bptest()
proven17_mivar_sf %>% lm(mivariable_pct ~ y, .) %>% bptest()
proven17_mivar_sf %>% lm(mivariable_pct_log ~ x, .) %>% bptest()
proven17_mivar_sf %>% lm(mivariable_pct_log ~ y, .) %>% bptest()

(gmoranw <- moran.test(x = proven17_mivar_sf$mivariable_pct_log, listw = proven17.w.W))
(gmoranb <- moran.test(x = proven17_mivar_sf$mivariable_pct_log, listw = proven17.w.B))

#Masivo Moran Global
data.frame(VoF=sapply(names(allsf), function(x) moran.test(allsf[[x]]$mivariable_pct_log, listw = proven17.w.W)$p.value<0.05)) %>%
  rownames_to_column %>% as_tibble %>% arrange(rowname) %>% View

#Función lisamap
source('lisaclusters.R')

#LISA Clusters
lisamap(objesp = proven17_mivar_sf,
        var = 'mivariable_pct_log',
        pesos = proven17.w.W,
        tituloleyenda = 'Significancia\n("x-y", léase\ncomo "x"\nrodeado de "y"',
        fuentedatos = 'ENHOGAR 2017',
        anchuratitulo = 1000,
        titulomapa = 'Clusters LISA del porcentaje de respuestas a la pregunta\nPrincipales problemas de su barrio o comunidad: ¿Otro problema?: Si')

#Masivo LISA Clusters
lisamaps <- sapply(names(allsf),
       function(x) {
         m <- lisamap(objesp = allsf[[x]],
                 var = 'mivariable_pct_log',
                 pesos = proven17.w.W,
                 tituloleyenda = 'Significancia ("x-y", léase como "x" rodeado de "y")',
                 leyenda = F,
                 anchuratitulo = 50,
                 tamanotitulo = 10,
                 fuentedatos = 'ENHOGAR 2017',
                 titulomapa = paste0('Clusters LISA de "', x, '"'))
         # dev.new();print(m$grafico)
         return(m$grafico)
       }, simplify = F
)
library(gridExtra)
library(grid)
library(gtable)
lisamaps$leyenda <- gtable_filter(ggplot_gtable(ggplot_build(lisamaps[[1]] + theme(legend.position="bottom"))), "guide-box")
dev.new();grid.arrange(do.call('arrangeGrob', c(lisamaps[1:12], nrow = 3)), lisamaps$leyenda, heights=c(1.1, 0.1), nrow = 2)
dev.new();grid.arrange(do.call('arrangeGrob', c(lisamaps[13:22], nrow = 3)), lisamaps$leyenda, heights=c(1.1, 0.1), nrow = 2)

#Estilo "B"
lisamaps_estilo_b <- sapply(names(allsf),
                   function(x) {
                     m <- lisamap(objesp = allsf[[x]],
                                  var = 'mivariable_pct_log',
                                  pesos = proven17.w.B,
                                  tituloleyenda = 'Significancia ("x-y", léase como "x" rodeado de "y")',
                                  leyenda = F,
                                  anchuratitulo = 50,
                                  tamanotitulo = 10,
                                  fuentedatos = 'ENHOGAR 2017',
                                  titulomapa = paste0('Clusters LISA de "', x, '"'))
                     # dev.new();print(m$grafico)
                     return(m$grafico)
                   }, simplify = F
)
lisamaps_estilo_b$leyenda <- gtable_filter(ggplot_gtable(ggplot_build(lisamaps_estilo_b[[1]] + theme(legend.position="bottom"))), "guide-box")
dev.new();grid.arrange(do.call('arrangeGrob', c(lisamaps_estilo_b[1:12], nrow = 3)), lisamaps_estilo_b$leyenda, heights=c(1.1, 0.1), nrow = 2)
dev.new();grid.arrange(do.call('arrangeGrob', c(lisamaps_estilo_b[13:22], nrow = 3)), lisamaps_estilo_b$leyenda, heights=c(1.1, 0.1), nrow = 2)

save.image('solucion_objetos.RData')
save(proven17, proven17.w.B, proven17.w.W, file = 'objetos-para-modelizacion.RData')

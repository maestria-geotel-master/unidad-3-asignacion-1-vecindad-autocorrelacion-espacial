create_lisamap <- function(raster_file, extent_file, out_suffix, titulo_mapa) {
  # Example:
  # create_lisamap(
  #   raster_file = 'vel_ll_180_32619_filled_masked.tif',
  #   extent_file = 'extent_sjm.gpkg',
  #   out_suffix = 'test',
  #   titulo_mapa = 'LISA clusters of velocity')
  library(raster)
  library(spdep)
  library(sf)
  library(tidyverse)
  library(devtools)
  
  # Read the raster file
  r <- raster(raster_file)
  
  # Crop
  ext <- st_read(extent_file, quiet=T)
  rc <- crop(mask(r, ext), ext)
  
  # Convert to polygons
  v <-rasterToPolygons(rc)
  names(v) <- 'not_scaled'
  print(describe(v$not_scaled))
  v$scaled <- scale(v[[1]])
  attributes(v$scaled) <- NULL
  vsf <- st_as_sf(v)
  
  # Neighbour and weight objects
  nb <- poly2nb(v)
  ww <- nb2listw(nb, zero.policy = T)
  
  # lisamap function
  basegeotelpath <- 'https://raw.githubusercontent.com/maestria-geotel-master/'
  source_url(paste0(
    basegeotelpath,
    'unidad-3-asignacion-1-vecindad-autocorrelacion-espacial/master/lisaclusters.R'))
  # tmpfile <- tempfile()
  download.file(
    url = paste0(basegeotelpath, 
                 'unidad-3-asignacion-1-vecindad-autocorrelacion-espacial/master/lisamap.qml'),
    destfile = paste0('lisamap_', out_suffix, '.qml'))
  # lisa
  lisa <- lisamap(objesp = vsf,
                  var = 'scaled',
                  pesos = ww,
                  tituloleyenda = 'Significance\n("x-y", read as\n "x" surrounded\nby "y"',
                  leyenda = T,
                  anchuratitulo = 1000,
                  tamanotitulo = 16,
                  # fuentedatos = 'Hansen et al., 2013',
                  titulomapa = titulo_mapa)
  lisa$grafico
  
  # Export
  st_write(lisa$objeto, paste0('lisamap_', out_suffix, '.gpkg'), delete_dsn = T)
  
  return(lisa)
}

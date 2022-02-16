## rasterize vectors from fip
## dhemerson.costa@ipam.org.br

## read libraries
library(raster)
library(sf)
library(tools)
library(stars)

## define root
root <- './input'

## read unique filenames
region_name <- unique(file_path_sans_ext(list.files(root)))

## for each region
for (i in 1:length(region_name)) {
  print (paste0('processing region: ', region_name[i]))
  
  ## read vector
  vec_i <- read_sf(dsn= root, layer= region_name[i])
  
  ## create mask
  mask <- raster(crs=projection(vec_i), ext= extent(vec_i)); res(mask) = 0.00025
  
  ## convert to stars
  mask <- st_as_stars(mask)
  
  ## rasterize by using 'COD_CLASSE' as value
  r_i  <- st_rasterize(vec_i['COD_CLASSE'], template= mask)
  
  ## export as geoTiff
  write_stars(r_i, paste0('./raster/', region_name[i], '.tif'), type="Byte", drive="GTiff")
  timestamp()
  print (paste0(round(i / length(region_name) * 100, digits=1), '% done'))
  print ('next --->')
  
  ## clear temp
  rm(vec_i, mask, r_i)
  gc()
  removeTmpFiles(h=0)
  
}
print ('100%')

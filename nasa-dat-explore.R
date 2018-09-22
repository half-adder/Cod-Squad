## Exploring NASA data
## - sea surface temps

#install.packages("raster")

####### libraries
library(tidyverse)
library(ncdf4)
library(raster)

###### open file
path <- file.path("/Users", "Hope", "Projects", "hack4thesea", "data")
seasurface <- nc_open(file.path(path, "1_17.nc")) 

## limit to gulf of maine coordinates
LonIdx <- which( (seasurface$dim$lon$vals > 40) & (seasurface$dim$lon$vals < 46))
LatIdx <- which( (seasurface$dim$lat$vals > 59) & (seasurface$dim$lat$vals < 74))
MyVariable <- ncvar_get(seasurface, var[[sst4]])[LonIdx, LatIdx]
nc_close(seasurface)


##### look at it more
names(seasurface)
seasurface$var[[1]]

#seasurface$var$sst$units

##### using ncdf4 package
# resource: http://geog.uoregon.edu/bartlein/courses/geog490/week04-netCDF.html#reading-restructuring-and-writing-netcdf-files-in-r
print(seasurface)
lon <- ncvar_get(seasurface, "lon")
lat <- ncvar_get(seasurface, "lat")


##### using raster package 
# resource: https://rpubs.com/markpayne/358146
sea3d <- brick(file.path(path, "1_17.nc")) # brick: 3d data


sea3d         # there is 1 layer
plot(sea3d, xlab = "longitude", ylab = "latitude")   # this looks promising




#' grab_temp_dat
#'
#' @param month should be 1:12 (no leading zeros)
#' @param year should be 17, 18, etc. assuming 21st century 
#' @param path file path for data files
#' @param xmin
#' @param xmax
#' @param ymin
#' @param ymax
#'
#' @return cleaned df with monthly sea surface temps and corresponding lat/lon
grab_temp_dat <- function(month, year, path, xmin = 60, xmax = 73, ymin = 41, ymax = 45) {
  require(raster)
  require(assertthat)
  assert_that(is.dir(path)) # make sure it's a dir
  dat <- file.path(path, paste0(month, "_", year, ".nc"))
  stopifnot(file.exists(dat)) # make sure file exists
  
  sea3d <- brick(dat) # brick: 3d data
  
  # extracting data in a region (right now a latitude line)
  lon.section <- seq(60, 73, by = 0.00001)
  lat.section <- rep(41, length(lon.section)) # want this to go from 41:45
  
  
  
}

mybrick <- grab_temp_dat(month = "1", year = "17", path = path)
hasValues(mybrick)
dim(mybrick)



extract.section <- cbind(lon.section, lat.section)
ext.values <- raster::extract(sea3d, extract.section, ncol = 2) 

# to do: make data frame with lat as rows and long as columns and fill with temps
#        automate the process above for all longs & lats

# making data frame
seasurftemp <- as.data.frame(cbind(extract.section, ext.values))
colnames(seasurftemp)[3] <- "temp" 

# plotting graph of temps by longitude
plot(lon.section, ext.values, xlab = "Longitude", ylab = "Temps in Celcius")


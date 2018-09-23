## Exploring NASA data
## - sea surface temps

#install.packages("raster")

####### libraries
library(tidyverse)
library(ncdf4)
library(raster)

###### open file
Path <- file.path("/Users", "Hope", "Projects", "Cod-Squad", "data", "seasurface")
seasurface <- nc_open(file.path(path, "1_17.nc")) 

#' grab_temp_dat
#'
#' @param month should be 1:12 (no leading zeros) - INT
#' @param year should be 17, 18, etc. assuming 21st century - INT
#' @param path file path for data files
#' @param xmin
#' @param xmax
#' @param ymin
#' @param ymax
#'
#' @return cleaned df with monthly sea surface temps and corresponding lat/lon
grab_temp_dat <- function(month, year = "17", path = Path, xmin = -60, xmax = -73, ymin = 41, ymax = 45) {
  require(raster)
  require(assertthat)
  assert_that(is.dir(path)) # make sure it's a dir
  dat <- file.path(path, paste0(as.character(month), "_", as.character(year), ".nc"))
  stopifnot(file.exists(dat)) # make sure file exists
  sea3d <- brick(dat) # brick: 3d data
  lon.section <- seq(-73, -60, by = 0.02)
  # put it in a df
  seasurftemp <- map_dfr(41:45, function(x) {
    lat.section <- rep(x, length(lon.section))
    extract.section <- cbind(lon.section, lat.section)
    ext.values <- raster::extract(sea3d, extract.section, ncol = 2) 
    seasurftemp <- as.data.frame(cbind(extract.section, ext.values))
    names(seasurftemp) <- c("lon", "lat", "temp")
    return(seasurftemp)
  })
  return(seasurftemp)
}

mydf <- map_dfr(1:12, grab_temp_dat)
write.csv(mydf, file.path(Path, "seasurfacetemp.csv"))



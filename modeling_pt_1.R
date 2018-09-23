## Libraries
#install.packages("pscl")
library(pscl)

## Read in data
dat <- read.csv(file.choose()) 
dat <- na.omit(dat)
newdat <- left_join(dat, seasurfacetemp, 
                by = c("left" = "lon",
                       "right" = "lon",
                       "top" = "lat",
                       "bottom" = "lat"))

write.csv(newdat, "grid_level_with_temp.csv")

## Hurdle
h1 <- hurdle(,
             data = dat,
             dist = "negbin")


## Zero-inflated poisson
zip1 <- zeroinfl(, 
                 data = dat,
                 dist = "poisson")
  
  
## Zero-inflated negative binomial
zinb1 <- zeroinfl(, 
                  data = dat,
                  dist = "negbin")

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

sediment$count <- rowSums(sediment[, 2:9])
sediment$sediement_NA_flag <- ifelse(is.na(sediment$count), 1, 0)

write.csv(sediment, "sediment_grid_with_flag.csv")


master$grid_id <- as.factor(master$grid_id)

## make really truly final dat

final <- read.csv(file.choose())
buoy <- read.csv(file.choose())

final2 <- left_join(final, buoy, by = c("grid_id",
                                        "month"))
final3 <- left_join(final2, sediment %>% dplyr::select(grid_id, sediement_NA_flag))

final4 <- left_join(final3, newMaster %>% dplyr::select(grid_id, temp))

write.csv(final4, "MASTER.csv")

master2 <- left_join(master, mydf)

## for testing/training

dat_17 <- subset(master, year == 2017)
dat_18 <- subset(master, year == 2018)

## build out formula 

formula <- as.formula(number_of_fish ~ as.factor(month) + 
                        temp + GRAVEL + SAND + CLAY + MUD + SILT + ROCK + 
                        BEDROCK + sediement_NA_flag + grid_id + 
                        wind_direction_degrees + atmospheric_pressure_mb + 
                        wave_period_s + wave_height_m + wind_gust_m.s + 
                        wind_direction_degrees +  visibility_m + 
                        temp + air_temperatures_deg_f )

formula2 <- as.formula(number_of_fish ~ as.factor(month) + 
                        temp + sediement_NA_flag + as.factor(grid_id) + 
                        wind_direction_degrees + atmospheric_pressure_mb + 
                        wave_period_s + wave_height_m + wind_gust_m.s + 
                        wind_direction_degrees +  visibility_m + 
                        temp + air_temperatures_deg_f)


formula_single_year <- as.formula(number_of_fish ~ as.factor(month) +  
                                    GRAVEL + SAND + CLAY + MUD + SILT + ROCK + SEDIMENT + 
                                    BEDROCK + sediement_NA_flag + as.factor(grid_id))


## Poisson
pois1 <- glm(formula,
           data = master3,
           family = "poisson")

### significant factors ###

# atmospheric pressure
# sediment 
# sand
# air temperature
# wind gust 
# air temp degrees 

df$pred <- predict(pois1, master3[, 15:17])
plot(master3, df$count)
lines(df$days, df$pred,type='l',col='blue')



pois2 <- glm(formula2,
             data = master3,
             family = "poisson")




## Hurdle
h1 <- hurdle(as.formula(number_of_fish ~ .),
             data = master,
             dist = "negbin")


## Zero-inflated poisson
zip1 <- zeroinfl(, 
                 data = master,
                 dist = "poisson")
  

## Zero-inflated negative binomial
zinb1 <- zeroinfl(, 
                  data = master,
                  dist = "negbin")

rm(list = objects())
graphics.off()

library(dplyr)
library(lubridate)

#%% Question 1 %%#
colnames(airquality)
summary(airquality)
View(airquality)
pairs(airquality) # Pratique pour les petits jeux de données

#%% Question 2 %%#
airquality$Date <- as.Date(paste("1973", airquality$Month, airquality$Day , sep = "-"))


#%% Question 3 %%#
par(mfrow = c(2, 2), mar = c(4.1, 4, 2, 2))
plot(airquality$Date, airquality$Ozone, pch = 16, col = "darkred")
plot(airquality$Date, airquality$Solar.R, pch = 16, col = "skyblue")
plot(airquality$Date, airquality$Wind, pch = 16, col = "forestgreen")
plot(airquality$Date, airquality$Temp, pch = 16, col = "darkblue")

#%% Question 4 %%#
airquality %>% summarise_all(function(x) 100*mean(is.na(x)))

#%% Question 5 %%#
par(mfrow = c(2, 2), mar = c(4.1, 4, 2, 2))
plot(airquality$Wind, airquality$Ozone, pch = 16)
plot(airquality$Temp, airquality$Ozone, pch = 16)
plot(airquality$Solar.R, airquality$Ozone, pch = 16)
plot(airquality$Wind, airquality$Solar.R, pch = 16)

#%% Question 6 %%#
lm_ozone <- lm(Ozone ~ Wind + Temp + Solar.R, data = airquality)
summary(lm_ozone)
plot(lm_ozone)

lm_solar <- lm(Solar.R ~ Ozone, data = airquality)
summary(lm_solar)

#%% Question 7 %%#
plot(airquality$Solar.R, airquality$Ozone, pch = 16)

# Avec ggplot2:
library(ggplot2)
ggplot(airquality, aes(x = Solar.R, y = Ozone)) + geom_point()

#%% Question 8 %%#
100 * mean(is.na(airquality$Ozone) & is.na(airquality$Solar.R))

#%% Question 9 %%#
aq <- airquality
indices <- is.na(airquality$Ozone) & !is.na(airquality$Solar.R)
aq$Ozone[indices] <- predict(lm_ozone, newdata = airquality[indices, ])
aq$Ozone_isna <- indices

#%% Question 10 %%#
indices <- is.na(airquality$Solar.R) & !is.na(airquality$Ozone)
aq$Solar.R[indices] <- predict(lm_solar, newdata = airquality[indices, ])
aq$Solar.R_isna <- indices

#%% Question 11 %%#
par(mfrow=c(2 ,1))
plot(aq$Date , aq$Ozone , xlab="",ylab="Ozone", pch =16+aq$Ozone_isna , col=c("#c0392b", "#2c3e50")[1+ aq$Ozone_isna])
plot(aq$Date , aq$Solar.R , xlab="", ylab="Solar.R", pch =16+aq$Solar.R_isna , col=c("#27ae60", "#2c3e50")[1+ aq$Solar.R_isna ])
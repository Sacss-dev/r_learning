rm(list = objects())
graphics.off()

library(dplyr)
library(lubridate)

#%% Question 1%%#
sp500 <- read.csv("chart.csv") %>%
          dplyr::mutate(Date = lubridate::my(Date))
n <- nrow(sp500)

#%% Question 2 %%#
delta <- (sp500$S.P.500[-1] - sp500$S.P.500[-n]) / sp500$S.P.500[-n] 
sp500$Perf <- c(NA, delta)

# Alternative:
#sp500 <- sp500 %>% dplyr::mutate(Perf = (S.P.500 - lag(S.P.500, 1)) / lag(S.P.500, 1))

#%% Question 3 %%#
hist(sp500$Perf, breaks = 30)

#%% Question 4 %%#
Perf <- sp500$Perf[!is.na(sp500$Perf)]

# +/- 0.01 sinon R ne voudra pas afficher l'histo
batons <- seq(round(min(Perf) - 0.01, 2), round(max(Perf) + 0.01, 2), by = 0.01)

#%% Question 5 %%#
hist(Perf, breaks = batons)

#%% Question 6 %%#
mu <- mean(Perf)
sigma <- sd(Perf)

#%% Question 7 %%#
hist(Perf , breaks = batons , col="#3498db", freq = FALSE , xlab="Performance mensuelle", ylab="Densité", main="SP500")
lines(batons , dnorm(batons , mu , sigma), col="#e74c3c", lwd =2)

#%% Question 8 %%#
lines(density(Perf), col="darkblue", lwd =2)

#%% Question 9 %%#
Perf_standard <- (Perf - mu) / sigma
skewness <- mean(Perf_standard**3)
kurtosis <- mean(Perf_standard**4)

skewness # skewness < 0 : asymétrie à gauche
kurtosis # > 3: queue plus épaisse qu'une gaussienne

#%% Question 10 %%#
n <- length(Perf)
stat_JB <- n*(skewness**2 / 6 + (kurtosis - 3)**2 / 24)
stat_JB

#%% Question 11 %%#
curve(dchisq(x, df = 2), from = 0, to = 10, col = "red", lwd = 2)

pval <- 1 - pchisq(stat_JB, df = 2)
pval # Très forte preuve pour rejeter H0

#%% Question 12 %%#
testJB <- function(x) {
  # On supprime d'abord les NAs
  x <- x[!is.na(x)]
  n <- length(x)
  
  # On standardise les données
  z <- (x - mean(x)) / sd(x)
  
  # Calcul de la statistique de test
  skewness <- mean(z**3)
  kurtosis <- mean(z**4)
  
  # Sous H0, stat_JB suit un chi-2 à 2 DDL.
  stat_JB <- n*(skewness**2 / 6 + (kurtosis - 3)**2 / 24)
  pval <- 1 - pchisq(stat_JB, df = 2)
  
  return(pval)
}

# Typiquement on conserve H0 si pval >= 0.05 ou 0.1
testJB(Perf)
testJB(rnorm(50, mean = 2.5, sd = 0.5)) # Exemple où on conserve H0
# car la pvaleur est très grande

#%% Bonus : performance annualisée %%#
sp500_yearly <- sp500 %>%
                  dplyr::select(-Perf) %>%
                  dplyr::filter(lubridate::month(Date) == 1) %>%
                  dplyr::mutate(Perf = 100 * (S.P.500 - lag(S.P.500, 1)) / S.P.500)

mean(sp500_yearly$Perf, na.rm = T)

library(ggplot2)
ggplot(sp500_yearly, aes(x = Date, y = S.P.500)) + geom_line()

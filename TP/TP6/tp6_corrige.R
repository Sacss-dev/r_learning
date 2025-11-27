rm(list = objects())
graphics.off()

#%% Question 1 %%#
#install.packages("CASdatasets", repos = "https://cas.uqam.ca/pub/", type="source")
library(CASdatasets)

#%% Question 2 %%#
library(data.table)

data(freMTPLfreq) # Charger les données
data(freMTPLsev)
setDT(freMTPLfreq) # Passer en data table
setDT(freMTPLsev)

class(freMTPLfreq$PolicyID)
class(freMTPLsev$PolicyID) # Problème ici
freMTPLsev$PolicyID = as.factor(freMTPLsev$PolicyID)


View(freMTPLfreq[1:10, ])

#%% Question 3 %%#
table(freMTPLfreq$ClaimNb) # Fréquence empirique
mean(freMTPLfreq$ClaimNb)
var(freMTPLfreq$ClaimNb)

# Estimateur de la méthode des moments:

lambda_0 = mean(freMTPLfreq$ClaimNb / freMTPLfreq$Exposure)
lambda_1 = mean(freMTPLfreq$ClaimNb) / mean(freMTPLfreq$Exposure)
lambda_2 = mean((freMTPLfreq$ClaimNb - lambda_0)**2 / freMTPLfreq$Exposure)
lambda_2_bis = mean((freMTPLfreq$ClaimNb - lambda_1)**2 / freMTPLfreq$Exposure)
# Différence importante entre les estimateurs:
# Ne suit probablement pas une loi de Poisson (trop de variance)

#%% Question 5 %%#
freq_empirique <- table(freMTPLfreq$ClaimNb)

freq_poisson <- rep(0, 5)
for(i in 0:4) {
  freq_poisson[i+1] <- sum(dpois(i, lambda_1 * freMTPLfreq$Exposure))
}

# ou alors :

freq_poisson <- sapply(unique(freMTPLfreq$ClaimNb), function(i) sum(dpois(i, lambda_1 * freMTPLfreq$Exposure)))

plot(log10(freq_poisson), log10(freq_empirique), type = "b")
abline(a = 0, b = 1, col = "red")

#%% Question 6 %%#
plot(c(0:4), freq_poisson, log = "y", type="b", pch=16, xlab="", ylab="log10−observations",
     lwd = 2)
lines(c(0:4),freq_empirique, type="b", pch =16, col="blue", lwd = 2)
legend(x = "topright", legend = c("Freq Poisson", "Freq Empi"), col = c("black", "blue"), lty = 1, pch = 16)

#%% Question 7 %%#
freMTPLsev_gb <- freMTPLsev[, .(S_i = sum(ClaimAmount)), by = PolicyID]
freMTPLsev_gb <- freMTPLsev_gb[order(PolicyID)]
freMTPLsev_gb[freMTPLfreq, ClaimNb := ClaimNb , on = "PolicyID"]
freMTPLsev_gb$S_i_mean <- freMTPLsev_gb$S_i/freMTPLsev_gb$ClaimNb

# Avec Dplyr:
library(dplyr)
tmp <- freMTPLsev %>%
                group_by(PolicyID) %>%
                summarise(S_i = sum(ClaimAmount)) %>%
                left_join(freMTPLfreq %>% select(PolicyID, ClaimNb), by = "PolicyID") %>%
                mutate(S_i_mean = S_i / ClaimNb)

# Calcul de la corrélation:
freMTPLsev_gb[,cor(S_i_mean, ClaimNb)] # Ou en syntaxe native:
cor(freMTPLsev_gb$S_i_mean , freMTPLsev_gb$ClaimNb)
# Cependant ATTENTION, cela n'implique aucunement l'indép !

# Alternative pertinente: information mutuelle (https://en.wikipedia.org/wiki/Mutual_information)
# library(infotheo)
# tmp <- discretize(freMTPLsev_gb[, c("S_i_mean", "ClaimNb")])
# mutinformation(tmp$S_i_mean , tmp$ClaimNb, method = "emp")
# MI faible donc en effet va dans le sens de l'indépendance

#%% Question 8 %%#
hist(freMTPLsev$ClaimAmount, xlab = "Montant sinistre", breaks = 100, col = "blue")
alpha <- 0.95
hist(freMTPLsev[ClaimAmount < quantile(ClaimAmount, alpha), ClaimAmount],
     xlab = "Montant sinistre", col = "blue", breaks = 100)
# On observe un mode vers 1200
hist(freMTPLsev[(ClaimAmount > 900) & (ClaimAmount < 1500), ClaimAmount],
     xlab = "Montant sinistre", col = "blue", breaks = 60)
# Sinistres avec franchise standardisée ? E.g. bris de glace

#%% Questions 9 & 10 %%#
tmp <- freMTPLsev %>%
          left_join(freMTPLfreq %>% select(PolicyID, CarAge , DriverAge), by = "PolicyID")

#tmp <- freMTPLsev[freMTPLfreq[, .(PolicyID, CarAge, DriverAge)], on = "PolicyID"]
cor(tmp %>% select(-PolicyID))
cor(tmp %>% filter(ClaimAmount > 30000)%>% select(-PolicyID))
# Corrélation plus importante sur les gros sinistres
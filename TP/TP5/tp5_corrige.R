rm(list = objects())
graphics.off()

library(data.table)
library(dplyr)

#%% Question 0 - récupérer les données %%#
input <- if (file.exists("flights14.csv")) {
  "flights14.csv"
} else {
  "https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv"
}

flights <- fread(input)

#%% Question 1 %%#
summary(flights)
View(flights[1:100, ]) # Eviter de faire View sur l'ensemble du JDD

#%% Question 2 %%#
# On cherche à faire la somme de tous les retards de vols
# A l'origine de l'aéroport JFK
t0 <- system.time({
  s = 0
  for(i in 1:nrow(flights))
    if(flights[i, ]$origin == "JFK")
      s = s + flights[i, ]$dep_delay
})

t1 <- system.time({
  s = 0
  for(i in 1:nrow(flights))
    if(flights[i, "origin"] == "JFK")
      s = s + flights[i, "dep_delay"]
})

t0
t1
# Les deux sont comparables. Par contre si maintenant on utilise
# L'aspect vectoriel de R

t2 <- system.time({
  sum(flights$dep_delay[flights$origin == "JFK"])
  # Alternative: flights[origin == "JFK", sum( dep_delay )]
})
t2

#%% Question 3 %%#
?tapply
tapply(flights$dep_delay, flights$origin, sum)
# Alternative avec dplyr:
# flights %>% group_by(origin) %>% summarise(somme = sum(dep_delay))

tapply(flights$dep_delay, flights$origin, sd)

#%% Question 4 - Idem mais syntaxe data.table %%#
flights[, sum(dep_delay), by = origin]
flights[, sd(dep_delay), by = origin]

#%% Question 5 %%#
flights_ic <- flights[, .(Moyenne = mean(dep_delay),
                          EcartType = sd(dep_delay),
                          N = length(dep_delay)), by=origin]

alpha <- 0.05 # Niveau de risque 5% ici
q <- qnorm(1 - alpha / 2)
flights_ic[, .(origin, Moyenne, IC_inf = Moyenne - q * EcartType /sqrt(N),
                                IC_sup = Moyenne + q * EcartType / sqrt(N))]

# Alternative avec dplyr:
flights %>%
  group_by(origin) %>%
  summarise(Moyenne = mean(dep_delay),
            IC_inf = mean(dep_delay) - q * sd(dep_delay) / sqrt(n()),
            IC_sup = mean(dep_delay) + q * sd(dep_delay) / sqrt(n()))

#%% Question 6 %%#
colors <- c("EWR" = "#2980b9", "JFK" = "#27ae60", "LGA" = "#c0392b")
col <- colors[flights$origin]

#%% Question 7 %%#
plot(flights$dep_delay, flights$arr_delay, pch = 16, col = col,
     xlab = "Retard au départ", ylab = "Retard à l'arrivée")
legend(x = "topleft", names(colors), col = colors , pch =16)

# Alternative avec ggplot2
library(ggplot2)
ggplot(flights, aes(x = dep_delay, y = arr_delay, color = origin)) +
    geom_point()
# Afficher en pdf est généralement préférable, mais ici il y a
# trop de points => pdf lourd à charger et enregistrer
# => png préférable pour une fois.

#%% Question 8 %%#
# Corrélation linéaire (aka de Pearson)
flights[, cor(dep_delay, arr_delay), by = origin]
flights[, cor(dep_delay, arr_delay - dep_delay), by = origin]

#%% Question 9 %%#
plot(flights$dep_delay, flights$arr_delay - flights$dep_delay, pch=16, col=col, xlab="Retard au départ", ylab="Retard à l’arrivée")
legend("topright", names(colors), col=colors, pch = 16)

#%% Question 10 %%#
dep_delay_group_name <- c("<=60", ">60& <=180", ">180")

dep_delay_group <- dep_delay_group_name[(flights$dep_delay > 180) + (flights$dep_delay > 60) + 1]
flights$dep_delay_group <- dep_delay_group

#%% Question 11 %%#
flights[, .(Moyenne = mean(arr_delay - dep_delay),
            EcartType = sd(arr_delay - dep_delay),
            Cor = cor(dep_delay, arr_delay - dep_delay), N = length(dep_delay)), by= dep_delay_group]

# Avec dplyr:
flights %>%
  group_by(dep_delay_group) %>%
  summarise(Moyenne = mean(arr_delay - dep_delay),
            EcartType = sd(arr_delay - dep_delay),
            Cor = cor(dep_delay, arr_delay - dep_delay),
            N = n())

#%% Question 12 %%#
colors <- c("#2980b9", "#27ae60", "#c0392b")
names(colors) <- dep_delay_group_name
col <- colors[flights$dep_delay_group]
plot(flights$dep_delay, flights$arr_delay - flights$dep_delay, pch =16, col=col, 
      xlab = "Retard au départ",ylab = "Retard à l’arrivée")
legend("topright", names(colors), col=colors , pch =16)
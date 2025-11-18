# Statistique descriptive avec R

## TP 4

Nous allons travailler sur les données `airquality` intégrées à R.

------------------------------------------------------------------------

### 1. Explorez vos données.

**📝 Corrigé**

``` r
data <- airquality
str(data)
summary(data)
head(data)
```

------------------------------------------------------------------------

### 2. La colonne Day donne le jour et la colonne Month donne le mois.

En consultant l'aide de airquality, ajoutez une colonne Date au format
Date de R.\
Puis supprimez les colonnes Day et Month.

**📝 Corrigé**

``` r
data$Date <- as.Date(
  paste(data$Year <- 1973, data$Month, data$Day, sep = "-"),
  format = "%Y-%m-%d"
)

data$Year <- NULL
data$Month <- NULL
data$Day <- NULL
```

------------------------------------------------------------------------

### 3. Utilisation de `par` pour afficher 4 graphiques

Affichez les vecteurs Ozone, Solar.R, Wind et Temp en fonction de Date,\
avec `pch = 16` et des couleurs différentes.

**📝 Corrigé**

``` r
par(mfrow=c(2,2), mar=c(4.1,4,2,2))

plot(data$Date, data$Ozone,  pch=16, col="steelblue",   main="Ozone")
plot(data$Date, data$Solar.R,pch=16, col="darkorange",  main="Solar.R")
plot(data$Date, data$Wind,   pch=16, col="seagreen",    main="Wind")
plot(data$Date, data$Temp,   pch=16, col="purple",      main="Temp")
```

------------------------------------------------------------------------

### 4. Calculez la proportion de NA par colonne.

**📝 Corrigé**

``` r
colMeans(is.na(data))
```

------------------------------------------------------------------------

### 5. Affichez Ozone et Solar.R en fonction de Wind et Temp (4 graphiques) et commentez.

**📝 Corrigé**

``` r
par(mfrow=c(2,2))

plot(data$Wind,  data$Ozone,   pch=16, col="steelblue",  main="Ozone ~ Wind")
plot(data$Temp,  data$Ozone,   pch=16, col="steelblue",  main="Ozone ~ Temp")
plot(data$Wind,  data$Solar.R, pch=16, col="darkorange", main="Solar.R ~ Wind")
plot(data$Temp,  data$Solar.R, pch=16, col="darkorange", main="Solar.R ~ Temp")
```

------------------------------------------------------------------------

### 6. Régression linéaire pour estimer les données manquantes.

Faites la régression de Ozone et Solar.R contre toutes les autres
variables.\
Supprimez les variables non significatives (5%).

**📝 Corrigé**

``` r
mod_oz <- lm(Ozone ~ Solar.R + Wind + Temp, data=data)
summary(mod_oz)

mod_oz2 <- lm(Ozone ~ Wind + Temp, data=data)
summary(mod_oz2)

mod_solar <- lm(Solar.R ~ Ozone + Wind + Temp, data=data)
summary(mod_solar)

mod_solar2 <- lm(Solar.R ~ Ozone + Temp, data=data)
summary(mod_solar2)
```

------------------------------------------------------------------------

### 7. Affichez Ozone en fonction de Solar.R

**📝 Corrigé**

``` r
plot(data$Solar.R, data$Ozone, pch=16, col="darkred",
     xlab="Solar.R", ylab="Ozone", main="Ozone en fonction de Solar.R")
```

------------------------------------------------------------------------

### 8. Vérifiez s'il existe des cas où Ozone ET Solar.R sont NA simultanément.

**📝 Corrigé**

``` r
sum(is.na(data$Ozone) & is.na(data$Solar.R))
```

------------------------------------------------------------------------

### 9. Imputation de Ozone via la régression linéaire (là où Solar.R n'est pas NA)

**📝 Corrigé**

``` r
aq <- data

mod_oz_final <- mod_oz2

ind <- is.na(aq$Ozone) & !is.na(aq$Solar.R)

pred_oz <- predict(mod_oz_final, newdata=aq[ind, ])

aq$Ozone[ind] <- pred_oz
```

------------------------------------------------------------------------

### 10. Faites de même pour Solar.R (là où Ozone n'est pas NA)

**📝 Corrigé**

``` r
mod_solar_final <- mod_solar2

ind <- is.na(aq$Solar.R) & !is.na(aq$Ozone)

pred_solar <- predict(mod_solar_final, newdata=aq[ind, ])

aq$Solar.R[ind] <- pred_solar
```

------------------------------------------------------------------------

### 11. Affichez Ozone et Solar.R en fonction de Date avec les données complétées.

Les données imputées seront affichées avec `pch=17` et une couleur
sombre.

**📝 Corrigé**

``` r
par(mfrow=c(2,1))

plot(aq$Date, aq$Ozone, pch=16, col="steelblue", main="Ozone complété")
points(aq$Date[is.na(data$Ozone)], 
       aq$Ozone[is.na(data$Ozone)],
       pch=17, col="black")

plot(aq$Date, aq$Solar.R, pch=16, col="darkorange", main="Solar.R complété")
points(aq$Date[is.na(data$Solar.R)],
       aq$Solar.R[is.na(data$Solar.R)],
       pch=17, col="black")
```

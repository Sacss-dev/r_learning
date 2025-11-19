# Statistique descriptive avec R

## TP 4

Nous allons travailler sur les données `airquality` intégrées à R.

------------------------------------------------------------------------

### 1. Explorez vos données.

**📝 Corrigé**

``` r
colnames(airquality)
summary(airquality)
View(airquality)
pairs(airquality) # Pratique pour les petits jeux de données
```

------------------------------------------------------------------------

### 2. La colonne Day donne le jour et la colonne Month donne le mois.

En consultant l'aide de airquality, ajoutez une colonne Date au format
Date de R.\
Puis supprimez les colonnes Day et Month.

**📝 Corrigé**

``` r
airquality$Date <- as.Date(paste("1973", airquality$Month, airquality$Day , sep = "-"))
```

------------------------------------------------------------------------

### 3. Utilisation de `par` pour afficher 4 graphiques

Affichez les vecteurs Ozone, Solar.R, Wind et Temp en fonction de Date,\
avec `pch = 16` et des couleurs différentes.

**📝 Corrigé**

``` r
par(mfrow = c(2, 2), mar = c(4.1, 4, 2, 2))

plot(airquality$Date, airquality$Ozone, pch = 16, col = "darkred")
plot(airquality$Date, airquality$Solar.R, pch = 16, col = "skyblue")
plot(airquality$Date, airquality$Wind, pch = 16, col = "forestgreen")
plot(airquality$Date, airquality$Temp, pch = 16, col = "darkblue")
```

Ce qui nous donne le graphique suivant : 


<br />  
<div align="center"> <img src="/TP/TP4/graphique_q3" alt="Graphique Q3" width="600"/> </div>
<br /> 



------------------------------------------------------------------------

### 4. Calculez la proportion de NA par colonne.

**📝 Corrigé**

``` r
colMeans(is.na(data))

# Alternative plus classique 
pourcentages <- apply(airquality, MARGIN=2, FUN= function(x) 100 * mean(is.na(x)))

# solution encore plus opti
airquality %>% summarise_all(function(x) 100*mean(is.na(x)))
```

------------------------------------------------------------------------

### 5. Affichez Ozone et Solar.R en fonction de Wind et Temp (4 graphiques) et commentez.

**📝 Corrigé**

``` r
par(mfrow = c(2, 2), mar = c(4.1, 4, 2, 2))


plot(airquality$Wind, airquality$Ozone, pch = 16)
plot(airquality$Temp, airquality$Ozone, pch = 16)
plot(airquality$Solar.R, airquality$Ozone, pch = 16)
plot(airquality$Wind, airquality$Solar.R, pch = 16)
```

<br />  
<div align="center"> <img src="/TP/TP4/graphique_q5" alt="Graphique Q5" width="600"/> </div>
<br /> 



------------------------------------------------------------------------

### 6. Régression linéaire pour estimer les données manquantes.

Faites la régression de Ozone et Solar.R contre toutes les autres
variables.\
Supprimez les variables non significatives (5%).

**📝 Corrigé**

``` r
lm_ozone <- lm(Ozone ~ Wind + Temp + Solar.R, data = airquality)
summary(lm_ozone)
plot(lm_ozone)

lm_solar <- lm(Solar.R ~ Ozone, data = airquality)
summary(lm_solar)
```



<br />  
<div align="center"> <img src="/TP/TP4/graphique_q6" alt="Graphique Q6" width="600"/> </div>
<br /> 



------------------------------------------------------------------------

### 7. Affichez Ozone en fonction de Solar.R

**📝 Corrigé**

``` r
plot(airquality$Solar.R, airquality$Ozone, pch = 16)

# Avec ggplot2:
library(ggplot2)
ggplot(airquality, aes(x = Solar.R, y = Ozone)) + geom_point()
```


<br />  
<div align="center"> <img src="/TP/TP4/graphique_q7" alt="Graphique Q7" width="600"/> </div>
<br /> 

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
aq <- airquality
indices <- is.na(airquality$Ozone) & !is.na(airquality$Solar.R)
aq$Ozone[indices] <- predict(lm_ozone, newdata = airquality[indices, ])
aq$Ozone_isna <- indices
```

------------------------------------------------------------------------

### 10. Faites de même pour Solar.R (là où Ozone n'est pas NA)

**📝 Corrigé**

``` r
indices <- is.na(airquality$Solar.R) & !is.na(airquality$Ozone)
aq$Solar.R[indices] <- predict(lm_solar, newdata = airquality[indices, ])
aq$Solar.R_isna <- indices
```

------------------------------------------------------------------------

### 11. Affichez Ozone et Solar.R en fonction de Date avec les données complétées.

Les données imputées seront affichées avec `pch=17` et une couleur
sombre.

**📝 Corrigé**

``` r
par(mfrow=c(2 ,1))
plot(aq$Date , aq$Ozone , xlab="",ylab="Ozone", pch =16+aq$Ozone_isna , col=c("#c0392b", "#2c3e50")[1+ aq$Ozone_isna])
plot(aq$Date , aq$Solar.R , xlab="", ylab="Solar.R", pch =16+aq$Solar.R_isna , col=c("#27ae60", "#2c3e50")[1+ aq$Solar.R_isna ])
```

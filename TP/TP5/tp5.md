
# Statistique descriptive avec R  
## TP 5

Nous allons travailler sur les données américaines **flights14** (vols au départ de New York, jan‑oct 2014).

---

### 1. Importez avec `data.table` et explorez vos données.
**📝 Corrigé**
```r
library(data.table)

input <- if (file.exists("flights14.csv")) {
  "flights14.csv"
} else {
  "https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv"
}

flights <- fread(input)

# Exploration
str(flights)
summary(flights)
head(flights)
View(flights[1:100, ]) # Eviter de faire View sur l'ensemble du JDD
```

---

### 2. Ne pas parcourir les lignes une à une.  
Exécutez les deux codes fournis et proposez une solution efficace (mesurez avec `system.time`).

**📝 Corrigé**
```r
# On cherche à faire la somme de tous les retards de vols
# A l'origine de l'aéroport JFK

# Code 1 (lent)
t0 <- system.time({
  s = 0
  for(i in 1:nrow(flights))
    if(flights[i, ]$origin == "JFK")
      s = s + flights[i, ]$dep_delay
})

# Code 2 (lent)
t1 <- system.time({
  s = 0
  for(i in 1:nrow(flights))
    if(flights[i, "origin"] == "JFK")
      s = s + flights[i, "dep_delay"]
})

t0
t1


# Les deux sont comparables. Par contre si maintenant on utilise l'aspect vectoriel de R

# Code 3 (rapide)

t2 <- system.time({
  sum(flights$dep_delay[flights$origin == "JFK"])
  # Alternative: flights[origin == "JFK", sum( dep_delay )]
})
t2
```

et on obtient un retour suivant : 

```shell
> t0
   user  system elapsed 
 13.588   0.321  13.966 
> t1
   user  system elapsed 
 30.708   0.440  31.140 
> t2
   user  system elapsed 
  0.001   0.000   0.001 
```

> LA VITESSE !

---

### 3. Moyenne et écart‑type du retard au départ avec `tapply`.

**📝 Corrigé**
```r
tapply(flights$dep_delay, flights$origin, sum)
# Alternative avec dplyr:
# flights %>% group_by(origin) %>% summarise(somme = sum(dep_delay))

tapply(flights$dep_delay, flights$origin, sd)


```

---

### 4. Même chose avec la syntaxe `data.table`.

**📝 Corrigé**
```r
# moyenne et écart-type par aéroport
flights[, sum(dep_delay), by = origin]
flights[, sd(dep_delay), by = origin]
```

---

### 5. IC asymptotique 95% pour la moyenne du retard par aéroport.

**📝 Corrigé**
```r
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
```

> Commentaire : interpréter les largeurs d'IC en fonction de n et de la variance.

---

### 6. Vecteur de couleurs par aéroport.

**📝 Corrigé**
```r
colors <- c("EWR" = "#2980b9", "JFK" = "#27ae60", "LGA" = "#c0392b")
col <- colors[flights$origin]
```

---

### 7. `arr_delay` en fonction de `dep_delay` coloré par origine + légende.

**📝 Corrigé**
```r
plot(flights$dep_delay, flights$arr_delay, pch = 16, col = col,
     xlab = "Retard au départ", ylab = "Retard à l'arrivée")
legend(x = "topleft", names(colors), col = colors , pch =16)


# Alternative avec ggplot2
library(ggplot2)
ggplot(flights, aes(x = dep_delay, y = arr_delay, color = origin)) +
    geom_point()
    
# Afficher en pdf est généralement préférable, mais ici il y a trop de points => pdf lourd à charger et enregistrer
# => png préférable pour une fois.
```

> Format recommandé pour l'enregistrement : PNG ou PDF selon si l'on veut bitmap (PNG) ou vectoriel (PDF) ; pour grands volumes de points, PNG est souvent plus simple.


<div align="center"> <img src="/TP/TP5/graphique_q7_1.png" alt="Graphique Q7 avec plot" width="600"/> </div>
<div align="center">  Graphique généré avec la fonction plot <br /> </div>


<div align="center"> <img src="/TP/TP5/graphique_q7_2.png" alt="Graphique Q7 avec ggplot2" width="600"/> </div>
<div align="center">  Graphique généré avec ggplot2 <br /> </div>



---

### 8. Corrélations par origine : `arr_delay` vs `dep_delay`, puis vs `arr_delay - dep_delay`.

**📝 Corrigé**
```r
# Corrélation linéaire (aka de Pearson)
flights[, cor(dep_delay, arr_delay), by = origin]
flights[, cor(dep_delay, arr_delay - dep_delay), by = origin]
```
> Ce qui nous donne l'affichage suivant : 

```shell
> flights[, cor(dep_delay, arr_delay), by = origin]
   origin        V1
   <char>     <num>
1:    JFK 0.9166548
2:    LGA 0.9183728
3:    EWR 0.9343938

> flights[, cor(dep_delay, arr_delay - dep_delay), by = origin]
   origin          V1
   <char>       <num>
1:    JFK 0.052560172
2:    LGA 0.003391104
3:    EWR 0.050983023
```

> Remarque : la corrélation avec `arr_delay - dep_delay` renseigne sur la compensation effectuée en vol.

---

### 9. Affiche `arr_delay - dep_delay` vs `dep_delay` (comparaison graphique).

**📝 Corrigé**
```r
plot(flights$dep_delay, flights$arr_delay - flights$dep_delay, pch=16, col=col, xlab="Retard au départ", ylab="Retard à l’arrivée")
legend("topright", names(colors), col=colors, pch = 16)
```

> Ce qui nous donne le graphique suivant : 

<div align="center"> <img src="/TP/TP5/graphique_q9.png" alt="Graphique Q9" width="600"/> </div>

---

### 10. Ajoutez `dep_delay_group` : "<=60", ">60&<=300", ">300".

**📝 Corrigé**
```r
dep_delay_group_name <- c("<=60", ">60& <=180", ">180")

dep_delay_group <- dep_delay_group_name[(flights$dep_delay > 180) + (flights$dep_delay > 60) + 1]
flights$dep_delay_group <- dep_delay_group
```

---

### 11. Pour `arr_delay - dep_delay`, calculez moyenne, sd, corrélation et effectif par `dep_delay_group`.

**📝 Corrigé**
```r
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
```

> Ce qui renvoie : 

```shell
    dep_delay_group   Moyenne EcartType         Cor      N
            <char>     <num>     <num>       <num>  <int>
1:            <=60 -4.498398  17.03425 0.017268903 234026
2:      >60& <=180 -2.154092  22.17235 0.016243859  16250
3:            >180 -2.044408  25.56483 0.001886009   3040


# A tibble: 3 × 5
  dep_delay_group Moyenne EcartType     Cor      N
  <chr>             <dbl>     <dbl>   <dbl>  <int>
1 <=60              -4.50      17.0 0.0173  234026
2 >180              -2.04      25.6 0.00189   3040
3 >60& <=180        -2.15      22.2 0.0162   16250
```


---

### 12. Trace `arr_delay - dep_delay` vs `dep_delay` coloré par `dep_delay_group` et commentez.

**📝 Corrigé**
```r
colors <- c("#2980b9", "#27ae60", "#c0392b")
names(colors) <- dep_delay_group_name
col <- colors[flights$dep_delay_group]
plot(flights$dep_delay, flights$arr_delay - flights$dep_delay, pch =16, col=col, 
      xlab = "Retard au départ",ylab = "Retard à l’arrivée")
legend("topright", names(colors), col=colors , pch =16)
```

> Commentaire : observer si les retards très importants sont davantage "compensés" ou non ; attention aux valeurs extrêmes et aux NA.

<div align="center"> <img src="/TP/TP5/graphique_q12.png" alt="Graphique Q12" width="600"/> </div>


---


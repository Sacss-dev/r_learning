# Statistique descriptive avec R  
## TP 3

Téléchargez au format CSV l’historique d’un portefeuille investi sur le **SP500** :  
<https://curvo.eu/backtest/fr/indice/sp-500?currency=eur#graphique>.

---

### 1. Importation
Importez les données et mettez la première colonne au format **Date** (1er janvier).  
Spécifiez le type des données à l’importation.


**📝 Corrigé**
```r
data <- fread("chart.csv", encoding="UTF-8", colClasses = c("character","numeric"))
data$Date <- as.Date(paste0("01/", data$Date), format = "%d/%m/%Y")
```
---

### 2. Performance
Ajoutez la colonne **Perf** :  

$$ Perf_t = \frac{SP500_t - SP500_{t-1}}{SP500_{t-1}}, \quad t \geq 2 $$  

Mettez `NA` pour le premier mois.


**📝 Corrigé**
```r
data[, Perf:= c(NA, (`S&P500`[-1] - `S&P500`[-nrow(data)])/ `S&P500`[-nrow(data)])]
```

---

### 3. Histogramme
Affichez l’histogramme des performances.


**📝 Corrigé**
```r
hist(data$Perf, main="Histogramme du S&P500")
```

<br />  
<div align="center"> <img src="/TP/TP3/histogramme_q3.png" alt="Histogramme Q3" width="600"/> </div>
<br /> 
---

### 4. Vecteurs utiles
Créez :  
- `Perf` : vecteur des performances sans la valeur manquante.  
- `batons` : séquence de min arrondi au centième à max arrondi au centième, pas = 0.01.


**📝 Corrigé**
```r
Perf <- data$Perf[-1]

min_perf <- round(min(Perf),2)
max_perf <- round(max(Perf),2)

batons <- seq(min_perf,max_perf, by=0.01)
```
---

### 5. Histogramme détaillé
Affichez l’histogramme avec un pas d’un centième.

**📝 Corrigé**
```r
hist(Perf, breaks=batons, main="Histogramme des Perf du S&P500", col="skyblue")
```

<br />  
<div align="center"> <img src="/TP/TP3/histogramme_q5.png" alt="Histogramme Q5" width="600"/> </div>
<br /> 
---

### 6. Moyenne et écart-type
Calculez la moyenne et l’écart-type des performances.

**📝 Corrigé**
```r
mean_perf <- mean(Perf)
sd_perf <- sd(Perf)
```
---

### 7. Densité gaussienne
Ajoutez sur l’histogramme la densité gaussienne avec moyenne et variance empiriques.  
Utilisez `freq = FALSE`.

**📝 Corrigé**
```r
hist(Perf, breaks=batons, freq=FALSE, main="Histogramme des Perf du S&P500", col="skyblue")
lines(batons, dnorm(batons, mean = mean_perf, sd = sd_perf), col="red", lwd=2)
```

<br />  
<div align="center"> <img src="/TP/TP3/graphique_q7.png" alt="Histogramme Q5" width="600"/> </div>
<br /> 

---

### 8. Densité empirique
Avec `density`, affichez la densité empirique des performances :  

$$ \hat f(x) = \frac{1}{n} \sum_{i=1}^n \frac{1}{h} K\left( \frac{x - x_i}{h} \right), \quad x \in \mathbb{R} $$  

Comparez à la loi normale.

**📝 Corrigé**


```r
dens_perf <- density(Perf)
lines(dens_perf, col="darkblue", lwd=2)
```


<br />  
<div align="center"> <img src="/TP/TP3/graphique_q8.png" alt="Histogramme Q5" width="600"/> </div>
<br /> 
---

### 9. Skewness et Kurtosis
Calculez `skewness` et `kurtosis` et commentez par rapport à la loi normale.

**📝 Corrigé**
```r
library(moments)

# Calcul des indicateurs pour notre loi
sk <- skewness(Perf)
kt <- kurtosis(Perf)

cat("Skewness :", sk, "\n")
cat("Kurtosis :", kt, "\n")

# Comparaison avec la normale
cat("Pour une loi normale : Skewness = 0, Kurtosis = 3\n")

skewness # skewness < 0 : asymétrie à gauche
kurtosis # > 3: queue plus épaisse qu'une gaussienne
```

---

### 10. Test de Jarque-Bera
Définition :  

$$ JB_n = n \left( \frac{S_n^2}{6} + \frac{(K_n - 3)^2}{24} \right) \xrightarrow{n \to +\infty} \chi^2_2 $$  

où $S_n$ est le skewness et $K_n$ le kurtosis.

**📝 Corrigé**
```r
n <- length(Perf)
stat_JB <- n*(skewness**2 / 6 + (kurtosis - 3)**2 / 24)
```

---

### 11. p-valeur
Calculez :  

$$ p = P(\chi^2_2 > JB_n) $$  

et concluez.

**📝 Corrigé**
```r
curve(dchisq(x, df = 2), from = 0, to = 10, col = "red", lwd = 2)

pval <- 1 - pchisq(stat_JB, df = 2)
pval # Très forte preuve pour rejeter H0
```
---

### 12. Fonction R
Mettez le calcul du test dans une fonction R.

**📝 Corrigé**
```r
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
```
---

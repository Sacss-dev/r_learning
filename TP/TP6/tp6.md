# Statistiques descriptives avec R

## TP6

Nous allons travailler sur des données d'assurance du paquet `CASdatasets`


---
### 1. Le paquet est trop volumineux pour être hébergé sur le CRAN.

Installez-le avec le code suivant, puis vérifiez qu’il se charge correctement

**📝 Corrigé**

```r
install.packages("CASdatasets", repos = "https://cas.uqam.ca/pub/", type="source")
library(CASdatasets)
```


---
### 2. Chargez les jeux de données `freMTPLfreq` et `freMTPLsev` avec la fonction `data`

puis convertissez-les en objets `data.table` sans effectuer de copie.
Le premier jeu décrit les polices (caractéristiques + nombre de sinistres).
Le second contient les sinistres individuels.

**📝 Corrigé**

```r 
library(data.table)

data(freMTPLfreq) # Charger les données
data(freMTPLsev)
setDT(freMTPLfreq) # Passer en data table
setDT(freMTPLsev)

class(freMTPLfreq$PolicyID)
class(freMTPLsev$PolicyID) # Problème ici
freMTPLsev$PolicyID = as.factor(freMTPLsev$PolicyID)


View(freMTPLfreq[1:10, ])
```


---
### 3. Pour le jeu `freMTPLfreq`, la colonne `ClaimNb` indique le nombre de sinistres par police.

Affichez le tableau des fréquences pour chaque nombre de sinistres, puis calculez la moyenne et la variance.

**📝 Corrigé**
```r 
table(freMTPLfreq$ClaimNb) # Fréquence empirique
mean(freMTPLfreq$ClaimNb)
var(freMTPLfreq$ClaimNb)
```


---
### 4. La colonne Exposure indique la durée d’observation $`E_i`$

Sous un modèle de Poisson $`N_i \sim \text{Poisson}(\lambda E_i)`$, proposer : 

  - un estimateur $`\hat{\lambda}_1`$ basé sur la _moyenne pondérée_ ;
  - un estimateur $`\hat{\lambda}_2`$ basé sur la _variance_ ;

Concluez (sans test formel), si les données semblent suivre a priori une loi de Poisson.


**📝 Corrigé**
```r
E <- freMTPLfreq$Exposure
N <- freMTPLfreq$ClaimNb

lambda1 <- sum(N) / sum(E)
lambda2 <- sum((N - mean(N))^2) / sum(E)

lambda1
lambda2
```

---

### 5. Fréquences théoriques sous Poisson  
Avec $`\hat{\lambda}_1`$, calculez les fréquences théoriques pour  
$`N_i \in \{0,1,2,3,4\}`$ sous $`N_i \sim P(\hat{\lambda}_1 E_i)`$.  
Stockez-les dans `freq_poisson`.  
Récupérez les fréquences empiriques dans `freq_empirique`.

**📝 Corrigé**
```r
freq_empirique <- table(freMTPLfreq$ClaimNb)

freq_poisson <- rep(0, 5)
for(i in 0:4) {
  freq_poisson[i+1] <- sum(dpois(i, lambda_1 * freMTPLfreq$Exposure))
}

# ou alors :

freq_poisson <- sapply(unique(freMTPLfreq$ClaimNb), function(i) sum(dpois(i, lambda_1 * freMTPLfreq$Exposure)))

plot(log10(freq_poisson), log10(freq_empirique), type = "b")
abline(a = 0, b = 1, col = "red")
```

---

### 6. Représentation graphique des deux fréquences  
Comparez graphiquement `freq_empirique` et `freq_poisson`.  
Commentez les écarts.

**📝 Corrigé**
```r
plot(c(0:4), freq_poisson, log = "y", type="b", pch=16, xlab="", ylab="log10−observations",
     lwd = 2)

lines(c(0:4),freq_empirique, type="b", pch =16, col="blue", lwd = 2)

legend(x = "topright", legend = c("Freq Poisson", "Freq Empi"), col = c("black", "blue"), lty = 1, pch = 16)
```

---

### 7. Indépendance fréquence / sévérité moyenne  
On suppose souvent que :  
- la fréquence \(N_i\),  
- la sévérité moyenne \(S_i / N_i\) (pour \(N_i > 0\))  

sont indépendantes.

Vérifiez empiriquement cette hypothèse en :  
1. agrégeant `freMTPLsev` par `PolicyID` ;  
2. joignant `ClaimNb` via une jointure à gauche ;  
3. calculant \(S_i/N_i\) pour \(N_i > 0\) ;  
4. calculant la corrélation.

**📝 Corrigé**
```r
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
```

---

### 8. Histogramme des coûts des sinistres (ClaimAmount)  
Représentez l’histogramme (100 barres) :  
- sur tout l’échantillon ;  
- tronqué au quantile 99.5% ;  
- tronqué au quantile 95%.

Commentez les particularités (ex. pics).

**📝 Corrigé**
```r

hist(freMTPLsev$ClaimAmount, xlab = "Montant sinistre", breaks = 100, col = "blue")
alpha <- 0.95
hist(freMTPLsev[ClaimAmount < quantile(ClaimAmount, alpha), ClaimAmount],
     xlab = "Montant sinistre", col = "blue", breaks = 100)

# On observe un mode vers 1200

hist(freMTPLsev[(ClaimAmount > 900) & (ClaimAmount < 1500), ClaimAmount],
     xlab = "Montant sinistre", main = "Coûts des sinistres", col = "blue", breaks = 60)

# Sinistres avec franchise standardisée ? E.g. bris de glace

```

---

### 9. Jointure pour analyse de la gravité selon variables explicatives  
Ajoutez les variables de `freMTPLfreq` à `freMTPLsev` via une jointure gauche.  
Convertissez d’abord `PolicyID` en entier dans `freMTPLfreq`.

**📝 Corrigé**
```r
tmp <- freMTPLsev %>%
          left_join(freMTPLfreq %>% select(PolicyID, CarAge , DriverAge), by = "PolicyID")

#tmp <- freMTPLsev[freMTPLfreq[, .(PolicyID, CarAge, DriverAge)], on = "PolicyID"]
```

---

### 10. Matrice de corrélations entre toutes les variables numériques (sauf PolicyID)

**📝 Corrigé**
```r
cor(tmp %>% select(-PolicyID))
cor(tmp %>% filter(ClaimAmount > 30000)%>% select(-PolicyID))
# Corrélation plus importante sur les gros sinistres
```






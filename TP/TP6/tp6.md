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


---
### 5. Work in progress






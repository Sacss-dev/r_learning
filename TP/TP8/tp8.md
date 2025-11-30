# Statistique descriptive avec R — TP 8

Nous allons travailler sur les données **mtcars**, déjà présentes dans R.

---

### 1. Affichez les données et consultez l’aide.  
Pour les 11 colonnes, indiquez si chaque variable est :

- **Quantitative continue**  
- **Quantitative discrète**  
- **Qualitative ordinale**  
- **Qualitative nominale**

**📝 Corrigé**

```r
mtcars
summary(mtcars)
View(mtcars)
?mtcars
```

**Classification des variables :**

| Variable | Signification | Type |
|---------|----------------|------|
| mpg | Miles per gallon | Quantitative continue |
| cyl | Nombre de cylindres | Quantitative discrète |
| disp | Cylindrée (in³) | Quantitative continue |
| hp | Puissance (HP) | Quantitative continue |
| drat | Rapport pont arrière | Quantitative continue |
| wt | Poids (1000 lbs) | Quantitative continue |
| qsec | Temps 1/4 mille | Quantitative continue |
| vs | Type moteur (0 = V, 1 = en ligne) | Qualitative nominale |
| am | Transmission (0 = auto, 1 = manuelle) | Qualitative nominale |
| gear | Nb vitesses | Quantitative discrète |
| carb | Nb carburateurs | Quantitative discrète |

---

### 2. Avec `table` et `prop.table`, affichez fréquences et proportions pour `cyl` et `am`.  
Puis affichez le tableau croisé `cyl`, `am`.

**📝 Corrigé**

```r
table(mtcars$cyl)
prop.table(table(mtcars$cyl))

table_am <- table(mtcars$am)
prob_table_am <- prop.table(table_am)

table(mtcars$cyl , mtcars$am)
prop.table(table(mtcars$cyl , mtcars$am))
```

> Ce qui produit le retour suivant dans la console : 

```shell
> table(mtcars$cyl , mtcars$am)
   
     0  1
  4  3  8
  6  4  3
  8 12  2
> prop.table(table(mtcars$cyl , mtcars$am))
   
          0       1
  4 0.09375 0.25000
  6 0.12500 0.09375
  8 0.37500 0.06250
```
---

### 3. Affichez l’histogramme de la variable quantitative continue `hp`.

**📝 Corrigé**

```r
hist(mtcars$hp , main = "Distribution de la puissance", xlab = "Puissance (chevaux)", col = "cyan")
# Puissance qui va de 50 à 250 chevaux, avec un mode à 130 environ
```


<br />  
<div align="center"> <img src="/TP/TP8/graphique_q3.png" alt="Graphique Q3" width="600"/> </div>
<br />  

---

### 4. Affichez un camembert de la répartition de `am` avec `pie`.  
Labels souhaités : `"Automatique"` pour `0`, `"Manuelle"` pour `1`, et pourcentage affiché.

**📝 Corrigé**

```r
table_am <- table(mtcars$am)
pie(table(mtcars$am),
    clockwise =  TRUE,
    main = "Répartition des types de transmission",
    labels = paste0(c("Automatique ", "Manuelle "),
                    round(100*prop.table(table_am), 1), "%")
)
```


<br />  
<div align="center"> <img src="/TP/TP8/graphique_q4.png" alt="Graphique Q4" width="600"/> </div>
<br />  


---

### 5. Affichez un diagramme en barres (`barplot`) de la variable qualitative `vs`.

**📝 Corrigé**

```r
barplot(table(mtcars$vs), main = "Répartition des types de moteurs",
        ylab = "Nombre de voitures", ylim=c(0,20),
        col = c("#F54927", "#3A2E8F"),
        names.arg = c("En V", "En ligne"))
```

<br />  
<div align="center"> <img src="/TP/TP8/graphique_q5.png" alt="Graphique Q5" width="600"/> </div>
<br />  

---

### 6. Comparer une variable quantitative par groupe qualitatif : boxplot.  
Affichez `mpg` en fonction de `am`.

**📝 Corrigé**

```r
boxplot(mpg ~ am, data = mtcars ,
        main = "Consommation par type de transmission",
        ylab = "Miles par gallon",
        names = c("Automatique", "Manuelle"))
# Attention mpg: distance par litre. Plus c'est élevé, moins on consomme.
# Les boîtes manuelles consomment moins que les boîtes
# automatiques apparemment (on a Q3 auto~18mpg << Q1 manuelle~22mpg)
```

<br />  
<div align="center"> <img src="/TP/TP8/graphique_q6.png" alt="Graphique Q6" width="600"/> </div>
<br />  


---

### 7. Ajouter une variable qualitative ordinale `classehp` à partir de `hp`.  
Classification souhaitée :

| Intervalle hp | classehp |
|---------------|-----------|
| [0, 100[ | "Faible" |
| [100, 200[ | "Moyenne" |
| [200, +∞[ | "Forte" |

**📝 Corrigé**

```r
# En R natif:
mtcars$classe_hp <- "Moyenne"
mtcars$classe_hp[mtcars$hp < 100] <- "Faible"
mtcars$classe_hp[mtcars$hp > 200] <- "Elevée"

# Avec la fonction cut :
mtcars$classe_hp <- cut(mtcars$hp,
                        breaks = c(0, 100, 200, Inf),
                        labels = c("Faible", "Moyenne", "Elevée"),
                        right=FALSE)

# Pour transformer
mtcars$classe_hp <- ordered(mtcars$classe_hp, levels = c("Faible", "Moyenne", "Elevée"))
mtcars$classe_hp
```
> Ce qui renvoie dans la console : 

```shell
> mtcars$classe_hp
 [1] Moyenne Moyenne Faible  Moyenne Moyenne Moyenne Elevée  Faible  Faible  Moyenne
[11] Moyenne Moyenne Moyenne Moyenne Elevée  Elevée  Elevée  Faible  Faible  Faible 
[21] Faible  Moyenne Moyenne Elevée  Moyenne Faible  Faible  Moyenne Elevée  Moyenne
[31] Elevée  Moyenne
Levels: Faible < Moyenne < Elevée
```


---

### 8. Affichez `mpg` en fonction de la nouvelle variable ordinale `classehp`.

**📝 Corrigé**

```r
boxplot(mpg ~ classe_hp, data = mtcars,
        main = "Consommation par classe de puissance",
        ylab = "Miles par gallon", xlab = "Classe HP")
# Plus la puissance est élevée, plus la consommation est élevée.

# Alternative avec ggplot2
library(ggplot2)
ggplot(mtcars, aes(x = classe_hp, y = mpg, fill = classe_hp)) + geom_boxplot()
```

<br />  
<div align="center"> <img src="/TP/TP8/graphique_q8_1.png" alt="Graphique Q8" width="600"/> </div>
<br />  


<br />  
<div align="center"> <img src="/TP/TP8/graphique_q8_2.png" alt="Graphique Q8" width="600"/> </div>
<br />  



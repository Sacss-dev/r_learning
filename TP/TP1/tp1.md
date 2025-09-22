# Statistique descriptive avec R  - TP1

R possède des jeux de données intégrés. Nous allons travailler sur les données **iris**, une  
`data.frame` déjà présente dans R. On rappelle que pour accéder à l’aide d’une fonction, on  
peut utiliser `help(nom_fonction)`.

La fonction `str` appliquée à une `data.frame` permet de voir les noms des colonnes, leurs  
types, et quelques valeurs :

```r
str(iris)
```

On peut avoir une représentation rapide des minimums, maximums, moyennes et quartiles de  
chaque colonne avec :

```r
summary(iris)
```

Pour explorer au-delà d’un affichage dans la console, on peut utiliser :

```r
View(iris)
```

La fonction `tapply` est similaire à l’opération **Group By** de SQL. Elle a la forme  
`tapply(x, y, f)` où `x` est un vecteur de données quantitatives, `y` est un vecteur de modalités  
de même taille, et `f` est une fonction d’agrégation. Ici, `tapply` calcule la fonction `f` sur `x`  
pour chaque modalité de `y`.

Exemple :

```r
tapply(iris$Sepal.Length , iris$Species , mean)
```

---

### 1. Fonction moyenne sans min et max
Calculez la moyenne des valeurs en excluant le minimum et le maximum :  

$$ f(x) = \frac{1}{n-2} \left( \sum_{i=1}^n x_i - \min(x) - \max(x) \right) $$



**📝 Corrigé**
```r
f <- function(x) 
  return((sum(x) - min(x) - max(x))/(length(x)-2))
```
---

### 2. Corrélations
Obtenez la matrice de corrélation des données quantitatives de **iris** (sans la dernière colonne) avec :

```r
cor(iris[ , -5])
```


**📝 Corrigé**
```r
## Exclure la dernière colonne, qui est uniquement qualitative
quant_data = iris[,-ncol(iris)]

## Construire la matrice de corrélation
corr_mat = cor(quant_data)

## Puis l'afficher
print(corr_mat)
```
Ce qui nous donne cette matrice dans la console : 
```txt
              Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length    1.0000000  -0.1175698    0.8717538   0.8179411
Sepal.Width    -0.1175698   1.0000000   -0.4284401  -0.3661259
Petal.Length    0.8717538  -0.4284401    1.0000000   0.9628654
Petal.Width     0.8179411  -0.3661259    0.9628654   1.0000000
```

---

### 3. Scatterplot
Affichez `Petal.Length` en fonction de `Petal.Width`.


**📝 Corrigé**
```r
x <- iris$Petal.Width # Largeur des pétales
y <- iris$Petal.Length # Longueur des pétales
plot(x,y)
```

Ce qui nous donne le premier graphique : **Insérer graphique**

---

### 4. Style de points
Changez le style avec `pch=16` et choisissez une couleur moderne depuis la palette  
<https://flatuicolors.com/palette/defo>.

**📝 Corrigé**
```r
plot(x,y,pch=16,col="#3498db")
```
---

### 5. Étiquettes
Ajoutez :  
- abscisses : `"Largeur des pétales"`  
- ordonnées : `"Longueur des pétales"`  

avec les arguments `xlab` et `ylab` de `plot`.

**📝 Corrigé**
```r
plot(x,y,pch=16,col="#3498db",
     xlab="Largeur des pétales", 
     ylab="Longueur des pétales")
```
---

### 6. Régression linéaire
Faites la régression linéaire de `Petal.Width` en fonction de `Petal.Length`.



**📝 Corrigé**
```r
mes_donnees <- iris[c("Petal.Width", "Petal.Length")]
colnames(mes_donnees)[colnames(mes_donnees)=="Petal.Width"] <- "x"
colnames(mes_donnees)[colnames(mes_donnees)=="Petal.Length"] <- "y"

reg <- lm(y ~ x, data=mes_donnees)
```

---

### 7. Structure
Vérifiez que `reg` est une liste et affichez ses éléments avec :


**📝 Corrigé**
```r
is.list(reg) # Check s'il s'agit d'une liste.

print(names(reg)) # Affiche le nom des éléments
```
Ce qui donne l'affichage suivant dans le terminal : 

```txt
 [1] "coefficients"  "residuals"     "effects"       "rank"          "fitted.values" "assign"        "qr"           
 [8] "df.residual"   "xlevels"       "call"          "terms"         "model"    
```
---

### 8. Droite de régression
Ajoutez la droite de régression avec `abline` avec une épaisseur de 2 et une couleur sombre.

**📝 Corrigé**
```r
abline(reg, col = "#333333", lwd = 2)  # "#333333" = gris très foncé
```
---

### 9. Légende
Ajoutez une légende en haut à gauche avec `legend`.


**📝 Corrigé**
```r
legend("topleft", legend="Jeu de données", pch=1, lwd=2)
```
---

### 10. Couleurs par espèce
Créez un vecteur `couleurs` initialement rempli de la couleur `#16a085`  


**📝 Corrigé**
```r
couleurs = rep("#16a085", nrow(iris))
```
---

### 11. Affectation des couleurs
Remplacez les couleurs dans le vecteur selon l’espèce : 
- "#16a085" pour *setosa*  
- "#c0392b" pour *versicolor*  
- "#8e44ad" pour *virginica*

  
**📝 Corrigé**
```r
versicolor_indice <- iris$Species == "versicolor"

couleurs[versicolor_indice] <- "#c0392b"

virginica_indice <- iris$Species == "virginica"

couleurs[virginica_indice] <- "#8e44ad"
```

---

### 12. Graphique complet
Affichez le graphique final avec couleurs par espèce et légende adaptée.


**📝 Corrigé**

```r
plot(x, y, pch=16, col=couleurs,
     xlab="Largeur des pétales", 
     ylab="Longueur des pétales")

abline(reg, col="#333333", lwd=2)

legend("topleft",
       legend=c("Setosa", "Versicolor", "Virginica", "Régression"),
       col=c("#16a085", "#c0392b", "#8e44ad", "#333333"),
       pch=c(16,16,16,NA),
       lwd=c(NA,NA,NA,2), 
       bg="#C6F5ED"
)
```
---

### 13. Maillage et fond
Ajoutez `grid()` et mettez une couleur de fond à la légende.

**📝 Corrigé**
```r
grid()
```
---

### 14. Export PDF
Enregistrez le graphique au format PDF :

```r
pdf("iris_plot.pdf", width=10, height=7)
plot(...)  # graphique
dev.off()
```

---

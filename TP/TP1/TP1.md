# TP1 - Statistique descriptive avec la dataframe iris

**Question 1.** La fonction $`f`$ qui est ci-dessus `mean` peut aussi être programmée. Calculez la moyenne des valeurs en excluant le minimum et le maximum, c'est-à-dire : 
$`   f(x) = \frac{1}{n-2}\left( \sum_{i=1}^n x_i - \min (x) - \max (x)\right) `$

```r
f <- function(x) 
  return((sum(x) - min(x) - max(x))/(length(x)-2))
```


<br>
<br>


**Question 2.** Pour obtenir la matrice de corrélation des données quantitatives de `iris`, on exclut la dernière colonne et on utilise la fonction `cor`. Affichez la matrice de corrélation des données quantitatives de `iris`.

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

<br>
<br>

**Question 3.** La fonction `plot(x,y)` permet d'afficher `y` en fonction de `x`. Affichez `Petal.Length` en fonction de `Petal.width`.

```r
x = iris$Petal.Width # Largeur des pétales
y = iris$Petal.Length # Longueur des pétales



plot(x,y)
```

Ce qui donne le premier graphique : **Insérer graphique**
<br>
<br>

**Question 4.** Changez de style de point en utilisant l'argument `pch=16`, et choisir une couleur moderne.
```r
plot(x,y,pch=16,col="#3498db")
```


<br>
<br>

**Question 5.** Mettez des étiquettes pour les abscisses et les ordonnées.
```r
plot(x,y,pch=16,col="#3498db",
     xlab="Largeur des pétales", 
     ylab="Longueur des pétales")
```
<br>
<br>


**Question 6.** Pour faire une régression linéaire, on utilise la syntaxe `lm(y ~ x, data=mes_donnees)`. Faites la régression linéaire de `Petal.Width` en fonction de `Petal.Length` et enregistrez-là dans une variable `reg`.
```r
mes_donnees <- iris[c("Petal.Width", "Petal.Length")]
colnames(mes_donnees)[colnames(mes_donnees)=="Petal.Width"] <- "x"
colnames(mes_donnees)[colnames(mes_donnees)=="Petal.Length"] <- "y"

reg <- lm(y ~ x, data=mes_donnees)
```
<br>
<br>

**Question 7.** Vérifiez que c'est une liste et obtenez le nom des éléments avec `names`.
```r
is.list(reg) # Check s'il s'agit d'une liste.

print(names(reg)) # Affiche le nom des éléments
```
<br>
<br>


**Question 8.** Ajoutez la droite de régression avec `abline` avec une épaisseur de 2 et une couleur sombre.
```r
abline(reg, col = "#333333", lwd = 2)  # "#333333" = gris très foncé
```

<br>
<br>


**Question 9.** Ajoutez une légende avec `legend`.
```r
legend("topright", legend="Jeu de données", pch=1, lwd=2)
```

<br>
<br>

**Question 10.** Dans le graphique, les largeurs et longueurs des pétales sont affichées pour toutes les espèces. On souhaite mettre une couleur différente en fonction de l'espèce. Construisez un vecteur `couleurs` de la même longueur que le nombre de lignes des données, avec la valeur constante `#16a085`.
```r
couleurs = rep("#16a085", nrow(iris))
```
<br>
<br>

**Question 11.** Pour les indices où l'espèce est `versicolor`, remplacez la valeur de `couleurs` par `#c0392b`. Faites de même pour `virginica` avec la couleur `#8e44ad`.

```r
versicolor_indice <- iris$Species == "versicolor"

couleurs[versicolor_indice] <- "#c0392b"

virginica_indice <- iris$Species == "virginica"

couleurs[virginica_indice] <- "#8e44ad"
```

<br>
<br>

**Question 12.** Affichez le graphique complet avec les couleurs par espèce, en adaptant la légende.

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

<br>
<br>

**Question 13.** Ajoutez un maillage avec la fonction `grid` et mettez une couleur de fond à votre légende.
```r
grid()
```
**Question 14.** mettre la fonction pdf AVANT l'editing !

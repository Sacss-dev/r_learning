# Révisions en R

--- 

## Les fonctions 

---

  - `tapply(x,cat_group_by,function_x)` : même opération que le `GROUP BY` en SQL pour ensuite appliquer à chaque catégorie la fonction.
      &rarr; Exemple : `tapply(iris$Sepal.Length, iris$Specis, mean)` calcule la moyenne de la longueur des sépales, groupée par espèce.

---


  - `cor(x)` donne une matrice de corrélation pour une dataframe/dataset 
     
     
     &rarr; Exemple : `cor(iris[0,4])` calcule la matrice de corrélation des 5 premières données quantitatives d'`iris`
    > ATTENTION : ne prend en compte que des données quantitatives

    
---

  - `plot(x,y,pch,col,xlab,ylab)` trace `y` en fonction de `x`. Les autres paramètres sont facultatifs :
      - `pch` est le type de point (_point character_ littéralement)
      - `col` est le type de couleur utilisée(s) (peut être un vecteur pour insérer différentes couleurs, cf. exemples)
      - `xlab` est le _label_ des abscisses
      - `ylab` est le _label_ des ordonnées




      &rarr; Exemple 1 : `plot(iris$Petal.Length, iris$Petal.Width, col = "forestgreen",pch=16)` trace `iris$Petal.Width` en fonction de `iris$Petal.Length`.
    
      &rarr; Exemple 2 :
      ```r
      # Création d'un vecteur de couleurs
      couleurs <- rep("#16a085",nrow(iris))
      
      indice_versicolor <- iris$Species == "versicolor"
      indice_virginica <- iris$Species == "virginica"
      
      couleurs[indice_versicolor] <- "#c0392b"
      couleurs[indice_virginica] <- "#8e44ad"
      
      # Tracé avec différentes couleurs
      
      plot(mes_donnees$x, mes_donnees$y, col = couleurs,pch=16, xlab="Largeur des pétales", ylab = "Longueur des pétales")
      ```

--- 


  - `lm(y~x, data)` construit une régression linéaire où : 
      - `data` est la _data.frame_ qui contient les données
      - `x` est le nom de la colonne de la variable explicative
      - `y` est le nom de la colonne de la variable à expliquer

      &rarr; Exemple : `reg <- lm(y ~ x, data=mes_donnees)` effectue cette tâche et affecte la valeur à la variable `reg`, avec `mes_donnees` comme la data.frame qui nous intéresse.

      > Attention : bien faire attention aux noms des variables `y` et `x`. Il faut que ces noms de colonnes apparaissent dans la _data.frame_ !


---
  - `legend(position,legend,pch,lwd,bg)` configure la légende sur le graphique, où :
      - `position` indique la position de la légende sur le graphique, généralement : `topleft`, `topright`, `bottomleft`, `bottomright`
      - `legend` est le titre de la légende (peut être un vecteur, cf. exemples ci-dessous)
      - `pch` est le type de point (peut être un vecteur)
      - `lwd` est l'épaisseur du trait (peut être un vecteur)
      - `bg` est la couleur du _background_

    &rarr; Exemple 1 : `legend("topleft", legend="Jeu de données", pch=1,lwd=2)` ajoute une légende en haut à gauche avec les paramètres ci-contre.

    &rarr; Exemple 2 :
    ```r
    # Exemple vectorisé
    noms_legendes <- colnames(mes_donnees)[-1]
    couleurs_legendes <- c("#c0392b","#bdc3c7","#f39c12","#2980b9","#2c3e50")
    
    legend("topleft",
      legend=noms_legendes,
      lty=1,lwd=2,
      col=couleurs_legendes,
      bg = "#ecf0f1")
    ```

---
  - `grid()` affiche la grille sur le graphique

--- 
  - `rep(value, longueur)` crée un vecteur de longueur `longueur` avec `value` à chaque indice.
    
    &rarr; Exemple : `rep("red",5)` crée un vecteur de `"red"` de longueur 5.

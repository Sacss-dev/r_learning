# Révisions R - Mémo






## Sommaire

  - [barplot](#barplot)
  - [colMeans](#colmeans)
  - [colnames](#colnames)
  - [cor](#cor)
  - [data](#data)
  - [density](#density)
  - [fread](#fread)
  - [file.exists](#fileexists)
  - [grid](#grid)
  - [hist](#hist)
  - [lines](#lines)
  - [lm](#lm)
  - [legend](#legend)
  - [matplot](#matplot)
  - [mean(x), sd(x)](#mean-sd)
  - [nchar](#nchar)
  - [order](#order)
  - [paste](#paste)
  - [paste0](#paste0)
  - [pairs](#pairs)
  - [par](#par)
  - [pie](#pie)
  - [plot](#plot)
  - [prop.table](#proptable)
  - [read.csv](#readcsv)
  - [rep](#rep)
  - [round](#round)
  - [rainbow](#rainbow)
  - [rowSums](#rowsums)
  - [sapply](#sapply)
  - [seq](#seq)
  - [system.time](#systemtime)
  - [subset](#subset)
  - [tapply](#tapply)
  - [trimws](#trimws)


## Les fonctions
  <a name="barplot"></a>
  - `barplot(x, names.arg, col, main, xlab, ylab)` crée un diagramme en barres
        &rarr; Exemple : `barplot(table(iris$Species), col="steelblue", main="Répartition des espèces")`

  --- 

  <a name="colmeans"></a>
  - `colMeans(x)` calcule la moyenne de chaque colonne d'une matrice ou data.frame
        &rarr; Exemple : `colMeans(iris[,1:4])` calcule les moyennes des colonnes numériques

  ---
  <a name="colnames"></a>
  - `colnames(x)` retourne les noms des colonnes d'une matrice ou data.frame
        &rarr; Exemple : `colnames(iris)` affiche les noms des colonnes

  ---
  <a name="cor"></a>
  - `cor(x)` donne une matrice de corrélation pour une dataframe/dataset 
       
       
       &rarr; Exemple : `cor(iris[0,4])` calcule la matrice de corrélation des 5 premières données quantitatives d'`iris`
      > ATTENTION : ne prend en compte que des données quantitatives

      
  ---

  <a name="data"></a>
  - `data(name)` charge un dataset pré-chargé dans R
        &rarr; Exemple : `data(iris)` charge le dataset iris

  ---
  <a name="density"></a>
   - `density(x, bw, adjust, kernel, trim, from, to)` calcule la densité de probabilité d'un vecteur `x`, où :
        - `x` est le vecteur de données pour lequel on souhaite estimer la densité
        - `bw` spécifie la méthode de sélection de la largeur de bande (bandwidth)
        - `adjust` permet d'ajuster la largeur de bande
        - `kernel` définit le type de noyau à utiliser (par exemple, "gaussian", "epanechnikov", etc.)
        - `trim` indique si l'on doit tronquer les valeurs en dehors de l'intervalle
        - `from` et `to` définissent l'intervalle sur lequel la densité est estimée
        &rarr; Exemple :

      ```r
      dens_perf <- density(Perf)
      lines(dens_perf, col="darkblue", lwd=2)
      ```



  ---
  <a name="fread"></a>
  - `fread(file_name, encoding, colClasses)` fait la même chose que `read.csv` mais est plus intelligente (elle n'a pas besoin qu'on lui tienne la main en lui précisant le séparateur etc…) 
     
      &rarr; Exemple：
      ```r
      data <- fread("data.csv", 
          encoding="UTF-8", 
          colClasses = c("numeric","character")
      )
      ```

  ---
  <a name="fileexists"></a>
  - `file.exists(filename)` vérifie si un fichier existe

        &rarr; Exemple : `file.exists("data.csv")` retourne TRUE ou FALSE

  ---
  <a name="grid"></a>
  - `grid()` affiche la grille sur le graphique

  --- 
  <a name="hist"></a>
  - `hist(data, col,main,seq,freq)` crée un histogramme avec : 
      - `data` est le jeu de données à afficher
      - `col` est la couleur des batons sur le graphique
      - `main` est le titre du graphique
      - `seq` est l'espacement des batons (réguliers ou non)
      - `freq` pour savoir si oui ou non on veut comparer l'histogramme à des densités (typiquement des densités gaussiennes).

    &rarr; Exemple : 
      ```r
      Perf <- data$Perf[-1]

      min_val <- round(min(Perf),2)
      max_val <- round(max(Perf),2)
      batons <- seq(min_val,max_val,by=0.01) # Ici le pas est régulier

      hist(Perf, batons, col="skyblue", main="Histogramme du S&P500")
      ```

  ---

  <a name="lines"></a>
  - `lines(x, y, col, lwd, lty)` ajoute des lignes sur un graphique déjà tracé :
      - `x`, `y` : coordonnées des points à relier
      - `col` : couleur
      - `lwd` : épaisseur du trait
      - `lty` : style du trait
      &rarr; Exemple：
      ```r
      plot(x, y, type = "n")         # crée la fenêtre sans tracer les points
      lines(x, y, col = "red", lwd = 2)
      ```



  --- 

  <a name="lm"></a>
  - `lm(y~x, data)` construit une régression linéaire où : 
        - `data` est la _data.frame_ qui contient les données
        - `x` est le nom de la colonne de la variable explicative
        - `y` est le nom de la colonne de la variable à expliquer

      &rarr; Exemple : `reg <- lm(y ~ x, data=mes_donnees)` effectue cette tâche et affecte la valeur à la variable `reg`, avec `mes_donnees` comme la data.frame qui nous intéresse.

      > Attention : bien faire attention aux noms des variables `y` et `x`. Il faut que ces noms de colonnes apparaissent dans la _data.frame_ !


  ---
  <a name="legend"></a>
  - `legend(position,legend,pch,lwd,bg)` configure la légende sur le graphique, où :
      - `position` indique la position de la légende sur le graphique, généralement : `topleft`, `topright`, `bottomleft`, `bottomright`
      - `legend` est le titre de la légende (peut être un vecteur, cf. exemples ci-dessous)
      - `pch` est le type de point (peut être un vecteur)
      - `lwd` est l'épaisseur du trait (peut être un vecteur)
      - `bg` est la couleur du _background_

      &rarr; Exemple 1 : `legend("topleft", legend="Jeu de données", pch=1,lwd=2)` ajoute une légende en haut à gauche avec les paramètres ci-contre.

      &rarr; Exemple 2：
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
  <a name="matplot"></a>
  - `matplot(x, y, type, pch, col, lty, lwd, xlab, ylab, main, ylim)` affiche plusieurs fonctions (chaque colonne de `y` est considérée comme une fonction de `x`) :
      - `x` : vecteur des abscisses (ou NULL pour utiliser l'indice des lignes)
      - `y` : matrice ou data.frame (chaque colonne devient une fonction à dessiner)
      - `type`, `col`, `lty`, `lwd` : apparence des courbes
      - `xlab`, `ylab`, `main`, `ylim` : étiquettes, titre et limites d'axe

        &rarr; Exemple : affichage de trois fonctions différentes
        ```r
        # Création des données
        x <- seq(0, 2*pi, length.out = 200)
        f1 <- sin(x)
        f2 <- sin(2*x) / 2
        f3 <- (cos(x))^2
        Fonctions <- cbind(f1, f2, f3)

        # Tracé de plusieurs fonctions en une seule commande
        matplot(x, Fonctions, type = "l", lty = 1, lwd = 2,
              col = c("steelblue", "tomato", "darkgreen"),
              xlab = "x", ylab = "f(x)", main = "Exemples de fonctions")

        legend("topright", legend = c("sin(x)", "sin(2x)/2", "cos^2(x)"),
                col = c("steelblue","tomato","darkgreen"), lty = 1, lwd = 2)
        ```

        > Différence avec `plot` : `matplot` est très pratique pour dessiner simultanément plusieurs colonnes d'une matrice/data frame, cela évite d'appeler plusieurs fois `plot` et `lines` en gros.
            
  --- 
  <a name="mean-sd"></a>
  - `mean(x)`, `sd(x)` permettent de calculer la moyenne et l'écart-type de `x`

  --- 

  <a name="nchar"></a>
  - `nchar(x)` retourne la longueur de chaque chaîne de caractères

      &rarr; Exemple : `nchar("hello")` retourne 5

  ---
  <a name="order"></a>
  - `order(x)` donne une permutation des indices dans la version triée de `x`
    &rarr; Mézalor, cela permet de réindexer les vecteurs en une version triée : 
      ```r
      x <- c(2,1,3)

      x <- x[order(x)] # x devient triée !
      ```

      &rarr; On remarquera que l'on peut trier des datasets etc…  _selon une seule colonne_ : 
      ```r
      data <- data[order(Mois), ] # on trie les données selon l'ordre chronologique
      ```

  --- 

  <a name="paste"></a>
  - `paste(x, y, sep, collapse)` concatène des chaînes de caractères, où :
      - `x`, `y` sont les chaînes à concaténer (peuvent être des vecteurs)
      - `sep` précise le séparateur entre les éléments, par défaut `" "`
      - `collapse` concatène les résultats avec ce séparateur si on travaille avec des vecteurs

        &rarr; Exemple :
        ```r
        paste("Bonjour", "monde", sep = " ")  # retourne "Bonjour monde"
        paste(c("a", "b", "c"), collapse = "-")  # retourne "a-b-c"
        ```

  ---

  <a name="paste0"></a>
  - `paste0(x, y)` concatène des chaînes de caractères __sans séparateur__ (équivalent à `paste(x, y, sep="")`), où :
      - `x`, `y` sont les chaînes à concaténer (peuvent être des vecteurs)
      - `collapse` concatène les résultats avec ce séparateur si on travaille avec des vecteurs

      &rarr; Exemple :
      ```r
      paste0("Bonjour", "monde")  # retourne "Bonjourmonde"
      paste0(c("a", "b", "c"), collapse = "-")  # retourne "a-b-c"
      ```


  ---
  <a name="pairs"></a>
  - `pairs(x)` crée une matrice de nuages de points pour explorer les corrélations entre variables

      &rarr; Exemple : `pairs(iris[,1:4])` affiche tous les croisements possibles

  ---
  <a name="par"></a>
  - `par(mfrow, mar)` configure les paramètres graphiques, où :
      - `mfrow` divise la fenêtre en plusieurs sous-graphiques (ex: `c(2,2)` pour 2×2)
      - `mar` définit les marges du graphique

      &rarr; Exemple : `par(mfrow=c(2,2))` crée une grille de 4 graphiques

  ---
  <a name="pie"></a>
  - `pie(x, labels, col)` crée un diagramme circulaire

      &rarr; Exemple : `pie(c(30,40,30), labels=c("A","B","C"), col=rainbow(3))`

  ---
  <a name="plot"></a>
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


  <a name="proptable"></a>
  - `prop.table(x)` convertit un tableau en proportions (pourcentages)

      &rarr; Exemple : `prop.table(table(iris$Species))` affiche les proportions de chaque espèce

  ---
  <a name="readcsv"></a>
  - `read.csv(file_name,header,sep,encoding,colClasses)` lit le contenu d'un fichier `.csv` (un tableur quoi), où : 
      - `file_name` est le nom du fichier 
      - `header` précise si oui ou non on a une ligne d'entête (avec le nom des colonnes par exemple) 
      - `sep` précise le séparateur, généralement `,` ou `;` 
      - `encoding` précise l'encodage du fichier, généralement `"UTF-8"`
      - `colClasses` précise le type de chaque colonne

      &rarr; Exemple : 
      ```r
      data <- read.csv("data.csv", 
           header = TRUE, 
           sep = ",",
           encoding = "UTF-8",
           colClasses = c("numeric","character")
      )
      ```


  --- 

  <a name="rep"></a>
  - `rep(value, longueur)` crée un vecteur de longueur `longueur` avec `value` à chaque indice.
      
      &rarr; Exemple : `rep("red",5)` crée un vecteur de `"red"` de longueur 5.

  --- 
  <a name="round"></a>
  - `round(number,number_digits)` fournit une approximation de `number` avec `number_digits` chiffres après la virgule
    &rarr; Exemple : `round(2.555555,2)` renvoie `2.56`

  --- 
  <a name="rainbow"></a>
  - `rainbow(n)` crée un vecteur de n couleurs de l'arc-en-ciel

      &rarr; Exemple : `plot(1:10, col=rainbow(10))` trace 10 points avec des couleurs différentes

  ---
  <a name="rowsums"></a>
  - `rowSums(x)` calcule la somme de chaque ligne d'une matrice ou data.frame

      &rarr; Exemple : `rowSums(iris[,1:4])` somme les valeurs par ligne

  ---
  <a name="sapply"></a>
  - `sapply(x, function)` applique une fonction à chaque élément et simplifie le résultat

      &rarr; Exemple : `sapply(iris, class)` retourne le type de chaque colonne

  ---
  <a name="seq"></a>
  - `seq(start,end,by)` crée un vecteur comprenant les nombres de `start` à `end` avec un pas régulier de `by`.
    &rarr; Exemple : `seq(1,3,1)` renvoie le vecteur `1 2 3`

  --- 
  <a name="systemtime"></a>
  - `system.time(expr)` mesure le temps d'exécution d'une expression

      &rarr; Exemple : `system.time(sum(1:1000000))` affiche le temps écoulé

  ---
  <a name="subset"></a>
  - `subset(x, condition)` extrait un sous-ensemble de données selon une condition spécifiée :
      - `x` est le vecteur ou la data.frame à filtrer
      - `condition` est la condition logique à appliquer

      &rarr; Exemple : `subset(iris, Species == "setosa")` retourne les lignes d'iris où l'espèce est "setosa"

  ---
  <a name="tapply"></a>
  - `tapply(x,cat_group_by,function_x)` : même opération que le `GROUP BY` en SQL pour ensuite appliquer à chaque catégorie la fonction.
        &rarr; Exemple : `tapply(iris$Sepal.Length, iris$Specis, mean)` calcule la moyenne de la longueur des sépales, groupée par espèce.

  ---


  <a name="trimws"></a>
  - `trimws(x)` enlève les espaces inutiles (en début ou en fin de mot) pour chaque chaîne de caractères contenue dans `x`.

      &rarr; Exemple： 
      ```r
      data$name_country <- trimws(data$name_country) # Enlève les espaces inutiles dans les noms de chaque pays
      ```

      > Ça sauve bien des situations !

  ---




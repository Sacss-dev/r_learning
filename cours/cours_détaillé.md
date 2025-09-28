# Langage R - Cours complet

## Table des matières
- [Introduction](#introduction)
- [Premiers pas](#premiers-pas)
- [Les conditionnelles](#les-conditionnelles)
- [Les boucles](#les-boucles)
- [Les fonctions](#les-fonctions)
- [Les variables](#les-variables)
- [Les objets](#les-objets)
- [Fonctions usuelles](#fonctions-usuelles)
- [Programmation efficace](#programmation-efficace)
- [Simulation de variables aléatoires](#simulation-de-variables-aléatoires)
- [Exercices](#exercices)

---

## Introduction
- **R** est un langage interprété et vectoriel, orienté statistiques et probabilités.  
- Téléchargement : [CRAN](https://cran.r-project.org/)  
- Outils : `Rgui`, `RStudio`, `RCode`.  
- Exécution de scripts, gestion de projets, encodage en UTF-8.

---

## Premiers pas

### Opérations simples
```r
5 + 7        # 12
TRUE         # booléen
1 + (1+1/2*(1+1/3))  # approx exp(1)
```

### Affectations
```r
x = 3
y <- 4   # recommandé
(z <- x^y)  # 81
```

### Types de variables
```r
typeof("R")      # "character"
typeof(TRUE)     # "logical"
typeof(pi)       # "double"
typeof(5)        # "double"
```

---

## Les conditionnelles

### Booléens et opérateurs
- `&&` : ET logique  
- `||` : OU logique  
- `!`  : NON logique

```r
TRUE && FALSE   # FALSE
TRUE || FALSE   # TRUE
!TRUE           # FALSE
```

### If / else
```r
x <- 7
if (x %% 2 == 1) {
  cat("x est impair\n")
} else {
  cat("x est pair\n")
}
```

---

## Les boucles

### Boucle for
```r
for (i in 1:5) {
  cat(paste0("Itération i = ", i, "\n"))
}
```

### Boucle while
```r
i <- 1
while (i <= 5) {
  print(i)
  i <- i + 1
}
```

---

## Les fonctions
```r
mafonction <- function(x, y) {
  return(x + y)
}
mafonction(2,3)   # 5
```

Exemple : décomposition en nombres premiers.
```r
premiers <- function(n) {
  i <- 2
  while(n != 1) {
    if(n %% i == 0) {
      cat(paste0(i, " "))
      n <- n %/% i
    } else i <- i + 1
  }
  cat("\n")
}
premiers(123456789)  # 3 3 3607 3803
```

---

## Les variables

### Numériques
```r
x <- 2
typeof(x)   # "double"
x <- 1L
typeof(x)   # "integer"
```

### Booléens
```r
typeof(TRUE)  # "logical"
NA            # valeur manquante
```

### Chaînes
```r
s <- "R"
toupper(s)   # "R"
substr(s,1,1) # "R"
```

### Dates
```r
d <- as.Date("29/02/2000", "%d/%m/%Y")
Sys.Date()
```

---

## Les objets

### Vecteur
```r
x <- c(1,3,7)
length(x)   # 3
rep(5,3)    # 5 5 5
seq(0,1,0.2)
```

### Matrice
```r
M <- matrix(1:9, 3, 3)
M[2,3]   # 8
t(M)     # transposée
M %*% t(M) # produit matriciel
```

### Data.frame
```r
df <- data.frame(Prenom=c("Alice","Bob"), Age=c(23,30))
str(df)
```

### Listes
```r
l <- list(a=TRUE, b=1:3)
l$a
l[[2]]
```

---

## Fonctions usuelles
- `sum(x)` : somme  
- `mean(x)` : moyenne  
- `var(x)` : variance  
- `sort(x)` : tri  
- `which.min(x)` : indice du minimum  
- `which.max(x)` : indice du maximum  

---

## Programmation efficace
- R est vectoriel → éviter les boucles quand possible.  
- Exemple :
```r
x <- 1:10
y <- x^2    # vectorisé
```

---

## Simulation de variables aléatoires

### Générateur aléatoire
```r
set.seed(123)
runif(5, 0, 1)
```

### Quatre fonctions associées à une loi
- `dnom` : densité  
- `pnom` : répartition  
- `qnom` : quantile  
- `rnom` : simulation  

Exemple loi normale :
```r
rnorm(5, mean=0, sd=1)
pnorm(0)  # 0.5
```

### Exemples de lois
- Uniforme : `runif(n,a,b)`  
- Binomiale : `rbinom(n,m,p)`  
- Poisson : `rpois(n,lambda)`  
- Normale : `rnorm(n,mu,sigma)`  

---

## Exercices
- Factorielle  
- Constante d’Euler  
- Suite de Fibonacci  
- Simulation Monte-Carlo de π  
- Vérification du TCL  

---

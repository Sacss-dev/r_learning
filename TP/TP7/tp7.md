# Statistique descriptive avec R — TP 7

Nous allons travailler sur les données de population des communes de France (millésime 2022, France hors Mayotte).

---

### 1. Téléchargement des données INSEE  
Rendez-vous sur la page officielle de l’Insee et téléchargez :  
**Évolution et structure de la population en 2022 - Commune - France hors Mayotte** (formats `.xlsx` et `.csv`).  
Avec l’Excel, vérifiez le nom des colonnes et identifiez celles qui correspondent au code géographique et aux effectifs (total + tranches d’âge).

**📝 Corrigé (exemple d’indication)**  
Les colonnes retenues (exemple standard) :  
```r
noms_col <- c("CODGEO", "P22_POP", "P22_POP0014", 
    "P22_POP1529", "P22_POP3044", "P22_POP4559", 
    "P22_POP6074", "P22_POP7589", "P22_POP90P")
```

---

### 2. Importer uniquement les colonnes utiles avec `data.table`  
Importez le `.csv` en sélectionnant seulement les colonnes souhaitées et nommez l’objet `Pop`.

**📝 Corrigé**
```r
library(data.table)
pop <- fread("base-cc-evol-struct-pop-2022.CSV", select = noms_col, encoding="UTF-8")

# Vérification que le chargement s'est bien déroulé
View(pop[1:10, ])
summary(pop)
```

---

### 3. Récupérer les infos communes / départements depuis data.gouv  
Téléchargez `communes-departement-region.csv` depuis data.gouv et importez-le en `Info`.

**📝 Corrigé**
```r
info <- fread(file = "20230823-communes-departement-region.csv", encoding="UTF-8")

# Inspecter les noms de colonnes
names(info)
head(info)
```

---

### 4. Détecter et corriger l’anomalie entre CODGEO et code_commune_INSEE  
Les deux colonnes représentent le même code INSEE de commune : identifiez les incohérences (espaces, zéros non significatifs, formats différents) et corrigez-les.

**📝 Corrigé**
```r
missing_0 <- nchar(info$code_commune_INSEE) == 4
info$code_commune_INSEE[missing_0] <- paste0("0", info$code_commune_INSEE[missing_0])

colnames(info)[1] <- "CODGEO"
#library(dplyr)
#info <- info %>% dplyr::rename(CODGEO = code_commune_INSEE)

missing_0 <- nchar(info$code_departement) == 1
info$code_departement[missing_0] <- paste0("0", info$code_departement[missing_0])
```

---

### 5. Enrichir `pop` avec 3 colonnes d’`info` (DEP, LAT, LONG) via jointure gauche  
Ajoutez `code_departement`, `latitude`, `longitude` de `info` dans `pop`, renommées `DEP`, `LAT`, `LONG`.

**📝 Corrigé**
```r
pop[info, on = "CODGEO", c("DEP", "LAT", "LONG") := .(code_departement, latitude, longitude)]
```

---

### 6. Communes sans département trouvé : sont-elles négligeables ?  
Pour les lignes où `DEP` est `NA`, affichez la taille de la population et le code géo ; examinez l’importance démographique.

**📝 Corrigé**
```r
View(pop[is.na(pop$DEP), ])
pop[is.na(DEP), CODGEO] # Il y a Marseille et Paris notamment
pop$P22_POP[is.na(pop$DEP)]
pop[is.na(DEP), P22_POP] # ou alors
# Population non négligeable évidemment
```

> Interprétation : si la somme des populations manquantes est très faible comparée à la population totale, elles sont négligeables ; sinon il faut investiguer pourquoi les clés n’ont pas matché.

---

### 7. Ajout manuel des codes départements pour Paris, Marseille, Lyon  
Pour Paris, Marseille et Lyon, complétez `DEP` à la main si nécessaire.

**📝 Corrigé**
```r
# pop$DEP[pop$CODGEO == "13055"] <- "13"
# pop$DEP[pop$CODGEO == "69123"] <- "69"
# pop$DEP[pop$CODGEO == "75056"] <- "75"
pop$P22_POP[pop$CODGEO == "13055"]
pop$P22_POP[pop$CODGEO == "69123"]
pop$P22_POP[pop$CODGEO == "75056"]
```

> Commentaire : j'ai l'impression qu'il y a une erreur dans l'énoncé Q7 et Q8 -> en effet 75056 correspond déjà à l'intégralité de la population parisienne que l'on obtient en sommant sur les DEP 75 (vous verrez que cela coïncide dans le corrigé). Du coup en mettant le DEP de 75056 à 75, on double effectivement la population du département...


---

### 8. Nombre d’habitants par département (Pop_Dep)  
Agrégerez `P22_POP` par `DEP`, en supprimant les `NA` résiduels.

**📝 Corrigé**
```r
#pop <- pop[!is.na(DEP)] #On filtre les NAs
pop_dep <- pop[!is.na(DEP), .(POP_DEP = sum(P22_POP, na.rm = T)), by = DEP]
pop_dep <- pop_dep[order(-POP_DEP)]
# Apparemment c'est le Nord le dép le plus peuplé
# Juste devant Paris. Etonnant !
# Enfin on remarque bien que 
pop$P22_POP[pop$CODGEO == "75056"]
pop_dep$POP_DEP[2]
# Coincident.
```

---

### 9. Affichage de la carte des départements (package `geodata`)  
Installer / charger `geodata`, récupérer la carte des départements (level = 2) et tracer un test.

**📝 Corrigé**
```r
library(geodata)

fr <- gadm(country = "FRA", level = 2, path = tempdir())
fr$CC_2
couleurs <- rainbow(length(fr))
plot(fr, col = couleurs, border = "white", lwd = 0.6)
```

<br />  
<div align="center"> <img src="/TP/TP7/graphique_q9.png" alt="Graphique Q9" width="600"/> </div>
<br />  

---

### 10. Construire un vecteur de couleurs linéaires entre deux couleurs RGB  
On veut une couleur par département proportionnelle à la population `POP_DEP`.  
Couleur naissance `col_0 = c(236, 240, 241)` (population nulle) → couleur maxi `col_max = c(44, 62, 80)` (population max).

**📝 Corrigé**
```r
MaxPop <- max(pop_dep$POP_DEP)
col_0 <- c(236, 240, 241)
col_max <- c(44, 62, 80)
pop_dep$couleurs <- rgb(
  col_0[1] + (col_max[1] - col_0[1]) * pop_dep$POP_DEP / MaxPop,
  col_0[2] + (col_max[2] - col_0[2]) * pop_dep$POP_DEP/ MaxPop,
  col_0[3] + (col_max[3] - col_0[3]) * pop_dep$POP_DEP/ MaxPop, maxColorValue = 255)
```

---

### 11. Afficher la carte colorée par population départementale  
Tracer la carte `fr` en utilisant `cols_map` alignées sur les départements.

**📝 Corrigé**
```r
FR_DEP <- data.table(DEP=fr$CC_2)
FR_DEP[pop_dep , on="DEP", couleurs:=couleurs]
plot(fr, col = FR_DEP$couleurs , border = "white", lwd = 0.6)
```

<br />  
<div align="center"> <img src="/TP/TP7/graphique_q11.png" alt="Graphique Q11" width="600"/> </div>
<br />  



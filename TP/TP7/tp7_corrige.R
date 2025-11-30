rm(list = objects())
graphics.off()

#%% Question 1 %%#
noms_col <- c("CODGEO", "P22_POP", "P22_POP0014", "P22_POP1529", "P22_POP3044", "P22_POP4559", "P22_POP6074", "P22_POP7589", "P22_POP90P")

#%% Question 2 %%#
library(data.table)
pop <- fread("base-cc-evol-struct-pop-2022.CSV", select = noms_col, encoding="UTF-8")

# Vérification que le chargement s'est bien déroulé
View(pop[1:10, ])
summary(pop)

#%% Question 3 %%#
info <- fread(file = "20230823-communes-departement-region.csv", encoding="UTF-8")

#%% Question 4 %%#
missing_0 <- nchar(info$code_commune_INSEE) == 4
info$code_commune_INSEE[missing_0] <- paste0("0", info$code_commune_INSEE[missing_0])

colnames(info)[1] <- "CODGEO"
#library(dplyr)
#info <- info %>% dplyr::rename(CODGEO = code_commune_INSEE)

missing_0 <- nchar(info$code_departement) == 1
info$code_departement[missing_0] <- paste0("0", info$code_departement[missing_0])

#%% Question 5 %%
pop[info, on = "CODGEO", c("DEP", "LAT", "LONG") := .(code_departement, latitude, longitude)]

#%% Question 6 %%#
View(pop[is.na(pop$DEP), ])
pop[is.na(DEP), CODGEO] # Il y a Marseille et Paris notamment
pop$P22_POP[is.na(pop$DEP)]
pop[is.na(DEP), P22_POP] # ou alors
# Population non négligeable évidemment

#%% Question 7 %%#
# pop$DEP[pop$CODGEO == "13055"] <- "13"
# pop$DEP[pop$CODGEO == "69123"] <- "69"
# pop$DEP[pop$CODGEO == "75056"] <- "75"
pop$P22_POP[pop$CODGEO == "13055"]
pop$P22_POP[pop$CODGEO == "69123"]
pop$P22_POP[pop$CODGEO == "75056"]

#%% Question 8 %%#
#pop <- pop[!is.na(DEP)] #On filtre les NAs
pop_dep <- pop[!is.na(DEP), .(POP_DEP = sum(P22_POP, na.rm = T)), by = DEP]
pop_dep <- pop_dep[order(-POP_DEP)]
# Apparemment c'est le Nord le dép le plus peuplé
# Juste devant Paris. Etonnant !
# Enfin on remarque bien que 
pop$P22_POP[pop$CODGEO == "75056"]
pop_dep$POP_DEP[2]
# Coincident.

#%% Question 9 %%#
library(geodata)

fr <- gadm(country = "FRA", level = 2, path = tempdir())
fr$CC_2
couleurs <- rainbow(length(fr))
plot(fr, col = couleurs, border = "white", lwd = 0.6)

#%% Question 10 %%#
MaxPop <- max(pop_dep$POP_DEP)
col_0 <- c(236, 240, 241)
col_max <- c(44, 62, 80)
pop_dep$couleurs <- rgb(
  col_0[1] + (col_max[1] - col_0[1]) * pop_dep$POP_DEP / MaxPop,
  col_0[2] + (col_max[2] - col_0[2]) * pop_dep$POP_DEP/ MaxPop,
  col_0[3] + (col_max[3] - col_0[3]) * pop_dep$POP_DEP/ MaxPop, maxColorValue = 255)

#%% Question 11 %%#
FR_DEP <- data.table(DEP=fr$CC_2)
FR_DEP[pop_dep , on="DEP", couleurs:=couleurs]
plot(fr, col = FR_DEP$couleurs , border = "white", lwd = 0.6)

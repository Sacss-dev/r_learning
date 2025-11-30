rm(list = objects())
graphics.off()

?mtcars # Description des données

#%% Question 1 %%#
summary(mtcars)
View(mtcars)

#%% Question 2 %%#
table(mtcars$cyl)
prop.table(table(mtcars$cyl))

table_am <- table(mtcars$am)
prob_table_am <- prop.table(table_am)

table(mtcars$cyl , mtcars$am)
prop.table(table(mtcars$cyl , mtcars$am))

#%% Question 3 %%#
hist(mtcars$hp , main = "Distribution de la puissance", xlab = "Puissance (chevaux)", col = "cyan")
# Puissance qui va de 50 à 250 chevaux, avec un mode à 130 environ

#%% Question 4 %%#
table_am <- table(mtcars$am)
pie(table(mtcars$am),
    clockwise =  TRUE,
    main = "Répartition des types de transmission",
    labels = paste0(c("Automatique ", "Manuelle "),
                    round(100*prop.table(table_am), 1), "%")
)
# Alternative: library(glue)

#%% Question 5 %%#
barplot(table(mtcars$vs), main = "Répartition des types de moteurs",
        ylab = "Nombre de voitures", ylim=c(0,20),
        col = c("#F54927", "#3A2E8F"),
        names.arg = c("En V", "En ligne"))

#%% Question 6 %%#
boxplot(mpg ~ am, data = mtcars ,
        main = "Consommation par type de transmission",
        ylab = "Miles par gallon",
        names = c("Automatique", "Manuelle"))
# Attention mpg: distance par litre. Plus c'est élevé, moins on consomme.
# Les boîtes manuelles consomment moins que les boîtes
# automatiques apparemment (on a Q3 auto~18mpg << Q1 manuelle~22mpg)

#%% Question 7 %%#
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

#%% Question 8 %%#
boxplot(mpg ~ classe_hp, data = mtcars,
        main = "Consommation par classe de puissance",
        ylab = "Miles par gallon", xlab = "Classe HP")
# Plus la puissance est élevée, plus la consommation est élevée.

# Alternative avec ggplot2
library(ggplot2)
ggplot(mtcars, aes(x = classe_hp, y = mpg, fill = classe_hp)) + geom_boxplot()
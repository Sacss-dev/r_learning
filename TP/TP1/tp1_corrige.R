rm(list = objects())
graphics.off()

?tapply
tapply(iris$Sepal.Length , iris$Species , mean)

#%% Question 1 %%#
# R est un langage vectorisé, on évite les boucles for
f <- function(x) {
  y <- (sum(x) - min(x) - max(x)) / (length(x) - 2)
  # Alternative:
  # y <- x[(x > min(x)) & (x < max(x))]

  return(mean(y))
}

tapply(iris$Sepal.Length , iris$Species , f)

#%% Question 2 %%#
# Calcul de la matrice de corrélation :
sigma <- cor(iris[, -ncol(iris)]) 
# Avec dplyr: 
#sigma <- cor(iris %>% dplyr::select(Species))
View(sigma)

#%% Questions 3 à 5 %%#
plot(iris$Petal.Width, iris$Petal.Length, pch = 16, col = "darkblue",
     xlab = "Largeur des pétales", ylab = "Longueur des pétales")

#%% Question 6 %%#
reg <- lm(Petal.Length ~ Petal.Width, data = iris)
summary(reg)

#%% Question 7 %%#
typeof(reg)
names(reg)

#%% Question 8 %%#
# Ne fonctionnait pas chez certains ?
abline(reg, col = "darkred", lwd = 2)

#%% Question 9 %%#
legend(x = "topleft", legend = c("Data", "Reg"),
       pch = c(16, NA), lty = c(NA, 1), lwd = c(NA, 2),
       col = c("darkblue", "darkred"), bg = "white")

#%% Question 10 %%#
couleurs <- rep("#16a085", nrow(iris))
couleurs[iris$Species == "versicolor"] <- "#c0392b"
couleurs[iris$Species == "virginica"] <- "#8e44ad"

#%% Question 11 %%#
couleurs[iris$Species %in% c("versicolor", "virginica")] <- "#c0392b"

#%% Question 12 %%#
plot(iris$Petal.Width, iris$Petal.Length, pch = 16, col = couleurs,
     xlab = "Largeur des pétales", ylab = "Longueur des pétales")

legend(x = "topleft", legend = c("Setosa", "Versi & Virgi", "Reg"),
       pch = c(16, 16, NA), lty = c(NA, NA, 1), lwd = c(NA, NA, 2),
       col = c("#16a085", "#c0392b", "darkred"), bg = "white")

#%% Question 13 %%#
?grid
grid()

#%% Question 14 %%#
pdf("ma_figure.pdf", width = 10, height = 7) # Permet de sauvegarder une figure en pdf

plot(iris$Petal.Width, iris$Petal.Length, pch = 16, col = couleurs,
     xlab = "Largeur des pétales", ylab = "Longueur des pétales")

grid()

legend(x = "topleft", legend = c("Setosa", "Versi & Virgi", "Reg"),
       pch = c(16, 16, NA), lty = c(NA, NA, 1), lwd = c(NA, NA, 2),
       col = c("#16a085", "#c0392b", "darkred"), bg = "white")

dev.off() # Ferme le pdf

#%% Bonus: alternative plus simple avec ggplot2 %%#
# ggplot2 permet de réaliser la figure automatiquement
library(ggplot2)
ggplot(data = iris, aes(x = Petal.Width, y = Petal.Length, color = Species)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, color = "darkred")

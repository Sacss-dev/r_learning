rm(list = objects())
graphics.off()

library(dplyr)

#%% Questions 1 à 4 %%#
data <- read.csv("inflation.csv", sep = "\t", encoding = "UTF-8",
                 colClasses = c("character", rep("numeric", 5)))
summary(data)

#%% Question 5 %%#
library(data.table)
data <- data.table::fread("inflation.csv", encoding = "UTF-8")
class(data)
summary(data)

#%% Question 6 %%#
setDF(data)
class(data)

setDT(data)
class(data)

#%% Question 7 %%#
data$Mois <- as.Date(paste0(data$Mois , "−01"), format = "%Y−%m−%d")
data <- data %>%
          mutate(Mois = as.Date(paste0(Mois, "-01"), format = "%Y-%m-%d"))

#%% Question 8 %%#
data <- data[order(Mois),] # Syntaxe data.table
data <- data %>% arrange(Mois) # Syntaxe dplyr
data

#%% Questions 9 & 10 %%#
matplot(data$Mois , data[, -1],
        xlab = "Mois", ylab= "Indice des prix à la consommation",
        type="l", lty=1, lwd=2,
        col = c("#c0392b", "#bdc3c7", "#f39c12", "#2980b9", "#2c3e50"))

legend("topleft", legend = colnames(data)[-1], lty=1, lwd=2,
       col = c("#c0392b", "#bdc3c7", "#f39c12", "#2980b9", "#2c3e50"),
       bg = "#ecf0f1")

# Alternative avec ggplot
library(ggplot2)
data_ggplot <- data %>% 
                tidyr::pivot_longer(cols = -Mois, names_to = "Categorie", values_to = "Indice")
ggplot(data_ggplot, aes(x = Mois, y = Indice, col = Categorie)) +
  geom_line()

#%% Question 11 %%#
tmp = data %>% mutate_if(is.numeric, function(x) 100 * x / x[1])
data_ggplot <- tmp %>% 
  tidyr::pivot_longer(cols = -Mois, names_to = "Categorie", values_to = "Indice")

ggplot(data_ggplot, aes(x = Mois, y = Indice, col = Categorie)) +
  geom_line()

#-----------------------------------------#
#### explorer les données d'herbivorie ####
# première exploration des données
# réunion du 11 avril 2024 - début stage
#-----------------------------------------#

## librairies ------------------------------------------

library(readxl)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(ade4)
library(adegraphics)
library(factoextra)

## data ------------------------------------------------

herbivorie <-
  as.data.frame(read_excel("m1_jacquemin_24/data/bdd_propre_PF_RNCFS_WG_clean.xlsx"))

# table par genres


herbivorie.genre <-
  aggregate(
    herbivorie[, c("presence", "consommation")],
    by = list(
      herbivorie$genre,
      herbivorie$annee,
      herbivorie$placette,
      herbivorie$guilde,
      herbivorie$type_feuillage
    ),
    FUN = "max"
  )
colnames(herbivorie.genre) <- c("genre","annee","placette","guilde","type","presence","consommation")

## exploration ------------------------------------------

# Subset du tab avec que de la consomation 

tab_conso <- herbivorie.genre %>%
  filter(consommation == 1)


# Test de trucs

donnees <- data.frame(genre = names(table(tab_conso$genre)),
                      Nombre_d_occurrences = as.vector(table(tab_conso$essence)))

# Créer le diagramme à barres
diagramme <- ggplot(donnees, aes(x = reorder(Classe_d_essence,-Nombre_d_occurrences), y = Nombre_d_occurrences)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(x = "Classe d'essence", y = "Nombre d'occurrences") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# Afficher le diagramme
print(diagramme)

## AFC sur données de présence -------------------------------------------------

# reshape données de présence 

h.pres <-
  aggregate(
    herbivorie.genre$presence,
    by = list(herbivorie.genre$placette, herbivorie.genre$genre),
    FUN = "max"
  )
h.pres.w <- h.pres %>%
  pivot_wider(names_from = Group.2,
              values_from = x,
              values_fill = 0) %>%
  as.data.frame()
rownames(h.pres.w) <- h.pres.w$Group.1
h.pres.w2 <- h.pres.w[, -1]

# do AFC 

h.pres.w3 <- h.pres.w2[,!names(h.pres.w2)%in%c("berberis")]
afc.pres <- dudi.coa(h.pres.w3, scannf = F, nf = 10)
screeplot(afc.pres)
cumsum(afc.pres$eig)/sum(afc.pres$eig)

s.label(afc.pres$li,plabels = list(cex = 0.5))
s.label(afc.pres$co,plabels = list(cex = 0.8, col = "goldenrod", boxes = list(draw = T, alpha = 0.8)),add = T)

# add abroutissement

conso.plac <- unique(herbivorie.genre[,c("consommation","placette","annee")])

abrou.plac <-
  aggregate(
    conso.plac$consommation,
    by = list(conso.plac$placette),
    FUN = sum
  )

colnames(abrou.plac) <- c("placette","nb.yr.abrou")

s.value(afc.pres$li,z = abrou.plac$nb.yr.abrou , method = "color", col = colorRampPalette(c("yellow", "blue"))(3))

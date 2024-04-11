####### NETTOYAGE DONNEE - 11/04/2022

setwd("m1_jacquemin_24")


## librairies ------------------------------------------

library(readxl)


## Importation data ------------------------------------------------

clean_1 <- read_excel("data/bdd_propre_PF_RNCFS_WG - Copie.xlsx")
summary(clean_1)


## Liste des noms essences -----------------------------------------------------
liste_essence <- sort(unique(clean_1$essence))
print(liste_essence)


## MAJ -------------------------------------------------------------------------

clean_2 <- clean_1  # -> Creation de clean_2 avec les valeur de clean_1
clean_2$essence <- toupper(clean_1$essence)  ## Tout en maj pour essence

  ## Liste essence
liste_essence_2 <- sort(unique(clean_2$essence))
print(liste_essence_2)








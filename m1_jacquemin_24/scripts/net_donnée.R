####### NETTOYAGE DONNEE - 11/04/2022

setwd("m1_jacquemin_24")


## librairies ------------------------------------------

library(readxl)
library(openxlsx)
library(dplyr)


## Importation data ------------------------------------------------

clean_1 <- read_excel("data/bdd_propre_PF_RNCFS_WG - Copie.xlsx")
summary(clean_1)


## Liste des noms essences -----------------------------------------------------
liste_essence <- sort(unique(clean_1$essence))
print(liste_essence)


## MAJ -------------------------------------------------------------------------

bdd_propre_PF_RNCFS_WG_Clean <- clean_1  # -> Creation de clean_2 avec les valeur de clean_1
bdd_propre_PF_RNCFS_WG_Clean$essence <- toupper(clean_1$essence)  ## Tout en maj pour essence

  ## Liste essence
liste_essence_2 <- sort(unique(bdd_propre_PF_RNCFS_WG_Clean$essence))
print(liste_essence_2)
## -> C'est ok, tout en Maj

## Sauvegarde xlxs

chemin_fichier <- "C:/Users/anais/Documents/ofb_m1/ofb-ungulates/m1_jacquemin_24/data/bdd_propre_PF_RNCFS_WG_Clean.xlsx"
write.xlsx(bdd_propre_PF_RNCFS_WG_Clean, chemin_fichier, rowNames = FALSE)


## Nouv colonne guilde resineux/feuillus/semi-ligneux -------------------------------------------------------

plus_guilde <- bdd_propre_PF_RNCFS_WG_Clean

plus_guilde <- plus_guilde %>%
  mutate(guilde = case_when(
    essence %in% c("ALISIER BLANC", "ALISIER DE MOUGEOT") ~ "FEUILLUS",
    essence == "SAPIN PECTINE" ~ "RESINEUX",
    essence == "RONCES" ~ "SEMI_LIGNEUX",
    TRUE ~ NA_character_  
  ))

############## NOISETIER = COUDRIER






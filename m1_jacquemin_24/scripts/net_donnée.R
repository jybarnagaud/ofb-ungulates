####### NETTOYAGE DONNEE - 11/04/2022

setwd("m1_jacquemin_24")


## librairies ------------------------------------------

library(readxl)
library(openxlsx)
library(dplyr)
library(ggplot2)


## Importation data ------------------------------------------------

clean_1 <- read_excel("data/bdd_propre_PF_RNCFS_WG - Copie.xlsx")
summary(clean_1)


## Liste des noms essences -----------------------------------------------------
liste_essence <- sort(unique(clean_1$essence))
print(liste_essence)


## MAJuscule -------------------------------------------------------------------------

clean_2 <- clean_1  # -> Creation de clean_2 avec les valeures de clean_1
clean_2$essence <- toupper(clean_1$essence)  ## Tout en maj pour essences

  ## Liste essence
liste_essence_2 <- sort(unique(bdd_propre_PF_RNCFS_WG_Clean$essence))
print(liste_essence_2)
## -> C'est ok, tout en Maj


## Nouv colonne guilde resineux/feuillus/semi-ligneux -------------------------------------------------------

plus_guilde <- clean_2

plus_guilde <- plus_guilde %>%
  mutate(guilde = case_when(
    essence %in% c("ALISIER BLANC", "ALISIER DE MOUGEOT", 
                   "AMELANCHIER",  "AUBEPINE",  "AULNE GLUTINEUX",
                   "AULNE VERT","BOULEAU PUBESCENT","CAMERISIER",
                   "CHARME","CHENES","CHEVREFEUILLE", "CORNOUILLERS",
                   "CORONILLE ARBRISSEAU","CORONILLES", "COUDRIER" ,
                   "DAPHNES","ERABLE A FEUILLES DOBIER", "ERABLE CHAMPETRE",        
                   "ERABLE PLANE","ERABLE SYCOMORE","EPINE VINETTE", 
                   "FRENE COMMUN","HETRE", "MERISIER", "NOISETIER",
                   "ORME DE MONTAGNE","PEUPLIER TREMBLE" ,"SAULES", "SORBIER DES OISELEURS",
                   "SUREAUX", "TILLEULS" ,"TROENE","VIORNE LANTANE" ,"VIORNE OBIER") ~ "FEUILLUS",
    essence %in% c("SAPIN PECTINE","EPICEA COMMUN","IF") ~ "RESINEUX",
    essence %in% c ("RONCES","FRAMBOISIER","GROSEILLIERS","MYRTILLE","RAISIN D'OURS","ROSIERS") ~ "SEMI_LIGNEUX",
    TRUE ~ NA_character_  
  ))

## Memo triyage  -------------------------------------------------------------------------------------

############## NOISETIER = COUDRIER
############## "FRAISIA" ??

#### farmboisier + ronce = rubus sp
#### erables = acer 

## ------------------------------------------------------------------------------------------------------


## Sauvegarde du fichier #1 : bdd_propre_PF_RNCFS_WG_clean

bdd_propre_PF_RNCFS_WG_clean <- plus_guilde
chemin_fichier <- "C:/Users/anais/Documents/ofb_m1/ofb-ungulates/m1_jacquemin_24/data/bdd_propre_PF_RNCFS_WG_clean.xlsx"
write.xlsx(bdd_propre_PF_RNCFS_WG_clean, chemin_fichier, rowNames = FALSE)


## Subset du tab avec que de la consomation 

tab_conso <- plus_guilde %>%
  filter(consommation == 1)
print(tab_conso)

## Test de trucs

donnees <- data.frame(Classe_d_essence = names(table(tab_conso$essence)),
                      Nombre_d_occurrences = as.vector(table(tab_conso$essence)))

# Créer le diagramme à barres
diagramme <- ggplot(donnees, aes(x = Classe_d_essence, y = Nombre_d_occurrences)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(x = "Classe d'essence", y = "Nombre d'occurrences") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# Afficher le diagramme
print(diagramme)

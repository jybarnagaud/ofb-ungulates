#--------------------------------------------------------------#
####### NETTOYAGE DONNEES - 11/04/2022
# des données brutes fournies par l'OFB produire un nouvel Excel 
# nettoyé (erreurs de saisie etc)
# auteur: A. Jacquemin
#--------------------------------------------------------------#

## librairies ------------------------------------------

library(readxl)
library(openxlsx)
library(dplyr)
library(ggplot2)


## Importation data ------------------------------------------------

clean0 <- as.data.frame(read_excel("m1_jacquemin_24/data/bdd_propre_PF_RNCFS_WG.xlsx"))

## clean noms de placettes -----------------------------------------------------

plac.list <- clean0$placette
not.good <- grep("-", plac.list,invert = T)
plac.correct <- paste("7",plac.list[not.good], sep =  "-")

clean0$placette.2 <- clean0$placette
clean0[not.good,"placette.2"] <- plac.correct

clean1 <- aggregate(clean0[,c("presence","consommation")],by = list(clean0$annee,clean0$placette.2, clean0$essence), FUN = "max")
colnames(clean1) <- c("annee","placette","essence","presence","consommation")

## Liste des noms essences -----------------------------------------------------

liste_essence <- sort(unique(clean1$essence))
print(liste_essence)


## Majuscule -------------------------------------------------------------------------

clean_2 <- clean1  # -> Creation de clean_2 avec les valeures de clean_1
clean_2$essence <- toupper(clean_2$essence)  ## Tout en maj pour essences

  ## Liste essence
liste_essence_2 <- sort(unique(clean_2$essence))
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

## noms d'espèces modifiés -----------------------------------------------------



ind.sp <- as.data.frame(read_excel("m1_jacquemin_24/data/index_especes.xlsx"))

plus_guilde2 <- merge(plus_guilde, ind.sp, by = "essence", all = T)


## Memo triage  -------------------------------------------------------------------------------------

############## NOISETIER = COUDRIER
############## "FRAISIA" ??

#### farmboisier + ronce = rubus sp
#### erables = acer 

## ------------------------------------------------------------------------------------------------------

# liste des espèces

index.sp <- unique(plus_guilde2[,c("essence","guilde")])
chemin.index <- "m1_jacquemin_24/data/index_especes.xlsx"
write.xlsx(index.sp, chemin.index, rowNames = FALSE)

## Sauvegarde du fichier #1 : bdd_propre_PF_RNCFS_WG_clean

bdd_propre_PF_RNCFS_WG_clean <- plus_guilde2
chemin_fichier <- "m1_jacquemin_24/data/bdd_propre_PF_RNCFS_WG_clean.xlsx"
write.xlsx(bdd_propre_PF_RNCFS_WG_clean, chemin_fichier, rowNames = FALSE)


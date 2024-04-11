#-----------------------------------------#
#### explorer les données d'herbivorie ####
# première exploration des données
# réunion du 11 avril 2024 - début stage
#-----------------------------------------#

## librairies ------------------------------------------

library(readxl)


## data ------------------------------------------------

herbivorie <-
  as.data.frame(read_excel("m1_jacquemin_24/data/bdd_propre_PF_RNCFS_WG.xlsx"))

herbivorie$code_territoire <- factor(herbivorie$code_territoire)

#-----------------------------------------#
#### explorer les données d'herbivorie ####
# première exploration des données 
# réunion du 11 avril 2024 - début stage 
#-----------------------------------------#

setwd("m1_jacquemin_24")

## librairies ------------------------------------------

library(readxl)


## data ------------------------------------------------

herbivorie <-
  read_excel("data/bdd_propre_PF_RNCFS_WG.xlsx", sheet = "bdd_propre_PF_RNCFS_WG")


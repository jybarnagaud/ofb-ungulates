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

pres <- matrix(rbinom(300,1,0.4),nrow = 30, ncol = 10)
abr <- pres
abr2 <- matrix(sapply(abr,FUN = function(x) {ifelse(x>0,rbinom(1,1,0.3),0)}), nrow = 30)

colnames(pres) = paste("A", 1:10,sep="")
colnames(abr2) = paste("A", 1:10,sep="")

library(ade4)

afc.pres <- dudi.coa(pres,scannf= F, nf = 2)
afc.abr <- dudi.coa(abr2,scannf = F, nf = 2)

co.afc <- coinertia(afc.pres,afc.abr)

proc <- procuste(pres,abr2)

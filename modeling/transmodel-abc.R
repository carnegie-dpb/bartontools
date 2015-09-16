##
## stack three plots with letter labels
##

oldpar = par(mfrow=c(3,1), mar=c(4,4,0.5,0.5), mgp=c(2.5,1,0))

source("transmodel-vary-nu.R")
text(0.02,.98,"(a)")

source("transmodel-vary-gammap.R")
text(0.02,.98,"(b)")

source("transmodel-vary-etap.R")
text(0.02,.98,"(c)")

par(oldpar)

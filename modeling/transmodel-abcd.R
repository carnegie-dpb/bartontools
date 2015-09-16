##
## stack three plots with letter labels
##

oldpar = par(mfrow=c(2,2), mar=c(3.5,3.5,0.5,0.5), mgp=c(2,1,0))

source("transmodel-vary-nu.R")
text(0.02,.98,"(a)")

source("transmodel-vary-gamman.R")
text(0.02,.98,"(b)")

source("transmodel-vary-etap.R")
text(0.02,.98,"(c)")

source("transmodel-vary-gammap.R")
text(0.02,.98,"(d)")

par()

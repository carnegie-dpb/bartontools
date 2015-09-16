##
## stack two plots with letter labels
##

oldpar = par(mfrow=c(2,1), mar=c(3,3,0.5,0.5), mgp=c(1.5,.5,0))

source("transmodel-vary-etap.R")
text(0.02,19,"(a)")

source("transmodel-vary-gammap.R")
text(0.02,19,"(b)")

par(oldpar)

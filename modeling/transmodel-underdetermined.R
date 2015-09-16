##
## stack two plots with letter labels
##

oldpar = par(mfrow=c(2,1), mar=c(3,3,0.5,0.5), mgp=c(1.5,.5,0))

source("transmodel-vary-nu-gammap.R")
text(0.02,par()$usr[4]*0.90,"(a)")

source("transmodel-vary-gamman-gammap.R")
text(0.02,par()$usr[4]*0.90,"(b)")

par(oldpar)

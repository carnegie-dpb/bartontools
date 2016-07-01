##
## plot three expression/fit plots showing asymptotic logFC
##

source("~/R/getTimes.R")
source("~/R/getExpression.R")
source("rhop.R")

source("plot.ZPR1.R")
source("plot.CRK30.R")
source("plot.HAT22.R")

oldpar = par(mfrow=c(3,1), mar=c(3,3,0.5,0.5), mgp=c(1.5,.5,0))

plot.ZPR1()
text(0.0,par()$usr[3]+(par()$usr[4]-par()$usr[3])*0.95,"(a)")

plot.CRK30()
text(0.0,par()$usr[3]+(par()$usr[4]-par()$usr[3])*0.95,"(b)")

plot.HAT22()
text(0.0,par()$usr[3]+(par()$usr[4]-par()$usr[3])*0.95,"(c)")

par(oldpar)

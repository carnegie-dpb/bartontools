## plot the early, middle and late turn-off plots as separate plots

oldpar = par(mfrow=c(3,1), mar=c(3,3,0.5,0.5), mgp=c(1.5,.5,0))

source("plot.early.R")
plot.early()
text(0.0, 3.5, pos=4, "(a)  Group E", cex=1.2)

source("plot.middle.R")
plot.middle()
text(0.0, 3.5, pos=4, "(b)  Group M", cex=1.2)

source("plot.late.R")
plot.late()
text(0.0, 4.5, pos=4, "(c)  Group L", cex=1.2)

par(oldpar)

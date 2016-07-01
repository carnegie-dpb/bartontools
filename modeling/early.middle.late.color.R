## plot the early, middle and late turn-off plots as separate plots

source("rhop.R")
source("transmodel.fit.R")

source("~/R/getTimes.R")
source("~/R/getExpression.R")
source("~/R/plot.bars.R")

oldpar = par(mfrow=c(3,1), mar=c(3,3,0.5,0.5), mgp=c(1.5,.5,0))

source("plot.early.color.R")
source("plot.middle.R")
source("plot.late.R")

plot.early()
text(0.0, 3.5, pos=4, "(a)  Group E", cex=1.2)

plot.middle()
text(0.0, 3.5, pos=4, "(b)  Group M", cex=1.2)

plot.late()
text(0.0, 4.5, pos=4, "(c)  Group L", cex=1.2)

par(oldpar)

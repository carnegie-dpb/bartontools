## plot three AHP4 model plots

source("plot.AHP4.R")

pri = c("CRK22", "JKD", "At5g28300")
sec = "AHP4"

oldpar = par(mfrow=c(3,1), mar=c(3,3,0.5,0.5), mgp=c(1.5,.5,0))

ylim = c(10,250)
plot.AHP4(schema="gse30703",condition="GR-REV", ylim=ylim)
text(-0.04, 0.92*ylim[2], pos=4, "(a) microarray: GR-REV")

ylim = c(0.5,100)
plot.AHP4(schema="gse70796",condition="GR-REV", ylim=ylim)
text(-0.04, 0.90*ylim[2], pos=4, "(b) RNA-seq: GR-REV")


ylim = c(1.8,20)
plot.AHP4(schema="gse70796",condition="GR-STM", ylim=ylim)
text(-0.04, 0.93*ylim[2], pos=4, "(c) RNA-seq: GR-STM")

par(oldpar)

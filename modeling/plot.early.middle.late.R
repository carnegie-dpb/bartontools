##
## overplot example early, middle and late genes
##

source("rhop.R")
source("transmodel.fit.R")

source("~/R/getTimes.R")
source("~/R/getExpression.R")
source("~/R/plot.bars.R")

plot.early.middle.late = function() {

  rhoc0 = 19
  rhon0 = 1
  nu = 10
  gamman = 0

  condition = "GR-REV"

  early = "HB-2"
  middle = "TAA1"
  late = "AHP4"

  early.12.fit = transmodel.fit(schema="bl2012",condition=condition,gene=early,turnOff=0.5, doPlot=F)
  early.13.fit = transmodel.fit(schema="bl2013",condition=condition,gene=early,turnOff=0.5, doPlot=F)

  middle.12.fit = transmodel.fit(schema="bl2012",condition=condition,gene=middle,turnOff=1, doPlot=F)
  middle.13.fit = transmodel.fit(schema="bl2013",condition=condition,gene=middle,turnOff=1, doPlot=F)

  late.12.fit = transmodel.fit(schema="bl2012",condition=condition,gene=late,turnOff=0, doPlot=F)
  late.13.fit = transmodel.fit(schema="bl2013",condition=condition,gene=late,turnOff=0, doPlot=F)

  t.12 = getTimes(schema="bl2012",condition=condition)/60
  t.13 = getTimes(schema="bl2013",condition=condition)/60

  early.12 = getExpression(schema="bl2012",condition=condition,gene=early)
  middle.12 = getExpression(schema="bl2012",condition=condition,gene=middle)
  late.12 = getExpression(schema="bl2012",condition=condition,gene=late)

  early.13 = getExpression(schema="bl2013",condition=condition,gene=early)
  middle.13 = getExpression(schema="bl2013",condition=condition,gene=middle)
  late.13 = getExpression(schema="bl2013",condition=condition,gene=late)

  t = 0:200/100

  early.12.model = rhop(rhoc=rhoc0,nu=nu,gamman=gamman,t=t, rhop0=early.12.fit$estimate[1], etap=early.12.fit$estimate[2], gammap=early.12.fit$estimate[3], turnOff=0.5)
  early.13.model = rhop(rhoc=rhoc0,nu=nu,gamman=gamman,t=t, rhop0=early.13.fit$estimate[1], etap=early.13.fit$estimate[2], gammap=early.13.fit$estimate[3], turnOff=0.5)

  middle.12.model = rhop(rhoc=rhoc0,nu=nu,gamman=gamman,t=t, rhop0=middle.12.fit$estimate[1], etap=middle.12.fit$estimate[2], gammap=middle.12.fit$estimate[3], turnOff=1)
  middle.13.model = rhop(rhoc=rhoc0,nu=nu,gamman=gamman,t=t, rhop0=middle.13.fit$estimate[1], etap=middle.13.fit$estimate[2], gammap=middle.13.fit$estimate[3], turnOff=1)

  late.12.model = rhop(rhoc=rhoc0,nu=nu,gamman=gamman,t=t, rhop0=late.12.fit$estimate[1], etap=late.12.fit$estimate[2], gammap=late.12.fit$estimate[3], turnOff=0)
  late.13.model = rhop(rhoc=rhoc0,nu=nu,gamman=gamman,t=t, rhop0=late.13.fit$estimate[1], etap=late.13.fit$estimate[2], gammap=late.13.fit$estimate[3], turnOff=0)


  ## plot(t, early.12.model/early.12.fit$estimate[1], type="l", xlim=c(0,2), ylim=c(.5,5), log="y", xlab="time (h)", ylab="differential expression", )
  ## lines(t, middle.12.model/middle.12.fit$estimate[1])
  ## lines(t, late.12.model/late.12.fit$estimate[1])

  plot(t, early.12.model, type="l", xlim=c(0,2), ylim=c(5,500), log="y", xlab="time (h)", ylab="transcript level (FPKM, intensity)", )
  lines(t, middle.12.model)
  lines(t, late.12.model)

  ## plot.bars(t.12, early.12/early.12.fit$estimate[1], over=T, pch=0, cex=1.2)
  ## plot.bars(t.12, middle.12/middle.12.fit$estimate[1], over=T, pch=1, cex=1.2)
  ## plot.bars(t.12, late.12/late.12.fit$estimate[1], over=T, pch=2, cex=1.2)

  plot.bars(t.12, early.12, over=T, pch=0, cex=1.2)
  plot.bars(t.12, middle.12, over=T, pch=1, cex=1.2)
  plot.bars(t.12, late.12, over=T, pch=2, cex=1.2)

  ## lines(t, early.13.model/early.13.fit$estimate[1])
  ## lines(t, middle.13.model/middle.13.fit$estimate[1])
  ## lines(t, late.13.model/late.13.fit$estimate[1])

  lines(t, early.13.model)
  lines(t, middle.13.model)
  lines(t, late.13.model)

  ## plot.bars(t.13, early.13/early.13.fit$estimate[1], over=T, pch=22, bg="grey", cex=1.2)
  ## plot.bars(t.13, middle.13/middle.13.fit$estimate[1], over=T, pch=21, bg="grey", cex=1.2)
  ## plot.bars(t.13, late.13/late.13.fit$estimate[1], over=T, pch=24, bg="grey", cex=1.2)

  plot.bars(t.13, early.13, over=T, pch=22, bg="grey", cex=1.2)
  plot.bars(t.13, middle.13, over=T, pch=21, bg="grey", cex=1.2)
  plot.bars(t.13, late.13, over=T, pch=24, bg="grey", cex=1.2)

  legend(0.2, 70, xjust=0, yjust=0, pch=c(0,1,2), cex=1.2,
         c(
           paste(early,"(E)"),
           paste(middle,"(M)"),
           paste(late,"(L)")
           )
         )

  text(1.2, 500, pos=4, "open symbols = microarray")
  text(1.2, 20, pos=4, "filled symbols = RNA-seq")


  text(0.7, 140, pos=4, bquote(paste(gamma[p]==.(round(early.12.fit$estimate[3],2)),", ",.(round(early.13.fit$estimate[3],2))," ",h^-1)))
  ##text(1, 5.3, pos=4, bquote(paste(r^2==.(early.12.r2),", ",.(early.13.r2))))

  text(0.7, 110, pos=4, bquote(paste(gamma[p]==.(round(middle.12.fit$estimate[3],2)),", ",.(round(middle.13.fit$estimate[3],2))," ",h^-1)))
  ##text(1, 3.3, pos=4, bquote(paste(r^2==.(middle.12.r2),", ",.(middle.13.r2))))

  text(0.7, 85, pos=4, bquote(paste(gamma[p]==.(round(late.12.fit$estimate[3],2)),", ",.(round(late.13.fit$estimate[3],2))," ",h^-1)))
  ##text(1, 2.3, pos=4, bquote(paste(r^2==.(late.12.r2),", ",.(late.13.r2))))

}

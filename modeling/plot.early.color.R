##
## plot an example early turnOff gene
##

source("rhop.R")
source("transmodel.fit.R")

source("../R/getTimes.R")
source("../R/getExpression.R")
source("../R/plot.bars.R")

plot.early = function() {

  rhoc0 = 19
  rhon0 = 1
  nu = 10
  gamman = 0

  condition = "GR-REV"
  gene = "HB-2"

  bl2012.t = getTimes(schema="bl2012",condition=condition)/60
  bl2013.t = getTimes(schema="bl2013",condition=condition)/60

  bl2012 = getExpression(schema="bl2012",condition=condition,gene=gene)
  bl2013 = getExpression(schema="bl2013",condition=condition,gene=gene)

  bl2012.base = mean(bl2012[bl2012.t==0])
  bl2013.base = mean(bl2013[bl2013.t==0])

  bl2012.fit = transmodel.fit(schema="bl2012",condition=condition,gene=gene,turnOff=0.5, doPlot=F)
  bl2013.fit = transmodel.fit(schema="bl2013",condition=condition,gene=gene,turnOff=0.5, doPlot=F)

  bl2012.rhop0 = bl2012.fit$estimate[1]
  bl2012.etap = bl2012.fit$estimate[2]
  bl2012.gammap = bl2012.fit$estimate[3]

  bl2013.rhop0 = bl2013.fit$estimate[1]
  bl2013.etap = bl2013.fit$estimate[2]
  bl2013.gammap = bl2013.fit$estimate[3]

  t = 0:200/100
  bl2012.model = rhop(rhoc=rhoc0,nu=nu,gamman=gamman,t=t, rhop0=bl2012.rhop0, etap=bl2012.etap, gammap=bl2012.gammap, turnOff=0.5)
  bl2013.model = rhop(rhoc=rhoc0,nu=nu,gamman=gamman,t=t, rhop0=bl2013.rhop0, etap=bl2013.etap, gammap=bl2013.gammap, turnOff=0.5)

  plot(t, bl2012.model/bl2012.base, type="l", xlim=c(0,2), log="y", xlab="time (h)", ylab="relative expression", ylim=c(.8,4), col="blue")
  plot.bars(bl2012.t, bl2012/bl2012.base, over=T, pch=21, cex=1.5, bg="blue", col="blue")

  plot.bars(bl2013.t, bl2013/bl2013.base, over=T, pch=22, cex=1.5, bg="red", col="red")
  lines(t, bl2013.model/bl2013.base, col="red")

  ## redo first points to cover bars
  points(t, bl2013.model/bl2012.base, pch=21, cex=1.5, bg="blue", col="blue")
  

  legend(2, 4, xjust=1, yjust=1, pch=21:22, pt.cex=1.5, pt.bg=c("blue","red"), pt.lwd=0, cex=1.2,
         c(
           expression(paste("microarray: ",gamma[p]==2.04," ",h^-1," (",r^2==0.90,"0)")),
           expression(paste("RNA-seq:   ",gamma[p]==0.95," ",h^-1," (",r^2==0.84,")"))
           )
         )

  text(2, .9, expression(paste("GR-REV:",italic("HB-2"))), pos=2, cex=1.5)


}

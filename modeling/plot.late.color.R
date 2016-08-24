##
## plot an example early turnOff gene
##

plot.late = function() {

  rhoc0 = 19
  rhon0 = 1
  nu = 10

  condition = "GR-REV"

  gene = "AHP4"

  gse30703.t = getTimes(schema="gse30703",condition=condition)/60
  gse70796.t = getTimes(schema="gse70796",condition=condition)/60

  gse30703 = getExpression(schema="gse30703",condition=condition,gene=gene)
  gse70796 = getExpression(schema="gse70796",condition=condition,gene=gene)

  gse30703.base = mean(gse30703[gse30703.t==0])
  gse70796.base = mean(gse70796[gse70796.t==0])

  gse30703.fit = transmodel.fit(schema="gse30703",condition=condition,gene=gene,turnOff=0, doPlot=F)
  gse70796.fit = transmodel.fit(schema="gse70796",condition=condition,gene=gene,turnOff=0, doPlot=F)

  gse30703.rhop0 = gse30703.fit$estimate[1]
  gse30703.etap = gse30703.fit$estimate[2]
  gse30703.gammap = gse30703.fit$estimate[3]

  gse70796.rhop0 = gse70796.fit$estimate[1]
  gse70796.etap = gse70796.fit$estimate[2]
  gse70796.gammap = gse70796.fit$estimate[3]

  t = 0:200/100
  gse30703.model = rhop(rhoc=rhoc0,nu=nu, t=t, rhop0=gse30703.rhop0, etap=gse30703.etap, gammap=gse30703.gammap, turnOff=0)
  gse70796.model = rhop(rhoc=rhoc0,nu=nu, t=t, rhop0=gse70796.rhop0, etap=gse70796.etap, gammap=gse70796.gammap, turnOff=0)

  plot(t, gse30703.model/gse30703.base, type="l", xlim=c(0,2), log="y", xlab="time (h)", ylab="relative expression", ylim=c(.5,6), col="blue")
  plot.bars(gse30703.t, gse30703/gse30703.base, over=T, pch=19, cex=1.5, col="blue")

  lines(t, gse70796.model/gse70796.base, col="red")
  plot.bars(gse70796.t, gse70796/gse70796.base, over=T, pch=19, cex=1.5, col="red")

  legend(2.05, 1.7, xjust=1, yjust=1, pch=19, pt.cex=1.5, col=c("blue","red"), cex=1.2,
         c(
           expression(paste("microarray: ",gamma[p]==-0.56," ",h^-1," (",r^2==0.88,")")),
           expression(paste("RNA-seq:   ",gamma[p]==-0.66," ",h^-1," (",r^2==0.88,")"))
           )
         )

  text(2, 0.6, expression(paste("GR-REV:",italic("AHP4"))), pos=2, cex=1.5)


}

## plot the various transmodel2 fits for At5g28300 and AHP4


source("transmodel.fit.R")
source("transmodel2.fit.R")
source("rhop.R")
source("rhos.R")

source("~/R/getExpression.R")
source("~/R/getTimes.R")
source("~/R/plot.bars.R")

plot.AHP4 = function(schema, condition, ylim) {

  if (schema=="bl2012") {
    assay = "microarray"
    units = "CEL intensity"
  }
  if (schema=="bl2013") {
    assay = "RNA-seq"
    units = "FPKM"
  }
  
  pri = c("CRK22", "JKD", "At5g28300")
  prisymbols = c("CRK22", "JKD", "GT2L")
  sec = "AHP4"

  gamman = 0
  nu = 10
  rhon0 = 1
  rhoc0 = 19

  tdata = getTimes(schema=schema, condition=condition)/60
  pri1data = getExpression(schema=schema,condition=condition,gene=pri[1])
  pri2data = getExpression(schema=schema,condition=condition,gene=pri[2])
  pri3data = getExpression(schema=schema,condition=condition,gene=pri[3])
  secdata = getExpression(schema=schema,condition=condition,gene=sec)

  fitp1 = transmodel.fit(doPlot=F, rhoc0=rhoc0,nu=nu,gamman=gamman, schema=schema, condition=condition, gene=pri[1])
  fitp2 = transmodel.fit(doPlot=F, rhoc0=rhoc0,nu=nu,gamman=gamman, schema=schema, condition=condition, gene=pri[2])
  fitp3 = transmodel.fit(doPlot=F, rhoc0=rhoc0,nu=nu,gamman=gamman, schema=schema, condition=condition, gene=pri[3])

  fits1 = transmodel2.fit(doPlot=F, rhoc0=rhoc0,nu=nu,gamman=gamman, schema=schema, condition=condition, gene1=pri[1], gene2=sec)
  fits2 = transmodel2.fit(doPlot=F, rhoc0=rhoc0,nu=nu,gamman=gamman, schema=schema, condition=condition, gene1=pri[2], gene2=sec)
  fits3 = transmodel2.fit(doPlot=F, rhoc0=rhoc0,nu=nu,gamman=gamman, schema=schema, condition=condition, gene1=pri[3], gene2=sec)

  rhop0 =  c(fitp1$estimate[1],fitp2$estimate[1],fitp3$estimate[1])
  etap =   c(fitp1$estimate[2],fitp2$estimate[2],fitp3$estimate[2])
  gammap = c(fitp1$estimate[3],fitp2$estimate[3],fitp3$estimate[3])

  rhos0 =  c(fits1$estimate[1],fits2$estimate[1],fits3$estimate[1])
  etas =   c(fits1$estimate[2],fits2$estimate[2],fits3$estimate[2])
  gammas = c(fits1$estimate[3],fits2$estimate[3],fits3$estimate[3])

  t = 0:200/100

  rhop1 = rhop(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0[1], etap=etap[1], gammap=gammap[1])
  rhop2 = rhop(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0[2], etap=etap[2], gammap=gammap[2])
  rhop3 = rhop(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0[3], etap=etap[3], gammap=gammap[3])
  
  rhos1 = rhos(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, etap=etap[1],gammap=gammap[1], rhos0=rhos0[1],etas=etas[1],gammas=gammas[1])
  rhos2 = rhos(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, etap=etap[2],gammap=gammap[2], rhos0=rhos0[2],etas=etas[2],gammas=gammas[2])
  rhos3 = rhos(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, etap=etap[3],gammap=gammap[3], rhos0=rhos0[3],etas=etas[3],gammas=gammas[3])

  plot(t,  rhop1, type="l", log="y", ylim=ylim, col="black", xlab="time (h)", ylab=paste(units,", nuclear concentration",sep=""), lty=1)
  lines(t, rhop2, col="black", lty=1)
  lines(t, rhop3, col="black", lty=1)

  plot.bars(tdata, pri1data, over=T, col="black", pch=21, cex=1.2)
  plot.bars(tdata, pri2data, over=T, col="black", pch=22, cex=1.2)
  plot.bars(tdata, pri3data, over=T, col="black", pch=23, cex=1.2)

  lines(t, rhos1, col="black", lty=2)
  lines(t, rhos2, col="black", lty=2)
  lines(t, rhos3, col="black", lty=2)

  plot.bars(tdata, secdata, over=T, col="black", pch=24, bg="black", cex=1.2)


  legend(0, ylim[1], yjust=0, pch=c(21:24,NA), lty=c(1,1,1,2,NA), pt.bg=c(NA,NA,NA,"black",NA),
         c(
           as.expression(bquote(paste(.(prisymbols[1])," ",gamma[p]==.(round(gammap[1],2))))),
           as.expression(bquote(paste(.(prisymbols[2]),"      ",gamma[p]==.(round(gammap[2],2))))),
           as.expression(bquote(paste(.(prisymbols[3]),"    ",gamma[p]==.(round(gammap[3],2))))),
           as.expression(bquote(paste(.(sec)," ",gamma[s]==.(round(gammas[1],2)),",",.(round(gammas[2],2)),",",.(round(gammas[3],2))))),
           as.expression(bquote(paste(eta[s]==.(round(etas[1],2)),",",.(round(etas[2],2)),",",.(round(etas[3],2)))))
           )
         )


}

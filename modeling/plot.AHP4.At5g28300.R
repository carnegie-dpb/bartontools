## plot the various transmodel2 fits for At5g28300 and AHP4


source("transmodel.fit.R")
source("transmodel2.fit.R")
source("rhop.R")
source("rhos.R")

source("~/R/getExpression.R")
source("~/R/getTimes.R")

plot.AHP4.At5g28300 = function() {

  pri = "At5g28300"
  sec = "AHP4"

  gamman = 0
  nu = 10
  rhon0 = 1
  rhoc0 = 19

  t = 0:200/100

  pri.bl2012.REV = getExpression(schema="bl2012",condition="GR-REV",gene=pri)
  pri.bl2013.REV = getExpression(schema="bl2013",condition="GR-REV",gene=pri)
  pri.bl2013.STM = getExpression(schema="bl2013",condition="GR-STM",gene=pri)

  sec.bl2012.REV = getExpression(schema="bl2012",condition="GR-REV",gene=sec)
  sec.bl2013.REV = getExpression(schema="bl2013",condition="GR-REV",gene=sec)
  sec.bl2013.STM = getExpression(schema="bl2013",condition="GR-STM",gene=sec)

  fit1.bl2012.REV = transmodel.fit(doPlot=F, rhoc0=rhoc0,nu=nu,gamman=gamman, schema="bl2012", condition="GR-REV", gene=pri)
  fit1.bl2013.REV = transmodel.fit(doPlot=F, rhoc0=rhoc0,nu=nu,gamman=gamman, schema="bl2013", condition="GR-REV", gene=pri)
  fit1.bl2013.STM = transmodel.fit(doPlot=F, rhoc0=rhoc0,nu=nu,gamman=gamman, schema="bl2013", condition="GR-STM", gene=pri)

  rhop0.bl2012.REV = fit1.bl2012.REV$estimate[1]
  etap.bl2012.REV = fit1.bl2012.REV$estimate[2]
  gammap.bl2012.REV = fit1.bl2012.REV$estimate[3]

  rhop0.bl2013.REV = fit1.bl2013.REV$estimate[1]
  etap.bl2013.REV = fit1.bl2013.REV$estimate[2]
  gammap.bl2013.REV = fit1.bl2013.REV$estimate[3]
  
  rhop0.bl2013.STM = fit1.bl2013.STM$estimate[1]
  etap.bl2013.STM = fit1.bl2013.STM$estimate[2]
  gammap.bl2013.STM = fit1.bl2013.STM$estimate[3]

  rhop.bl2012.REV = rhop(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0.bl2012.REV, etap=etap.bl2012.REV, gammap=gammap.bl2012.REV)
  rhop.bl2013.REV = rhop(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0.bl2013.REV, etap=etap.bl2013.REV, gammap=gammap.bl2013.REV)
  rhop.bl2013.STM = rhop(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0.bl2013.STM, etap=etap.bl2013.STM, gammap=gammap.bl2013.STM)

  fit2.bl2012.REV = transmodel2.fit(doPlot=F, rhoc0=rhoc0,nu=nu,gamman=gamman, schema="bl2012", condition="GR-REV", gene1=pri, gene2=sec)
  fit2.bl2013.STM = transmodel2.fit(doPlot=F, rhoc0=rhoc0,nu=nu,gamman=gamman, schema="bl2013", condition="GR-REV", gene1=pri, gene2=sec)
  fit2.bl2013.STM = transmodel2.fit(doPlot=F, rhoc0=rhoc0,nu=nu,gamman=gamman, schema="bl2013", condition="GR-STM", gene1=pri, gene2=sec)

  rhos0.bl2012.REV = fit1.bl2012.REV$estimate[1]
  etas.bl2012.REV = fit1.bl2012.REV$estimate[2]
  gammas.bl2012.REV = fit1.bl2012.REV$estimate[3]

  rhos0.bl2013.REV = fit1.bl2013.REV$estimate[1]
  etas.bl2013.REV = fit1.bl2013.REV$estimate[2]
  gammas.bl2013.REV = fit1.bl2013.REV$estimate[3]
  
  rhos0.bl2013.STM = fit1.bl2013.STM$estimate[1]
  etas.bl2013.STM = fit1.bl2013.STM$estimate[2]
  gammas.bl2013.STM = fit1.bl2013.STM$estimate[3]

  rhos.bl2012.REV = rhos(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, etap=etap.bl2012.REV,gammap=gammap.bl2012.REV, rhos0=rhos0.bl2012.REV,etas=etas.bl2012.REV,gammas=gammas.bl2012.REV)
  rhos.bl2013.REV = rhos(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, etap=etap.bl2013.REV,gammap=gammap.bl2013.REV, rhos0=rhos0.bl2013.REV,etas=etas.bl2013.REV,gammas=gammas.bl2013.REV)
  rhos.bl2013.STM = rhos(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, etap=etap.bl2013.STM,gammap=gammap.bl2013.STM, rhos0=rhos0.bl2013.STM,etas=etas.bl2013.STM,gammas=gammas.bl2013.STM)

  plot(t, rhop.bl2012.REV, type="l", log="y", ylim=c(1,1e3), col="blue")
  lines(t, rhop.bl2013.REV, col="blue")
  lines(t, rhop.bl2013.STM, col="blue")

  lines(t, rhos.bl2012.REV, col="red")
  lines(t, rhos.bl2013.REV, col="red")
  lines(t, rhos.bl2013.STM, col="red")


}

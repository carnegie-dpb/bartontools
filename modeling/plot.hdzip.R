## HD-ZIPII genes, microarray

source("~/R/getExpression.R")
source("~/R/getTimes.R")
source("~/R/plot.bars.R")

source("rhop.R")
source("rhop.shape.R")

plot.hdzip = function() {

  nu = 10
  rhoc0 = 19
  rhon0 = 1
  gamman = 0

  tData = getTimes(schema="gse30703",condition="GR-REV")/60

  hat1 = getExpression(schema="gse30703",condition="GR-REV", gene="HAT1")
  hat2 = getExpression(schema="gse30703",condition="GR-REV", gene="HAT2")
  hat3 = getExpression(schema="gse30703",condition="GR-REV", gene="HAT3")
  hat4 = getExpression(schema="gse30703",condition="GR-REV", gene="HAT4")
  hat9 = getExpression(schema="gse30703",condition="GR-REV", gene="HAT9")
  hat22 = getExpression(schema="gse30703",condition="GR-REV", gene="HAT22")

  hat1.base = mean(hat1[tData==0])
  hat2.base = mean(hat2[tData==0])
  hat3.base = mean(hat3[tData==0])
  hat9.base = mean(hat9[tData==0])
  hat22.base = mean(hat22[tData==0])
  hat4.base = mean(hat4[tData==0])

  t = 0:200/100

  hat1.fit = rhop(t=t, turnOff=0.5, nu=nu,rhoc0=rhoc0,gamman=gamman, rhop0=285.5, etap=96.0, gammap=1.07)
  hat2.fit = rhop(t=t, turnOff=0.5, nu=nu,rhoc0=rhoc0,gamman=gamman, rhop0=183.9, etap=56.0, gammap=0.636)
  hat3.fit = rhop(t=t, turnOff=0.5, nu=nu,rhoc0=rhoc0,gamman=gamman, rhop0=52.5,  etap=8.46, gammap=0.550)
  hat9.fit = rhop(t=t, turnOff=0.5, nu=nu,rhoc0=rhoc0,gamman=gamman, rhop0=26.4,  etap=8.07, gammap=14.6)
  hat22.fit= rhop(t=t, turnOff=0.5, nu=nu,rhoc0=rhoc0,gamman=gamman, rhop0=178.9, etap=90.53, gammap=3.98)
  hat4.fit  = rhop(t=t, turnOff=0.5, nu=nu,rhoc0=rhoc0,gamman=gamman, rhop0=138.4, etap=57.4, gammap=2.04)


  plot(t, hat3.fit/hat3.base, type="l", log="y", ylim=c(.9,5), lty=1, xlab="time (h)", ylab="relative transcript level")
  lines(t, hat2.fit/hat2.base, lty=2)
  lines(t, hat1.fit/hat1.base, lty=3)
  lines(t, hat4.fit/hat4.base, lty=4)
  lines(t, hat22.fit/hat22.base, lty=5)
  lines(t, hat9.fit/hat9.base, lty=6)

  plot.bars(tData, hat3/hat3.base, over=T, pch=8)
  plot.bars(tData, hat2/hat2.base, over=T, pch=21)
  plot.bars(tData, hat1/hat1.base, over=T, pch=22)
  plot.bars(tData, hat4/hat4.base, over=T, pch=23)
  plot.bars(tData, hat22/hat22.base, over=T, pch=24)
  plot.bars(tData, hat9/hat9.base, over=T, pch=25)

  legend(2, 5, xjust=1, yjust=1, lty=1:6, pch=c(8,21:25),
         c(
           expression(paste(italic("HAT3"), "   ",gamma[p],"=0.55",h^-1,"  ",r^2,"=0.81")),
           expression(paste(italic("HAT2"), "   ",gamma[p],"=0.64",h^-1,"  ",r^2,"=0.88")),
           expression(paste(italic("HAT1"), "   ",gamma[p],"=1.07",h^-1,"  ",r^2,"=0.97")),
           expression(paste(italic("HAT4"), "   ",gamma[p],"=2.04",h^-1,"  ",r^2,"=0.90")),
           expression(paste(italic("HAT22")," ",gamma[p],"=3.98",h^-1,"  ",r^2,"=0.96")),
           expression(paste(italic("HAT9"), "   ",gamma[p],"=14.6",h^-1,"  ",r^2,"=0.64"))
           )
         )
}

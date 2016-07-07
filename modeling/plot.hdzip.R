## HD-ZIPII genes, microarray

source("~/R/getExpression.R")
source("~/R/getTimes.R")
source("~/R/plot.bars.R")

source("rhop.R")
source("rhop.shape.R")

plot.hdzip = function() {

    nu = 25
    rhoc0 = 25
    rhon0 = 1
    
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
    
    hat3.fit = rhop(t=t, turnOff=0.5, nu=nu,rhoc0=rhoc0, rhop0=52.5,  etap=6.43, gammap=0.55)
    hat2.fit = rhop(t=t, turnOff=0.5, nu=nu,rhoc0=rhoc0, rhop0=184, etap=42.5, gammap=0.64)
    hat1.fit = rhop(t=t, turnOff=0.5, nu=nu,rhoc0=rhoc0, rhop0=286, etap=70.3, gammap=1.07)
    hat4.fit  = rhop(t=t, turnOff=0.5, nu=nu,rhoc0=rhoc0, rhop0=138, etap=43.6, gammap=2.04)
    hat22.fit= rhop(t=t, turnOff=0.5, nu=nu,rhoc0=rhoc0, rhop0=182, etap=69.6, gammap=4.11)
    hat9.fit = rhop(t=t, turnOff=0.5, nu=nu,rhoc0=rhoc0, rhop0=26.4,  etap=9.66, gammap=23.2)

    ## commence plotting

    plot(t, hat3.fit/hat3.base, type="l", log="y", ylim=c(.9,5), lty=1, lwd=2,
         xlab="time after DEX application (h)", ylab="relative transcript level, model concentration", col="red")
    lines(t, hat2.fit/hat2.base, lty=1, lwd=2, col="orange")
    lines(t, hat1.fit/hat1.base, lty=1, lwd=2, col="cyan")
    lines(t, hat4.fit/hat4.base, lty=1, lwd=2, col="darkgreen")
    lines(t, hat22.fit/hat22.base, lty=1, lwd=2, col="blue")
    lines(t, hat9.fit/hat9.base, lty=1, lwd=2, col="violet")
    
    plot.bars(tData, hat3/hat3.base, over=T, pch=19, col="red")
    plot.bars(tData, hat2/hat2.base, over=T, pch=19, col="orange")
    plot.bars(tData, hat1/hat1.base, over=T, pch=19, col="cyan")
    plot.bars(tData, hat4/hat4.base, over=T, pch=19, col="darkgreen")
    plot.bars(tData, hat22/hat22.base, over=T, pch=19, col="blue")
    plot.bars(tData, hat9/hat9.base, over=T, pch=19, col="violet")

    legend(2, 5, xjust=1, yjust=1, lty=1, lwd=2, pch=19,
           col=c("red","orange","cyan","darkgreen","blue","violet"),
           text.col=c("black","black","black","black","black","black"),
         c(
           expression(paste(italic("HAT3"), "   ",gamma[p],"=0.55",h^-1,"  ",r^2,"=0.81")),
           expression(paste(italic("HAT2"), "   ",gamma[p],"=0.64",h^-1,"  ",r^2,"=0.88")),
           expression(paste(italic("HAT1"), "   ",gamma[p],"=1.07",h^-1,"  ",r^2,"=0.97")),
           expression(paste(italic("HAT4"), "   ",gamma[p],"=2.04",h^-1,"  ",r^2,"=0.90")),
           expression(paste(italic("HAT22")," ",gamma[p],"=4.11",h^-1,"  ",r^2,"=0.96")),
           expression(paste(italic("HAT9"), "   ",gamma[p],"=23.2",h^-1,"  ",r^2,"=0.66"))
           )
         )
}

##
## plot a series of lines for varying nu and gammap with similar resulting rhop profiles
##

source("rhoc.R")
source("rhon.R")
source("rhop.R")

source("~/R/getExpression.R")
source("~/R/getTimes.R")
source("~/R/plot.bars.R")

expr = getExpression(schema="gse70796", condition="GR-REV", gene="At4g39190")
texpr = getTimes(schema="gse70796", condition="GR-REV")/60

t = (0:200)/100

rhon0 = 1
rhoc0 = 25

plot(t, rhon(rhoc0=rhoc0,rhon0=rhon0,nu=5,t=t), type="l", ylim=c(1,26), lty=1, lwd=1, col="red", 
     xlab="time after DEX application (h)", ylab="transcript level (FPKM), model nuclear concentration (arb. units)")

lines(t, rhon(rhoc0=rhoc0,rhon0=rhon0,nu=10,t=t), lty=1, lwd=1, col="darkgreen")
lines(t, rhon(rhoc0=rhoc0,rhon0=rhon0,nu=20,t=t), lty=1, lwd=1, col="blue")

lines(t, rhop(rhoc0=rhoc0,rhon0=rhon0,rhop0=3.93,nu=5, etap=0.72,gammap=3.62,t=t), lty=1, lwd=1, col="red")
lines(t, rhop(rhoc0=rhoc0,rhon0=rhon0,rhop0=3.92,nu=10,etap=0.52,gammap=2.58,t=t), lty=1, lwd=1, col="darkgreen")
lines(t, rhop(rhoc0=rhoc0,rhon0=rhon0,rhop0=3.91,nu=20,etap=0.46,gammap=2.26,t=t), lty=1, lwd=1, col="blue")

points(texpr, expr, pch=21, cex=1.2)

legend(2.0, 1, xjust=1, yjust=0, lty=c(NA,1,1,1), pch=c(21,NA,NA,NA), lwd=1, pt.cex=c(1.2,1,1,1), col=c("black", "red","darkgreen","blue"),
       c(
         "GR-REV:At4g39190 (FPKM)",
         expression(paste(nu==5," ",h^-1,"     ",gamma[p]==3.62," ",h^-1,"  ",eta[p]==0.72," ",h^-1)),
         expression(paste(nu==10," ",h^-1,"   ",gamma[p]==2.58," ",h^-1,"  ",eta[p]==0.52," ",h^-1)),
         expression(paste(nu==20," ",h^-1,"   ",gamma[p]==2.26," ",h^-1,"  ",eta[p]==0.46," ",h^-1))
         )
       )

text(x=1.5, y=rhoc0, expression(rho[n]), cex=1.5)
text(x=1.5, y=10, expression(rho[p]), cex=1.5)

text(x=2, y=0.95*rhoc0, pos=2, bquote(paste(rho[c0]==.(rhoc0))))
text(x=2, y=0.90*rhoc0, pos=2, bquote(paste(rho[n0]==.(rhon0))))
text(x=2, y=0.85*rhoc0, pos=2, bquote(gamma[n]==0))
text(x=2, y=0.80*rhoc0, pos=2, bquote(gamma[e]==0))


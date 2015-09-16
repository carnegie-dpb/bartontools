##
## plot a series of lines for varying nu and gammap with similar resulting rhop profiles
##

source("rhoc.R")
source("rhon.R")
source("rhop.R")

source("../R/getExpression.R")
source("../R/getTimes.R")
source("../R/plot.bars.R")

expr = getExpression(schema="bl2013", condition="GR-REV", gene="At4g39190")
texpr = getTimes(schema="bl2013", condition="GR-REV")/60

t = (0:200)/100

rhon0 = 1
rhoc0 = 19
gamman = 0

plot(t, rhon(rhoc0=rhoc0, rhon0=rhon0, gamman=gamman, nu=5, t=t), type="l", ylim=c(0,20),
     xlab="time (h)", ylab="nuclear concentration (arb. units)", lty=1, lwd=1.5)
lines(t, rhon(rhoc0=rhoc0, rhon0=rhon0, gamman=gamman, nu=10, t=t), lty=2, lwd=1.5)
lines(t, rhon(rhoc0=rhoc0, rhon0=rhon0, gamman=gamman, nu=20, t=t), lty=3, lwd=1.5)

lines(t, rhop(rhoc0=rhoc0, gamman=gamman, rhop0=3.9, nu=5,  etap=0.943, gammap=3.62, t=t), lty=1, lwd=1.5)
lines(t, rhop(rhoc0=rhoc0, gamman=gamman, rhop0=3.9, nu=10, etap=0.681, gammap=2.58, t=t), lty=2, lwd=1.5)
lines(t, rhop(rhoc0=rhoc0, gamman=gamman, rhop0=3.9, nu=20, etap=0.602, gammap=2.26, t=t), lty=3, lwd=1.5)

points(texpr, expr, pch=21, cex=1)

legend(2.0, 0, xjust=1, yjust=0, lty=c(0,1,2,3), pch=c(21,NA,NA,NA), lwd=1.5, cex=1, 
       c(
         "GR-REV:At4g39190 (FPKM)",
         expression(paste(nu==5," ",h^-1,"     ",gamma[p]==3.62," ",h^-1,"  ",eta[p]==0.943," ",h^-1)),
         expression(paste(nu==10," ",h^-1,"   ",gamma[p]==2.58," ",h^-1,"  ",eta[p]==0.681," ",h^-1)),
         expression(paste(nu==20," ",h^-1,"   ",gamma[p]==2.26," ",h^-1,"  ",eta[p]==0.602," ",h^-1))
         )
       )

text(1.5, 19, expression(rho[n]), cex=1.5)
text(1.5, 10, expression(rho[p]), cex=1.5)

text(1.7, .95*20, pos=4, bquote(paste(rho[c0]==.(rhoc0))))
text(1.7, .90*20, pos=4, bquote(paste(rho[n0]==.(rhon0))))
text(1.7, .85*20, pos=4, bquote(paste(gamma[n]==.(gamman)," ",h^-1)))


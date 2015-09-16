##
## plot a series of lines for varying gamman and gammap that overlay
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
nu = 10

plot(t, rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=0, t=t), type="l", ylim=c(0,20),
     xlab="time (h)", ylab="nuclear concentration (arb. units)", lty=1, lwd=1.5)
lines(t, rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=1, t=t), lty=2, lwd=1.5)
lines(t, rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=2, t=t), lty=3, lwd=1.5)

lines(t, rhop(rhoc0=rhoc0, nu=nu, rhop0=3.9, gamman=0, etap=0.681, gammap=2.58, t=t), lty=1, lwd=1.5)
lines(t, rhop(rhoc0=rhoc0, nu=nu, rhop0=3.9, gamman=1, etap=0.534, gammap=0.494, t=t), lty=2, lwd=1.5)
lines(t, rhop(rhoc0=rhoc0, nu=nu, rhop0=3.9, gamman=2, etap=0.628, gammap=0.122, t=t), lty=3, lwd=1.5)

points(texpr, expr, pch=21, cex=1)

legend(2.0, 11, xjust=1, yjust=0, lty=c(NA,1,2,3), pch=c(21,NA,NA,NA), lwd=1.5, cex=1,
       c(
         "GR-REV:At4g39190 (FPKM)",
         expression(paste(gamma[n]==0.0," ",h^-1,"  ",gamma[p]==2.58," ",h^-1,"    ",eta[p]==0.681," ",h^-1)),
         expression(paste(gamma[n]==1.0," ",h^-1,"  ",gamma[p]==0.494," ",h^-1,"  ",eta[p]==0.534," ",h^-1)),
         expression(paste(gamma[n]==2.0," ",h^-1,"  ",gamma[p]==0.122," ",h^-1,"  ",eta[p]==0.628," ",h^-1))
         )
       )

text(0.4, 17, expression(rho[n]), cex=1.5)
text(1.5, 10, expression(rho[p]), cex=1.5)

text(1.7, .95*20, pos=4, bquote(paste(rho[c0]==.(rhoc0))))
text(1.7, .90*20, pos=4, bquote(paste(rho[n0]==.(rhon0))))
text(1.7, .85*20, pos=4, bquote(paste(nu==.(nu)," ",h^-1)))
     

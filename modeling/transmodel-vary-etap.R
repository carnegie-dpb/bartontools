##
## plot a series of lines for varying etap with nu and gammap fixed
##

source("rhon.R")
source("rhop.R")

t = 0:200/100

rhoc0 = 19
rhon0 = 1
nu = 10
gamman = 0

rhop0 = 1
gammap = 4

plot(t, rhon(t=t, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman), lty=1, lwd=1.5,
     type="l", ylim=c(0,20), xlab="time (h)", ylab="nuclear concentration (arb. units)")
lines(t, rhop(t=t, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, rhop0=rhop0,gammap=gammap, etap=1), lty=4, lwd=1.5)

lines(t, rhop(t=t, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, rhop0=rhop0,gammap=gammap, etap=2), lty=3, lwd=1.5)

lines(t, rhop(t=t, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, rhop0=rhop0,gammap=gammap, etap=4), lty=2, lwd=1.5)

text(0.5, 4, pos=4, bquote(paste(eta[p]==1,h^-1)))
text(0.5, 8, pos=4, bquote(paste(eta[p]==2,h^-1)))
text(0.5, 15, pos=4, bquote(paste(eta[p]==4,h^-1)))

legend(2.0,0, xjust=1, yjust=0, c(expression(rho[n]),expression(rho[p])), lty=c(1,2), lwd=1.5)

text(1.7, .90*par()$usr[4], pos=4, bquote(paste(rho[n0]==.(rhon0))))
text(1.7, .85*par()$usr[4], pos=4, bquote(paste(rho[c0]==.(rhoc0))))
text(1.7, .80*par()$usr[4], pos=4, bquote(paste(nu==.(nu)," ",h^-1)))
text(1.7, .75*par()$usr[4], pos=4, bquote(paste(gamma[n]==.(gamman)," ",h^-1)))
text(1.7, .70*par()$usr[4], pos=4, bquote(paste(gamma[p]==.(gammap)," ",h^-1)))


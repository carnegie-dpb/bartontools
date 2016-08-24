##
## plot out an example solution of the ODEs (gamman=0)
##

source("rhoc.R")
source("rhon.R")
source("rhop.R")
source("rhos.R")

t=-50:1000/500

rhoc0=25
rhon0=1
rhop0=1
rhos0=1

nu=10
gamman = 0 # not used

etap=2
gammap=3

etas=3
gammas=4

plot(t, rhoc(t=t, rhoc0=rhoc0, nu=nu), type="l", col="black", lwd=2, ylim=c(0,rhoc0+rhon0),
     xlab="time after DEX application (h)",
     ylab="protein or mRNA concentration (arb. units)"
     )
lines(t, rhon(t=t, rhoc0=rhoc0, rhon0=rhon0, nu=nu), col="blue", lwd=2)
lines(t, rhop(t=t, rhoc0=rhoc0, rhon0=rhon0, nu=nu, rhop0=rhop0, etap=etap, gammap=gammap), col="red", lwd=2)
lines(t, rhos(t=t, rhoc0=rhoc0, rhon0=rhon0, nu=nu, etap=etap, gammap=gammap, rhos0=rhos0, etas=etas, gammas=gammas), col="darkgreen", lwd=2)

text(0.17, 24, bquote(rho[c]), pos=2, col="black", cex=1.5)
text(0.31, 20, bquote(rho[n]), pos=2, col="blue", cex=1.5)
text(1.0, 14.2, bquote(rho[p]), pos=2, col="red", cex=1.5)
text(1.4, 10.5, bquote(rho[s]), pos=2, col="darkgreen", cex=1.5)

ytop = rhoc0+rhon0-3

text(1.6, ytop, bquote(rho[c0]==.(round(rhoc0,1))), pos=4, col="black", cex=1.0)
text(1.6, ytop-1, bquote(rho[n0]==.(round(rhon0,1))), pos=4, col="blue", cex=1.0)
text(1.6, ytop-2, bquote(rho[p0]==.(round(rhop0,1))), pos=4, col="red", cex=1.0)
text(1.6, ytop-3, bquote(rho[s0]==.(round(rhos0,1))), pos=4, col="darkgreen", cex=1.0)

ytop = 8
text(1.6, ytop, bquote(paste(nu==.(round(nu,1))," ",h^-1)), pos=4, col="blue", cex=1.0)
text(1.6, ytop-2, bquote(paste(eta[p]==.(round(etap,1))," ",h^-1)), pos=4, col="red", cex=1.0)
text(1.6, ytop-3, bquote(paste(gamma[p]==.(round(gammap,1))," ",h^-1)), pos=4, col="red", cex=1.0)
text(1.6, ytop-5, bquote(paste(eta[s]==.(round(etas,1))," ",h^-1)), pos=4, col="darkgreen", cex=1.0)
text(1.6, ytop-6, bquote(paste(gamma[s]==.(round(gammas,1))," ",h^-1)), pos=4, col="darkgreen", cex=1.0)





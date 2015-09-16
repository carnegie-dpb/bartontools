##
## plot a series of lines for varying gamman with nu, etap, gammap fixed
##

source("rhon.R")
source("rhop.R")

t = 0:200/100

rhon0 = 0.01
rhoc0 = 0.99
nu = 10
gammap = 3
etap = 3

rhop0 = 0.01

plot(t, rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=0, t=t), type="l", lty=1, ylim=c(0,1),
     xlab="time (h)", ylab="nuclear concentration (arb. units)")
lines(t, rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=.5, t=t))
lines(t, rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=2, t=t))
      
lines(t, rhop(rhoc0=rhoc0, nu=nu, gamman=0, rhop0=rhop0, etap=etap, gammap=gammap, t=t), lty=2)
lines(t, rhop(rhoc0=rhoc0, nu=nu, gamman=.5, rhop0=rhop0, etap=etap, gammap=gammap, t=t), lty=2)
lines(t, rhop(rhoc0=rhoc0, nu=nu, gamman=2, rhop0=rhop0, etap=etap, gammap=gammap, t=t), lty=2)

text(0.5, .95, pos=4, bquote(paste(gamma[n]==0)))
text(1.0, .45, pos=4, bquote(paste(gamma[n]==0.5,h^-1)))
text(1.2, 0, pos=4, bquote(paste(gamma[n]==2,h^-1)))

legend(0.25,0, yjust=0, c(expression(rho[n]),expression(rho[p])), lty=c(1,2))

text(1.5, .92, pos=4, bquote(paste(rho[c0]==.(rhoc0))))
text(1.5, .86, pos=4, bquote(paste(rho[n0]==.(rhon0))))
text(1.5, .80, pos=4, bquote(paste(rho[p0]==.(rhop0))))
text(1.5, .74, pos=4, bquote(paste(nu==.(nu),h^-1)))
text(1.5, .68, pos=4, bquote(paste(eta[p]==.(etap),h^-1)))
text(1.5, .62, pos=4, bquote(paste(gamma[p]==.(gammap),h^-1)))
     

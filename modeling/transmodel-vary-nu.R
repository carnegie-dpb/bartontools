##
## plot a series of lines for varying nu etap/gammap fixed
##

source("rhoc.R")
source("rhon.R")
source("rhop.R")

t = (0:200)/100

rhon0 = 1
rhoc0 = .99
gamman = 0
rhop0 = .01
etap = 1.0
gammap = 1.0

plot(t, rhon(rhon0=rhon0, rhoc0=rhoc0, nu=2, gamman=gamman, t=t), type="l", lty=1, ylim=c(0,1),
     xlab="time (h)", ylab="nuclear concentration (arb. units)")
lines(t, rhon(rhon0=rhon0, rhoc0=rhoc0, nu=4, gamman=gamman, t=t))
lines(t, rhon(rhon0=rhon0, rhoc0=rhoc0, nu=8, gamman=gamman, t=t))
lines(t, rhon(rhon0=rhon0, rhoc0=rhoc0, nu=16, gamman=gamman, t=t))

lines(t, rhop(rhoc0=rhoc0, nu=2, gamman=gamman, rhop0=rhop0, etap=etap, gammap=gammap, t=t), lty=2)
lines(t, rhop(rhoc0=rhoc0, nu=4, gamman=gamman, rhop0=rhop0, etap=etap, gammap=gammap, t=t), lty=3)
lines(t, rhop(rhoc0=rhoc0, nu=8, gamman=gamman, rhop0=rhop0, etap=etap, gammap=gammap, t=t), lty=4)
lines(t, rhop(rhoc0=rhoc0, nu=16, gamman=gamman, rhop0=rhop0, etap=etap, gammap=gammap, t=t), lty=5)

legend(2,0, lty=1:5, xjust=1, yjust=0,
       c(
         expression(rho[n]),
         expression(paste(rho[p],"  ",nu==2,h^-1)),
         expression(paste(rho[p],"  ",nu==4,h^-1)),
         expression(paste(rho[p],"  ",nu==8,h^-1)),
         expression(paste(rho[p],"  ",nu==16,h^-1))
         )
       )

text(0, 1, pos=4, bquote(paste(nu==16,h^-1)))
text(.85, .8, pos=4, bquote(paste(nu==2,h^-1)))

text(2, .61, pos=2, bquote(rho[c0]==.(rhoc0)))
text(2, .55, pos=2, bquote(rho[n0]==.(rhon0)))
text(2, .49, pos=2, bquote(rho[p0]==.(rhop0)))
text(2, .43, pos=2, bquote(paste(eta[p]==.(etap),h^-1)))
text(2, .37, pos=2, bquote(paste(gamma[p]==.(gammap),h^-1)))


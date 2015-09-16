##
## plot a series of lines for varying nu etap/gammap fixed
##

source("rhon.R")
source("rhop.R")

t = (0:200)/100

rhon0 = .01
rhoc0 = .99
gamman = 0
rhop0 = .01

plot(t, rhop(rhoc0=rhoc0, nu=8, gamman=gamman, rhop0=rhop0, etap=1.2, gammap=1.3, t=t), lty=2, ylim=c(0,1),
     type="l", xlab="time (h)", ylab="nuclear concentration (arb. units)")

lines(t, rhop(rhoc0=rhoc0, nu=4, gamman=gamman, rhop0=rhop0, etap=1.5, gammap=1.7, t=t), lty=3)
lines(t, rhop(rhoc0=rhoc0, nu=16, gamman=gamman, rhop0=rhop0, etap=.93, gammap=.95, t=t), lty=4)

legend(2,0, lty=c(3,2,4), xjust=1, yjust=0,
       legend=c(
         expression(paste(nu==4,"   ",eta[p]==1.5,"   ",gamma[p]==1.7)),
         expression(paste(nu==8,"   ",eta[p]==1.2,"   ",gamma[p]==1.3)),
         expression(paste(nu==16," ",eta[p]==0.93," ",gamma[p]==0.93))
         )
     )

text(2, .41, pos=2, bquote(paste(rho[c0]==.(rhoc0))))
text(2, .35, pos=2, bquote(paste(rho[n0]==.(rhon0))))
text(2, .29, pos=2, bquote(paste(rho[p0]==.(rhop0))))

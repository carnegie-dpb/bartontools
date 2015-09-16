##
## plot a series of lines for various gamman,etap,gammap with same rhop trace
##

t = (0:200)/100

rhon0 = 0.01
rhoc0 = 0.99
nu = 10
rhop0 = 0.01

plot(t, rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=0.5, t=t), type="l", lty=1, ylim=c(0,1),
     xlab="time (h)", ylab="nuclear concentration (arb. units)")
lines(t, rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=1.0, t=t))
lines(t, rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=2.0, t=t))
lines(t, rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=4.0, t=t))
      
lines(t, rhop(rhoc0=rhoc0, nu=nu, rhop0=rhop0, gamman=0.5, etap=2.15, gammap=1.8, t=t), lty=2)
lines(t, rhop(rhoc0=rhoc0, nu=nu, rhop0=rhop0, gamman=1.0, etap=2.0, gammap=1.0, t=t), lty=3)
lines(t, rhop(rhoc0=rhoc0, nu=nu, rhop0=rhop0, gamman=2.0, etap=2.2, gammap=0.4, t=t), lty=4)
lines(t, rhop(rhoc0=rhoc0, nu=nu, rhop0=rhop0, gamman=4.0, etap=3.1, gammap=0.1, t=t), lty=5)


text(0.7, 0.08, pos=2, bquote(paste(gamma[n]==4,h^-1)))
text(2.0, 0.48, pos=2, bquote(paste(gamma[n]==0.5,h^-1)))

legend(2.0,1.0, xjust=1, yjust=1, lty=c(0,2:5,1),
       c(
         expression(paste("       ",gamma[n],"      ",eta[p],"      ",gamma[p])),
         expression(paste(rho[p],"   0.5   2.15  1.8")),
         expression(paste(rho[p],"   1.0   2.00  1.0")),
         expression(paste(rho[p],"   2.0   2.20  0.4")),
         expression(paste(rho[p],"   4.0   3.10  0.1")),
         expression(rho[n])
         )
       )

text(0.7, 0.96, pos=4, bquote(paste(rho[n0]==0.01)))
text(0.7, 0.90, pos=4, bquote(paste(rho[c0]==0.99)))
text(0.7, 0.84, pos=4, bquote(paste(nu==10,h^-1)))
     

##
## plot out the shapes for the various gamma values
##

plot(t, rhop(rhoc0=99,nu=10,gamman=0,rhop0=0,etap=highR2.etap[1],gammap=highR2.gammap[1], t=t), type="l", ylim=c(-20,30), ylab=expression(rho[p]-rho[p0]))

for (i in 1:length(highR2.gammap)) {
  lines(t, rhop(rhoc0=99,nu=10,gamman=0,rhop0=0,etap=highR2.etap[i],gammap=highR2.gammap[i], t=t))
}

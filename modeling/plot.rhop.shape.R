## make a nice plot of the rhop shape function

source("rhop.shape.R")

t = 0:500/100

plot(t, rhop.shape(t, nu=10, gammap=10), type="l", xlab="time (h)", ylab=expression(paste(rho[p]," shape function")))

lines(t, rhop.shape(t, nu=10, gammap=2))
lines(t, rhop.shape(t, nu=10, gammap=1))
lines(t, rhop.shape(t, nu=10, gammap=0.5))
lines(t, rhop.shape(t, nu=10, gammap=0.2))
lines(t, rhop.shape(t, nu=10, gammap=0.1))

text(4.2, 0.31, pos=4, expression(paste(gamma[p]==0.1," ",h^-1)))
text(3.7, 0.50, pos=4, expression(paste(0.2," ",h^-1)))
text(2.5, 0.69, pos=4, expression(paste(0.5," ",h^-1)))
text(1.8, 0.81, pos=4, expression(paste(1," ",h^-1)))
text(1.2, 0.88, pos=4, expression(paste(2," ",h^-1)))
text(0.5, 0.96, pos=4, expression(paste(10," ",h^-1)))

text(4, 0.10, pos=4, expression(gamma[n]==0))
text(4, 0.05, pos=4, expression(paste(nu==10," ",h^-1)))


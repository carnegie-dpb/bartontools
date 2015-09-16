##
## solve linear transcription model for a direct target in one condition

require("deSolve")

## trans rate and loss rate for direct target, per hour
gamma12 = 0.5
gamma2 = 1.0

## ratios of initial concentrations
C12 = 1.0

## c1(t) is given, the externally-induced TF concentration
a = 300
b = 2.0

c1 = function(t) {
  return(1 + a*t*exp(-b*t))
}

## derivatives for c2
derivs = function(t, y, parms) {
  c2 = y[1]
  return( list( c( -gamma2*(c2-1)+gamma12*C12*(c1(t)-1) )))
}

## time array
times = seq(from=0, to=2, by=0.01)

## calculate; starting relative concentrations are 1 by definition
out = ode(y=c(1), times=times, func=derivs, parms=NULL)

## kludge, sorry!
c1t = times
for (i in 1:length(times)) {
  c1t[i] = c1(times[i])
}

## TF concentration
plot(times, c1t, type="l", xlab="t (h)", ylab="Rel. Conc. (lines), Rel. FPKM (points)", main="Linear ODE Transcription Model", col="purple", log="y", ylim=c(.1,100))

## transcript concentration
lines(out[,1], out[,2], col="red")


legend(1.5, 0.5, c("GR-REV","ZPR3"), lty=1, col=c("purple","red"))

## compare with ZPR3 under GR-REV (relative to average ZPR3(0))
t = c( 0,0,0, 30,30,30, 60,60,60, 120,120,120)/60
GRREV.ZPR3 = c( 1.153357,1.354201,0.4924417, 0.4272676,2.695558,2.807537, 16.80174,17.13758,14.32351, 19.27571,12.04715,13.84045 )

total = 0
points(t, GRREV.ZPR3, pch=19, col="red")
sumsq = sum((GRREV.ZPR3[1:3]-out[1,2])^2) + sum((GRREV.ZPR3[4:6]-out[51,2])^2) + sum((GRREV.ZPR3[7:9]-out[101,2])^2) + sum((GRREV.ZPR3[10:12]-out[201,2])^2)
print(paste("GRREV.ZPR3",signif(sumsq,4)))



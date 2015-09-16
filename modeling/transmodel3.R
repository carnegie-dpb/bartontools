##
## solve linear transcription model for a direct target in one condition and direct and indirect target in another condition
## subject to constraint that c1max,t1max are the same (assumed similar GR penetration into nucleus in both conditions)
## as well as gamma12,gamma2 in first case equals gamma23,gamma3 in second case
##

require("deSolve")

## trans rate and loss rate for first condition direct target, per hour
## GR-AS2 -> At4g27900
gamma12a = 0.073
gamma2a = 0.7

## trans rate and loss rate for second condition direct target, per hour
## GR-KAN -> AS2
gamma12b = -0.018
gamma2b = 1.1

## trans rate and loss rate for second condition indirect target, per hour
## AS2 -> At4g27900
gamma23b = 2.3
gamma3b = 0.7

## ratios of initial concentrations
C12a = 0.539 # AS2/At4g27900
C12b = 0.628 # KAN/AS2
C23b = C12a  # AS2/At4g27900

## c1(t) is given, the externally-induced TF concentration
aa = 300
ab = aa*85/50
ba = 2.0
bb = 2.0

c1a = function(t) {
  return(1 + aa*t*exp(-ba*t))
}
c1b = function(t) {
  return(1 + ab*t*exp(-bb*t))
}

## derivatives for c2a
derivsa = function(t, y, parms) {
  c2a = y[1]
  return( list( c( -gamma2a*(c2a-1)+gamma12a*C12a*(c1a(t)-1) )))
}

## derivatives for c2b and c3b
derivsb = function(t, y, parms) {
  c2b = y[1]
  c3b = y[2]
  return( list( c( -gamma2b*(c2b-1)+gamma12b*C12b*(c1b(t)-1), -gamma3b*(c3b-1)+gamma23b*C23b*(c2b-1) )))
}

## time array
times = seq(from=0, to=2, by=0.01)

## calculate; starting relative concentrations are 1 by definition
outa = ode(y=c(1), times=times, func=derivsa, parms=NULL)
outb = ode(y=c(1,1), times=times, func=derivsb, parms=NULL)

## kludge, sorry!
c1at = times
for (i in 1:length(times)) {
  c1at[i] = c1a(times[i])
}
c1bt = times
for (i in 1:length(times)) {
  c1bt[i] = c1b(times[i])
}

## TF concentration
plot(times, c1at, type="l", xlab="t (h)", ylab="Rel. Conc. (lines), Rel. FPKM (points)", main="Linear ODE Transcription Model", col="purple", log="y", ylim=c(.1,100))
lines(times, c1bt, col="green")

## condition a transcript
lines(outa[,1], outa[,2], col="red")

## condition b transcripts
lines(outb[,1], outb[,2], col="blue")
lines(outb[,1], outb[,3], col="orange")

## experimental times
t = c( 0,0,0, 30,30,30, 60,60,60, 120,120,120)/60
## At4g27900 under GR-AS2
GRAS2.At4g27900 = c( 0.9417431,1.143665,0.9145921, 1.62699,1.799639,0.9679873, 2.37361,2.580802,2.509264, 2.480963,2.283664,1.815969 )
## At1g65620 (AS2) under GR-KAN
GRKAN.At1g65620 = c( 1.250928,0.9676416,0.7814302, 0.8818608,0.7136073,0.7217256, 0.5466891,0.2368291,0.3799573, 0.5752782,0.5846687,0.5599046 )
## At4g27900 under GR-KAN
GRKAN.At4g27900 = c( 0.9858,0.9618472,1.052353, 0.9163274,0.9889606,0.7061309, 0.514636,0.6396041,0.4848489, 0.384317,0.4377428,0.5405878 )

legend(0, 0.5, c("GR-AS2","At4g27900","GR-KAN", "AS2","At4g27900"), lty=1, col=c("purple","red","green","blue","orange"))



total = 0

points(t, GRAS2.At4g27900, pch=19, col="red")
sumsq = sum((GRAS2.At4g27900[1:3]-outa[1,2])^2) + sum((GRAS2.At4g27900[4:6]-outa[51,2])^2) + sum((GRAS2.At4g27900[7:9]-outa[101,2])^2) + sum((GRAS2.At4g27900[10:12]-outa[201,2])^2)
print(paste("GRAS2.At4g27900",signif(sumsq,4)))
total = total + sumsq

points(t, GRKAN.At1g65620, pch=19, col="blue")
sumsq = sum((GRKAN.At1g65620[1:3]-outb[1,2])^2) + sum((GRKAN.At1g65620[4:6]-outb[51,2])^2) + sum((GRKAN.At1g65620[7:9]-outb[101,2])^2) + sum((GRKAN.At1g65620[10:12]-outb[201,2])^2)
print(paste("GRKAN.At1g65620",signif(sumsq,4)))
total = total + sumsq

points(t, GRKAN.At4g27900, pch=19, col="orange")
sumsq = sum((GRKAN.At4g27900[1:3]-outb[1,3])^2) + sum((GRKAN.At4g27900[4:6]-outb[51,3])^2) + sum((GRKAN.At4g27900[7:9]-outb[101,3])^2) + sum((GRKAN.At4g27900[10:12]-outb[201,3])^2)
print(paste("GRKAN.At4g27900",signif(sumsq,4)))
total = total + sumsq

print(paste("TOTAL", signif(total,4)))



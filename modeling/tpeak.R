##
## solve the transcendental equation defining tpeak and return it
##

tpeak = function(gamman, nu, gammap, interval=c(0,2)) {

  y = function(t) { -gamman*(nu-gammap)*exp(-gamman*t) - nu*(gammap-gamman)*exp(-nu*t) + gammap*(nu-gamman)*exp(-gammap*t) }

  tseq = seq(from=interval[1],to=interval[2],by=0.01)
  plot(tseq, y(tseq), type="l")
  lines(interval, c(0,0), lty=2)

  return(uniroot(y, interval=interval))

}

##
## plot HAT22 and RLP19 with given parameters
##

source("rhocnps.R")

source("~/R/getExpression.R")
source("~/R/getTimes.R")

plot.ps = function(schema, gene1, gene2, rhop0, etap, gammap, rhos0, etas, gammas, turnOff=0) {

  rhoc0 = 20
  rhon0 = 1
  nu = 10
  gamman = 0.825
  gammae = 0
  
  t = (0:200)/100

  dataTimes = getTimes(schema, condition="GR-REV")/60
  p = getExpression(schema, condition="GR-REV", gene=gene1)
  s = getExpression(schema, condition="GR-REV", gene=gene2)

  model = rhocnps(rhoc0, rhon0, nu, gammae, gamman, rhop0, etap, gammap, rhos0, etas, gammas, t, turnOff)

  plot(t, model$rhop, type="l", col="blue", log="y", ylim=c(min(p,s),max(p,s)))
  lines(t, model$rhos, col="red")
  points(dataTimes, p, col="blue")
  points(dataTimes, s, col="red")

}

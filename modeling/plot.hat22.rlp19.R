##
## plot HAT22 and RLP19 with given parameters
##

source("rhocnps.R")

source("~/R/getExpression.R")
source("~/R/getTimes.R")

plot.hat22.rlp19 = function(schema, rhop0, etap, gammap, rhos0, etas, gammas, turnOff) {

  rhoc0 = 20
  rhon0 = 1
  nu = 10
  gamman = 0.825
  gammae = 0
  
  t = (0:200)/100

  dataTimes = getTimes(schema, condition="GR-REV")/60
  hat22 = getExpression(schema, condition="GR-REV", gene="HAT22")
  rlp19 = getExpression(schema, condition="GR-REV", gene="RLP19")

  model = rhocnps(rhoc0, rhon0, nu, gammae, gamman, rhop0, etap, gammap, rhos0, etas, gammas, t, turnOff)

  plot(t, model$rhop, ylim=c(10,1000), log="y", type="l", col="blue")
  lines(t, model$rhos, col="red")
  points(dataTimes, hat22, col="blue")
  points(dataTimes, rlp19, col="red")

}

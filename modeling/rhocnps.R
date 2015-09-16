##
## numerically solve linear transcription model for a primary and secondary target using numerical integration using input time array
##

require("deSolve")

rhocnps = function(turnOff=0, rhoc0, rhon0, nu, gammae, gamman, rhop0, etap, gammap, rhos0, etas, gammas, t) {

  ## derivatives for rhoc, rhon and rhop
  derivs = function(t, y, parms) {
    rhoc = y[1]
    rhon = y[2]
    rhop = y[3]
    rhos = y[4]

    ## TURN OFF etap for t>turnOff
    if (turnOff>0 && t>turnOff) etap = 0

    ## continuous logistic function to model turn-off
    ## if (turnOff>0) {
    ##   sigma = 100.0
    ##   etap = etap*2*exp(-sigma*(t-turnOff))/(1+exp(-sigma*(t-turnOff)))
    ## }
    
    return( list( c(
      -nu*rhoc + gammae*(rhon-rhon0),
      +nu*rhoc - gammae*(rhon-rhon0) - gamman*(rhon-rhon0),
      +etap*rhon - gammap*(rhop-rhop0),
      +etas*rhop - gammas*(rhos-rhos0)
      )))
  }

  ## integrate the equations
  out = ode(y=c(rhoc0,rhon0,rhop0,rhos0), times=t, func=derivs, parms=NULL, method="lsoda")

  ## return in a data frame
  return(data.frame(t=out[,1], rhoc=out[,2], rhon=out[,3], rhop=out[,4], rhos=out[,5]))

}

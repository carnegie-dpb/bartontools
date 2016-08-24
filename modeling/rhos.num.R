##
## numerically solve for secondary transcription given the functions for nuclear GR-TF and primary transcript concentrations
##
## Note: gammae == 0 since analytic rhop doesn't include gammae
##

require("deSolve")
source("rhop.R")

rhos.num = function(turnOff=0, rhoc0,rhon0,nu, rhop0,etap,gammap, rhos0,etas,gammas, t) {

  ## derivative for rhos
  rhosdot = function(t, y, parms) {
    rhos = y[1]

    ## rhop from analytic solution
    rhop = rhop(turnOff=turnOff, t=t, rhoc0=rhoc0,nu=nu, rhop0=rhop0,etap=etap,gammap=gammap)
    
    ## deriv
    return( list( c(
      +etas*rhop - gammas*(rhos-rhos0)
      )))
  }

  ## integrate the equations
  out = ode(y=c(rhos0), times=t, func=rhosdot, parms=NULL, method="lsoda")

  ## return rhos, t=out[,1]
  return(out[,2])

}

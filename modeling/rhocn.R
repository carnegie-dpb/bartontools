##
## numerically solve the nuclear import model 
## return the PERCENTAGE of nuclear and cytoplasmic to total GR in a data frame
##

require("deSolve")

rhocn = function(rhoc0, rhon0, nu, gammae, gamman, t) {

  ## derivatives for rhoc and rhon
  derivs = function(t, y, parms) {
    rhoc = y[1]
    rhon = y[2]
    return( list( c(
      -nu*rhoc + gammae*rhon,
      nu*rhoc - gammae*rhon - gamman*(rhon-rhon0)
      )))
  }

  ## integrate the equations
  out = ode(y=c(rhoc0,rhon0), times=t, func=derivs, parms=NULL)

  ## papers report the PERCENTAGE of nuclear to total GR, so let's use that, as well as percentage of cytoplasmic
  rhocFrac = out[,2]/(out[,2]+out[,3])*100
  rhonFrac = out[,3]/(out[,2]+out[,3])*100

  return(data.frame(t=t, rhoc=rhocFrac, rhon=rhonFrac))

}

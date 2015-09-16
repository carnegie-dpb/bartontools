##
## compare analytic against numerical integration
##

source("rhoc.R")
source("rhon.R")
source("rhop.R")
source("rhos.R")
source("rhocnps.R")

compare = function(eqn="s", turnOff=0, rhoc0=20,rhon0=1,nu=10,gamman=0.825,gammae=0, rhop0=1,etap=1,gammap=2, rhos0=1,etas=1,gammas=1) {

  t = (0:500)/100
  model = rhocnps(turnOff=turnOff, t=t, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gammae=gammae,gamman=gamman, rhop0=rhop0,etap=etap,gammap=gammap, rhos0=rhos0,etas=etas,gammas=gammas)
  
  if (eqn=="c") {
    analytic = rhoc(t=t, rhoc0=rhoc0,nu=nu)
    plot(t, model$rhoc, pch=3)
    lines(t, analytic, col="red")
    lines(t, analytic-model$rhoc, col="red", lty=2)
  } else if (eqn=="n") {
    analytic = rhon(t=t, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman)
    plot(t, model$rhon, pch=3)
    lines(t, analytic, col="red")
    lines(t, analytic-model$rhon, col="red", lty=2)
  } else if (eqn=="p") {
    analytic = rhop(t=t, turnOff=turnOff, rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0,etap=etap,gammap=gammap)
    plot(t, model$rhop, pch=3)
    lines(t, analytic, col="red")
    lines(t, analytic-model$rhop, col="red", lty=2)
  } else if (eqn=="s") {
    ## don't have turnOff yet in rhos.R
    analytic = rhos(t=t, rhoc0=rhoc0,nu=nu,gamman=gamman, etap=etap,gammap=gammap, rhos0=rhos0,etas=etas,gammas=gammas)
    plot(t, model$rhos, pch=3)
    lines(t, analytic, col="red")
    lines(t, analytic-model$rhos, col="red", lty=2)
  }


}
  

    


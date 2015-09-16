## transcript concentration in nucleus
##
## rhoc0 = initial cytoplasmic TF concentration
## nu = nuclear TF import rate
## gamman = nuclear TF loss rate
##
## rhop0 = initial nuclear target concentration
## etap = transcription rate of target
## gammap = loss rate of target
##
## t = time (array)

rhop = function(turnOff=0, t, rhoc0, nu, gamman, rhop0, etap, gammap) {
  if (nu!=gamman && gammap!=gamman) A = rhoc0*etap*nu/((nu-gamman)*(gammap-gamman))
  if (nu!=gamman && nu!=gammap) B = rhoc0*etap*nu/((nu-gamman)*(nu-gammap))
  if (nu!=gammap && gammap!=gamman) C = -rhoc0*etap*nu/((nu-gammap)*(gammap-gamman))
  if (nu==gamman && gamman==gammap) {
    f = rhop0 + rhoc0*etap*nu/2*t^2*exp(-nu*t)
  } else if (gammap==0 && gamman==0) {
    f = rhop0 + rhoc0*etap/nu*(exp(-nu*t)+nu*t-1)
  } else if (nu==gamman && gamman==gammap) {
    f = rhop0 + rhoc0*etap*nu*t^2/2*exp(-nu*t)
  } else if (gammap==gamman) {
    AA = rhoc0*etap*nu/(nu-gamman)
    f = rhop0 + AA*t*exp(-gamman*t) - B*exp(-gamman*t) + B*exp(-nu*t) 
  } else if (nu==gamman) {
    BB = -rhoc0*etap*nu/(nu-gammap)
    f = rhop0 + BB*t*exp(-nu*t) - C*exp(-nu*t) + C*exp(-gammap*t) 
  } else if (nu==gammap) {
    BB = -rhoc0*etap*nu/(nu-gamman)
    f = rhop0 + A*exp(-gamman*t) + BB*t*exp(-nu*t) - A*exp(-nu*t)
  } else {
    f = rhop0 + A*exp(-gamman*t) + B*exp(-nu*t) +C*exp(-gammap*t)
  }
  f[t<0] = rhop0
  if (turnOff>0) {
    ## this is recursive, but it works
    rhop.turnOff = rhop(turnOff=0, rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0,etap=etap,gammap=gammap, t=turnOff)
    f[t>turnOff] = rhop0 + (rhop.turnOff-rhop0)*exp(-gammap*(t[t>turnOff]-turnOff))
  }
  return(f)
}

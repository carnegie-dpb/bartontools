## transcript concentration in nucleus
##
## t = time
##
## rhoc0 = initial cytoplasmic TF concentration
## nu = nuclear TF import rate
## gamman = nuclear TF loss rate
##
## etap = transcription rate of primary target
## gammap = loss rate of primary target
##
## rhos0 = initial secondary target concentration
## etas = transcription rate of secondary target
## gammas = loss rate of secondary target

rhos = function(t, rhoc0,nu,gamman, etap,gammap, rhos0,etas,gammas) {
  if (nu!=gamman && gammap!=gamman) {
    A = rhoc0*etap*nu/((nu-gamman)*(gammap-gamman))
    if (gammas!=gamman) a = etas*A/(gammas-gamman)
  }
  if (nu!=gamman && nu!=gammap) {
    B = rhoc0*etap*nu/((nu-gamman)*(nu-gammap))
    if (nu!=gammas) b = -etas*B/(nu-gammas)
  }
  if (nu!=gammap && gammap!=gamman) {
    C = -rhoc0*etap*nu/((nu-gammap)*(gammap-gamman))
    if (gammap!=gammas) c = -etas*C/(gammap-gammas)
  }
  ##
  if (nu==gamman && gamman==gammap && gammap==gammas) {
    BB = rhoc0*etap*nu/2
    bb = etas*BB/3
    f = rhos0 + bb*t^3*exp(-nu*t)
  } else if (gamman==gammap && gammap==gammas) {
    AA = rhoc0*etap*nu/(nu-gamman)
    a1 = -etas*B
    a2 = etas*AA/2
    d = -b
    f = rhos0 + (a1*t+a2*t^2+d)*exp(-gamman*t) + b*exp(-nu*t)
  } else if (nu==gammap && gammap==gammas) {
    BB = -rhoc0*etap*nu/(nu-gamman)
    b1 = -etas*A
    b2 = etas*BB/2
    d = -a
    f = rhos0 + a*exp(-gamman*t) + (b1*t+b2*t^2+d)*exp(-nu*t)
  } else if (gammas==0 && gammap==0 && gamman==0) {
    f = rhos0 + rhoc0*etas*etap/nu^2*((1-exp(-nu*t)) - nu*t + (nu*t)^2/2)
  } else if (nu==gamman && gamman==gammas) {
    BB = -rhoc0*etap*nu/(nu-gammap)
    b1 = -etas*C
    b2 = etas*BB/2
    d = -c
    f = rhos0 + (b1*t+b2*t^2+d)*exp(-nu*t) + c*exp(-gammap*t)
  } else if (gammap==0 && gamman==0) {
    b1 = -rhoc0*etas*etap/nu/(nu-gammas)
    b2 = rhoc0*etas*etap
    b3 = -rhoc0*etas*etap/nu/gammas^2*(nu+gammas)
    dd = -(b1+b3)
    f = rhos0 + b1*exp(-nu*t) + b2*t + b3 + dd*exp(-gammas*t)
  } else if (gammas==0 && gammap==0) {
    f = rhos0 + etas*A/gamman*(1-exp(-gamman*t)) + etas*B/nu*(1-exp(-nu*t)) + etas*C*t
  } else if (gamman==gammap && gammap==gammas) {
    AA = rhoc0*etap*nu/(nu-gamman)
    a1 = -etas*B
    a2 = etas*AA/2
    d = -b
    f = rhos0 + (a1*t+a2*t^2+d)*exp(-gamman*t) + b*exp(-nu*t)
  } else if (nu==gamman && nu==gammap) {
    a1 = -rhoc0*etas*etap*nu/2/(nu-gammas)
    a2 = a1*2/(nu-gammas)
    a3 = a2/(nu-gammas)
    d = -a3
    f = rhos0 + (a1*t^2+a2*t+a3)*exp(-nu*t) + d*exp(-gammas*t)
  } else if (nu==gamman && gammap==gammas) {
    BB = -rhoc0*etap*nu/(nu-gammap)
    cc = etas*C
    bb2 = -etas*BB/(nu-gammap)
    bb1 = (etas*C+bb2)/(nu-gammap)
    d = -bb1
    f = rhos0 + (bb1+bb2*t)*exp(-nu*t) + (cc*t+d)*exp(-gammap*t)
  } else if (nu==gammas && gamman==gammap) {
    AA = rhoc0*etap*nu/(nu-gamman)
    aa1 = -etas*B/(nu-gamman) -etas*AA/(nu-gamman)^2
    aa2 = etas*AA/(nu-gamman)
    bb = etas*B
    d = -aa1
    f = rhos0 + aa1*exp(-gamman*t) + aa2*t*exp(-gamman*t) + bb*t*exp(-nu*t) + d*exp(-nu*t)
  } else if (nu==gammap && gamman==gammas) {
    BB = -rhoc0*etap*nu/(nu-gamman)
    a1 = etas*A
    b1 = -etas*BB/(nu-gamman)
    bb = (etas*A+b1)/(nu-gamman)
    d = -bb
    f = rhos0 + (bb+b1*t)*exp(-nu*t) + (a1*t+d)*exp(-gamman*t)
  } else if (nu==gamman) {
    BB = -rhoc0*etap*nu/(nu-gammap)
    bb2 = -etas*BB/(nu-gammas)
    bb1 = (etas*C+bb2)/(nu-gammas)
    dd = -(bb1+c)
    f = rhos0 + bb1*exp(-nu*t) + bb2*t*exp(-nu*t) + c*exp(-gammap*t) + dd*exp(-gammas*t)
  } else if (nu==gammap) {
    BB = -rhoc0*etap*nu/(nu-gamman)
    bb = -etas*BB/(nu-gammas)
    cc = (etas*A+bb)/(nu-gammas)
    dd = -(a+cc)
    f = rhos0 + a*exp(-gamman*t) + bb*t*exp(-nu*t) + cc*exp(-nu*t) + dd*exp(-gammas*t)
  } else if (gammap==gamman) {
    AA = rhoc0*etap*nu/(nu-gamman)
    aa2 = etas*AA/(gammas-gamman)
    aa1 = -etas*AA/(gammas-gamman)^2 -etas*B/(gammas-gamman)
    dd = -(b+aa1)
    f = rhos0 + aa1*exp(-gamman*t) + aa2*t*exp(-gamman*t) + b*exp(-nu*t) + dd*exp(-gammas*t)
  } else if (gammas==gamman) {
    aa = etas*A
    dd = -(b+c)
    f = rhos0 + aa*t*exp(-gamman*t) + b*exp(-nu*t) + c*exp(-gammap*t) + dd*exp(-gamman*t)
  } else if (nu==gammas) {
    bb = etas*B
    dd = -(a+c)
    f = rhos0 + a*exp(-gamman*t) + bb*t*exp(-nu*t) + c*exp(-gammap*t) + dd*exp(-nu*t)
  } else if (gammap==gammas) {
    cc = etas*C
    dd = -(a+b)
    f = rhos0 + a*exp(-gamman*t) + b*exp(-nu*t) + (cc*t+dd)*exp(-gammap*t)
  } else {
    ## general case
    d = -(a+b+c)
    f = rhos0 + a*exp(-gamman*t) + b*exp(-nu*t) + c*exp(-gammap*t) + d*exp(-gammas*t)
  }
  ##
  f[t<0] = rhos0
  return(f)
}

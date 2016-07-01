## transcript concentration in nucleus
##
## rhoc0 = initial cytoplasmic TF concentration
## nu = nuclear TF import rate
##
## rhop0 = initial nuclear target concentration
## etap = transcription rate of target
## gammap = loss rate of target
##
## t = time (array)
##
## NOTE: these solutions are for gamman = 0
##
## Solutions provided by Sage Math

rhop = function(t=0:1000/500, rhoc0=10, rhon0=1, nu=10, rhop0=1, etap=2, gammap=3, turnOff=0) {

    if (nu==gammap) {

        f = rhop0 - etap*rhoc0*t*e^(-nu*t) + etap*rhoc0/nu - etap*rhoc0*e^(-nu*t)/nu

    } else {

        f = rhop0 - etap*rhoc0*exp(-nu*t)/(gammap - nu) + etap*rhoc0/gammap + etap*nu*rhoc0*exp(-gammap*t)/(gammap^2 - gammap*nu)
 
    }

    if (turnOff>0) {

        f[t>turnOff] = rhop0 + (rhop(t=turnOff,rhoc0=rhoc0,rhon0=rhon0,nu=nu,rhop0=rhop0,etap=etap,gammap=gammap,0)-rhop0)*exp(-gammap*(t[t>turnOff]-turnOff))

    }

    f[t<0] = rhop0

    return(f)
    
}

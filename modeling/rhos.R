## transcript concentration in nucleus
##
## rhoc0 = initial cytoplasmic TF concentration
## nu = nuclear TF import rate
##
## etap = transcription rate of primary target
## gammap = loss rate of primary target
##
## rhos0 = initial secondary target concentration
## etas = transcription rate of secondary target
## gammas = loss rate of secondary target
##
## t = time array
##
## NOTE: these solutions are for gamman = 0
##
## Solutions provided by Sage Math


rhos = function(t=0:1000/500, rhoc0=10, rhon0=1, rhos0=1, nu=10, etap=2, gammap=3, etas=4, gammas=5) {

    if (nu==gammap && gammap==gammas) {

       f = rhos0 - etap*rhoc0*t*exp(-nu*t) + etap*rhoc0/nu - etap*rhoc0*exp(-nu*t)/nu
        
    } else if (nu==gammap && gammap!=gammas) {

        f = rhos0 - etap*etas*rhoc0*t*exp(-nu*t)/(gammas-nu) + etap*etas*rhoc0/(gammas*nu) - (etap*etas*nu*rhoc0)*exp(-gammas*t) / (gammas^3 - 2*gammas^2*nu + gammas*nu^2) + (- (etap*etas*gammas - 2*etap*etas*nu)*rhoc0)*exp(-nu*t) / (gammas^2*nu - 2*gammas*nu^2 + nu^3)

    } else if (nu!=gammap && gammap==gammas) {
        f = rhos0 + etap*etas*nu*rhoc0*t*exp(-gammap*t)/(gammap^2 - gammap*nu) - etap*etas*rhoc0*exp(-nu*t)/(gammap^2 - 2*gammap*nu + nu^2) + etap*etas*rhoc0/gammap^2 + ((2*etap*etas*gammap*nu - etap*etas*nu^2)*rhoc0)*exp(-gammap*t) / (gammap^4 - 2*gammap^3*nu + gammap^2*nu^2)

    } else {

        f = rhos0 -etap*etas*rhoc0*exp(-nu*t)/(gammap*gammas - (gammap + gammas)*nu + nu^2) + etap*etas*rhoc0/(gammap*gammas) - (etap*etas*nu*rhoc0)*exp(-gammap*t)/(gammap^3 - gammap^2*gammas - (gammap^2 - gammap*gammas)*nu) + (etap*etas*nu*rhoc0)*exp(-gammas*t) / (gammap*gammas^2-gammas^3-(gammap*gammas-gammas^2)*nu)
        
    }
    
    f[t<0] = rhos0

    return(f)

}

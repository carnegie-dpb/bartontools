## GR concentration in nucleus; nu=nuclear import rate, gamman=nuclear loss rate
##
## rhoc0 = initial cytoplasmic GR concentration
## rhon0 = initial nuclear GR concentration
## nu = nuclear GR import rate
## gamman = nuclear GR loss rate

rhon = function(t=0:1000/500, rhoc0=10, rhon0=1, nu=10) {
    f = rhon0 + rhoc0*(1 - exp(-nu*t))
    f[t<0] = rhon0
    return(f)
}

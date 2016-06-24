## GR-TF concentration in cytoplasm
##
## rhoc0 = initial cytoplasmic TF concentration
## nu = nuclear TF import rate

rhoc = function(t=0:1000/500, rhoc0=10, nu=10) {
    f = rhoc0*exp(-nu*t)
    f[t<0] = rhoc0
    return(f)
}


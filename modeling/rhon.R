## GR concentration in nucleus; nu=nuclear import rate, gamman=nuclear loss rate
##
## rhoc0 = initial cytoplasmic GR concentration
## rhon0 = initial nuclear GR concentration
## nu = nuclear GR import rate
## gamman = nuclear GR loss rate

rhon = function(rhoc0, rhon0, nu, gamman, t) {
  if (nu==gamman) {
    f = rhon0 + rhoc0*nu*t*exp(-nu*t)
  } else {
    f = rhon0 + rhoc0*nu/(nu-gamman)*(exp(-gamman*t)-exp(-nu*t))
  }
  f[t<0] = rhon0
  return(f)
}

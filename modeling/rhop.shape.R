## simple function giving the shape of a gamman=0 rhop curve

rhop.shape = function(t, nu, gammap) {
  if (nu==gammap) {
    return(1 - exp(-nu*t)*(1+gammap*t))
  } else {
    return(1 - (nu*exp(-gammap*t)-gammap*exp(-nu*t))/(nu-gammap))
  }
}
  



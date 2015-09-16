## GR-TF concentration in cytoplasm
##
## rhoc0 = initial cytoplasmic TF concentration
## nu = nuclear TF import rate

rhoc = function(rhoc0, nu, t) {
  return(rhoc0*exp(-nu*t))
}


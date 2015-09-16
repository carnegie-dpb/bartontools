##
## return the error metric for modeling a direct target, for nlm usage
##

require("deSolve")

## the transcription model to be minimized
transmodel.error = function(p) {

  r = p[1]
  gamma = p[2]
  gamma12 = p[3]
  gamma2 = p[4]

  ## Dex concentration is step rise with linear fall to tmax
  D = function(t) {
    if (t<0) {
      return(0.0)
    } else if (t<tmax) {
      return(1.0-t/tmax)
    } else {
      return(0.0)
    }
  }

  ## derivative of c1, TF concentration
  dc1dt = function(t, y, parms) {
    return(list(c( r*D(t)-gamma*(y[1]-1) )))
  }

  ## calculate TF concentration; starting relative concentration is 1 by definition
  c1 = ode(y=c(1), times=times, func=dc1dt, parms=NULL)

  ## derivatives for the target concentration c2
  dc2dt = function(t, y, parms) {
    c1t = approx(c1[,1],c1[,2],t)$y
    c2t = y[1]
    return( list( c( -gamma2*(c2t-1)+gamma12*(c1t-1) )))
  }

  ## calculate target concentration; starting relative concentrations are 1 by definition
  c2 = ode(y=c(1), times=times, func=dc2dt, parms=NULL)
  

  ## normalize data to mean of t=0 values
  zeros = (dataTimes==0)
  zeroValue = mean(dataValues[zeros])
  dataValues = dataValues/zeroValue
  
  ## error metric is mean square relative deviation
  meansq = 0.0
  for (i in 1:length(dataTimes)) {
    val = approx(c2[,1],c2[,2],dataTimes[i])$y
    meansq = meansq + ((val-dataValues[i])/val)^2
  }

  return(meansq)

}

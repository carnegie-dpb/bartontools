##
## select rows from fit data frames according to filter criteria here for each group
##

select = function(fits, group) {

  ## earlies
  if (group=="E") {
    pass = fits[
      fits$R2.0.5 > 0.6 & fits$gammap.0.5 > -0.05  & 
      ((fits$gammap < -0.05 & fits$gammap.1.0 < -0.05) | (fits$gammap>10 & fits$gammap.1.0>10) | (fits$R2.0.5>fits$R2 & fits$R2.0.5>fits$R2.1.0))
      , ]
  }
  
  ## middles
  if (group=="M") {
    pass = fits[
      fits$R2.1.0 > 0.6 & fits$gammap.1.0 > -0.05 & 
      ((fits$gammap < -0.05 & fits$gammap.0.5 < -0.05) | (fits$gammap>10 & fits$gammap.0.5>10) | (fits$R2.1.0>fits$R2 & fits$R2.1.0>fits$R2.0.5))
      , ]
  }

  ## lates
  if (group=="L") {
    pass = fits[
      fits$R2 > 0.6 & fits$gammap > -0.05 &
      ((fits$gammap.0.5 < -0.05 & fits$gammap.1.0 < -0.05) | (fits$gammap.0.5>10 & fits$gammap.1.0>10) | (fits$R2>fits$R2.0.5 & fits$R2>fits$R2.1.0))
      , ]
  }

  ## secondaries
  if (group=="S") {
    pass = fits[fits$gammap < -0.05 & fits$gammap.0.5 < -0.05 & fits$gammap.1.0 < -0.05,]
  }

  return(
    data.frame(row.names=row.names(pass), symbol=pass$symbol,
               gammap=pass$gammap, R2=pass$R2,
               gammap.0.5=pass$gammap.0.5, R2.0.5=pass$R2.0.5,
               gammap.1.0=pass$gammap.1.0, R2.1.0=pass$R2.1.0)
    )

}

  


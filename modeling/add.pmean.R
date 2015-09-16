## add the geometric mean of p, plus the highest of the three R2 values

add.pmean = function(df) {

  for (i in 1:dim(df)[1]) {
    df$p.gmean[i] = exp(mean(log(c(df$p.30[i],df$p.60[i],df$p.120[i]))))
    df$R2[i] = max(c(df$R2.E[i],df$R2.M[i],df$R2.L[i]))
  }

  return(df)

}


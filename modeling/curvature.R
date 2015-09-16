##
## return the curvature of a quadratic fit to the given FPKM expression, normalized to FPKM(0)
##
curvature = function(times, values) {
  c = lm(values ~ times + I(times^2))
  print(paste("NormCurv=", as.numeric(c$coefficients[3]/mean(values[1:3])), "AdjR-Squared=", summary(c)$adj.r.squared))
}

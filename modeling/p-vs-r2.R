## plot p vs R2 along with a significance line

ymin = 1e-8 # bl2012
## ymin = 5e-5 # bl2013

plot(bl2012.compare$R2, bl2012.compare$p.gmean, xlim=c(0,1), log="y", ylim=c(ymin,1), pch=16,cex=0.4,
     xlab=expression(paste("model fit coefficient of determination"," (",r^2,")")), ylab="geometric mean of time-wise DE p-values")

pmin = .00490 # bl2012
## pmin = .00105 # bl2013

lines(c(0,1), c(pmin,pmin), lwd=2)
lines(c(0.6,0.6), c(0.75*ymin,1.5), lty=2, lwd=2)

text(0.05, pmin, pos=1, expression(q<0.05))
text(0.05, pmin, pos=3, expression(q>0.05))

text(0.6, ymin, pos=2, "14%")
text(0.6, ymin, pos=4, "86%")

text(0.6, 1, pos=2, "88%")
text(0.6, 1, pos=4, "12%")

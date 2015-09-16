##
## make a nice plot of tpeak stored in a file
##
## gamman=0.7, nu=10

df = read.table("tmax-v-gammap.txt")
plot(df$tmax, df$gammap, type="l", lwd=2, ylab=expression(paste(gamma[p]," ",(h^-1))), xlab=expression(paste(t[peak]," ",(h))), log="y", ylim=c(.1,10), xlim=c(0,3) )

rect(1.5,0.01, 4,0.67, col="grey", border=NA)
rect(0.75,0.67, 1.5,2.90, col="grey", border=NA)
rect(0,2.90, 0.75,100, col="grey", border=NA)

lines(c(0.75,0.75), c(0.01,100), lty=3)
lines(c(1.5,1.5), c(0.01,100), lty=3)

lines(c(-1,4), c(2.90,2.90), lty=3)
lines(c(-1,4), c(0.67,0.67), lty=3)

lines(c(0.0,0.0), c(0.01,.11), lty=1, lwd=5)
lines(c(0.5,0.5), c(0.01,.11), lty=1, lwd=5)
lines(c(1.0,1.0), c(0.01,.11), lty=1, lwd=5)
lines(c(2.0,2.0), c(0.01,.11), lty=1, lwd=5)


text(2.3, 0.3, pos=4, "L", cex=2)
text(1.0, 2.0, pos=4, "M", cex=2)
text(0.25, 5.0, pos=4, "E", cex=2)

lines(df$tmax, df$gammap, lwd=2)


## text(3.5, 0.2, pos=4, "VERY EARLY -->")





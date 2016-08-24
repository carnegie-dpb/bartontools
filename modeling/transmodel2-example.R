##
## plot an example of primary and secondary transcription modeling
##

source("rhon.R")
source("rhop.R")
source("rhos.R")

oldpar = par(mar=c(4,4,4,4), mgp=c(2,0.5,0))

t = 0:400/100
tex = c(0.5,1,2)

nu = 10

rhon0 = 1
rhoc0 = 25

rhop0 = 1
rhos0 = 1

## (a)
etap1 = 2
gammap1 = 4

## (b)
etap2 = 1
gammap2 = 4

## (c)
etap3 = -0.14
gammap3 = 4

## (a)
etas1 = 1
gammas1 = 1

## (b)
etas2 = 1
gammas2 = 1

## (c)
etas3 = 1
gammas3 = 1

print(1+etap1/gammap1*rhoc0/rhop0)
print(1+etap2/gammap2*rhoc0/rhop0)

#########################################################################

rhop1 = rhop(rhoc0=rhoc0, nu=nu, rhop0=rhop0, etap=etap1, gammap=gammap1, t=t)
rhos1 = rhos(rhoc0=rhoc0, nu=nu, etap=etap1, gammap=gammap1, rhos0=rhos0, etas=etas1, gammas=gammas1, t=t)

plot(t, rhop1, lty=1, lwd=1.5, type="l", log="y", ylim=c(.1,20), xlab="time (h)", ylab="mRNA concentrations", col="red")
lines(t, rhos1, lty=2, lwd=1.5, col="red")

rhop1ex = rhop(rhoc0=rhoc0, nu=nu, rhop0=rhop0, etap=etap1, gammap=gammap1, t=tex)
rhos1ex = rhos(rhoc0=rhoc0, nu=nu, etap=etap1, gammap=gammap1, rhos0=rhos0, etas=etas1, gammas=gammas1, t=tex)

points(tex, rhop1ex, pch=21, cex=4, bg="white", col="white")
points(tex, rhos1ex, pch=21, cex=4, bg="white", col="white")

text(tex, rhop1ex, sprintf("%.1f",round(log2(rhop1ex),1)), cex=1, col="red")
text(tex, rhos1ex, sprintf("%.1f",round(log2(rhos1ex),1)), cex=1, col="red")

# text(tex[3]-0.03, rhos1ex[3]-0.05, "logFC=", pos=2)

#########################################################################

rhop2 = rhop(rhoc0=rhoc0, nu=nu, rhop0=rhop0, etap=etap2, gammap=gammap2, t=t)
rhos2 = rhos(rhoc0=rhoc0, nu=nu, etap=etap2, gammap=gammap2, rhos0=rhos0, etas=etas2, gammas=gammas2, t=t)
lines(t, rhop2, lty=1, lwd=1.5, col="darkgreen")
lines(t, rhos2, lty=2, lwd=1.5, col="darkgreen")

rhop2ex = rhop(rhoc0=rhoc0, nu=nu, rhop0=rhop0, etap=etap2, gammap=gammap2, t=tex)
rhos2ex = rhos(rhoc0=rhoc0, nu=nu, etap=etap2, gammap=gammap2, rhos0=rhos0, etas=etas2, gammas=gammas2, t=tex)

points(tex, rhop2ex, pch=23, cex=4, bg="white", col="white")
points(tex, rhos2ex, pch=23, cex=4, bg="white", col="white")

text(tex, rhop2ex, sprintf("%.1f",round(log2(rhop2ex),1)), cex=1, col="darkgreen")
text(tex, rhos2ex, sprintf("%.1f",round(log2(rhos2ex),1)), cex=1, col="darkgreen")

#########################################################################

rhop3 = rhop(rhoc0=rhoc0, nu=nu, rhop0=rhop0, etap=etap3, gammap=gammap3, t=t)
rhos3 = rhos(rhoc0=rhoc0, nu=nu, etap=etap3, gammap=gammap3, rhos0=rhos0, etas=etas3, gammas=gammas3, t=t)
lines(t, rhop3, lty=1, lwd=1.5, col="blue")
lines(t, rhos3, lty=2, lwd=1.5, col="blue")

rhop3ex = rhop(rhoc0=rhoc0, nu=nu, rhop0=rhop0, etap=etap3, gammap=gammap3, t=tex)
rhos3ex = rhos(rhoc0=rhoc0, nu=nu, etap=etap3, gammap=gammap3, rhos0=rhos0, etas=etas3, gammas=gammas3, t=tex)

points(tex, rhop3ex, pch=23, cex=4, bg="white", col="white")
points(tex, rhos3ex, pch=23, cex=4, bg="white", col="white")

text(tex, rhop3ex, sprintf("%.1f",round(log2(rhop3ex),1)), cex=1, col="blue")
text(tex, rhos3ex, sprintf("%.1f",round(log2(rhos3ex),1)), cex=1, col="blue")

#########################################################################

## arrows(tex[1], 1.0, tex[1], 1.1, length=0.06, lwd=2)
## arrows(tex[2], 1.0, tex[2], 1.1, length=0.06, lwd=2)
## arrows(tex[3], 1.0, tex[3], 1.1, length=0.06, lwd=2)

## arrows(tex[1], 1.0, tex[1], 1/1.1, length=0.06, lwd=2)
## arrows(tex[2], 1.0, tex[2], 1/1.1, length=0.06, lwd=2)
## arrows(tex[3], 1.0, tex[3], 1/1.1, length=0.06, lwd=2)

legend(4.0,5.5, xjust=1, yjust=1,
       c(
         expression(rho[p]),
         expression(rho[s]),
         expression(rho[n])
         ),
       lty=c(1,2,3), lwd=1.5)

## text(0.8, 14.0, pos=4, bquote(paste(nu==1," ",h^-1)))
## text(0.5, 16.0, pos=4, bquote(paste(nu==2," ",h^-1)))
## text(0.0, 19.5, pos=4, bquote(paste(nu==10," ",h^-1)))

text(1.5, 8.8, "(a)", col="red")
text(1.5, 4.0, "(b)", col="darkgreen")
text(1.5, 0.2, "(c)", col="blue")

text(3.0, 6^0.3, pos=4, bquote(paste(rho[n0]==.(rhon0),", ",rho[c0]==.(rhoc0))))
text(3.0, 6^0.2, pos=4, bquote(paste(nu==.(nu),", ", gamma[n]==0)))
text(3.0, 6^0.1, pos=4, bquote(paste(rho[p0]==.(rhop0),", ",rho[s0]==.(rhos0))))

text(2.8, 6^-0.1, pos=4, bquote(paste("(a) ",eta[p]==.(etap1),", ",gamma[p]==.(gammap1))))
text(2.8, 6^-0.2, pos=4, bquote(paste("      ",eta[s]==.(etas1),", ",gamma[s]==.(gammas1))))

text(2.8, 6^-0.4, pos=4, bquote(paste("(b) ",eta[p]==.(etap2),", ",gamma[p]==.(gammap2))))
text(2.8, 6^-0.5, pos=4, bquote(paste("      ",eta[s]==.(etas2),", ",gamma[s]==.(gammas2))))

text(2.8, 6^-0.7, pos=4, bquote(paste("(c) ",eta[p]==.(etap3),", ",gamma[p]==.(gammap3))))
text(2.8, 6^-0.8, pos=4, bquote(paste("      ",eta[s]==.(etas3),", ",gamma[s]==.(gammas3))))

## plot TF concentration on right axis, linear
par(new=TRUE)
rhon = rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, t=t)
plot(t, rhon, type="l", lty=3, lwd=1.5, ylim=c(0,26), xlab=NA, ylab=NA, axes=FALSE)
axis(side=4) 
par(new=FALSE)

mtext("nuclear TF concentration", side=4, line=1.5)


par(oldpar)

##
## plot the values of the transgenes at t=0 across conditions
##

source("~/R/getTimes.R")
source("~/R/getExpression.R")

geo = "gse70796"

t = getTimes(schema=geo, condition="ALL")
AS2 = getExpression(schema=geo, condition="ALL", gene="AS2")
STM = getExpression(schema=geo, condition="ALL", gene="STM")
REV = getExpression(schema=geo, condition="ALL", gene="REV")
KAN = getExpression(schema=geo, condition="ALL", gene="KAN1")

cond = c("WT", "GR-AS2", "GR-STM", "GR-REV", "GR-KAN")
condIndex = c(1,1,1,1,1,1, 2,2,2, 3,3,3, 4,4,4, 5,5,5)

baseAS2 = mean(AS2[t==0][condIndex==1])
baseSTM = mean(STM[t==0][condIndex==1])
baseREV = mean(REV[t==0][condIndex==1])
baseKAN = mean(KAN[t==0][condIndex==1])

grAS2 = mean(AS2[t==0][condIndex==2])
grSTM = mean(STM[t==0][condIndex==3])
grREV = mean(REV[t==0][condIndex==4])
grKAN = mean(KAN[t==0][condIndex==5])

plot(condIndex, AS2[t==0], pch=19, cex=1, col="red",
     log="y", ylim=c(1,500), xaxt="n",
     ylab="mRNA expression before DEX (FPKM)", xlab="Plant line")
points(condIndex, STM[t==0], pch=19, cex=1, col="darkgreen")
points(condIndex, REV[t==0], pch=19, cex=1, col="blue")
points(condIndex, KAN[t==0], pch=19, cex=1, col="orange")

lines(c(1,5), c(baseAS2,baseAS2), col="red")
lines(c(1,5), c(baseSTM,baseSTM), col="darkgreen")
lines(c(1,5), c(baseREV,baseREV), col="blue")
lines(c(1,5), c(baseKAN,baseKAN), col="orange")

axis(side=1, at=c(1,2,3,4,5), labels=cond)

legend(1, 100, xjust=0, yjust=1, pch=19, cex=1, col=c("red","darkgreen","blue","orange"),
       c(paste("AS2  ratio =",bquote(.(round(grAS2/baseAS2),0))),
         paste("STM  ratio =",bquote(.(round(grSTM/baseSTM),0))),
         paste("REV  ratio =",bquote(.(round(grREV/baseREV),0))),
         paste("KAN  ratio =",bquote(.(round(grKAN/baseKAN),0)))
         )
       )




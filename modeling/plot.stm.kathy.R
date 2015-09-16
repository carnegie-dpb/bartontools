## a plot for Kathy

t = getTimes(schema="bl2013", condition="GR-STM")

HSP90.1 = getExpression(schema="bl2013", condition="GR-STM", gene="HSP90.1")                                                                                                          
BCAT2 = getExpression(schema="bl2013", condition="GR-STM", gene="BCAT-2")> BCAT2
LOL1 = getExpression(schema="bl2013", condition="GR-STM", gene="LOL1")
TINY2 = getExpression(schema="bl2013", condition="GR-STM", gene="TINY2")
AT1G30280 = getExpression(schema="bl2013", condition="GR-STM", gene="AT1G30280")
AT1G44760 = getExpression(schema="bl2013", condition="GR-STM", gene="AT1G44760")


plot.bars(t, HSP90.1/mean(HSP90.1[1:3]), xlab="time after DEX application (min)", ylab="relative expression", pch=9, log="y", ylim=c(.1,10))
plot.bars(t, BCAT2/mean(BCAT2[1:3]), over=T, pch=0)
plot.bars(t, LOL1/mean(LOL1[1:3]), over=T, pch=1)
plot.bars(t, TINY2/mean(TINY2[1:3]), over=T, pch=2)
plot.bars(t, AT1G30280/mean(AT1G30280[1:3]), over=T, pch=5)
plot.bars(t, AT1G44760/mean(AT1G44760[1:3]), over=T, pch=6)

legend(80, 0.1, yjust=0, pch=c(9,0,1,2,5,6), c("HSP90.1","BCAT2","LOL1","TINY2","At1g30280","At1g44760"))

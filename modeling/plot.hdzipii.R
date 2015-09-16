##
## overplot the early HD-ZIPII genes
##

source("../R/plot.bars.R")
source("../R/getTimes.R")
source("../R/getExpression.R")

t.12 = getTimes(schema="bl2012",condition="GR-REV")
t.13 = getTimes(schema="bl2013",condition="GR-REV")

expr.12.hb2 = getExpression(schema="bl2012",condition="GR-REV",gene="HB-2")
expr.12.hat1  = getExpression(schema="bl2012",condition="GR-REV",gene="At4g17460")
expr.12.hat22 = getExpression(schema="bl2012",condition="GR-REV",gene="At4g37790")

expr.13.hb2 = getExpression(schema="bl2013",condition="GR-REV",gene="HB-2")
expr.13.hat1  = getExpression(schema="bl2013",condition="GR-REV",gene="At4g17460")
expr.13.hat22 = getExpression(schema="bl2013",condition="GR-REV",gene="At4g37790")

base.12.hb2 = mean(expr.12.hb2[1:3])
base.12.hat1 = mean(expr.12.hat1[1:3])
base.12.hat22 = mean(expr.12.hat22[1:3])

base.13.hb2 = mean(expr.13.hb2[1:3])
base.13.hat1 = mean(expr.13.hat1[1:3])
base.13.hat22 = mean(expr.13.hat22[1:3])

plot.bars(bl2012.times, expr.12.hb2/base.12.hb2, pch=21, log="y", ylim=c(.5,5))
plot.bars(bl2012.times, expr.12.hat1/base.12.hat1, pch=22, over=T)
plot.bars(bl2012.times, expr.12.hat22/base.12.hat22, pch=23, over=T)

plot.bars(bl2013.times, expr.13.hb2/base.13.hb2, pch=21, over=T, bg="grey")
plot.bars(bl2013.times, expr.13.hat1/base.13.hat1, pch=22, over=T, bg="grey")
plot.bars(bl2013.times, expr.13.hat22/base.13.hat22, pch=23, over=T, bg="grey")


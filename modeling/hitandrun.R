##
## plot several fits of "hit and run" expression
##

transmodel.num(etap=21, gammap=4, dataTimes=BL2012.GR.REV.times, dataValues=BL2012.GR.REV.HAT22, dataLabel="BL2012 GR-REV:HAT22")
transmodel.num(etap=.31, gammap=1, dataTimes=BL2013.GR.REV.times, dataValues=BL2013.GR.REV.HAT22, dataLabel="BL2013 GR-REV:HAT22")

transmodel.fit(schema="bl2012", condition="GR-KAN", gene="At4g37790", gamman=1, etap=-6, rhoc0=99, rhon0=1, dataLabel="BL2012 GR-KAN:HAT22")
transmodel.fit(schema="bl2013", condition="GR-KAN", gene="At4g37790", gamman=1, rhoc0=99, rhon0=1, dataLabel="BL2013 GR-KAN:HAT22")

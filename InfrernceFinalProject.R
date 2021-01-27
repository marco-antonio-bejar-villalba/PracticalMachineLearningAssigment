require(ggplot2)
require(RColorBrewer)
require(reshape2)
require(ggthemes)

summary(mtcars)

mtcars$transmition<-factor(mtcars$am,labels = c("automatic","manual"))
mtcars$cyl<-factor(mtcars$cyl)
mtcars$vs<-factor(mtcars$vs)
mtcars$gear<-factor(mtcars$gear)
mtcars$carb<-factor(mtcars$carb)


gg<-ggplot(data=mtcars,aes(transmition,mpg))
gg<-gg+geom_boxplot(aes(fill=transmition))
gg<-gg+theme_economist()
gg<-gg+scale_fill_brewer(palette = "Purples")

spliteddata<-split(mtcars,mtcars$transmition)

intervalManual<-mean(spliteddata$manual$mpg)+c(-1,1)*qt(0.975,
  nrow(spliteddata$manual)-1)*sd(spliteddata$manual$mpg)/
  sqrt(nrow(spliteddata$manual))

intervalAutomatic<-mean(spliteddata$automatic$mpg)+c(-1,1)*qt(0.975,
  nrow(spliteddata$automatic)-1)*sd(spliteddata$automatic$mpg)/
  sqrt(nrow(spliteddata$automatic))


testMpg<-t.test(spliteddata$automatic$mpg,spliteddata$manual$mpg, 
       alternative = "two.sided", paired=FALSE, var.equal = FALSE)

manualMean<-mean(spliteddata$manual$mpg)
automaticMean<-mean(spliteddata$automatic$mpg)
manualSD<-sd(spliteddata$manual$mpg)
automaticSD<-sd(spliteddata$automatic$mpg)
ddfAtomatic<-nrow(spliteddata$automatic)
ddfManual<-nrow(spliteddata$manual)



xvalues<-seq(12,31,.1)

yValueManual<-dt(xvalues-automaticMean,ddfAtomatic)

yValueAutomatic<-dt(xvalues-manualMean,ddfManual)

primariyDataFrame<-data.frame(x=xvalues,manual=yValueManual,automatic=yValueAutomatic)

finalDataFrame<-melt(primariyDataFrame,id="x")

colnames(finalDataFrame)= c("xval","dy","yval")

gg<-ggplot(data = finalDataFrame,aes(x=xval,y=yval,group=dy, colour=dy))
gg<-gg+geom_line(size=3)
gg<-gg+theme_economist()
gg<-gg+scale_color_brewer(palette = "Purples",type=div)
gg


my_fn <- function(data, mapping, method="lm", ...){
  p <- ggplot(data = data, mapping = mapping) + 
    geom_point() + 
    geom_smooth(method=method, ...)
  p
}

ggpairs(spliteddata$manual, lower = list(continuous = wrap(my_fn)))

ggpairs(spliteddata$automatic, lower = list(continuous = wrap(my_fn)))

fit1<-lm(mpg~cyl+disp+hp+drat+wt+qsec+vs+gear+carb,spliteddata$automatic)
fit2<-lm(mpg~cyl+disp+hp+drat+wt+qsec+vs+gear+carb,spliteddata$manual)


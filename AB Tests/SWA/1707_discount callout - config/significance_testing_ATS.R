##load packages
library(ggplot2)
library(nortest)
library(car)
library(plyr)
library(coin)

## Set working directory
setwd("C:/Users/kelvin.ye/Google Drive/My Documents/Analytics-Kelvin/AB Tests/SWA")

##Load in data - I usually filter out sessions in Alteryx
df1<-read.csv("ATS_filtered.csv", header=T)


## summarize data
summary(df1)

## check data types
str(df1)

### Plot all the data by test and control Offer_Names ###
###                                                   ###

##subset data into high/med as well as mass
df1<-subset(df1, df1$Offer_Name=="Test" |  df1$Offer_Name=="Control")
##df1_med<-subset(df1, df1$Offer_Name=="Mass Control IHG" |  df1$Offer_Name=="Mass Test IHG")

df1<-subset(df1, df1$ATS != 0)

summary(df1)
##summary(df1_med)


## Plot all distribution for tests and control points purchased
##
a_high <-ggplot(df1, aes(x = ATS, fill = Offer_Name)) + geom_histogram(position="dodge")
a_high

##a_med <-ggplot(df1_med, aes(x = ATS, fill = Offer_Name)) + geom_histogram(position="dodge")
##a_med

## Plot log-transformed distribution for tests and control points purchased
##

b_high <-ggplot(df1, aes(x = log(ATS), fill = Offer_Name)) + geom_histogram(position="dodge")
b_high

##b_med_log <- ggplot(df1_med, aes(x = log(ATS), fill = Offer_Name)) + geom_histogram(position="dodge")
##b_med_log 


## Plot average points purchased by test and control

p_high<-ggplot(df1, aes(y = ATS, x=Offer_Name, fill=Offer_Name))+ stat_summary(fun.y="mean", geom="bar")
p_high + labs(y="Average Points Purchased", x="Offer") + theme(axis.text.x = element_text(colour="black",size=14), axis.title.x=element_text(colour="black",size=14), axis.text.y = element_text(colour="black",size=14), axis.title.y=element_text(colour="black",size=14) )


### Test for Significance between Test and Control Offer_Names ###
## Points Purchased ##

## Step 1: assess normality of distributions

#test Points normality high
ad.test(subset(df1, df1$Offer_Name=="Control")$ATS)
cvm.test(subset(df1, df1$Offer_Name=="Control")$ATS)
shapiro.test(subset(df1, df1$Offer_Name=="Control")$ATS)

ad.test(subset(df1, df1$Offer_Name=="Test")$ATS)
cvm.test(subset(df1, df1$Offer_Name=="Test")$ATS)
shapiro.test(subset(df1, df1$Offer_Name=="Test")$ATS)

## Step 2: assess variance between Offer_Names

##look at variance
##df1
var(subset(df1, df1$Offer_Name=="Test")$ATS)
var(subset(df1, df1$Offer_Name=="Control")$ATS)


## Bartlett Test
#raw data 35
bartlett.test(df1$ATS~df1$Offer_Name, data=df1) #variance not significantly different

#log transformed data 35
bartlett.test(log(df1$ATS)~df1$Offer_Name, data=df1) #variance not significantly different


## Step 3: Significance testing points purchased

## tests for location 35%
wilcox.test(df1$ATS~df1$Offer_Name, conf.level=0.05) #0.2104 not significant
t.test(log(df1$ATS)~df1$Offer_Name, conf.level=0.05, var.equal=FALSE) #0.3239 not significant
kruskal.test(ATS~Offer_Name, data=df1) #0.3837 not significant



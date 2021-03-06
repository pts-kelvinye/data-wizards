#########################################
###### Sample Chi Square ###################
#########################################

### create matrix of data
con_h<-matrix(c(7072,27908,34409,136269), ncol=2, byrow=TRUE)

#label the rows and columns
colnames(con_h)<-c("test","control")
rownames(con_h)<-c("transactions", "audience")

#convert object to a contingency table
con_h<-as.table(con_h)

#run chi-square test
chisq.test(con_h)    # 0.8142 insignificant

## if p value <= 0.05 the result is significant
## if p value is > 0.05 and  <= 0.1 the result is marginally significant
## if p value > 0.1 then result is not significant
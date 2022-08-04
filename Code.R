####Read Data------------
library(ggplot2)
library(car)
library(plotly)
library(gridExtra)
library(dplyr)

##Version of R------
R.version.string

df <- read.csv("./ImmoDataNRW.csv", header = TRUE, sep = ",")

dim (df)

##Data Prep##-----
n_distinct(df$regio2)
df_dort <-df[df$regio2 =="Dortmund",]
df_dort$sqmPrice <- df_dort$totalRent/df_dort$livingSpace

df_dort$groupOfFlat[df_dort$typeOfFlat %in% c("apartment")] <- "apartment"
df_dort$groupOfFlat[df_dort$typeOfFlat %in% c("loft", "maisonette", "penthouse", "terraced_flat", "other")] <- "luxurious_artistic_other"
df_dort$groupOfFlat[df_dort$typeOfFlat %in% c("ground_floor", "raised_ground_floor")] <- "r_ground_floor"
df_dort$groupOfFlat[df_dort$typeOfFlat %in% c("roof_storey", "half_basement")] <- "roof_half_basement"

dim (df_dort)

##Removing Missing values##----
countNa <- data.frame(sapply(df_dort, function(y) {
  sum(length(which(is.na(y))))
}))

print(countNa)

##We see variable 'noParkSpaces' has maximum number of NA values, so deleting them. Also the independent variable which are dependent on some other independent variables are deleted here ------
df_dort$noParkSpaces <- NULL
df_dort$ID <- NULL
df_dort$typeOfFlat <- NULL
df_dort$totalRent <- NULL
df_dort$livingSpace <- NULL
df_dort$regio2 <- NULL

##Deleting the rows with at least one missing values
df_final <- df_dort[complete.cases(df_dort),]

dim (df_final)

####Descriptive Statistics------------
#Sample size
table(df_final$groupOfFlat)

#Data Type
str(df_final)

#Data summary
df_s <- data.frame()
for (i in unique(df_final$groupOfFlat)){
  
  df_s <- rbind(df_s,summary(df_final$sqmPrice[df_final$groupOfFlat == i]))
  
}
colnames(df_s) <- c("Min","Q1","Median","Mean","Q3","Max")
df_s


##variables to be as.factor##----
df_final$newlyConst <- as.factor(df_final$newlyConst)
df_final$balcony <- as.factor(df_final$balcony)
df_final$hasKitchen <- as.factor(df_final$hasKitchen)
df_final$lift <- as.factor(df_final$lift)
df_final$garden <- as.factor(df_final$garden)
df_final$condition <- as.factor(df_final$condition)
df_final$lastRefurbish <- as.factor(df_final$lastRefurbish)
df_final$energyEfficiencyClass <- as.factor(df_final$energyEfficiencyClass)
df_final$groupOfFlat <- as.factor(df_final$groupOfFlat)

##AIC BIC Computation##----

predictors <- as.data.frame(colnames(df_final[-11]))
colnames(predictors) <- "regressor"
SubSetResult <- vector()

for (predictorsCounter in 1:nrow(predictors)) {
  
  allMCombn <- combn(x = predictors$regressor, m = predictorsCounter)
  
  for (mCombnCounter in 1:ncol(allMCombn)) {
    
    modelPredictors <- allMCombn[,mCombnCounter]
    
    betaFormula <- character()
    
    for (subPredictorsCounter in 1:predictorsCounter) {
      
      betaFormula <- paste(betaFormula, modelPredictors[subPredictorsCounter], sep = "+")
      
    }
    
    formula <- paste("sqmPrice ~",sub(".","",betaFormula))
    
    reg.lm <- lm(as.formula(formula), df_final)
    
    aic <- AIC(reg.lm)
    
    bic <- BIC(reg.lm)
    
    SubSetResult <- rbind(SubSetResult,c(formula,round(aic, digits = 2),round(bic, digits = 2), predictorsCounter))
    
  }
  
}

SubSetResult <- as.data.frame(SubSetResult)

colnames(SubSetResult) <- c("model","aic","bic","CountOfPredictors")
aicmin <- which.min(SubSetResult$aic)
bicmin <- which.min(SubSetResult$bic)


print(SubSetResult[aicmin,])
print(SubSetResult[bicmin,])

##BestLinearModelestimation----

aic.mdl <- lm(formula = sqmPrice ~ newlyConst+balcony+yearConstructed+hasKitchen+lift+floor+condition+energyEfficiencyClass+groupOfFlat, data = df_final)
summary(aic.mdl)

bic.mdl <- lm(formula = sqmPrice ~ newlyConst+hasKitchen+lift+condition, data = df_final)
summary(bic.mdl)
##par(mfrow = c(2,2))
##plot(aic.mdl)
##plot.new()

##Residual vs Fitted value Plot----
residuals <- df_final$sqmPrice - aic.mdl$fitted.values
plot(aic.mdl$fitted.values, residuals, main = "Residuals Plot",xlab=("Fitted values"), ylab=("Residuals"))
abline(0,0)

##QQ Plot for Normality Assumption----

qqnorm(residuals, xlab=("Quantiles AIC Model"), ylab=("Residuals"))
qqline(residuals)


##ConfidenceInterval----
confint(aic.mdl, level = 0.95)
##Graph##----
##ggplot(df_final, aes(y=sqmPrice, x= aic.mdl$fitted.values))+
  ##geom_point() + ylab("True values") + xlab("Fitted Values")+
  ##theme(plot.title = element_text( 
    ##size = 20, hjust = 0.5), face = "bold", text= element_text(size=20))+
  ##geom_abline(intercept=0, slope=1)




##confint(bic.mdl)
##mod <- lm(sqmPrice~., data = df_final)
##summary(mod)

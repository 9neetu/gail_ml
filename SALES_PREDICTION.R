rm(list = ls())

setwd("C:/Users/Administrator.NOI-RM-AB-DE8/Desktop/PC SOLUTIONS/SALES_PREDICTION")

res <- read.csv("GAIL_DATA1.csv")

res$Calendar.Day <-
  as.Date(res$Calendar.Day, "%d.%m.%Y") #Changes to calender format

summary(res)


sapply(res , function(x)
  class(x))

sapply(res , function(x)
  sum(is.na(x)))  #Returns a list of the same length and doing the fun on it

res$Billing.Type <-
  as.character(res$Billing.Type) #Changes type to chr format

trimws(res$Billing.Type) #Removes the trailing and leading whitespaces

res$Billing.Type <- toupper(res$Billing.Type)#Converts to uppercase

library(dplyr)

exportDATA <- dplyr::filter(res , res$Billing.Type == "ZP13")

res1 <-
  res[res$Billing.Type != "ZP13" ,] #Keeps data without billing type as ZP13

summary(res1)

sapply(res, function(x)
  sum(is.na(x)))

class(res$Calendar.Day)

as.data.frame(table(res1$Material.group , useNA = "always"))

as.data.frame(table(res1$Plant , useNA = "always"))

as.data.frame(table(res1$Sales.Office , useNA = "always"))

res1$sales <- res1$Net.Value + res1$TAX.Amount..CSR.

scatter.smooth(res1$Billing.Qty.Base.UoM ,
               res1$sales,
               main = "Sales vs Quantity" ,
               col = rainbow(7))

boxplot(res1$sales ,
        main = "Net Sales" ,
        sub = paste("Outlier Rows :" , paste(
          boxplot.stats(res1$Net.Value)$out , collapse = " "
        )))

library(e1071)

plot(
  density(res$Net.Value),
  main = "Density plot : NetValue",
  ylab = "Frequency",
  sub = paste("Skewness : ", round(skewness(res$Net.Value), 2))
)
polygon(density(res$Net.Value) , col = rainbow(3))

length(unique(res$Sold.to.party))

plot(cor(res$Net.Value, res$Billing.Qty.Base.UoM))

cor(res$Plant, res$Sales.Office)

########linear regression #########

lmdata <- res1

sapply(res1 , function(x)
  class(x))

lmdata$Billing.document <- NULL
lmdata$X <- NULL
lmdata$X.1 <- NULL
lmdata$X.2 <- NULL
lmdata$Sold.to.party <- NULL
lmdata$X.3 <- NULL

lmdata$Net.Value <- NULL
lmdata$TAX.Amount..CSR. <- NULL

lmdata$Sales.Office <- as.factor(lmdata$Sales.Office)

summary(lmdata)

library(lubridate)

lmdata$Day <- day(lmdata$Calendar.Day) #Extracts day month and year

lmdata$Month <- month(lmdata$Calendar.Day)

lmdata$Year <- year(lmdata$Calendar.Day)

lmdata$Billing.Type <- as.factor(lmdata$Billing.Type)

lmdata$Billing.Type <- NULL
lmdata$Calendar.Day <- NULL

outlierKD <- function(dt, var) {
  var_name <- eval(substitute(var), eval(dt))
  na1 <- sum(is.na(var_name))
  m1 <- mean(var_name, na.rm = T)
  par(mfrow = c(2, 2), oma = c(0, 0, 3, 0))
  boxplot(var_name, main = "With outliers", col = rainbow(3))
  hist(
    var_name,
    main = "With outliers",
    xlab = NA,
    ylab = NA,
    col = rainbow(8)
  )
  outlier <- boxplot.stats(var_name)$out
  mo <- mean(outlier)
  var_name <- ifelse(var_name %in% outlier, NA, var_name)
  boxplot(var_name, main = "Without outliers", col = rainbow(5))
  hist(
    var_name,
    main = "Without outliers",
    xlab = NA,
    ylab = NA,
    col = rainbow(9)
  )
  title("Outlier Check", outer = TRUE)
  na2 <- sum(is.na(var_name))
  cat("Outliers identified:", na2 - na1, "n")
  cat("Propotion (%) of outliers:", round((na2 - na1) / sum(!is.na(var_name)) *
                                            100, 1), "n")
  cat("Mean of the outliers:", round(mo, 2), "n")
  m2 <- mean(var_name, na.rm = T)
  cat("Mean without removing outliers:", round(m1, 2), "n")
  cat("Mean if we remove outliers:", round(m2, 2), "n")
  response <-
    readline(prompt = "Do you want to remove outliers and to replace with NA? [yes/no]: ")
  if (response == "y" | response == "yes") {
    dt[as.character(substitute(var))] <- invisible(var_name)
    assign(as.character(as.list(match.call())$dt), dt, envir = .GlobalEnv)
    cat("Outliers successfully removed", "n")
    return(invisible(dt))
  } else{
    cat("Nothing changed", "n")
    return(invisible(var_name))
  }
}

outlierKD(lmdata, sales)

lmdata$sales[which(is.na(lmdata$sales))] <- 539520

library(caTools)

set.seed(121)

a <- sample.split(lmdata , SplitRatio = 0.7)

train <- subset(lmdata, a == T)

test <- subset(lmdata, a == F)

summary(train)

fit <- lm(sales ~ . , data = train)

summary(fit)

fit1 <- lm(sales ~ . , data = test)

summary(fit1)

train$Lower_Predicted_Value <- predict(fit , train)

test$Lower_Predicted_Value <- predict(fit, test)

output <- rbind(train, test)

output$Date <- paste(output$Day, output$Month, output$Year, sep = "-")

output$Date <- as.Date(output$Date , "%d-%m-%Y")

# output$Day <- NULL
# output$Month <- NULL
# output$Year <- NULL

output$Higher_Predicted_Value <-
  ((output$Lower_Predicted_Value * 0.01) + output$Lower_Predicted_Value)

write.csv(output, "sales_Final.csv" , row.names = F)

RMSE <- function(a, b) {
  sqrt(mean((a - b) ^ 2))
}

RMSE(output$Lower_Predicted_Value, output$sales)

RMSE(output$Higher_Predicted_Value, output$sales)

mean(fit$residuals)

acf(fit$residuals)

library(lawstat)

lawstat::runs.test(fit$residuals)

install.packages("gvlma")

gvlma::gvlma(fit)

plot(fit , col = rainbow(11))

train$Lower_Predicted_Value <- NULL

#####2018 VAlidation##

val <- read.csv("Data2018.csv")

val$Calendar.Day <- as.Date(val$Calendar.Day, "%d.%m.%Y")

val$Day <- day(val$Calendar.Day)

val$Month <- month(val$Calendar.Day)

val$Year <- year(val$Calendar.Day)

val$Billing.Type <- trimws(val$Billing.Type)

val$Billing.Type <- toupper(val$Billing.Type)

final_data <- val[val$Billing.Type != "ZP13" ,]

final_data$Billing.document <- NULL
final_data$Billing.Type <- NULL
final_data$Calendar.Day <- NULL
final_data$X <- NULL
final_data$X.1 <- NULL
final_data$X.2 <- NULL
final_data$Sold.to.party <- NULL

final_data$Sales.Office <- as.factor(final_data$Sales.Office)

sapply(lmdata , function(x)
  class(x))

sapply(final_data , function(x)
  class(x))

final_data <- na.omit(final_data)

final_data$Lower_Predicted_Value <- predict(fit , final_data)

final_data$Higher_Predicted_Value <-
  ((final_data$Lower_Predicted_Value * 0.01) + final_data$Lower_Predicted_Value)

final_data$Date <-
  paste(final_data$Day, final_data$Month, final_data$Year, sep = "-")

final_data$Date <- as.Date(final_data$Date, "%d-%m-%Y")

final_data$Day <- NULL
final_data$Month <- NULL
final_data$Year <- NULL

write.csv(final_data, "validatio_2018.csv"  , row.names = F)

### Dummy 2018 ###

dum_2018 <- read.csv("DUM_ALL.csv")

dum_2018 <- dum_2018[1:110556 ,]

sapply(lmdata , function(x)
  class(x))

sapply(dum_2018 , function(x)
  class(x))

dum_2018$Sales.Office <- as.factor(dum_2018$Sales.Office)

dum_2018$Lower_Predicted_Value <- predict(fit , dum_2018)

dum_2018$Higher_Predicted_Value <-
  ((dum_2018$Lower_Predicted_Value * 0.01) + dum_2018$Lower_Predicted_Value)

dum_2018$sales <- 0

dum_2018$Date <-
  paste(dum_2018$Day, dum_2018$Month, dum_2018$Year, sep = "-")

dum_2018$Date <- as.Date(dum_2018$Date, "%d-%m-%Y")

dum_2018 <- na.omit(dum_2018)

# dum_2018 <-    dum_2018[ c(1,2,3,4,10,5,6,7,8,11,9)]

# library(gtools)
#
# sales_prediction <- smartbind(output,dum_2018)

sales_prediction <- rbind(output, dum_2018)

sapply(output , function(x)
  sum(is.na(x)))
sapply(dum_2018 , function(x)
  sum(is.na(x)))

write.csv(sales_prediction, "sales.prediction.csv" , row.names = F)


######## K-fold Cross Validation ##########

library(caret)

model <- train(
  sales ~ . ,
  train ,
  method = "lm" ,
  trcontrol = trainControl(
    method = "cv" ,
    number = 10 ,
    verboseIter = T
  )
)

summary(model)

summary(train)

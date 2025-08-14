#Question 1.1
concrete <- read.csv("concrete.ass3.2024.csv")
fit_strength <- lm(Strength ~. , concrete)
summary(fit_strength)

#Question 1.2
bonferroni_significance_level <- 0.05/8
bonferroni_significance_level

#Question 1.3
#Cement
cement_fit <- lm(Strength ~ Cement, data = concrete)
predict_cement = predict(cement_fit, cement = data.frame(Cement = concrete$Cement)
                         , interval="confidence")
plot(concrete$Cement, concrete$Strength, xlab="Cement(kg/m3)", 
     ylab="Compressive Strength (MPa)",
     main = "Mean Compressive Strength against Cement")
lines(concrete$Cement, predict_cement[,"fit"], col="red")
lines(concrete$Cement, predict_cement[,"lwr"], col="black")
lines(concrete$Cement, predict_cement[,"upr"], col="black")

#Age of Concrete
age_fit <- lm(Strength ~ Age, data = concrete)
predict_age = predict(age_fit, age = data.frame(Age = concrete$Age)
                         , interval="confidence")
plot(concrete$Age, concrete$Strength, xlab="Concrete Age (days)", 
     ylab="Compressive Strength (MPa)",
     main = "Mean Compressive Strength against Concrete Age")
lines(concrete$Age, predict_age[,"fit"], col="red")
lines(concrete$Age, predict_age[,"lwr"], col="black")
lines(concrete$Cement, predict_cement[,"upr"], col="black")

#Question 1.4
n <- nrow(concrete) #number of observations
fit.strength.bic <- step(fit_strength, k = log(n))
summary(fit.strength.bic)

#Question 1.5.a
example_concrete <- data.frame(Cement = 491, 
                               Blast.Furnace.Slag = 26, 
                               Fly.Ash = 123, 
                               Superplasticizer = 3.9, 
                               Coarse.Aggregate = 882, 
                               Fine.Aggregate = 699, 
                               Age = 28)
predict(fit.strength.bic, newdata = example_concrete, interval = "confidence")



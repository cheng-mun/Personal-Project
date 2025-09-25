#Question 2.1
heart.train <- read.csv("heart.train.ass3.2024.csv")
heart.test <- read.csv("heart.test.ass3.2024.csv")
library(rpart)
library(pROC)
source("wrappers.R")
tree.heart <- rpart(HD ~ ., heart.train)
cv <- learn.tree.cv(HD~.,data=heart.train,nfolds=10,m=5000)
plot.tree.cv(cv)
prune.rpart(tree=tree.heart, cp = cv$best.cp)

#Question 2.2
plot(cv$best.tree)
text(cv$best.tree,pretty=12, cex=0.7)

#Question 2.5
heart.train$HD <- ifelse(heart.train$HD == "Y", 1, 0)
heart.fit = glm(HD ~ ., heart.train, family=binomial)
n <- nrow(heart.train)
heart.fit.bic <- step(heart.fit, k = log(n))
summary(heart.fit.bic)

#Question 2.7
source("my.prediction.stats.R")
heart.test$HD <- factor(heart.test$HD, levels = c("N", "Y"))

# decision tree
tree.prob <- predict(tree.heart, newdata = heart.test, type = "prob")[, 2]
my.pred.stats(tree.prob, heart.test$HD)

#logistic regression
logistic.prob <- predict(heart.fit.bic, newdata = heart.test, type = "response")
my.pred.stats(logistic.prob, heart.test$HD)

#question 2.8
data_patient <- heart.test[60, ]

#question 2.8.a decision tree
tree_patient <- predict(tree.heart, newdata = data_patient, type = "prob")[, 2]
tree_odds <- tree_patient / (1 - tree_patient)
tree_odds

#question 2.8.b logistic regression
logistic_patient <- predict(heart.fit.bic, newdata = data_patient, type = "response")
logistic_odds <- logistic_patient / (1 - logistic_patient)
logistic_odds

#question 2.9
library(boot)
library(glmnet)
n_boot <- 5000

boot_fn <- function(data, indices, patient_row) {
  # Create a bootstrap sample
  boot_sample <- data[indices, ]
  
  # Fit the logistic regression model
  boot_fit <- glm(HD ~ ., data = boot_sample, family = binomial)
  
  # Predict the probability for the specific patient
  predict(boot_fit, newdata = heart.test[patient_row, ], type = "response")
}

boot_65 <- boot(data = heart.train, statistic = boot_fn, R = n_boot, patient_row = 65)
ci.65<-boot.ci(boot_65, 0.95, type="bca")
ci.65

boot_66 <- boot(data = heart.train, statistic = boot_fn, R = n_boot, patient_row = 66)
ci.66 <- boot.ci(boot_66, type = "bca")
ci.66



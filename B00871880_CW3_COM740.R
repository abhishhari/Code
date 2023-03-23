---

#Title: "Maternity health risk prediction using ML algorithms"
#author: "Abhish Hari"
#B.No :  "BOO871880"

---

#Load the necessary packages:
library(tidyverse)
library(dplyr)
install.packages("Hmisc")
library("Hmisc")
install.packages("corrplot")
library(corrplot)
#Check work Directory
getwd()
#import the .csv file
mother<- read.csv("/Users/a.hari/Documents/Study/Semester 2 /COM740 Statistics/Dataset/Maternal Health Risk Data Set.csv", header = TRUE, sep = ",")
#Displaying the first 5 rows
head(mother,5)
#Displaying the last 5 rows
tail(mother,5)
#Displaying the datatypes
str(mother)
#Displaying the dimensions 
dim(mother)

#Checking for the total number of Missing Values
sum(is.na(mother))
#count the number of risklevel values 
table(mother['RiskLevel'])
#converting RiskLevel to numeric values
mother$RiskLevel <- as.numeric(gsub("high risk", "3", 
                                gsub("mid risk", "2", 
                                     gsub("low risk", "1", mother$RiskLevel))))
mother$RiskLevel <- as.numeric(mother$RiskLevel)
head(mother)
#counting the number of values of Risklevel
table(mother$RiskLevel)
#getting the total summary of the dataset 
summary(mother)
#correlation matrix
mother.rcorr = rcorr(as.matrix(mother))
mother.rcorr
set.seed(1) # seed random generator to be able to repeat the random result
x <- rnorm(100, mean=25, sd=10) # normal distribution
y <- runif(100, min=10, max=50) # uniform distribution
layout(matrix(1:2, nrow = 2, byrow = TRUE))


# Plot the histogram of the x variable in the first panel
hist(x)

# Plot the histogram of the y variable in the second panel
hist(y)
# normality tests
shapiro.test(x)
shapiro.test(y)

#correlation plot 
library(corrplot)
cor_matrix <- cor(mother)
corrplot(cor_matrix, method = "circle")
#percentage of RiskLevel
table(mother$RiskLevel)
table(mother$RiskLevel) * 100 / nrow(mother)


#plotting the data using histogram
library(ggplot2)
ggplot(data = mother, aes(x = Age)) +
  geom_histogram(binwidth = .50, color = "black", fill = "blue") +
  labs(title = "Histogram of Age", x = "Age", y = "Frequency")
ggplot(data = mother, aes(x = SystolicBP)) +
  geom_histogram(binwidth = .50, color = "black", fill = "blue") +
  labs(title = "Histogram of SystolicBP", x = "SystolicBP", y = "Frequency")
ggplot(data = mother, aes(x = DiastolicBP)) +
  geom_histogram(binwidth = .50, color = "black", fill = "blue") +
  labs(title = "Histogram of DiastolicBP", x = "DiastolicBP", y = "Frequency")
ggplot(data = mother, aes(x = BS)) +
  geom_histogram(binwidth = .50, color = "black", fill = "blue") +
  labs(title = "Histogram of BS", x = "BS", y = "Frequency")
ggplot(data = mother, aes(x = BodyTemp)) +
  geom_histogram(binwidth = .50, color = "black", fill = "blue") +
  labs(title = "Histogram of BodyTemp", x = "BodyTemp", y = "Frequency")
ggplot(data = mother, aes(x = HeartRate)) +
  geom_histogram(binwidth = .50, color = "black", fill = "blue") +
  labs(title = "Histogram of HeartRate", x = "HeartRate", y = "Frequency")
ggplot(data = mother, aes(x = RiskLevel)) +
  geom_histogram(binwidth = .50, color = "black", fill = "blue") +
  labs(title = "Histogram of RiskLevel", x = "HeartRate", y = "Frequency")
install.packages("pysch")
library(psych)
pairs.panels(mother[c("Age", "SystolicBP", "DiastolicBP", "BS","BodyTemp","HeartRate","RiskLevel")])
pairs(mother[c("Age", "SystolicBP", "DiastolicBP", "BS","BodyTemp","HeartRate","RiskLevel")])

# Set seed for random number generator
set.seed(150)

# Splitting data into training and testing sets
mother_new <- data.frame(mother) # Replace with actual data frame
split <- sample(1:nrow(mother), size = round(nrow(mother) * 0.2))
train <- mother[-split,]
test <- mother[split,]

# Printing the number of training and testing examples
cat(paste0("No. of training examples: ", nrow(train), "\n"))
cat(paste0("No. of testing examples: ", nrow(test), "\n"))
# Access 'RiskLevel' column of the test data frame
y_test <- test$RiskLevel

# Drop 'RiskLevel' column from the test data frame
x_test <- test[, !names(test) %in% "RiskLevel"]

# Print the first few rows of the x_test data frame
head(x_test)
# Drop 'RiskLevel' column from the train data frame
x_train <- train[, !names(train) %in% "RiskLevel"]

# Access 'RiskLevel' column of the train data frame
y_train <- train$RiskLevel

#LINEAR REGRESSION
# Loading the necessary libraries
library(tidyverse)

# Fitting the model
linear_model <- lm(formula = RiskLevel ~ SystolicBP+BS+HeartRate+Age+DiastolicBP+BodyTemp, data = train)

# Printing the model coefficients
print(linear_model$coefficients)

# Evaluating the model on the training data
train_predictions <- predict(linear_model, newdata =train)
print(train_predictions)

# Evaluating the model on the test data
test_predictions <- predict(linear_model, newdata = test)
test_results <- data.frame(Predicted_Risk = test_predictions, Actual_Risk = test$RiskLevel)
print(test_results)
print(summary(linear_model))
cor(test_predictions,test_results)

#DECISION TREE

# Loading the required libraries
library(rpart)
library(caret)

# Training the decision tree classifier
decision_tree <- rpart(y_train ~ ., data = x_train, method = "class")

# Make predictions on the test set
y_pred <- predict(decision_tree, x_test, type = "class")

# Evaluating the model's performance
print(paste("Training accuracy:", round(mean(y_train == predict(decision_tree, x_train, type = "class")), 2)))
print(paste("Testing accuracy:", round(mean(y_test == y_pred), 2)))

# Converting y_pred and y_test to factors
y_pred <- as.factor(y_pred)
y_test <- as.factor(y_test)

# Setting levels of y_pred and y_test to match
levels(y_pred) <- levels(y_test)

# Generating confusion matrix
cm <- confusionMatrix(y_pred, y_test)
print(cm)

#NAIVE BAYES
# Loading the required libraries

# Installing the e1071 package
install.packages("e1071")
library(e1071)
library(caret)

# Training the Naive Bayes classifier
nb <- naiveBayes(x_train, y_train)

# Making predictions on the test set
y_pred <- predict(nb, x_test)

# Evaluating the model's performance
print(paste("Training accuracy:", round(mean(y_train == predict(nb, x_train)), 2)))

# Calculating the accuracy
print(paste("Testing accuracy:", round(mean(y_test == y_pred), 2)))


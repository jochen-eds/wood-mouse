# This code and the used models were generated using R version 4.3.1 and the 
# packages tidyverse (version 2.0.0) and ranger (version 0.17.0).
# To install these package versions on your system, you can run the commented 
# code below.

# install.packages("devtools")
# 
# require(devtools)
# install_version("tidyverse", version = "2.0.0", repos = "http://cran.us.r-project.org")
# install_version("ranger", version = "0.17.0", repos = "http://cran.us.r-project.org")
# install_version("caret", version = "6.0-94", repos = "http://cran.us.r-project.org")
# install_version("yardstick", version = "1.3.1", repos = "http://cran.us.r-project.org")

#### Load libraries ####

library(tidyverse)
library(ranger)
library(caret)
library(yardstick)

#### Example model predictions ####

# Here we try to reproduce the metrics for the final model from the manuscript. 

### Load model

model <- readRDS("RF_model.rds")

### Load training and test data

training_data <- readRDS("Train_data.rds")

test_data <- readRDS("Test_data.rds")

### Make predictions

## Create tables with actual vs. predicted target values

pred_training_data <- tibble(actual = training_data$Target_Density, 
                             pred = predict(model, newdata = training_data %>% 
                                              select(-Target_Density)))

pred_test_data <- tibble(actual = test_data$Target_Density, 
                         pred = predict(model, newdata = test_data %>% 
                                          select(-Target_Density)))

## Calculate RMSE and RSQ values

rmse_training <- yardstick::rmse(pred_training_data, pred, actual) %>%
  pull(.estimate)
rsq_training <- yardstick::rsq(pred_training_data, pred, actual) %>%
  pull(.estimate)

rmse_test <- yardstick::rmse(pred_test_data, pred, actual) %>%
  pull(.estimate)
rsq_test <- yardstick::rsq(pred_test_data, pred, actual) %>%
  pull(.estimate)

# Gives you the results presented in Table 6 of the publication.

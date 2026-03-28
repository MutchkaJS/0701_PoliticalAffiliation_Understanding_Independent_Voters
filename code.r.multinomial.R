# READ election_research_2 .csv dataset
df <- read.csv("election_research_2.csv")
head(df,20)

head(df_clean, 30)
# -----------------------------------------------------------
# 0. Load required packages
# -----------------------------------------------------------
library(caret)   # for data partitioning and train()
library(nnet)    # for multinom()
library(dplyr)   # for data manipulation

# -----------------------------------------------------------
# 1. Prepare variables (ensure correct types)
# -----------------------------------------------------------
df$Party   <- factor(df$Party, 
                     levels = c("Democrat", "Republican", "Independent"))
df$Gender  <- factor(df$Gender)
df$Race    <- factor(df$Race)
df$EdLevel <- ordered(df$EdLevel,
                      levels = c("Less than HS", "HS", "Some College", 
                                 "Bachelor", "Graduate"))

# Optional: drop rows with missing values in modeling variables
df_mod <- df %>%
  filter(complete.cases(Party, Income, Age, Gender, Race, EdLevel))

# -----------------------------------------------------------
# 2. Stratified random split: 70% train, 30% test
# -----------------------------------------------------------
set.seed(123)  # for reproducibility

trainIndex <- createDataPartition(
  df_mod$Party,  # stratify by Party
  p = 0.70,      # 70% to training
  list = FALSE   # return row indices, not a list
)

train_df <- df_mod[trainIndex, ]
test_df  <- df_mod[-trainIndex, ]

# Check proportions of Party in each set (optional)
prop.table(table(train_df$Party))
prop.table(table(test_df$Party))

# -----------------------------------------------------------
# 3. Set up 10-fold cross-validation control
# -----------------------------------------------------------
set.seed(123)

train_control <- trainControl(
  method = "cv",           # k-fold cross-validation
  number = 10,             # 10 folds
  classProbs = TRUE,       # needed for multinomial outcomes
  savePredictions = "final",
  summaryFunction = multiClassSummary
)

# -----------------------------------------------------------
# 4. Fit multinomial logistic regression with 10-fold CV
#    on the training data
# -----------------------------------------------------------
cv_fit <- train(
  Party ~ Income + Age + Gender + Race + EdLevel,
  data = train_df,
  method = "multinom",     # uses nnet::multinom internally
  trControl = train_control,
  trace = FALSE            # suppress iteration output
)

# -----------------------------------------------------------
# 5. Inspect cross-validated results
# -----------------------------------------------------------
cv_fit$results          # accuracy, Kappa, etc. across folds
cv_fit$bestTune         # tuning parameters (if any)
cv_fit                  # prints a summary

# -----------------------------------------------------------
# 6. (Optional) Evaluate on the held-out test set
# -----------------------------------------------------------

test_pred_class <- predict(cv_fit, newdata = test_df)
test_pred_prob  <- predict(cv_fit, newdata = test_df, type = "prob")

# Confusion matrix on test data
confusionMatrix(test_pred_class, test_df$Party)

# Test accuracy
mean(test_pred_class == test_df$Party)

final_model <- cv_fit$finalModel
summary(final_model)
coef(final_model)

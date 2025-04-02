###PARTITION THE DATA AFTER CLEANING IN SAS.
#Set seed for reproducibility.
set.seed(100)

#Count the number of rows in the dataset.
num_rows <- nrow(engine)

#Sample row indices for the training set (70%).
train_indices <- sample(seq_len(num_rows), size = round(0.7 * num_rows))

#Create the training and validation sets.
engine_train <- engine[train_indices, ]
engine_validation <- engine[-train_indices, ]

#Export training dataset.
write.csv(engine_train, 
          file = "C:/Users/trent/OneDrive/Desktop/CSU_Global/MIS581/Z_Data/engine_train.csv", 
          row.names = FALSE)

#Export validation dataset.
write.csv(engine_validation, 
          file = "C:/Users/trent/OneDrive/Desktop/CSU_Global/MIS581/Z_Data/engine_validation.csv", 
          row.names = FALSE)
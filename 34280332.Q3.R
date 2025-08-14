library(kknn)
library(boot)
ms.train <- read.csv("ms.train.2024.csv")
ms.test <- read.csv("ms.test.2024.csv")

#Question 3.1
train_data <- data.frame(MZ = ms.train$MZ, intensity = ms.train$intensity)
test_data <- data.frame(MZ = ms.test$MZ, true_intensity = ms.test$intensity)

# Initialize a vector to store mse for k
mse_values <- numeric(25)

# Loop over 1 to 25
for (k in 1:25) {
  # Fit the k-NN model
  knn_model <- kknn(intensity ~ MZ, train = train_data, test = test_data, k = k, kernel = "optimal")
  
  # Get the predicted intensities
  predicted_intensity <- fitted(knn_model)
  
  # Calculate the MSE
  mse_values[k] <- mean((predicted_intensity - test_data$true_intensity)^2)
}
mse_values

# Plot the graph
plot(1:25, mse_values, type = "b", pch = 19, col = "blue",
     xlab = "Number of Neighbors (k)", ylab = "Mean Squared Error",
     main = "Mean Squared Error for Various k")

#Question 3.2
k_values <- c(2, 6, 12, 25) # k to be analysed
par(mfrow = c(2, 2)) # split into 2x2

for (k in k_values) {
  # Fit the k-NN model
  knn_model <- kknn(intensity ~ MZ, train = train_data, test = test_data, k = k, kernel = "optimal")
  
  # Get the predicted intensity
  predicted_intensity <- fitted(knn_model)
  
  # Plot the data
  plot(train_data$MZ, train_data$intensity, col = "orange", pch = 16, 
       xlab = "MZ values", 
       ylab = "Intensity", 
       main = paste("k-NN Smoothing (k =", k, ")"))
  
  # Add the true spectrum
  lines(test_data$MZ, test_data$true_intensity, col = "red", lwd = 2)
  
  # Add the estimated spectrum
  lines(test_data$MZ, predicted_intensity, col = "blue", lwd = 2)
  
  # Add a legend
  legend("topright", legend = c("Training Data", "True Spectrum", "Estimated Spectrum"),
         col = c("orange", "red", "blue"), 
         lwd = c(1, 2, 2), 
         pch = c(16, NA, NA), 
         bty = "n", 
         cex = 0.6)
}

#Question 3.4
response_var <- "intensity"
predictor_var <- "MZ"
kmax <- 25 
knn_model <- train.kknn(intensity ~ MZ, data = ms.train, kmax = 25, kernel = "optimal")

best_k <- knn_model$best.parameters$k
best_k

#Question 3.5
knn_model2 <- kknn(intensity ~ MZ, train = ms.train, test = ms.test, k = 6, 
                   kernel = "optimal")
prediction <- fitted(knn_model2)
residuals <- ms.test$intensity - prediction
estimated_sd <- sd(residuals)
estimated_sd

#Question 3.7
knn_model3 <- kknn(intensity ~ MZ, train = train_data, test = test_data, k = best_k, 
                  kernel = "optimal")
predicted_intensity <- fitted(knn_model3)

max_intensity_index <- which.max(predicted_intensity)
max_intensity_value <- predicted_intensity[max_intensity_index]
max_MZ_value <- test_data$MZ[max_intensity_index]

max_intensity_value
max_MZ_value

#Question 3.8
boot_knn_fn <- function(data, indices, MZ_value, k) {
  # Create a bootstrap sample
  boot_sample <- data[indices, ]
  
  # Fit the k-NN model using the optimal kernel
  knn_model <- kknn(intensity ~ MZ, train = boot_sample, test = data.frame(MZ = MZ_value), k = k, kernel = "optimal")
  
  # Return the predicted intensity
  return(fitted(knn_model))
}
n_boot <- 5000
k_values <- c(6, 3, 20)
ci_results <- list()

for (k in k_values) {
  boot_results <- boot(data = train_data, statistic = boot_knn_fn, R = n_boot, 
                       MZ_value = max_MZ_value, k = k)
  
  ci <- boot.ci(boot_results, type = "bca")
  ci_results[[as.character(k)]] <- ci$bca[4:5]  # Extract lower and upper bounds
}

ci_results

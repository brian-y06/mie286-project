# Load the aggregated master dataset
data <- read.csv("C:/Users/harle/OneDrive/Desktop/engsci year 2/mie/mie286-project/analysis/master_data.csv")

cat("=== Descriptive Statistics: Overall ===\n")

# Dependent Variable: Reaction Time
cat("\n--- Reaction Time (ms) ---\n")
cat("Mean:     ", mean(data$reactionTimeMs, na.rm=TRUE), "\n")
cat("Variance: ", var(data$reactionTimeMs, na.rm=TRUE), "\n")
cat("SD:       ", sd(data$reactionTimeMs, na.rm=TRUE), "\n")


# Dependent Variable: Accuracy
cat("\n--- Accuracy ---\n")
cat("Mean:     ", mean(data$accuracy, na.rm=TRUE), "\n")
cat("Variance: ", var(data$accuracy, na.rm=TRUE), "\n")
cat("SD:       ", sd(data$accuracy, na.rm=TRUE), "\n")

# Covariate: Baseline Typing Speed
cat("\n--- Covariate: Baseline Typing Speed (ms) ---\n")
cat("Mean:     ", mean(data$baselineTypingSpeedMs, na.rm=TRUE), "\n")
cat("Variance: ", var(data$baselineTypingSpeedMs, na.rm=TRUE), "\n")
cat("SD:       ", sd(data$baselineTypingSpeedMs, na.rm=TRUE), "\n")


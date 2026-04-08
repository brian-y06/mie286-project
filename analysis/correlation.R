# correlation between typing speed and accuracy
# 1. SET UP ---------------------------------------------------------------
# Set the CRAN mirror to avoid the "no mirror" error
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Load or install required packages
if (!require("dplyr")) install.packages("dplyr")
if (!require("ggplot2")) install.packages("ggplot2")

library(dplyr)
library(ggplot2)

# 2. LOAD DATA ------------------------------------------------------------
# Ensure the file is in your current working directory
file_path <- "C:/Users/harle/OneDrive/Desktop/engsci year 2/mie/mie286-project/analysis/ttest_visual_data.csv"
# change auditory to visual and vice versa for difference analysis

if (!file.exists(file_path)) {
  stop("The file 'ttest_auditory_data.csv' was not found in the current folder.")
}

data <- read.csv(file_path)

# 3. DATA AGGREGATION -----------------------------------------------------
# Calculate mean reaction time and accuracy for each participant
participant_summary <- data %>%
  group_by(participantId) %>%
  summarize(
    mean_RT = mean(reactionTimeMs, na.rm = TRUE), #change this between "reactionTimeMs" and "typingTimeMs" to change results
    mean_ACC = mean(accuracy, na.rm = TRUE),
    .groups = 'drop'
  )

# 4. STATISTICAL TEST -----------------------------------------------------
# Conduct Pearson Correlation
cor_test <- cor.test(participant_summary$mean_RT, participant_summary$mean_ACC)

# Print results to console
cat("\n--- Correlation Results: Speed vs. Accuracy ---\n")
print(cor_test)

# 5. VISUALIZATION --------------------------------------------------------
# Create a scatter plot with a linear regression line
plot <- ggplot(participant_summary, aes(x = mean_RT, y = mean_ACC)) +
  geom_point(size = 3, color = "royalblue") +
  geom_smooth(method = "lm", color = "red", se = TRUE, linetype = "dashed") +
  labs(
    title = "Participant Speed-Accuracy Correlation",
    subtitle = paste("Pearson r =", round(cor_test$estimate, 3), 
                     "| p =", round(cor_test$p.value, 3)),
    x = "Mean Reaction Time (ms)",
    y = "Mean Accuracy (0-1)"
  ) +
  theme_minimal()

# Display the plot
print(plot)

# Auditory

# --- Correlation Results:  Typing Speed vs. Accuracy ---
# 
#         Pearson's product-moment correlation
# 
# data:  participant_summary$mean_RT and participant_summary$mean_ACC
# t = 1.1894, df = 11, p-value = 0.2593
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  -0.2621722  0.7492094
# sample estimates:
#       cor
# 0.3375771 
# 
# `geom_smooth()` using formula = 'y ~ x'

# --- Correlation Results: Reaction Speed vs. Accuracy --- (probably not relevent)
# 
#         Pearson's product-moment correlation
# 
# data:  participant_summary$mean_RT and participant_summary$mean_ACC
# t = 0.44512, df = 11, p-value = 0.6649
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  -0.4510249  0.6372941
# sample estimates:
#       cor
# 0.1330159
# 
# `geom_smooth()` using formula = 'y ~ x'




# Visual

# --- Correlation Results: Typing Speed vs. Accuracy ---
# 
#         Pearson's product-moment correlation
# 
# data:  participant_summary$mean_RT and participant_summary$mean_ACC
# t = -0.76995, df = 11, p-value = 0.4575
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  -0.6910217  0.3710857
# sample estimates:
#       cor 
# -0.226136
# 
# `geom_smooth()` using formula = 'y ~ x'

# --- Correlation Results: Reaction Speed vs. Accuracy --- (again, probably not gonna be used)
# 
#         Pearson's product-moment correlation
# 
# data:  participant_summary$mean_RT and participant_summary$mean_ACC
# t = 1.0455, df = 11, p-value = 0.3182
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  -0.3000298  0.7306115
# sample estimates:
#       cor
# 0.3006578
# 
# `geom_smooth()` using formula = 'y ~ x'
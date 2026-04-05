# Load the split data
auditory_data <- read.csv("ttest_auditory_data.csv")
visual_data <- read.csv("ttest_visual_data.csv")

# Null Hypothesis, there is no difference in reaction time between the two groups
result <- t.test(visual_data$logReactionTime, auditory_data$logReactionTime)
print(result)

# > result

# 	Welch Two Sample t-test

# data:  visual_data$logReactionTime and auditory_data$logReactionTime
# t = -28.17, df = 317.42, p-value < 2.2e-16
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -0.7522909 -0.6540669
# sample estimates:
# mean of x mean of y 
#  6.601814  7.304993 
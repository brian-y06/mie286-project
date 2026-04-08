# Load libraries
library(ggplot2)
library(dplyr)
library(tidyr)

# Load the split data
auditory_data <- read.csv("ttest_auditory_data.csv")
visual_data <- read.csv("ttest_visual_data.csv")

data <- rbind(visual_data, auditory_data)

#-----------------------------------------------
# Plot Auditory Condition's Histogram (NOT Normalized)
x_auditory <- auditory_data$reactionTimeMs
hist(x_auditory,
     main="Auditory Condition's Reaction Time",
     xlab="Reaction Time (ms)",
     # xaxt="n",
     # xlim=c(6.5, 8.6),
     breaks = 15,
     prob=TRUE
)
# axis(1, at-seq(6.5, 8.2, by=0.1))
lines(density(x_auditory), col="green")

#-----------------------------------------------
# Plot Visual Condition's Histogram (NOT Normalized)
x_visual <- visual_data$reactionTimeMs
hist(x_visual,
     main="Visual Condition's Reaction Time",
     xlab="Reaction Time (ms)",
     # xlim=c(6.3, 7.7),
     prob=TRUE,
     breaks=15
)
lines(density(x_visual), col="green")

#-----------------------------------------------
# Plot Auditory Condition's Histogram (Normalized)
x_auditory <- auditory_data$logReactionTime
hist(x_auditory,
     main="Auditory Condition's Reaction Time",
     xlab="Reaction Time (ms)",
     # xaxt="n",
     # xlim=c(6.5, 8.6),
     breaks = 15,
     prob=TRUE
     )
axis(1, at-seq(6.5, 8.2, by=0.1))
lines(density(x_auditory), col="green")

#-----------------------------------------------
# Plot Visual Condition's Histogram (Normalized)
x_visual <- visual_data$logReactionTime
hist(x_visual,
     main="Visual Condition's Reaction Time",
     xlab="Reaction Time (ms)",
     xlim=c(6.3, 7.7),
     prob=TRUE
)
lines(density(x_visual), col="green")

#-----------------------------------------------
# Plot Reaction Time Density (Auditory & Visual)

density <- ggplot(data, aes(x=logReactionTime, color=condition, fill=condition)) +
  geom_density(alpha=0.25, linewidth=1) + # probability density curve (alpha adds transparency)
  labs(
    title="Probability Densities of Reaction Time to Auditory and Visual Cues",
    x="Reaction Time [log(ms)]",
    y="Probability Density"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size=18),
    legend.title=element_blank(),
    legend.text = element_text(size=14),
    legend.key.spacing.x = unit(0.5, "cm"),
    legend.key.spacing.y = unit(0.25, "cm"),
    legend.position=c(0.9, 0.9)
  )
print(density)

#-----------------------------------------------
# Plot Box-and-Whisker Plot
means <- data %>%
  group_by(condition) %>%
  summarise(mean=mean(logReactionTime))

boxplot <- ggplot(data, aes(x=condition, y=logReactionTime, fill=condition)) +
  geom_boxplot(alpha=0.25) +
  labs(
    title="Reaction Time to Auditory and Visual Cues (Box-and-Whisker Plots)",
    x="Condition",
    y="Reaction Time [log(ms)]"
  ) +
  stat_summary(
    fun="mean",
    geom="point",
    size=2
  ) + 
  geom_text(
    data=means, 
    aes(x=condition, y=mean, label=paste("Mean:", round(mean,1))), 
        vjust=-1.5, 
        size=5,
        show.legend=FALSE
    ) +
  theme(
    plot.title = element_text(hjust = 0.5, size=18),
    axis.text=element_text(size=12),
    axis.title.x=element_text(size=16),
    axis.title.y=element_text(size=16),
    legend.title=element_blank(),
    legend.text = element_text(size=14),
    legend.key.spacing.x = unit(0.5, "cm"),
    legend.key.spacing.y = unit(0.25, "cm"),
    legend.position=c(0.9, 0.9)
  )
print(boxplot)

#-----------------------------------------------
# Q-Q Plot

reactionT_differences <- x_auditory - x_visual
qqnorm(reactionT_differences,
       main="Q-Q Plot of Differences in Response Time between Conditions"
       )
qqline(reactionT_differences, col="blue")


qqnorm(x_auditory,
       main="Q-Q Plot of Response Time for Auditory Conditions"
)
qqline(x_auditory, col="green")

qqnorm(x_visual,
       main="Q-Q Plot of Response Time for Visual Condition"
)
qqline(x_visual, col="RED")
#-----------------------------------------------
# Means and Standard Deviations

means <- data %>%
  group_by(condition) %>%
  summarise(mean=mean(reactionTimeMs))

print(means)

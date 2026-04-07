options(repos = c(CRAN = "https://cloud.r-project.org"))
install.packages(c("rlang", "ps", "magrittr", "processx", "pkgload", "lme4", "lmerTest"), 
                 type = "win.binary", 
                 repos = "https://cloud.r-project.org")
library(lme4)
library(lmerTest)
library(rlang)

aud_data <- read.csv("ttest_auditory_data.csv")
aud_data$participantId <- as.factor(aud_data$participantId)
aud_data$targetWord <- as.factor(aud_data$targetWord)

aud_model <- lmer(logReactionTime ~ 1 + (1 | participantId) + (1 | targetWord), data = aud_data)
summary(aud_model)

vis_data <- read.csv("ttest_visual_data.csv")
vis_data$participantId <- as.factor(vis_data$participantId)
vis_data$targetWord <- as.factor(vis_data$targetWord)

vis_model <- lmer(logReactionTime ~ 1 + (1 | participantId) + (1 | targetWord), data = vis_data)
summary(vis_model)


# LMM Results

# Auditory
# Linear mixed model fit by REML. t-tests use Satterthwaite's method [lmerModLmerTest]
# Formula: logReactionTime ~ 1 + (1 | participantId) + (1 | targetWord)
#    Data: data
# 
# REML criterion at convergence: 69
# 
# Scaled residuals: 
#      Min       1Q   Median       3Q      Max
# -2.68764 -0.64480 -0.08897  0.67985  2.90178
# 
# Random effects:
#  Groups        Name        Variance Std.Dev.
#  targetWord    (Intercept) 0.00429  0.0655
#  participantId (Intercept) 0.01497  0.1223  
#  Residual                  0.07144  0.2673
# Number of obs: 195, groups:  targetWord, 15; participantId, 13
# 
# Fixed effects:
#             Estimate Std. Error       df t value Pr(>|t|)
# (Intercept)  7.30499    0.04247 14.57931     172   <2e-16 ***
#---
#Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1


# Visual
# Linear mixed model fit by REML. t-tests use Satterthwaite's method [lmerModLmerTest]
# Formula: logReactionTime ~ 1 + (1 | participantId) + (1 | targetWord)
#    Data: vis_data
# 
# REML criterion at convergence: -135.4
# 
# Scaled residuals:
#     Min      1Q  Median      3Q     Max
# -1.8138 -0.5854 -0.1666  0.4123  5.4312
# 
# Random effects:
#  Groups        Name        Variance Std.Dev.
#  targetWord    (Intercept) 0.002036 0.04512
#  participantId (Intercept) 0.006211 0.07881
#  Residual                  0.024296 0.15587
# Number of obs: 194, groups:  targetWord, 15; participantId, 13
# 
# Fixed effects:
#             Estimate Std. Error       df t value Pr(>|t|)
# (Intercept)  6.60203    0.02718 15.51175   242.9   <2e-16 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
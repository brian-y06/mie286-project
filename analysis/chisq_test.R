# Load the split data
auditory_data <- read.csv("ttest_auditory_data.csv")
visual_data <- read.csv("ttest_visual_data.csv")

aud_avg <- 7.32167175281
vis_avg <- 6.62155928124

#aud_res <- chisq.test(auditory_data$logReactionTime)
#vis_res <- chisq.test(visual_data$logReactionTime)

#print(aud_res)
#print(vis_res)
aud_sigma <- sd(auditory_data$logReactionTime)
aud_chi_sq <- sum(((auditory_data$logReactionTime - aud_avg) / aud_sigma)^2)
aud_df <- length(auditory_data$logReactionTime) - 1
aud_reduced_chi_sq <- aud_chi_sq / aud_df
aud_p_val <- pchisq(aud_chi_sq, aud_df, lower.tail = FALSE)

vis_sigma <- sd(visual_data$logReactionTime)
vis_chi_sq <- sum(((visual_data$logReactionTime - vis_avg) / vis_sigma)^2)
vis_df <- length(visual_data$logReactionTime) - 1
vis_reduced_chi_sq <- vis_chi_sq / vis_df
vis_p_val <- pchisq(vis_chi_sq, vis_df, lower.tail = FALSE)

print(paste("Auditory Chi-Squared =", aud_chi_sq))                  # 194.607108992394
print(paste("Auditory df =", aud_df))                               # 194
print(paste("Auditory Reduced Chi-Squared =", aud_reduced_chi_sq))  # 1.00312942779585
print(paste("Auditory p =", aud_p_val))                             # 0.474232857766077

print(paste("Visual Chi-Squared =", vis_chi_sq))                    # 195.364695808789
print(paste("Visual df =", vis_df))                                 # 193
print(paste("Visual Reduced Chi-Squared =", vis_reduced_chi_sq))    # 1.0122523098901
print(paste("Visual p =", vis_p_val))                               # 0.438892328340143



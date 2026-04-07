aud_data <- read.csv("C:/Users/harle/OneDrive/Desktop/engsci year 2/mie/mie286-project/analysis/ttest_auditory_data.csv")
vis_data <- read.csv("C:/Users/harle/OneDrive/Desktop/engsci year 2/mie/mie286-project/analysis/ttest_visual_data.csv")

aud_accuracy_table <- table(aud_data$targetWord, aud_data$accuracy)
aud_chi_result <- chisq.test(aud_accuracy_table)
aud_chi <- aud_chi_result$statistic
aud_df <- aud_chi_result$parameter
aud_reduced_chi_sq <- aud_chi / aud_df

vis_accuracy_table <- table(vis_data$targetWord, vis_data$accuracy)
vis_chi_result <- chisq.test(vis_accuracy_table)
vis_chi <- vis_chi_result$statistic
vis_df <- vis_chi_result$parameter
vis_reduced_chi_sq <- vis_chi / vis_df

print(aud_accuracy_table)
print(aud_chi_result)       # chisq = 18.599, df = 14, p-value = 0.1808
print(aud_reduced_chi_sq)   # 1.328516

print(vis_accuracy_table)
print(vis_chi_result)       # chisq = 16.789, df = 14, p-value = 0.2676
print(vis_reduced_chi_sq)   # 1.199202
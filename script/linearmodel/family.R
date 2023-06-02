setwd("/Users/hy/Documents/GitHub/microbiome/data_analysis/raw_result/alpha/family")
metadata <- read.table("/Users/hy/Documents/GitHub/all.pops.metadata.tsv",header=TRUE)


# ISI_F
isi_F <- read_table("inverse_simpson_alpha_F.txt", 
                        col_names= c("sample_id", "inverse_simpson"), 
                        col_types = "cd")

full_isi_F <- full_join(metadata, isi_F)


F_isi1 <- lm(inverse_simpson ~ hostplant*transect*hostrange, data = full_isi_F)
anova(F_isi1)

# drop 3way interaction
F_isi2 <- lm(inverse_simpson ~ hostplant*transect + hostplant*hostrange + transect*hostrange, data = full_isi_F)
anova(F_isi2)

# drop hostplant*transect
F_isi3 <- lm(inverse_simpson ~  hostplant*hostrange + transect*hostrange, data = full_isi_F)
anova(F_isi3)

# drop hostplant*hostrange
F_isi4 <- lm(inverse_simpson ~ hostplant + transect*hostrange, data = full_isi_F)
anova(F_isi4)

# drop hostplant
F_isi5 <- lm(inverse_simpson ~  transect*hostrange, data = full_isi_F)
anova(F_isi5)

# drop transect * host range
F_isi6 <- lm(inverse_simpson ~  transect + hostrange, data = full_isi_F)
anova(F_isi6)

AIC(F_isi1, F_isi2, F_isi3, F_isi4, F_isi5, F_isi6)
BIC(F_isi1, F_isi2, F_isi3, F_isi4, F_isi5, F_isi6)
anova(F_isi2, F_isi1)
anova(F_isi3, F_isi2)
anova(F_isi4, F_isi3)
anova(F_isi5, F_isi4)
anova(F_isi6, F_isi5)

###

# S_F
shannon_F <- read_table("shannon_alpha_F.txt", 
                        col_names= c("sample_id", "shannon"), 
                        col_types = "cd")

full_shannon_F <- full_join(metadata, shannon_F)


F_shan1 <- lm(shannon ~ hostplant * transect * hostrange, data = full_shannon_F)
anova(F_shan1)

# drop 3way interaction
F_shan2 <- lm(shannon ~ hostplant * transect + hostplant* hostrange + transect * hostrange, data = full_shannon_F)
anova(F_shan2)

# drop hostplant*transect
F_shan3 <- lm(shannon ~  hostplant* hostrange + transect * hostrange, data = full_shannon_F)
anova(F_shan3)

# drop hostplant* hostrange
F_shan4 <- lm(shannon ~ hostplant + transect * hostrange, data = full_shannon_F)
anova(F_shan4)

# drop host plant
F_shan5 <- lm(shannon ~  transect * hostrange, data = full_shannon_F)
anova(F_shan5)

# drop transect * host range
F_shan6 <- lm(shannon ~  transect + hostrange, data = full_shannon_F)
anova(F_shan6)

AIC(F_shan1, F_shan2, F_shan3, F_shan4, F_shan5, F_shan6)
BIC(F_shan1, F_shan2, F_shan3, F_shan4, F_shan5, F_shan6)
anova(F_shan2, F_shan1)
anova(F_shan3, F_shan2)
anova(F_shan4, F_shan3)
anova(F_shan5, F_shan4)
anova(F_shan6, F_shan5)

setwd("/Users/hy/Documents/GitHub/microbiome/data_analysis/raw_result/alpha/species")
metadata <- read.table("/Users/hy/Documents/GitHub/all.pops.metadata.tsv",header=TRUE)


# ISI_S
isi_S <- read_table("inverse_simpson_alpha.txt", 
                    col_names= c("sample_id", "inverse_simpson"), 
                    col_types = "cd")

full_isi_S <- full_join(metadata, isi_S)


S_isi1 <- lm(inverse_simpson ~ hostplant*transect*hostrange, data = full_isi_S)
anova(S_isi1)

# drop 3way interaction
S_isi2 <- lm(inverse_simpson ~ hostplant*transect + hostplant*hostrange + transect*hostrange, data = full_isi_S)
anova(S_isi2)

# drop transect*hostrange
S_isi3 <- lm(inverse_simpson ~ hostplant*hostrange + hostplant*transect, data = full_isi_S)
anova(S_isi3)

# drop hostplant*transect
S_isi4 <- lm(inverse_simpson ~ transect + hostplant*hostrange, data = full_isi_S)
anova(S_isi4)

# drop hostplant*hostrange
S_isi5 <- lm(inverse_simpson ~  transect + hostrange + hostplant, data = full_isi_S)
anova(S_isi5)

# drop host range
S_isi6 <- lm(inverse_simpson ~ transect + hostplant, data = full_isi_S)
anova(S_isi6)

# drop  transect
S_isi7 <- lm(inverse_simpson ~ hostplant, data = full_isi_S)
anova(S_isi7)

# drop everything
S_isi8 <- lm(inverse_simpson ~ 1, data = full_isi_S)

AIC(S_isi1, S_isi2, S_isi3, S_isi4, S_isi5, S_isi6, S_isi7, S_isi8)
BIC(S_isi1, S_isi2, S_isi3, S_isi4, S_isi5, S_isi6, S_isi7, S_isi8)
anova(S_isi2, S_isi1)
anova(S_isi3, S_isi2)
anova(S_isi4, S_isi3)
anova(S_isi5, S_isi4)
anova(S_isi6, S_isi5)
anova(S_isi7, S_isi6)
anova(S_isi8, S_isi7)

###

# S_F
shannon_S <- read_table("shannon_alpha.txt", 
                        col_names= c("sample_id", "shannon"), 
                        col_types = "cd")

full_shannon_S <- full_join(metadata, shannon_S)


S_shan1 <- lm(shannon ~ hostplant * transect * hostrange, data = full_shannon_S)
anova(S_shan1)

# drop 3way interaction
S_shan2 <- lm(shannon ~ hostplant * transect + hostplant* hostrange + transect * hostrange, data = full_shannon_S)
anova(S_shan2)

# drop hostplant*transect
S_shan3 <- lm(shannon ~  hostplant* hostrange + transect * hostrange, data = full_shannon_S)
anova(S_shan3)

# drop hostplant* hostrange
S_shan4 <- lm(shannon ~ hostplant + transect * hostrange, data = full_shannon_S)
anova(S_shan4)

# drop transect*hostrange
S_shan5 <- lm(shannon ~ transect + hostplant + hostrange, data = full_shannon_S)
anova(S_shan5)

# drop host range
S_shan6 <- lm(shannon ~ transect + hostplant, data = full_shannon_S)
anova(S_shan6)

# drop transect
S_shan7 <- lm(shannon ~  hostplant, data = full_shannon_S)
anova(S_shan7)

# drop everything
S_shan8 <- lm(shannon ~  1, data = full_shannon_S)


AIC(S_shan1, S_shan2, S_shan3, S_shan4, S_shan5, S_shan6, S_shan7, S_shan8)
BIC(S_shan1, S_shan2, S_shan3, S_shan4, S_shan5, S_shan6, S_shan7, S_shan8)
anova(S_shan2, S_shan1)
anova(S_shan3, S_shan2)
anova(S_shan4, S_shan3)
anova(S_shan5, S_shan4)
anova(S_shan6, S_shan5)
anova(S_shan7, S_shan6)
anova(S_shan8, S_shan7)

###
#Richness Species
count_S <- read_table("species_count.txt", 
                        col_names= c("sample_id", "count"), 
                        col_types = "cd")
full_count_S <- full_join(metadata, count_S)

S_count1 <- lm(count ~ hostplant * transect * hostrange, data = full_count_S)
anova(S_count1)

# drop 3way interaction
S_count2 <- lm(count ~ hostplant * transect + hostplant* hostrange + transect * hostrange, data = full_count_S)
anova(S_count2)

# drop hostplant*transect
S_count3 <- lm(count ~  hostplant* hostrange + transect * hostrange, data = full_count_S)
anova(S_count3)

# drop hostplant*hostrange
S_count4 <- lm(count ~ hostplant + transect * hostrange, data = full_count_S)
anova(S_count4)

# drop transect*hostrange
S_count5 <- lm(count ~ transect + hostplant + hostrange, data = full_count_S)
anova(S_count5)

# drop transect
S_count6 <- lm(count ~ hostrange + hostplant, data = full_count_S)
anova(S_count6)

# dorp hostplant
S_count7 <- lm(count ~ hostrange, data = full_count_S)
anova(S_count7)

# drop everything
S_count8 <- lm(count ~ 1, data = full_count_S)
anova(S_count8)



AIC(S_count1, S_count2, S_count3, S_count4, S_count5, S_count6, S_count7, S_count8)
BIC(S_count1, S_count2, S_count3, S_count4, S_count5, S_count6, S_count7, S_count8)
anova(S_count2, S_count1)
anova(S_count3, S_count2)
anova(S_count4, S_count3)
anova(S_count5, S_count4)
anova(S_count6, S_count5)
anova(S_count7, S_count6)
anova(S_count8, S_count7)

print(S_count7)

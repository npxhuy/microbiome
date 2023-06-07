setwd("/set/your/working/directory")
metadata <- read.table("all.pops.metadata.tsv",header=TRUE)

### Inverse Simpson Species
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

# This is the best fit model, look for more details
print(S_isi7)
anova(S_isi7)

# Shannon Family
shannon_S <- read_table("shannon_alpha.txt", 
                        col_names= c("sample_id", "shannon"), 
                        col_types = "cd")

full_shannon_S <- full_join(metadata, shannon_S)

### Initiall model
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

# AIC and BIC score
AIC(S_shan1, S_shan2, S_shan3, S_shan4, S_shan5, S_shan6, S_shan7, S_shan8)
BIC(S_shan1, S_shan2, S_shan3, S_shan4, S_shan5, S_shan6, S_shan7, S_shan8)

# Compare between model for F, df, p value
anova(S_shan2, S_shan1)
anova(S_shan3, S_shan2)
anova(S_shan4, S_shan3)
anova(S_shan5, S_shan4)
anova(S_shan6, S_shan5)
anova(S_shan7, S_shan6)
anova(S_shan8, S_shan7)

# This is the best fit model, look for more details
print(S_shan7)
anova(S_shan7)

###Richness Species
rich_S <- read_table("species_rich.txt", 
                     col_names= c("sample_id", "rich"), 
                     col_types = "cd")
full_rich_S <- full_join(metadata, rich_S)

# Initial model
S_rich1 <- lm(rich ~ hostplant * transect * hostrange, data = full_rich_S)
anova(S_rich1)

# drop 3way interaction
S_rich2 <- lm(rich ~ hostplant * transect + hostplant* hostrange + transect * hostrange, data = full_rich_S)
anova(S_rich2)

# drop hostplant*transect
S_rich3 <- lm(rich ~  hostplant* hostrange + transect * hostrange, data = full_rich_S)
anova(S_rich3)

# drop hostplant*hostrange
S_rich4 <- lm(rich ~ hostplant + transect * hostrange, data = full_rich_S)
anova(S_rich4)

# drop transect*hostrange
S_rich5 <- lm(rich ~ transect + hostplant + hostrange, data = full_rich_S)
anova(S_rich5)

# drop transect
S_rich6 <- lm(rich ~ hostrange + hostplant, data = full_rich_S)
anova(S_rich6)

# dorp hostplant
S_rich7 <- lm(rich ~ hostrange, data = full_rich_S)
anova(S_rich7)

# drop everything
S_rich8 <- lm(rich ~ 1, data = full_rich_S)
anova(S_rich8)

# AIC and BIC score
AIC(S_rich1, S_rich2, S_rich3, S_rich4, S_rich5, S_rich6, S_rich7, S_rich8)
BIC(S_rich1, S_rich2, S_rich3, S_rich4, S_rich5, S_rich6, S_rich7, S_rich8)

# Compare between model for F, df, p value
anova(S_rich2, S_rich1)
anova(S_rich3, S_rich2)
anova(S_rich4, S_rich3)
anova(S_rich5, S_rich4)
anova(S_rich6, S_rich5)
anova(S_rich7, S_rich6)
anova(S_rich8, S_rich7)

# This is the best fit model, look for more details
print(S_rich8)
anova(S_rich8)

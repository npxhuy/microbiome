# Set working directory
setwd("/Users/hy/Documents/GitHub") 

# Load library, you may have to install them first using install.package()
library(lme4)
library(tidyverse)
library(dyplr)

# Load required data
metadata <- read.table("all.pops.metadata.tsv",header=TRUE)
count <- read.table("species_count.txt",col.names = c("sample_id","richness"))
alpha1 <- read.table("shannon_alpha.txt", col.names = c("sample_id","shannon"))
alpha2 <- read.table("inverse_simpson_alpha.txt", col.names = c("sample_id","inverse_simpson"))

# Join with the metadata
count_join <- (count) %>%
  left_join(metadata, by = "sample_id")
alpha1_join <- (alpha1) %>%
  left_join(metadata, by = "sample_id")
alpha2_join <- (alpha2) %>%
  left_join(metadata, by = "sample_id")

# Plotting
richness <- ggplot(count_join, aes(x=pop,y=richness, color=hostplant, shape=hostrange)) +
  scale_color_manual(values = c("#5E548E", "#32936F"), name = "Hostplant")+
  geom_boxplot(outlier.shape = NA) + theme_bw() +
  xlab("Population") + ylab("Richness") +
  facet_grid(~transect, scales = "free") +
  theme(legend.position = "bottom") +
  geom_jitter(width = 0.1)

alpha1_plot <- ggplot(alpha1_join, aes(x=pop,y=shannon, color=hostplant, shape=hostrange)) +
  scale_color_manual(values = c("#5E548E", "#32936F"), name = "Hostplant")+
  geom_boxplot(outlier.shape = NA) + theme_bw() +
  xlab("Population") + ylab("Shannon Diveristy") +
  facet_grid(~transect, scales = "free") +
  theme(legend.position = "bottom") +
  geom_jitter(width = 0.1)

alpha2_plot <- ggplot(alpha2_join, aes(x=pop,y=inverse_simpson, color=hostplant)) +
  scale_color_manual(values = c("#5E548E", "#32936F"), name = "Hostplant")+
  geom_boxplot(outlier.shape = NA) + theme_bw() +
  facet_grid(~transect, scales = "free")+
  xlab("Population") + ylab("Inverse Simpson Diveristy") +
  theme(legend.position = "bottom") +
  geom_jitter(width = 0.1)

# Saving plot
ggsave(plot = richness, filename = "richness.pdf", height = 6, width = 7)
ggsave(plot = alpha1_plot, filename = "shannon_diversity.pdf", height = 6, width = 7)
ggsave(plot = alpha2_plot, filename = "inv_simp_diversity.pdf", height = 6, width = 7)


# Lm in population: no sig diff
lm1 <- lm(shannon~pop,alpha1_join)
summary(lm1)

# Lm in hostplant, sig diff
lm11 <- lm(shannon~hostplant,alpha1_join)
summary(lm11)

# Lm in transect, no sig diff
lm111 <- lm(shannon~hostrange,alpha1_join)
summary(lm111)

# Same as above for inverse simpson

lm2 <- lm(inverse_simpson~pop,alpha2_join)
summary(lm2)

lm22 <- lm(inverse_simpson~hostplant,alpha2_join)
summary(lm22)

lm222 <- lm(inverse_simpson~transect,alpha2_join)
summary(lm222)


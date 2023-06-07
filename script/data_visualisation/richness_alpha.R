# Set working directory
setwd("/Users/hy/Documents/GitHub/microbiome/data_analysis/raw_result/alpha/species") 
rm(list=ls())
# Load library, you may have to install them first using install.package()
library(lme4)
library(tidyverse)

# Load required data
metadata <- read.table("/Users/hy/Documents/GitHub/all.pops.metadata.tsv",header=TRUE)
count <- read.table("species_count.txt",col.names = c("sample_id","richness"))
alpha1 <- read.table("shannon_alpha_F.txt", col.names = c("sample_id","shannon"))
alpha2 <- read.table("inverse_simpson_alpha_F.txt", col.names = c("sample_id","inverse_simpson"))

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
  xlab("Population") + ylab("Shannon Diversity") +
  facet_grid(~transect, scales = "free") +
  theme(legend.position = "bottom") +
  geom_jitter(width = 0.1)

alpha2_plot <- ggplot(alpha2_join, aes(x=pop,y=inverse_simpson, color=hostplant, shape=hostrange)) +
  scale_color_manual(values = c("#5E548E", "#32936F"), name = "Hostplant")+
  geom_boxplot(outlier.shape = NA) + theme_bw() +
  xlab("Population") + ylab("Inverse Simpson Diversity") +
  facet_grid(~transect, scales = "free") +
  theme(legend.position = "bottom") +
  geom_jitter(width = 0.1)


# Saving plot richness
ggsave(plot = richness, filename = "richness.pdf", height = 3.5, width = 5.5)

# Combine alpha and save

combine <- ggarrange(alpha1_plot, alpha2_plot, ncol = 1,nrow = 2, common.legend = TRUE, labels = "AUTO", legend = "bottom")

ggsave(plot = combine, filename = "combine_alpha_F.pdf", height = 7, width = 5.5)



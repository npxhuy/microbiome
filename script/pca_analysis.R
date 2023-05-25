# Load packages
library(tidyverse)
library(dplyr)
library(tibble)
library(ggplot2)
library(DESeq2)
library(RColorBrewer)
library(ggpubr)

drm(list=ls())
# Input 1: metadata
metadata <- read.table("/Users/hy/Documents/GitHub/all.pops.metadata.tsv",header=TRUE)

# Input 2: bracken result

# Function 1: Merge data function
merge_data_funciton <- function(dir){
  setwd(dir)
  # Take the directory that contains the bracken files
  # Put the names of the files into a list
  files <- list.files(dir)
  # Manually handle the first file
  merge_data <- read.table(files[1], header=TRUE, sep='\t') # Read file
  name <- sub("\\..*", "", files[1]) # Change column name
  colnames(merge_data)[2] <- name
  
  # Set the first data frame as a variable for the loop
  # merge_data <- one
  for (i in 2:length(files)){ # Loop through the files
    temp_data <- read.table(files[i], header=TRUE, sep='\t') # Read the df
    colnames(temp_data)[2] <- sub("\\..*", "", files[i]) # Change column name
    merge_data <- merge(merge_data, temp_data, all.x = TRUE, all.y = TRUE) # Merge
  }
  return(merge_data)
}
merge_data <- merge_data_funciton("/Users/hy/Documents/GitHub/bracken")

# Function 2: Find rows of species that need to be removed
removed <- function(percentage, dat, thres) {
  to_be_removed <- c()
  for (i in 1:nrow(dat)) {
    if (sum(dat[i, ] <= thres) >= ((1-percentage) * ncol(dat))) { # Here we count the number of 0 instead of species, so have to 1 - percentage
      to_be_removed <- c(to_be_removed, i)
    }
  }
  return(to_be_removed)
}

#if (sum(dat[i, ] <= thres) >= ((percentage) * ncol(dat))) {

# Function 3: Remove the rows from data
clean_data <- function(vec,dat){
  if (length(vec)>0){
    for (i in 1:length(vec)){
      dat <- dat[-rev(vec)[i],]
    }
  }
  return(dat)
}

# Replace NA in ORIGINAL DATA with 0
raw_counts_matrix <- merge_data %>% 
  mutate(across(where(is.numeric), ~replace_na(.x, 0))) %>% # Replace NA with 0
  column_to_rownames("name") %>% #Change to first column (label as name) to the row name
  as.matrix()

# PCA 1: Original + log2
PCA1 <- log2(raw_counts_matrix +1)

# PCA 2: exclude columns with >50% 0s.

PCA2 <- log2(clean_data(vec = removed( percentage = 0.5, dat = raw_counts_matrix, thres = 0),
                        dat = raw_counts_matrix) + 1)

# PCA 3: exclude columns with more than 30%
PCA3 <- log2(clean_data(vec = removed( percentage = 0.3, dat = raw_counts_matrix, thres = 0),
                        dat = raw_counts_matrix) + 1)

# RUN PCA
PCA.scaled_log_counts <- prcomp(t(PCA3), scale. = F, center = T)

PCA.summary <- as.data.frame(t((summary(PCA.scaled_log_counts))$importance)) %>% 
  rownames_to_column(var = "Principal Component")

PCA.data.frame <- (as.data.frame(PCA.scaled_log_counts$x)) %>%
  rownames_to_column(var = "sample_id") %>% 
  left_join(metadata, by = "sample_id") 

first <- ggplot(PCA.data.frame, aes(x = PC1, y = PC2)) +
  #xlim(-70,60) + ylim(-70,25)+ #0%
  #xlim(-40,40) + ylim(-20,25)+ #50%
  xlim(-40,50) + ylim(-25,25) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_point(size = 2, stroke = 1.25, aes(shape = hostplant, color = pop))+
  geom_point(pch = 21,stroke = 0, size = 1, aes(fill = hostrange))+
  scale_color_manual(values = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#FFD300", "#A65628", "#F781BF"), name = "Populaiton")+
  scale_shape_manual(values = c(1,2), name = "Host Plant") +
  scale_fill_manual(values = c("Allopatric" = "white", "Sympatric" = "black"), name = "Host Range") +
  theme_minimal(base_size = 12) + theme(legend.position = "bottom") + 
  facet_grid(~transect)

second <- ggplot(PCA.data.frame, aes(x = PC2, y = PC3)) +
  #xlim(-70,60) + ylim(-70,25)+ #0%
  #xlim(-40,40) + ylim(-20,25)+ #50%
  xlim(-40,50) + ylim(-25,25) + #30%
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_point(size = 2, stroke = 1.25, aes(shape = hostplant, color = pop))+
  geom_point(pch = 21,stroke=0, size = 1, aes(fill = hostrange))+
  scale_color_manual(values = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#FFD300", "#A65628", "#F781BF"), name = "Populaiton")+
  scale_shape_manual(values = c(1,2), name = "Host Plant") +
  scale_fill_manual(values = c("Allopatric" = "white", "Sympatric" = "black"),name = "Host Range") +
  theme_minimal(base_size = 12) + theme(legend.position = "bottom") + 
  facet_grid(~transect)

ggarrange(first, second, ncol = 2, nrow = 1, common.legend = TRUE, legend = "bottom")


ggplot(PCA.summary[1:6,], 
                      aes( x= `Principal Component`, y = `Proportion of Variance`)) +
  geom_bar(stat = "identity") +
  labs(x = "Principal component", "Prop. of variance") +
  geom_label(stat = "identity", aes(label = round(`Proportion of Variance`, 3))) +
  theme_classic(base_size = 15)






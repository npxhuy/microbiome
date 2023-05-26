# Load packages
library(tidyverse)
library(dplyr)
library(tibble)
library(ggplot2)
library(DESeq2)

rm(list=ls())
# Take the directory that contains the bracken files
dir <- "/Users/hy/Documents/GitHub/bracken"

# Put the names of the files into a list
files <- list.files(dir)

metadata <- read.table("/Users/hy/Documents/GitHub/all.pops.metadata.tsv",header=TRUE)
# Manually handle the first file
one <- read.table(files[1], header=TRUE, sep='\t') # Read file
name <- sub("\\..*", "", files[1]) # Change column name
colnames(one)[2] <- name



###
merge_data <- one # Set the first data frame as a variable for the loop
for (i in 2:length(files)){ # Loop through the files
  temp_data <- read.table(files[i], header=TRUE, sep='\t') # Read the df
  colnames(temp_data)[2] <- sub("\\..*", "", files[i]) # Change column name
  merge_data <- merge(merge_data, temp_data, all.x = TRUE, all.y = TRUE) # Merge
}

raw_counts_matrix <- merge_data %>% 
  mutate(across(where(is.numeric))) %>%
  column_to_rownames("name") %>% 
  as.matrix() ### OKAY


raw_counts_matrix[is.na(raw_counts_matrix)] <- 0 ### OKAY
log_counts_matrix <- log2(raw_counts_matrix +1) ### OKAY


PCA.scaled_log_counts <- prcomp(t(log_counts_matrix), scale. = F, center = T) ### OKAY
### Add the t() to log count matrix


# Still not in the label i want
PCA.summary <- as.data.frame(t((summary(PCA.scaled_log_counts))$importance)) %>% 
  rownames_to_column(var = "Principal Component") ### OKAY



PCA.data.frame <- (as.data.frame(PCA.scaled_log_counts$x)) %>%
  rownames_to_column(var = "sample_id") %>% 
  left_join(metadata, by = "sample_id") ### OKAY


##
PCA.propVar <- ggplot(PCA.summary[1:6,], 
                      aes( x= `Principal Component`, y = `Proportion of Variance`)) +
  geom_bar(stat = "identity") +
  labs(x = "Principal component", "Prop. of variance") +
  geom_label(stat = "identity", aes(label = round(`Proportion of Variance`, 3))) +
  theme_classic(base_size = 15)


##
pca_plot <- list()
for (i in 2:5){
  PC_axes <- c(1,i)
  PC_columns <- c(paste0("PC",PC_axes[1]), paste0("PC",PC_axes[2]))
  PC_var <- c(paste0(PC_columns[1], " (", round(PCA.summary[PC_axes[1],3]*100, 1), "%)"), paste0(PC_columns[2], " (", round(PCA.summary[PC_axes[2],3]*100, 1), "%)"))
  
  pca_plot[[i-1]] <- ggplot(PCA.data.frame, aes(x = as.name(PC_columns[1]), y = as.name(PC_columns[2]))) +
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_hline(yintercept = 0, linetype = "dashed") +
    # geom_point(size = 2, stroke = 1.25)+
    geom_point(size = 2, stroke = 1.25, aes(color = hostplant, shape = transect))+
    scale_color_manual(values = c("#5E548E", "#32936F"), name = "Host Plant")+
    scale_shape_manual(values = c(1,2), name = "Transect") +
    labs(x = PC_var[1], y =PC_var[2]) +
    theme_minimal(base_size = 12) + theme(legend.position = "bottom")
  # ggsave(plot = pca.plot[[i-1]], paste0(prefix, "PCA.plot.",PC_columns[1], PC_columns[2],".pdf"), height = 5.5, width = 5)
}
pca_plot
####

ggplot(PCA.data.frame, aes(x = PC1, y = PC96)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  # geom_point(size = 2, stroke = 1.25)+
  geom_point(size = 2, stroke = 1.25, aes(color = hostplant, shape = transect))+
  scale_color_manual(values = c("#5E548E", "#32936F"), name = "Host Plant")+
  scale_shape_manual(values = c(1,2), name = "Transect") +
  labs(x = PC_var[1], y =PC_var[2]) +
  theme_minimal(base_size = 12) + theme(legend.position = "bottom")





####
clean_data <- function(vec,dat){
  for (i in 1:length(vec)){
    dat <- dat[,-rev(vec)[i]]
  }
  return(dat)
}




# Remove col funciton
removed <- function(number,dat){
  to_be_removed <- c()
  for (i in 1:ncol(dat)){
    if (sum(is.na(dat[,i]))>(number*nrow(dat))){
      to_be_removed <- c(to_be_removed,i)
    }
  }
  return((to_be_removed))
}
removed_vec <- removed(0.5,final)


# Shit stuff
copy1 <- merge_data # Make a copy to avoid writing over the original variable
copy1 <- copy1[,-1] # Remove the microbes name
rownames(copy1) <- merge_data[,1] # Make the microbes names as the columns name
final = t(copy1) # Transpose the df

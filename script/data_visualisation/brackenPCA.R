# 
library(dplyr)
library(tibble)
library(ggplot2)
library(DESeq2)

# instruct R to take information from the command line
args = commandArgs(trailingOnly=TRUE)

## test if there is at least one argument: if not, return an error
if (length(args)< 2) {
  stop("At least two arguments must be supplied: 1) tab-separated bracken raw count matrix (rows = samples, columns = taxa), 2) metadata file where sample IDs match count matrix. 3) Prefix (optional)", call.=FALSE)
} else if (length(args)<3) {
  # default output file
  args[3] = str_split_fixed(args[1], "\\.", n = 2)[1]
}


raw_counts <- read_table(args[1], col_names = T) 
metadata <- read_table(args[2], col_names = T)
prefix = args[3]

# if you want to run this in the Rstudio, you can read in your files directly
# raw_counts <- read_table("name_of_file")


## Run the pca
# you should use scaled, normalized data when running the pca
# all NAs are converted to 0. 
raw_counts_matrix <- bracken_est_reads %>% 
  mutate(across(where(is.numeric), ~replace_na(.x, 0))) %>%
  column_to_rownames("sample_id") %>% 
  as.matrix()

# Because we cannot take the log of 0, we add 1 read
# this is called a shifted log transformation

log_counts_matrix <- log2(raw_counts_matrix +1)
  
# calculate principal components
PCA.scaled_log_counts <- prcomp(log_counts_matrix, scale. = F, center = T)
PCA.summary <- as.data.frame(t((summary(PCA.scaled_log_counts))$importance)) %>% 
  rownames_to_column(var = "Principal Component")
# write_tsv(PCA.summary,paste0(prefix, "PCA.summary.tsv"))

# explore principal component axes
PCA.data.frame <- as.data.frame(PCA.scaled_log_counts$x) %>%
  rownames_to_column(var = "sample_id") %>% 
  left_join(metadata, by = "sample_id")
# write_tsv(PCA.data.frame,paste0(prefix, "PCA.samples.tsv"))

PCA.propVar <- ggplot(PCA.summary[1:6,], 
                      aes( x= `Principal Component`, y = `Proportion of Variance`)) +
  geom_bar(stat = "identity") +
  labs(x = "Principal component", "Prop. of variance") +
  geom_label(stat = "identity", aes(label = round(`Proportion of Variance`, 3))) +
  theme_classic(base_size = 15)
# ggsave(PCA.propVar, file =paste0(prefix, "PCA.plot.propVariance.pdf"), height = 4.5, width = 6)

pca_plot <- list()
for (i in 2:5){
  PC_axes <- c(1,i)
  PC_columns <- c(paste0("PC",PC_axes[1]), paste0("PC",PC_axes[2]))
  PC_var <- c(paste0(PC_columns[1], " (", round(PCA.summary[PC_axes[1],3]*100, 1), "%)"), paste0(PC_columns[2], " (", round(PCA.summary[PC_axes[2],3]*100, 1), "%)"))
  
  pca_plot[[i-1]] <- ggplot(PCA.data.frame, aes_(x = as.name(PC_columns[1]), y = as.name(PC_columns[2]))) +
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_hline(yintercept = 0, linetype = "dashed") +
    # geom_point(size = 2, stroke = 1.25)+
    geom_point(size = 2, stroke = 1.25, aes(color = hostplant, shape= transect))+
    scale_color_manual(values = c("#5E548E", "#32936F"), name = "Host Plant")+
    scale_shape_manual(values = c(1,2), name = "Transect") +
    labs(x = PC_var[1], y =PC_var[2]) +
    theme_minimal(base_size = 12) + theme(legend.position = "bottom")
  # ggsave(plot = pca.plot[[i-1]], paste0(prefix, "PCA.plot.",PC_columns[1], PC_columns[2],".pdf"), height = 5.5, width = 5)
}
pca_plot
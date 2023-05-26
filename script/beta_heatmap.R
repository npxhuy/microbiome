rm(list=ls())
# Set working directory
setwd("/Users/hy/Documents/GitHub")

# Load library, you may want to install them 
library(dplyr)
library(circlize)
library(ComplexHeatmap)

# Load data
data <- read.table("newbeta_F.txt")
metadata <- read.table("/Users/hy/Documents/GitHub/all.pops.metadata.tsv",header=TRUE)

# Prepare to construct matrix
metadata <- metadata %>%
  arrange(pop)

# Change label
metadata <- metadata %>%
  group_by(pop) %>%
  mutate(new_pop = paste0(pop, "_", sprintf("%02d", row_number()))) #%>% # Add a new column name "new_name" with value of pop and count number 

# Make new_data by merging the original data with the meta data
new_data <- merge(data, metadata, by.x = "V1", by.y = "sample_id", all.x = TRUE)
new_data <- merge(new_data, metadata, by.x = "V2", by.y = "sample_id", all.x = TRUE)

# Select the required columns in the desired order
new_data <- new_data[, c("new_pop.x", "new_pop.y", "V3")]

# Rename the columns
colnames(new_data) <- c("V1", "V2", "V3")

# Extract unique sample names
sample_names <- sort(unique(c(new_data$V1, new_data$V2)))

# Create an empty matrix
# Dimensions based on the length of the sample_names vector. 
# The matrix is initialized with zeros.
matrix_data <- matrix(0, nrow = length(sample_names), ncol = length(sample_names))

# Fill in the matrix with values from the third column
# The for loop iterates over each row of the data data frame:
for (i in 1:nrow(new_data)) { 
  # Finds the index of the V1 value in the sample_names vector and assigns it to row_index
  row_index <- match(new_data$V1[i], sample_names)
  # Finds the index of the V2 value in the sample_names vector and assigns it to col_index
  col_index <- match(new_data$V2[i], sample_names)
  # Assigns the value from the V3 column of data to the corresponding position in matrix_data.
  matrix_data[row_index, col_index] <- new_data$V3[i]
  # Set symmetrical value
  matrix_data[col_index, row_index] <- new_data$V3[i]  
}

# Transposes the matrix to a symmetrical matrix
matrix_data <- t(matrix_data)

# Set row and column names
rownames(matrix_data) <- sample_names
colnames(matrix_data) <- sample_names

# Transform to matrix
df <- as.data.frame(matrix_data)
df$row <- rownames(matrix_data)

# Reshape the data to long format
df_long <- reshape2::melt(df, id.vars = "row")

# Plot the heatmap using ggplot
norm_heat <- ggplot(df_long, aes(x = variable, y = row, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "#534b7e") +
  theme_minimal() + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  labs(fill = "Beta diversity") + xlab("") + ylab("")

# Clustering heatmap + dendogram
col_fun = colorRamp2(c(0, 0.8), c("white", "#534b7e"))
heat_dendo <- Heatmap(matrix_data,
        clustering_distance_rows = "euclidean",
        heatmap_legend_param = list(
          title = "Beta diveristy",
          labels = c(0,0.2,0.4,0.6,0.8)),
        col = col_fun,
        row_names_gp = gpar(fontsize = 8),
        column_names_gp = gpar(fontsize = 8))

# Save plot
ggsave(plot = norm_heat, filename = "norm_heat.pdf", height = 11, width = 12)

# heat_dendo was save differently because cant use ggsave, have not figured out why
pdf("heat_dendo.pdf",width = 12, height = 11)
draw(heat_dendo)
dev.off()

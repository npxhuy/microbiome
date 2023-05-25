rm(list=ls())
library(dplyr)
library(circlize)
library(ComplexHeatmap)
setwd("/Users/hy/Documents/GitHub")

data <- read.table("newbeta.txt")
metadata <- read.table("/Users/hy/Documents/GitHub/all.pops.metadata.tsv",header=TRUE)

metadata <- metadata %>%
  arrange(pop)

# Change label
metadata <- metadata %>%
  group_by(pop) %>%
  mutate(new_pop = paste0(pop, "_", sprintf("%02d", row_number()))) #%>% # Add a new column name "new_name" with value of pop and count number 


new_data <- merge(data, metadata, by.x = "V1", by.y = "sample_id", all.x = TRUE)
new_data <- merge(new_data, metadata, by.x = "V2", by.y = "sample_id", all.x = TRUE)

# Select the required columns in the desired order
new_data <- new_data[, c("new_pop.x", "new_pop.y", "V3")]

# Rename the columns
colnames(new_data) <- c("V1", "V2", "V3")

# Extract unique sample names
sample_names <- sort(unique(c(new_data$V1, new_data$V2)))

# Create an empty matrix
matrix_data <- matrix(0, nrow = length(sample_names), ncol = length(sample_names))

# Fill in the matrix with values from the third column
for (i in 1:nrow(new_data)) {
  row_index <- match(new_data$V1[i], sample_names)
  col_index <- match(new_data$V2[i], sample_names)
  matrix_data[row_index, col_index] <- new_data$V3[i]
  matrix_data[col_index, row_index] <- new_data$V3[i]  # Set symmetrical value
}

# Convert the matrix to a symmetrical matrix
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
ggplot(df_long, aes(x = variable, y = row, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "#534b7e") +
  theme_minimal() + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  labs(fill = "Beta diversity") + xlab("") + ylab("")

# Clustering heatmap + dendogram
col_fun = colorRamp2(c(0, 0.9), c("white", "#534b7e"))
Heatmap(matrix_data,
        clustering_distance_rows = "euclidean",
        col = col_fun,
        row_names_gp = gpar(fontsize = 8),
        column_names_gp = gpar(fontsize = 8))

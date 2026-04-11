#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(DESeq2)
})

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
  stop("Usage: Rscript deseq2.r <counts_file> <metadata_file>")
}

counts_file <- args[1]
metadata_file <- args[2]

# 1. Read featureCounts output
counts <- read.delim(counts_file, comment.char = "#", check.names = FALSE, stringsAsFactors = FALSE)

# 2. Read metadata and clean potential whitespace/formatting issues
meta <- read.csv(metadata_file, stringsAsFactors = FALSE, strip.white = TRUE)
meta$sample <- trimws(as.character(meta$sample))
meta$condition <- trimws(as.character(meta$condition))

# 3. Clean Sample Names in Count Matrix
# Converts "SRR19070250_trimmed.sorted.bam" -> "SRR19070250"
gene_ids <- counts$Geneid
annotation_cols <- c("Geneid", "Chr", "Start", "End", "Strand", "Length")
count_data <- counts[, !(colnames(counts) %in% annotation_cols), drop = FALSE]

clean_names <- gsub("[_\\.].*$", "", basename(colnames(count_data)))
colnames(count_data) <- clean_names
rownames(count_data) <- gene_ids

# 4. Align Metadata with Count Matrix
meta <- meta[meta$sample %in% colnames(count_data), ]
meta <- meta[match(colnames(count_data), meta$sample), , drop = FALSE]

if (any(is.na(meta$sample)) || length(unique(meta$condition)) < 2) {
  stop(paste("Metadata error. Found conditions:", paste(unique(meta$condition), collapse=", ")))
}

rownames(meta) <- meta$sample
meta$condition <- factor(meta$condition)
if ("Normal" %in% levels(meta$condition)) meta$condition <- relevel(meta$condition, ref = "Normal")

# 5. Run DESeq2
count_matrix <- as.matrix(count_data)
storage.mode(count_matrix) <- "integer"
keep <- rowSums(count_matrix) >= 10
count_matrix <- count_matrix[keep, , drop = FALSE]

dds <- DESeqDataSetFromMatrix(countData = count_matrix, colData = meta, design = ~ condition)
dds <- DESeq(dds)

# 6. Results
res <- results(dds)
if (all(c("NASH", "Normal") %in% levels(meta$condition))) {
  res <- results(dds, contrast = c("condition", "NASH", "Normal"))
}

res_df <- as.data.frame(res)
res_df$Geneid <- rownames(res_df)
write.csv(res_df[order(res_df$padj), ], file = "deseq2_results.csv", row.names = FALSE)

# 7. Visualizations with Fallback for Small Datasets
num_genes <- nrow(dds)
if (num_genes < 1000) {
  vsd <- varianceStabilizingTransformation(dds, blind = FALSE, fitType = "mean")
} else {
  vsd <- vst(dds, blind = FALSE)
}

pdf("pca_plot.pdf")
plotPCA(vsd, intgroup = "condition", ntop = min(500, num_genes))
dev.off()

pdf("ma_plot.pdf")
plotMA(res, main = "DESeq2 MA Plot", ylim = c(-5, 5))
dev.off()

# Save normalized counts
norm_df <- as.data.frame(counts(dds, normalized = TRUE))
norm_df$Geneid <- rownames(norm_df)
write.csv(norm_df, file = "normalized_counts.csv", row.names = FALSE)

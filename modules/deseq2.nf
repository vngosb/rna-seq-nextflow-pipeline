#!/usr/bin/env nextflow

process DESEQ2 {

    input:
    path script
    path counts
    path samplesheet


    output:
    path "deseq2_results.csv", emit: results
    path "normalized_counts.csv", emit: normalized_counts
    path "pca_plot.pdf", emit: pca_plot
    path "ma_plot.pdf", emit: ma_plot

    script:
    """
    Rscript ${script} ${counts} ${samplesheet}
    """
}
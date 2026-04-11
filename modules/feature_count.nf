#!/usr/bin/env nextflow

process FEATURE_COUNTS {

    container "quay.io/biocontainers/subread:2.0.6--he4a0461_2"

    input:
    path sorted_bam
    path gtf

    output:
    path 'counts.txt'

    script:
    """
    featureCounts -T 4 \
    -a ${gtf} \
    -o counts.txt \
    ${sorted_bam}
    """
}
#!/usr/bin/env nextflow

process SAMTOOLS {
    
    container 'community.wave.seqera.io/library/samtools:1.20--b5dfbd93de237464'

    input:
    path bam

    output:
    path "${bam.simpleName}.sorted.bam", emit: sorted_bam
    path "${bam.simpleName}.sorted.bam.bai", emit: bai 

    script:
    """
    samtools sort -@ 4 -o "${bam.simpleName}.sorted.bam" ${bam}
    samtools index "${bam.simpleName}.sorted.bam"
    """

}
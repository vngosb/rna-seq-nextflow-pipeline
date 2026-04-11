#!/usr/bin/env nextflow

process HISAT2_ALIGN {

    container "community.wave.seqera.io/library/hisat2_samtools:5e49f68a37dc010e"

    input:
    path accession
    path index_files

    output:
    path "${accession.simpleName}.bam", emit: bam
    path "${accession.simpleName}.hisat2.log", emit: log

    script:
    """
    hisat2 -x genome_index -U ${accession} \
        --new-summary --summary-file ${accession.simpleName}.hisat2.log | \
        samtools view -bS -o ${accession.simpleName}.bam
    """
}
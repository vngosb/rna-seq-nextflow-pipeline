#!/usr/bin/env nextflow

process SRA {

    input:
        val accession
    
    output:
        path "${accession}.fastq.gz", emit: gz

    script:
    """
        prefetch ${accession} 
        fasterq-dump ${accession}
        gzip -k ${accession}.fastq
    """

}
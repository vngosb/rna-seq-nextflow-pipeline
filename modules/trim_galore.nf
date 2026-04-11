#!/usr/bin/env nextflow

process TRIM_GALORE {

    container "community.wave.seqera.io/library/trim-galore:0.6.10--1bf8ca4e1967cd18"

    input:
    path accession

    output:
    path "${accession.simpleName}_trimmed.fq.gz", emit: trimmed_reads
    path "${accession}_trimming_report.txt", emit: trimming_reports
    path "${accession.simpleName}_trimmed_fastqc.{zip,html}", emit: fastqc_reports

    script:
    """
    trim_galore --fastqc ${accession}
    """
}
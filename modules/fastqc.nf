#!/usr/bin/env nextflow

process FASTQC {

    container "community.wave.seqera.io/library/trim-galore:0.6.10--1bf8ca4e1967cd18"

    input:
    path accession

    output:
    path "${accession.simpleName}_fastqc.zip", emit: zip
    path "${accession.simpleName}_fastqc.html", emit: html

    script:
    """
    fastqc ${accession}
    """
}
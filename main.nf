#!/usr/bin/env nextflow

// Module INCLUDE statements
include { SRA } from './modules/sra.nf'
include { FASTQC } from './modules/fastqc.nf'
include { TRIM_GALORE } from './modules/trim_galore.nf'
include { HISAT2_ALIGN } from './modules/hisat2_align.nf'
include { SAMTOOLS } from './modules/samtools.nf'
include { FEATURE_COUNTS } from './modules/feature_count.nf'
include { DESEQ2 } from './modules/deseq2.nf'


/*
 * Pipeline parameters
 */
params{
    // Primary input
    samplesheet: Path

    // Reference genome
    hisat2_index: Path
    // Reference genome annotation file (GTF)
    annotation_file: Path    
    // Deseq2 script in R
    deseq2_script: Path
}

workflow {

    main:
    // Create input channel
    read_ch = Channel
        .fromPath(params.samplesheet)
        .splitCsv(header: true)
        .map { row -> row.sample }
    index_ch = Channel.fromPath(params.hisat2_index).collect()

    // Retrieve fastq data from GEO
    SRA(read_ch)
    // Initial quality control
    FASTQC(SRA.out)
    // Adapter trimming and post-trimming QC
    TRIM_GALORE(SRA.out)
    // Alignment to a reference genome
    HISAT2_ALIGN(TRIM_GALORE.out.trimmed_reads, index_ch)
    // Sorting BAM files
    SAMTOOLS(HISAT2_ALIGN.out.bam)
    // featureCount sorted BAM
    FEATURE_COUNTS(SAMTOOLS.out.sorted_bam.collect(), params.annotation_file)
    // Run deseq2 analysis
    DESEQ2(params.deseq2_script, FEATURE_COUNTS.out, params.samplesheet)

    publish:
    gzip = SRA.out.gz
    fastqc_zip = FASTQC.out.zip
    fastqc_html = FASTQC.out.html
    trimmed_reads = TRIM_GALORE.out.trimmed_reads
    trimming_reports = TRIM_GALORE.out.trimming_reports
    trimming_fastqc = TRIM_GALORE.out.fastqc_reports
    bam = HISAT2_ALIGN.out.bam
    align_log = HISAT2_ALIGN.out.log
    sorted_bam = SAMTOOLS.out.sorted_bam
    bai = SAMTOOLS.out.bai
    counts = FEATURE_COUNTS.out
    deseq2_results = DESEQ2.out.results
    normalized_counts = DESEQ2.out.normalized_counts
    pca_plot = DESEQ2.out.pca_plot
    ma_plot = DESEQ2.out.ma_plot

}

output{
    gzip {
        path 'reads'
    }
    fastqc_zip {
        path 'fastqc'
    }
    fastqc_html {
        path 'fastqc'
    }
    trimmed_reads {
        path 'trimming'
    }
    trimming_reports {
        path 'trimming'
    }
    trimming_fastqc {
        path 'trimming'
    }  
    bam {
        path 'align'
    }
    align_log {
        path 'align'
    }
    sorted_bam{
        path 'sorted'
    }
    bai{
        path 'sorted'
    }
    counts{
        path 'feature_counts'
    }
    deseq2_results{
        path 'deseq2_analysis'
    }
    normalized_counts{
        path 'deseq2_analysis'
    }
    pca_plot{
        path 'deseq2_analysis'
    }
    ma_plot{
        path 'deseq2_analysis'
    }
}          

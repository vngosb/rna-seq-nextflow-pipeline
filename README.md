# RNA-seq Nextflow Pipeline for NASH vs Control Analysis

## Overview

This project implements an end-to-end RNA-seq analysis pipeline using Nextflow, starting from raw sequencing reads (FASTQ) through alignment, quantification, and differential expression analysis.

The pipeline analyzes exosomal microRNA (miRNA) expression profiles from patients with Non-Alcoholic Steatohepatitis (NASH) compared to healthy controls using publicly available sequencing data.

---

## Workflow

```text
FASTQ → FastQC → Trim Galore → HISAT2 → SAMtools → FeatureCounts → DESeq2 → Visualization
```

---

## Tools & Technologies

* Nextflow — workflow orchestration
* FastQC — quality control
* Trim Galore — adapter trimming
* HISAT2 — sequence alignment
* SAMtools — BAM sorting and indexing
* FeatureCounts — read quantification
* DESeq2 — differential expression analysis
* R — statistical computing and visualization
* Docker — reproducible execution environment

---

## Dataset

This analysis uses publicly available RNA-seq data from the Gene Expression Omnibus (GEO):

* **Accession:** GSE202167
* **Organism:** Homo sapiens
* **Study Title:** Exosomal microRNA expression profiles of NASH: normal vs. NASH

### Study Description

Non-alcoholic fatty liver disease (NAFLD) is a prevalent chronic liver condition affecting approximately 25% of the global population. Progression to non-alcoholic steatohepatitis (NASH) is a major contributor to liver-related morbidity and mortality.

This study investigates exosomal microRNA (miRNA) expression profiles derived from peripheral blood samples of:

* NASH patients
* Healthy controls

### Experimental Design

* Comparative RNA-seq analysis
* Sample groups:

  * NASH (n = 3)
  * Control (n = 3)
* Data type: small RNA sequencing (miRNA-focused)

### Relevance

Exosomal miRNAs are involved in:

* intercellular signaling
* disease progression
* biomarker discovery

This pipeline identifies candidate miRNAs that may serve as potential biomarkers for NASH.

> Note: This dataset represents small RNA sequencing; results reflect differential miRNA abundance rather than protein-coding gene expression.

---

## How to Run

```bash
nextflow run main.nf --input samplesheet.csv
```

---

## Project Structure

```bash
rna_seq_pipeline/
├── main.nf
├── nextflow.config
├── modules/
├── deseq2_analysis.R
├── samplesheet.csv
├── figures/
├── results/
└── README.md
```

---

## Data Acquisition

Raw sequencing data was downloaded from the Sequence Read Archive (SRA):

```bash
prefetch SRRXXXXX
fasterq-dump SRRXXXXX
gzip SRRXXXXX.fastq
```

Reference genome and annotation files were obtained from Ensembl.

---

## Results

### Principal Component Analysis (PCA)

* PC1 explains ~41% of variance
* PC2 explains ~19% of variance
* Clear clustering of NASH vs control samples

### MA Plot

* Displays log2 fold change vs mean expression
* Identifies differentially expressed miRNAs
* Majority of features centered near zero, with outliers representing strong differential expression

---

## Output Files

* `deseq2_results.csv` — differential expression results
* `normalized_counts.csv` — normalized expression matrix
* `pca_plot.pdf` — PCA visualization
* `ma_plot.pdf` — MA plot

---

## Key Findings

* Distinct expression profiles between NASH and control samples
* Differentially expressed miRNAs identified using DESeq2
* PCA confirms separation by biological condition
* Results suggest potential miRNA biomarkers associated with NASH

---

## Notes

* Raw sequencing data (FASTQ), BAM files, and reference genomes are not included due to size
* File paths and parameters are configurable through Nextflow
* Pipeline is designed for reproducibility and scalability


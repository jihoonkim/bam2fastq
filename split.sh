#!/bin/bash
export SM=$1
bedtools bamtofastq  -i  ${SM}.sort.bam \
   -fq  ${SM}.sort.pe1.fastq  -fq2 ${SM}.sort.pe2.fastq

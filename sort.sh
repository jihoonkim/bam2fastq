#!/bin/bash
export SM=$1
samtools sort -n ${SM}.bam -o ${SM}.sort.bam --output-fmt bam

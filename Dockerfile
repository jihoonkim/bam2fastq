#-----------------------------------------------------------------------------
#  Name: Dockerfile for bam2fastq
#  Author: Jihoon Kim
#  Modified date: 02/26/2016
#  Description: Builds a Docker image to convert a .bam file to two .fastq
#               files for pair-end read sequences
#
#  Usage: Provide ${MyLocalDirectory} and ${MySample} to invoke 'docker run'
#         sequentially as below.
# 
#     $ docker run   -v /${MyLocalDirectory}:/mnt/data \
#                    -w /mnt/data   -d \
#                       j5kim/bam2fastq:latest   \
#                       /opt/workflow/sort.sh  ${MySample}
#     
#     $ docker run   -v /${MyLocalDirectory}:/mnt/data \
#                    -w /mnt/data   -d \
#                       j5kim/bam2fastq:latest   \
#                       /opt/workflow/split.sh  ${MySample}   
#-----------------------------------------------------------------------------
FROM ubuntu:14.04

MAINTAINER Jihoon Kim "j5kim@ucsd.edu"

# Set environment varialbes for directories
ENV TARGET_DIR /opt
ENV WORKFLOW_DIR     /opt/workflow
ENV DATA_DIR   /mnt/data

# create a target directory for installing applications
RUN mkdir -p ${TARGET_DIR}

# create a target directory for installing workflow scripts
RUN mkdir -p {WORKFLOW_DIR}

# create a workspace directory to put input files and create output files
RUN mkdir -p ${DATA_DIR}

# Update ubuntu packages 
RUN apt-get update

# Install dependent ubuntu packages
RUN apt-get install -y  \
    build-essential \
    git \
    g++ \
    libncurses5-dev \
    libncursesw5-dev \
    make \
    python \
    software-properties-common \
    wget \
    zip \
    zlib1g-dev 

# Install bedtools2 
#   https://github.com/arq5x/bedtools2
WORKDIR ${TARGET_DIR}
RUN git clone https://github.com/arq5x/bedtools2.git
RUN cd bedtools2
RUN make
RUN make install
WORKDIR ${TARGET_DIR}

### Install htslib (for samtools)
WORKDIR ${TARGET_DIR}
RUN git clone https://github.com/samtools/htslib.git
RUN cd htslib
RUN make
RUN make install
WORKDIR ${TARGET_DIR}

### Install samtool
WORKDIR ${TARGET_DIR}
RUN git clone https://github.com/samtools/samtools.git
RUN cd samtools
RUN make
RUN make install
WORKDIR ${TARGET_DIR}

### Download workflow scripts 
WORKDIR ${WORKFLOW_DIR}
RUN wget https://raw.githubusercontent.com/jihoonkim/bam2fastq/master/sort.sh
RUN wget https://raw.githubusercontent.com/jihoonkim/bam2fastq/master/split.sh

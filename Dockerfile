#-----------------------------------------------------------------------------
#  Name: Dockerfile for bam2fastq
#  Author: Jihoon Kim
#  Modified date: 02/26/2016
#  Description: Builds a Docker image to convert a .bam file to two .fastq
#               files for pair-end read sequences
#
#  Usage: 
#     $ docker run   -v /MyLocalDirectory:/workspaceindocker \
#                    -w /workspaceindocker     \
#                    -d 
#                        j5kim/bam2fastq:latest   \
#                       /workspaceindocker/sort.sh  MySample 
#     
#     $ docker run   -v /MyLocalDirectory:/workspaceindocker \
#                    -w /workspaceindocker     \
#                    -d 
#                        j5kim/bam2fastq:latest   \
#                       /workspaceindocker/split.sh  MySample   
#-----------------------------------------------------------------------------
FROM ubuntu:14.04

MAINTAINER Jihoon Kim "j5kim@ucsd.edu"

# Set environment varialbes
ENV TDIR /opt
ENV WSDIR  /workspaceindocker

# create a target directory for installing applications
RUN mkdir -p ${TDIR}

# create a workspace directory for data analysis 
RUN mkdir -p ${WSDIR}

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
    zip \
    zlib1g-dev 

# Install bedtools2 
#   https://github.com/arq5x/bedtools2
WORKDIR ${TDIR}
RUN git clone https://github.com/arq5x/bedtools2.git
RUN cd bedtools2
RUN make
RUN make install
WORKDIR ${TDIR}

### Install htslib (for samtools)
WORKDIR ${TDIR}
RUN git clone https://github.com/samtools/htslib.git
RUN cd htslib
RUN make
RUN make install
WORKDIR ${TDIR}

### Install samtool
WORKDIR ${TDIR}
RUN git clone https://github.com/samtools/samtools.git
RUN cd samtools
RUN make
RUN make install
WORKDIR ${TDIR}

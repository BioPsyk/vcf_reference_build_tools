# Represents docker.io/library/gradle:jdk11-openj9 at 2021-01-14
FROM gradle@sha256:7e07e513b83e6a7790f0cb30820f4142b96ab7ceaac67865965b2127734c2c3d AS java_builder

RUN apt-get update --fix-missing

#---------------------------------------------------------------------------------
# Installing nextflow

ARG NEXTFLOW_REVISION="a96233af6fb505a1716a70408d46218f7d45dc96"

WORKDIR /vcf_reference_build_tools

RUN wget "https://github.com/nextflow-io/nextflow/archive/${NEXTFLOW_REVISION}.zip" \
  --quiet -O nextflow.zip && \
  unzip -q nextflow.zip && \
  mv "nextflow-${NEXTFLOW_REVISION}" "nextflow" && \
  rm nextflow.zip

WORKDIR /vcf_reference_build_tools/nextflow

RUN gradle --daemon && BUILD_PACK=1 gradle compile packAll

WORKDIR /vcf_reference_build_tools

#---------------------------------------------------------------------------------
# Installing htslib, samtools and bcftools

ARG HTSLIB_VERSION="1.9"
ARG BCFTOOLS_VERSION="1.9"
ARG SAMTOOLS_VERSION="1.3.1"

RUN apt-get update --fix-missing
RUN apt-get install -y autoconf automake make zlib1g-dev libbz2-dev \
  liblzma-dev libcurl4-gnutls-dev libssl-dev libncurses5-dev \
  cmake build-essential

WORKDIR /vcf_reference_build_tools

RUN wget https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 \
  --quiet -O htslib.tar.bz2 && \
  tar -xjvf htslib.tar.bz2 && \
  mv "htslib-${HTSLIB_VERSION}" "htslib"

WORKDIR /vcf_reference_build_tools/htslib
RUN make
RUN make install

WORKDIR /vcf_reference_build_tools

RUN wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 \
  --quiet -O samtools.tar.bz2 && \
  tar -vxjf samtools.tar.bz2 && \
  mv "samtools-${SAMTOOLS_VERSION}" "samtools"

WORKDIR /vcf_reference_build_tools/samtools
RUN make

WORKDIR /vcf_reference_build_tools

RUN wget https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 \
  --quiet -O bcftools.tar.bz2 && \
  tar -vxjf bcftools.tar.bz2 && \
  mv "bcftools-${BCFTOOLS_VERSION}" "bcftools"

WORKDIR /vcf_reference_build_tools/bcftools
RUN make

WORKDIR /vcf_reference_build_tools

#---------------------------------------------------------------------------------
# Creating runtime image with software built in builder image

# Represents docker.io/library/adoptopenjdk:11-jre-openj9 at 2021-01-14
FROM adoptopenjdk@sha256:477d0c53aca999692d2432e529af1f7abd715205fcfc36534ac9ff490f4da0e8

COPY --from=java_builder /vcf_reference_build_tools /vcf_reference_build_tools

WORKDIR /vcf_reference_build_tools

RUN mv /vcf_reference_build_tools/htslib/tabix /usr/bin/tabix
RUN mv /vcf_reference_build_tools/htslib/bgzip /usr/bin/bgzip
RUN mv /vcf_reference_build_tools/samtools/samtools /usr/bin/samtools
RUN mv /vcf_reference_build_tools/bcftools/bcftools /usr/bin/bcftools

RUN mv nextflow/build/releases/nextflow-21.12.1-edge-all /usr/bin/nextflow && \
  chmod +x /usr/bin/nextflow

RUN apt-get update --fix-missing && \
    apt-get install python3 python3-pip python gawk graphviz dos2unix pigz \
    libbz2-dev liblzma-dev vim -y

RUN useradd -rm -s /bin/bash -g users -u 1000 nextflow
RUN rm -rf /vcf_reference_build_tools/* && chown nextflow:users /vcf_reference_build_tools && chmod g+s /vcf_reference_build_tools

USER nextflow


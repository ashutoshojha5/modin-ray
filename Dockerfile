FROM ubuntu:18.04
RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3.6.9 \
    && conda update conda \
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes
ENV PATH /opt/conda/bin:$PATH
WORKDIR /root
RUN conda install -c conda-forge psutil setproctitle
RUN pip install modin "ray==0.8.7" boto3==1.4.8 rpyc==4.1.5
COPY worker head ./
RUN chmod +x worker head
ENTRYPOINT /bin/bash
CMD head.sh

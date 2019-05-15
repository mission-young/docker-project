FROM ubuntu

MAINTAINER <yfs> "yuanfangsee@pku.edu.cn"

RUN  echo "docker for scientific data analysis " \
    ##### Optional: update aliyun source list for China Users.
    # && sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && apt update \
    && apt upgrade \
    ##### multi-thread download tool---axel
    && apt install -y --fix-missing curl \
    && apt install -y --fix-missing axel \
    ##### required minimum dependences for cern-root
    && rootMinDeps='git dpkg-dev cmake g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev' \
    && apt install -y --fix-missing rootMinDeps \ 
    ##### clear apt cache file
    && apt purge -y --auto-remove $rootMinDeps \
    ##### optional dependences for cern-root
    # && rootOptDeps='libssl-dev libpcre3-dev xlibmesa-glu-dev libglew1.5-dev libftgl-dev libmysqlclient-dev libfftw3-dev libcfitsio-dev graphviz-dev libavahi-compat-libdnssd-dev libldap2-dev libxml2-dev libkrb5-dev libgsl0-dev' \
    # && apt install -y --fix-missing rootOptDeps \
    # && apt purge -y --auto-remove $rootOptDeps \
    ##### download cern-root prebuild package
    && axel -n 100 https://root.cern/download/root_v6.16.00.Linux-ubuntu18-x86_64-gcc7.3.tar.gz \
    ##### tar package and set cern-root environment
    && tar -zxvf root_v6.16.00.Linux-ubuntu18-x86_64-gcc7.3.tar.gz -C /opt/ \
    && echo "source /opt/root/bin/thisroot.sh" >> ~/.bashrc
    ##### python environment setup
    ### python2
    # && apt install python-dev python-pip \
    # && pip install metakernel jupyter \
    ### python3
    # && apt install python3-dev python3-pip \
    # && pip3 install metakernel jupyter \

    && sed -i 's/python2.7/python3.6/g' /opt/root/etc/notebook/kernels/root/kernel.json











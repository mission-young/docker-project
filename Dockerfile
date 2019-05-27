FROM ubuntu:18.04


LABEL author="yfs" \
    email="yuanfangsee@126.com" 

ENV DEBIAN_FRONTEND noninteractive
ENV jupypasswd dataana
RUN rm /bin/sh && ln -s /bin/bash /bin/sh 
RUN  echo "docker for scientific data analysis " \
    ##### Optional: update aliyun source list for China Users.
    && sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && apt-get update \
    && apt-get update -o Acquire::http::Pipeline-Depth=0 \
    && apt-get update -o Acquire::No-Cache=True  \
    && apt-get update -o Acquire::BrokenProxy=True \
    && apt-get -y upgrade \
    && apt install apt-utils -y \
    # # # ##### multi-thread download tool---axel
    && apt-get install -y wget \
    && apt-get install -y curl \
    && apt-get install -y axel \
    # # ##### required minimum dependences for cern-root
    && rootMinDeps='git dpkg cmake g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev libtiff5' \
    && apt-get install -y  ${rootMinDeps} \
    # ##### optional dependences for cern-root
    # # && rootOptDeps='libssl-dev libpcre3-dev xlibmesa-glu-dev libglew1.5-dev libftgl-dev libmysqlclient-dev libfftw3-dev libcfitsio-dev graphviz-dev libavahi-compat-libdnssd-dev libldap2-dev libxml2-dev libkrb5-dev libgsl0-dev' \
    # # && apt-get install -y --fix-missing rootOptDeps -o Acquire::http::proxy=false\
    # # && apt-get autoremove \
    #### download cern-root prebuild package
    && axel -n 100 https://root.cern/download/root_v6.16.00.Linux-ubuntu18-x86_64-gcc7.3.tar.gz \
    # ##### tar package and set cern-root environment
    && tar -zxvf root_v6.16.00.Linux-ubuntu18-x86_64-gcc7.3.tar.gz -C /opt/ \
    && echo "source /opt/root/bin/thisroot.sh" >> ~/.bashrc \
    && source /opt/root/bin/thisroot.sh \
    ##### python environment setup
    ### python2
    # && apt install python-dev python-pip \
    # && pip install metakernel jupyter \
    ### python3
    && echo "install python-deps" \
    && apt install python3-dev python3-pip -y \
    && pip3 install metakernel jupyter \
    && wget https://github.com/mission-young/docker-project/releases/download/v1/pyrootlink.tar.gz \
    && tar -xvf pyrootlink.tar.gz \
    && cd pyrootlink/ \
    && axel -n 100 https://raw.githubusercontent.com/mission-young/pyroot_link_to_binary/master/Makefile \
    && make -j4 \
    && rm -rf /opt/root/lib/libPyROOT* \
    && cp libPyROOT* /opt/root/lib/ \
    && sed -i 's/python2.7/python3.6/g' /opt/root/etc/notebook/kernels/root/kernel.json \
    ## set notebook password
    && mkdir /notebook \
    && jupyter-notebook --generate-config \
    && shapasswd=`echo -e "from notebook.auth import passwd \nprint(passwd(\"$jupypasswd\"))" | python3` \ 
    && sed -i "s/#c.NotebookApp.allow_remote_access = False/c.NotebookApp.allow_remote_access = True/g" ~/.jupyter/jupyter_notebook_config.py \
    && sed -i "s/#c.NotebookApp.allow_root = False/c.NotebookApp.allow_root = True/g" ~/.jupyter/jupyter_notebook_config.py \
    && sed -i "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '*'/g" ~/.jupyter/jupyter_notebook_config.py \
    && sed -i "s/#c.NotebookApp.notebook_dir = ''/c.NotebookApp.notebook_dir = '\/notebook'/g" ~/.jupyter/jupyter_notebook_config.py \
    && sed -i "s/#c.NotebookApp.open_browser = True/c.NotebookApp.open_browser = False/g" ~/.jupyter/jupyter_notebook_config.py \
    && sed -i "s/#c.NotebookApp.password = ''/c.NotebookApp.password = '$shapasswd'/g" ~/.jupyter/jupyter_notebook_config.py \
    && sed -i "s/#c.NotebookApp.port = 8888/c.NotebookApp.port = 8888/g" ~/.jupyter/jupyter_notebook_config.py \
    ## clean up
    && rm -rf /pyroot* \
    && rm -rf /root_v6* \
    && apt-get clean \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/cache/apt/archives \
    && rm -rf /var/cache/apt/archives/particle \
    && rm -rf /var/log/* \
    && rm -rf /tmp/*



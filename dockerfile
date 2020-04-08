FROM jupyter/minimal-notebook:dc9744740e12
LABEL MAINTAINER="Alaska Satellite Facility"

# By default, the notebook base image is set to non-sudo user joyvan. This makes root-ful actions difficult.
USER root

# Pip is ran under /opt/conda/lib/python3.6/site-packages/pip.
# Pip3 is ran under /usr/lib/python3.6/dist-packages.
# Pip2 is ran under /usr/lib/python2.7/dist-packages. Choose wisely.

# Manually update nbconvert. A dicrepancy in the versioning causes a 500 when opening a notebook. https://github.com/jupyter/notebook/issues/3629#issuecomment-399408222
# Remember, here pip is updating within the condas namespace where jupyter notebook items are held.
RUN pip install --upgrade nbconvert

# Downgrade tornado otherwise the notebook can't connect to the notebook server. https://github.com/jupyter/notebook/issues/2664#issuecomment-468954423
RUN pip install tornado==4.5.3

# ---------------------------------------------------------------------------------------------------------------
# Install general items. If a library is needed for a specific piece of software, put it with that software.
RUN apt update && \
    apt install --no-install-recommends -y software-properties-common && \
    add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable

RUN apt update && \
    apt install --no-install-recommends -y \
    python3 \
    python3-pip \
    python2.7 \
    python-pip \
    python2.7-setuptools \
    python3-setuptools \
    zip \
    wget \
    vim \
    rsync \
    less \
    snaphu

RUN pip install 'awscli' 'boto3>=1.4.4' 'pyyaml>=3.12' 'matplotlib' 'bokeh'


# ---------------------------------------------------------------------------------------------------------------
# Install MapReady
RUN apt update && \
    apt install --no-install-recommends -y \
    pkg-config \
    gcc \
    g++ \
    bison \
    flex \
    libcunit1-dev \
    libexif-dev \
    libfftw3-dev \
    libgdal-dev \
    libgeotiff-dev \
    libglade2-dev \
    libglib2.0-dev \
    libgsl-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    libpng-dev \
    libproj-dev \
    libproj12 \
    libshp-dev \
    libtiff5-dev \
    libxml2-dev \
    libhdf5-dev

ENV MAPREADY_HOME /usr/local/mapready/

COPY software/mapready-build/bin/* $MAPREADY_HOME/bin/
COPY software/mapready-build/doc/* $MAPREADY_HOME/doc/
COPY software/mapready-build/lib/* $MAPREADY_HOME/lib/
COPY software/mapready-build/man/* $MAPREADY_HOME/man/
COPY software/mapready-build/share/* $MAPREADY_HOME/share/

ENV PATH $PATH:$MAPREADY_HOME/bin/:$MAPREADY_HOME/lib/:$MAPREADY_HOME/share/

# ---------------------------------------------------------------------------------------------------------------
# Install ISCE.

RUN apt update && \
    apt install --no-install-recommends -y \
    gdal-bin \
    gfortran \
    libgfortran3 \
    libfftw3-dev \
    curl

RUN pip install 'numpy>=1.13.0' 'h5py' 'gdal==3.0.2' 'scipy'

ENV ISCE_HOME /usr/local/isce/isce
ENV PYTHONPATH $PYTHONPATH:/usr/local/isce/
ENV PATH $PATH:$ISCE_HOME/bin:$ISCE_HOME/applications

COPY software/isce $ISCE_HOME

# Add extra files to ISCE
COPY software/focus.py $ISCE_HOME/applications/
COPY software/topo.py $ISCE_HOME/applications/
COPY software/unpackFrame_ALOS_raw.py $ISCE_HOME/applications/

RUN chmod 755 $ISCE_HOME/applications/*


# ---------------------------------------------------------------------------------------------------------------
# Install SNAP 7.0
RUN apt update && \
    apt install --no-install-recommends -y \
    default-jdk-headless

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV PATH $PATH:/usr/lib/jvm/java-11-openjdk-amd64/bin

RUN mkdir -p /tmp/build/snap
COPY software/esa-snap_sentinel_unix_7_0.sh /tmp/build/snap/esa-snap_sentinel_unix_7_0.sh
COPY software/snap_install_7_0.varfile /tmp/build/snap/snap_install_7_0.varfile

# The build script will create a /usr/local/snap directory
RUN sh /tmp/build/snap/esa-snap_sentinel_unix_7_0.sh -q -varfile /tmp/build/snap/snap_install_7_0.varfile
COPY software/gpt.vmoptions /usr/local/snap/bin/gpt.vmoptions

RUN rm -rf /tmp/build/

# ---------------------------------------------------------------------------------------------------------------
# Install GIAnT (which only runs in python 2)
# Some of these might not be needed but the thing works.
RUN apt update && \
    apt install --no-install-recommends -y \
    build-essential \
    gfortran \
    zlibc \
    zlib1g-dev \
    libpng-dev \
    libopenjp2-7-dev \
    environment-modules \
    libopenblas-dev \
    libfreetype6-dev \
    pkg-config \
    cython \
    ipython \
    python-pip \
    python-numpy \
    python-scipy \
    python-numexpr \
    python-setuptools \
    python-distutils-extra \
    python-matplotlib \
    python-h5py \
    python-pyproj \
    python-mpltoolkits.basemap \
    python-lxml \
    python-requests \
    python-pyshp \
    python-shapely \
    python-pywt \
    python-simplejson \
    python-netcdf4 \
    python-pyresample

RUN pip2 install 'scipy==0.18.1' 'matplotlib==1.4.3' 'pykml' 'gdal==3.0.2'

COPY software/GIAnT/ /usr/local/GIAnT/
RUN cd /usr/local/GIAnT/ && python2.7 setup.py build_ext && cd /
ENV PYTHONPATH $PYTHONPATH:/usr/local/GIAnT:/usr/local/GIAnT/SCR:/usr/local/GIAnT/tsinsar:/usr/local/GIAnT/examples:/usr/local/GIAnT/geocode:/usr/local/GIAnT/solver

COPY software/prepdataxml.py /usr/local/GIAnT/prepdataxml.py


# ---------------------------------------------------------------------------------------------------------------
# Install hyp3-lib (which only runs in python2)
# Prereq for TRAIN
# Only copy what is needed. Other unused libs might have prerequisites which might bloat things
RUN pip2 install 'numpy' 'gdal==3.0.2' 'boto3' 'lxml' 'requests' 'Pillow'

COPY software/hyp3-lib /usr/local/hyp3-lib

ENV PYTHONPATH $PYTHONPATH:/usr/local/hyp3-lib/src


# ---------------------------------------------------------------------------------------------------------------
# Install TRAIN (which only runs in python2)
RUN pip2 install 'numpy' 'netCDF4' 'scipy==0.18.1' 'gdal==3.0.2'

COPY software/TRAIN/ /usr/local/TRAIN/
ENV PYTHONPATH $PYTHONPATH:/usr/local/TRAIN/src


# ---------------------------------------------------------------------------------------------------------------
# Install MintPy

ENV MINTPY_HOME=/usr/local/MintPy
ENV PYAPS_HOME=/usr/local/PyAPS
ENV PATH=${PATH}:${MINTPY_HOME}/mintpy:${MINTPY_HOME}/sh
ENV PYTHONPATH=${PYTHONPATH}:${MINTPY_HOME}:${PYAPS_HOME}
ENV PROJ_LIB=/usr/share/proj

# Pull and config mintpy and pyaps
COPY software/MintPy ${MINTPY_HOME}
COPY software/PyAPS ${PYAPS_HOME}/pyaps3

RUN pip install 'cdsapi' 'cvxopt' 'dask[complete]>=1.0,<2.0' 'dask-jobqueue>=0.3,<1.0' \
    'h5py' 'lxml' 'matplotlib' 'netcdf4' 'numpy' 'pyproj' 'pykdtree' \
    'pyresample' 'scikit-image' 'scipy' && \
    pip install https://github.com/matplotlib/basemap/archive/master.zip  && \
    pip install pykml -e git+https://github.com/yunjunz/pykml.git#egg=pykml

# ---------------------------------------------------------------------------------------------------------------
# Install any other custom and jupyter libaries like widgets
# Use pip (conda version) since we want to corner off GIAnT's work and also run it with Jupyter
RUN pip install nbgitpuller asf-hyp3 jupyter_contrib_nbextensions ipywidgets mpldatacursor nbserverproxy

# Activate git puller so users get the latest notebooks
# Enable jupyter widgets
# Install JavaScript and CSS for extensions
# Disable extension GUI in menu.
# Enable specific extensions
RUN jupyter serverextension enable --py nbgitpuller --sys-prefix && \
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter contrib nbextension install --system && \
    jupyter nbextensions_configurator disable --system && \
    jupyter nbextension enable hide_input/main && \
    jupyter nbextension enable freeze/main && \
    jupyter serverextension enable --py nbserverproxy

# Remove over 1 GB of latex files to save space
RUN apt remove -y texlive*
# Remove 'LaTeX' options and all custom exporters in download menu
RUN sed -i '/LaTeX/d' /opt/conda/lib/python3.7/site-packages/notebook/templates/notebook.html && \
    sed -i '/exporter\.display/d' /opt/conda/lib/python3.7/site-packages/notebook/templates/notebook.html

# Remove unneeded packages to free up a few hundred MB
# Remove apt list to save a little room (though it probably doesn't matter as much since the image is already really big)
# Make sure that any files in the home directory are jovyan permission
RUN rm -rf /var/lib/apt/lists/* && \
    apt autoremove -y && \
    chown -R jovyan:users /home/jovyan/

USER jovyan

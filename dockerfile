FROM jupyter/minimal-notebook:df4a9681f19c
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

RUN pip install 'awscli' 'boto3>=1.4.4' 'pyyaml>=3.12' 'pandas==0.23.0' 'bokeh' 'matplotlib' 'tensorflow==1.13.1' 'keras' 'plotly' 'rasterio' 'pyproj'


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

COPY software/mapready-build/bin/* /usr/local/bin/
COPY software/mapready-build/doc/* /usr/local/doc/
COPY software/mapready-build/lib/* /usr/local/lib/
COPY software/mapready-build/man/* /usr/local/man/
COPY software/mapready-build/share/* /usr/local/share/


# ---------------------------------------------------------------------------------------------------------------
# Install ISCE.

RUN apt update && \
    apt install --no-install-recommends -y \
    gdal-bin \
    gfortran \
    libgfortran3 \
    libfftw3-dev \
    curl

RUN pip install 'numpy>=1.13.0' 'h5py' 'gdal==2.4.0' 'scipy'

ENV ISCE_HOME /usr/local/isce
ENV PYTHONPATH $PYTHONPATH:/usr/local/
ENV PATH $PATH:$ISCE_HOME/bin:$ISCE_HOME/applications

COPY software/isce $ISCE_HOME

# Add extra files to ISCE
COPY software/focus.py $ISCE_HOME/applications/
COPY software/topo.py $ISCE_HOME/applications/
COPY software/unpackFrame_ALOS_raw.py $ISCE_HOME/applications/

RUN chmod 755 $ISCE_HOME/applications/*


# ---------------------------------------------------------------------------------------------------------------
# Install SNAP 7.0 and snappy
COPY software/esa-snap_sentinel_unix_7_0.sh /usr/local/etc/esa-snap_sentinel_unix_7_0.sh
COPY software/snap_install_7_0.varfile /usr/local/etc/snap_install_7_0.varfile
RUN sh /usr/local/etc/esa-snap_sentinel_unix_7_0.sh -q -varfile /usr/local/etc/snap_install_7_0.varfile
COPY software/gpt.vmoptions /usr/local/snap/bin/gpt.vmoptions
RUN rm /usr/local/etc/esa-snap_sentinel_unix_7_0.sh

#ENV PATH $PATH:/usr/local/snap/jre/bin
#ENV JAVA_HOME /usr/local/snap/jre

#RUN git clone https://github.com/bcdev/jpy.git /home/jovyan/jpy
#RUN python /home/jovyan/setup.py bdist_wheel
#RUN cp dist/*.whl "/home/jovyan/.snap/snap-python/snappy"

#RUN /usr/local/snap/bin/snappy-conf /opt/conda/bin/python ~/.snap/snap-python

# ---------------------------------------------------------------------------------------------------------------
# Install GIAnT (which only runs in python 2)
# Some of these might not be needed but the thing works.
RUN apt install -y build-essential \
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
    python-gdal \
    python-pyshp \
    python-shapely \
    python-pywt \
    python-simplejson \
    python-netcdf4 \
    python-pyresample

RUN pip2 install 'scipy==0.18.1' 'matplotlib==1.4.3' 'pykml'

COPY software/GIAnT/ /usr/local/GIAnT/
RUN cd /usr/local/GIAnT/ && python2.7 setup.py build_ext
ENV PYTHONPATH $PYTHONPATH:/usr/local/GIAnT:/usr/local/GIAnT/SCR:/usr/local/GIAnT/tsinsar:/usr/local/GIAnT/examples:/usr/local/GIAnT/geocode:/usr/local/GIAnT/solver

COPY software/prepdataxml.py /usr/local/GIAnT/prepdataxml.py


# ---------------------------------------------------------------------------------------------------------------
# Install hyp3-lib (which only runs in python2)
# Prereq for TRAIN
# Only copy what is needed. Other unused libs might have prerequisites which might bloat things
RUN pip2 install 'numpy' 'gdal==2.4.0' 'boto3' 'lxml' 'requests' 'Pillow'

COPY software/hyp3-lib /usr/local/hyp3-lib
COPY software/get_dem.py.cfg /usr/local/hyp3-lib/config/get_dem.py.cfg

ENV PYTHONPATH $PYTHONPATH:/usr/local/hyp3-lib/src


# ---------------------------------------------------------------------------------------------------------------
# Install TRAIN (which only runs in python2)
RUN pip2 install 'numpy' 'netCDF4' 'scipy==0.18.1' 'gdal==2.4.0'

COPY software/TRAIN/ /usr/local/TRAIN/
ENV PYTHONPATH $PYTHONPATH:/usr/local/TRAIN/src


# ---------------------------------------------------------------------------------------------------------------
# Install any other custom and jupyter libaries like widgets
# Use pip (conda version) since we want to corner off GIAnT's work and also run it with Jupyter
RUN pip install nbgitpuller asf-hyp3 jupyter_contrib_nbextensions ipywidgets mpldatacursor nbserverproxy

# Activate git puller so users get the latest notebooks
RUN jupyter serverextension enable --py nbgitpuller --sys-prefix

# Enable jupyter widgets
RUN jupyter nbextension enable --py widgetsnbextension

# Install JavaScript and CSS for extensions
RUN jupyter contrib nbextension install --system
# Disable extension GUI in menu.
RUN jupyter nbextensions_configurator disable --system
# Enable specific extensions
RUN jupyter nbextension enable hide_input/main
RUN jupyter nbextension enable freeze/main

# Install and enable bokeh extensions. THe nbserver is needed for the extensions to work properly due to Jupyter limitations.
RUN jupyter labextension install jupyterlab_bokeh
RUN jupyter serverextension enable --py nbserverproxy

# Remove apt list to save a little room (though it probably doesn't matter as much since the image is already really big)
RUN rm -rf /var/lib/apt/lists/*

USER jovyan

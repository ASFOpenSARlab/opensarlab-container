
FROM jupyter/minimal-notebook:dc9744740e12 as base 

USER root

##########################################

FROM base as general-stage

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
    snaphu \
    curl

RUN pip install 'awscli' 'boto3>=1.4.4' 'pyyaml>=3.12' 'matplotlib==3.1.3' 'bokeh'

##########################################

FROM base as mapready-stage 

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

COPY mapready-build/bin/* $MAPREADY_HOME/bin/
COPY mapready-build/doc/* $MAPREADY_HOME/doc/
COPY mapready-build/lib/* $MAPREADY_HOME/lib/
COPY mapready-build/man/* $MAPREADY_HOME/man/
COPY mapready-build/share/* $MAPREADY_HOME/share/

ENV PATH $PATH:$MAPREADY_HOME/bin/:$MAPREADY_HOME/lib/:$MAPREADY_HOME/share/

##########################################

FROM base as isce-stage

ENV ISCE_HOME /opt/isce2/isce/
ENV PYTHONPATH $PYTHONPATH:/opt/isce2
ENV PATH $PATH:$ISCE_HOME/bin:$ISCE_HOME/applications

RUN apt update -y
RUN apt install -y --no-install-recommends \
    gdal-bin \
    gfortran-4.8 \
    libfftw3-dev \
    libxm4 \
    libgdal-dev

RUN conda install gdal==3.0.2

#RUN ln -s /usr/lib/libgdal.so /usr/lib/libgdal.so.20
RUN ln -s /usr/lib/x86_64-linux-gnu/hdf5/serial/libhdf5.so /usr/lib/x86_64-linux-gnu/libhdf5.so.101
RUN ln -s /usr/lib/x86_64-linux-gnu/hdf5/serial/libhdf5.so /usr/lib/x86_64-linux-gnu/libhdf5.so.10

RUN pip install 'numpy' 'h5py' 'scipy'

COPY --from=isce-native:1.0 /opt/isce2/isce $ISCE_HOME

# Add extra files to ISCE
COPY topo.py $ISCE_HOME/applications/
COPY unpackFrame_ALOS_raw.py $ISCE_HOME/applications/
RUN chmod 755 $ISCE_HOME/applications/*

# So that users can temporarily add items to ISCE
RUN chown -R jovyan:root $ISCE_HOME

# Install after ISCE because of possible conflicts
#RUN apt install -y libgfortran3 gfortran

##########################################

FROM base as snap-stage

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

##########################################

FROM base as aria-stage 

ENV ARIA_TOOLS_HOME=/usr/local/ARIA-tools
ENV ARIA_TOOLS_DOCS_HOME=/usr/local/ARIA-tools-docs

# Tools
COPY software/ARIA-tools ${ARIA_TOOLS_HOME}
RUN pip install 'shapely' 'joblib' && \
    cd ${ARIA_TOOLS_HOME} && \
    python setup.py install && \
    cd /

# Docs
COPY software/ARIA-tools-docs ${ARIA_TOOLS_DOCS_HOME}

##########################################

FROM base as mintpy-stage

ENV MINTPY_HOME=/usr/local/MintPy
ENV PYAPS_HOME=/usr/local/PyAPS
ENV PATH=${PATH}:${MINTPY_HOME}/mintpy:${MINTPY_HOME}/sh
ENV PYTHONPATH=${PYTHONPATH}:${MINTPY_HOME}:${PYAPS_HOME}
ENV PROJ_LIB=/usr/share/proj

# Pull and config mintpy and pyaps
COPY software/MintPy ${MINTPY_HOME}
COPY software/PyAPS ${PYAPS_HOME}/pyaps3

RUN apt install -y cython3 proj-bin libgeos-3.6.2 libgeos-dev libproj-dev
RUN pip install 'cdsapi' 'cvxopt' 'dask[complete]>=1.0,<2.0' 'dask-jobqueue>=0.3,<1.0' cython \
    'h5py' 'lxml' 'matplotlib==3.1.3' 'netcdf4' 'numpy' 'pyproj' 'pykdtree' 'pyresample' 'scikit-image' 'scipy'
RUN pip install git+https://github.com/SciTools/cartopy.git --no-binary cartopy  # dev version
RUN pip install pykml -e git+https://github.com/yunjunz/pykml.git#egg=pykml

##########################################

FROM base as hyp3lib-stage

RUN apt update && \
    apt install -y gdal-bin

RUN pip install hyp3lib

##########################################

FROM base as train-stage 

# hyp3-lib
COPY --from=hyp3lib-stage / /

RUN pip install 'numpy' 'netCDF4' 'scipy>=0.18.1' 'gdal>=3.0.2'

COPY software/TRAIN/ /usr/local/TRAIN/
ENV PYTHONPATH $PYTHONPATH:/usr/local/TRAIN/src

##########################################

FROM base as giant-stage

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

##########################################

FROM base as finale-stage

# Install any other custom and jupyter libaries like widgets
# Use pip (conda version) since we want to corner off GIAnT's work and also run it with Jupyter
RUN pip install asf-hyp3
RUN conda install -c conda-forge jupyter_contrib_nbextensions -y

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

# Add sudo group user 599 elevation
RUN addgroup -gid 599 elevation \
    && echo '%elevation ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Add jupyter hooks
COPY jupyter-hooks /etc/jupyter-hooks
RUN chmod -R 755 /etc/jupyter-hooks && \
    chown -R jovyan:users /etc/jupyter-hooks

# So that users can temporarily install conda packages and avoid a special environment
RUN chown -R jovyan:root /opt/conda

USER jovyan

##########################################
##########################################

FROM isce-build as isce-test

# A few tests for largely possible debugging, make errors as warnings 
RUN python3.7 $ISCE_HOME/applications/topsApp.py --help ; exit 0
RUN python3.7 -c "import isce; print(isce.__version__)" ; exit 0
RUN python3.7 -c "from isce.applications import topsApp" ; exit 0

RUN gdalinfo --help

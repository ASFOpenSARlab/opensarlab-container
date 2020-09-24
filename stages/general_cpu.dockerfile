FROM jupyter/minimal-notebook:dc9744740e12 as general_cpu-stage

# Start
COPY --from=start:1.0 / /

# Isce
ENV ISCE_HOME /opt/isce2/isce/
ENV PYTHONPATH $PYTHONPATH:/opt/isce2
ENV PATH $PATH:$ISCE_HOME/bin:$ISCE_HOME/applications
COPY --from=isce:1.0 / / 

# Mapready
ENV MAPREADY_HOME /usr/local/mapready/
ENV PATH $PATH:$MAPREADY_HOME/bin/:$MAPREADY_HOME/lib/:$MAPREADY_HOME/share/
COPY --from=mapready:1.0 / /

# Snap
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV PATH $PATH:/usr/lib/jvm/java-11-openjdk-amd64/bin
COPY --from=snap:1.0 / /

# ARIA
ENV ARIA_TOOLS_HOME=/usr/local/ARIA-tools
ENV ARIA_TOOLS_DOCS_HOME=/usr/local/ARIA-tools-docs
COPY --from=aria:1.0 / /

# MintPy
ENV MINTPY_HOME=/usr/local/MintPy
ENV PYAPS_HOME=/usr/local/PyAPS
ENV PATH=${PATH}:${MINTPY_HOME}/mintpy:${MINTPY_HOME}/sh
ENV PYTHONPATH=${PYTHONPATH}:${MINTPY_HOME}:${PYAPS_HOME}
ENV PROJ_LIB=/usr/share/proj
COPY --from=mintpy:1.0 / /

# Train
ENV PYTHONPATH $PYTHONPATH:/usr/local/TRAIN/src
COPY --from=train:1.0 / /

# Giant 
ENV PYTHONPATH $PYTHONPATH:/usr/local/GIAnT:/usr/local/GIAnT/SCR:/usr/local/GIAnT/tsinsar:/usr/local/GIAnT/examples:/usr/local/GIAnT/geocode:/usr/local/GIAnT/solver
COPY --from=giant:1.0 / /

# Finale
COPY --from=finale:1.0 / /

##########################################

FROM general_cpu-stage as general_cpu-test 

# A few tests for largely possible debugging, make errors as warnings 
RUN python3.7 $ISCE_HOME/applications/topsApp.py --help ; exit 0
RUN python3.7 -c "import isce; print(isce.__version__)" ; exit 0
RUN python3.7 -c "from isce.applications import topsApp" ; exit 0

RUN gdalwarp --help ; exit 0

RUN asf_mapready --help ; exit 0
RUN asf_geocode --help ; exit 0

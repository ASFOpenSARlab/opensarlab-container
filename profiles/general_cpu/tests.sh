set -e

python --version 
python3.8 --version

# ISCE
python3.8 $ISCE_HOME/applications/topsApp.py --help && [ $? -gt 2 ] && true
python3.8 -c "import isce; print(isce.__version__)"
python3.8 -c "from isce.applications import topsApp"

# gdal
gdalwarp --version

# mapready
asf_mapready -version
asf_geocode -version

# MintPy
python3.8 -c "import numpy"
python3.8 -c "from mintpy import view, tsview, plot_network, plot_transection, plot_coherence_matrix"
smallbaselineApp.py --help

# ARIA
ariaDownload.py --help

# Train
python3.8 /usr/local/TRAIN/src/aps_weather_model.py -h

# snap
/usr/local/snap/bin/gpt -h

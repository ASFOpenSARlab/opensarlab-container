#!/usr/bin/env bash

source $(conda info --base)/etc/profile.d/conda.sh
conda activate isce

set -ex
# The idiom "&& [ $? -gt 2 ] && true" ignores warnings from the previous command

python3.8 $ISCE_HOME/applications/topsApp.py --help && [ $? -gt 2 ] && true
python3.8 -c "import isce; print(isce.__version__)"
python3.8 -c "from isce.applications import topsApp"

gdalinfo --help || exit 0

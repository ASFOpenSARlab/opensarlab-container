#!/usr/bin/env bash

set -ex
# The idiom "&& [ $? -gt 2 ] && true" ignores warnings from the previous command

python3.9 $ISCE_HOME/applications/topsApp.py --help && [ $? -gt 2 ] && true
python3.9 -c "import isce; print(isce.__version__)"
python3.9 -c "from isce.applications import topsApp"

gdalinfo --help || exit 0

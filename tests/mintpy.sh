#!/bin/bash

set -ex
# The idiom "&& [ $? -gt 2 ] && true" ignores warnings from the previous command

python3.8 -c "import numpy"
python3.8 -c "from mintpy import view, tsview, plot_network, plot_transection, plot_coherence_matrix"
smallbaselineApp.py --help

#!/bin/bash
set -e

pip install --user \
    ipywidgets \
    mpldatacursor \
    rise \
    hide_code \
    jupyter_nbextensions_configurator \
    pandoc==2.0a4 \
    pypandoc

# Add Path to local pip execs. 
export PATH=$HOME/.local/bin:$PATH

# Install and enable nbextensions
jupyter serverextension enable --py nbgitpuller
jupyter nbextensions_configurator enable --user
jupyter nbextension enable --py widgetsnbextension --user
jupyter-nbextension enable rise --py --user 
jupyter nbextension install --py hide_code --user
jupyter nbextension enable --py hide_code --user
jupyter serverextension enable --py hide_code --user

# Copy custom jupyter magic command, df (displays available disc space on volume)
mkdir -p $HOME/.ipython/image_default/startup/
cp /etc/jupyter-hooks/custom_magics/00-df.py $HOME/.ipython/image_default/startup/00-df.py

echo 'No git puller enabled.'
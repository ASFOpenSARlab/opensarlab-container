#!/bin/bash
set -e

python /etc/jupyter-hooks/resource_checks/check_storage.py $1

pip install --user \
    nbgitpuller \
    ipywidgets \
    mpldatacursor \
    rise \
    hide_code \
    jupyter_nbextensions_configurator 

# Add Path to local pip execs. 
export PATH=$HOME/.local/bin:$PATH

jupyter serverextension enable --py nbgitpuller
jupyter nbextensions_configurator enable --user
jupyter nbextension enable --py widgetsnbextension --user
jupyter-nbextension enable rise --py --user 
jupyter nbextension install --py hide_code --user
jupyter nbextension enable --py hide_code --user
jupyter serverextension enable --py hide_code --user

mkdir -p /home/jovyan/.ipython/profile_default/startup/
cp /etc/jupyter-hooks/custom_magics/00-df.py /home/jovyan/.ipython/profile_default/startup/00-df.py

gitpuller https://github.com/asfadmin/asf-jupyter-notebooks.git master /home/jovyan/notebooks

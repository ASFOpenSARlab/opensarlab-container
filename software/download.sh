#! /bin/bash
#
# `bash download.sh` will use *default* for the AWS profile
# `bash download.sh jupyterhub` will use the *jupyterhub* AWS profile
#
set -e

if [[ "$#" == 0 ]] ; then
   profile=default
elif [[ "$#" == 1 ]] ; then
   profile=$1
fi

echo "Using AWS profile '$profile'"


# Unzip all zips and tars so that we are only importing into the dockerfile plain files. This will make any future migration easier.

echo "Downloading GIAnT...."
if [ ! -d GIAnT ] ; then
    aws s3 sync --exclude '*' --include 'GIAnT.zip' s3://asf-jupyter-software/ . --profile=$profile
    unzip GIAnT.zip
fi

echo "Downloading MapReady..."
if [ ! -d ASF_MapReady ] ; then
    aws s3 sync --exclude '*' --include 'mapready-u18.zip' s3://asf-jupyter-software/ . --profile=$profile
    unzip mapready-u18.zip
fi

echo "Downloading isce...."
if [ ! -d isce ] ; then
    aws s3 sync --exclude '*' --include 'isce.zip' s3://asf-jupyter-software/ . --profile=$profile
    unzip isce.zip
fi

echo "Downloading TRAIN..."
if [ ! -d TRAIN ] ; then
    git clone -b test --single-branch https://github.com/asfadmin/hyp3-TRAIN.git TRAIN
fi

echo "Downloading hyp3-lib"
if [ ! -d hyp3-lib ] ; then
    git clone -b test --single-branch https://github.com/asfadmin/hyp3-lib.git
fi

echo "Downloading MintPy"
if [ ! -d MintPy ] ; then
    git clone -b master --single-branch https://github.com/insarlab/MintPy.git
fi

echo "Downloading PyAPS"
if [ ! -d PyAPS ] ; then
    git clone -b master --single-branch https://github.com/yunjunz/pyaps3.git PyAPS
fi

echo "Downloading snap..."
aws s3 sync --exclude '*' --include 'esa-snap_sentinel_unix_7_0.sh' s3://asf-jupyter-software/ . --profile=$profile

aws s3 sync --exclude '*' --include 'snap_install_7_0.varfile' s3://asf-jupyter-software/ . --profile=$profile

echo "Downloading other files...."
aws s3 sync --exclude '*' --include 'focus.py' s3://asf-jupyter-software/ . --profile=$profile

aws s3 sync --exclude '*' --include 'prepdataxml.py' s3://asf-jupyter-software/ . --profile=$profile

aws s3 sync --exclude '*' --include 'topo.py' s3://asf-jupyter-software/ . --profile=$profile

aws s3 sync --exclude '*' --include 'unpackFrame_ALOS_raw.py' s3://asf-jupyter-software/ . --profile=$profile

aws s3 sync --exclude '*' --include 'gpt.vmoptions' s3://asf-jupyter-software/ . --profile=$profile

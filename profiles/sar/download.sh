set -e

# ARIA
if [ ! -d ARIA-tools ] ; then
    git clone -b v1.1.1 --depth=1 --single-branch https://github.com/aria-tools/ARIA-tools.git ARIA-tools
fi
if [ ! -d ARIA-tools-docs ] ; then
    git clone -b master --depth=1 --single-branch https://github.com/aria-tools/ARIA-tools-docs.git ARIA-tools-docs
fi

# ISCE
if [ ! -f topo.py ] ; then 
    aws s3 sync --exclude '*' --include 'topo.py' s3://asf-jupyter-software/ . --profile=$AWS_PROFILE
fi

if [ ! -f unpackFrame_ALOS_raw.py ] ; then 
    aws s3 sync --exclude '*' --include 'unpackFrame_ALOS_raw.py' s3://asf-jupyter-software/ . --profile=$AWS_PROFILE
fi

# MAPREADY 
if [ ! -d mapready-build ] ; then
    aws s3 sync --exclude '*' --include 'mapready-u18.zip' s3://asf-jupyter-software/ . --profile=$AWS_PROFILE
    unzip mapready-u18.zip
    rm mapready-u18.zip 
fi

# MIMTPY
if [ ! -d MintPy ] ; then
    git clone -b v1.2.2 --depth=1 --single-branch https://github.com/insarlab/MintPy.git
fi
if [ ! -d PyAPS ] ; then
    git clone -b main --depth=1 --single-branch https://github.com/yunjunz/pyaps3.git PyAPS
fi

# TRAIN
if [ ! -d TRAIN ] ; then
    git clone -b OpenSARlab --depth=1 --single-branch https://github.com/asfadmin/hyp3-TRAIN.git TRAIN
fi

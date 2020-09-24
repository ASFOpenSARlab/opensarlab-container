
function GENERAL {
    VERSION=1.0

    # Build
    time docker build -f stages.dockerfile -t general:$VERSION --target general-stage .

    # Push image to registry
}

function MAPREADY {

    # Download 
    profile=jupyterhub
    if [ ! -d ASF_MapReady ] ; then
        aws s3 sync --exclude '*' --include 'mapready-u18.zip' s3://asf-jupyter-software/ . --profile=$profile
        unzip mapready-u18.zip
    fi

    # Build
    VERSION=1.0

    #time docker build -f stages.dockerfile -t mapready:test --target mapready-test .
    time docker build -f stages.dockerfile -t mapready:$VERSION --target mapready-stage .

    # Push image to registry
}

function ISCE {

    VERSION=1.0

    # Build
    time docker build -f stages.dockerfile -t isce:test --target isce-test .
    time docker build -f stages.dockerfile -t isce:$VERSION --target isce-stage .

    # Push image to registry

}

function SNAP {

    VERSION=1.0

    profile=jupyterhub
    if [ ! -f esa-snap_sentinel_unix_7_0.sh ] ; then
        aws s3 sync --exclude '*' --include 'esa-snap_sentinel_unix_7_0.sh' s3://asf-jupyter-software/ . --profile=$profile
    fi
    if [ ! -f snap_install_7_0.varfile ] ; then
        aws s3 sync --exclude '*' --include 'snap_install_7_0.varfile' s3://asf-jupyter-software/ . --profile=$profile
    fi
    if [ ! -f gpt.vmoptions ] ; then
        aws s3 sync --exclude '*' --include 'gpt.vmoptions' s3://asf-jupyter-software/ . --profile=$profile
    fi

    # Build
    time docker build -f stages.dockerfile -t snap:test --target snap-test .
    time docker build -f stages.dockerfile -t snap:$VERSION --target snap-stage .

    # Push image to registry
}

function ARIA {

echo "Downloading ARIA-Tools"
if [ ! -d ARIA-tools ] ; then
    git clone -b v1.1.1 --single-branch https://github.com/aria-tools/ARIA-tools.git ARIA-tools
fi

echo "Downloading ARIA-Docs"
if [ ! -d ARIA-tools-docs ] ; then
    git clone -b master --single-branch https://github.com/aria-tools/ARIA-tools-docs.git ARIA-tools-docs
fi

}

function MINTPY {

if [ ! -d MintPy ] ; then
    git clone -b v1.2.2 --single-branch https://github.com/insarlab/MintPy.git
fi

if [ ! -d PyAPS ] ; then
    git clone -b master --single-branch https://github.com/yunjunz/pyaps3.git PyAPS
fi

}

function TRAIN {

if [ ! -d TRAIN ] ; then
    git clone -b OpenSARlab --single-branch https://github.com/asfadmin/hyp3-TRAIN.git TRAIN
fi

}

function GIANT {

if [ ! -d GIAnT ] ; then
    aws s3 sync --exclude '*' --include 'GIAnT.zip' s3://asf-jupyter-software/ . --profile=$profile
    unzip GIAnT.zip
fi

aws s3 sync --exclude '*' --include 'prepdataxml.py' s3://asf-jupyter-software/ . --profile=$profile

}

function ISCE_NATIVE {

    set -e

    profile=jupyterhub
    echo "Using AWS profile '$profile'"

    # Download software
    echo "Downloading isce2...."
    if [ ! -d isce2 ] ; then
        git clone -b main --single-branch https://github.com/isce-framework/isce2.git isce2
    fi

    if [ ! -f topo.py ] ; then 
        aws s3 sync --exclude '*' --include 'topo.py' s3://asf-jupyter-software/ . --profile=$profile
    fi

    if [ ! -f unpackFrame_ALOS_raw.py ] ; then 
        aws s3 sync --exclude '*' --include 'unpackFrame_ALOS_raw.py' s3://asf-jupyter-software/ . --profile=$profile
    fi

    VERSION=1.0

    # Build ISCE
    time docker build -f isce2/docker/Dockerfile -t isce-native:$VERSION isce2/

    ## Push image to registry
    #docker push isce-builder:latest here

} 

$1


set -e

if [ ! -f topo.py ] ; then 
    aws s3 sync --exclude '*' --include 'topo.py' s3://asf-jupyter-software/ . --profile=$AWS_PROFILE
fi

if [ ! -f unpackFrame_ALOS_raw.py ] ; then 
    aws s3 sync --exclude '*' --include 'unpackFrame_ALOS_raw.py' s3://asf-jupyter-software/ . --profile=$AWS_PROFILE
fi

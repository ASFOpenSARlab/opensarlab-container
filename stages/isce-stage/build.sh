
if [ ! -f topo.py ] ; then 
    aws s3 sync --exclude '*' --include 'topo.py' s3://asf-jupyter-software/ . --profile=$PROFILE
fi

if [ ! -f unpackFrame_ALOS_raw.py ] ; then 
    aws s3 sync --exclude '*' --include 'unpackFrame_ALOS_raw.py' s3://asf-jupyter-software/ . --profile=$PROFILE
fi

# Build
time docker build -f dockerfile -t isce-stage:test --target isce-stage-test .
time docker build -f dockerfile -t isce-stage:$STAGE_VERSION --target isce-stage .

# Push image to registry

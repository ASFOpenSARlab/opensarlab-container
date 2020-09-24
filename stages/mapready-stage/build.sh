
terhub 

# Download 
if [ ! -d mapready-build ] ; then
    aws s3 sync --exclude '*' --include 'mapready-u18.zip' s3://asf-jupyter-software/ . --profile=$PROFILE
    unzip mapready-u18.zip
    rm mapready-u18.zip 
fi

time docker build -f dockerfile -t mapready-stage:test --target mapready-stage-test .
time docker build -f dockerfile -t mapready-stage:$STAGE_VERSION --target mapready-stage .

# Push image to registry

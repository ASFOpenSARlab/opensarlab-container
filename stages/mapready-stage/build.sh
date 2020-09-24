VERSION=1.0
profile=jupyterhub 

# Download 
if [ ! -d mapready-build ] ; then
    aws s3 sync --exclude '*' --include 'mapready-u18.zip' s3://asf-jupyter-software/ . --profile=$profile
    unzip mapready-u18.zip
    rm mapready-u18.zip 
fi

time docker build -f dockerfile -t mapready-stage:test --target mapready-stage-test .
time docker build -f dockerfile -t mapready-stage:$VERSION --target mapready-stage .

# Push image to registry


set -e 

# Download 
if [ ! -d mapready-build ] ; then
    aws s3 sync --exclude '*' --include 'mapready-u18.zip' s3://asf-jupyter-software/ . --profile=$AWS_PROFILE
    unzip mapready-u18.zip
    rm mapready-u18.zip 
fi

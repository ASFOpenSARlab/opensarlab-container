set -e

# MAPREADY 
if [ ! -d mapready-build ] ; then
    aws s3 sync --exclude '*' --include 'mapready-u18.zip' s3://osl-e-software/ . --profile=$AWS_PROFILE
    unzip mapready-u18.zip
    rm mapready-u18.zip 
fi

# TRAIN
if [ ! -d TRAIN ] ; then
    git clone -b OpenSARlab --depth=1 --single-branch https://github.com/asfadmin/hyp3-TRAIN.git TRAIN
fi


if [ ! -d isce2 ] ; then
    git clone -b main --single-branch https://github.com/isce-framework/isce2.git isce2
fi

# Build ISCE
time docker build -f isce2/docker/Dockerfile -t isce-native:$STAGE_VERSION isce2/

## Push image to registry
#docker push isce-builder:latest here
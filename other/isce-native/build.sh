
set -e 

set -a
. ../versions.env
set +a

if [ ! -d isce2 ] ; then
    git clone -b main --single-branch https://github.com/isce-framework/isce2.git isce2
fi

BUILD_TAG=$(date +"%F-%H-%M-%S")
time docker build -f isce2/docker/Dockerfile -t $DOCKER_REGISTRY/isce-native:$BUILD_TAG isce2/

## Push image to registry
docker push $DOCKER_REGISTRY/isce-native:$BUILD_TAG

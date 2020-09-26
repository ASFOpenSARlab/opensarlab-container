set -e

STAGE_NAME = $1

cd $STAGE_NAME-stage
[ -e download.sh ] && bash download.sh

BUILD_TAG=$(date +"%F-%H-%M-%S")

time docker build -f dockerfile -t $DOCKER_REGISTRY/$STAGE_NAME-stage:test --target $STAGE_NAME-stage-test .
docker build -f dockerfile -t $DOCKER_REGISTRY/$STAGE_NAME-stage:$BUILD_TAG --target $STAGE_NAME-stage .

# Push image to registry
docker push $DOCKER_REGISTRY/$STAGE_NAME-stage:$BUILD_TAG

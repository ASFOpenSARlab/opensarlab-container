set -ex

STAGE_NAME=$1

cd $STAGE_NAME-stage
[ -e download.sh ] && bash download.sh

cp dockerfile dockerfile.build
sed -i "s|base-stage:|$DOCKER_REGISTRY/base-stage:$STAGE_MATURITY|g" dockerfile.build

SED_STR="s|--from=(.*):|--from=$DOCKER_REGISTRY/\1:$STAGE_MATURITY|g"
sed -i -r $SED_STR dockerfile.build

BUILD_TAG=$(date +"%F-%H-%M-%S")

time docker build -f dockerfile.build -t $DOCKER_REGISTRY/$STAGE_NAME-stage:test --target $STAGE_NAME-stage-test .
docker build -f dockerfile.build -t $DOCKER_REGISTRY/$STAGE_NAME-stage:$BUILD_TAG -t $DOCKER_REGISTRY/$STAGE_NAME-stage:$STAGE_MATURITY --target $STAGE_NAME-stage .

# Push image to registry
docker push $DOCKER_REGISTRY/$STAGE_NAME-stage:$BUILD_TAG
docker push $DOCKER_REGISTRY/$STAGE_NAME-stage:$STAGE_MATURITY
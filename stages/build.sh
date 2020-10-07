set -e

STAGE_NAME=$1
BUILD_TAG=$(date +"%F-%H-%M-%S")

echo "Building '$DOCKER_REGISTRY/$STAGE_NAME' with tags '$BUILD_TAG' and '$STAGE_MATURITY' for location '$STAGE_LOCATION' "

cd $STAGE_NAME-stage
[ -e download.sh ] && bash download.sh

cp dockerfile dockerfile.build
sed -i "s|base-stage:|$DOCKER_REGISTRY/base-stage:$STAGE_MATURITY|g" dockerfile.build

SED_STR="s|--from=(.*):|--from=$DOCKER_REGISTRY/\1:$STAGE_MATURITY|g"
sed -i -r $SED_STR dockerfile.build

time docker build -f dockerfile.build --target $STAGE_NAME-stage-test .
time docker build -f dockerfile.build -t $DOCKER_REGISTRY/$STAGE_NAME-stage:$BUILD_TAG -t $DOCKER_REGISTRY/$STAGE_NAME-stage:$STAGE_MATURITY --target $STAGE_NAME-stage --no-cache .

# Push image to registry
if [ "$STAGE_LOCATION" != 'local' ]
then
    docker push $DOCKER_REGISTRY/$STAGE_NAME-stage:$BUILD_TAG
    docker push $DOCKER_REGISTRY/$STAGE_NAME-stage:$STAGE_MATURITY
fi

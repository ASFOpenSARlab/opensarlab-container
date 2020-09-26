
set -ex

cp dockerfile dockerfile.build
sed -i "s|base-stage:|$DOCKER_REGISTRY/base-stage:$STAGE_MATURITY|g" dockerfile.build
SED_STR="s|--from=(.*):|--from=$DOCKER_REGISTRY/\1:$STAGE_MATURITY|g"
sed -i -r $SED_STR dockerfile.build

BUILD_TAG=$(date +"%F-%H-%M-%S")

time docker build -f dockerfile.build -t $DOCKER_REGISTRY/general_cpu:test --target general_cpu-test .
docker build -f dockerfile.build -t $DOCKER_REGISTRY/general_cpu:$BUILD_TAG -t $DOCKER_REGISTRY/general_cpu:$STAGE_MATURITY --target general_cpu --squash .

# Push to registry
docker push $DOCKER_REGISTRY/general_cpu:$BUILD_TAG
docker push $DOCKER_REGISTRY/general_cpu:$STAGE_MATURITY

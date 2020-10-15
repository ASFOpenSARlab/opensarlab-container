
set -ex

cp dockerfile dockerfile.build
sed -i "s|base-stage:|$DOCKER_REGISTRY/base-stage:$PROFILE_MATURITY|g" dockerfile.build
SED_STR="s|--from=(.*):|--from=$DOCKER_REGISTRY/\1:$PROFILE_MATURITY|g"
sed -i -r $SED_STR dockerfile.build

BUILD_TAG=$(date +"%F-%H-%M-%S")

mkdir -p tests
cp -R ../../tests/* tests/

time docker build -f dockerfile.build --target testing .
time docker build -f dockerfile.build -t $DOCKER_REGISTRY/general_cpu:$BUILD_TAG -t $DOCKER_REGISTRY/general_cpu:$PROFILE_MATURITY --target release .

# Push to registry
docker push $DOCKER_REGISTRY/general_cpu:$BUILD_TAG
docker push $DOCKER_REGISTRY/general_cpu:$PROFILE_MATURITY

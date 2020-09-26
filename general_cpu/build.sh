
set -e

sed "s|DOCKER_REGISTRY|$DOCKER_REGISTRY|g" dockerfile > dockerfile.build

BUILD_TAG=$(date +"%F-%H-%M-%S")

time docker build -f dockerfile.build -t $DOCKER_REGISTRY/general_cpu:test --target general_cpu-test .
docker build -f dockerfile.build -t $DOCKER_REGISTRY/general_cpu:$BUILD_TAG --target general_cpu .

# Push to registry
docker push $DOCKER_REGISTRY/general_cpu:$BUILD_TAG

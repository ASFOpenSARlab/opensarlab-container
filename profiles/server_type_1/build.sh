
set -ex

if [ "$STAGE_FORCE_BUILD" = 'true' ]; then

    cp dockerfile dockerfile.build

    BUILD_TAG=$(date +"%F-%H-%M-%S")

    time docker build -f dockerfile.build --target testing .
    time docker build -f dockerfile.build -t $DOCKER_REGISTRY/server_type_1:$BUILD_TAG -t $DOCKER_REGISTRY/server_type_1:$PROFILE_MATURITY --target release .

    # Push to registry
    docker push $DOCKER_REGISTRY/server_type_1:$BUILD_TAG
    docker push $DOCKER_REGISTRY/server_type_1:$PROFILE_MATURITY

fi
